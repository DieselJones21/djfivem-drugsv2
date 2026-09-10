local function pendingBucket()
    Server.harvestPending = Server.harvestPending or {}
    return Server.harvestPending
end

local function pendingKey(src, entityKey, spotId)
    return tostring(entityKey or spotId)
end

lib.callback.register('djdrugsv2:server:harvestStart', function(source, spotId, entityKey)
    local spot = Server.FindHarvest(spotId)
    if not spot then return false end

    if not Server.IsNearHarvestSpot(source, spot, entityKey) then
        Server.Notify(source, 'Too far away', 'error')
        return false
    end

    local key = pendingKey(source, entityKey, spot.id)
    local bucket = pendingBucket()
    bucket[source] = bucket[source] or {}
    bucket[source][key] = {
        spotId = spot.id,
        entityKey = entityKey,
        started = GetGameTimer(),
        duration = math.max(1500, tonumber(spot.duration) or 5000),
    }
    return true, bucket[source][key].duration
end)

lib.callback.register('djdrugsv2:server:harvestCancel', function(source, spotId, entityKey)
    local bucket = pendingBucket()
    if bucket[source] then
        bucket[source][pendingKey(source, entityKey, spotId)] = nil
    end
    return true
end)

local function tryHarvest(src, spotId, entityKey)
    local spot = Server.FindHarvest(spotId)
    if not spot then return false end

    if not Server.IsNearHarvestSpot(src, spot, entityKey) then
        Server.Notify(src, 'Too far away', 'error')
        return false
    end

    local key = pendingKey(src, entityKey, spot.id)
    local bucket = pendingBucket()
    local pending = bucket[src] and bucket[src][key]
    if not pending or pending.spotId ~= spot.id then
        Server.Notify(src, 'Harvest expired', 'error')
        return false
    end

    local elapsed = GetGameTimer() - (pending.started or 0)
    local need = math.floor((pending.duration or 5000) * 0.8)
    if elapsed < need then
        Server.Notify(src, 'Too fast', 'error')
        return false
    end
    if elapsed > ((pending.duration or 5000) + 30000) then
        bucket[src][key] = nil
        Server.Notify(src, 'Harvest expired', 'error')
        return false
    end
    bucket[src][key] = nil

    local cdKey = entityKey or spot.id
    local cooling, left = Server.OnCooldown(Server.harvestCooldown, src, cdKey, spot.cooldown or Config.IngredientCooldown or 10)
    if cooling then
        Server.Notify(src, ('Wait %s seconds'):format(left), 'error')
        return false
    end

    local amount = Server.AmountFromConfig(spot.amount)
    local mult = Boost.GetHarvestMultiplier()
    if mult > 1 then
        amount = math.max(1, math.floor(amount * mult + 0.5))
    end
    if not Server.CanCarry(src, spot.item, amount) then
        Server.ClearCooldown(Server.harvestCooldown, src, cdKey)
        Server.Notify(src, 'You cannot carry that', 'error')
        return false
    end

    if Server.AddItem(src, spot.item, amount) then
        local boostNote = mult > 1 and (' [%sx harvest boost]'):format(mult) or ''
        Server.Notify(src, ('Collected %sx %s%s'):format(amount, spot.item, boostNote), 'success')
        return true
    end

    Server.ClearCooldown(Server.harvestCooldown, src, cdKey)
    Server.Notify(src, 'Could not add item', 'error')
    return false
end

lib.callback.register('djdrugsv2:server:tryHarvest', function(source, spotId, entityKey)
    return tryHarvest(source, spotId, entityKey)
end)

RegisterNetEvent('djdrugsv2:server:harvest', function(spotId, entityKey)
    -- Legacy path still requires a harvestStart + elapsed time.
    tryHarvest(source, spotId, entityKey)
end)
