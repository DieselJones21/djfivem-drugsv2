Progress = {
    stats = {},
}

local KVP_KEY = 'djdrugsv2_progress'
local dirty = false

local function loadStats()
    local raw = GetResourceKvpString(KVP_KEY)
    if not raw or raw == '' then
        Progress.stats = {}
        return
    end
    local ok, data = pcall(json.decode, raw)
    if ok and type(data) == 'table' then
        Progress.stats = data
    else
        Progress.stats = {}
        Utils.Debug('progress KVP decode failed')
    end
end

local function saveStats()
    if not dirty then return end
    SetResourceKvp(KVP_KEY, json.encode(Progress.stats))
    dirty = false
end

local function enabled()
    return Config.Progression and Config.Progression.enabled ~= false
end

function Progress.GetPayoutMultiplier(src)
    if not enabled() then return 1 end
    local char = Bridge.GetCharacter(src)
    if not char then return 1 end
    local row = Progress.stats[char.citizenid]
    return Utils.GetRankPayoutMultiplier(row and row.sold or 0)
end

function Progress.RecordSale(src, quantity, earned)
    if not enabled() then
        return false, nil
    end

    local char = Bridge.GetCharacter(src)
    if not char then
        Utils.Debug('progress skip — no citizenid', src)
        return false, nil
    end

    local row = Progress.stats[char.citizenid] or {
        name = char.name,
        sold = 0,
        earned = 0,
    }
    local before = Utils.GetRankForSold(row.sold)
    row.sold = (row.sold or 0) + (quantity or 0)
    row.earned = (row.earned or 0) + (earned or 0)
    row.name = char.name
    row.updated = os.time()
    Progress.stats[char.citizenid] = row
    dirty = true
    saveStats()

    local after = Utils.GetRankForSold(row.sold)
    local leveled = (after.level or 1) > (before.level or 1)
    return leveled, after, row
end

function Progress.GetBoard(src, limit)
    limit = limit or (Config.Progression and Config.Progression.leaderboardSize) or 10
    local list = {}
    for citizenid, row in pairs(Progress.stats) do
        list[#list + 1] = {
            citizenid = citizenid,
            name = row.name or 'Unknown',
            sold = row.sold or 0,
            earned = row.earned or 0,
        }
    end
    table.sort(list, function(a, b)
        if a.sold == b.sold then
            return a.earned > b.earned
        end
        return a.sold > b.sold
    end)

    local mine = nil
    local char = src and Bridge.GetCharacter(src)
    if char then
        for i = 1, #list do
            if list[i].citizenid == char.citizenid then
                local rank = Utils.GetRankForSold(list[i].sold)
                local nxt = Utils.GetNextRank(list[i].sold)
                mine = {
                    place = i,
                    name = list[i].name,
                    sold = list[i].sold,
                    earned = list[i].earned,
                    level = rank.level,
                    label = rank.label,
                    payoutMultiplier = rank.payoutMultiplier or 1,
                    nextSold = nxt and nxt.sold or nil,
                    nextLabel = nxt and nxt.label or nil,
                    remaining = nxt and math.max(0, nxt.sold - list[i].sold) or 0,
                    maxed = nxt == nil,
                }
                break
            end
        end
        if not mine then
            local rank = Utils.GetRankForSold(0)
            local nxt = Utils.GetNextRank(0)
            mine = {
                place = nil,
                name = char.name,
                sold = 0,
                earned = 0,
                level = rank.level,
                label = rank.label,
                payoutMultiplier = rank.payoutMultiplier or 1,
                nextSold = nxt and nxt.sold or nil,
                nextLabel = nxt and nxt.label or nil,
                remaining = nxt and nxt.sold or 0,
                maxed = nxt == nil,
            }
        end
    end

    local top = {}
    for i = 1, math.min(limit, #list) do
        local rank = Utils.GetRankForSold(list[i].sold)
        top[i] = {
            place = i,
            name = list[i].name,
            sold = list[i].sold,
            earned = list[i].earned,
            level = rank.level,
            label = rank.label,
        }
    end

    return {
        mine = mine,
        top = top,
        totalSellers = #list,
    }
end

lib.callback.register('djdrugsv2:server:getProgressBoard', function(source)
    if not enabled() then
        return nil
    end
    return Progress.GetBoard(source)
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    saveStats()
end)

CreateThread(function()
    loadStats()
    Utils.Debug('progress loaded')
end)
