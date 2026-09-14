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

if not vec3 then
    function vec3(x, y, z)
        return { x = x, y = y, z = z }
    end
end

if not GetConvar then
    function GetConvar(_, default)
        return default
    end
end

local function dofile_fivem(path)
    local f = assert(io.open(path, 'r'))
    local src = f:read('*a')
    f:close()
    src = src:gsub('`([^`]+)`', function(s)
        return string.format('%q', s)
    end)
    local fn, err = load(src, '@' .. path)
    if not fn then
        error(err)
    end
    fn()
end

dofile_fivem('shared/utils.lua')
dofile_fivem('config/config.lua')
dofile_fivem('config/drugs.lua')

print('=== djfivem-drugsv2 tests ===\n')

assert_eq(Config.Brand, 'The 305', 'brand is The 305')

local drugCount = 0
for _ in pairs(Config.Drugs) do drugCount = drugCount + 1 end
assert_eq(drugCount, 10, 'should have 10 Miami street drugs')
assert_true(Config.Drugs.perico_gold ~= nil, 'includes perico_gold')
assert_true(Config.Drugs.south_beach_kush ~= nil, 'includes south_beach_kush')
assert_true(Config.Drugs.calle_ocho_haze ~= nil, 'includes calle_ocho_haze')
assert_true(Config.Drugs.heat_305 ~= nil, 'includes 305 Heat')
assert_true(Config.Drugs.honda_pills == nil, 'personal Honda Pills are gone')
assert_true(Config.Drugs.stab_juice == nil, 'personal Stab Juice is gone')
assert_true(Config.Drugs.black_lotus == nil, 'personal Black Lotus is gone')
assert_true(Config.Drugs.diesels_pack == nil, 'personal Diesels Pack is gone')
assert_true(Config.Drugs.longhorn_kush == nil, 'Rebel longhorn_kush is gone')
assert_true(Config.Drugs.cayo_crown == nil, 'Rebel cayo_crown is gone')

for drugId, drug in pairs(Config.Drugs) do
    assert_true(drug.label ~= nil, drugId .. ' has label')
    assert_true(drug.item ~= nil, drugId .. ' has item')
    assert_true(drug.playerOwned ~= true, drugId .. ' is not a personal drug')
    assert_true(drug.kind ~= 'personal', drugId .. ' does not use a personal bench')
    assert_true(drug.ingredients and #drug.ingredients > 0, drugId .. ' has ingredients')
    assert_true(drug.process and drug.process.coords, drugId .. ' has process coords')
    assert_true(drug.process.prop and drug.process.prop.model, drugId .. ' cooks at a bench')
    assert_true(not drug.process.ped, drugId .. ' does not use a cook ped')
    assert_true(drug.minLevel >= 1 and drug.minLevel <= 5, drugId .. ' has a rank gate')
    assert_true(drug.kind == 'weed' or drug.kind == 'hard', drugId .. ' has a bench kind')
    assert_true(drug.sell and drug.sell.enabled ~= false, drugId .. ' is sellable')
    assert_true(drug.effects and drug.effects.enabled ~= false, drugId .. ' has effects')
    assert_true(drug.sell.minPrice and drug.sell.maxPrice and drug.sell.maxPrice >= drug.sell.minPrice, drugId .. ' has valid payout range')
    assert_true(drug.sell.minQty and drug.sell.maxQty and drug.sell.maxQty >= drug.sell.minQty, drugId .. ' has valid qty range')
    assert_true(drug.effects.noScreenFx ~= true, drugId .. ' uses screen FX')
    local sprint = drug.effects.sprintMultiplier or 1
    assert_true(sprint <= 1.49, drugId .. ' sprint stays at or under the 1.49 cap')
    assert_true(not tostring(drug.process.prop.model):find('v_ret_ml_tableb', 1, true), drugId .. ' does not use the personal table')
end

local cayo = Config.Drugs.perico_gold
assert_true(cayo.sell.minPrice >= 1500, 'perico_gold has premium pricing')
assert_true(cayo.sell.maxPrice <= 2800, 'perico_gold stays in the island range')
assert_true((cayo.effects.armorPercent or 0) >= 60, 'perico_gold grants heavy armor')
assert_true(cayo.effects.screenEffect ~= nil, 'perico_gold has a screen effect')

local cashDrugs = { south_beach_kush = true, calle_ocho_haze = true }
assert_eq(Config.Drugs.south_beach_kush.sell.moneyType, 'cash', 'south_beach_kush pays cash')
assert_eq(Config.Drugs.calle_ocho_haze.sell.moneyType, 'cash', 'calle_ocho_haze pays cash')

for drugId, drug in pairs(Config.Drugs) do
    if cashDrugs[drugId] then
        assert_eq(drug.sell.moneyType, 'cash', drugId .. ' pays cash')
    else
        assert_eq(drug.sell.moneyType, 'black_money', drugId .. ' pays black_money')
    end
end

local runners = {
    'calle_ocho_haze', 'brickell_snow', 'biscayne_ice', 'ocean_drive_rolls',
    'neon_rush', 'heat_305', 'perico_gold',
}
for _, id in ipairs(runners) do
    assert_true((Config.Drugs[id].effects.sprintMultiplier or 1) > 1, id .. ' boosts sprint')
end

local armor = {
    'brickell_snow', 'port_brick', 'ocean_drive_rolls', 'neon_rush', 'perico_gold',
}
for _, id in ipairs(armor) do
    assert_true((Config.Drugs[id].effects.armorPercent or 0) > 0, id .. ' grants armor')
end

assert_true((Config.Drugs.biscayne_ice.effects.sprintMultiplier or 1) >= 1.49, 'biscayne_ice hits the sprint cap')
assert_true((Config.Drugs.heat_305.effects.sprintMultiplier or 1) >= 1.49, '305 Heat hits the sprint cap')

local propFieldCount = 0
local pedHarvestCount = 0
local totalProps = 0
local plantFields = 0
for i = 1, #Config.Harvest do
    local spot = Config.Harvest[i]
    if spot.type == 'ped' then
        pedHarvestCount = pedHarvestCount + 1
        assert_true(spot.model ~= nil, spot.id .. ' ped has a model')
        assert_true(spot.coords ~= nil, spot.id .. ' ped has coords')
        assert_true(spot.heading ~= nil, spot.id .. ' ped has heading')
    elseif spot.type == 'propField' then
        propFieldCount = propFieldCount + 1
        assert_true(spot.positions and #spot.positions >= 4, spot.id .. ' has 4+ prop positions')
        assert_true((spot.visibleCount or 0) >= 1, spot.id .. ' has visibleCount')
        totalProps = totalProps + #spot.positions
        if spot.plant then plantFields = plantFields + 1 end
        local r = spot.radius or 8.0
        assert_true(r <= 12.0, (spot.id or '?') .. ' harvest radius is compact')
        assert_true(r >= 5.0, (spot.id or '?') .. ' harvest radius is still a field')
    end
end
assert_eq(propFieldCount, 2, 'only the two Miami weed fields stay as props')
assert_true(pedHarvestCount >= 20, 'every non-weed ingredient is a ped')
assert_eq(plantFields, 2, 'weed plants still relocate like a grow')
print(('  Harvest: %d weed fields, %d pool props, %d peds'):format(propFieldCount, totalProps, pedHarvestCount))

local levels = Utils.GetProgressLevels()
assert_eq(#levels, 5, '5 progression ranks')
assert_eq(levels[1].label, 'Beach Runner', 'first rank is Beach Runner')
assert_eq(levels[2].label, 'Vice Hustler', 'second rank is Vice Hustler')
assert_eq(levels[3].label, 'Ocean Plug', 'third rank is Ocean Plug')
assert_eq(levels[4].label, 'Port Boss', 'fourth rank is Port Boss')
assert_eq(levels[5].label, '305 Kingpin', 'max rank is 305 Kingpin')

local rank = Utils.GetRankForSold(0)
assert_eq(rank.label, 'Beach Runner', '0 sold = Beach Runner')
rank = Utils.GetRankForSold(250)
assert_eq(rank.label, 'Vice Hustler', '250 sold = Vice Hustler')
rank = Utils.GetRankForSold(4500)
assert_eq(rank.label, '305 Kingpin', '4500 sold = 305 Kingpin')

assert_eq(Config.Dispatch.chance, 35, 'bad sell chance is 35%')
assert_eq(Config.Dispatch.resource, 'wasabi_mdt', 'primary dispatch is Wasabi MDT')
assert_eq(Config.Dispatch.fallback, 'ps-dispatch', 'ps-dispatch is the fallback')
assert_eq(Config.Dispatch.dispatchType, 'disturbance', 'Wasabi type is a stock DispatchTypes key')
assert_eq(Config.Dispatch.title, 'Drug Sale', 'Wasabi call title is Drug Sale')
assert_eq(Config.Dispatch.senderName, 'Anonymous tip', 'Wasabi sender is an anonymous tip')
assert_eq(Config.Dispatch.priority, 3, 'Wasabi priority is 3')
assert_eq(Config.Dispatch.code, '10-66', 'radio code is 10-66')

local function read_file(path)
    local f = assert(io.open(path, 'r'))
    local src = f:read('*a')
    f:close()
    return src
end

local dispatchSrc = read_file('server/dispatch.lua')
assert_true(dispatchSrc:find('wasabi_mdt', 1, true) ~= nil, 'server dispatch targets wasabi_mdt')
assert_true(dispatchSrc:find('CreateDispatch', 1, true) ~= nil, 'server uses Wasabi CreateDispatch')
assert_true(dispatchSrc:find('senderName', 1, true) ~= nil, 'server CreateDispatch sets senderName')
assert_true(dispatchSrc:find('function Server.AlertDrugSale', 1, true) ~= nil, 'AlertDrugSale is the shared snitch entry')
assert_true(dispatchSrc:find('GetResourceState', 1, true) ~= nil, 'Wasabi is optional (resource state check)')

local clientSellSrc = read_file('client/sell.lua')
assert_true(clientSellSrc:find('payload.wasabi', 1, true) ~= nil, 'client skips ps-dispatch when Wasabi already alerted')
assert_true(clientSellSrc:find('cfg.fallback', 1, true) ~= nil, 'client ps-dispatch uses Config.Dispatch.fallback')

local fxSrc = read_file('fxmanifest.lua')
assert_true(fxSrc:find('server/dispatch.lua', 1, true) ~= nil, 'fxmanifest starts server/dispatch.lua')
assert_true(fxSrc:find("'wasabi_mdt'", 1, true) == nil, 'wasabi_mdt is optional (not a hard dependency)')
assert_true(fxSrc:find('The 305', 1, true) ~= nil, 'fxmanifest brands The 305')

local sellSrc = read_file('server/sell.lua')
assert_true(sellSrc:find('Server.AlertDrugSale', 1, true) ~= nil, 'street sales call AlertDrugSale')
assert_true(sellSrc:find("djdrugsv2:client:badSell", 1, true) == nil, 'street sales do not fire the client event directly')

local bulkSrc = read_file('server/bulk.lua')
assert_true(bulkSrc:find('Server.AlertDrugSale', 1, true) ~= nil, 'bulk sales call AlertDrugSale')
assert_true(bulkSrc:find("djdrugsv2:client:badSell", 1, true) == nil, 'bulk sales do not fire the client event directly')
assert_eq(Config.WeedRespawn.min, 45, 'weed grow-back is at least 45s')
assert_eq(Config.WeedRespawn.max, 90, 'weed grow-back is at most 90s')
assert_true(Config.Drugs.south_beach_kush.sell.minPrice >= 80, 'south beach street prices stay playable')
assert_true(Config.Drugs.brickell_snow.sell.maxPrice >= 350, 'brickell snow pays a city brick rate')
assert_eq(Config.Drugs.south_beach_kush.minLevel, 1, 'weed starts at Beach Runner')
assert_eq(Config.Drugs.perico_gold.minLevel, 5, 'perico is kingpin-only')
assert_true(not Utils.IsPersonalDrug('south_beach_kush'), 'street weed is not personal')
assert_true(Utils.CanAccessDrug(0, 'south_beach_kush'), 'beach runner can bag south beach')
assert_true(not Utils.CanAccessDrug(0, 'perico_gold'), 'beach runner cannot cook perico')
assert_true(Utils.CanAccessDrug(4500, 'perico_gold'), 'kingpin can cook perico')
assert_eq(Config.Drugs.south_beach_kush.sell.minPrice, 92, 'south beach pay is +15%')
assert_eq(Config.Drugs.vice_purple.sell.minPrice, 138, 'vice purple pay is +15%')
assert_eq(Config.Drugs.brickell_snow.sell.minPrice, 253, 'brickell snow pay is +15%')
assert_true(Utils.CanAccessHarvestItem(0, 'street_lace'), 'lace is always collectable')
assert_true(not Utils.CanAccessHarvestItem(0, 'gold_capsules'), 'cayo supplies stay hidden')
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
    'south_beach_kush', 'calle_ocho_haze', 'brickell_snow', 'biscayne_ice',
    'port_brick', 'ocean_drive_rolls', 'vice_purple', 'neon_rush',
    'heat_305', 'perico_gold', 'black_money',
    'beach_bud', 'canal_nugs', 'tropical_leaves', 'drive_crystals',
    'rush_sludge', 'neon_dust', 'cayo_palm_leaf', 'street_lace',
}
for _, item in ipairs(requiredImages) do
    local f = io.open(imageDir .. item .. '.png', 'r')
    assert_true(f ~= nil, item .. '.png exists')
    if f then f:close() end
end

assert_eq(Config.Target.resource, 'interact', 'props use darktrovx interact')
assert_eq(Config.Target.fallback, 'ox_target', 'street buyers / fallback use ox_target')

do
    local sellFile = io.open('client/sell.lua', 'r')
    assert_true(sellFile ~= nil, 'client/sell.lua readable')
    local body = sellFile:read('*a')
    sellFile:close()
    assert_true(body:find('Client.AttachOxTarget', 1, true) ~= nil, 'street buyers attach with ox_target')
    assert_true(body:find('Client.AttachInteract', 1, true) == nil, 'street buyers do not use interact')
    assert_true(body:find('3rd eye', 1, true) ~= nil, 'trap notify mentions 3rd eye')
    assert_true(body:find('buyerSay', 1, true) ~= nil, 'street buyers speak on deals')
end

assert_true(Config.Trap.talk ~= nil, 'trap talk lines exist')
assert_true(#Config.Trap.talk.good >= 2, 'good-sale talk lines')
assert_true(#Config.Trap.talk.snitch >= 2, 'snitch talk lines')

assert_true(Config.Drugs.perico_gold.process.output.amount >= 8, 'perico gold returns at least as much as it eats')
assert_true(Config.Drugs.south_beach_kush.process.output.amount > Config.Drugs.calle_ocho_haze.process.output.amount, 'south beach yields more than calle ocho')
assert_true(tostring(Config.Drugs.south_beach_kush.process.prop.model):find('weed_table', 1, true) ~= nil, 'weed cooks on the weed table')
assert_true(tostring(Config.Drugs.brickell_snow.process.prop.model):find('coke_table01a', 1, true) ~= nil, 'hard cooks on the coke table')

local outputAmounts = {}
local distinctOutputs = 0
for _, drug in pairs(Config.Drugs) do
    local amt = drug.process.output.amount
    if not outputAmounts[amt] then
        outputAmounts[amt] = true
        distinctOutputs = distinctOutputs + 1
    end
end
assert_true(distinctOutputs >= 4, 'recipes do not all output the same amount')

for drugId, drug in pairs(Config.Drugs) do
    local input = Utils.RecipeInputTotal(drug)
    local output = drug.process.output.amount
    assert_true(output >= input, drugId .. ' output is at least the ingredient total')
end

assert_true(Config.Lace ~= nil, 'vice lace config exists')
assert_eq(Config.Lace.item, 'street_lace', 'lace item is street_lace')
assert_eq(Config.Lace.label, 'Vice Lace', 'lace label is Vice Lace')
assert_true(Config.Lace.pricePercent > 0, 'lace pays extra')
assert_eq(Utils.ApplyLacePrice(100, false), 100, 'unlaced price is unchanged')
assert_eq(Utils.ApplyLacePrice(100, true), 135, 'laced price is +35%')

local harvestByItem = {}
for _, spot in ipairs(Config.Harvest) do
    harvestByItem[spot.item] = spot
end
assert_eq(harvestByItem.zip_bags.type, 'ped', 'zip bags is a contact ped')
assert_eq(harvestByItem.tide_rocks.type, 'ped', 'tide rocks is a contact ped')
assert_eq(harvestByItem.drive_crystals.type, 'ped', 'drive crystals is a contact ped')
assert_eq(harvestByItem.purple_syrup.type, 'ped', 'purple syrup is a contact ped')
assert_eq(harvestByItem.rush_sludge.type, 'ped', 'rush sludge is a contact ped')
assert_eq(harvestByItem.gold_capsules.type, 'ped', 'gold capsules is a contact ped')
assert_eq(harvestByItem.street_lace.type, 'ped', 'vice lace is a contact ped')
assert_eq(harvestByItem.beach_bud.type, 'propField', 'beach bud stays a weed field')
assert_eq(harvestByItem.canal_nugs.type, 'propField', 'canal nugs stay a weed field')
assert_true(harvestByItem.diesel_nugs == nil, 'diesel nugs field is gone')
assert_true(harvestByItem.civic_bolts == nil, 'personal civic bolts ped is gone')

local pedItems = {}
for _, spot in ipairs(Config.Harvest) do
    if spot.type == 'ped' then
        pedItems[spot.item] = true
    end
end
for drugId, drug in pairs(Config.Drugs) do
    local pedIng, weedIng = 0, 0
    for j = 1, #drug.ingredients do
        local item = drug.ingredients[j].item
        if pedItems[item] then
            pedIng = pedIng + 1
        end
        local spot = harvestByItem[item]
        if spot and spot.type == 'propField' then
            weedIng = weedIng + 1
        end
    end
    if drug.kind == 'weed' then
        assert_true(weedIng >= 1, drugId .. ' still uses a weed field')
        assert_true(pedIng >= 1, drugId .. ' still has a supply ped')
    else
        assert_eq(pedIng, #drug.ingredients, drugId .. ' ingredients are all peds')
    end
end

local signatures = {}
for drugId, drug in pairs(Config.Drugs) do
    local sig = Utils.RecipeSignature(drug)
    assert_true(signatures[sig] == nil, drugId .. ' recipe is unique')
    signatures[sig] = drugId
end

assert_true(Config.Informant ~= nil, 'informant config exists')
assert_eq(Config.Informant.cooldown, 3600, 'informant cooldown is 1 hour')
assert_eq(Config.Informant.singlePrice, 75000, 'each intel mark is $75k')
assert_true(math.abs(Config.Informant.coords.x - (-1234.80)) < 0.05, 'Street Intel sits on the South Beach walk')
assert_true(harvestByItem.beach_bud.public == true, 'beach bud is a public civ field')
assert_true(harvestByItem.beach_bud.blip.enabled == true, 'beach bud has a civ blip')
assert_true(harvestByItem.canal_nugs.blip.enabled == true, 'canal nugs has a civ blip')
assert_true(harvestByItem.zip_bags.public == true, 'zip bags is a public civ ped')
assert_true(harvestByItem.zip_bags.blip.enabled == true, 'zip bags has a civ blip')
assert_true(Config.Drugs.south_beach_kush.process.blip.enabled == true, 'south beach bench is blipped')
assert_true(Config.Drugs.calle_ocho_haze.process.blip.enabled == true, 'calle ocho bench is blipped')
assert_true(Config.Drugs.brickell_snow.process.blip.enabled ~= true, 'street labs stay hidden')

local intelSrc = read_file('server/informant.lua')
assert_true(intelSrc:find('not spot.public', 1, true) ~= nil, 'informant skips public civ harvest')
assert_true(intelSrc:find("drug.kind ~= 'weed'", 1, true) ~= nil, 'informant does not sell civ weed benches')
assert_true(type(Config.Boost.discordWebhook) == 'string' and Config.Boost.discordWebhook:find('/1548557503992696832/', 1, true) ~= nil, 'boost webhook is configured')
assert_eq(Config.Help.command, 'drughelp', 'player help command is /drughelp')
assert_eq(Config.Boost.warningSeconds, 15 * 60, 'boost lead-in is 15 minutes')
assert_eq(Config.Boost.endingWarningSeconds, 15 * 60, 'boost ending warning is 15 minutes')
assert_eq(Config.Boost.discordUsername, '305 Boost Desk', 'boost Discord name is 305')

local harvestIds = {}
for i = 1, #Config.Harvest do
    local spot = Config.Harvest[i]
    assert_true(harvestIds[spot.item] == nil, spot.item .. ' has only one harvest contact')
    harvestIds[spot.item] = true
end

assert_true(fxSrc:find('server/informant.lua', 1, true) ~= nil, 'fxmanifest starts informant')
assert_true(fxSrc:find('client/help.lua', 1, true) ~= nil, 'fxmanifest starts help')
assert_true(read_file('server/boost.lua'):find('discord.com/api/webhooks', 1, true) ~= nil, 'boost posts to Discord webhooks')
assert_true(read_file('client/harvest.lua'):find('useInteract = true', 1, true) ~= nil, 'ingredient peds use interact')
assert_true(read_file('html/index.html'):find('logo-305.png', 1, true) ~= nil, 'NUI embeds the 305 logo')
assert_true(read_file('html/style.css'):find('ff2d8a', 1, true) ~= nil, 'NUI uses the 305 magenta')
assert_true(read_file('html/style.css'):find('background: transparent !important', 1, true) ~= nil, 'NUI plate stays transparent')

assert_true(Config.BulkSell ~= nil, 'bulk sell config exists')
assert_eq(Config.BulkSell.command, 'drugbulksell', 'bulk command is /drugbulksell')
assert_eq(Config.BulkSell.minQty, 100, 'bulk min is 100')
assert_eq(Config.BulkSell.maxQty, 200, 'bulk max is 200')
assert_true(Config.BulkSell.pricePercent < 1, 'bulk pays less than street min')
assert_true(#Config.BulkSell.locations >= 8, 'multiple bulk drop locations')

local locIds = {}
for i = 1, #Config.BulkSell.locations do
    local loc = Config.BulkSell.locations[i]
    assert_true(loc.id ~= nil and loc.label ~= nil, 'bulk location has id and label')
    assert_true(loc.coords ~= nil, loc.id .. ' has coords')
    assert_true(locIds[loc.id] == nil, loc.id .. ' is unique')
    locIds[loc.id] = true
end
assert_true(locIds.port_crates ~= nil, 'bulk drop at Port of Miami')
assert_true(locIds.ocean_drive_alley ~= nil, 'bulk drop on Ocean Drive')

for drugId, drug in pairs(Config.Drugs) do
    local bulkEach = Utils.GetBulkPriceEach(drug, 1)
    assert_true(bulkEach < drug.sell.minPrice, drugId .. ' bulk unit price is below street min')
    local ranked = Utils.GetBulkPriceEach(drug, 1.18)
    assert_true(ranked < drug.sell.minPrice, drugId .. ' bulk stays below street min even with kingpin rank')
end

print(('\n=== Results: %d passed, %d failed ==='):format(passed, failed))
os.exit(failed > 0 and 1 or 0)
