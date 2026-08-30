Boost = {
    sell = nil,
    harvest = nil,
}

local function now()
    return os.time()
end

local function remaining(event)
    if not event then return 0 end
    return math.max(0, event.endsAt - now())
end

local function expired(event)
    return not event or event.endsAt <= now()
end

local function prune()
    if expired(Boost.sell) then Boost.sell = nil end
    if expired(Boost.harvest) then Boost.harvest = nil end
end

local function makeEvent(multiplier, durationSeconds, adminName)
    return {
        multiplier = multiplier,
        endsAt = now() + durationSeconds,
        startedBy = adminName or 'Admin',
        label = ('%sx'):format(multiplier),
    }
end

function Boost.GetSellMultiplier()
    prune()
    return (Boost.sell and Boost.sell.multiplier) or 1
end

function Boost.GetHarvestMultiplier()
    prune()
    return (Boost.harvest and Boost.harvest.multiplier) or 1
end

function Boost.GetState()
    prune()
    return {
        sell = Boost.sell and {
            multiplier = Boost.sell.multiplier,
            endsAt = Boost.sell.endsAt,
            remaining = remaining(Boost.sell),
            startedBy = Boost.sell.startedBy,
        } or nil,
        harvest = Boost.harvest and {
            multiplier = Boost.harvest.multiplier,
            endsAt = Boost.harvest.endsAt,
            remaining = remaining(Boost.harvest),
            startedBy = Boost.harvest.startedBy,
        } or nil,
    }
end

local function formatMinutes(seconds)
    local m = math.ceil(seconds / 60)
    if m <= 1 then return '1 minute' end
    if m >= 60 and m % 60 == 0 then
        local h = m / 60
        return h == 1 and '1 hour' or (h .. ' hours')
    end
    return ('%s minutes'):format(m)
end

local function announce(message, nType)
    if Config.Boost.announce == false then return end
    TriggerClientEvent('ox_lib:notify', -1, {
        title = 'THE 305 Boost Event',
        description = message,
        type = nType or 'inform',
        duration = 8000,
    })
end

function Boost.Start(kind, multiplier, durationSeconds, adminName)
    local cfg = Config.Boost
    durationSeconds = durationSeconds or cfg.defaultDuration or 3600
    multiplier = tonumber(multiplier) or 2

    if kind == 'sell' or kind == 'both' then
        Boost.sell = makeEvent(multiplier, durationSeconds, adminName)
    end
    if kind == 'harvest' or kind == 'both' then
        Boost.harvest = makeEvent(multiplier, durationSeconds, adminName)
    end

    local length = formatMinutes(durationSeconds)
    if kind == 'both' then
        announce(('%sx sell + harvest boost is live for %s!'):format(multiplier, length), 'success')
    elseif kind == 'sell' then
        announce(('%sx drug sell boost is live for %s!'):format(multiplier, length), 'success')
    else
        announce(('%sx ingredient harvest boost is live for %s!'):format(multiplier, length), 'success')
    end

    TriggerClientEvent('djdrugsv2:client:boostUpdated', -1, Boost.GetState())
    return true
end

function Boost.Stop(kind, silent)
    if kind == 'sell' or kind == 'both' then
        Boost.sell = nil
    end
    if kind == 'harvest' or kind == 'both' then
        Boost.harvest = nil
    end

    if not silent then
        if kind == 'both' then
            announce('All drug boost events have ended.', 'inform')
        elseif kind == 'sell' then
            announce('The drug sell boost has ended.', 'inform')
        else
            announce('The harvest boost has ended.', 'inform')
        end
    end

    TriggerClientEvent('djdrugsv2:client:boostUpdated', -1, Boost.GetState())
    return true
end

lib.callback.register('djdrugsv2:server:getBoostState', function()
    return Boost.GetState()
end)

lib.callback.register('djdrugsv2:server:canManageBoost', function(source)
    return Bridge.IsBoostAdmin(source)
end)

RegisterNetEvent('djdrugsv2:server:startBoost', function(kind, multiplier, durationSeconds)
    local src = source
    if not Bridge.IsBoostAdmin(src) then
        Server.Notify(src, 'No permission', 'error')
        return
    end

    if kind ~= 'sell' and kind ~= 'harvest' and kind ~= 'both' then
        Server.Notify(src, 'Invalid boost type', 'error')
        return
    end

    local allowed = false
    for i = 1, #(Config.Boost.multipliers or {}) do
        if Config.Boost.multipliers[i] == multiplier then
            allowed = true
            break
        end
    end
    if not allowed then
        Server.Notify(src, 'Invalid multiplier', 'error')
        return
    end

    durationSeconds = tonumber(durationSeconds) or Config.Boost.defaultDuration
    if durationSeconds < 60 or durationSeconds > (12 * 60 * 60) then
        Server.Notify(src, 'Invalid duration', 'error')
        return
    end

    local name = GetPlayerName(src) or 'Admin'
    Boost.Start(kind, multiplier, durationSeconds, name)
    Server.Notify(src, ('Started %s %sx boost'):format(kind, multiplier), 'success')
end)

RegisterNetEvent('djdrugsv2:server:stopBoost', function(kind)
    local src = source
    if not Bridge.IsBoostAdmin(src) then
        Server.Notify(src, 'No permission', 'error')
        return
    end

    if kind ~= 'sell' and kind ~= 'harvest' and kind ~= 'both' then
        Server.Notify(src, 'Invalid boost type', 'error')
        return
    end

    Boost.Stop(kind, false)
    Server.Notify(src, ('Stopped %s boost'):format(kind), 'inform')
end)

CreateThread(function()
    while true do
        Wait(15000)
        local beforeSell = Boost.sell ~= nil
        local beforeHarvest = Boost.harvest ~= nil
        prune()
        local sellEnded = beforeSell and Boost.sell == nil
        local harvestEnded = beforeHarvest and Boost.harvest == nil
        if sellEnded or harvestEnded then
            if sellEnded then
                announce('The drug sell boost has ended.', 'inform')
            end
            if harvestEnded then
                announce('The harvest boost has ended.', 'inform')
            end
            TriggerClientEvent('djdrugsv2:client:boostUpdated', -1, Boost.GetState())
        end
    end
end)
