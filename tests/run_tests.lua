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

-- Test: exactly 7 drugs
local drugCount = 0
for _ in pairs(Config.Drugs) do drugCount = drugCount + 1 end
assert_eq(drugCount, 7, 'should have exactly 7 drugs')

-- Test: all drugs have required fields
for drugId, drug in pairs(Config.Drugs) do
    assert_true(drug.label ~= nil, drugId .. ' has label')
    assert_true(drug.item ~= nil, drugId .. ' has item')
    assert_true(drug.ingredients and #drug.ingredients > 0, drugId .. ' has ingredients')
    assert_true(drug.process and drug.process.coords, drugId .. ' has process coords')
    assert_true(drug.process.prop and drug.process.prop.model, drugId .. ' has process prop')
    assert_true(drug.sell and drug.sell.enabled ~= false, drugId .. ' is sellable')
    assert_true(drug.effects, drugId .. ' has effects')
end

-- Test: perico_gold is Cayo exclusive (high price)
local perico = Config.Drugs.perico_gold
assert_true(perico.sell.minPrice >= 1500, 'perico_gold has premium pricing')

-- Test: south_beach_kush pays cash
local kush = Config.Drugs.south_beach_kush
assert_eq(kush.sell.moneyType, 'cash', 'south_beach_kush pays cash')

-- Test: all other drugs pay black_money
for drugId, drug in pairs(Config.Drugs) do
    if drugId ~= 'south_beach_kush' then
        assert_eq(drug.sell.moneyType, 'black_money', drugId .. ' pays black_money')
    end
end

-- Test: harvest spots use propField with multiple positions
local propFieldCount = 0
local totalProps = 0
for i = 1, #Config.Harvest do
    local spot = Config.Harvest[i]
    if spot.type == 'propField' then
        propFieldCount = propFieldCount + 1
        assert_true(spot.positions and #spot.positions >= 4, spot.id .. ' has 4+ prop positions')
        totalProps = totalProps + #spot.positions
    end
end
assert_true(propFieldCount >= 20, 'most harvest spots are propField type')
print(('  Harvest fields: %d propField spots, %d total props'):format(propFieldCount, totalProps))

-- Test: progression ranks
local levels = Utils.GetProgressLevels()
assert_eq(#levels, 5, '5 progression ranks')
assert_eq(levels[5].label, 'Envy Kingpin', 'max rank is Envy Kingpin')

-- Test: rank math
local rank = Utils.GetRankForSold(0)
assert_eq(rank.label, 'Street Runner', '0 sold = Street Runner')
rank = Utils.GetRankForSold(250)
assert_eq(rank.label, 'Vice Hustler', '250 sold = Vice Hustler')
rank = Utils.GetRankForSold(4500)
assert_eq(rank.label, 'Envy Kingpin', '4500 sold = Envy Kingpin')

-- Test: money type detection
assert_true(Utils.IsFrameworkMoney('cash'), 'cash is framework money')
assert_true(not Utils.IsFrameworkMoney('black_money'), 'black_money is inventory item')

-- Test: all harvest items referenced in drug ingredients exist
local harvestItems = {}
for i = 1, #Config.Harvest do
    harvestItems[Config.Harvest[i].item] = true
end
for drugId, drug in pairs(Config.Drugs) do
    for j = 1, #drug.ingredients do
        local item = drug.ingredients[j].item
        -- zip_bags and lab_solvent are shared harvest items
        if not harvestItems[item] and item ~= 'zip_bags' and item ~= 'lab_solvent' then
            -- Check if another drug's harvest provides it via shared spots
            local found = false
            for k = 1, #Config.Harvest do
                if Config.Harvest[k].item == item then found = true break end
            end
            assert_true(found, item .. ' (used by ' .. drugId .. ') has harvest spot')
        end
    end
end

-- Test: inventory images exist
local imageDir = 'install/images/'
local requiredImages = {
    'heat_305', 'south_beach_kush', 'brickell_snow', 'vice_purple',
    'ocean_drive_rolls', 'neon_rush', 'perico_gold', 'black_money',
    'neon_crystals', 'beach_bud', 'tropical_leaves', 'purple_syrup',
    'drive_crystals', 'rush_powder', 'cayo_palm_leaf',
}
for _, item in ipairs(requiredImages) do
    local f = io.open(imageDir .. item .. '.png', 'r')
    assert_true(f ~= nil, item .. '.png exists')
    if f then f:close() end
end

print(('\n=== Results: %d passed, %d failed ==='):format(passed, failed))
os.exit(failed > 0 and 1 or 0)
