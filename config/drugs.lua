--[[
    7 Miami-themed drugs for djfivem-drugsv2

    Default craft rule: 5 of each ingredient → 7 finished product
    Weed (South Beach Kush) pays clean cash; all others pay black_money.
]]

local COMBAT_STIM = {
    enabled = true,
    duration = 45000,
    armorPercent = 25,
    stamina = true,
}

Config.Drugs = {
    --------------------------------------------------
    -- 305 Heat — neon stim drink (Little Havana)
    --------------------------------------------------
    heat_305 = {
        label = '305 Heat',
        item = 'heat_305',
        description = 'High-octane Miami neon stimulant brew',
        theme = 'Little Havana',
        ingredients = {
            { item = 'neon_crystals', amount = 5 },
            { item = 'miami_solvent', amount = 5 },
            { item = 'vice_jars', amount = 5 },
            { item = 'espresso_powder', amount = 5 },
        },
        process = {
            label = 'Mix 305 Heat',
            coords = vec3(856.71, -943.52, 25.28),
            heading = 268.68,
            duration = 14000,
            prop = {
                model = `bkr_prop_meth_table01a`,
                heading = 268.68,
            },
            anim = {
                dict = 'anim@amb@business@coc@coc_unpack_cut@',
                clip = 'fullcut_cycle_v6_cokecutter',
            },
            output = { item = 'heat_305', amount = 7 },
            blip = { enabled = false, sprite = 499, color = 8, label = '305 Heat Lab' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 550,
            maxPrice = 900,
            minQty = 1,
            maxQty = 4,
        },
        effects = {
            enabled = COMBAT_STIM.enabled,
            label = 'Chugging 305 Heat',
            useTime = 3500,
            duration = COMBAT_STIM.duration,
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle', flag = 49 },
            armorPercent = COMBAT_STIM.armorPercent,
            stamina = COMBAT_STIM.stamina,
        },
    },

    --------------------------------------------------
    -- South Beach Kush — weed (Vespucci Beach)
    --------------------------------------------------
    south_beach_kush = {
        label = 'South Beach Kush',
        item = 'south_beach_kush',
        description = 'Premium beach-grown kush bagged for the streets',
        theme = 'Vespucci Beach',
        ingredients = {
            { item = 'beach_bud', amount = 5 },
            { item = 'zip_bags', amount = 5 },
        },
        process = {
            label = 'Bag South Beach Kush',
            coords = vec3(-1198.70, -1548.40, 4.33),
            heading = 210.0,
            duration = 9000,
            prop = {
                model = `bkr_prop_weed_table_01a`,
                heading = 210.0,
            },
            anim = {
                dict = 'mini@repair',
                clip = 'fixing_a_ped',
            },
            output = { item = 'south_beach_kush', amount = 7 },
            blip = { enabled = false, sprite = 469, color = 8, label = 'Beach Kush Bench' },
        },
        sell = {
            enabled = true,
            moneyType = 'cash',
            minPrice = 80,
            maxPrice = 160,
            minQty = 1,
            maxQty = 8,
        },
        effects = {
            enabled = true,
            label = 'Smoking South Beach Kush',
            useTime = 5000,
            duration = 45000,
            anim = { dict = 'amb@world_human_smoking@male@male_a@idle_a', clip = 'idle_b', flag = 49 },
            stress = -30,
        },
    },

    --------------------------------------------------
    -- Brickell Snow — cocaine (Downtown)
    --------------------------------------------------
    brickell_snow = {
        label = 'Brickell Snow',
        item = 'brickell_snow',
        description = 'Refined downtown snow ready to move',
        theme = 'Brickell',
        ingredients = {
            { item = 'tropical_leaves', amount = 5 },
            { item = 'lab_solvent', amount = 5 },
            { item = 'zip_bags', amount = 5 },
        },
        process = {
            label = 'Cook Brickell Snow',
            coords = vec3(-2972.40, 618.80, 23.18),
            heading = 108.26,
            duration = 12000,
            prop = {
                model = `bkr_prop_coke_table01a`,
                heading = 108.26,
            },
            anim = {
                dict = 'anim@amb@business@coc@coc_unpack_cut@',
                clip = 'fullcut_cycle_v6_cokecutter',
            },
            output = { item = 'brickell_snow', amount = 7 },
            blip = { enabled = false, sprite = 501, color = 0, label = 'Brickell Snow Table' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 250,
            maxPrice = 420,
            minQty = 1,
            maxQty = 6,
        },
        effects = {
            enabled = true,
            label = 'Snorting Brickell Snow',
            useTime = 4000,
            duration = 45000,
            anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer', flag = 49 },
            armorPercent = 15,
            stamina = true,
        },
    },

    --------------------------------------------------
    -- Vice Purple — lean (Davis / Grove)
    --------------------------------------------------
    vice_purple = {
        label = 'Vice Purple',
        item = 'vice_purple',
        description = 'Classic Miami purple cup ready to pour',
        theme = 'Vice City',
        ingredients = {
            { item = 'purple_syrup', amount = 5 },
            { item = 'crushed_ice', amount = 5 },
            { item = 'foam_cups', amount = 5 },
            { item = 'spark_soda', amount = 5 },
            { item = 'hard_candy', amount = 5 },
        },
        process = {
            label = 'Mix Vice Purple',
            coords = vec3(1092.77, -154.72, 54.64),
            heading = 66.12,
            duration = 10000,
            prop = {
                model = `prop_tool_bench02`,
                heading = 66.12,
            },
            anim = {
                dict = 'mini@repair',
                clip = 'fixing_a_ped',
            },
            output = { item = 'vice_purple', amount = 7 },
            blip = { enabled = false, sprite = 499, color = 27, label = 'Vice Purple Bench' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 140,
            maxPrice = 260,
            minQty = 1,
            maxQty = 5,
        },
        effects = {
            enabled = true,
            label = 'Sipping Vice Purple',
            useTime = 4500,
            duration = 45000,
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle', flag = 49 },
            stress = -40,
        },
    },

    --------------------------------------------------
    -- Ocean Drive Rolls — ecstasy (Del Perro)
    --------------------------------------------------
    ocean_drive_rolls = {
        label = 'Ocean Drive Rolls',
        item = 'ocean_drive_rolls',
        description = 'Neon-pressed rolls from the Del Perro strip',
        theme = 'Ocean Drive',
        ingredients = {
            { item = 'drive_crystals', amount = 5 },
            { item = 'neon_powder', amount = 5 },
            { item = 'press_capsules', amount = 5 },
            { item = 'vice_stamps', amount = 5 },
        },
        process = {
            label = 'Press Ocean Drive Rolls',
            coords = vec3(384.63, 3554.60, 32.42),
            heading = 172.92,
            duration = 11000,
            prop = {
                model = `prop_tool_bench02`,
                heading = 172.92,
            },
            anim = {
                dict = 'mini@repair',
                clip = 'fixing_a_ped',
            },
            output = { item = 'ocean_drive_rolls', amount = 7 },
            blip = { enabled = false, sprite = 51, color = 8, label = 'Ocean Drive Press' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 500,
            maxPrice = 850,
            minQty = 1,
            maxQty = 6,
        },
        effects = {
            enabled = true,
            label = 'Popping Ocean Drive Rolls',
            useTime = 3000,
            duration = 45000,
            anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger', flag = 49 },
            stamina = true,
            sprintMultiplier = 1.35,
        },
    },

    --------------------------------------------------
    -- Neon Rush — stim juice (Port)
    --------------------------------------------------
    neon_rush = {
        label = 'Neon Rush',
        item = 'neon_rush',
        description = 'Port-side neon juice ready to move',
        theme = 'Elysian Island',
        ingredients = {
            { item = 'rush_powder', amount = 5 },
            { item = 'neon_candy', amount = 5 },
            { item = 'tropical_concentrate', amount = 5 },
        },
        process = {
            label = 'Mix Neon Rush',
            coords = vec3(1048.50, -3095.80, 5.90),
            heading = 90.0,
            duration = 11000,
            prop = {
                model = `prop_tool_bench02`,
                heading = 90.0,
            },
            anim = {
                dict = 'mini@repair',
                clip = 'fixing_a_ped',
            },
            output = { item = 'neon_rush', amount = 7 },
            blip = { enabled = false, sprite = 499, color = 8, label = 'Neon Rush Lab' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 500,
            maxPrice = 850,
            minQty = 1,
            maxQty = 6,
        },
        effects = {
            enabled = COMBAT_STIM.enabled,
            label = 'Drinking Neon Rush',
            useTime = 4000,
            duration = COMBAT_STIM.duration,
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle', flag = 49 },
            armorPercent = COMBAT_STIM.armorPercent,
            stamina = COMBAT_STIM.stamina,
        },
    },

    --------------------------------------------------
    -- Perico Gold — Cayo exclusive premium pills
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
            coords = vec3(5071.07, -4639.87, 2.11),
            heading = 30.0,
            duration = 15000,
            prop = {
                model = `prop_tool_bench02`,
                heading = 30.0,
            },
            anim = {
                dict = 'mini@repair',
                clip = 'fixing_a_ped',
            },
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
            label = 'Popping Perico Gold',
            useTime = 3000,
            duration = 60000,
            anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger', flag = 49 },
            armorPercent = 40,
            stamina = true,
        },
    },
}
