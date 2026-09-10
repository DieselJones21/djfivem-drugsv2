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
    if not Client.BeginAction() then return end

    local drug = Utils.GetDrug(drugId)
    if not drug or not drug.process then
        Client.EndAction()
        return
    end

    local started, durationOrReason = lib.callback.await('djdrugsv2:server:processStart', false, drugId)
    if not started then
        Client.Notify(durationOrReason or ('Missing ingredients: %s'):format(recipeText(drug)), 'error')
        Client.EndAction()
        return
    end

    local p = drug.process
    if not Client.Progress(p.label or ('Process ' .. drug.label), durationOrReason or p.duration or 10000, p.anim) then
        Client.Notify('Cancelled', 'error')
        lib.callback.await('djdrugsv2:server:processCancel', false, drugId)
        Client.EndAction()
        return
    end

    local ok, message = lib.callback.await('djdrugsv2:server:tryProcess', false, drugId)
    Client.EndAction()
    if ok then
        Client.Notify(message or ('Processed %s'):format(drug.label), 'success')
    else
        Client.Notify(message or 'Processing failed', 'error')
    end
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
            if p.ped and p.ped.model then
                local heading = p.ped.heading or p.heading or 0.0
                spawned = Client.SpawnTargetPed(p.ped.model, groundCoords, heading, options, {
                    scenario = p.ped.scenario,
                    placeOnGround = true,
                })
            elseif p.prop and p.prop.model then
                local heading = p.prop.heading or p.heading or 0.0
                local pos = groundCoords + (p.prop.offset or vec3(0.0, 0.0, 0.0))
                spawned = Client.SpawnTargetProp(p.prop.model, pos, heading, options, true, {
                    id = 'djdrugsv2_process_' .. drugId,
                    offset = vec3(0.0, 0.0, 0.6),
                    ignoreLos = true,
                    interactDst = Config.InteractDistance or 1.5,
                })
            end

            if not spawned then
                Client.AddCoordInteract({
                    id = 'djdrugsv2_process_' .. drugId,
                    coords = groundCoords,
                    label = p.label or ('Process ' .. drug.label),
                    rotation = p.rotation or p.heading or 0.0,
                    size = p.size or vec3(1.6, 1.6, 2.0),
                    onSelect = function()
                        processDrug(drugId)
                    end,
                })
            end
        end
    end
end
