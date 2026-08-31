Server = {
    harvestCooldown = {},
    storeCooldown = {},
    machineCooldown = {},
    processCooldown = {},
    offers = {},
}

function Server.Notify(src, description, nType)
    TriggerClientEvent('ox_lib:notify', src, {
        title = Config.Brand or 'THE 305',
        description = description,
        type = nType or 'inform',
    })
end

function Server.ItemCount(src, item)
    return Bridge.ItemCount(src, item)
end

function Server.CanCarry(src, item, amount)
    return Bridge.CanCarry(src, item, amount)
end

function Server.AddItem(src, item, amount, metadata)
    return Bridge.AddItem(src, item, amount, metadata)
end

function Server.RemoveItem(src, item, amount)
    return Bridge.RemoveItem(src, item, amount)
end

function Server.CanAddPayout(src, moneyType, amount)
    local account = moneyType or Config.MoneyType or 'cash'
    if Utils.IsFrameworkMoney(account) then
        return true
    end
    return Server.CanCarry(src, account, amount) == true
end

function Server.AddMoney(src, amount, moneyType)
    local account = moneyType or Config.MoneyType or 'cash'
    if Utils.IsFrameworkMoney(account) then
        local ok = Bridge.AddMoney(src, account, amount, 'djdrugsv2-sale')
        return ok ~= false
    end

    if not Server.CanAddPayout(src, account, amount) then
        Utils.Debug('payout cannot carry', account, tostring(amount))
        return false
    end
    local added = Server.AddItem(src, account, amount)
    if not added then
        Utils.Debug('payout AddItem failed', account, tostring(amount))
        return false
    end
    return true
end

function Server.RemoveMoney(src, amount)
    local ok = Bridge.RemoveMoney(src, Config.MoneyType, amount, 'djdrugsv2-store')
    return ok ~= false
end

function Server.GetMoney(src)
    return Bridge.GetMoney(src, Config.MoneyType) or 0
end

function Server.OnCooldown(bucket, src, key, seconds)
    bucket[src] = bucket[src] or {}
    local now = os.time()
    local stamp = bucket[src][key]
    if stamp and stamp > now then
        return true, stamp - now
    end
    bucket[src][key] = now + (seconds or 5)
    return false, 0
end

function Server.ClearCooldown(bucket, src, key)
    if bucket[src] then
        bucket[src][key] = nil
    end
end

function Server.GetOnDutyPolice()
    if not Config.Police.enabled then return 999 end
    local count = 0
    local players = Bridge.GetPlayers()
    for _, player in pairs(players) do
        local job = player.PlayerData and player.PlayerData.job
        if job and job.onduty then
            for i = 1, #Config.Police.jobs do
                if job.name == Config.Police.jobs[i] then
                    count = count + 1
                    break
                end
            end
        end
    end
    return count
end

function Server.FindHarvest(id)
    for i = 1, #Config.Harvest do
        if Config.Harvest[i].id == id then
            return Config.Harvest[i]
        end
    end
end

function Server.AmountFromConfig(amount)
    if type(amount) == 'table' then
        local min = amount.min or 1
        local max = amount.max or min
        return math.random(min, max)
    end
    return amount or 1
end

function Server.IsNearCoords(src, coords, maxDist)
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return false end
    local pCoords = GetEntityCoords(ped)
    return #(pCoords - coords) <= (maxDist or 4.0)
end

--- Map entityKey (spotId or spotId_N) to a configured harvest coordinate.
--- Client-supplied world coords are never trusted.
function Server.GetHarvestTarget(spot, entityKey)
    if not spot then return nil end

    if spot.positions and #spot.positions > 0 then
        if type(entityKey) == 'string' then
            local prefix = spot.id .. '_'
            if entityKey:sub(1, #prefix) == prefix then
                local idx = tonumber(entityKey:sub(#prefix + 1))
                if idx and spot.positions[idx] then
                    return spot.positions[idx]
                end
            end
        end
        return nil
    end

    if entityKey and entityKey ~= spot.id then
        return nil
    end
    return spot.coords
end

--- Validate harvest proximity against configured prop positions only
function Server.IsNearHarvestSpot(src, spot, entityKey)
    local target = Server.GetHarvestTarget(spot, entityKey)
    if not target then return false end

    -- Horizontal distance so small Z mismatches from ground-snap do not fail
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return false end
    local pCoords = GetEntityCoords(ped)
    local dx = pCoords.x - target.x
    local dy = pCoords.y - target.y
    local maxDist = (Config.InteractDistance or 2.2) + 2.0
    return (dx * dx + dy * dy) <= (maxDist * maxDist)
end

AddEventHandler('playerDropped', function()
    local src = source
    Server.harvestCooldown[src] = nil
    Server.storeCooldown[src] = nil
    Server.machineCooldown[src] = nil
    Server.processCooldown[src] = nil
    Server.offers[src] = nil
end)

CreateThread(function()
    math.randomseed(os.time())
    Utils.Debug('server ready (qbx) — sellable drugs:', tostring(#Utils.GetSellableDrugs()))
end)
