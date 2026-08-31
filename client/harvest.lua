Harvest = {}

local cooldowns = {}

local function onCooldown(id, seconds)
    local now = GetGameTimer()
    if cooldowns[id] and cooldowns[id] > now then
        local left = math.ceil((cooldowns[id] - now) / 1000)
        Client.Notify(('Wait %s seconds'):format(left), 'error')
        return true
    end
    cooldowns[id] = now + ((seconds or 10) * 1000)
    return false
end

local function doHarvest(spot, entityKey, propCoords)
    local key = entityKey or spot.id
    if onCooldown(key, spot.cooldown) then return end

    if not Client.Progress(spot.label, spot.duration or 5000, spot.anim) then
        Client.Notify('Cancelled', 'error')
        cooldowns[key] = nil
        return
    end

    TriggerServerEvent('djdrugsv2:server:harvest', spot.id, entityKey)
end

local function registerPropPosition(spotId, entityKey, coords)
    Client.propPositions[spotId] = Client.propPositions[spotId] or {}
    Client.propPositions[spotId][entityKey] = coords
end

--- Single bench harvest spot
local function setupBench(spot)
    Client.AddBlip(spot.coords, spot.blip)

    local propData = spot.prop
    if not propData or not propData.model then
        Utils.Debug('harvest bench missing prop', spot.id)
        return
    end

    local heading = propData.heading or spot.heading or 0.0
    local placeOnGround = propData.placeOnGround
    if placeOnGround == nil then placeOnGround = true end

    local groundCoords = placeOnGround and Client.GetGroundCoords(spot.coords) or spot.coords
    registerPropPosition(spot.id, spot.id, groundCoords)

    local options = {
        {
            name = 'djdrugsv2_harvest_' .. spot.id,
            icon = 'fa-solid fa-hand',
            label = spot.label,
            distance = Config.InteractDistance,
            onSelect = function()
                doHarvest(spot, spot.id, groundCoords)
            end,
        },
    }

    Client.SpawnProp(propData.model, spot.coords, heading, placeOnGround)

    local zoneId = exports.ox_target:addBoxZone({
        coords = groundCoords,
        size = spot.size or vec3(1.6, 1.6, 2.0),
        rotation = heading,
        debug = Config.Debug,
        options = options,
    })
    Client.harvestZones[#Client.harvestZones + 1] = zoneId
end

--- Multiple props scattered in an area — walk around to harvest
local function setupPropField(spot)
    Client.AddBlip(spot.coords, spot.blip)

    local model = spot.model or (spot.prop and spot.prop.model)
    if not model then
        Utils.Debug('propField missing model', spot.id)
        return
    end

    local positions = spot.positions
    if not positions or #positions == 0 then
        -- Fallback: generate circle layout
        local count = spot.count or 6
        local radius = spot.radius or 8.0
        positions = {}
        for i = 1, count do
            local angle = (i / count) * math.pi * 2
            local dist = radius * (0.45 + (math.random() * 0.55))
            positions[i] = vec3(
                spot.coords.x + math.cos(angle) * dist,
                spot.coords.y + math.sin(angle) * dist,
                spot.coords.z
            )
        end
    end

    for i = 1, #positions do
        local rawCoords = positions[i]
        local groundCoords = Client.GetGroundCoords(rawCoords)
        local heading = (spot.heading or 0.0) + (i * 37.0)
        local entityKey = ('%s_%s'):format(spot.id, i)

        registerPropPosition(spot.id, entityKey, groundCoords)

        Client.SpawnTargetProp(model, rawCoords, heading, {
            {
                name = 'djdrugsv2_prop_' .. entityKey,
                icon = 'fa-solid fa-seedling',
                label = spot.label,
                distance = Config.InteractDistance,
                onSelect = function()
                    doHarvest(spot, entityKey, groundCoords)
                end,
            },
        }, true)
    end
end

function Harvest.Init()
    for i = 1, #Config.Harvest do
        local spot = Config.Harvest[i]
        if spot.type == 'propField' or spot.type == 'prop' then
            setupPropField(spot)
        else
            setupBench(spot)
        end
    end
end

