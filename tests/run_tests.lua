--[[
    Unit tests for djfivem-drugsv2 config validation.
    Run: lua tests/run_tests.lua
]]

local passed = 0
local failed = 0

local function assert_eq(a, b, msg)
    if a ~= b then
        failed = failed + 1
        print(('FAIL: %s — expected %s, got %s'):format(msg, tostring(b), tostring(a)))
        return false
    end
    passed = passed + 1
    return true
end

local function assert_true(v, msg)
    if not v then
        failed = failed + 1
        print(('FAIL: %s'):format(msg))
        return false
    end
    passed = passed + 1
    return true
end

-- Load config
dofile('shared/utils.lua')
dofile('config/config.lua')
dofile('config/drugs.lua')

print('=== djfivem-drugsv2 tests ===\n')

assert_eq(Config.Brand, 'Envy Roleplay', 'brand is Envy Roleplay')

local drugCount = 0
for _ in pairs(Config.Drugs) do drugCount = drugCount + 1 end
assert_eq(drugCount, 10, 'should have exactly 10 drugs')
assert_true(Config.Drugs.perico_gold ~= nil, 'includes perico_gold')

for drugId, drug in pairs(Config.Drugs) do
    assert_true(drug.label ~= nil, drugId .. ' has label')
    assert_true(drug.item ~= nil, drugId .. ' has item')
    assert_true(drug.ingredients and #drug.ingredients > 0, drugId .. ' has ingredients')
    assert_true(drug.process and drug.process.coords, drugId .. ' has process coords')
    assert_true(drug.process.prop and drug.process.prop.model, drugId .. ' has process prop')
    assert_true(drug.sell and drug.sell.enabled ~= false, drugId .. ' is sellable')
    assert_true(drug.effects and drug.effects.enabled ~= false, drugId .. ' has effects')
    assert_true(drug.sell.minPrice and drug.sell.maxPrice and drug.sell.maxPrice >= drug.sell.minPrice, drugId .. ' has valid payout range')
    assert_true(drug.sell.minQty and drug.sell.maxQty and drug.sell.maxQty >= drug.sell.minQty, drugId .. ' has valid qty range')
end

local perico = Config.Drugs.perico_gold
assert_true(perico.sell.minPrice >= 1500, 'perico_gold has premium pricing')
assert_true(perico.effects.noScreenFx == true, 'perico_gold has no screen FX')
assert_true((perico.effects.armorPercent or 0) >= 40, 'perico_gold grants armor')

local cashDrugs = { lone_star_kush = true, hill_country_haze = true }
assert_eq(Config.Drugs.lone_star_kush.sell.moneyType, 'cash', 'lone_star_kush pays cash')
assert_eq(Config.Drugs.hill_country_haze.sell.moneyType, 'cash', 'hill_country_haze pays cash')

for drugId, drug in pairs(Config.Drugs) do
    if cashDrugs[drugId] then
        assert_eq(drug.sell.moneyType, 'cash', drugId .. ' pays cash')
    else
        assert_eq(drug.sell.moneyType, 'black_money', drugId .. ' pays black_money')
    end
end

local clean = { 'lone_star_kush', 'hill_country_haze', 'purple_drank', 'rig_juice', 'perico_gold' }
for _, id in ipairs(clean) do
    assert_true(Config.Drugs[id].effects.noScreenFx == true, id .. ' is marked noScreenFx')
end

local runners = { 'hill_country_haze', 'houston_snow', 'west_texas_ice', 'sixth_street_rolls', 'rig_juice', 'panhandle_dust' }
for _, id in ipairs(runners) do
    assert_true((Config.Drugs[id].effects.sprintMultiplier or 1) > 1, id .. ' boosts sprint')
end

local armor = { 'houston_snow', 'border_brick', 'rig_juice', 'perico_gold' }
for _, id in ipairs(armor) do
    assert_true((Config.Drugs[id].effects.armorPercent or 0) > 0, id .. ' grants armor')
end

local propFieldCount = 0
local totalProps = 0
local plantFields = 0
for i = 1, #Config.Harvest do
    local spot = Config.Harvest[i]
    if spot.type == 'propField' then
        propFieldCount = propFieldCount + 1
        assert_true(spot.positions and #spot.positions >= 4, spot.id .. ' has 4+ prop positions')
        assert_true((spot.visibleCount or 0) >= 1, spot.id .. ' has visibleCount')
        totalProps = totalProps + #spot.positions
        if spot.plant then plantFields = plantFields + 1 end
    end
end
assert_true(propFieldCount >= 20, 'most harvest spots are propField type')
assert_true(plantFields >= 3, 'plant fields exist for client-side relocate')
print(('  Harvest fields: %d propField spots, %d pool props, %d plant fields'):format(propFieldCount, totalProps, plantFields))

local levels = Utils.GetProgressLevels()
assert_eq(#levels, 5, '5 progression ranks')
assert_eq(levels[1].label, 'Ranch Hand', 'first rank is Ranch Hand')
assert_eq(levels[5].label, 'Envy Kingpin', 'max rank is Envy Kingpin')

local rank = Utils.GetRankForSold(0)
assert_eq(rank.label, 'Ranch Hand', '0 sold = Ranch Hand')
rank = Utils.GetRankForSold(250)
assert_eq(rank.label, 'Dust Runner', '250 sold = Dust Runner')
rank = Utils.GetRankForSold(4500)
assert_eq(rank.label, 'Envy Kingpin', '4500 sold = Envy Kingpin')

assert_true(Utils.IsFrameworkMoney('cash'), 'cash is framework money')
assert_true(not Utils.IsFrameworkMoney('black_money'), 'black_money is inventory item')

local harvestItems = {}
for i = 1, #Config.Harvest do
    harvestItems[Config.Harvest[i].item] = true
end
for drugId, drug in pairs(Config.Drugs) do
    for j = 1, #drug.ingredients do
        local item = drug.ingredients[j].item
        assert_true(harvestItems[item] == true, item .. ' (used by ' .. drugId .. ') has harvest spot')
    end
end

local imageDir = 'install/images/'
local requiredImages = {
    'lone_star_kush', 'hill_country_haze', 'houston_snow', 'west_texas_ice',
    'border_brick', 'sixth_street_rolls', 'purple_drank', 'rig_juice',
    'panhandle_dust', 'perico_gold', 'black_money',
    'ranch_bud', 'haze_bud', 'coca_leaves', 'oil_sludge', 'desert_dust', 'cayo_palm_leaf',
}
for _, item in ipairs(requiredImages) do
    local f = io.open(imageDir .. item .. '.png', 'r')
    assert_true(f ~= nil, item .. '.png exists')
    if f then f:close() end
end

print(('\n=== Results: %d passed, %d failed ==='):format(passed, failed))
os.exit(failed > 0 and 1 or 0)
