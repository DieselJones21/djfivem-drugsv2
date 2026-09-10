Bulk = {
    job = nil,
    crate = nil,
    blip = nil,
}

local INTERACT_ID = 'djdrugsv2_bulk_drop'

local function cfg()
    return Config.BulkSell or {}
end

local function clearWorld()
    Client.RemoveCoordInteract(INTERACT_ID)
    if Bulk.crate then
        Client.DeleteProp(Bulk.crate)
        Bulk.crate = nil
    end
    if Bulk.blip and DoesBlipExist(Bulk.blip) then
        RemoveBlip(Bulk.blip)
        Bulk.blip = nil
    end
    SetWaypointOff()
end

local function setHud(job)
    if NUI and NUI.Send then
        NUI.Send('updateBulk', job)
    end
end

function Bulk.Clear(silent)
    Bulk.job = nil
    clearWorld()
    setHud(nil)
    if not silent then
        Client.Notify('Bulk order cleared', 'inform')
    end
end

local function spawnDrop(job)
    clearWorld()
    local coords = vec3(job.coords.x, job.coords.y, job.coords.z)
    local ground = Client.GetGroundCoords(coords)

    local blipCfg = cfg().blip or {}
    if blipCfg.enabled ~= false then
        local blip = AddBlipForCoord(ground.x, ground.y, ground.z)
        SetBlipSprite(blip, blipCfg.sprite or 478)
        SetBlipColour(blip, blipCfg.color or 1)
        SetBlipScale(blip, blipCfg.scale or 0.9)
        SetBlipRoute(blip, blipCfg.route ~= false)
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(blipCfg.label or job.locationLabel or 'Bulk Drop')
        EndTextCommandSetBlipName(blip)
        Bulk.blip = blip
    end

    SetNewWaypoint(ground.x, ground.y)

    local model = cfg().crateModel or `prop_box_wood02a`
    Bulk.crate = Client.SpawnProp(model, ground, 0.0, true)

    local label = ('Deliver %sx %s'):format(job.quantity, job.label)
    if Bulk.crate then
        Client.AttachInteract(Bulk.crate, {
            {
                name = 'djdrugsv2_bulk_crate',
                icon = 'fa-solid fa-box',
                label = label,
                distance = cfg().interactDistance or 2.2,
                onSelect = function()
                    Bulk.TryDeliver()
                end,
            },
        }, {
            id = 'djdrugsv2_bulk_crate',
            offset = vec3(0.0, 0.0, 0.55),
            ignoreLos = true,
            interactDst = cfg().interactDistance or 2.2,
        })
    else
        Client.AddCoordInteract({
            id = INTERACT_ID,
            coords = ground,
            label = label,
            onSelect = function()
                Bulk.TryDeliver()
            end,
        })
    end
end

function Bulk.ApplyJob(job)
    if not job then
        Bulk.Clear(true)
        return
    end
    Bulk.job = job
    spawnDrop(job)
    setHud(job)
end

function Bulk.TryDeliver()
    local job = Bulk.job
    if not job then
        Client.Notify('No bulk order active', 'error')
        return
    end
    if not Client.BeginAction() then return end

    local started, durationOrReason = lib.callback.await('djdrugsv2:server:bulkDeliverStart', false, job.token)
    if not started then
        Client.Notify(durationOrReason or 'Cannot deliver', 'error')
        Client.EndAction()
        return
    end

    if not Client.Progress(('Deliver %sx %s'):format(job.quantity, job.label), durationOrReason or cfg().deliverDuration or 12000, cfg().anim) then
        Client.Notify('Cancelled', 'error')
        lib.callback.await('djdrugsv2:server:bulkDeliverCancel', false, job.token)
        Client.EndAction()
        return
    end

    local ok, message = lib.callback.await('djdrugsv2:server:completeBulk', false, job.token)
    Client.EndAction()
    if ok then
        Client.Notify(message or 'Bulk drop complete', 'success')
        Bulk.Clear(true)
    else
        Client.Notify(message or 'Delivery failed', 'error')
    end
end

function Bulk.Init()
    local bulk = cfg()
    if bulk.enabled == false then return end

    RegisterCommand(bulk.command or 'drugbulksell', function()
        if Trap and Trap.active then
            Client.Notify('Stop trapping first', 'error')
            return
        end
        if Bulk.job then
            Client.Notify(('Drop %sx %s at %s'):format(Bulk.job.quantity, Bulk.job.label, Bulk.job.locationLabel), 'inform')
            return
        end

        local existing = lib.callback.await('djdrugsv2:server:getBulkJob', false)
        if existing then
            Bulk.ApplyJob(existing)
            Client.Notify(('Drop %sx %s at %s'):format(existing.quantity, existing.label, existing.locationLabel), 'inform')
            return
        end

        local ok, jobOrReason = lib.callback.await('djdrugsv2:server:startBulk', false)
        if not ok then
            Client.Notify(type(jobOrReason) == 'string' and jobOrReason or 'Could not start a bulk order', 'error')
            return
        end

        Bulk.ApplyJob(jobOrReason)
        Client.Notify(('Bulk order: %sx %s → %s ($%s)'):format(
            jobOrReason.quantity,
            jobOrReason.label,
            jobOrReason.locationLabel,
            jobOrReason.total
        ), 'success')
    end, false)

    RegisterCommand(bulk.cancelCommand or 'drugbulkcancel', function()
        local ok, message = lib.callback.await('djdrugsv2:server:cancelBulk', false)
        if ok then
            Bulk.Clear(true)
        end
        Client.Notify(message or (ok and 'Cancelled' or 'Nothing to cancel'), ok and 'inform' or 'error')
    end, false)

    TriggerEvent('chat:addSuggestion', ('/%s'):format(bulk.command or 'drugbulksell'), bulk.description or 'Take a bulk delivery order')
    TriggerEvent('chat:addSuggestion', ('/%s'):format(bulk.cancelCommand or 'drugbulkcancel'), 'Cancel your bulk delivery order')

    CreateThread(function()
        Wait(1500)
        local job = lib.callback.await('djdrugsv2:server:getBulkJob', false)
        if job then
            Bulk.ApplyJob(job)
        end
    end)

    CreateThread(function()
        while true do
            Wait(1000)
            if Bulk.job then
                Bulk.job.remaining = math.max(0, (Bulk.job.remaining or 0) - 1)
                if Bulk.job.remaining <= 0 then
                    Client.Notify('Bulk order expired', 'error')
                    Bulk.Clear(true)
                else
                    setHud(Bulk.job)
                end
            end
        end
    end)
end
