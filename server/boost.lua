Boost = {
    sell = nil,
    harvest = nil,
    pending = nil,
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
    local endsAt = now() + durationSeconds
    local warnSec = tonumber(Config.Boost.endingWarningSeconds) or 0
    return {
        multiplier = multiplier,
        endsAt = endsAt,
        startedBy = adminName or 'Admin',
        label = ('%sx'):format(multiplier),
        warnAt = (warnSec > 0 and durationSeconds > warnSec) and (endsAt - warnSec) or nil,
        endWarned = false,
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
        pending = Boost.pending and {
            kind = Boost.pending.kind,
            multiplier = Boost.pending.multiplier,
            remaining = math.max(0, Boost.pending.startsAt - now()),
            startedBy = Boost.pending.adminName,
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
        title = (Config.Brand or 'The 305') .. ' Boost Event',
        description = message,
        type = nType or 'inform',
        duration = 8000,
    })
end

local function discordPost(title, description, color)
    local cfg = Config.Boost or {}
    local url = cfg.discordWebhook
    if (not url or url == '') and GetConvar then
        url = GetConvar('djdrugsv2_boost_webhook', '')
    end
    if type(url) ~= 'string' or url == '' or not url:find('discord.com/api/webhooks', 1, true) then
        return
    end
    PerformHttpRequest(url, function() end, 'POST', json.encode({
        username = cfg.discordUsername or '305 Boost Desk',
        embeds = {{
            title = title,
            description = description,
            color = color or 15105570,
            footer = { text = Config.Brand or 'The 305' },
        }},
    }), { ['Content-Type'] = 'application/json' })
end

local function kindLabel(kind)
    if kind == 'both' then return 'sell + harvest'
    elseif kind == 'sell' then return 'sell'
    end
    return 'harvest'
end

function Boost.GoLive(kind, multiplier, durationSeconds, adminName)
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
    local msg
    if kind == 'both' then
        msg = ('%sx sell + harvest boost is live for %s!'):format(multiplier, length)
    elseif kind == 'sell' then
        msg = ('%sx drug sell boost is live for %s!'):format(multiplier, length)
    else
        msg = ('%sx ingredient harvest boost is live for %s!'):format(multiplier, length)
    end
    announce(msg, 'success')
    discordPost('Boost is LIVE', msg, 5763719)
    TriggerClientEvent('djdrugsv2:client:boostUpdated', -1, Boost.GetState())
    return true
end

function Boost.Start(kind, multiplier, durationSeconds, adminName)
    local cfg = Config.Boost or {}
    durationSeconds = durationSeconds or cfg.defaultDuration or 3600
    multiplier = tonumber(multiplier) or 2
    local lead = tonumber(cfg.warningSeconds) or 0

    if lead <= 0 then
        Boost.pending = nil
        return Boost.GoLive(kind, multiplier, durationSeconds, adminName)
    end

    Boost.pending = {
        kind = kind,
        multiplier = multiplier,
        durationSeconds = durationSeconds,
        adminName = adminName or 'Admin',
        startsAt = now() + lead,
    }

    local warn = ('%sx %s boost starts in %s.'):format(multiplier, kindLabel(kind), formatMinutes(lead))
    announce(warn, 'inform')
    discordPost('Boost in 15 minutes', warn .. (' Live duration: %s.'):format(formatMinutes(durationSeconds)), 16753920)
    TriggerClientEvent('djdrugsv2:client:boostUpdated', -1, Boost.GetState())
    return true
end

function Boost.Stop(kind, silent)
    if Boost.pending and (kind == 'both' or Boost.pending.kind == kind or Boost.pending.kind == 'both') then
        Boost.pending = nil
    end
    if kind == 'sell' or kind == 'both' then
        Boost.sell = nil
    end
    if kind == 'harvest' or kind == 'both' then
        Boost.harvest = nil
    end

    if not silent then
        if kind == 'both' then
            announce('All drug boost events have ended.', 'inform')
            discordPost('Boost ended', 'All drug boost events have ended.', 10038562)
        elseif kind == 'sell' then
            announce('The drug sell boost has ended.', 'inform')
            discordPost('Sell boost ended', 'The drug sell boost has ended.', 10038562)
        else
            announce('The harvest boost has ended.', 'inform')
            discordPost('Harvest boost ended', 'The harvest boost has ended.', 10038562)
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

local function maybeEndWarn(event, label)
    if not event or event.endWarned or not event.warnAt then return end
    if now() >= event.warnAt then
        event.endWarned = true
        local msg = ('The %s boost ends in 15 minutes.'):format(label)
        announce(msg, 'inform')
        discordPost('15 minutes left', msg, 16776960)
    end
end

CreateThread(function()
    while true do
        Wait(5000)
        if Boost.pending and now() >= Boost.pending.startsAt then
            local pending = Boost.pending
            Boost.pending = nil
            Boost.GoLive(pending.kind, pending.multiplier, pending.durationSeconds, pending.adminName)
        end

        maybeEndWarn(Boost.sell, 'sell')
        maybeEndWarn(Boost.harvest, 'harvest')

        local beforeSell = Boost.sell ~= nil
        local beforeHarvest = Boost.harvest ~= nil
        prune()
        local sellEnded = beforeSell and Boost.sell == nil
        local harvestEnded = beforeHarvest and Boost.harvest == nil
        if sellEnded or harvestEnded then
            if sellEnded then
                announce('The drug sell boost has ended.', 'inform')
                discordPost('Sell boost ended', 'The drug sell boost has ended.', 10038562)
            end
            if harvestEnded then
                announce('The harvest boost has ended.', 'inform')
                discordPost('Harvest boost ended', 'The harvest boost has ended.', 10038562)
            end
            TriggerClientEvent('djdrugsv2:client:boostUpdated', -1, Boost.GetState())
        end
    end
end)
