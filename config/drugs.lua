--[[
    The 305 — Miami street set (10 drugs, no player-owned customs)

    Weed bags use bkr_prop_weed_table_01a. Everything else uses
    bkr_prop_coke_table01a. minLevel hides a drug until that sell rank.
    Two beach weeds pay clean cash; all others pay black_money.
    Effects stay loud (sprint cap 1.49). Each recipe is unique and
    returns at least as much product as it eats.
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

local function processBench(kind, heading)
    local model = `bkr_prop_coke_table01a`
    if kind == 'weed' then
        model = `bkr_prop_weed_table_01a`
    end
    return {
        model = model,
        heading = heading or 0.0,
    }
end

Config.Drugs = {
    --------------------------------------------------
    -- South Beach Kush — Vespucci Beach — cash
    --------------------------------------------------
    south_beach_kush = {
        label = 'South Beach Kush',
        item = 'south_beach_kush',
        kind = 'weed',
        minLevel = 1,
        description = 'Boardwalk kush bagged for the strip',
        theme = 'South Beach',
        ingredients = {
            { item = 'beach_bud', amount = 3 },
            { item = 'zip_bags', amount = 1 },
        },
        process = {
            label = 'Bag South Beach Kush',
            coords = vec3(-1198.70, -1548.40, 4.33),
            heading = 210.0,
            duration = 9000,
            prop = processBench('weed', 210.0),
            anim = bagAnim(),
            output = { item = 'south_beach_kush', amount = 6 },
            public = true,
            blip = { enabled = true, sprite = 469, color = 8, scale = 0.8, label = 'South Beach Kush Cook' },
        },
        sell = {
            enabled = true,
            moneyType = 'cash',
            minPrice = 92,
            maxPrice = 161,
            minQty = 1,
            maxQty = 8,
        },
        effects = {
            enabled = true,
            noScreenFx = false,
            label = 'Smoking South Beach Kush',
            useTime = 4500,
            duration = 70000,
            anim = { dict = 'amb@world_human_smoking@male@male_a@idle_a', clip = 'idle_b', flag = 49 },
            stress = -45,
            stamina = true,
            sprintMultiplier = 1.28,
            walk = 'move_m@hipster@a',
            timecycle = 'drug_flying_base',
            timecycleStrength = 0.45,
            shake = { intensity = 0.18, duration = 8000 },
        },
    },

    --------------------------------------------------
    -- Calle Ocho Haze — Vespucci Canals / Little Havana
    --------------------------------------------------
    calle_ocho_haze = {
        label = 'Calle Ocho Haze',
        item = 'calle_ocho_haze',
        kind = 'weed',
        minLevel = 1,
        description = 'Canal-grown haze that lights up the legs',
        theme = 'Little Havana',
        ingredients = {
            { item = 'canal_nugs', amount = 4 },
            { item = 'zip_bags', amount = 1 },
        },
        process = {
            label = 'Bag Calle Ocho Haze',
            coords = vec3(-1062.40, -1443.20, 5.42),
            heading = 125.0,
            duration = 9000,
            prop = processBench('weed', 125.0),
            anim = bagAnim(),
            output = { item = 'calle_ocho_haze', amount = 5 },
            public = true,
            blip = { enabled = true, sprite = 469, color = 8, scale = 0.8, label = 'Calle Ocho Haze Cook' },
        },
        sell = {
            enabled = true,
            moneyType = 'cash',
            minPrice = 109,
            maxPrice = 184,
            minQty = 1,
            maxQty = 8,
        },
        effects = {
            enabled = true,
            noScreenFx = false,
            label = 'Smoking Calle Ocho Haze',
            useTime = 4000,
            duration = 65000,
            anim = { dict = 'amb@world_human_smoking@male@male_a@idle_a', clip = 'idle_b', flag = 49 },
            stamina = true,
            sprintMultiplier = 1.40,
            stress = -20,
            timecycle = 'spectator5',
            timecycleStrength = 0.5,
            shake = { intensity = 0.22, duration = 7000 },
        },
    },

    --------------------------------------------------
    -- Vice Purple — Davis / Little Haiti analogue
    --------------------------------------------------
    vice_purple = {
        label = 'Vice Purple',
        item = 'vice_purple',
        kind = 'hard',
        minLevel = 1,
        description = 'South-side lean that turns the world magenta',
        theme = 'Little Haiti',
        ingredients = {
            { item = 'purple_syrup', amount = 1 },
            { item = 'crushed_ice', amount = 1 },
            { item = 'foam_cups', amount = 1 },
            { item = 'spark_soda', amount = 1 },
            { item = 'hard_candy', amount = 1 },
        },
        process = {
            label = 'Pour Vice Purple',
            coords = vec3(113.20, -1966.80, 21.33),
            heading = 15.0,
            duration = 10000,
            prop = processBench('hard', 15.0),
            anim = bagAnim(),
            output = { item = 'vice_purple', amount = 8 },
            blip = { enabled = false, sprite = 499, color = 27, label = 'Vice Purple Cook' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 138,
            maxPrice = 230,
            minQty = 1,
            maxQty = 5,
        },
        effects = {
            enabled = true,
            noScreenFx = false,
            label = 'Sipping Vice Purple',
            useTime = 4000,
            duration = 80000,
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle', flag = 49 },
            stress = -70,
            walk = 'move_m@drunk@verydrunk',
            drunkCamera = true,
            timecycle = 'Drunk',
            timecycleStrength = 0.8,
            shake = { intensity = 0.5, duration = 14000 },
        },
    },

    --------------------------------------------------
    -- 305 Heat — Little Havana stim
    --------------------------------------------------
    heat_305 = {
        label = '305 Heat',
        item = 'heat_305',
        kind = 'hard',
        minLevel = 2,
        description = 'Calle stim that rips the horizon pink',
        theme = 'Little Havana',
        ingredients = {
            { item = 'neon_dust', amount = 4 },
            { item = 'baking_soda', amount = 1 },
        },
        process = {
            label = 'Cut 305 Heat',
            coords = vec3(-1087.60, -1674.80, 4.49),
            heading = 305.0,
            duration = 10000,
            prop = processBench('hard', 305.0),
            anim = bagAnim(),
            output = { item = 'heat_305', amount = 5 },
            blip = { enabled = false, sprite = 51, color = 8, label = '305 Heat Cook' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 184,
            maxPrice = 299,
            minQty = 1,
            maxQty = 6,
        },
        effects = {
            enabled = true,
            noScreenFx = false,
            label = 'Railing 305 Heat',
            useTime = 2500,
            duration = 65000,
            anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer', flag = 49 },
            stamina = true,
            sprintMultiplier = 1.49,
            shake = { intensity = 0.42, duration = 9000 },
            timecycle = 'drug_flying_01',
            timecycleStrength = 0.75,
            screenEffect = 'DrugsTrevorClownsFight',
        },
    },

    --------------------------------------------------
    -- Brickell Snow — downtown high-rise coke
    --------------------------------------------------
    brickell_snow = {
        label = 'Brickell Snow',
        item = 'brickell_snow',
        kind = 'hard',
        minLevel = 2,
        description = 'Tower brick cut until it shines',
        theme = 'Brickell',
        ingredients = {
            { item = 'tropical_leaves', amount = 2 },
            { item = 'lab_solvent', amount = 3 },
            { item = 'zip_bags', amount = 1 },
        },
        process = {
            label = 'Cut Brickell Snow',
            coords = vec3(289.40, -1163.80, 29.29),
            heading = 90.0,
            duration = 12000,
            prop = processBench('hard', 90.0),
            anim = processAnim(),
            output = { item = 'brickell_snow', amount = 6 },
            blip = { enabled = false, sprite = 501, color = 0, label = 'Brickell Snow Cook' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 253,
            maxPrice = 426,
            minQty = 1,
            maxQty = 6,
        },
        effects = {
            enabled = true,
            noScreenFx = false,
            label = 'Snorting Brickell Snow',
            useTime = 3200,
            duration = 70000,
            anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer', flag = 49 },
            armorPercent = 45,
            stamina = true,
            sprintMultiplier = 1.38,
            timecycle = 'spectator5',
            timecycleStrength = 0.7,
            shake = { intensity = 0.4, duration = 9000 },
            screenEffect = 'DrugsMichaelAliensFight',
        },
    },

    --------------------------------------------------
    -- Biscayne Ice — Del Perro marina meth
    --------------------------------------------------
    biscayne_ice = {
        label = 'Biscayne Ice',
        item = 'biscayne_ice',
        kind = 'hard',
        minLevel = 2,
        description = 'Marina-cooked ice that redlines the legs',
        theme = 'Biscayne',
        ingredients = {
            { item = 'tide_rocks', amount = 4 },
            { item = 'boat_fuel', amount = 1 },
        },
        process = {
            label = 'Cook Biscayne Ice',
            coords = vec3(-806.40, -1349.60, 5.17),
            heading = 140.0,
            duration = 13000,
            prop = processBench('hard', 140.0),
            anim = processAnim(),
            output = { item = 'biscayne_ice', amount = 5 },
            blip = { enabled = false, sprite = 499, color = 3, label = 'Biscayne Ice Cook' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 230,
            maxPrice = 380,
            minQty = 1,
            maxQty = 6,
        },
        effects = {
            enabled = true,
            noScreenFx = false,
            label = 'Hitting Biscayne Ice',
            useTime = 2800,
            duration = 75000,
            anim = { dict = 'switch@trevor@trev_smoking_meth', clip = 'trev_smoking_meth_loop', flag = 49 },
            stamina = true,
            sprintMultiplier = 1.49,
            shake = { intensity = 0.55, duration = 12000 },
            timecycle = 'drug_wobbly',
            timecycleStrength = 0.75,
            screenEffect = 'DrugsTrevorClownsFight',
            drunkCamera = true,
        },
    },

    --------------------------------------------------
    -- Port Brick — Port of Miami analogue
    --------------------------------------------------
    port_brick = {
        label = 'Port Brick',
        item = 'port_brick',
        kind = 'hard',
        minLevel = 3,
        description = 'Dock-wrapped brick that drops you in the tide',
        theme = 'Port of Miami',
        ingredients = {
            { item = 'port_tar', amount = 2 },
            { item = 'wrap_tape', amount = 3 },
            { item = 'zip_bags', amount = 1 },
        },
        process = {
            label = 'Wrap Port Brick',
            coords = vec3(154.40, -3078.20, 5.98),
            heading = 270.0,
            duration = 12000,
            prop = processBench('hard', 270.0),
            anim = bagAnim(),
            output = { item = 'port_brick', amount = 6 },
            blip = { enabled = false, sprite = 501, color = 1, label = 'Port Brick Cook' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 280,
            maxPrice = 450,
            minQty = 1,
            maxQty = 5,
        },
        effects = {
            enabled = true,
            noScreenFx = false,
            label = 'Using Port Brick',
            useTime = 4000,
            duration = 80000,
            anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer', flag = 49 },
            armorPercent = 55,
            health = 25,
            walk = 'move_m@drunk@verydrunk',
            drunkCamera = true,
            shake = { intensity = 0.45, duration = 10000 },
            timecycle = 'drug_wobbly',
            timecycleStrength = 0.65,
        },
    },

    --------------------------------------------------
    -- Ocean Drive Rolls — Del Perro strip molly
    --------------------------------------------------
    ocean_drive_rolls = {
        label = 'Ocean Drive Rolls',
        item = 'ocean_drive_rolls',
        kind = 'hard',
        minLevel = 3,
        description = 'Pressed strip rolls that blow the roof off',
        theme = 'Ocean Drive',
        ingredients = {
            { item = 'drive_crystals', amount = 3 },
            { item = 'press_capsules', amount = 1 },
            { item = 'vice_stamps', amount = 2 },
        },
        process = {
            label = 'Press Ocean Drive Rolls',
            coords = vec3(-1535.20, -454.80, 35.89),
            heading = 50.0,
            duration = 11000,
            prop = processBench('hard', 50.0),
            anim = bagAnim(),
            output = { item = 'ocean_drive_rolls', amount = 7 },
            blip = { enabled = false, sprite = 51, color = 8, label = 'Ocean Drive Press' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 400,
            maxPrice = 680,
            minQty = 1,
            maxQty = 6,
        },
        effects = {
            enabled = true,
            noScreenFx = false,
            label = 'Popping Ocean Drive Rolls',
            useTime = 2500,
            duration = 70000,
            anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger', flag = 49 },
            stamina = true,
            sprintMultiplier = 1.49,
            health = 20,
            armorPercent = 15,
            screenEffect = 'DrugsMichaelAliensFight',
            timecycle = 'drug_flying_01',
            timecycleStrength = 0.7,
            shake = { intensity = 0.4, duration = 8000 },
        },
    },

    --------------------------------------------------
    -- Neon Rush — port stim juice
    --------------------------------------------------
    neon_rush = {
        label = 'Neon Rush',
        item = 'neon_rush',
        kind = 'hard',
        minLevel = 4,
        description = 'Port-side neon juice that keeps crews redlined',
        theme = 'Port of Miami',
        ingredients = {
            { item = 'rush_sludge', amount = 2 },
            { item = 'neon_caps', amount = 3 },
            { item = 'boat_fuel', amount = 1 },
        },
        process = {
            label = 'Mix Neon Rush',
            coords = vec3(1048.50, -3095.80, 5.90),
            heading = 90.0,
            duration = 11000,
            prop = processBench('hard', 90.0),
            anim = processAnim(),
            output = { item = 'neon_rush', amount = 6 },
            blip = { enabled = false, sprite = 499, color = 8, label = 'Neon Rush Cook' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 480,
            maxPrice = 780,
            minQty = 1,
            maxQty = 4,
        },
        effects = {
            enabled = true,
            noScreenFx = false,
            label = 'Drinking Neon Rush',
            useTime = 2800,
            duration = 70000,
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle', flag = 49 },
            armorPercent = 45,
            stamina = true,
            sprintMultiplier = 1.49,
            timecycle = 'drug_flying_01',
            timecycleStrength = 0.55,
            shake = { intensity = 0.35, duration = 8000 },
        },
    },

    --------------------------------------------------
    -- Perico Gold — Cayo exclusive
    --------------------------------------------------
    perico_gold = {
        label = 'Perico Gold',
        item = 'perico_gold',
        kind = 'hard',
        minLevel = 5,
        description = 'Island gold that makes you feel untouchable',
        theme = 'Cayo Perico',
        ingredients = {
            { item = 'cayo_palm_leaf', amount = 2 },
            { item = 'reef_coral', amount = 3 },
            { item = 'perico_resin', amount = 1 },
            { item = 'gold_capsules', amount = 2 },
        },
        process = {
            label = 'Press Perico Gold',
            coords = vec3(4904.80, -5743.20, 26.35),
            heading = 330.0,
            duration = 15000,
            prop = processBench('hard', 330.0),
            anim = bagAnim(),
            output = { item = 'perico_gold', amount = 8 },
            blip = { enabled = false, sprite = 51, color = 5, label = 'Perico Gold Cook' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 1600,
            maxPrice = 2500,
            minQty = 1,
            maxQty = 3,
        },
        effects = {
            enabled = true,
            noScreenFx = false,
            label = 'Popping Perico Gold',
            useTime = 2800,
            duration = 90000,
            anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger', flag = 49 },
            armorPercent = 65,
            stamina = true,
            sprintMultiplier = 1.42,
            health = 40,
            timecycle = 'MP_corona_heist_DOF',
            timecycleStrength = 0.55,
            screenEffect = 'DrugsMichaelAliensFight',
            shake = { intensity = 0.25, duration = 6000 },
        },
    },
}
