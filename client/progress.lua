ProgressUI = {}

function ProgressUI.Open()
    if not Config.Progression or Config.Progression.enabled == false then
        Client.Notify('Sell ranks are disabled', 'error')
        return
    end

    local board = lib.callback.await('djdrugsv2:server:getProgressBoard', false)
    if not board then
        Client.Notify('Could not load the leaderboard', 'error')
        return
    end

    NUI.OpenLeaderboard(board)
end

CreateThread(function()
    Wait(500)
    if not Config.Progression or Config.Progression.enabled == false then
        return
    end
    local cmd = Config.Progression.command or 'drugboard'
    RegisterCommand(cmd, function()
        ProgressUI.Open()
    end, false)
    TriggerEvent('chat:addSuggestion', '/' .. cmd, Config.Progression.description or 'Drug sell leaderboard')
end)
