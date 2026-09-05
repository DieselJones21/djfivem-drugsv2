--[[
    10 Texas-themed drugs for djfivem-drugsv2 (Envy Roleplay)

    Default craft rule: 5 of each ingredient → 7 finished product
    Weed strains pay clean cash; everything else pays black_money.

    Effects:
      noScreenFx = true  → armor / sprint / stamina / stress only (no timecycle, shake, or postfx)
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
            minPrice = 85,
            maxPrice = 165,
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
            minPrice = 110,
            maxPrice = 190,
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
            minPrice = 260,
            maxPrice = 430,
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
            minPrice = 210,
            maxPrice = 370,
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
            minPrice = 320,
            maxPrice = 520,
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
            minPrice = 480,
            maxPrice = 820,
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
            minPrice = 145,
            maxPrice = 265,
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
            minPrice = 560,
            maxPrice = 920,
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
            minPrice = 185,
            maxPrice = 330,
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
            minPrice = 1800,
            maxPrice = 2800,
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
}
