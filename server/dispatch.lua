-- Snitch alerts for /trap and bulk drops.
-- Wasabi MDT must be created from a trusted SERVER resource. The client
-- CreateDispatch export rejects anyone who cannot open the MDT, and the
-- snitch is a civilian dealer — so that path always fails.
-- If wasabi_mdt is started we use it and skip ps-dispatch (Wasabi can also
-- mirror the call into ps-dispatch itself). Otherwise the client falls back.

local function resourceStarted(name)
    return name and name ~= '' and GetResourceState(name) == 'started'
end

local function playerCoords(src)
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then
        return nil
    end
    return GetEntityCoords(ped)
end

local function describeSale(payload, cfg)
    local qty = tonumber(payload.quantity) or 0
    local label = payload.label or payload.item or 'drugs'
    local kind = payload.kind or 'street'
    if qty > 0 then
        if kind == 'bulk' then
            return ('A civilian reported a warehouse drug drop (%sx %s).'):format(qty, label)
        end
        return ('A civilian reported a street drug sale (%sx %s).'):format(qty, label)
    end
    return cfg.description or 'A civilian reported a street drug sale.'
end

local function saleLocation(payload)
    if payload.location and payload.location ~= '' then
        return payload.location
    end
    if (payload.kind or 'street') == 'bulk' then
        return 'Reported warehouse drop'
    end
    return 'Reported street sale'
end

local function tryWasabi(data)
    if not resourceStarted('wasabi_mdt') then
        return false
    end

    local ok, result = pcall(function()
        return exports.wasabi_mdt:CreateDispatch({
            type = data.type,
            title = data.title,
            description = data.description,
            location = data.location,
            coords = data.coords,
            priority = data.priority,
            code = data.code,
            senderName = data.senderName,
        })
    end)

    if not ok then
        Utils.Debug('wasabi_mdt CreateDispatch error', result)
        return false
    end
    if not result then
        Utils.Debug('wasabi_mdt CreateDispatch returned false (dispatch module unavailable)')
        return false
    end
    return true
end

--- Ping LEO after a snitched sale. Always notifies the seller; only one
--- dispatch system is used so Wasabi + ps-dispatch do not double-alert.
function Server.AlertDrugSale(src, payload)
    payload = payload or {}
    local cfg = Config.Dispatch or {}
    if cfg.enabled == false then
        return false
    end

    local description = describeSale(payload, cfg)
    local location = saleLocation(payload)
    local coords = playerCoords(src)
    local usedWasabi = tryWasabi({
        type = cfg.dispatchType or 'disturbance',
        title = cfg.title or 'Drug Sale',
        description = description,
        location = location,
        coords = coords,
        priority = tonumber(cfg.priority) or 3,
        code = cfg.code or '10-66',
        senderName = cfg.senderName or 'Anonymous tip',
    })

    TriggerClientEvent('djdrugsv2:client:badSell', src, {
        label = payload.label,
        item = payload.item,
        quantity = payload.quantity,
        kind = payload.kind,
        description = description,
        location = location,
        code = cfg.code or '10-66',
        wasabi = usedWasabi,
    })
    return true
end
