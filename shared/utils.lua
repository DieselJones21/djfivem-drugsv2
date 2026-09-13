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

local drugByItem
local drugsUsingItem

local function rebuildDrugIndex()
    drugByItem = {}
    drugsUsingItem = {}
    if not Config or not Config.Drugs then return end
    for id, drug in pairs(Config.Drugs) do
        if drug.item then
            drugByItem[drug.item] = { id = id, drug = drug }
        end
        local ings = drug.ingredients or {}
        for i = 1, #ings do
            local item = ings[i].item
            if item then
                local bucket = drugsUsingItem[item]
                if not bucket then
                    bucket = {}
                    drugsUsingItem[item] = bucket
                end
                bucket[#bucket + 1] = id
            end
        end
    end
end

function Utils.GetDrug(drugId)
    return Config.Drugs[drugId]
end

function Utils.GetDrugByItem(itemName)
    if not drugByItem then rebuildDrugIndex() end
    local row = drugByItem and drugByItem[itemName]
    if not row then return nil end
    return row.id, row.drug
end

function Utils.GetDrugsUsingItem(itemName)
    if not drugsUsingItem then rebuildDrugIndex() end
    return (drugsUsingItem and drugsUsingItem[itemName]) or {}
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

function Utils.GetDrugMinLevel(drug)
    if type(drug) == 'string' then
        drug = Utils.GetDrug(drug)
    end
    return math.max(1, math.floor(tonumber(drug and drug.minLevel) or 1))
end

function Utils.CanAccessDrug(sold, drugOrId)
    local drug = type(drugOrId) == 'string' and Utils.GetDrug(drugOrId) or drugOrId
    if not drug then return false end
    local rank = Utils.GetRankForSold(sold)
    return (rank.level or 1) >= Utils.GetDrugMinLevel(drug)
end

function Utils.CanAccessHarvestItem(sold, itemName)
    if not itemName then return false end
    local lace = Config.Lace and Config.Lace.item
    if lace and itemName == lace then
        return true
    end
    local users = Utils.GetDrugsUsingItem(itemName)
    if #users == 0 then
        return true
    end
    for i = 1, #users do
        if Utils.CanAccessDrug(sold, users[i]) then
            return true
        end
    end
    return false
end

function Utils.IsWeedHarvest(spot)
    return spot and (spot.weed == true or spot.plant == true)
end

function Utils.RecipeSignature(drug)
    if not drug or not drug.ingredients then return '' end
    local parts = {}
    for i = 1, #drug.ingredients do
        local ing = drug.ingredients[i]
        parts[#parts + 1] = ('%s:%s'):format(ing.item or '?', tonumber(ing.amount) or 0)
    end
    table.sort(parts)
    return table.concat(parts, '|')
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

--- Bulk drop pays a cut of street minPrice (easier than trapping).
function Utils.GetBulkPriceEach(drug, rankMult)
    if not drug or not drug.sell then return 0 end
    local bulk = Config.BulkSell or {}
    local pct = tonumber(bulk.pricePercent) or 0.55
    if pct < 0.1 then pct = 0.1 end
    if pct > 0.95 then pct = 0.95 end
    local base = math.floor(((drug.sell.minPrice or 0) * pct) + 0.5)
    if bulk.rankApplies ~= false then
        local rank = tonumber(rankMult) or 1
        if rank > 1 then
            base = math.floor((base * rank) + 0.5)
        end
    end
    local streetMin = drug.sell.minPrice or 0
    if base >= streetMin and streetMin > 0 then
        base = math.max(1, streetMin - 1)
    end
    return math.max(1, base)
end

function Utils.GetLaceConfig()
    return Config.Lace or {}
end

function Utils.GetLaceNeed(quantity)
    local lace = Utils.GetLaceConfig()
    local per = math.max(1, math.floor(tonumber(lace.perUnit) or 1))
    return math.max(1, math.floor((tonumber(quantity) or 1) * per))
end

function Utils.ApplyLacePrice(amount, laced)
    amount = math.floor(tonumber(amount) or 0)
    if not laced then return amount end
    local pct = tonumber(Utils.GetLaceConfig().pricePercent) or 0.35
    if pct < 0 then pct = 0 end
    if pct > 1 then pct = 1 end
    return math.max(1, math.floor(amount * (1 + pct) + 0.5))
end

function Utils.RecipeInputTotal(drug)
    if not drug or not drug.ingredients then return 0 end
    local n = 0
    for i = 1, #drug.ingredients do
        n = n + (tonumber(drug.ingredients[i].amount) or 0)
    end
    return n
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
