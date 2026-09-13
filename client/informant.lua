InformantUI = {}

local intelBlips = {}

local function clearIntelBlips()
    for id, blip in pairs(intelBlips) do
        if blip and DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
        intelBlips[id] = nil
    end
end

local function addIntelBlip(entry)
    if not entry or not entry.coords or intelBlips[entry.id] then return end
    local blip = AddBlipForCoord(entry.coords.x, entry.coords.y, entry.coords.z)
    SetBlipSprite(blip, 162)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, 5)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(entry.label or 'Drug mark')
    EndTextCommandSetBlipName(blip)
    intelBlips[entry.id] = blip
end

local function applyMarks(list, setWaypoint)
    if type(list) ~= 'table' then return end
    for i = 1, #list do
        addIntelBlip(list[i])
    end
    if setWaypoint and list[1] and list[1].coords then
        SetNewWaypoint(list[1].coords.x, list[1].coords.y)
    end
end

local function refreshIntel()
    local data = lib.callback.await('djdrugsv2:server:getIntel', false)
    if not data then return nil end
    applyMarks(data.revealed, false)
    return data
end

local function buy(mode)
    if not Client.BeginAction() then return end
    local ok, message, marks = lib.callback.await('djdrugsv2:server:buyIntel', false, mode)
    Client.EndAction()
    if ok then
        Client.Notify(message or 'Marked.', 'success')
        applyMarks(marks, true)
    else
        Client.Notify(message or 'Not happening', 'error')
    end
end

local function openMenu()
    local data = refreshIntel()
    if not data then
        Client.Notify('Intel is closed', 'error')
        return
    end

    local options = {
        {
            title = 'Buy one location',
            description = ('%s  ·  %s left  ·  1 hour cooldown'):format(
                Utils.FormatMoney(data.singlePrice or 75000),
                data.remaining or 0
            ),
            icon = 'map-pin',
            disabled = (data.remaining or 0) <= 0 or (data.cooldown or 0) > 0,
            onSelect = function()
                buy('one')
            end,
        },
    }

    if data.tourDone then
        options[#options + 1] = {
            title = 'Buy all unlocked locations',
            description = ('%s  ·  $75k each remaining mark'):format(Utils.FormatMoney(data.allPrice or 75000)),
            icon = 'map',
            disabled = (data.cooldown or 0) > 0,
            onSelect = function()
                buy('all')
            end,
        }
    else
        options[#options + 1] = {
            title = 'Full book locked',
            description = 'Buy each mark once. Then I sell the whole book.',
            icon = 'lock',
            disabled = true,
        }
    end

    if (data.cooldown or 0) > 0 then
        options[#options + 1] = {
            title = ('Cooldown: %s min'):format(math.ceil(data.cooldown / 60)),
            icon = 'clock',
            disabled = true,
        }
    end

    lib.registerContext({
        id = 'djdrugsv2_informant',
        title = 'Street Intel',
        options = options,
    })
    lib.showContext('djdrugsv2_informant')
end

function InformantUI.Init()
    local info = Config.Informant
    if not info or info.enabled == false or not info.coords then return end

    Client.AddBlip(info.coords, info.blip)

    local ground = Client.GetGroundCoords(info.coords)
    local options = {
        {
            name = 'djdrugsv2_informant',
            icon = 'fa-solid fa-map',
            label = info.label or 'Ask about a stash',
            distance = Config.InteractDistance,
            onSelect = openMenu,
        },
    }

    local ped = Client.SpawnTargetPed(info.model or `g_m_m_chiboss_01`, ground, info.heading or 0.0, options, {
        scenario = info.scenario or 'WORLD_HUMAN_SMOKING',
        placeOnGround = true,
        useInteract = true,
        id = 'djdrugsv2_informant',
        offset = vec3(0.0, 0.0, 1.0),
        interactDst = Config.InteractDistance or 1.5,
    })
    if not ped then
        Client.AddCoordInteract({
            id = 'djdrugsv2_informant',
            coords = ground,
            label = info.label or 'Ask about a stash',
            onSelect = openMenu,
        })
    end

    refreshIntel()
end

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    clearIntelBlips()
end)

CreateThread(function()
    Wait(800)
    InformantUI.Init()
end)
