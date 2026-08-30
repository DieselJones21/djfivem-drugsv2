NUI = {
    focus = false,
}

function NUI.Send(action, data)
    SendNUIMessage({
        action = action,
        data = data,
    })
end

function NUI.SetFocus(state)
    NUI.focus = state
    SetNuiFocus(state, state)
end

function NUI.CloseAll()
    NUI.SetFocus(false)
    NUI.Send('closeAll')
end

function NUI.OpenLeaderboard(board)
    NUI.Send('openLeaderboard', board)
    NUI.SetFocus(true)
end

function NUI.OpenBoost(state)
    NUI.Send('openBoost', state)
    NUI.SetFocus(true)
end

function NUI.UpdateBoost(state)
    NUI.Send('updateBoost', state)
end

function NUI.OpenSell(offer)
    NUI.Send('openSell', offer)
    -- Mini sell UI does not steal focus (player can still move)
end

function NUI.UpdateSell(offer)
    NUI.Send('updateSell', offer)
end

function NUI.CloseSell()
    NUI.Send('closeSell')
end

RegisterNUICallback('close', function(_, cb)
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

    -- Refresh boost state in the panel after server processes the action
    SetTimeout(500, function()
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
