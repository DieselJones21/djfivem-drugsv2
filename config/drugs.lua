--[[
    Rebel Roleplay outlaw set — 10 county drugs + 4 player-owned customs

    Branched from Envy. Item IDs are new so both versions can exist on one inventory if needed.

    Each recipe is unique and returns at least as much product as it eats.
    Weed bags use bkr_prop_weed_table_01a, personal drugs use v_ret_ml_tableb,
    everything else uses bkr_prop_coke_table01a. minLevel hides a drug until
    that sell rank. Weed strains pay clean cash; everything else pays black_money.
    Effects are cranked (sprint cap 1.49).
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
    elseif kind == 'personal' then
        model = `v_ret_ml_tableb`
    end
    return {
        model = model,
        heading = heading or 0.0,
    }
end

Config.Drugs = {
    --------------------------------------------------
    -- Longhorn Kush — ranch weed — cash, run + drunk haze
    --------------------------------------------------
    longhorn_kush = {
        label = 'Longhorn Kush',
        item = 'longhorn_kush',
        kind = 'weed',
        minLevel = 1,
        description = 'Outlaw ranch kush that hits harder than it looks',
        theme = 'Grapeseed',
        ingredients = {
            { item = 'horn_nugs', amount = 3 },
            { item = 'zip_bags', amount = 1 },
        },
        process = {
            label = 'Bag Longhorn Kush',
            coords = vec3(1960.85, 5174.22, 47.94),
            heading = 140.0,
            duration = 9000,
            prop = processBench('weed', 140.0),
            anim = bagAnim(),
            output = { item = 'longhorn_kush', amount = 6 },
            blip = { enabled = false, sprite = 469, color = 1, label = 'Longhorn Kush Cook' },
        },
        sell = {
            enabled = true,
            moneyType = 'cash',
            minPrice = 80,
            maxPrice = 140,
            minQty = 1,
            maxQty = 8,
        },
        effects = {
            enabled = true,
            noScreenFx = false,
            label = 'Smoking Longhorn Kush',
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
    -- Dirt Road Haze — country sativa — cash, fast run + screen
    --------------------------------------------------
    dirt_road_haze = {
        label = 'Dirt Road Haze',
        item = 'dirt_road_haze',
        kind = 'weed',
        minLevel = 1,
        description = 'Chaparral haze that lights up the legs',
        theme = 'Great Chaparral',
        ingredients = {
            { item = 'road_nugs', amount = 4 },
            { item = 'zip_bags', amount = 1 },
        },
        process = {
            label = 'Bag Dirt Road Haze',
            coords = vec3(-2194.40, 4290.10, 49.17),
            heading = 235.0,
            duration = 9000,
            prop = processBench('weed', 235.0),
            anim = bagAnim(),
            output = { item = 'dirt_road_haze', amount = 5 },
            blip = { enabled = false, sprite = 469, color = 1, label = 'Dirt Road Haze Cook' },
        },
        sell = {
            enabled = true,
            moneyType = 'cash',
            minPrice = 95,
            maxPrice = 160,
            minQty = 1,
            maxQty = 8,
        },
        effects = {
            enabled = true,
            noScreenFx = false,
            label = 'Smoking Dirt Road Haze',
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
    -- Chrome Snow — industrial coke — heavy armor + run + screen
    --------------------------------------------------
    chrome_snow = {
        label = 'Chrome Snow',
        item = 'chrome_snow',
        kind = 'hard',
        minLevel = 2,
        description = 'City brick cut until it shines',
        theme = 'La Mesa',
        ingredients = {
            { item = 'bush_leaves', amount = 2 },
            { item = 'lab_solvent', amount = 3 },
            { item = 'zip_bags', amount = 1 },
        },
        process = {
            label = 'Cut Chrome Snow',
            coords = vec3(968.20, -1828.40, 31.24),
            heading = 85.0,
            duration = 12000,
            prop = processBench('hard', 85.0),
            anim = processAnim(),
            output = { item = 'chrome_snow', amount = 6 },
            blip = { enabled = false, sprite = 501, color = 0, label = 'Chrome Snow Cook' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 220,
            maxPrice = 370,
            minQty = 1,
            maxQty = 6,
        },
        effects = {
            enabled = true,
            noScreenFx = false,
            label = 'Snorting Chrome Snow',
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
    -- Sandlot Ice — desert meth — max run + wild screen
    --------------------------------------------------
    sandlot_ice = {
        label = 'Sandlot Ice',
        item = 'sandlot_ice',
        kind = 'hard',
        minLevel = 2,
        description = 'Sandy-cooked ice that redlines the legs',
        theme = 'Sandy Shores',
        ingredients = {
            { item = 'lithium_rocks', amount = 4 },
            { item = 'camp_fuel', amount = 1 },
        },
        process = {
            label = 'Cook Sandlot Ice',
            coords = vec3(1391.55, 3606.80, 38.94),
            heading = 200.0,
            duration = 13000,
            prop = processBench('hard', 200.0),
            anim = processAnim(),
            output = { item = 'sandlot_ice', amount = 5 },
            blip = { enabled = false, sprite = 499, color = 17, label = 'Sandlot Ice Cook' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 200,
            maxPrice = 330,
            minQty = 1,
            maxQty = 6,
        },
        effects = {
            enabled = true,
            noScreenFx = false,
            label = 'Hitting Sandlot Ice',
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
    -- Outlaw Brick — tar brick — heavy armor + drunk wreck
    --------------------------------------------------
    outlaw_brick = {
        label = 'Outlaw Brick',
        item = 'outlaw_brick',
        kind = 'hard',
        minLevel = 3,
        description = 'Dock-wrapped brick that drops you in the mud',
        theme = 'Elysian Island',
        ingredients = {
            { item = 'raw_tar', amount = 2 },
            { item = 'wrap_tape', amount = 3 },
            { item = 'zip_bags', amount = 1 },
        },
        process = {
            label = 'Wrap Outlaw Brick',
            coords = vec3(154.40, -3078.20, 5.98),
            heading = 270.0,
            duration = 12000,
            prop = processBench('hard', 270.0),
            anim = bagAnim(),
            output = { item = 'outlaw_brick', amount = 6 },
            blip = { enabled = false, sprite = 501, color = 1, label = 'Outlaw Brick Cook' },
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
            label = 'Using Outlaw Brick',
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
    -- Honkytonk Rolls — molly — max run + wild screen
    --------------------------------------------------
    honkytonk_rolls = {
        label = 'Honkytonk Rolls',
        item = 'honkytonk_rolls',
        kind = 'hard',
        minLevel = 3,
        description = 'Pressed club rolls that blow the roof off',
        theme = 'Alta',
        ingredients = {
            { item = 'club_crystals', amount = 3 },
            { item = 'press_capsules', amount = 1 },
            { item = 'stamp_dies', amount = 2 },
        },
        process = {
            label = 'Press Honkytonk Rolls',
            coords = vec3(372.80, -1267.40, 32.51),
            heading = 50.0,
            duration = 11000,
            prop = processBench('hard', 50.0),
            anim = bagAnim(),
            output = { item = 'honkytonk_rolls', amount = 7 },
            blip = { enabled = false, sprite = 51, color = 1, label = 'Honkytonk Press' },
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
            label = 'Popping Honkytonk Rolls',
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
    -- Swamp Lean — drunk wreck + heavy stress dump
    --------------------------------------------------
    swamp_lean = {
        label = 'Swamp Lean',
        item = 'swamp_lean',
        kind = 'hard',
        minLevel = 1,
        description = 'South-side lean that turns the world purple',
        theme = 'Davis',
        ingredients = {
            { item = 'purple_syrup', amount = 1 },
            { item = 'crushed_ice', amount = 1 },
            { item = 'foam_cups', amount = 1 },
            { item = 'spark_soda', amount = 1 },
            { item = 'hard_candy', amount = 1 },
        },
        process = {
            label = 'Pour Swamp Lean',
            coords = vec3(113.20, -1966.80, 21.33),
            heading = 15.0,
            duration = 10000,
            prop = processBench('hard', 15.0),
            anim = bagAnim(),
            output = { item = 'swamp_lean', amount = 8 },
            blip = { enabled = false, sprite = 499, color = 27, label = 'Swamp Lean Cook' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 120,
            maxPrice = 200,
            minQty = 1,
            maxQty = 5,
        },
        effects = {
            enabled = true,
            noScreenFx = false,
            label = 'Sipping Swamp Lean',
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
    -- Truck Juice — oilfield stim — max run + armor + screen
    --------------------------------------------------
    truck_juice = {
        label = 'Truck Juice',
        item = 'truck_juice',
        kind = 'hard',
        minLevel = 4,
        description = 'Diesel stim that keeps crews redlined',
        theme = 'Power station oil',
        ingredients = {
            { item = 'oil_sludge', amount = 2 },
            { item = 'spark_caps', amount = 3 },
            { item = 'camp_fuel', amount = 1 },
        },
        process = {
            label = 'Mix Truck Juice',
            coords = vec3(2748.10, 1454.60, 24.50),
            heading = 75.0,
            duration = 11000,
            prop = processBench('hard', 75.0),
            anim = processAnim(),
            output = { item = 'truck_juice', amount = 6 },
            blip = { enabled = false, sprite = 499, color = 17, label = 'Truck Juice Cook' },
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
            label = 'Drinking Truck Juice',
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
    -- Gravel Dust — desert speed — max run + flying screen
    --------------------------------------------------
    gravel_dust = {
        label = 'Gravel Dust',
        item = 'gravel_dust',
        kind = 'hard',
        minLevel = 2,
        description = 'Desert speed that rips the horizon',
        theme = 'Grand Senora Desert',
        ingredients = {
            { item = 'desert_dust', amount = 4 },
            { item = 'baking_soda', amount = 1 },
        },
        process = {
            label = 'Cut Gravel Dust',
            coords = vec3(1980.40, 3049.70, 47.22),
            heading = 145.0,
            duration = 10000,
            prop = processBench('hard', 145.0),
            anim = bagAnim(),
            output = { item = 'gravel_dust', amount = 5 },
            blip = { enabled = false, sprite = 51, color = 5, label = 'Gravel Dust Cook' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 160,
            maxPrice = 260,
            minQty = 1,
            maxQty = 6,
        },
        effects = {
            enabled = true,
            noScreenFx = false,
            label = 'Railing Gravel Dust',
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
    -- Cayo Crown — island exclusive — heavy armor + run + screen
    --------------------------------------------------
    cayo_crown = {
        label = 'Cayo Crown',
        item = 'cayo_crown',
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
            label = 'Press Cayo Crown',
            coords = vec3(4904.80, -5743.20, 26.35),
            heading = 330.0,
            duration = 15000,
            prop = processBench('hard', 330.0),
            anim = bagAnim(),
            output = { item = 'cayo_crown', amount = 8 },
            blip = { enabled = false, sprite = 51, color = 5, label = 'Cayo Crown Cook' },
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
            label = 'Popping Cayo Crown',
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

    --------------------------------------------------
    -- PLAYER-OWNED CUSTOM SET
    -- Signature recipes. Yields are not equal — Diesels Pack cooks fat,
    -- Black Lotus is expensive, Honda is in the middle.
    --------------------------------------------------

    honda_pills = {
        label = 'Honda Pills',
        item = 'honda_pills',
        kind = 'personal',
        minLevel = 3,
        playerOwned = true,
        description = 'Player-owned racing pills — Civic bolts, shift powder, red keycaps',
        theme = 'Rockford Hills garage',
        ingredients = {
            { item = 'civic_bolts', amount = 1 },
            { item = 'shift_powder', amount = 3 },
            { item = 'red_keycaps', amount = 2 },
        },
        process = {
            label = 'Press Honda Pills',
            coords = vec3(-1345.90, 55.78, 55.25),
            heading = 277.80,
            duration = 11000,
            prop = processBench('personal', 277.80),
            anim = bagAnim(),
            output = { item = 'honda_pills', amount = 6 },
            blip = { enabled = false, sprite = 51, color = 1, label = 'Honda Pills Cook' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 350,
            maxPrice = 580,
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
            armorPercent = 30,
            stamina = true,
            sprintMultiplier = 1.49,
            timecycle = 'drug_flying_01',
            timecycleStrength = 0.55,
            shake = { intensity = 0.32, duration = 7000 },
        },
    },

    stab_juice = {
        label = 'Stab Juice',
        item = 'stab_juice',
        kind = 'personal',
        minLevel = 4,
        playerOwned = true,
        description = 'Player-owned combat tonic — rust needles, iodine swabs, alley tonic',
        theme = 'Chiliad cult / Cape Catfish',
        ingredients = {
            { item = 'rust_needles', amount = 3 },
            { item = 'iodine_swabs', amount = 1 },
            { item = 'alley_tonic', amount = 2 },
        },
        process = {
            label = 'Brew Stab Juice',
            coords = vec3(3328.86, 5169.42, 18.31),
            heading = 290.0,
            duration = 12000,
            prop = processBench('personal', 290.0),
            anim = processAnim(),
            output = { item = 'stab_juice', amount = 6 },
            blip = { enabled = false, sprite = 499, color = 1, label = 'Stab Juice Cook' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 450,
            maxPrice = 720,
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
            armorPercent = 45,
            health = 50,
            stamina = true,
            sprintMultiplier = 1.40,
            shake = { intensity = 0.42, duration = 8000 },
            walk = 'move_m@drunk@moderatedrunk',
            drunkCamera = true,
        },
    },

    black_lotus = {
        label = 'Black Lotus',
        item = 'black_lotus',
        kind = 'personal',
        minLevel = 4,
        playerOwned = true,
        description = 'Player-owned night bloom — black petals, temple ash, ink resin',
        theme = 'Cypress Flats / Lake Vinewood / Rockford',
        ingredients = {
            { item = 'black_petals', amount = 4 },
            { item = 'temple_ash', amount = 1 },
            { item = 'ink_resin', amount = 1 },
        },
        process = {
            label = 'Bind Black Lotus',
            coords = vec3(1087.81, -212.98, 59.07),
            heading = 351.50,
            duration = 14000,
            prop = processBench('personal', 351.50),
            anim = bagAnim(),
            output = { item = 'black_lotus', amount = 6 },
            blip = { enabled = false, sprite = 51, color = 27, label = 'Black Lotus Cook' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 500,
            maxPrice = 820,
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
            armorPercent = 50,
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
        kind = 'personal',
        minLevel = 5,
        playerOwned = true,
        description = 'Player-owned house pack — diesel nugs, grease wrap, iron filters',
        theme = 'Wind farm / McKenzie Field',
        ingredients = {
            { item = 'diesel_nugs', amount = 2 },
            { item = 'grease_wrap', amount = 3 },
            { item = 'iron_filters', amount = 2 },
        },
        process = {
            label = 'Bag Diesels Pack',
            coords = vec3(2137.42, 4795.88, 41.14),
            heading = 25.0,
            duration = 13000,
            prop = processBench('personal', 25.0),
            anim = bagAnim(),
            output = { item = 'diesels_pack', amount = 8 },
            blip = { enabled = false, sprite = 469, color = 5, label = 'Diesels Pack Cook' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 850,
            maxPrice = 1400,
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
            armorPercent = 60,
            health = 50,
            stamina = true,
            sprintMultiplier = 1.49,
            timecycle = 'spectator5',
            timecycleStrength = 0.6,
            screenEffect = 'DrugsTrevorClownsFight',
            shake = { intensity = 0.38, duration = 9000 },
        },
    },
}
