--[[
    Rebel Roleplay outlaw set — 10 county drugs + 4 player-owned customs

    Branched from Envy. Item IDs are new so both versions can exist on one inventory if needed.

    Each recipe has its own input/output so some cooks are efficient and some
    are expensive on purpose. Weed strains pay clean cash; everything else
    pays black_money. Effects are cranked (sprint cap 1.49, heavy armor, screen FX).
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

local function cooker(model, heading, scenario)
    return {
        model = model,
        heading = heading,
        scenario = scenario or 'WORLD_HUMAN_STAND_IMPATIENT',
    }
end

Config.Drugs = {
    --------------------------------------------------
    -- Longhorn Kush — ranch weed — cash, run + drunk haze
    --------------------------------------------------
    longhorn_kush = {
        label = 'Longhorn Kush',
        item = 'longhorn_kush',
        description = 'Outlaw ranch kush that hits harder than it looks',
        theme = 'Grapeseed',
        ingredients = {
            { item = 'horn_nugs', amount = 2 },
            { item = 'zip_bags', amount = 1 },
        },
        process = {
            label = 'Bag Longhorn Kush',
            coords = vec3(1960.85, 5174.22, 47.94),
            heading = 140.0,
            duration = 9000,
            ped = cooker(`a_m_m_farmer_01`, 140.0, 'WORLD_HUMAN_SMOKING'),
            anim = bagAnim(),
            output = { item = 'longhorn_kush', amount = 8 },
            blip = { enabled = false, sprite = 469, color = 1, label = 'Longhorn Kush Cook' },
        },
        sell = {
            enabled = true,
            moneyType = 'cash',
            minPrice = 90,
            maxPrice = 170,
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
        description = 'Chaparral haze that lights up the legs',
        theme = 'Great Chaparral',
        ingredients = {
            { item = 'road_nugs', amount = 4 },
            { item = 'zip_bags', amount = 2 },
        },
        process = {
            label = 'Bag Dirt Road Haze',
            coords = vec3(-2194.40, 4290.10, 49.17),
            heading = 235.0,
            duration = 9000,
            ped = cooker(`a_m_o_salton_01`, 235.0, 'WORLD_HUMAN_LEANING'),
            anim = bagAnim(),
            output = { item = 'dirt_road_haze', amount = 5 },
            blip = { enabled = false, sprite = 469, color = 1, label = 'Dirt Road Haze Cook' },
        },
        sell = {
            enabled = true,
            moneyType = 'cash',
            minPrice = 115,
            maxPrice = 195,
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
        description = 'City brick cut until it shines',
        theme = 'La Mesa',
        ingredients = {
            { item = 'bush_leaves', amount = 5 },
            { item = 'lab_solvent', amount = 4 },
            { item = 'zip_bags', amount = 2 },
        },
        process = {
            label = 'Cut Chrome Snow',
            coords = vec3(968.20, -1828.40, 31.24),
            heading = 85.0,
            duration = 12000,
            ped = cooker(`g_m_y_mexgoon_01`, 85.0, 'WORLD_HUMAN_STAND_IMPATIENT'),
            anim = processAnim(),
            output = { item = 'chrome_snow', amount = 4 },
            blip = { enabled = false, sprite = 501, color = 0, label = 'Chrome Snow Cook' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 250,
            maxPrice = 410,
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
        description = 'Sandy-cooked ice that redlines the legs',
        theme = 'Sandy Shores',
        ingredients = {
            { item = 'lithium_rocks', amount = 6 },
            { item = 'camp_fuel', amount = 5 },
            { item = 'lab_solvent', amount = 4 },
        },
        process = {
            label = 'Cook Sandlot Ice',
            coords = vec3(1391.55, 3606.80, 38.94),
            heading = 200.0,
            duration = 13000,
            ped = cooker(`a_m_m_rurmeth_01`, 200.0, 'WORLD_HUMAN_CLIPBOARD'),
            anim = processAnim(),
            output = { item = 'sandlot_ice', amount = 4 },
            blip = { enabled = false, sprite = 499, color = 17, label = 'Sandlot Ice Cook' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 205,
            maxPrice = 355,
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
        description = 'Dock-wrapped brick that drops you in the mud',
        theme = 'Elysian Island',
        ingredients = {
            { item = 'raw_tar', amount = 4 },
            { item = 'wrap_tape', amount = 3 },
            { item = 'zip_bags', amount = 2 },
        },
        process = {
            label = 'Wrap Outlaw Brick',
            coords = vec3(154.40, -3078.20, 5.98),
            heading = 270.0,
            duration = 12000,
            ped = cooker(`g_m_y_lost_01`, 270.0, 'WORLD_HUMAN_STAND_MOBILE'),
            anim = bagAnim(),
            output = { item = 'outlaw_brick', amount = 3 },
            blip = { enabled = false, sprite = 501, color = 1, label = 'Outlaw Brick Cook' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 305,
            maxPrice = 500,
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
        description = 'Pressed club rolls that blow the roof off',
        theme = 'Alta',
        ingredients = {
            { item = 'club_crystals', amount = 2 },
            { item = 'press_capsules', amount = 2 },
            { item = 'stamp_dies', amount = 1 },
        },
        process = {
            label = 'Press Honkytonk Rolls',
            coords = vec3(372.80, -1267.40, 32.51),
            heading = 50.0,
            duration = 11000,
            ped = cooker(`a_m_y_hipster_01`, 50.0, 'WORLD_HUMAN_DRINKING'),
            anim = bagAnim(),
            output = { item = 'honkytonk_rolls', amount = 8 },
            blip = { enabled = false, sprite = 51, color = 1, label = 'Honkytonk Press' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 460,
            maxPrice = 780,
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
        description = 'South-side lean that turns the world purple',
        theme = 'Davis',
        ingredients = {
            { item = 'purple_syrup', amount = 2 },
            { item = 'crushed_ice', amount = 2 },
            { item = 'foam_cups', amount = 2 },
            { item = 'spark_soda', amount = 1 },
            { item = 'hard_candy', amount = 1 },
        },
        process = {
            label = 'Pour Swamp Lean',
            coords = vec3(113.20, -1966.80, 21.33),
            heading = 15.0,
            duration = 10000,
            ped = cooker(`g_m_y_famca_01`, 15.0, 'WORLD_HUMAN_DRUG_DEALER'),
            anim = bagAnim(),
            output = { item = 'swamp_lean', amount = 10 },
            blip = { enabled = false, sprite = 499, color = 27, label = 'Swamp Lean Cook' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 140,
            maxPrice = 255,
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
        description = 'Diesel stim that keeps crews redlined',
        theme = 'Power station oil',
        ingredients = {
            { item = 'oil_sludge', amount = 6 },
            { item = 'spark_caps', amount = 4 },
            { item = 'camp_fuel', amount = 3 },
        },
        process = {
            label = 'Mix Truck Juice',
            coords = vec3(2748.10, 1454.60, 24.50),
            heading = 75.0,
            duration = 11000,
            ped = cooker(`s_m_y_construct_01`, 75.0, 'WORLD_HUMAN_SMOKING'),
            anim = processAnim(),
            output = { item = 'truck_juice', amount = 3 },
            blip = { enabled = false, sprite = 499, color = 17, label = 'Truck Juice Cook' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 530,
            maxPrice = 870,
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
        description = 'Desert speed that rips the horizon',
        theme = 'Grand Senora Desert',
        ingredients = {
            { item = 'desert_dust', amount = 3 },
            { item = 'baking_soda', amount = 2 },
            { item = 'zip_bags', amount = 1 },
        },
        process = {
            label = 'Cut Gravel Dust',
            coords = vec3(1980.40, 3049.70, 47.22),
            heading = 145.0,
            duration = 10000,
            ped = cooker(`a_m_m_hillbilly_01`, 145.0, 'WORLD_HUMAN_LEANING'),
            anim = bagAnim(),
            output = { item = 'gravel_dust', amount = 6 },
            blip = { enabled = false, sprite = 51, color = 5, label = 'Gravel Dust Cook' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 180,
            maxPrice = 320,
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
        description = 'Island gold that makes you feel untouchable',
        theme = 'Cayo Perico',
        ingredients = {
            { item = 'cayo_palm_leaf', amount = 8 },
            { item = 'reef_coral', amount = 6 },
            { item = 'perico_resin', amount = 5 },
            { item = 'gold_capsules', amount = 4 },
        },
        process = {
            label = 'Press Cayo Crown',
            coords = vec3(4904.80, -5743.20, 26.35),
            heading = 330.0,
            duration = 15000,
            ped = cooker(`u_m_y_party_01`, 330.0, 'WORLD_HUMAN_STAND_IMPATIENT'),
            anim = bagAnim(),
            output = { item = 'cayo_crown', amount = 2 },
            blip = { enabled = false, sprite = 51, color = 5, label = 'Cayo Crown Cook' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 1700,
            maxPrice = 2700,
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
        playerOwned = true,
        description = 'Player-owned racing pills — Civic bolts, shift powder, red keycaps',
        theme = 'Rockford Hills garage',
        ingredients = {
            { item = 'civic_bolts', amount = 3 },
            { item = 'shift_powder', amount = 3 },
            { item = 'red_keycaps', amount = 2 },
        },
        process = {
            label = 'Press Honda Pills',
            coords = vec3(-1345.90, 55.78, 55.25),
            heading = 277.80,
            duration = 11000,
            ped = cooker(`s_m_m_autoshop_02`, 277.80, 'WORLD_HUMAN_CLIPBOARD'),
            anim = bagAnim(),
            output = { item = 'honda_pills', amount = 5 },
            blip = { enabled = false, sprite = 51, color = 1, label = 'Honda Pills Cook' },
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
        playerOwned = true,
        description = 'Player-owned combat tonic — rust needles, iodine swabs, alley tonic',
        theme = 'Chiliad cult / Cape Catfish',
        ingredients = {
            { item = 'rust_needles', amount = 4 },
            { item = 'iodine_swabs', amount = 3 },
            { item = 'alley_tonic', amount = 3 },
        },
        process = {
            label = 'Brew Stab Juice',
            coords = vec3(3328.86, 5169.42, 18.31),
            heading = 290.0,
            duration = 12000,
            ped = cooker(`g_m_y_mexgoon_02`, 290.0, 'WORLD_HUMAN_DRUG_DEALER'),
            anim = processAnim(),
            output = { item = 'stab_juice', amount = 4 },
            blip = { enabled = false, sprite = 499, color = 1, label = 'Stab Juice Cook' },
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
        playerOwned = true,
        description = 'Player-owned night bloom — black petals, temple ash, ink resin',
        theme = 'Cypress Flats / Lake Vinewood / Rockford',
        ingredients = {
            { item = 'black_petals', amount = 5 },
            { item = 'temple_ash', amount = 4 },
            { item = 'ink_resin', amount = 4 },
        },
        process = {
            label = 'Bind Black Lotus',
            coords = vec3(1087.81, -212.98, 59.07),
            heading = 351.50,
            duration = 14000,
            ped = cooker(`a_f_y_hippie_01`, 351.50, 'WORLD_HUMAN_SMOKING'),
            anim = bagAnim(),
            output = { item = 'black_lotus', amount = 3 },
            blip = { enabled = false, sprite = 51, color = 27, label = 'Black Lotus Cook' },
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
        playerOwned = true,
        description = 'Player-owned house pack — diesel nugs, grease wrap, iron filters',
        theme = 'Wind farm / McKenzie Field',
        ingredients = {
            { item = 'diesel_nugs', amount = 3 },
            { item = 'grease_wrap', amount = 2 },
            { item = 'iron_filters', amount = 2 },
        },
        process = {
            label = 'Bag Diesels Pack',
            coords = vec3(2137.42, 4795.88, 41.14),
            heading = 25.0,
            duration = 13000,
            ped = cooker(`s_m_y_construct_02`, 25.0, 'WORLD_HUMAN_SMOKING'),
            anim = bagAnim(),
            output = { item = 'diesels_pack', amount = 10 },
            blip = { enabled = false, sprite = 469, color = 5, label = 'Diesels Pack Cook' },
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
