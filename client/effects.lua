Effects = {
    active = nil,
    token = 0,
    busy = false,
}

local function clearVisuals()
    ClearTimecycleModifier()
    StopGameplayCamShaking(true)
    AnimpostfxStopAll()
    ResetPedMovementClipset(PlayerPedId(), 0.25)
    SetPedIsDrunk(PlayerPedId(), false)
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
    SetSwimMultiplierForPlayer(PlayerId(), 1.0)
end

function Effects.Clear()
    Effects.token = Effects.token + 1
    Effects.active = nil
    clearVisuals()
end

local function applyStress(amount)
    if not amount or amount == 0 then return end
    if amount < 0 and Config.StressEvent then
        TriggerServerEvent(Config.StressEvent, math.abs(amount))
    elseif amount > 0 and Config.StressGainEvent then
        TriggerServerEvent(Config.StressGainEvent, amount)
    end
end

function Effects.Apply(drugId, effect)
    Effects.Clear()
    local token = Effects.token
    Effects.active = drugId

    local ped = PlayerPedId()
    local playerId = PlayerId()

    if effect.health and effect.health ~= 0 then
        local hp = GetEntityHealth(ped) + effect.health
        SetEntityHealth(ped, math.min(hp, GetEntityMaxHealth(ped)))
    end

    if effect.armor and effect.armor > 0 then
        local maxArmour = GetPlayerMaxArmour(playerId)
        if maxArmour < 1 then maxArmour = 100 end
        SetPedArmour(ped, math.min(maxArmour, GetPedArmour(ped) + effect.armor))
    end

    if effect.armorPercent and effect.armorPercent > 0 then
        local maxArmour = GetPlayerMaxArmour(playerId)
        if maxArmour < 1 then maxArmour = 100 end
        local add = math.floor(maxArmour * (effect.armorPercent / 100.0))
        SetPedArmour(ped, math.min(maxArmour, GetPedArmour(ped) + add))
    end

    if effect.stress then
        applyStress(effect.stress)
    end

    local allowScreen = effect.noScreenFx ~= true

    if allowScreen and effect.timecycle then
        SetTimecycleModifier(effect.timecycle)
        SetTimecycleModifierStrength(effect.timecycleStrength or 0.5)
    end

    if allowScreen and effect.screenEffect then
        AnimpostfxPlay(effect.screenEffect, 0, true)
    end

    if allowScreen and effect.shake then
        ShakeGameplayCam('DRUNK_SHAKE', effect.shake.intensity or 0.3)
        SetTimeout(effect.shake.duration or 5000, function()
            if Effects.token == token then
                StopGameplayCamShaking(true)
            end
        end)
    end

    if allowScreen and effect.walk then
        RequestAnimSet(effect.walk)
        local timeout = GetGameTimer() + 3000
        while not HasAnimSetLoaded(effect.walk) do
            if GetGameTimer() > timeout then break end
            Wait(10)
        end
        if HasAnimSetLoaded(effect.walk) then
            SetPedMovementClipset(ped, effect.walk, 0.5)
        end
    end

    if allowScreen and effect.drunkCamera then
        SetPedIsDrunk(ped, true)
    end

    if effect.sprintMultiplier and effect.sprintMultiplier > 1.0 then
        SetRunSprintMultiplierForPlayer(playerId, math.min(1.49, effect.sprintMultiplier))
    end

    CreateThread(function()
        local endsAt = GetGameTimer() + (effect.duration or 30000)
        while Effects.token == token and GetGameTimer() < endsAt do
            if effect.stamina then
                RestorePlayerStamina(playerId, 1.0)
            end
            if effect.sprintMultiplier and effect.sprintMultiplier > 1.0 then
                SetRunSprintMultiplierForPlayer(playerId, math.min(1.49, effect.sprintMultiplier))
            end
            Wait(1000)
        end

        if Effects.token == token then
            Effects.Clear()
            Client.Notify('The high wore off', 'inform')
        end
    end)
end

function Effects.TryUse(itemName, oxData)
    if Effects.busy then return end
    if not Config.UseEffects then
        Client.Notify('Drug effects are disabled', 'error')
        return
    end

    local drugId, drug = Utils.GetDrugByItem(itemName)
    if not drug or not drug.effects or drug.effects.enabled == false then
        Client.Notify('This item has no effect configured', 'error')
        return
    end

    Effects.busy = true
    local effect = drug.effects

    local canUse = lib.callback.await('djdrugsv2:server:canUseDrug', false, itemName)
    if not canUse then
        Effects.busy = false
        return
    end

    local progressOk = true
    if effect.useTime and effect.useTime > 0 then
        progressOk = Client.Progress(effect.label or ('Using ' .. drug.label), effect.useTime, effect.anim)
    end

    if not progressOk then
        Effects.busy = false
        Client.Notify('Cancelled', 'error')
        return
    end

    local function afterConsumed()
        Effects.Apply(drugId, effect)
        Client.Notify(('You used %s'):format(drug.label), 'success')
        Effects.busy = false
    end

    if oxData then
        exports.ox_inventory:useItem(oxData, function(used)
            if not used then
                Effects.busy = false
                Client.Notify('Could not use item', 'error')
                return
            end
            TriggerServerEvent('djdrugsv2:server:usedDrug', itemName)
            afterConsumed()
        end)
        return
    end

    local consumed = lib.callback.await('djdrugsv2:server:consumeDrug', false, itemName)
    if not consumed then
        Effects.busy = false
        Client.Notify('Could not use item', 'error')
        return
    end

    afterConsumed()
end

RegisterNetEvent('djdrugsv2:client:tryUseDrug', function(itemName)
    Effects.TryUse(itemName, nil)
end)

exports('useDrug', function(data, slot)
    if not data or not data.name then return end
    Effects.TryUse(data.name, data)
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    Effects.Clear()
end)

CreateThread(function()
    Wait(1500)
    Utils.Debug(('effects ready — use export "%s.useDrug"'):format(GetCurrentResourceName()))
end)
