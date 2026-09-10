Client = {
    spawnedProps = {},
    harvestZones = {},
    processZones = {},
    storeZones = {},
    machineZones = {},
    blips = {},
    propPositions = {}, -- spotId -> { [entityKey] = vec3 }
}

function Client.Notify(description, nType)
    lib.notify({
        title = Config.Brand or 'Rebel Roleplay',
        description = description,
        type = nType or 'inform',
    })
end

function Client.Progress(label, duration, anim)
    local opts = {
        duration = duration,
        label = label,
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = Config.ProgressCancelOnMove,
            car = true,
            combat = true,
        },
    }

    if anim and anim.dict and anim.clip then
        opts.anim = {
            dict = anim.dict,
            clip = anim.clip,
            flag = anim.flag or 49,
        }
    end

    return lib.progressBar(opts)
end

function Client.AddBlip(coords, data)
    if not data or not data.enabled then return end
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, data.sprite or 1)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, data.scale or 0.7)
    SetBlipColour(blip, data.color or 3)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(data.label or 'Drug Spot')
    EndTextCommandSetBlipName(blip)
    Client.blips[#Client.blips + 1] = blip
    return blip
end

function Client.LoadModel(model)
    local hash = type(model) == 'number' and model or joaat(model)
    if not IsModelInCdimage(hash) and not IsModelValid(hash) then
        Utils.Debug('invalid model', tostring(model))
        return false
    end
    RequestModel(hash)
    local timeout = GetGameTimer() + 7000
    while not HasModelLoaded(hash) do
        if GetGameTimer() > timeout then
            Utils.Debug('model load timeout', tostring(model))
            return false
        end
        Wait(10)
    end
    return hash
end

--- Snap coords to ground level
---@param coords vector3
---@return vector3
function Client.GetGroundCoords(coords)
    local x, y, z = coords.x, coords.y, coords.z
    RequestCollisionAtCoord(x, y, z)
    local timeout = GetGameTimer() + 1200
    while GetGameTimer() < timeout do
        RequestCollisionAtCoord(x, y, z)
        local found, groundZ = GetGroundZFor_3dCoord(x, y, z + 80.0, false)
        if found then
            return vec3(x, y, groundZ)
        end
        Wait(0)
    end
    local found, groundZ = GetGroundZFor_3dCoord(x, y, z + 200.0, false)
    if found then
        z = groundZ
    end
    return vec3(x, y, z)
end

---@param model number|string
---@param coords vector3
---@param heading number|nil
---@param placeOnGround boolean|nil
function Client.SpawnProp(model, coords, heading, placeOnGround)
    local hash = Client.LoadModel(model)
    if not hash then return nil end

    local pos = coords
    if placeOnGround ~= false then
        pos = Client.GetGroundCoords(coords)
    end

    local obj = CreateObjectNoOffset(hash, pos.x, pos.y, pos.z, false, false, false)
    if not obj or obj == 0 then
        SetModelAsNoLongerNeeded(hash)
        return nil
    end
    SetEntityHeading(obj, heading or 0.0)

    if placeOnGround ~= false then
        PlaceObjectOnGroundProperly(obj)
        local finalCoords = GetEntityCoords(obj)
        local found, groundZ = GetGroundZFor_3dCoord(finalCoords.x, finalCoords.y, finalCoords.z + 4.0, false)
        if found then
            SetEntityCoordsNoOffset(obj, finalCoords.x, finalCoords.y, groundZ, false, false, false)
            PlaceObjectOnGroundProperly(obj)
        end
    end

    FreezeEntityPosition(obj, true)
    SetEntityAsMissionEntity(obj, true, true)
    SetEntityCollision(obj, true, true)
    SetEntityInvincible(obj, true)
    SetModelAsNoLongerNeeded(hash)

    Client.spawnedProps[#Client.spawnedProps + 1] = obj
    return obj
end

function Client.SpawnLocalPed(model, coords, heading, extra)
    extra = extra or {}
    local hash = Client.LoadModel(model)
    if not hash then return nil end

    local pos = coords
    if extra.placeOnGround ~= false then
        pos = Client.GetGroundCoords(coords)
    end

    local ped = CreatePed(4, hash, pos.x, pos.y, pos.z, heading or 0.0, false, true)
    SetModelAsNoLongerNeeded(hash)
    if not ped or ped == 0 or not DoesEntityExist(ped) then
        return nil
    end

    SetEntityAsMissionEntity(ped, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedFleeAttributes(ped, 0, false)
    SetPedCanRagdollFromPlayerImpact(ped, false)
    SetPedCanBeTargetted(ped, false)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    SetPedDiesWhenInjured(ped, false)
    SetPedKeepTask(ped, true)

    if extra.scenario then
        TaskStartScenarioInPlace(ped, extra.scenario, 0, true)
    end

    Client.spawnedProps[#Client.spawnedProps + 1] = ped
    return ped
end

function Client.SpawnTargetPed(model, coords, heading, options, extra)
    extra = extra or {}
    local ped = Client.SpawnLocalPed(model, coords, heading, extra)
    if not ped then return nil end
    Client.AttachOxTarget(ped, options)
    return ped
end

function Client.DrawText3D(coords, text)
    if not coords or not text then return end
    SetDrawOrigin(coords.x, coords.y, coords.z, 0)
    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(true)
    SetTextColour(255, 255, 255, 220)
    SetTextCentre(true)
    SetTextDropshadow(1, 0, 0, 0, 180)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

--- Make a ped speak a line (3D text over their head + GTA ambient speech).
function Client.PedSay(ped, text, speech)
    if not ped or ped == 0 or not DoesEntityExist(ped) or not text or text == '' then
        return
    end

    if speech and speech ~= '' then
        pcall(function()
            PlayPedAmbientSpeechNative(ped, speech, 'SPEECH_PARAMS_FORCE_NORMAL')
        end)
    end

    CreateThread(function()
        local untilTime = GetGameTimer() + 3200
        while GetGameTimer() < untilTime and DoesEntityExist(ped) do
            local c = GetEntityCoords(ped)
            Client.DrawText3D(vec3(c.x, c.y, c.z + 1.05), text)
            Wait(0)
        end
    end)
end

--- Force-delete a local harvest/process prop or ped (hide first so it never "sticks").
function Client.DeleteProp(entity)
    if not entity or entity == 0 then return end

    if Client.DetachOxTarget then
        Client.DetachOxTarget(entity)
    end
    if Client.DetachInteract then
        Client.DetachInteract(entity)
    elseif not Client.DetachOxTarget then
        pcall(function()
            exports.ox_target:removeLocalEntity(entity)
        end)
    end

    if DoesEntityExist(entity) then
        SetEntityAsMissionEntity(entity, true, true)
        FreezeEntityPosition(entity, false)
        SetEntityCollision(entity, false, false)
        SetEntityAlpha(entity, 0, false)
        SetEntityVisible(entity, false, false)
        if IsPed(entity) then
            DeletePed(entity)
        else
            DeleteObject(entity)
        end
        if DoesEntityExist(entity) then
            DeleteEntity(entity)
        end
    end

    for i = #Client.spawnedProps, 1, -1 do
        if Client.spawnedProps[i] == entity then
            table.remove(Client.spawnedProps, i)
        end
    end
end

---@param model number|string
---@param coords vector3
---@param heading number|nil
---@param options table
---@param placeOnGround boolean|nil
function Client.SpawnTargetProp(model, coords, heading, options, placeOnGround, extra)
    local obj = Client.SpawnProp(model, coords, heading, placeOnGround)
    if not obj then return nil end
    if Client.AttachInteract then
        Client.AttachInteract(obj, options, extra)
    else
        exports.ox_target:addLocalEntity(obj, options)
    end
    return obj
end

local function cleanup()
    Harvest.running = false
    for i = 1, #Client.spawnedProps do
        local ent = Client.spawnedProps[i]
        if DoesEntityExist(ent) then
            pcall(function()
                if Client.DetachInteract then
                    Client.DetachInteract(ent)
                else
                    exports.ox_target:removeLocalEntity(ent)
                end
            end)
            DeleteEntity(ent)
        end
    end
    Client.spawnedProps = {}
    Client.propPositions = {}

    if Client.coordInteractions then
        for id in pairs(Client.coordInteractions) do
            Client.RemoveCoordInteract(id)
        end
    end

    for i = 1, #Client.blips do
        if DoesBlipExist(Client.blips[i]) then
            RemoveBlip(Client.blips[i])
        end
    end
    Client.blips = {}
end

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    cleanup()
    if Trap and Trap.Stop then
        Trap.Stop(true)
    end
    if Bulk and Bulk.Clear then
        Bulk.Clear(true)
    end
    if NUI then
        NUI.CloseAll()
    end
end)

CreateThread(function()
    Wait(500)
    Harvest.Init()
    Process.Init()
    Sell.Init()
    if Bulk and Bulk.Init then
        Bulk.Init()
    end
    Utils.Debug('client ready (qbx) — Rebel Roleplay theme')
end)
