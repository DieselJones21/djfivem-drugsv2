Server.bulkJobs = Server.bulkJobs or {}
Server.bulkCooldown = Server.bulkCooldown or {}
Server.bulkLastLocation = Server.bulkLastLocation or {}
Server.bulkPending = Server.bulkPending or {}

local function newToken()
    return ('%s_%s_%s'):format(os.time(), math.random(1000, 9999), math.random(10000, 99999))
end

local function cfg()
    return Config.BulkSell or {}
end

local function findLocation(id)
    local list = cfg().locations or {}
    for i = 1, #list do
        if list[i].id == id then
            return list[i]
        end
    end
end

local function cooldownKey(src)
    local char = Bridge.GetCharacter(src)
    if char and char.citizenid then
        return char.citizenid
    end
    return 'src:' .. tostring(src)
end

local function remainingCooldown(src)
    local untilTs = Server.bulkCooldown[cooldownKey(src)]
    if not untilTs then return 0 end
    return math.max(0, untilTs - os.time())
end

local function setCooldown(src, seconds)
    Server.bulkCooldown[cooldownKey(src)] = os.time() + math.max(1, seconds or 0)
end

local function jobPayload(job)
    if not job then return nil end
    return {
        token = job.token,
        drugId = job.drugId,
        item = job.item,
        label = job.label,
        quantity = job.quantity,
        priceEach = job.priceEach,
        total = job.total,
        locationId = job.locationId,
        locationLabel = job.locationLabel,
        coords = { x = job.coords.x, y = job.coords.y, z = job.coords.z },
        remaining = math.max(0, job.expires - os.time()),
        expires = job.expires,
        moneyType = job.moneyType,
        laced = job.laced == true,
        laceNeed = job.laceNeed or 0,
        laceLabel = job.laceLabel,
    }
end

local function eligibleStock(src)
    local bulk = cfg()
    local minQty = bulk.minQty or 100
    local stock = {}
    for drugId, drug in pairs(Config.Drugs) do
        if drug.sell and drug.sell.enabled ~= false then
            local count = Server.ItemCount(src, drug.item)
            if count >= minQty then
                stock[#stock + 1] = {
                    id = drugId,
                    drug = drug,
                    count = count,
                }
            end
        end
    end
    return stock
end

local function pickLocation(src)
    local list = cfg().locations or {}
    if #list == 0 then return nil end
    local last = Server.bulkLastLocation[src]
    local pool = {}
    for i = 1, #list do
        if list[i].id ~= last then
            pool[#pool + 1] = list[i]
        end
    end
    if #pool == 0 then
        pool = list
    end
    return pool[math.random(1, #pool)]
end

local function clearJob(src)
    Server.bulkJobs[src] = nil
    Server.bulkPending[src] = nil
end

lib.callback.register('djdrugsv2:server:startBulk', function(source)
    local bulk = cfg()
    if bulk.enabled == false then
        return false, 'Bulk drops are disabled'
    end

    Server.trapActive = Server.trapActive or {}
    if Server.trapActive[source] then
        return false, 'Stop trapping before taking a bulk order'
    end

    if Server.bulkJobs[source] then
        return false, 'You already have a bulk drop', jobPayload(Server.bulkJobs[source])
    end

    local wait = remainingCooldown(source)
    if wait > 0 then
        return false, ('Wait %ss before another bulk order'):format(wait)
    end

    local stock = eligibleStock(source)
    if #stock == 0 then
        return false, ('You need at least %s finished product for a bulk order'):format(bulk.minQty or 100)
    end

    local pick = stock[math.random(1, #stock)]
    local minQty = bulk.minQty or 100
    local maxQty = math.min(bulk.maxQty or 200, pick.count)
    if maxQty < minQty then
        return false, ('You need at least %s finished product for a bulk order'):format(minQty)
    end

    local location = pickLocation(source)
    if not location or not location.coords then
        return false, 'No drop locations configured'
    end

    local quantity = math.random(minQty, maxQty)
    local rankMult = 1
    if bulk.rankApplies ~= false then
        rankMult = Progress.GetPayoutMultiplier(source)
    end
    local priceEach = Utils.GetBulkPriceEach(pick.drug, rankMult)
    local lace = Config.Lace or {}
    local laceItem = lace.item or 'street_lace'
    local laceNeed = Utils.GetLaceNeed(quantity)
    local laced = lace.applyToBulk ~= false and Server.ItemCount(source, laceItem) >= laceNeed
    if laced then
        local lacedEach = Utils.ApplyLacePrice(priceEach, true)
        local streetMin = pick.drug.sell.minPrice or 0
        if streetMin > 0 and lacedEach >= streetMin then
            lacedEach = math.max(1, streetMin - 1)
        end
        priceEach = lacedEach
    end
    local moneyType = pick.drug.sell.moneyType
        or (pick.drug.sell.clean == true and (Config.MoneyType or 'cash'))
        or (Config.DirtyMoneyType or 'black_money')
    local timeout = bulk.jobTimeout or (20 * 60)

    local job = {
        token = newToken(),
        drugId = pick.id,
        item = pick.drug.item,
        label = pick.drug.label,
        quantity = quantity,
        priceEach = priceEach,
        total = priceEach * quantity,
        moneyType = moneyType,
        locationId = location.id,
        locationLabel = location.label,
        coords = location.coords,
        expires = os.time() + timeout,
        rankMultiplier = rankMult,
        laced = laced,
        laceNeed = laced and laceNeed or 0,
        laceItem = laced and laceItem or nil,
        laceLabel = laced and (lace.label or 'Street Lace') or nil,
    }

    Server.bulkJobs[source] = job
    Server.bulkLastLocation[source] = location.id
    return true, jobPayload(job)
end)

lib.callback.register('djdrugsv2:server:getBulkJob', function(source)
    local job = Server.bulkJobs[source]
    if not job then return nil end
    if job.expires < os.time() then
        clearJob(source)
        return nil
    end
    return jobPayload(job)
end)

lib.callback.register('djdrugsv2:server:cancelBulk', function(source)
    local job = Server.bulkJobs[source]
    if not job then
        return false, 'No bulk order to cancel'
    end
    clearJob(source)
    setCooldown(source, cfg().cancelCooldown or 240)
    return true, 'Bulk order cancelled'
end)

lib.callback.register('djdrugsv2:server:bulkDeliverStart', function(source, token)
    local job = Server.bulkJobs[source]
    if not job or job.token ~= token then
        return false, 'Bulk order expired'
    end
    if job.expires < os.time() then
        clearJob(source)
        return false, 'Bulk order expired'
    end
    if job.locked then
        return false, 'Delivery already in progress'
    end
    if not Server.IsNearCoords(source, job.coords, 4.0) then
        return false, 'Too far from the drop'
    end
    if Server.ItemCount(source, job.item) < job.quantity then
        return false, ('You need %sx %s'):format(job.quantity, job.label)
    end

    job.locked = true
    local duration = math.max(4000, tonumber(cfg().deliverDuration) or 12000)
    Server.bulkPending[source] = {
        token = token,
        started = GetGameTimer(),
        duration = duration,
    }
    return true, duration
end)

lib.callback.register('djdrugsv2:server:bulkDeliverCancel', function(source, token)
    local job = Server.bulkJobs[source]
    if job and job.token == token then
        job.locked = false
    end
    Server.bulkPending[source] = nil
    return true
end)

lib.callback.register('djdrugsv2:server:completeBulk', function(source, token)
    local job = Server.bulkJobs[source]
    if not job or job.token ~= token then
        return false, 'Bulk order expired'
    end
    if job.expires < os.time() then
        clearJob(source)
        return false, 'Bulk order expired'
    end

    local pending = Server.bulkPending[source]
    if not pending or pending.token ~= token then
        job.locked = false
        return false, 'Walk up and deliver at the drop'
    end

    local elapsed = GetGameTimer() - (pending.started or 0)
    local need = math.floor((pending.duration or 12000) * 0.8)
    if elapsed < need then
        return false, 'Too fast'
    end

    if not Server.IsNearCoords(source, job.coords, 4.0) then
        job.locked = false
        Server.bulkPending[source] = nil
        return false, 'Too far from the drop'
    end

    local loc = findLocation(job.locationId)
    if not loc then
        clearJob(source)
        return false, 'Drop location is invalid'
    end

    local qty = tonumber(job.quantity) or 0
    local minQty = cfg().minQty or 100
    local maxQty = cfg().maxQty or 200
    if qty < minQty or qty > maxQty then
        clearJob(source)
        return false, 'Invalid order size'
    end

    if Server.ItemCount(source, job.item) < qty then
        job.locked = false
        Server.bulkPending[source] = nil
        return false, ('You need %sx %s'):format(qty, job.label)
    end

    local expected = Utils.GetBulkPriceEach(Utils.GetDrug(job.drugId), job.rankMultiplier or 1) * qty
    if job.total ~= expected then
        -- Recompute from frozen priceEach so a config hot-reload cannot inflate payout.
        job.total = job.priceEach * qty
    end
    if job.total <= 0 or job.priceEach <= 0 then
        clearJob(source)
        return false, 'Invalid payout'
    end

    local streetMin = (Utils.GetDrug(job.drugId) and Utils.GetDrug(job.drugId).sell and Utils.GetDrug(job.drugId).sell.minPrice) or 0
    if streetMin > 0 and job.priceEach >= streetMin then
        clearJob(source)
        return false, 'Invalid payout'
    end

    if not Server.CanAddPayout(source, job.moneyType, job.total) then
        job.locked = false
        Server.bulkPending[source] = nil
        return false, 'Payment failed'
    end

    if not Server.RemoveItem(source, job.item, qty) then
        job.locked = false
        Server.bulkPending[source] = nil
        return false, 'Could not remove product'
    end

    if job.laced then
        local laceItem = job.laceItem or (Config.Lace and Config.Lace.item) or 'street_lace'
        local laceNeed = job.laceNeed or Utils.GetLaceNeed(qty)
        if Server.ItemCount(source, laceItem) < laceNeed or not Server.RemoveItem(source, laceItem, laceNeed) then
            Server.AddItem(source, job.item, qty)
            job.locked = false
            Server.bulkPending[source] = nil
            return false, 'Missing Street Lace for this drop'
        end
    end

    if not Server.AddMoney(source, job.total, job.moneyType) then
        Server.AddItem(source, job.item, qty)
        if job.laced then
            local laceItem = job.laceItem or (Config.Lace and Config.Lace.item) or 'street_lace'
            Server.AddItem(source, laceItem, job.laceNeed or Utils.GetLaceNeed(qty))
        end
        job.locked = false
        Server.bulkPending[source] = nil
        return false, 'Payment failed'
    end

    local payload = {
        label = job.label,
        item = job.item,
        quantity = qty,
        total = job.total,
        priceEach = job.priceEach,
        locationLabel = job.locationLabel,
        moneyType = job.moneyType,
    }

    clearJob(source)
    setCooldown(source, cfg().cooldown or 480)

    local leveled, rank = Progress.RecordSale(source, qty, payload.total)
    if leveled and rank then
        Server.Notify(source, ('Rank up — %s (Level %s)'):format(rank.label, rank.level), 'success')
    end

    local chance = cfg().dispatchChance or 0
    local dispatch = Config.Dispatch or {}
    if dispatch.enabled ~= false and chance > 0 and math.random(1, 100) <= chance then
        TriggerClientEvent('djdrugsv2:client:badSell', source, {
            label = payload.label,
            item = payload.item,
            quantity = payload.quantity,
        })
    end

    local dirty = payload.moneyType and payload.moneyType ~= (Config.MoneyType or 'cash')
    local laceNote = job.laced and ' (laced)' or ''
    return true, ('Dropped %sx %s for $%s ($%s each)%s%s — bulk rate'):format(
        payload.quantity,
        payload.label,
        payload.total,
        payload.priceEach,
        dirty and ' (dirty)' or '',
        laceNote
    )
end)
