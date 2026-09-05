Harvest = {}

local cooldowns = {}
local fields = {} -- spotId -> { spot, spawned = { [index] = entityKey }, entities = { [entityKey] = rec } }

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

local function shuffle(list)
    for i = #list, 2, -1 do
        local j = math.random(1, i)
        list[i], list[j] = list[j], list[i]
    end
    return list
end

local function registerPropPosition(spotId, entityKey, coords)
    Client.propPositions[spotId] = Client.propPositions[spotId] or {}
    Client.propPositions[spotId][entityKey] = coords
end

local function destroyEntity(entity)
    if entity and DoesEntityExist(entity) then
        exports.ox_target:removeLocalEntity(entity)
        DeleteEntity(entity)
    end
end

local function spawnFieldProp(spot, index)
    local state = fields[spot.id]
    if not state or not spot.positions or not spot.positions[index] then return end
    if state.spawned[index] then return end

    local model = spot.model or (spot.prop and spot.prop.model)
    local rawCoords = spot.positions[index]
    local groundCoords = Client.GetGroundCoords(rawCoords)
    local heading = (spot.heading or 0.0) + (index * 37.0)
    local entityKey = ('%s_%s'):format(spot.id, index)

    local obj = Client.SpawnTargetProp(model, groundCoords, heading, {
        {
            name = 'djdrugsv2_prop_' .. entityKey,
            icon = spot.plant and 'fa-solid fa-seedling' or 'fa-solid fa-hand',
            label = spot.label,
            distance = Config.InteractDistance,
            onSelect = function()
                Harvest.TryCollect(spot, entityKey)
            end,
        },
    }, true)

    if not obj then return end

    local placed = GetEntityCoords(obj)
    registerPropPosition(spot.id, entityKey, placed)

    state.spawned[index] = entityKey
    state.entities[entityKey] = {
        entity = obj,
        index = index,
        coords = placed,
    }
end

local function despawnFieldProp(spot, entityKey)
    local state = fields[spot.id]
    if not state then return end
    local rec = state.entities[entityKey]
    if not rec then return end

    destroyEntity(rec.entity)
    state.entities[entityKey] = nil
    state.spawned[rec.index] = nil
    if Client.propPositions[spot.id] then
        Client.propPositions[spot.id][entityKey] = nil
    end
end

local function unusedIndices(spot)
    local state = fields[spot.id]
    local free = {}
    for i = 1, #spot.positions do
        if not state.spawned[i] then
            free[#free + 1] = i
        end
    end
    return free
end

function Harvest.Relocate(spot, entityKey)
    if not spot or not spot.positions or #spot.positions == 0 then return end
    despawnFieldProp(spot, entityKey)

    local free = unusedIndices(spot)
    if #free == 0 then
        return
    end
    spawnFieldProp(spot, free[math.random(1, #free)])
end

function Harvest.TryCollect(spot, entityKey)
    local key = entityKey or spot.id
    if onCooldown(key, spot.cooldown) then return end

    if not Client.Progress(spot.label, spot.duration or 5000, spot.anim) then
        Client.Notify('Cancelled', 'error')
        cooldowns[key] = nil
        return
    end

    local ok = lib.callback.await('djdrugsv2:server:tryHarvest', false, spot.id, entityKey)
    if not ok then
        cooldowns[key] = nil
        return
    end

    if spot.clientUnique ~= false then
        Harvest.Relocate(spot, entityKey)
    end
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
                Harvest.TryCollect(spot, spot.id)
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

--- Per-player subset of a position pool. Harvest despawns that prop and grows another in a free slot.
local function setupPropField(spot)
    Client.AddBlip(spot.coords, spot.blip)

    local model = spot.model or (spot.prop and spot.prop.model)
    if not model then
        Utils.Debug('propField missing model', spot.id)
        return
    end

    local positions = spot.positions
    if not positions or #positions == 0 then
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
        spot.positions = positions
    end

    fields[spot.id] = { spot = spot, spawned = {}, entities = {} }

    local pool = {}
    for i = 1, #positions do
        pool[i] = i
    end
    shuffle(pool)

    local visible = math.min(spot.visibleCount or 6, #pool)
    for n = 1, visible do
        spawnFieldProp(spot, pool[n])
    end
end

function Harvest.Init()
    math.randomseed(GetGameTimer() + (PlayerId() * 7919))
    for i = 1, #Config.Harvest do
        local spot = Config.Harvest[i]
        if spot.type == 'propField' or spot.type == 'prop' then
            setupPropField(spot)
        else
            setupBench(spot)
        end
    end
end
