BoostUI = {}

local cachedBoost = { sell = nil, harvest = nil }

local function refreshBoost()
    cachedBoost = lib.callback.await('djdrugsv2:server:getBoostState', false) or { sell = nil, harvest = nil }
    return cachedBoost
end

function BoostUI.GetCached()
    return cachedBoost
end

function BoostUI.OnUpdated(state)
    cachedBoost = state or { sell = nil, harvest = nil }
end

function BoostUI.Open()
    local allowed = lib.callback.await('djdrugsv2:server:canManageBoost', false)
    if not allowed then
        Client.Notify('No permission for boost events', 'error')
        return
    end

    local state = refreshBoost()
    NUI.OpenBoost(state)
end

CreateThread(function()
    Wait(500)
    local cmd = (Config.Boost and Config.Boost.command) or 'drugboost'
    RegisterCommand(cmd, function()
        BoostUI.Open()
    end, false)
    TriggerEvent('chat:addSuggestion', '/' .. cmd, (Config.Boost and Config.Boost.description) or 'Drug boost admin menu')
    local state = refreshBoost()
    NUI.UpdateBoost(state)
end)
