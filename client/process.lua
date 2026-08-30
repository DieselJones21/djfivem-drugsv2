Process = {}

local function recipeText(drug)
    local parts = {}
    for i = 1, #drug.ingredients do
        local ing = drug.ingredients[i]
        parts[#parts + 1] = ('%sx %s'):format(ing.amount, ing.item)
    end
    return table.concat(parts, ', ')
end

local function processDrug(drugId)
    local drug = Utils.GetDrug(drugId)
    if not drug or not drug.process then return end

    local hasItems = lib.callback.await('djdrugsv2:server:canProcess', false, drugId)
    if not hasItems then
        Client.Notify(('Missing ingredients: %s'):format(recipeText(drug)), 'error')
        return
    end

    local p = drug.process
    if not Client.Progress(p.label or ('Process ' .. drug.label), p.duration or 10000, p.anim) then
        Client.Notify('Cancelled', 'error')
        return
    end

    TriggerServerEvent('djdrugsv2:server:process', drugId)
end

function Process.Init()
    for drugId, drug in pairs(Config.Drugs) do
        local p = drug.process
        if p and p.coords then
            Client.AddBlip(p.coords, p.blip)

            local groundCoords = Client.GetGroundCoords(p.coords)
            local options = {
                {
                    name = 'djdrugsv2_process_' .. drugId,
                    icon = 'fa-solid fa-flask',
                    label = p.label or ('Process ' .. drug.label),
                    distance = Config.InteractDistance,
                    onSelect = function()
                        processDrug(drugId)
                    end,
                },
            }

            local spawned = nil
            if p.prop and p.prop.model then
                local heading = p.prop.heading or p.heading or 0.0
                local pos = groundCoords + (p.prop.offset or vec3(0.0, 0.0, 0.0))
                spawned = Client.SpawnTargetProp(p.prop.model, pos, heading, options, true)
            end

            if not spawned then
                local zoneId = exports.ox_target:addBoxZone({
                    coords = groundCoords,
                    size = p.size or vec3(1.6, 1.6, 2.0),
                    rotation = p.rotation or p.heading or 0.0,
                    debug = Config.Debug,
                    options = options,
                })
                Client.processZones[#Client.processZones + 1] = zoneId
            end
        end
    end
end
