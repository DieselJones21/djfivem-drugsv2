Informant = {}

local KVP_KEY = 'djdrugsv2_intel'

local function cfg()
    return Config.Informant or {}
end

local function loadRow(citizenid)
    local raw = GetResourceKvpString(KVP_KEY .. ':' .. citizenid)
    if not raw or raw == '' then
        return { revealed = {}, tourDone = false, cooldownUntil = 0 }
    end
    local ok, data = pcall(json.decode, raw)
    if not ok or type(data) ~= 'table' then
        return { revealed = {}, tourDone = false, cooldownUntil = 0 }
    end
    data.revealed = data.revealed or {}
    data.tourDone = data.tourDone == true
    data.cooldownUntil = tonumber(data.cooldownUntil) or 0
    return data
end

local function saveRow(citizenid, row)
    SetResourceKvp(KVP_KEY .. ':' .. citizenid, json.encode(row))
end

local function catalog()
    local list = {}
    for i = 1, #Config.Harvest do
        local spot = Config.Harvest[i]
        list[#list + 1] = {
            id = 'harvest:' .. spot.id,
            kind = 'harvest',
            item = spot.item,
            label = spot.label,
            coords = spot.coords,
        }
    end
    for drugId, drug in pairs(Config.Drugs) do
        local p = drug.process
        if p and p.coords then
            list[#list + 1] = {
                id = 'process:' .. drugId,
                kind = 'process',
                drugId = drugId,
                label = p.label or ('Cook ' .. drug.label),
                coords = p.coords,
            }
        end
    end
    return list
end

local function unlockedFor(sold, entry)
    if entry.kind == 'process' then
        return Utils.CanAccessDrug(sold, entry.drugId)
    end
    return Utils.CanAccessHarvestItem(sold, entry.item)
end

local function snapshot(src)
    local char = Bridge.GetCharacter(src)
    if not char then return nil end
    local sold = Progress.GetSold(src)
    local row = loadRow(char.citizenid)
    local available, unrevealed, revealed = {}, {}, {}
    local all = catalog()
    for i = 1, #all do
        local entry = all[i]
        if unlockedFor(sold, entry) then
            available[#available + 1] = entry
            if row.revealed[entry.id] then
                revealed[#revealed + 1] = entry
            else
                unrevealed[#unrevealed + 1] = entry
            end
        end
    end
    if #unrevealed == 0 and #available > 0 then
        row.tourDone = true
        saveRow(char.citizenid, row)
    end
    return {
        char = char,
        sold = sold,
        row = row,
        available = available,
        unrevealed = unrevealed,
        revealed = revealed,
    }
end

local function cooldownLeft(row)
    return math.max(0, (row.cooldownUntil or 0) - os.time())
end

local function takeMoney(src, amount, moneyType)
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return true end
    if Utils.IsFrameworkMoney(moneyType) then
        local have = Bridge.GetMoney(src, moneyType) or 0
        if have < amount then return false end
        return Bridge.RemoveMoney(src, moneyType, amount, 'djdrugsv2-intel') ~= false
    end
    if Server.ItemCount(src, moneyType) < amount then return false end
    return Server.RemoveItem(src, moneyType, amount)
end

local function markCooldown(row)
    row.cooldownUntil = os.time() + math.max(1, tonumber(cfg().cooldown) or 3600)
end

lib.callback.register('djdrugsv2:server:getIntel', function(source)
    if cfg().enabled == false then return nil end
    local snap = snapshot(source)
    if not snap then return nil end
    return {
        revealed = snap.revealed,
        remaining = #snap.unrevealed,
        total = #snap.available,
        tourDone = snap.row.tourDone == true or #snap.unrevealed == 0,
        cooldown = cooldownLeft(snap.row),
        singlePrice = cfg().singlePrice or 25000,
        allPrice = cfg().allPrice or 175000,
        moneyType = cfg().moneyType or 'cash',
    }
end)

lib.callback.register('djdrugsv2:server:buyIntel', function(source, mode)
    if cfg().enabled == false then
        return false, 'Intel is closed'
    end
    if not Server.IsNearCoords(source, cfg().coords, 3.5) then
        return false, 'Talk to the informant'
    end

    local snap = snapshot(source)
    if not snap then
        return false, 'Who are you?'
    end

    local left = cooldownLeft(snap.row)
    if left > 0 then
        local mins = math.ceil(left / 60)
        return false, ('Come back in %s min'):format(mins)
    end

    local moneyType = cfg().moneyType or 'cash'
    if mode == 'all' then
        local canPack = snap.row.tourDone or #snap.unrevealed == 0
        if not canPack then
            return false, 'Buy each mark first, then I sell the full book'
        end
        local price = cfg().allPrice or 175000
        if not takeMoney(source, price, moneyType) then
            return false, ('Need %s %s'):format(Utils.FormatMoney(price), moneyType)
        end
        for i = 1, #snap.available do
            snap.row.revealed[snap.available[i].id] = true
        end
        snap.row.tourDone = true
        markCooldown(snap.row)
        saveRow(snap.char.citizenid, snap.row)
        return true, ('All %s unlocked marks are yours'):format(#snap.available), snap.available
    end

    if #snap.unrevealed == 0 then
        return false, 'You already bought every mark you can use'
    end

    local price = cfg().singlePrice or 25000
    if not takeMoney(source, price, moneyType) then
        return false, ('Need %s %s'):format(Utils.FormatMoney(price), moneyType)
    end

    local pick = snap.unrevealed[math.random(1, #snap.unrevealed)]
    snap.row.revealed[pick.id] = true
    if #snap.unrevealed == 1 then
        snap.row.tourDone = true
    end
    markCooldown(snap.row)
    saveRow(snap.char.citizenid, snap.row)
    return true, ('I marked %s. One hour. Do not come back sooner.'):format(pick.label), { pick }
end)
