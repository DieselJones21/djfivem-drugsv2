--[[
    10 Texas county drugs + 4 player-owned custom recipes for djfivem-drugsv2

    Default craft rule: 5 of each ingredient → 7 finished product
    Weed strains pay clean cash; everything else pays black_money.

    Player-owned set (3 ingredients each): Honda Pills, Stab Juice, Black Lotus, Diesels Pack
]]

local function processAnim()
    return {
        dict = 'anim@amb@business@coc@coc_unpack_cut@',
        clip = 'fullcut_cycle_v6_cokecutter',
    }
end

local function bagAnim()
    return {
        dict = 'mini@repair',
        clip = 'fixing_a_ped',
    }
end

Config.Drugs = {
    --------------------------------------------------
    -- Lone Star Kush — ranch weed (Grapeseed) — cash, no screen FX
    --------------------------------------------------
    lone_star_kush = {
        label = 'Lone Star Kush',
        item = 'lone_star_kush',
        description = 'Ranch-grown kush bagged for the county',
        theme = 'Grapeseed',
        ingredients = {
            { item = 'ranch_bud', amount = 5 },
            { item = 'zip_bags', amount = 5 },
        },
        process = {
            label = 'Bag Lone Star Kush',
            coords = vec3(310.38, 263.08, 104.85),
            heading = 272.13,
            duration = 9000,
            prop = { model = `bkr_prop_weed_table_01a`, heading = 272.13 },
            anim = bagAnim(),
            output = { item = 'lone_star_kush', amount = 7 },
            blip = { enabled = false, sprite = 469, color = 2, label = 'Lone Star Kush Bench' },
        },
        sell = {
            enabled = true,
            moneyType = 'cash',
            minPrice = 80,
            maxPrice = 150,
            minQty = 1,
            maxQty = 8,
        },
        effects = {
            enabled = true,
            noScreenFx = true,
            label = 'Smoking Lone Star Kush',
            useTime = 5000,
            duration = 45000,
            anim = { dict = 'amb@world_human_smoking@male@male_a@idle_a', clip = 'idle_b', flag = 49 },
            stress = -30,
        },
    },

    --------------------------------------------------
    -- Hill Country Haze — country sativa — cash, light run, no screen FX
    --------------------------------------------------
    hill_country_haze = {
        label = 'Hill Country Haze',
        item = 'hill_country_haze',
        description = 'Dry-country haze that keeps you moving',
        theme = 'Great Chaparral',
        ingredients = {
            { item = 'haze_bud', amount = 5 },
            { item = 'zip_bags', amount = 5 },
        },
        process = {
            label = 'Bag Hill Country Haze',
            coords = vec3(-3164.28, 1113.06, 20.77),
            heading = 155.91,
            duration = 9000,
            prop = { model = `bkr_prop_weed_table_01a`, heading = 155.91 },
            anim = bagAnim(),
            output = { item = 'hill_country_haze', amount = 7 },
            blip = { enabled = false, sprite = 469, color = 2, label = 'Hill Country Haze Bench' },
        },
        sell = {
            enabled = true,
            moneyType = 'cash',
            minPrice = 100,
            maxPrice = 175,
            minQty = 1,
            maxQty = 8,
        },
        effects = {
            enabled = true,
            noScreenFx = true,
            label = 'Smoking Hill Country Haze',
            useTime = 4500,
            duration = 40000,
            anim = { dict = 'amb@world_human_smoking@male@male_a@idle_a', clip = 'idle_b', flag = 49 },
            stamina = true,
            sprintMultiplier = 1.15,
            stress = -15,
        },
    },

    --------------------------------------------------
    -- Houston Snow — industrial coke — armor + run, light screen
    --------------------------------------------------
    houston_snow = {
        label = 'Houston Snow',
        item = 'houston_snow',
        description = 'City brick broken down for the streets',
        theme = 'El Burro / La Mesa',
        ingredients = {
            { item = 'coca_leaves', amount = 5 },
            { item = 'lab_solvent', amount = 5 },
            { item = 'zip_bags', amount = 5 },
        },
        process = {
            label = 'Cut Houston Snow',
            coords = vec3(-2246.64, 198.47, 174.59),
            heading = 116.22,
            duration = 12000,
            prop = { model = `bkr_prop_coke_table01a`, heading = 116.22 },
            anim = processAnim(),
            output = { item = 'houston_snow', amount = 7 },
            blip = { enabled = false, sprite = 501, color = 0, label = 'Houston Snow Table' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 240,
            maxPrice = 395,
            minQty = 1,
            maxQty = 6,
        },
        effects = {
            enabled = true,
            noScreenFx = false,
            label = 'Snorting Houston Snow',
            useTime = 4000,
            duration = 45000,
            anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer', flag = 49 },
            armorPercent = 20,
            stamina = true,
            sprintMultiplier = 1.20,
            timecycle = 'spectator5',
            timecycleStrength = 0.35,
        },
    },

    --------------------------------------------------
    -- West Texas Ice — desert meth — fast run + screen FX
    --------------------------------------------------
    west_texas_ice = {
        label = 'West Texas Ice',
        item = 'west_texas_ice',
        description = 'Sandy-cooked ice that burns the legs',
        theme = 'Sandy Shores',
        ingredients = {
            { item = 'lithium_rocks', amount = 5 },
            { item = 'camp_fuel', amount = 5 },
            { item = 'lab_solvent', amount = 5 },
        },
        process = {
            label = 'Cook West Texas Ice',
            coords = vec3(-1102.04, 2727.97, 18.80),
            heading = 218.27,
            duration = 13000,
            prop = { model = `bkr_prop_meth_table01a`, heading = 218.27 },
            anim = processAnim(),
            output = { item = 'west_texas_ice', amount = 7 },
            blip = { enabled = false, sprite = 499, color = 17, label = 'West Texas Ice Lab' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 195,
            maxPrice = 340,
            minQty = 1,
            maxQty = 6,
        },
        effects = {
            enabled = true,
            noScreenFx = false,
            label = 'Hitting West Texas Ice',
            useTime = 3500,
            duration = 50000,
            anim = { dict = 'switch@trevor@trev_smoking_meth', clip = 'trev_smoking_meth_loop', flag = 49 },
            stamina = true,
            sprintMultiplier = 1.40,
            shake = { intensity = 0.35, duration = 8000 },
            timecycle = 'drug_wobbly',
            timecycleStrength = 0.45,
        },
    },

    --------------------------------------------------
    -- Border Brick — tar brick — armor + screen FX
    --------------------------------------------------
    border_brick = {
        label = 'Border Brick',
        item = 'border_brick',
        description = 'Wrapped brick moved up from the docks',
        theme = 'Elysian Island',
        ingredients = {
            { item = 'raw_tar', amount = 5 },
            { item = 'wrap_tape', amount = 5 },
            { item = 'zip_bags', amount = 5 },
        },
        process = {
            label = 'Wrap Border Brick',
            coords = vec3(1467.80, 6554.91, 14.00),
            heading = 93.54,
            duration = 12000,
            prop = { model = `prop_tool_bench02`, heading = 93.54 },
            anim = bagAnim(),
            output = { item = 'border_brick', amount = 7 },
            blip = { enabled = false, sprite = 501, color = 1, label = 'Border Brick Bench' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 295,
            maxPrice = 480,
            minQty = 1,
            maxQty = 5,
        },
        effects = {
            enabled = true,
            noScreenFx = false,
            label = 'Using Border Brick',
            useTime = 4500,
            duration = 50000,
            anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer', flag = 49 },
            armorPercent = 30,
            walk = 'move_m@drunk@slightlydrunk',
            drunkCamera = true,
            shake = { intensity = 0.25, duration = 6000 },
        },
    },

    --------------------------------------------------
    -- Sixth Street Rolls — molly — fast run + screen FX
    --------------------------------------------------
    sixth_street_rolls = {
        label = 'Sixth Street Rolls',
        item = 'sixth_street_rolls',
        description = 'Pressed rolls from the downtown alleys',
        theme = 'Textile City',
        ingredients = {
            { item = 'street_crystals', amount = 5 },
            { item = 'press_capsules', amount = 5 },
            { item = 'stamp_dies', amount = 5 },
        },
        process = {
            label = 'Press Sixth Street Rolls',
            coords = vec3(120.45, -717.69, 42.02),
            heading = 68.03,
            duration = 11000,
            prop = { model = `prop_tool_bench02`, heading = 68.03 },
            anim = bagAnim(),
            output = { item = 'sixth_street_rolls', amount = 7 },
            blip = { enabled = false, sprite = 51, color = 3, label = 'Sixth Street Press' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 440,
            maxPrice = 750,
            minQty = 1,
            maxQty = 6,
        },
        effects = {
            enabled = true,
            noScreenFx = false,
            label = 'Popping Sixth Street Rolls',
            useTime = 3000,
            duration = 45000,
            anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger', flag = 49 },
            stamina = true,
            sprintMultiplier = 1.35,
            screenEffect = 'DrugsMichaelAliensFight',
        },
    },

    --------------------------------------------------
    -- Purple Drank — lean — stress only, no screen FX
    --------------------------------------------------
    purple_drank = {
        label = 'Purple Drank',
        item = 'purple_drank',
        description = 'County-cup lean mixed in the south side',
        theme = 'Davis',
        ingredients = {
            { item = 'purple_syrup', amount = 5 },
            { item = 'crushed_ice', amount = 5 },
            { item = 'foam_cups', amount = 5 },
            { item = 'spark_soda', amount = 5 },
            { item = 'hard_candy', amount = 5 },
        },
        process = {
            label = 'Pour Purple Drank',
            coords = vec3(220.35, -1992.47, 19.66),
            heading = 48.19,
            duration = 10000,
            prop = { model = `prop_tool_bench02`, heading = 48.19 },
            anim = bagAnim(),
            output = { item = 'purple_drank', amount = 7 },
            blip = { enabled = false, sprite = 499, color = 27, label = 'Purple Drank Bench' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 135,
            maxPrice = 245,
            minQty = 1,
            maxQty = 5,
        },
        effects = {
            enabled = true,
            noScreenFx = true,
            label = 'Sipping Purple Drank',
            useTime = 4500,
            duration = 45000,
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle', flag = 49 },
            stress = -40,
        },
    },

    --------------------------------------------------
    -- Rig Juice — oilfield stim — fast run + armor, no screen FX
    --------------------------------------------------
    rig_juice = {
        label = 'Rig Juice',
        item = 'rig_juice',
        description = 'Oilfield stim that keeps crews on their feet',
        theme = 'Grand Senora oil',
        ingredients = {
            { item = 'oil_sludge', amount = 5 },
            { item = 'spark_caps', amount = 5 },
            { item = 'camp_fuel', amount = 5 },
        },
        process = {
            label = 'Mix Rig Juice',
            coords = vec3(1732.27, -1536.24, 112.70),
            heading = 68.03,
            duration = 11000,
            prop = { model = `bkr_prop_meth_table01a`, heading = 68.03 },
            anim = processAnim(),
            output = { item = 'rig_juice', amount = 7 },
            blip = { enabled = false, sprite = 499, color = 17, label = 'Rig Juice Lab' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 515,
            maxPrice = 845,
            minQty = 1,
            maxQty = 4,
        },
        effects = {
            enabled = true,
            noScreenFx = true,
            label = 'Drinking Rig Juice',
            useTime = 3500,
            duration = 45000,
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle', flag = 49 },
            armorPercent = 25,
            stamina = true,
            sprintMultiplier = 1.38,
        },
    },

    --------------------------------------------------
    -- Panhandle Dust — desert speed — fast run + screen FX
    --------------------------------------------------
    panhandle_dust = {
        label = 'Panhandle Dust',
        item = 'panhandle_dust',
        description = 'Desert speed cut with baking soda',
        theme = 'Grand Senora Desert',
        ingredients = {
            { item = 'desert_dust', amount = 5 },
            { item = 'baking_soda', amount = 5 },
            { item = 'zip_bags', amount = 5 },
        },
        process = {
            label = 'Cut Panhandle Dust',
            coords = vec3(1142.20, -299.64, 68.79),
            heading = 269.29,
            duration = 10000,
            prop = { model = `prop_tool_bench02`, heading = 269.29 },
            anim = bagAnim(),
            output = { item = 'panhandle_dust', amount = 7 },
            blip = { enabled = false, sprite = 51, color = 5, label = 'Panhandle Dust Bench' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 170,
            maxPrice = 305,
            minQty = 1,
            maxQty = 6,
        },
        effects = {
            enabled = true,
            noScreenFx = false,
            label = 'Railing Panhandle Dust',
            useTime = 3000,
            duration = 40000,
            anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer', flag = 49 },
            stamina = true,
            sprintMultiplier = 1.42,
            shake = { intensity = 0.28, duration = 5000 },
            timecycle = 'drug_flying_01',
            timecycleStrength = 0.4,
        },
    },

    --------------------------------------------------
    -- Perico Gold — Cayo exclusive — armor + stamina, no screen FX
    --------------------------------------------------
    perico_gold = {
        label = 'Perico Gold',
        item = 'perico_gold',
        description = 'Cayo exclusive gold pills — top street pay',
        theme = 'Cayo Perico',
        ingredients = {
            { item = 'cayo_palm_leaf', amount = 5 },
            { item = 'reef_coral', amount = 5 },
            { item = 'perico_resin', amount = 5 },
            { item = 'gold_capsules', amount = 5 },
        },
        process = {
            label = 'Press Perico Gold',
            coords = vec3(5211.84, -5128.51, 6.20),
            heading = 280.63,
            duration = 15000,
            prop = { model = `prop_tool_bench02`, heading = 280.63 },
            anim = bagAnim(),
            output = { item = 'perico_gold', amount = 7 },
            blip = { enabled = false, sprite = 51, color = 5, label = 'Perico Gold Press' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 1650,
            maxPrice = 2550,
            minQty = 1,
            maxQty = 3,
        },
        effects = {
            enabled = true,
            noScreenFx = true,
            label = 'Popping Perico Gold',
            useTime = 3000,
            duration = 60000,
            anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger', flag = 49 },
            armorPercent = 40,
            stamina = true,
        },
    },

    --------------------------------------------------
    -- PLAYER-OWNED CUSTOM SET
    -- Signature recipes. Same 5x3 → 7 craft rule. Harvest spots are
    -- intentionally off the usual farm/port/warehouse loop.
    --------------------------------------------------

    honda_pills = {
        label = 'Honda Pills',
        item = 'honda_pills',
        playerOwned = true,
        description = 'Player-owned racing pills — Civic bolts, shift powder, red keycaps',
        theme = 'Redwood Lights / Paleto garage',
        ingredients = {
            { item = 'civic_bolts', amount = 5 },
            { item = 'shift_powder', amount = 5 },
            { item = 'red_keycaps', amount = 5 },
        },
        process = {
            label = 'Press Honda Pills',
            coords = vec3(107.17, 6629.63, 31.79),
            heading = 45.0,
            duration = 11000,
            prop = { model = `prop_tool_bench02`, heading = 45.0 },
            anim = bagAnim(),
            output = { item = 'honda_pills', amount = 7 },
            blip = { enabled = false, sprite = 51, color = 1, label = 'Honda Pills Press' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 380,
            maxPrice = 640,
            minQty = 1,
            maxQty = 5,
        },
        effects = {
            enabled = true,
            noScreenFx = false,
            label = 'Popping Honda Pills',
            useTime = 2800,
            duration = 55000,
            anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger', flag = 49 },
            armorPercent = 20,
            stamina = true,
            sprintMultiplier = 1.48,
            timecycle = 'drug_flying_01',
            timecycleStrength = 0.55,
            shake = { intensity = 0.32, duration = 7000 },
        },
    },

    stab_juice = {
        label = 'Stab Juice',
        item = 'stab_juice',
        playerOwned = true,
        description = 'Player-owned combat tonic — rust needles, iodine swabs, alley tonic',
        theme = 'Chiliad cult / Cape Catfish',
        ingredients = {
            { item = 'rust_needles', amount = 5 },
            { item = 'iodine_swabs', amount = 5 },
            { item = 'alley_tonic', amount = 5 },
        },
        process = {
            label = 'Brew Stab Juice',
            coords = vec3(3328.86, 5169.42, 18.31),
            heading = 290.0,
            duration = 12000,
            prop = { model = `bkr_prop_meth_table01a`, heading = 290.0 },
            anim = processAnim(),
            output = { item = 'stab_juice', amount = 7 },
            blip = { enabled = false, sprite = 499, color = 1, label = 'Stab Juice Still' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 420,
            maxPrice = 700,
            minQty = 1,
            maxQty = 5,
        },
        effects = {
            enabled = true,
            noScreenFx = false,
            label = 'Drinking Stab Juice',
            useTime = 3200,
            duration = 60000,
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle', flag = 49 },
            armorPercent = 35,
            health = 35,
            stamina = true,
            sprintMultiplier = 1.32,
            shake = { intensity = 0.42, duration = 8000 },
            walk = 'move_m@drunk@moderatedrunk',
            drunkCamera = true,
        },
    },

    black_lotus = {
        label = 'Black Lotus',
        item = 'black_lotus',
        playerOwned = true,
        description = 'Player-owned night bloom — black petals, temple ash, ink resin',
        theme = 'Pacific Bluffs cemetery / observatory',
        ingredients = {
            { item = 'black_petals', amount = 5 },
            { item = 'temple_ash', amount = 5 },
            { item = 'ink_resin', amount = 5 },
        },
        process = {
            label = 'Bind Black Lotus',
            coords = vec3(-411.52, 1173.18, 325.64),
            heading = 165.0,
            duration = 14000,
            prop = { model = `prop_tool_bench02`, heading = 165.0 },
            anim = bagAnim(),
            output = { item = 'black_lotus', amount = 7 },
            blip = { enabled = false, sprite = 51, color = 27, label = 'Black Lotus Altar' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 520,
            maxPrice = 880,
            minQty = 1,
            maxQty = 4,
        },
        effects = {
            enabled = true,
            noScreenFx = false,
            label = 'Smoking Black Lotus',
            useTime = 4500,
            duration = 75000,
            anim = { dict = 'amb@world_human_smoking@male@male_a@idle_a', clip = 'idle_b', flag = 49 },
            armorPercent = 40,
            stress = -60,
            walk = 'move_m@drunk@verydrunk',
            drunkCamera = true,
            timecycle = 'drug_wobbly',
            timecycleStrength = 0.7,
            shake = { intensity = 0.28, duration = 10000 },
            screenEffect = 'DrugsMichaelAliensFight',
        },
    },

    diesels_pack = {
        label = 'Diesels Pack',
        item = 'diesels_pack',
        playerOwned = true,
        description = 'Player-owned house pack — diesel nugs, grease wrap, iron filters',
        theme = 'Wind farm / McKenzie Field',
        ingredients = {
            { item = 'diesel_nugs', amount = 5 },
            { item = 'grease_wrap', amount = 5 },
            { item = 'iron_filters', amount = 5 },
        },
        process = {
            label = 'Bag Diesels Pack',
            coords = vec3(2137.42, 4795.88, 41.14),
            heading = 25.0,
            duration = 13000,
            prop = { model = `bkr_prop_weed_table_01a`, heading = 25.0 },
            anim = bagAnim(),
            output = { item = 'diesels_pack', amount = 7 },
            blip = { enabled = false, sprite = 469, color = 5, label = 'Diesels Pack Bench' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 900,
            maxPrice = 1500,
            minQty = 1,
            maxQty = 4,
        },
        effects = {
            enabled = true,
            noScreenFx = false,
            label = 'Hitting Diesels Pack',
            useTime = 3500,
            duration = 70000,
            anim = { dict = 'switch@trevor@trev_smoking_meth', clip = 'trev_smoking_meth_loop', flag = 49 },
            armorPercent = 50,
            health = 40,
            stamina = true,
            sprintMultiplier = 1.45,
            timecycle = 'spectator5',
            timecycleStrength = 0.6,
            screenEffect = 'DrugsTrevorClownsFight',
            shake = { intensity = 0.38, duration = 9000 },
        },
    },
}
