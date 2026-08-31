Utils = {}

local DEFAULT_FRAMEWORK_MONEY = {
    cash = true,
    bank = true,
    crypto = true,
}

function Utils.Debug(...)
    if not Config or not Config.Debug then return end
    print('[djfivem-drugsv2]', ...)
end

function Utils.IsFrameworkMoney(moneyType)
    if type(moneyType) ~= 'string' or moneyType == '' then
        return false
    end
    local configured = Config and Config.FrameworkMoneyTypes
    if type(configured) == 'table' then
        return configured[moneyType] == true
    end
    return DEFAULT_FRAMEWORK_MONEY[moneyType] == true
end

function Utils.RandomInt(min, max)
    return math.random(min, max)
end

function Utils.RandomFloat(min, max)
    return min + (math.random() * (max - min))
end

function Utils.GetDrug(drugId)
    return Config.Drugs[drugId]
end

function Utils.GetDrugByItem(itemName)
    for id, drug in pairs(Config.Drugs) do
        if drug.item == itemName then
            return id, drug
        end
    end
end

function Utils.GetSellableDrugs()
    local list = {}
    for id, drug in pairs(Config.Drugs) do
        if drug.sell and drug.sell.enabled ~= false then
            list[#list + 1] = id
        end
    end
    table.sort(list)
    return list
end

function Utils.Distance(a, b)
    return #(a - b)
end

function Utils.GetProgressLevels()
    local prog = Config and Config.Progression
    if not prog or type(prog.levels) ~= 'table' or #prog.levels == 0 then
        return {
            { level = 1, sold = 0, label = 'Runner', payoutMultiplier = 1.0 },
        }
    end
    return prog.levels
end

function Utils.GetRankForSold(sold)
    sold = tonumber(sold) or 0
    local levels = Utils.GetProgressLevels()
    local current = levels[1]
    for i = 1, #levels do
        if sold >= (levels[i].sold or 0) then
            current = levels[i]
        end
    end
    return current
end

function Utils.GetNextRank(sold)
    sold = tonumber(sold) or 0
    local levels = Utils.GetProgressLevels()
    local current = Utils.GetRankForSold(sold)
    for i = 1, #levels do
        if (levels[i].level or 0) > (current.level or 0) then
            return levels[i]
        end
    end
    return nil
end

function Utils.GetRankPayoutMultiplier(sold)
    local rank = Utils.GetRankForSold(sold)
    local mult = rank and rank.payoutMultiplier or 1
    if type(mult) ~= 'number' or mult < 1 then
        return 1
    end
    return mult
end

function Utils.FormatMoney(n)
    n = math.floor(tonumber(n) or 0)
    local s = tostring(n)
    local k
    while true do
        s, k = s:gsub('^(-?%d+)(%d%d%d)', '%1,%2')
        if k == 0 then break end
    end
    return '$' .. s
end

function Utils.FormatNumber(n)
    n = math.floor(tonumber(n) or 0)
    local s = tostring(n)
    local k
    while true do
        s, k = s:gsub('^(-?%d+)(%d%d%d)', '%1,%2')
        if k == 0 then break end
    end
    return s
end
