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
        title = Config.Brand or 'THE 305',
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
    SetBlipColour(blip, data.color or 8)
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
    local found, groundZ = GetGroundZFor_3dCoord(x, y, z + 50.0, false)
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

    local obj = CreateObject(hash, pos.x, pos.y, pos.z, false, false, false)
    SetEntityHeading(obj, heading or 0.0)

    if placeOnGround ~= false then
        PlaceObjectOnGroundProperly(obj)
        -- Double-check ground level after placement
        local finalCoords = GetEntityCoords(obj)
        local found, groundZ = GetGroundZFor_3dCoord(finalCoords.x, finalCoords.y, finalCoords.z + 2.0, false)
        if found and math.abs(finalCoords.z - groundZ) > 0.15 then
            SetEntityCoords(obj, finalCoords.x, finalCoords.y, groundZ, false, false, false, false)
            PlaceObjectOnGroundProperly(obj)
        end
    end

    FreezeEntityPosition(obj, true)
    SetEntityAsMissionEntity(obj, true, true)
    SetEntityCollision(obj, true, true)
    SetModelAsNoLongerNeeded(hash)

    Client.spawnedProps[#Client.spawnedProps + 1] = obj
    return obj
end

---@param model number|string
---@param coords vector3
---@param heading number|nil
---@param options table
---@param placeOnGround boolean|nil
function Client.SpawnTargetProp(model, coords, heading, options, placeOnGround)
    local obj = Client.SpawnProp(model, coords, heading, placeOnGround)
    if not obj then return nil end
    exports.ox_target:addLocalEntity(obj, options)
    return obj
end

local function cleanup()
    for i = 1, #Client.spawnedProps do
        local ent = Client.spawnedProps[i]
        if DoesEntityExist(ent) then
            exports.ox_target:removeLocalEntity(ent)
            DeleteEntity(ent)
        end
    end
    Client.spawnedProps = {}
    Client.propPositions = {}

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
    if NUI then
        NUI.CloseAll()
    end
end)

CreateThread(function()
    Wait(500)
    Harvest.Init()
    Process.Init()
    Sell.Init()
    Utils.Debug('client ready (qbx) — v2 Miami theme')
end)
