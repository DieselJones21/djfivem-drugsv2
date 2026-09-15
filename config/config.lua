Config = {}

--[[
    djfivem-drugsv2 — The 305 Miami street economy

    Harvest → process → /trap. No player-owned personal drugs.
]]

Config.Debug = false
Config.Locale = 'en'
Config.Brand = 'The 305'

Config.MoneyType = 'cash'
Config.DirtyMoneyType = 'black_money'
Config.FrameworkMoneyTypes = {
    cash = true,
    bank = true,
    crypto = true,
}

Config.InteractDistance = 2.2
Config.ProgressCancelOnMove = true

-- Harvest weed plants, process benches, ingredient peds, informant, bulk crates:
-- darktrovx/interact (E). Street buyers stay on ox_target (3rd eye).
Config.Target = {
    resource = 'interact',
    fallback = 'ox_target',
    distance = 8.0,
    interactDst = 1.5,
    offset = vec3(0.0, 0.0, 0.45),
}

Config.Police = {
    enabled = false, -- cop-count gate for /trap (leave false to always allow trapping)
    jobs = { 'police', 'sheriff' },
    minimum = 0,
    alertChance = 35,
}

-- Snitch ping after a "bad" street / bulk sale. Sale still pays.
-- Primary: wasabi_mdt server CreateDispatch (MDT + Wasabi dispatch HUD).
-- Do NOT use the client CreateDispatch for this — Wasabi only accepts that
-- from players who can open the MDT, and the snitch is a civilian.
-- dispatchType must exist in Wasabi Config.DispatchTypes (disturbance is stock).
-- Departments come from Wasabi's own config; there is no jobs field on CreateDispatch.
-- Fallback: ps-dispatch client DrugSale / CustomAlert if Wasabi is missing.
Config.Dispatch = {
    enabled = true,
    resource = 'wasabi_mdt',
    fallback = 'ps-dispatch',
    chance = 35,
    code = '10-66',
    dispatchType = 'disturbance',
    title = 'Drug Sale',
    message = 'Suspicious street sale',
    description = 'A civilian reported a street drug sale.',
    senderName = 'Anonymous tip',
    priority = 3,
    jobs = { 'leo', 'police', 'sheriff' }, -- ps-dispatch fallback only
    sprite = 51,
    color = 1,
    scale = 1.0,
    length = 3,
}

-- Weed plants despawn when picked and grow back at another pool point.
-- Longer than supply peds so fields feel like a real grow.
Config.WeedRespawn = {
    min = 45,
    max = 90,
}

-- Fallback if a leftover non-weed prop field is still configured.
Config.HarvestRespawn = {
    min = 8,
    max = 14,
}

-- Universal cut. 1 lace per unit sold on /trap (and bulk) pays extra.
Config.Lace = {
    item = 'street_lace',
    label = 'Vice Lace',
    pricePercent = 0.35,
    perUnit = 1,
    applyToBulk = true,
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
    -- Lines the street buyer says out loud (3D text + ambient speech).
    talk = {
        good = {
            'Hell yeah. That is the good shit.',
            'Clean pack. I will be back.',
            'We are good. Do not follow me.',
            'That is a deal. Stay low.',
        },
        snitch = {
            'Cops on me — you set me up!',
            'I am calling this in, asshole!',
            'Nah, this is heat. Five-oh!',
        },
        fail = {
            'Forget it. Keep your trash.',
            'I am not touching that.',
        },
        walk = {
            'You are wasting my time.',
            'Forget it. I am gone.',
        },
        refuse = {
            'I ain\'t paying that.',
            'Lower it or I am walking.',
        },
        haggle = {
            'Alright, alright — I will bump it.',
            'Fine. Do not get greedy.',
        },
        counter = {
            'Meet in the middle. Take it or leave it.',
            'That is as high as I go.',
        },
        decline = {
            'Whatever. Stay away from me.',
        },
        speech = {
            good = 'GENERIC_THANKS',
            snitch = 'GENERIC_INSULT_HIGH',
            fail = 'GENERIC_INSULT_MED',
            walk = 'GENERIC_FRIGHTENED_HIGH',
            refuse = 'GENERIC_NO',
            haggle = 'GENERIC_THANKS',
            counter = 'GENERIC_HI',
            decline = 'GENERIC_INSULT_MED',
        },
    },
}

Config.UseEffects = true
Config.EffectCooldown = 12
Config.StressEvent = 'hud:server:RelieveStress'
Config.StressGainEvent = nil

Config.IngredientAmount = { min = 5, max = 10 }
Config.IngredientCooldown = 4

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
    -- 15-minute lead-in: Discord + city get a warning, then the boost goes live.
    warningSeconds = 15 * 60,
    -- Also warn Discord / city 15 minutes before a live boost ends.
    endingWarningSeconds = 15 * 60,
    -- Paste a Discord webhook URL, or set convar djdrugsv2_boost_webhook
    discordWebhook = (GetConvar and GetConvar('djdrugsv2_boost_webhook', '') ~= '' and GetConvar('djdrugsv2_boost_webhook', ''))
        or 'https://discord.com/api/webhooks/1548557503992696832/DKk722nRUAH_lhTQHi-hAFChx0BwNWdcdRjxYLBDFXfjurTWY4bSMrxxHnPeF4TeTYlx',
    discordUsername = '305 Boost Desk',
}

Config.Help = {
    command = 'drughelp',
    description = 'How the 305 drug system works',
}

-- Hidden locations. Pay for one GPS mark at a time; after the tour you can
-- buy the remaining / full pack. 1 hour cooldown either way.
Config.Informant = {
    enabled = true,
    label = 'Ask about a stash',
    coords = vec3(-1234.80, -1476.40, 4.32),
    heading = 215.0,
    model = `g_m_m_chiboss_01`,
    scenario = 'WORLD_HUMAN_SMOKING',
    moneyType = 'cash',
    singlePrice = 75000, -- each GPS mark
    allPrice = nil, -- charged as singlePrice x remaining marks
    cooldown = 60 * 60,
    blip = { enabled = true, sprite = 280, color = 8, scale = 0.75, label = 'Street Intel' },
}

Config.Progression = {
    enabled = true,
    command = 'drugboard',
    description = 'Open drug sell leaderboard and your rank',
    leaderboardSize = 10,
    levels = {
        { level = 1, sold = 0,    label = 'Beach Runner',   payoutMultiplier = 1.00 },
        { level = 2, sold = 250,  label = 'Vice Hustler',   payoutMultiplier = 1.04 },
        { level = 3, sold = 800,  label = 'Ocean Plug',     payoutMultiplier = 1.08 },
        { level = 4, sold = 2000, label = 'Port Boss',      payoutMultiplier = 1.12 },
        { level = 5, sold = 4500, label = '305 Kingpin',    payoutMultiplier = 1.18 },
    },
}

Config.Stores = {}
Config.Machines = {}

--[[
    /drugbulksell — warehouse drops. 100–200 units at a cut below street
    trap prices because the sale is instant and you pick the drop.
]]
Config.BulkSell = {
    enabled = true,
    command = 'drugbulksell',
    cancelCommand = 'drugbulkcancel',
    description = 'Take a bulk delivery order',
    minQty = 100,
    maxQty = 200,
    pricePercent = 0.55, -- of street minPrice (rank may apply on top)
    rankApplies = true,
    boostApplies = false,
    cooldown = 8 * 60,
    cancelCooldown = 4 * 60,
    jobTimeout = 20 * 60,
    deliverDuration = 12000,
    interactDistance = 2.2,
    crateModel = `prop_box_wood02a`,
    dispatchChance = 15,
    anim = {
        dict = 'anim@heists@box_carry@',
        clip = 'idle',
        flag = 49,
    },
    blip = {
        enabled = true,
        sprite = 478,
        color = 1,
        scale = 0.9,
        route = true,
        label = 'Bulk Drop',
    },
    locations = {
        { id = 'port_crates', label = 'Port of Miami crate yard', coords = vec3(164.12, -3312.55, 5.96) },
        { id = 'wynwood_yard', label = 'Wynwood loading bay', coords = vec3(837.21, -1936.40, 28.97) },
        { id = 'design_depot', label = 'Design District depot', coords = vec3(913.55, -1561.22, 30.74) },
        { id = 'brickell_garage', label = 'Brickell garage alley', coords = vec3(-139.80, -631.40, 32.42) },
        { id = 'little_havana_lot', label = 'Little Havana backlot', coords = vec3(-1078.40, -1652.20, 4.45) },
        { id = 'south_beach_marina', label = 'South Beach marina', coords = vec3(-802.50, -1351.80, 5.17) },
        { id = 'ocean_drive_alley', label = 'Ocean Drive garage alley', coords = vec3(-1393.55, -588.10, 30.32) },
        { id = 'terminal_stack', label = 'Port terminal stack', coords = vec3(1181.40, -3113.80, 6.03) },
        { id = 'lsia_cargo', label = 'Airport cargo fence', coords = vec3(-941.50, -2954.80, 13.95) },
        { id = 'downtown_backlot', label = 'Downtown backlot', coords = vec3(970.40, -126.55, 74.36) },
    },
}


--[[
    Harvest spots.
    Weed plants stay as per-player prop fields (pick one, it dies, another grows).
    Every other ingredient is a single sidewalk ped on interact (E) so missing
    props cannot brick the loop. One ped per ingredient. No map blips — the
    informant sells GPS marks. Peds snap to floor height on the client.
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
    opts.weed = true
    opts.plant = true
    opts.amount = opts.amount or Config.IngredientAmount or { min = 5, max = 10 }
    opts.cooldown = opts.cooldown or Config.IngredientCooldown or 10
    opts.visibleCount = opts.visibleCount or 6
    opts.clientUnique = true
    opts.positions = opts.positions or scatter(opts.coords.x, opts.coords.y, opts.coords.z, opts.pool or 16, opts.radius or 8.0)
    opts.blip = opts.blip or { enabled = false, sprite = 469, color = 2, label = opts.label }
    opts.anim = opts.anim or { dict = 'amb@world_human_gardener_plant@male@base', clip = 'base' }
    return opts
end

local function pedSpot(opts)
    opts.type = 'ped'
    opts.amount = opts.amount or Config.IngredientAmount or { min = 5, max = 10 }
    opts.cooldown = opts.cooldown or Config.IngredientCooldown or 10
    opts.clientUnique = false
    opts.heading = opts.heading or 0.0
    opts.model = opts.model or `g_m_y_mexgoon_01`
    opts.scenario = opts.scenario or 'WORLD_HUMAN_DRUG_DEALER'
    opts.anim = opts.anim or { dict = 'mp_common', clip = 'givetake1_a' }
    opts.blip = opts.blip or { enabled = false, sprite = 501, color = 3, label = opts.label }
    return opts
end

Config.Harvest = {
    --------------------------------------------------
    -- WEED PLANTS — South Beach + Calle Ocho
    --------------------------------------------------
    field({
        id = 'beach_bud_field',
        item = 'beach_bud',
        label = 'Harvest Beach Bud',
        public = true,
        coords = vec3(-1172.40, -1570.80, 4.35),
        radius = 10.0,
        pool = 20,
        model = `prop_weed_01`,
        duration = 6500,
        blip = { enabled = true, sprite = 469, color = 8, scale = 0.75, label = 'Beach Bud' },
    }),
    field({
        id = 'canal_nugs_field',
        item = 'canal_nugs',
        label = 'Harvest Canal Nugs',
        public = true,
        coords = vec3(-1075.20, -1255.40, 5.42),
        radius = 10.0,
        pool = 16,
        model = `prop_weed_01`,
        duration = 6500,
        blip = { enabled = true, sprite = 469, color = 8, scale = 0.75, label = 'Canal Nugs' },
    }),

    --------------------------------------------------
    -- SOUTH BEACH / LITTLE HAVANA supplies
    --------------------------------------------------
    pedSpot({
        id = 'zip_bags_supply',
        item = 'zip_bags',
        label = 'Buy Zip Bags',
        public = true,
        coords = vec3(-1221.40, -1488.60, 4.35),
        heading = 125.0,
        model = `a_m_y_beach_01`,
        duration = 5000,
        blip = { enabled = true, sprite = 478, color = 8, scale = 0.75, label = 'Zip Bags' },
    }),
    pedSpot({
        id = 'neon_dust',
        item = 'neon_dust',
        label = 'Buy Neon Dust',
        coords = vec3(-1082.40, -1650.20, 4.45),
        heading = 305.0,
        model = `g_m_y_mexgoon_01`,
        duration = 6500,
    }),
    pedSpot({
        id = 'baking_soda',
        item = 'baking_soda',
        label = 'Buy Baking Soda',
        coords = vec3(-1185.20, -1510.40, 4.65),
        heading = 210.0,
        model = `s_m_m_strvend_01`,
        scenario = 'WORLD_HUMAN_CLIPBOARD',
        duration = 5000,
    }),

    --------------------------------------------------
    -- BRICKELL / DOWNTOWN
    --------------------------------------------------
    pedSpot({
        id = 'tropical_leaves',
        item = 'tropical_leaves',
        label = 'Buy Tropical Leaves',
        coords = vec3(250.50, -800.20, 29.30),
        heading = 160.0,
        model = `a_m_m_farmer_01`,
        scenario = 'WORLD_HUMAN_SMOKING',
        duration = 6000,
    }),
    pedSpot({
        id = 'lab_solvent',
        item = 'lab_solvent',
        label = 'Buy Lab Solvent',
        coords = vec3(127.80, -1297.40, 29.27),
        heading = 270.0,
        model = `s_m_m_chemsec_01`,
        scenario = 'WORLD_HUMAN_CLIPBOARD',
        duration = 6000,
    }),

    --------------------------------------------------
    -- BISCAYNE / DEL PERRO MARINA
    --------------------------------------------------
    pedSpot({
        id = 'tide_rocks',
        item = 'tide_rocks',
        label = 'Buy Tide Rocks',
        coords = vec3(-1850.20, -1232.40, 13.02),
        heading = 140.0,
        model = `a_m_y_surfer_01`,
        scenario = 'WORLD_HUMAN_STAND_IMPATIENT',
        duration = 7000,
    }),
    pedSpot({
        id = 'boat_fuel',
        item = 'boat_fuel',
        label = 'Buy Boat Fuel',
        coords = vec3(-820.40, -1342.20, 5.15),
        heading = 50.0,
        model = `s_m_y_construct_01`,
        scenario = 'WORLD_HUMAN_CLIPBOARD',
        duration = 6500,
    }),

    --------------------------------------------------
    -- PORT OF MIAMI
    --------------------------------------------------
    pedSpot({
        id = 'port_tar',
        item = 'port_tar',
        label = 'Buy Port Tar',
        coords = vec3(38.22, -2678.55, 6.01),
        heading = 0.0,
        model = `g_m_y_lost_01`,
        scenario = 'WORLD_HUMAN_SMOKING',
        duration = 7000,
    }),
    pedSpot({
        id = 'wrap_tape',
        item = 'wrap_tape',
        label = 'Buy Wrap Tape',
        coords = vec3(164.12, -3312.55, 5.96),
        heading = 180.0,
        model = `s_m_m_autoshop_01`,
        scenario = 'WORLD_HUMAN_CLIPBOARD',
        duration = 5000,
    }),
    pedSpot({
        id = 'rush_sludge',
        item = 'rush_sludge',
        label = 'Buy Rush Sludge',
        coords = vec3(1200.40, -3100.80, 5.80),
        heading = 90.0,
        model = `s_m_y_construct_02`,
        scenario = 'WORLD_HUMAN_SMOKING',
        duration = 7000,
    }),
    pedSpot({
        id = 'neon_caps',
        item = 'neon_caps',
        label = 'Buy Neon Caps',
        coords = vec3(1181.40, -3113.80, 6.03),
        heading = 270.0,
        model = `s_m_y_construct_01`,
        scenario = 'WORLD_HUMAN_CLIPBOARD',
        duration = 6000,
    }),

    --------------------------------------------------
    -- OCEAN DRIVE / DEL PERRO STRIP
    --------------------------------------------------
    pedSpot({
        id = 'drive_crystals',
        item = 'drive_crystals',
        label = 'Buy Drive Crystals',
        coords = vec3(-1478.20, -674.40, 28.94),
        heading = 50.0,
        model = `a_m_y_hipster_02`,
        duration = 7000,
    }),
    pedSpot({
        id = 'press_capsules',
        item = 'press_capsules',
        label = 'Buy Press Capsules',
        coords = vec3(-1393.55, -588.10, 30.32),
        heading = 310.0,
        model = `s_m_m_autoshop_02`,
        scenario = 'WORLD_HUMAN_CLIPBOARD',
        duration = 6000,
    }),
    pedSpot({
        id = 'vice_stamps',
        item = 'vice_stamps',
        label = 'Buy Vice Stamps',
        coords = vec3(-1289.55, -1115.80, 6.99),
        heading = 215.0,
        model = `u_m_y_party_01`,
        scenario = 'WORLD_HUMAN_STAND_IMPATIENT',
        duration = 5500,
    }),

    --------------------------------------------------
    -- VICE PURPLE — Davis / Little Haiti analogue
    --------------------------------------------------
    pedSpot({
        id = 'purple_syrup_stash',
        item = 'purple_syrup',
        label = 'Buy Purple Syrup',
        coords = vec3(243.40, -1785.20, 28.70),
        heading = 15.0,
        model = `g_m_y_famdnf_01`,
        duration = 7500,
    }),
    pedSpot({
        id = 'crushed_ice',
        item = 'crushed_ice',
        label = 'Buy Crushed Ice',
        coords = vec3(29.80, -1340.10, 29.50),
        heading = 270.0,
        model = `s_m_m_strvend_01`,
        scenario = 'WORLD_HUMAN_STAND_IMPATIENT',
        duration = 5000,
    }),
    pedSpot({
        id = 'foam_cups',
        item = 'foam_cups',
        label = 'Buy Foam Cups',
        coords = vec3(75.50, -1391.80, 29.38),
        heading = 90.0,
        model = `s_m_y_shop_mask`,
        scenario = 'WORLD_HUMAN_STAND_IMPATIENT',
        duration = 5000,
    }),
    pedSpot({
        id = 'spark_soda',
        item = 'spark_soda',
        label = 'Buy Spark Soda',
        coords = vec3(99.80, -1922.40, 20.80),
        heading = 80.0,
        model = `a_m_y_hipster_01`,
        scenario = 'WORLD_HUMAN_SMOKING',
        duration = 5500,
    }),
    pedSpot({
        id = 'hard_candy',
        item = 'hard_candy',
        label = 'Buy Hard Candy',
        coords = vec3(132.40, -1712.10, 29.29),
        heading = 220.0,
        model = `a_m_y_hipster_01`,
        duration = 5500,
    }),
    pedSpot({
        id = 'street_lace',
        item = 'street_lace',
        label = 'Buy Vice Lace',
        coords = vec3(-468.55, -1718.10, 18.69),
        heading = 160.0,
        model = `g_m_y_ballasout_01`,
        duration = 5000,
    }),

    --------------------------------------------------
    -- CAYO PERICO
    --------------------------------------------------
    pedSpot({
        id = 'cayo_palm_leaf',
        item = 'cayo_palm_leaf',
        label = 'Buy Cayo Palm Leaves',
        coords = vec3(4890.20, -4921.40, 3.37),
        heading = 140.0,
        model = `a_m_y_beachvesp_01`,
        scenario = 'WORLD_HUMAN_SMOKING',
        duration = 6500,
    }),
    pedSpot({
        id = 'reef_coral',
        item = 'reef_coral',
        label = 'Buy Reef Coral',
        coords = vec3(5132.80, -5115.60, 2.20),
        heading = 200.0,
        model = `a_m_y_surfer_01`,
        scenario = 'WORLD_HUMAN_STAND_IMPATIENT',
        duration = 7000,
    }),
    pedSpot({
        id = 'perico_resin',
        item = 'perico_resin',
        label = 'Buy Perico Resin',
        coords = vec3(4968.40, -5108.20, 2.98),
        heading = 250.0,
        model = `g_m_y_mexgoon_01`,
        duration = 7500,
    }),
    pedSpot({
        id = 'gold_capsules',
        item = 'gold_capsules',
        label = 'Buy Gold Capsules',
        coords = vec3(4991.10, -5716.40, 19.88),
        heading = 330.0,
        model = `u_m_y_party_01`,
        scenario = 'WORLD_HUMAN_STAND_IMPATIENT',
        duration = 6500,
    }),
}

