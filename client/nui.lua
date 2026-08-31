NUI = {
    focus = false,
    mode = nil, -- 'leaderboard' | 'boost' | 'sell' | nil
}

function NUI.Send(action, data)
    SendNUIMessage({
        action = action,
        data = data,
    })
end

function NUI.SetFocus(state)
    NUI.focus = state == true
    SetNuiFocus(NUI.focus, NUI.focus)
end

function NUI.CloseAll()
    NUI.mode = nil
    NUI.SetFocus(false)
    NUI.Send('closeAll')
end

function NUI.OpenLeaderboard(board)
    NUI.mode = 'leaderboard'
    NUI.Send('openLeaderboard', board)
    NUI.SetFocus(true)
end

function NUI.OpenBoost(state)
    NUI.mode = 'boost'
    NUI.Send('openBoost', state)
    NUI.SetFocus(true)
end

function NUI.UpdateBoost(state)
    NUI.Send('updateBoost', state)
end

function NUI.OpenSell(offer)
    NUI.Send('openSell', offer)
    -- Deal panel needs mouse so Accept / Haggle / Walk Away actually work
    if NUI.mode ~= 'leaderboard' and NUI.mode ~= 'boost' then
        NUI.mode = 'sell'
        NUI.SetFocus(true)
    end
end

function NUI.UpdateSell(offer)
    NUI.Send('updateSell', offer)
end

function NUI.CloseSell()
    NUI.Send('closeSell')
    if NUI.mode == 'sell' then
        NUI.mode = nil
        NUI.SetFocus(false)
    end
end

RegisterNUICallback('close', function(_, cb)
    if NUI.mode == 'sell' then
        cb('ok')
        return
    end
    NUI.mode = nil
    NUI.SetFocus(false)
    cb('ok')
end)

RegisterNUICallback('sellAction', function(data, cb)
    if Sell and Sell.HandleNUIAction then
        Sell.HandleNUIAction(data)
    end
    cb('ok')
end)

RegisterNUICallback('boostAction', function(data, cb)
    if data.action == 'start' then
        TriggerServerEvent('djdrugsv2:server:startBoost', data.kind, data.multiplier, data.duration)
    elseif data.action == 'stop' then
        TriggerServerEvent('djdrugsv2:server:stopBoost', data.kind)
    end
    cb('ok')

    SetTimeout(400, function()
        local state = lib.callback.await('djdrugsv2:server:getBoostState', false)
        if state then
            NUI.UpdateBoost(state)
        end
    end)
end)

RegisterNetEvent('djdrugsv2:client:boostUpdated', function(state)
    NUI.UpdateBoost(state)
    if BoostUI and BoostUI.OnUpdated then
        BoostUI.OnUpdated(state)
    end
end)
