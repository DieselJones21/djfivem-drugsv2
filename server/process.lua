local function pendingBucket()
    Server.processPending = Server.processPending or {}
    return Server.processPending
end

local function missingMessage(drug)
    local parts = {}
    for i = 1, #drug.ingredients do
        local ing = drug.ingredients[i]
        parts[#parts + 1] = ('%sx %s'):format(ing.amount, ing.item)
    end
    return 'Missing ingredients: ' .. table.concat(parts, ', ')
end

local function hasIngredients(src, drug)
    for i = 1, #drug.ingredients do
        local ing = drug.ingredients[i]
        if Server.ItemCount(src, ing.item) < ing.amount then
            return false
        end
    end
    return true
end

lib.callback.register('djdrugsv2:server:canProcess', function(source, drugId)
    local drug = Utils.GetDrug(drugId)
    if not drug then return false end
    return hasIngredients(source, drug)
end)

lib.callback.register('djdrugsv2:server:processStart', function(source, drugId)
    local drug = Utils.GetDrug(drugId)
    if not drug or not drug.process then
        return false, 'Unknown recipe'
    end

    local p = drug.process
    if not Server.IsNearCoords(source, p.coords, 4.0) then
        return false, 'Too far from the bench'
    end

    if not hasIngredients(source, drug) then
        return false, missingMessage(drug)
    end

    local cooling, left = Server.OnCooldown(Server.processCooldown, source, drugId, 3)
    if cooling then
        return false, ('Slow down (%ss)'):format(left)
    end

    local duration = math.max(2500, tonumber(p.duration) or 10000)
    local bucket = pendingBucket()
    bucket[source] = bucket[source] or {}
    bucket[source][drugId] = {
        drugId = drugId,
        started = GetGameTimer(),
        duration = duration,
    }
    return true, duration
end)

lib.callback.register('djdrugsv2:server:processCancel', function(source, drugId)
    local bucket = pendingBucket()
    if bucket[source] then
        bucket[source][drugId] = nil
        Server.ClearCooldown(Server.processCooldown, source, drugId)
    end
    return true
end)

local function tryProcess(src, drugId)
    local drug = Utils.GetDrug(drugId)
    if not drug or not drug.process then
        return false, 'Unknown recipe'
    end

    local p = drug.process
    if not Server.IsNearCoords(src, p.coords, 4.0) then
        return false, 'Too far from the bench'
    end

    local bucket = pendingBucket()
    local pending = bucket[src] and bucket[src][drugId]
    if not pending then
        return false, 'Process expired'
    end

    local elapsed = GetGameTimer() - (pending.started or 0)
    local need = math.floor((pending.duration or 10000) * 0.8)
    if elapsed < need then
        return false, 'Too fast'
    end
    if elapsed > ((pending.duration or 10000) + 30000) then
        bucket[src][drugId] = nil
        return false, 'Process expired'
    end
    bucket[src][drugId] = nil

    if not hasIngredients(src, drug) then
        return false, 'Missing ingredients'
    end

    local outItem = p.output.item or drug.item
    local outAmount = p.output.amount or 1
    if not Server.CanCarry(src, outItem, outAmount) then
        return false, 'You cannot carry the product'
    end

    for i = 1, #drug.ingredients do
        local ing = drug.ingredients[i]
        if not Server.RemoveItem(src, ing.item, ing.amount) then
            return false, 'Failed to remove ingredients'
        end
    end

    if Server.AddItem(src, outItem, outAmount) then
        return true, ('Processed %sx %s'):format(outAmount, drug.label)
    end

    for i = 1, #drug.ingredients do
        local ing = drug.ingredients[i]
        Server.AddItem(src, ing.item, ing.amount)
    end
    return false, 'Processing failed'
end

lib.callback.register('djdrugsv2:server:tryProcess', function(source, drugId)
    return tryProcess(source, drugId)
end)

RegisterNetEvent('djdrugsv2:server:process', function(drugId)
    local ok, message = tryProcess(source, drugId)
    if message then
        Server.Notify(source, message, ok and 'success' or 'error')
    end
end)
