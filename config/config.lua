Config = {}

--[[
    djfivem-drugsv2 — Envy Roleplay themed drug economy

    Framework stack:
      - qbx_core
      - ox_lib
      - ox_target (3rd eye)
      - ox_inventory

    Harvest types:
      - 'bench'      = single prop + ox_target zone
      - 'propField'  = client-unique subset of a position pool; harvest relocates that prop

    All props use ground snapping (PlaceObjectOnGroundProperly + GetGroundZFor_3dCoord).
]]

Config.Debug = false
Config.Locale = 'en'
Config.Brand = 'Envy Roleplay'

Config.MoneyType = 'cash'
Config.DirtyMoneyType = 'black_money'
Config.FrameworkMoneyTypes = {
    cash = true,
    bank = true,
    crypto = true,
}

Config.InteractDistance = 2.2
Config.ProgressCancelOnMove = true

Config.Police = {
    enabled = false,
    jobs = { 'police', 'sheriff' },
    minimum = 0,
    alertChance = 0,
}

Config.Trap = {
    command = 'trap',
    description = 'Start or stop street trapping',
    cooldown = 8,
    sessionTimeout = 0,
    buyerApproachTime = 12,
    buyerWaitTime = 45,
    spawnDistance = { min = 18.0, max = 28.0 },
    models = {
        `a_m_m_eastsa_01`,
        `a_m_m_eastsa_02`,
        `a_m_y_hipster_01`,
        `a_m_y_stwhi_01`,
        `a_f_y_hipster_01`,
        `a_m_y_soucent_01`,
        `g_m_y_famca_01`,
        `g_m_y_ballasout_01`,
    },
    requireOwnedDrug = true,
    dealAnim = {
        dict = 'mp_common',
        clip = 'givetake1_a',
        flag = 49,
        duration = 2500,
    },
    blip = {
        enabled = true,
        sprite = 514,
        color = 3,
        scale = 0.7,
        label = 'Trap Mode',
    },
    haggle = {
        enabled = true,
        maxAttempts = 2,
        openingBias = 0.35,
        asks = {
            {
                id = 'soft',
                label = 'Ask a little more',
                bump = { min = 0.25, max = 0.45 },
                successChance = 50,
                counterChance = 30,
                walkAwayChance = 10,
            },
            {
                id = 'hard',
                label = 'Push for top dollar',
                bump = { min = 0.70, max = 1.00 },
                successChance = 20,
                counterChance = 25,
                walkAwayChance = 35,
            },
        },
    },
}

Config.UseEffects = true
Config.EffectCooldown = 12
Config.StressEvent = 'hud:server:RelieveStress'
Config.StressGainEvent = nil

Config.IngredientAmount = { min = 5, max = 10 }
Config.IngredientCooldown = 10

Config.Boost = {
    command = 'drugboost',
    description = 'Open drug boost event admin menu',
    ace = 'djdrugsv2.boost',
    permissions = { 'admin', 'god' },
    announce = true,
    multipliers = { 2, 3, 4 },
    durations = {
        { label = '30 minutes', seconds = 30 * 60 },
        { label = '1 hour', seconds = 60 * 60 },
        { label = '2 hours', seconds = 2 * 60 * 60 },
        { label = '4 hours', seconds = 4 * 60 * 60 },
    },
    defaultDuration = 60 * 60,
}

Config.Progression = {
    enabled = true,
    command = 'drugboard',
    description = 'Open drug sell leaderboard and your rank',
    leaderboardSize = 10,
    levels = {
        { level = 1, sold = 0,    label = 'Ranch Hand',     payoutMultiplier = 1.00 },
        { level = 2, sold = 250,  label = 'Dust Runner',    payoutMultiplier = 1.03 },
        { level = 3, sold = 800,  label = 'County Plug',    payoutMultiplier = 1.06 },
        { level = 4, sold = 2000, label = 'Border Star',    payoutMultiplier = 1.10 },
        { level = 5, sold = 4500, label = 'Envy Kingpin',   payoutMultiplier = 1.15 },
    },
}

Config.Stores = {}
Config.Machines = {}


--[[
    Harvest spots — 10 Texas drugs + shared supplies.
    positions = pool of legal world coords (server validates these).
    Each client shows `visibleCount` of them, then relocates after a successful harvest.
    Plant fields use weed/plant models and the same per-player spawn rules.
]]

local function scatter(x, y, z, count, radius)
    local positions = {}
    for i = 1, count do
        local angle = (i / count) * math.pi * 2 + (i * 0.37)
        local dist = radius * (0.22 + ((i * 17) % 70) / 100.0)
        positions[i] = vec3(x + math.cos(angle) * dist, y + math.sin(angle) * dist, z)
    end
    return positions
end

local function field(opts)
    opts.type = 'propField'
    opts.amount = opts.amount or Config.IngredientAmount or { min = 5, max = 10 }
    opts.cooldown = opts.cooldown or Config.IngredientCooldown or 10
    opts.visibleCount = opts.visibleCount or 6
    opts.clientUnique = true
    opts.positions = opts.positions or scatter(opts.coords.x, opts.coords.y, opts.coords.z, opts.pool or 16, opts.radius or 16.0)
    opts.blip = opts.blip or { enabled = false, sprite = 501, color = 3, label = opts.label }
    opts.anim = opts.anim or { dict = 'amb@world_human_gardener_plant@male@base', clip = 'base' }
    return opts
end

Config.Harvest = {
    --------------------------------------------------
    -- LONE STAR KUSH (Grapeseed ranch)
    --------------------------------------------------
    field({
        id = 'ranch_bud_field',
        item = 'ranch_bud',
        label = 'Harvest Ranch Buds',
        plant = true,
        coords = vec3(-278.47, -1632.34, 31.84),
        radius = 25.0,
        pool = 20,
        model = `prop_weed_01`,
        duration = 6500,
        blip = { enabled = true, sprite = 469, color = 2, label = 'Ranch Buds' },
    }),
    field({
        id = 'zip_bags_supply',
        item = 'zip_bags',
        label = 'Grab Zip Bags',
        plant = false,
        coords = vec3(1202.43, -1332.69, 35.21),
        radius = 14.0,
        pool = 12,
        model = `prop_cs_cardbox_01`,
        duration = 5000,
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 478, color = 0, label = 'Zip Bags' },
    }),

    --------------------------------------------------
    -- HILL COUNTRY HAZE (Great Chaparral / Route 68)
    --------------------------------------------------
    field({
        id = 'haze_bud_field',
        item = 'haze_bud',
        label = 'Harvest Haze Buds',
        plant = true,
        coords = vec3(-2554.04, 2708.44, 2.83),
        radius = 20.0,
        pool = 16,
        model = `prop_weed_01`,
        duration = 6500,
        blip = { enabled = true, sprite = 469, color = 2, label = 'Haze Buds' },
    }),

    --------------------------------------------------
    -- HOUSTON SNOW (El Burro / La Mesa)
    --------------------------------------------------
    field({
        id = 'coca_leaf_garden',
        item = 'coca_leaves',
        label = 'Pick Coca Leaves',
        plant = true,
        coords = vec3(1482.40, -1902.10, 71.10),
        radius = 20.0,
        pool = 16,
        model = `prop_plant_01a`,
        duration = 6000,
        blip = { enabled = false, sprite = 501, color = 0, label = 'Coca Leaves' },
    }),
    field({
        id = 'lab_solvent',
        item = 'lab_solvent',
        label = 'Take Lab Solvent',
        plant = false,
        coords = vec3(-2950.20, 637.03, 23.18),
        radius = 16.0,
        pool = 14,
        model = `prop_barrel_exp_01a`,
        duration = 6000,
        anim = { dict = 'anim@amb@business@coc@coc_unpack_cut@', clip = 'fullcut_cycle_v6_cokecutter' },
        blip = { enabled = false, sprite = 478, color = 0, label = 'Lab Solvent' },
    }),

    --------------------------------------------------
    -- WEST TEXAS ICE (Sandy / quarry)
    --------------------------------------------------
    field({
        id = 'lithium_rocks',
        item = 'lithium_rocks',
        label = 'Break Lithium Rocks',
        plant = false,
        coords = vec3(820.64, 1315.07, 363.18),
        radius = 20.0,
        pool = 16,
        model = `prop_rock_4_c`,
        duration = 7000,
        anim = { dict = 'amb@world_human_gardener_plant@male@base', clip = 'base' },
        blip = { enabled = false, sprite = 501, color = 17, label = 'Lithium Rocks' },
    }),
    field({
        id = 'camp_fuel',
        item = 'camp_fuel',
        label = 'Siphon Camp Fuel',
        plant = false,
        coords = vec3(-1042.40, -3522.67, 14.13),
        radius = 16.0,
        pool = 14,
        model = `prop_jerrycan_01a`,
        duration = 6500,
        anim = { dict = 'anim@amb@business@coc@coc_unpack_cut@', clip = 'fullcut_cycle_v6_cokecutter' },
        blip = { enabled = false, sprite = 499, color = 17, label = 'Camp Fuel' },
    }),

    --------------------------------------------------
    -- BORDER BRICK (Port)
    --------------------------------------------------
    field({
        id = 'raw_tar',
        item = 'raw_tar',
        label = 'Scoop Raw Tar',
        plant = false,
        coords = vec3(969.45, -2621.24, 5.52),
        radius = 20.0,
        pool = 16,
        model = `prop_barrel_02b`,
        duration = 7000,
        anim = { dict = 'amb@prop_human_parking_meter@male@idle_a', clip = 'idle_a' },
        blip = { enabled = false, sprite = 501, color = 1, label = 'Raw Tar' },
    }),
    field({
        id = 'wrap_tape',
        item = 'wrap_tape',
        label = 'Grab Wrap Tape',
        plant = false,
        coords = vec3(1216.83, -2198.77, 41.43),
        radius = 16.0,
        pool = 14,
        model = `prop_box_wood05a`,
        duration = 5000,
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 478, color = 1, label = 'Wrap Tape' },
    }),

    --------------------------------------------------
    -- SIXTH STREET ROLLS (Downtown)
    --------------------------------------------------
    field({
        id = 'street_crystals',
        item = 'street_crystals',
        label = 'Harvest Street Crystals',
        plant = false,
        coords = vec3(327.82, -1221.27, 30.70),
        radius = 18.0,
        pool = 16,
        model = `prop_box_wood05a`,
        duration = 7000,
        blip = { enabled = false, sprite = 51, color = 3, label = 'Street Crystals' },
    }),
    field({
        id = 'press_capsules',
        item = 'press_capsules',
        label = 'Collect Press Capsules',
        plant = false,
        coords = vec3(876.73, -2189.13, 30.51),
        radius = 16.0,
        pool = 14,
        model = `prop_box_wood05a`,
        duration = 6000,
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 51, color = 3, label = 'Press Capsules' },
    }),
    field({
        id = 'stamp_dies',
        item = 'stamp_dies',
        label = 'Collect Stamp Dies',
        plant = false,
        coords = vec3(712.38, -1377.32, 26.25),
        radius = 15.0,
        pool = 12,
        model = `prop_box_wood05a`,
        duration = 5500,
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 51, color = 3, label = 'Stamp Dies' },
    }),

    --------------------------------------------------
    -- PURPLE DRANK (Davis / Grove)
    --------------------------------------------------
    field({
        id = 'purple_syrup_stash',
        item = 'purple_syrup',
        label = 'Steal Purple Syrup',
        plant = false,
        coords = vec3(99.71, -1978.33, 19.76),
        radius = 16.0,
        pool = 14,
        model = `prop_drug_bottle`,
        duration = 7500,
        anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer' },
        blip = { enabled = false, sprite = 403, color = 27, label = 'Purple Syrup' },
    }),
    field({
        id = 'crushed_ice_cooler',
        item = 'crushed_ice',
        label = 'Scoop Crushed Ice',
        plant = false,
        coords = vec3(-47.52, -1758.87, 29.42),
        radius = 12.0,
        pool = 12,
        model = `prop_coolbox_01`,
        duration = 5000,
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 478, color = 27, label = 'Crushed Ice' },
    }),
    field({
        id = 'foam_cups_stack',
        item = 'foam_cups',
        label = 'Grab Foam Cups',
        plant = false,
        coords = vec3(-620.23, 323.26, 81.26),
        radius = 14.0,
        pool = 12,
        model = `prop_food_bs_cups01`,
        duration = 5000,
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 478, color = 27, label = 'Foam Cups' },
    }),
    field({
        id = 'spark_soda_crates',
        item = 'spark_soda',
        label = 'Take Spark Soda',
        plant = false,
        coords = vec3(-1784.34, -401.11, 45.47),
        radius = 16.0,
        pool = 12,
        model = `prop_crate_11e`,
        duration = 5500,
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 478, color = 27, label = 'Spark Soda' },
    }),
    field({
        id = 'hard_candy_bin',
        item = 'hard_candy',
        label = 'Grab Hard Candy',
        plant = false,
        coords = vec3(-1486.62, -909.08, 9.02),
        radius = 14.0,
        pool = 12,
        model = `prop_candy_pqs`,
        duration = 5500,
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 478, color = 27, label = 'Hard Candy' },
    }),

    --------------------------------------------------
    -- RIG JUICE (Grand Senora oil)
    --------------------------------------------------
    field({
        id = 'oil_sludge',
        item = 'oil_sludge',
        label = 'Scoop Oil Sludge',
        plant = false,
        coords = vec3(592.40, 2926.20, 40.90),
        radius = 20.0,
        pool = 16,
        model = `prop_barrel_01a`,
        duration = 7000,
        anim = { dict = 'anim@amb@business@coc@coc_unpack_cut@', clip = 'fullcut_cycle_v6_cokecutter' },
        blip = { enabled = true, sprite = 499, color = 17, label = 'Oil Sludge' },
    }),
    field({
        id = 'spark_caps',
        item = 'spark_caps',
        label = 'Collect Spark Caps',
        plant = false,
        coords = vec3(467.20, 2974.10, 41.50),
        radius = 16.0,
        pool = 14,
        model = `prop_battery_01`,
        duration = 6000,
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 478, color = 17, label = 'Spark Caps' },
    }),

    --------------------------------------------------
    -- PANHANDLE DUST (Grand Senora Desert)
    --------------------------------------------------
    field({
        id = 'desert_dust',
        item = 'desert_dust',
        label = 'Sweep Desert Dust',
        plant = false,
        coords = vec3(2638.18, 3499.78, 54.20),
        radius = 20.0,
        pool = 16,
        model = `prop_rock_4_c`,
        duration = 6500,
        anim = { dict = 'amb@prop_human_parking_meter@male@idle_a', clip = 'idle_a' },
        blip = { enabled = true, sprite = 51, color = 5, label = 'Desert Dust' },
    }),
    field({
        id = 'baking_soda',
        item = 'baking_soda',
        label = 'Grab Baking Soda',
        plant = false,
        coords = vec3(1620.73, 3292.14, 39.39),
        radius = 14.0,
        pool = 12,
        model = `prop_feed_sack_01`,
        duration = 5000,
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 478, color = 5, label = 'Baking Soda' },
    }),

    --------------------------------------------------
    -- PERICO GOLD (Cayo Perico)
    --------------------------------------------------
    field({
        id = 'cayo_palm_leaf',
        item = 'cayo_palm_leaf',
        label = 'Pick Cayo Palm Leaves',
        plant = true,
        coords = vec3(4250.03, -4496.83, 4.16),
        radius = 22.0,
        pool = 16,
        model = `prop_plant_01a`,
        duration = 6500,
        blip = { enabled = false, sprite = 51, color = 5, label = 'Cayo Palm Leaves' },
    }),
    field({
        id = 'reef_coral',
        item = 'reef_coral',
        label = 'Grind Reef Coral',
        plant = false,
        coords = vec3(4819.21, -5038.63, 31.40),
        radius = 18.0,
        pool = 14,
        model = `prop_rock_4_c`,
        duration = 7000,
        anim = { dict = 'amb@prop_human_parking_meter@male@idle_a', clip = 'idle_a' },
        blip = { enabled = false, sprite = 51, color = 5, label = 'Reef Coral' },
    }),
    field({
        id = 'perico_resin',
        item = 'perico_resin',
        label = 'Tap Perico Resin',
        plant = false,
        coords = vec3(4821.73, -5777.58, 35.90),
        radius = 16.0,
        pool = 14,
        model = `prop_barrel_01a`,
        duration = 7500,
        anim = { dict = 'anim@amb@business@coc@coc_unpack_cut@', clip = 'fullcut_cycle_v6_cokecutter' },
        blip = { enabled = false, sprite = 51, color = 5, label = 'Perico Resin' },
    }),
    field({
        id = 'gold_capsules',
        item = 'gold_capsules',
        label = 'Collect Gold Capsules',
        plant = false,
        coords = vec3(5099.88, -4845.09, 13.42),
        radius = 16.0,
        pool = 12,
        model = `prop_box_wood05a`,
        duration = 6500,
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 51, color = 5, label = 'Gold Capsules' },
    }),
}
