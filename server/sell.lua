local function newToken()
    return ('%s_%s_%s'):format(os.time(), math.random(1000, 9999), math.random(10000, 99999))
end

local function playerSellableStock(src)
    local stock = {}
    for drugId, drug in pairs(Config.Drugs) do
        if drug.sell and drug.sell.enabled ~= false then
            local count = Server.ItemCount(src, drug.item)
            if count > 0 then
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

local function biasedPrice(minPrice, maxPrice, bias)
    bias = math.max(0.0, math.min(1.0, bias or 0.5))
    local span = maxPrice - minPrice
    local roll = math.max(0.0, math.min(1.0, bias + (math.random() - 0.5) * 0.35))
    return math.floor(minPrice + (span * roll) + 0.5)
end

local function findAsk(askId)
    local asks = Config.Trap.haggle and Config.Trap.haggle.asks or {}
    for i = 1, #asks do
        if asks[i].id == askId then
            return asks[i]
        end
    end
end

local function offerPayload(offer)
    return {
        token = offer.token,
        drugId = offer.drugId,
        item = offer.item,
        label = offer.label,
        quantity = offer.quantity,
        priceEach = offer.priceEach,
        total = offer.total,
        minPrice = offer.minPrice,
        maxPrice = offer.maxPrice,
        attempts = offer.attempts,
        maxAttempts = offer.maxAttempts,
        haggleEnabled = offer.haggleEnabled,
        boostMultiplier = offer.boostMultiplier or 1,
    }
end

lib.callback.register('djdrugsv2:server:canTrap', function(source)
    if Config.Police.enabled then
        local cops = Server.GetOnDutyPolice()
        if cops < (Config.Police.minimum or 0) then
            return false, 'Not enough police on duty'
        end
    end

    if Config.Trap.requireOwnedDrug then
        local stock = playerSellableStock(source)
        if #stock == 0 then
            return false, 'You need finished product to trap'
        end
    end

    return true
end)

lib.callback.register('djdrugsv2:server:createOffer', function(source)
    local stock = playerSellableStock(source)
    local pick

    if Config.Trap.requireOwnedDrug then
        if #stock == 0 then return nil end
        pick = stock[math.random(1, #stock)]
    else
        local ids = Utils.GetSellableDrugs()
        if #ids == 0 then return nil end
        local drugId = ids[math.random(1, #ids)]
        local drug = Utils.GetDrug(drugId)
        pick = {
            id = drugId,
            drug = drug,
            count = Server.ItemCount(source, drug.item),
        }
        if pick.count <= 0 then return nil end
    end

    local sell = pick.drug.sell
    local maxAsk = math.min(sell.maxQty or 5, pick.count)
    local minAsk = math.min(sell.minQty or 1, maxAsk)
    if maxAsk < 1 then return nil end

    local quantity = math.random(minAsk, maxAsk)
    local haggle = Config.Trap.haggle or {}
    local mult = Boost.GetSellMultiplier()
    local rankMult = Progress.GetPayoutMultiplier(source)
    local minPrice = math.floor((sell.minPrice * mult * rankMult) + 0.5)
    local maxPrice = math.floor((sell.maxPrice * mult * rankMult) + 0.5)
    local priceEach = biasedPrice(minPrice, maxPrice, haggle.openingBias or 0.35)
    priceEach = math.max(minPrice, math.min(maxPrice, priceEach))
    local total = priceEach * quantity
    local token = newToken()
    local moneyType = sell.moneyType
        or (sell.clean == true and (Config.MoneyType or 'cash'))
        or (Config.DirtyMoneyType or 'black_money')

    Server.offers[source] = {
        token = token,
        drugId = pick.id,
        item = pick.drug.item,
        label = pick.drug.label,
        quantity = quantity,
        priceEach = priceEach,
        total = total,
        minPrice = minPrice,
        maxPrice = maxPrice,
        moneyType = moneyType,
        boostMultiplier = mult,
        rankMultiplier = rankMult,
        attempts = 0,
        maxAttempts = haggle.maxAttempts or 2,
        haggleEnabled = haggle.enabled ~= false,
        expires = os.time() + 90,
    }

    return offerPayload(Server.offers[source])
end)

lib.callback.register('djdrugsv2:server:haggleOffer', function(source, token, askId)
    local offer = Server.offers[source]
    if not offer or offer.token ~= token then
        return { ok = false, outcome = 'expired', message = 'Offer expired' }
    end

    if offer.expires < os.time() then
        Server.offers[source] = nil
        return { ok = false, outcome = 'expired', message = 'Offer expired' }
    end

    if not offer.haggleEnabled then
        return { ok = false, outcome = 'disabled', message = 'Buyer will not negotiate', offer = offerPayload(offer) }
    end

    if offer.attempts >= offer.maxAttempts then
        return { ok = false, outcome = 'max', message = 'Buyer is done negotiating', offer = offerPayload(offer) }
    end

    if offer.priceEach >= offer.maxPrice then
        return { ok = false, outcome = 'maxed', message = 'Already at top dollar for this buyer', offer = offerPayload(offer) }
    end

    local ask = findAsk(askId)
    if not ask then
        return { ok = false, outcome = 'invalid', message = 'Invalid ask', offer = offerPayload(offer) }
    end

    offer.attempts = offer.attempts + 1

    local roll = math.random(1, 100)
    local success = ask.successChance or 0
    local counter = ask.counterChance or 0
    local walk = ask.walkAwayChance or 0

    local gap = offer.maxPrice - offer.priceEach
    local bumpMin = ask.bump and ask.bump.min or 0.25
    local bumpMax = ask.bump and ask.bump.max or 0.45
    local bumpFactor = Utils.RandomFloat(bumpMin, bumpMax)

    if roll <= success then
        local bump = math.max(1, math.floor(gap * bumpFactor + 0.5))
        offer.priceEach = math.min(offer.maxPrice, offer.priceEach + bump)
        offer.total = offer.priceEach * offer.quantity
        return {
            ok = true,
            outcome = 'success',
            message = ('Buyer bites — $%s each now'):format(offer.priceEach),
            offer = offerPayload(offer),
        }
    end

    roll = roll - success
    if roll <= counter then
        local bump = math.max(1, math.floor(gap * (bumpFactor * 0.45) + 0.5))
        offer.priceEach = math.min(offer.maxPrice, offer.priceEach + bump)
        offer.total = offer.priceEach * offer.quantity
        return {
            ok = true,
            outcome = 'counter',
            message = ('Buyer meets you halfway — $%s each'):format(offer.priceEach),
            offer = offerPayload(offer),
        }
    end

    roll = roll - counter
    if roll <= walk then
        Server.offers[source] = nil
        return {
            ok = false,
            outcome = 'walk',
            message = 'Buyer got mad and walked off',
        }
    end

    return {
        ok = true,
        outcome = 'refuse',
        message = ('Buyer says no — still offering $%s each'):format(offer.priceEach),
        offer = offerPayload(offer),
    }
end)

lib.callback.register('djdrugsv2:server:completeSale', function(source, token)
    local offer = Server.offers[source]
    if not offer or offer.token ~= token then
        return false, 'Offer expired'
    end

    if offer.expires < os.time() then
        Server.offers[source] = nil
        return false, 'Offer expired'
    end

    local count = Server.ItemCount(source, offer.item)
    if count < offer.quantity then
        Server.offers[source] = nil
        return false, 'Not enough product'
    end

    if not Server.CanAddPayout(source, offer.moneyType, offer.total) then
        return false, 'Payment failed'
    end

    if not Server.RemoveItem(source, offer.item, offer.quantity) then
        return false, 'Could not remove product'
    end

    if not Server.AddMoney(source, offer.total, offer.moneyType) then
        Server.AddItem(source, offer.item, offer.quantity)
        return false, 'Payment failed'
    end

    Server.offers[source] = nil

    local leveled, rank = Progress.RecordSale(source, offer.quantity, offer.total)
    if leveled and rank then
        Server.Notify(source, ('Rank up — %s (Level %s)'):format(rank.label, rank.level), 'success')
    end

    if Config.Police.enabled and (Config.Police.alertChance or 0) > 0 then
        if math.random(1, 100) <= Config.Police.alertChance then
            Utils.Debug('police alert rolled for', source)
        end
    end

    local dirty = offer.moneyType and offer.moneyType ~= (Config.MoneyType or 'cash')
    local rankNote = (offer.rankMultiplier and offer.rankMultiplier > 1)
        and (' [%sx rank]'):format(offer.rankMultiplier)
        or ''
    return true, ('Sold %sx %s for $%s ($%s each)%s%s%s'):format(
        offer.quantity,
        offer.label,
        offer.total,
        offer.priceEach,
        dirty and ' (dirty)' or '',
        (offer.boostMultiplier and offer.boostMultiplier > 1) and (' [%sx boost]'):format(offer.boostMultiplier) or '',
        rankNote
    )
end)
