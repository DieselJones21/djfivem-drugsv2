Config = {}

--[[
    djfivem-drugsv2 — Miami Vice themed drug economy

    Framework stack:
      - qbx_core
      - ox_lib
      - ox_target (3rd eye)
      - ox_inventory

    Harvest types:
      - 'bench'      = single prop + ox_target zone
      - 'propField'  = multiple props scattered in an area (walk around to harvest)

    All props use ground snapping (PlaceObjectOnGroundProperly + GetGroundZFor_3dCoord).
]]

Config.Debug = false
Config.Locale = 'en'
Config.Brand = 'THE 305'

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
        color = 8,
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
        { level = 1, sold = 0,    label = 'Street Runner',  payoutMultiplier = 1.00 },
        { level = 2, sold = 250,  label = 'Vice Hustler',   payoutMultiplier = 1.03 },
        { level = 3, sold = 800,  label = 'Ocean Plug',     payoutMultiplier = 1.06 },
        { level = 4, sold = 2000, label = 'Neon Trap Star', payoutMultiplier = 1.10 },
        { level = 5, sold = 4500, label = '305 Kingpin',    payoutMultiplier = 1.15 },
    },
}

Config.Stores = {}
Config.Machines = {}

--[[
    Harvest spots — 7 Miami drugs, multiple props per ingredient field.
    coords = center for blip / server area check
    radius = max distance from center OR any prop position
    positions = explicit prop coords (preferred for propField)
]]
Config.Harvest = {
    --------------------------------------------------
    -- 305 HEAT ingredients (Little Havana / Downtown)
    --------------------------------------------------
    {
        id = 'neon_crystal_field',
        type = 'propField',
        item = 'neon_crystals',
        label = 'Harvest Neon Crystals',
        amount = { min = 5, max = 10 },
        duration = 7000,
        cooldown = 10,
        coords = vec3(1287.42, -1710.88, 54.77),
        radius = 22.0,
        model = `prop_rock_4_c`,
        positions = {
            vec3(1282.10, -1715.40, 54.77),
            vec3(1291.55, -1718.20, 54.77),
            vec3(1296.80, -1708.30, 54.77),
            vec3(1288.20, -1703.50, 54.77),
            vec3(1279.60, -1706.90, 54.77),
            vec3(1293.40, -1710.00, 54.77),
            vec3(1285.00, -1719.80, 54.77),
            vec3(1299.10, -1713.60, 54.77),
        },
        anim = { dict = 'amb@world_human_gardener_plant@male@base', clip = 'base' },
        blip = { enabled = false, sprite = 501, color = 8, label = 'Neon Crystals' },
    },
    {
        id = 'miami_solvent_yard',
        type = 'propField',
        item = 'miami_solvent',
        label = 'Siphon Miami Solvent',
        amount = { min = 5, max = 10 },
        duration = 8000,
        cooldown = 10,
        coords = vec3(955.0, -194.81, 78.3),
        radius = 18.0,
        model = `prop_barrel_01a`,
        positions = {
            vec3(950.20, -198.40, 78.3),
            vec3(958.60, -200.10, 78.3),
            vec3(961.30, -192.50, 78.3),
            vec3(953.80, -189.20, 78.3),
            vec3(948.50, -193.70, 78.3),
            vec3(956.90, -196.80, 78.3),
        },
        anim = { dict = 'anim@amb@business@coc@coc_unpack_cut@', clip = 'fullcut_cycle_v6_cokecutter' },
        blip = { enabled = false, sprite = 499, color = 8, label = 'Miami Solvent' },
    },
    {
        id = 'vice_jars_warehouse',
        type = 'propField',
        item = 'vice_jars',
        label = 'Collect Vice Jars',
        amount = { min = 5, max = 10 },
        duration = 6000,
        cooldown = 10,
        coords = vec3(1123.41, -652.92, 55.73),
        radius = 16.0,
        model = `prop_box_wood05a`,
        positions = {
            vec3(1119.20, -656.40, 55.73),
            vec3(1126.80, -658.10, 55.73),
            vec3(1128.50, -650.30, 55.73),
            vec3(1121.00, -648.60, 55.73),
            vec3(1117.40, -653.80, 55.73),
            vec3(1125.60, -654.20, 55.73),
        },
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 478, color = 8, label = 'Vice Jars' },
    },
    {
        id = 'espresso_powder_dock',
        type = 'propField',
        item = 'espresso_powder',
        label = 'Scoop Espresso Powder',
        amount = { min = 5, max = 10 },
        duration = 6500,
        cooldown = 10,
        coords = vec3(756.17, -672.71, 27.73),
        radius = 15.0,
        model = `prop_feed_sack_01`,
        positions = {
            vec3(752.40, -676.20, 27.73),
            vec3(759.80, -677.50, 27.73),
            vec3(761.20, -670.10, 27.73),
            vec3(754.60, -668.40, 27.73),
            vec3(750.90, -672.80, 27.73),
            vec3(758.30, -674.60, 27.73),
        },
        anim = { dict = 'amb@prop_human_parking_meter@male@idle_a', clip = 'idle_a' },
        blip = { enabled = false, sprite = 499, color = 8, label = 'Espresso Powder' },
    },

    --------------------------------------------------
    -- SOUTH BEACH KUSH (Vespucci Beach)
    --------------------------------------------------
    {
        id = 'beach_bud_field',
        type = 'propField',
        item = 'beach_bud',
        label = 'Harvest Beach Buds',
        amount = { min = 5, max = 10 },
        duration = 6500,
        cooldown = 10,
        coords = vec3(-1172.40, -1570.80, 4.35),
        radius = 25.0,
        model = `prop_weed_01`,
        positions = {
            vec3(-1178.20, -1575.40, 4.35),
            vec3(-1168.50, -1578.10, 4.35),
            vec3(-1165.30, -1568.60, 4.35),
            vec3(-1174.80, -1564.20, 4.35),
            vec3(-1182.10, -1569.50, 4.35),
            vec3(-1170.60, -1572.30, 4.35),
            vec3(-1176.40, -1580.80, 4.35),
            vec3(-1163.90, -1574.00, 4.35),
            vec3(-1180.50, -1566.70, 4.35),
            vec3(-1167.20, -1562.40, 4.35),
        },
        anim = { dict = 'amb@world_human_gardener_plant@male@base', clip = 'base' },
        blip = { enabled = true, sprite = 469, color = 8, label = 'Beach Buds' },
    },

    --------------------------------------------------
    -- BRICKELL SNOW (Downtown / Maze Bank area)
    --------------------------------------------------
    {
        id = 'tropical_leaf_garden',
        type = 'propField',
        item = 'tropical_leaves',
        label = 'Pick Tropical Leaves',
        amount = { min = 5, max = 10 },
        duration = 6000,
        cooldown = 10,
        coords = vec3(250.50, -800.20, 29.30),
        radius = 20.0,
        model = `prop_plant_01a`,
        positions = {
            vec3(245.80, -804.60, 29.30),
            vec3(254.20, -806.40, 29.30),
            vec3(257.10, -798.20, 29.30),
            vec3(249.30, -795.50, 29.30),
            vec3(243.60, -799.80, 29.30),
            vec3(252.40, -802.10, 29.30),
            vec3(256.80, -803.70, 29.30),
            vec3(247.90, -807.30, 29.30),
        },
        anim = { dict = 'amb@world_human_gardener_plant@male@base', clip = 'base' },
        blip = { enabled = false, sprite = 501, color = 0, label = 'Tropical Leaves' },
    },

    --------------------------------------------------
    -- VICE PURPLE (Davis / Grove area)
    --------------------------------------------------
    {
        id = 'purple_syrup_stash',
        type = 'propField',
        item = 'purple_syrup',
        label = 'Steal Purple Syrup',
        amount = { min = 5, max = 10 },
        duration = 7500,
        cooldown = 10,
        coords = vec3(99.71, -1978.33, 19.76),
        radius = 18.0,
        model = `prop_drug_bottle`,
        positions = {
            vec3(95.40, -1982.10, 19.76),
            vec3(103.20, -1983.50, 19.76),
            vec3(105.80, -1976.40, 19.76),
            vec3(98.60, -1974.20, 19.76),
            vec3(93.20, -1977.80, 19.76),
            vec3(101.50, -1980.60, 19.76),
        },
        anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer' },
        blip = { enabled = false, sprite = 403, color = 27, label = 'Purple Syrup' },
    },
    {
        id = 'crushed_ice_cooler',
        type = 'propField',
        item = 'crushed_ice',
        label = 'Scoop Crushed Ice',
        amount = { min = 5, max = 10 },
        duration = 5000,
        cooldown = 10,
        coords = vec3(-47.52, -1758.87, 29.42),
        radius = 12.0,
        model = `prop_coolbox_01`,
        positions = {
            vec3(-49.80, -1761.20, 29.42),
            vec3(-45.10, -1762.40, 29.42),
            vec3(-44.30, -1757.50, 29.42),
            vec3(-49.20, -1756.10, 29.42),
        },
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 478, color = 27, label = 'Crushed Ice' },
    },
    {
        id = 'foam_cups_stack',
        type = 'propField',
        item = 'foam_cups',
        label = 'Grab Foam Cups',
        amount = { min = 5, max = 10 },
        duration = 5000,
        cooldown = 10,
        coords = vec3(-620.23, 323.26, 81.26),
        radius = 14.0,
        model = `prop_box_wood05a`,
        positions = {
            vec3(-623.40, 320.80, 81.26),
            vec3(-617.50, 319.60, 81.26),
            vec3(-616.80, 325.40, 81.26),
            vec3(-622.10, 326.90, 81.26),
            vec3(-624.60, 323.50, 81.26),
        },
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 478, color = 27, label = 'Foam Cups' },
    },
    {
        id = 'spark_soda_crates',
        type = 'propField',
        item = 'spark_soda',
        label = 'Take Spark Soda',
        amount = { min = 5, max = 10 },
        duration = 5500,
        cooldown = 10,
        coords = vec3(-1784.34, -401.11, 45.47),
        radius = 16.0,
        model = `prop_box_wood05a`,
        positions = {
            vec3(-1788.20, -404.60, 45.47),
            vec3(-1781.40, -405.80, 45.47),
            vec3(-1780.10, -398.30, 45.47),
            vec3(-1787.50, -397.20, 45.47),
            vec3(-1789.80, -401.90, 45.47),
        },
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 478, color = 27, label = 'Spark Soda' },
    },
    {
        id = 'hard_candy_bin',
        type = 'propField',
        item = 'hard_candy',
        label = 'Grab Hard Candy',
        amount = { min = 5, max = 10 },
        duration = 5500,
        cooldown = 10,
        coords = vec3(-1486.62, -909.08, 9.02),
        radius = 14.0,
        model = `prop_candy_pqs`,
        positions = {
            vec3(-1490.40, -911.60, 9.02),
            vec3(-1483.80, -912.40, 9.02),
            vec3(-1482.50, -906.80, 9.02),
            vec3(-1489.20, -905.30, 9.02),
            vec3(-1491.80, -908.50, 9.02),
        },
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 478, color = 27, label = 'Hard Candy' },
    },

    --------------------------------------------------
    -- OCEAN DRIVE ROLLS (Del Perro)
    --------------------------------------------------
    {
        id = 'drive_crystals',
        type = 'propField',
        item = 'drive_crystals',
        label = 'Harvest Drive Crystals',
        amount = { min = 5, max = 10 },
        duration = 7000,
        cooldown = 10,
        coords = vec3(-1500.40, -400.20, 35.60),
        radius = 22.0,
        model = `prop_rock_4_c`,
        positions = {
            vec3(-1505.80, -404.60, 35.60),
            vec3(-1496.20, -406.40, 35.60),
            vec3(-1493.50, -398.10, 35.60),
            vec3(-1501.80, -395.30, 35.60),
            vec3(-1508.40, -399.80, 35.60),
            vec3(-1498.60, -402.10, 35.60),
            vec3(-1503.20, -408.50, 35.60),
            vec3(-1491.90, -403.70, 35.60),
        },
        anim = { dict = 'amb@world_human_gardener_plant@male@base', clip = 'base' },
        blip = { enabled = false, sprite = 51, color = 8, label = 'Drive Crystals' },
    },
    {
        id = 'neon_powder_barrels',
        type = 'propField',
        item = 'neon_powder',
        label = 'Scoop Neon Powder',
        amount = { min = 5, max = 10 },
        duration = 6500,
        cooldown = 10,
        coords = vec3(-1344.20, -1154.58, 4.49),
        radius = 18.0,
        model = `prop_barrel_02b`,
        positions = {
            vec3(-1348.60, -1158.20, 4.49),
            vec3(-1340.40, -1159.80, 4.49),
            vec3(-1338.50, -1152.40, 4.49),
            vec3(-1346.80, -1150.60, 4.49),
            vec3(-1350.20, -1154.90, 4.49),
            vec3(-1342.30, -1156.70, 4.49),
        },
        anim = { dict = 'amb@prop_human_parking_meter@male@idle_a', clip = 'idle_a' },
        blip = { enabled = false, sprite = 51, color = 8, label = 'Neon Powder' },
    },
    {
        id = 'press_capsules',
        type = 'propField',
        item = 'press_capsules',
        label = 'Collect Press Capsules',
        amount = { min = 5, max = 10 },
        duration = 6000,
        cooldown = 10,
        coords = vec3(-1606.26, -1050.48, 6.02),
        radius = 16.0,
        model = `prop_barrel_02b`,
        positions = {
            vec3(-1610.40, -1054.20, 6.02),
            vec3(-1602.80, -1055.60, 6.02),
            vec3(-1601.20, -1048.40, 6.02),
            vec3(-1608.50, -1046.80, 6.02),
            vec3(-1611.80, -1050.30, 6.02),
        },
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 51, color = 8, label = 'Press Capsules' },
    },
    {
        id = 'vice_stamps',
        type = 'propField',
        item = 'vice_stamps',
        label = 'Collect Vice Stamps',
        amount = { min = 5, max = 10 },
        duration = 6500,
        cooldown = 10,
        coords = vec3(-1278.79, -838.92, 16.15),
        radius = 15.0,
        model = `prop_box_wood05a`,
        positions = {
            vec3(-1282.40, -842.60, 16.15),
            vec3(-1275.20, -843.80, 16.15),
            vec3(-1273.80, -836.40, 16.15),
            vec3(-1280.50, -834.90, 16.15),
            vec3(-1283.60, -838.20, 16.15),
        },
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 51, color = 8, label = 'Vice Stamps' },
    },

    --------------------------------------------------
    -- NEON RUSH (Port / Elysian Island)
    --------------------------------------------------
    {
        id = 'rush_powder',
        type = 'propField',
        item = 'rush_powder',
        label = 'Scoop Rush Powder',
        amount = { min = 5, max = 10 },
        duration = 6500,
        cooldown = 10,
        coords = vec3(1200.40, -3100.80, 5.80),
        radius = 22.0,
        model = `prop_feed_sack_01`,
        positions = {
            vec3(1195.80, -3105.40, 5.80),
            vec3(1204.60, -3107.20, 5.80),
            vec3(1207.40, -3099.10, 5.80),
            vec3(1199.20, -3096.50, 5.80),
            vec3(1193.60, -3100.80, 5.80),
            vec3(1202.30, -3102.60, 5.80),
            vec3(1206.80, -3104.40, 5.80),
            vec3(1197.50, -3108.90, 5.80),
        },
        anim = { dict = 'amb@prop_human_parking_meter@male@idle_a', clip = 'idle_a' },
        blip = { enabled = false, sprite = 499, color = 8, label = 'Rush Powder' },
    },
    {
        id = 'neon_candy',
        type = 'propField',
        item = 'neon_candy',
        label = 'Grab Neon Candy',
        amount = { min = 5, max = 10 },
        duration = 6000,
        cooldown = 10,
        coords = vec3(1243.59, -3250.40, 5.50),
        radius = 18.0,
        model = `prop_candy_pqs`,
        positions = {
            vec3(1239.20, -3254.80, 5.50),
            vec3(1247.80, -3256.40, 5.50),
            vec3(1250.50, -3248.60, 5.50),
            vec3(1242.40, -3246.20, 5.50),
            vec3(1237.60, -3250.50, 5.50),
            vec3(1246.10, -3252.30, 5.50),
        },
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 499, color = 8, label = 'Neon Candy' },
    },
    {
        id = 'tropical_concentrate',
        type = 'propField',
        item = 'tropical_concentrate',
        label = 'Tap Tropical Concentrate',
        amount = { min = 5, max = 10 },
        duration = 7000,
        cooldown = 10,
        coords = vec3(1080.20, -3102.60, 5.90),
        radius = 16.0,
        model = `prop_barrel_01a`,
        positions = {
            vec3(1076.40, -3106.80, 5.90),
            vec3(1084.20, -3108.20, 5.90),
            vec3(1086.80, -3100.40, 5.90),
            vec3(1079.10, -3098.60, 5.90),
            vec3(1074.60, -3102.90, 5.90),
        },
        anim = { dict = 'anim@amb@business@coc@coc_unpack_cut@', clip = 'fullcut_cycle_v6_cokecutter' },
        blip = { enabled = false, sprite = 499, color = 8, label = 'Tropical Concentrate' },
    },

    --------------------------------------------------
    -- PERICO GOLD (Cayo Perico exclusive)
    --------------------------------------------------
    {
        id = 'cayo_palm_leaf',
        type = 'propField',
        item = 'cayo_palm_leaf',
        label = 'Pick Cayo Palm Leaves',
        amount = { min = 5, max = 10 },
        duration = 6500,
        cooldown = 10,
        coords = vec3(5365.07, -5438.82, 47.83),
        radius = 24.0,
        model = `prop_plant_01a`,
        positions = {
            vec3(5360.40, -5443.60, 47.83),
            vec3(5369.80, -5445.20, 47.83),
            vec3(5372.50, -5437.10, 47.83),
            vec3(5364.20, -5434.50, 47.83),
            vec3(5358.60, -5439.80, 47.83),
            vec3(5367.40, -5441.30, 47.83),
            vec3(5371.80, -5443.90, 47.83),
            vec3(5362.90, -5446.40, 47.83),
        },
        anim = { dict = 'amb@world_human_gardener_plant@male@base', clip = 'base' },
        blip = { enabled = false, sprite = 51, color = 5, label = 'Cayo Palm Leaves' },
    },
    {
        id = 'reef_coral',
        type = 'propField',
        item = 'reef_coral',
        label = 'Grind Reef Coral',
        amount = { min = 5, max = 10 },
        duration = 7000,
        cooldown = 10,
        coords = vec3(5609.77, -5653.08, 8.65),
        radius = 20.0,
        model = `prop_rock_4_c`,
        positions = {
            vec3(5605.20, -5657.40, 8.65),
            vec3(5614.60, -5659.10, 8.65),
            vec3(5617.30, -5651.20, 8.65),
            vec3(5609.10, -5648.50, 8.65),
            vec3(5603.80, -5653.80, 8.65),
            vec3(5612.40, -5655.60, 8.65),
        },
        anim = { dict = 'amb@prop_human_parking_meter@male@idle_a', clip = 'idle_a' },
        blip = { enabled = false, sprite = 51, color = 5, label = 'Reef Coral' },
    },
    {
        id = 'perico_resin',
        type = 'propField',
        item = 'perico_resin',
        label = 'Tap Perico Resin',
        amount = { min = 5, max = 10 },
        duration = 7500,
        cooldown = 10,
        coords = vec3(4924.14, -5271.69, 4.35),
        radius = 18.0,
        model = `prop_barrel_01a`,
        positions = {
            vec3(4920.40, -5275.80, 4.35),
            vec3(4928.20, -5277.40, 4.35),
            vec3(4930.80, -5269.60, 4.35),
            vec3(4923.10, -5267.80, 4.35),
            vec3(4918.60, -5272.10, 4.35),
        },
        anim = { dict = 'anim@amb@business@coc@coc_unpack_cut@', clip = 'fullcut_cycle_v6_cokecutter' },
        blip = { enabled = false, sprite = 51, color = 5, label = 'Perico Resin' },
    },
    {
        id = 'gold_capsules',
        type = 'propField',
        item = 'gold_capsules',
        label = 'Collect Gold Capsules',
        amount = { min = 5, max = 10 },
        duration = 6500,
        cooldown = 10,
        coords = vec3(4517.43, -4531.98, 2.82),
        radius = 16.0,
        model = `prop_box_wood05a`,
        positions = {
            vec3(4513.60, -4535.80, 2.82),
            vec3(4521.40, -4537.40, 2.82),
            vec3(4524.10, -4529.60, 2.82),
            vec3(4516.30, -4527.80, 2.82),
            vec3(4511.80, -4532.10, 2.82),
        },
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 51, color = 5, label = 'Gold Capsules' },
    },

    --------------------------------------------------
    -- Shared supplies (zip bags, lab solvent)
    --------------------------------------------------
    {
        id = 'zip_bags_supply',
        type = 'propField',
        item = 'zip_bags',
        label = 'Grab Zip Bags',
        amount = { min = 5, max = 10 },
        duration = 5000,
        cooldown = 10,
        coords = vec3(284.67, -1773.03, 27.06),
        radius = 14.0,
        model = `prop_box_wood05a`,
        positions = {
            vec3(281.40, -1776.60, 27.06),
            vec3(287.80, -1777.80, 27.06),
            vec3(289.20, -1771.40, 27.06),
            vec3(282.60, -1769.80, 27.06),
            vec3(280.10, -1773.50, 27.06),
        },
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 478, color = 0, label = 'Zip Bags' },
    },
    {
        id = 'lab_solvent',
        type = 'propField',
        item = 'lab_solvent',
        label = 'Take Lab Solvent',
        amount = { min = 5, max = 10 },
        duration = 6000,
        cooldown = 10,
        coords = vec3(-2950.20, 637.03, 23.18),
        radius = 16.0,
        model = `prop_barrel_exp_01a`,
        positions = {
            vec3(-2954.60, 633.40, 23.18),
            vec3(-2946.80, 631.80, 23.18),
            vec3(-2944.20, 639.60, 23.18),
            vec3(-2951.90, 641.40, 23.18),
            vec3(-2956.40, 637.10, 23.18),
        },
        anim = { dict = 'anim@amb@business@coc@coc_unpack_cut@', clip = 'fullcut_cycle_v6_cokecutter' },
        blip = { enabled = false, sprite = 478, color = 0, label = 'Lab Solvent' },
    },
}
