Config = {}

--[[
    djfivem-drugsv2 — Rebel Roleplay outlaw drug economy

    Branched from the Envy Roleplay Texas set. Keep Envy on main / Envy PRs.
]]

Config.Debug = false
Config.Locale = 'en'
Config.Brand = 'Rebel Roleplay'

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
    enabled = false, -- cop-count gate for /trap (leave false to always allow trapping)
    jobs = { 'police', 'sheriff' },
    minimum = 0,
    alertChance = 35,
}

-- Project Sloth dispatch on a "bad" street sale (buyer snitches).
-- Sale still pays; police get a DrugSale ping.
Config.Dispatch = {
    enabled = true,
    resource = 'ps-dispatch',
    chance = 35,
    code = '10-66',
    message = 'Suspicious street sale',
    description = 'Drug Sale',
    jobs = { 'leo', 'police', 'sheriff' },
    sprite = 51,
    color = 1,
    scale = 1.0,
    length = 3,
}

-- After a successful harvest the prop deletes immediately, then a new one
-- grows at a different pool point inside the field radius.
Config.HarvestRespawn = {
    min = 10,
    max = 15,
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
        { level = 1, sold = 0,    label = 'Prospect',       payoutMultiplier = 1.00 },
        { level = 2, sold = 250,  label = 'Outlaw',         payoutMultiplier = 1.04 },
        { level = 3, sold = 800,  label = 'Road Captain',   payoutMultiplier = 1.08 },
        { level = 4, sold = 2000, label = 'Shot Caller',    payoutMultiplier = 1.12 },
        { level = 5, sold = 4500, label = 'Rebel Kingpin',  payoutMultiplier = 1.18 },
    },
}

Config.Stores = {}
Config.Machines = {}


--[[
    Harvest spots — Rebel outlaw set + 4 player-owned customs.
    New field centers vs the Envy branch so the two versions do not share farms.
    positions = pool of legal world coords (server validates these).
    Each client shows `visibleCount` of them. Harvest deletes that prop immediately;
    a new one grows 10–15s later at a different pool point in the same radius.
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
    -- LONGHORN KUSH (Grapeseed)
    --------------------------------------------------
    field({
        id = 'horn_nugs_field',
        item = 'horn_nugs',
        label = 'Harvest Horn Nugs',
        plant = true,
        coords = vec3(2447.12, 4975.88, 46.81),
        radius = 25.0,
        pool = 20,
        model = `prop_weed_01`,
        duration = 6500,
        blip = { enabled = true, sprite = 469, color = 1, label = 'Horn Nugs' },
    }),
    field({
        id = 'zip_bags_supply',
        item = 'zip_bags',
        label = 'Grab Zip Bags',
        plant = false,
        coords = vec3(1703.44, 3596.21, 35.47),
        radius = 14.0,
        pool = 12,
        model = `prop_cs_cardbox_01`,
        duration = 5000,
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 478, color = 0, label = 'Zip Bags' },
    }),

    --------------------------------------------------
    -- DIRT ROAD HAZE (Great Chaparral)
    --------------------------------------------------
    field({
        id = 'road_nugs_field',
        item = 'road_nugs',
        label = 'Harvest Road Nugs',
        plant = true,
        coords = vec3(-1888.40, 2045.10, 140.98),
        radius = 20.0,
        pool = 16,
        model = `prop_weed_01`,
        duration = 6500,
        blip = { enabled = true, sprite = 469, color = 1, label = 'Road Nugs' },
    }),

    --------------------------------------------------
    -- CHROME SNOW (La Mesa)
    --------------------------------------------------
    field({
        id = 'bush_leaf_garden',
        item = 'bush_leaves',
        label = 'Pick Bush Leaves',
        plant = true,
        coords = vec3(1142.55, -1486.22, 34.69),
        radius = 20.0,
        pool = 16,
        model = `prop_plant_01a`,
        duration = 6000,
        blip = { enabled = false, sprite = 501, color = 0, label = 'Bush Leaves' },
    }),
    field({
        id = 'lab_solvent',
        item = 'lab_solvent',
        label = 'Take Lab Solvent',
        plant = false,
        coords = vec3(2763.18, 1675.44, 24.53),
        radius = 16.0,
        pool = 14,
        model = `prop_barrel_exp_01a`,
        duration = 6000,
        anim = { dict = 'anim@amb@business@coc@coc_unpack_cut@', clip = 'fullcut_cycle_v6_cokecutter' },
        blip = { enabled = false, sprite = 478, color = 0, label = 'Lab Solvent' },
    }),

    --------------------------------------------------
    -- SANDLOT ICE (Sandy Shores)
    --------------------------------------------------
    field({
        id = 'lithium_rocks',
        item = 'lithium_rocks',
        label = 'Break Lithium Rocks',
        plant = false,
        coords = vec3(2954.22, 2788.10, 41.50),
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
        coords = vec3(724.80, 4191.40, 40.71),
        radius = 16.0,
        pool = 14,
        model = `prop_jerrycan_01a`,
        duration = 6500,
        anim = { dict = 'anim@amb@business@coc@coc_unpack_cut@', clip = 'fullcut_cycle_v6_cokecutter' },
        blip = { enabled = false, sprite = 499, color = 17, label = 'Camp Fuel' },
    }),

    --------------------------------------------------
    -- OUTLAW BRICK (Elysian / docks)
    --------------------------------------------------
    field({
        id = 'raw_tar',
        item = 'raw_tar',
        label = 'Scoop Raw Tar',
        plant = false,
        coords = vec3(38.22, -2678.55, 6.01),
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
        coords = vec3(808.40, -2158.90, 29.62),
        radius = 16.0,
        pool = 14,
        model = `prop_box_wood05a`,
        duration = 5000,
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 478, color = 1, label = 'Wrap Tape' },
    }),

    --------------------------------------------------
    -- HONKYTONK ROLLS (Alta / downtown)
    --------------------------------------------------
    field({
        id = 'club_crystals',
        item = 'club_crystals',
        label = 'Harvest Club Crystals',
        plant = false,
        coords = vec3(239.10, -34.80, 69.90),
        radius = 18.0,
        pool = 16,
        model = `prop_box_wood05a`,
        duration = 7000,
        blip = { enabled = false, sprite = 51, color = 1, label = 'Club Crystals' },
    }),
    field({
        id = 'press_capsules',
        item = 'press_capsules',
        label = 'Collect Press Capsules',
        plant = false,
        coords = vec3(-1154.20, -2005.40, 13.18),
        radius = 16.0,
        pool = 14,
        model = `prop_box_wood05a`,
        duration = 6000,
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 51, color = 1, label = 'Press Capsules' },
    }),
    field({
        id = 'stamp_dies',
        item = 'stamp_dies',
        label = 'Collect Stamp Dies',
        plant = false,
        coords = vec3(1240.60, -3179.20, 7.13),
        radius = 15.0,
        pool = 12,
        model = `prop_box_wood05a`,
        duration = 5500,
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 51, color = 1, label = 'Stamp Dies' },
    }),

    --------------------------------------------------
    -- SWAMP LEAN (Davis / Strawberry)
    --------------------------------------------------
    field({
        id = 'purple_syrup_stash',
        item = 'purple_syrup',
        label = 'Steal Purple Syrup',
        plant = false,
        coords = vec3(243.40, -1785.20, 28.70),
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
        coords = vec3(29.80, -1340.10, 29.50),
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
        coords = vec3(1126.40, -645.80, 56.82),
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
        coords = vec3(-2972.10, 390.40, 15.04),
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
        coords = vec3(-822.50, -1083.20, 11.13),
        radius = 14.0,
        pool = 12,
        model = `prop_candy_pqs`,
        duration = 5500,
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 478, color = 27, label = 'Hard Candy' },
    }),

    --------------------------------------------------
    -- TRUCK JUICE (oil / power station)
    --------------------------------------------------
    field({
        id = 'oil_sludge',
        item = 'oil_sludge',
        label = 'Scoop Oil Sludge',
        plant = false,
        coords = vec3(2735.80, 1551.20, 24.50),
        radius = 20.0,
        pool = 16,
        model = `prop_barrel_01a`,
        duration = 7000,
        anim = { dict = 'anim@amb@business@coc@coc_unpack_cut@', clip = 'fullcut_cycle_v6_cokecutter' },
        blip = { enabled = true, sprite = 499, color = 1, label = 'Oil Sludge' },
    }),
    field({
        id = 'spark_caps',
        item = 'spark_caps',
        label = 'Collect Spark Caps',
        plant = false,
        coords = vec3(1543.20, 2185.40, 78.80),
        radius = 16.0,
        pool = 14,
        model = `prop_battery_01`,
        duration = 6000,
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 478, color = 17, label = 'Spark Caps' },
    }),

    --------------------------------------------------
    -- GRAVEL DUST (Grand Senora)
    --------------------------------------------------
    field({
        id = 'desert_dust',
        item = 'desert_dust',
        label = 'Sweep Desert Dust',
        plant = false,
        coords = vec3(2354.10, 3125.40, 48.21),
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
        coords = vec3(1963.40, 3744.10, 32.34),
        radius = 14.0,
        pool = 12,
        model = `prop_feed_sack_01`,
        duration = 5000,
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 478, color = 5, label = 'Baking Soda' },
    }),

    --------------------------------------------------
    -- CAYO CROWN (Cayo Perico)
    --------------------------------------------------
    field({
        id = 'cayo_palm_leaf',
        item = 'cayo_palm_leaf',
        label = 'Pick Cayo Palm Leaves',
        plant = true,
        coords = vec3(4890.20, -4921.40, 3.37),
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
        coords = vec3(5132.80, -5115.60, 2.20),
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
        coords = vec3(5136.40, -5524.10, 54.19),
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
        coords = vec3(4991.10, -5716.40, 19.88),
        radius = 16.0,
        pool = 12,
        model = `prop_box_wood05a`,
        duration = 6500,
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 51, color = 5, label = 'Gold Capsules' },
    }),

    --------------------------------------------------
    -- PLAYER-OWNED: HONDA PILLS (Redwood Lights / Land Act / mansion garden)
    --------------------------------------------------
    field({
        id = 'civic_bolts',
        item = 'civic_bolts',
        label = 'Scrape Civic Bolts',
        plant = false,
        coords = vec3(1042.35, 2283.18, 49.67),
        radius = 16.0,
        pool = 12,
        model = `prop_toolchest_01`,
        duration = 6000,
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 402, color = 1, label = 'Civic Bolts' },
    }),
    field({
        id = 'shift_powder',
        item = 'shift_powder',
        label = 'Sweep Shift Powder',
        plant = false,
        coords = vec3(1661.42, -13.85, 173.77),
        radius = 14.0,
        pool = 12,
        model = `prop_feed_sack_01`,
        duration = 5500,
        anim = { dict = 'amb@prop_human_parking_meter@male@idle_a', clip = 'idle_a' },
        blip = { enabled = false, sprite = 478, color = 1, label = 'Shift Powder' },
    }),
    field({
        id = 'red_keycaps',
        item = 'red_keycaps',
        label = 'Grab Red Keycaps',
        plant = false,
        coords = vec3(-1504.22, 151.18, 55.67),
        radius = 14.0,
        pool = 12,
        model = `prop_cs_pills`,
        duration = 5000,
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 51, color = 1, label = 'Red Keycaps' },
    }),

    --------------------------------------------------
    -- PLAYER-OWNED: STAB JUICE (Altruist Camp / Cape Catfish / Chumash church)
    --------------------------------------------------
    field({
        id = 'rust_needles',
        item = 'rust_needles',
        label = 'Pick Rust Needles',
        plant = false,
        coords = vec3(-1167.72, 4926.44, 223.26),
        radius = 16.0,
        pool = 12,
        model = `prop_ld_health_pack`,
        duration = 6500,
        anim = { dict = 'amb@world_human_gardener_plant@male@base', clip = 'base' },
        blip = { enabled = false, sprite = 499, color = 1, label = 'Rust Needles' },
    }),
    field({
        id = 'iodine_swabs',
        item = 'iodine_swabs',
        label = 'Steal Iodine Swabs',
        plant = false,
        coords = vec3(3808.15, 4478.62, 4.15),
        radius = 14.0,
        pool = 12,
        model = `prop_cs_script_bottle`,
        duration = 6000,
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 403, color = 1, label = 'Iodine Swabs' },
    }),
    field({
        id = 'alley_tonic',
        item = 'alley_tonic',
        label = 'Grab Alley Tonic',
        plant = false,
        coords = vec3(-3192.48, 1296.22, 14.43),
        radius = 12.0,
        pool = 12,
        model = `prop_drug_bottle`,
        duration = 5500,
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 478, color = 1, label = 'Alley Tonic' },
    }),

    --------------------------------------------------
    -- PLAYER-OWNED: BLACK LOTUS (cemetery / chaparral church / studio lot)
    --------------------------------------------------
    field({
        id = 'black_petals',
        item = 'black_petals',
        label = 'Pick Black Petals',
        plant = true,
        coords = vec3(-1762.88, -262.41, 48.14),
        radius = 16.0,
        pool = 14,
        model = `prop_plant_01a`,
        duration = 6500,
        blip = { enabled = false, sprite = 469, color = 27, label = 'Black Petals' },
    }),
    field({
        id = 'temple_ash',
        item = 'temple_ash',
        label = 'Scoop Temple Ash',
        plant = false,
        coords = vec3(-289.62, 2834.48, 55.50),
        radius = 14.0,
        pool = 12,
        model = `prop_rock_4_c`,
        duration = 6000,
        anim = { dict = 'amb@prop_human_parking_meter@male@idle_a', clip = 'idle_a' },
        blip = { enabled = false, sprite = 51, color = 27, label = 'Temple Ash' },
    }),
    field({
        id = 'ink_resin',
        item = 'ink_resin',
        label = 'Tap Ink Resin',
        plant = false,
        coords = vec3(-1048.55, -522.18, 36.07),
        radius = 14.0,
        pool = 12,
        model = `prop_barrel_02b`,
        duration = 7000,
        anim = { dict = 'anim@amb@business@coc@coc_unpack_cut@', clip = 'fullcut_cycle_v6_cokecutter' },
        blip = { enabled = false, sprite = 499, color = 27, label = 'Ink Resin' },
    }),

    --------------------------------------------------
    -- PLAYER-OWNED: DIESELS PACK (wind farm / bus depot / cement works)
    --------------------------------------------------
    field({
        id = 'diesel_nugs',
        item = 'diesel_nugs',
        label = 'Harvest Diesel Nugs',
        plant = true,
        coords = vec3(2354.18, 1835.62, 102.10),
        radius = 18.0,
        pool = 14,
        model = `prop_weed_01`,
        duration = 6500,
        blip = { enabled = false, sprite = 469, color = 5, label = 'Diesel Nugs' },
    }),
    field({
        id = 'grease_wrap',
        item = 'grease_wrap',
        label = 'Grab Grease Wrap',
        plant = false,
        coords = vec3(454.23, -1151.39, 29.29),
        radius = 14.0,
        pool = 12,
        model = `prop_cs_cardbox_01`,
        duration = 5000,
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 478, color = 5, label = 'Grease Wrap' },
    }),
    field({
        id = 'iron_filters',
        item = 'iron_filters',
        label = 'Pull Iron Filters',
        plant = false,
        coords = vec3(267.45, 2885.92, 43.61),
        radius = 16.0,
        pool = 12,
        model = `prop_oilcan_01a`,
        duration = 6000,
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 499, color = 5, label = 'Iron Filters' },
    }),
}
