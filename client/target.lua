--[[
    Interaction attach — prefers darktrovx/interact (E prompt on the prop).
    Falls back to ox_target if interact is not started.
    Peds (process NPCs, a couple of ingredient dealers, street buyers) stay on ox_target.
]]

Client.interactEntities = {} -- entity -> interact id
Client.coordInteractions = {} -- id -> true
Client.actionBusy = false

local warnedMissing = false

local function targetCfg()
    return Config.Target or {}
end

function Client.HasInteract()
    local res = targetCfg().resource or 'interact'
    return GetResourceState(res) == 'started'
end

function Client.HasOxTarget()
    local res = targetCfg().fallback or 'ox_target'
    return GetResourceState(res) == 'started'
end

function Client.BeginAction()
    if Client.actionBusy then
        Client.Notify('You are already busy', 'error')
        return false
    end
    local ped = PlayerPedId()
    if IsEntityDead(ped) or IsPedFatallyInjured(ped) then
        Client.Notify('You cannot do that right now', 'error')
        return false
    end
    if IsPedInAnyVehicle(ped, false) then
        Client.Notify('Get out of the vehicle first', 'error')
        return false
    end
    Client.actionBusy = true
    return true
end

function Client.EndAction()
    Client.actionBusy = false
end

local function playerCanUse()
    local ped = PlayerPedId()
    return not Client.actionBusy
        and not IsEntityDead(ped)
        and not IsPedFatallyInjured(ped)
        and not IsPedInAnyVehicle(ped, false)
end

local function toInteractOptions(options)
    local list = {}
    for i = 1, #options do
        local opt = options[i]
        list[i] = {
            label = opt.label,
            canInteract = opt.canInteract or playerCanUse,
            action = function(entity, coords, args)
                if opt.onSelect then
                    opt.onSelect(entity, coords, args)
                end
            end,
        }
    end
    return list
end

--- ox_target only. Use this for peds so interact never attaches to them.
function Client.AttachOxTarget(entity, options)
    if not entity or entity == 0 or not DoesEntityExist(entity) then
        return false
    end
    if not Client.HasOxTarget() then
        Client.Notify('ox_target is required for this contact', 'error')
        return false
    end
    pcall(function()
        exports.ox_target:addLocalEntity(entity, options)
    end)
    return true
end

function Client.DetachOxTarget(entity)
    if not entity or not Client.HasOxTarget() then return end
    pcall(function()
        exports.ox_target:removeLocalEntity(entity)
    end)
end

function Client.AttachInteract(entity, options, extra)
    extra = extra or {}
    if not entity or entity == 0 or not DoesEntityExist(entity) then
        return nil
    end
    if not options or not options[1] then
        return nil
    end

    local id = extra.id or options[1].name or ('djdrugsv2_%s'):format(entity)
    local distance = extra.distance or targetCfg().distance or 8.0
    local interactDst = extra.interactDst or options[1].distance or targetCfg().interactDst or 1.5
    local offset = extra.offset or targetCfg().offset or vec3(0.0, 0.0, 0.45)

    Client.DetachInteract(entity, id)

    if Client.HasInteract() then
        local ok, interactId = pcall(function()
            return exports.interact:AddLocalEntityInteraction({
                entity = entity,
                id = id,
                name = extra.name or id,
                distance = distance,
                interactDst = interactDst,
                offset = offset,
                ignoreLos = extra.ignoreLos ~= false,
                options = toInteractOptions(options),
            })
        end)
        if ok then
            Client.interactEntities[entity] = interactId or id
            return interactId or id
        end
        Utils.Debug('interact AddLocalEntityInteraction failed', tostring(interactId))
    end

    if Client.HasOxTarget() then
        pcall(function()
            exports.ox_target:addLocalEntity(entity, options)
        end)
        Client.interactEntities[entity] = id
        return id
    end

    if not warnedMissing then
        warnedMissing = true
        Client.Notify('No interact resource started — props will not be usable', 'error')
    end
    return nil
end

function Client.DetachInteract(entity, id)
    if not entity then return end
    local stored = id or Client.interactEntities[entity]
    if Client.HasInteract() and stored then
        pcall(function()
            exports.interact:RemoveLocalEntityInteraction(entity, stored)
        end)
    end
    if Client.HasOxTarget() then
        pcall(function()
            exports.ox_target:removeLocalEntity(entity)
        end)
    end
    Client.interactEntities[entity] = nil
end

function Client.AddCoordInteract(data)
    if not data or not data.id or not data.coords or not data.label then
        return nil
    end
    Client.RemoveCoordInteract(data.id)

    local options = {
        {
            name = data.id,
            label = data.label,
            icon = data.icon or 'fa-solid fa-box',
            distance = data.interactDst or Config.InteractDistance or 2.2,
            canInteract = data.canInteract or playerCanUse,
            onSelect = data.onSelect,
        },
    }

    if Client.HasInteract() then
        local ok, interactId = pcall(function()
            return exports.interact:AddInteraction({
                id = data.id,
                name = data.name or data.id,
                coords = data.coords,
                distance = data.distance or targetCfg().distance or 8.0,
                interactDst = data.interactDst or targetCfg().interactDst or 1.5,
                options = toInteractOptions(options),
            })
        end)
        if ok then
            Client.coordInteractions[data.id] = true
            return interactId or data.id
        end
    end

    if Client.HasOxTarget() then
        local zoneId = exports.ox_target:addBoxZone({
            coords = data.coords,
            size = data.size or vec3(1.6, 1.6, 2.0),
            rotation = data.rotation or 0.0,
            debug = Config.Debug,
            options = options,
        })
        Client.coordInteractions[data.id] = zoneId or true
        return zoneId
    end

    return nil
end

function Client.RemoveCoordInteract(id)
    if not id then return end
    if Client.HasInteract() then
        pcall(function()
            exports.interact:RemoveInteraction(id)
        end)
    end
    local zoneId = Client.coordInteractions[id]
    if Client.HasOxTarget() and zoneId and zoneId ~= true then
        pcall(function()
            exports.ox_target:removeZone(zoneId)
        end)
    end
    Client.coordInteractions[id] = nil
end
