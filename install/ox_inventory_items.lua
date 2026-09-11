--[[
    Merge into ox_inventory/data/items.lua

    Finished drugs MUST include:
      server = { export = 'djfivem-drugsv2.useDrugServer' }

    Copy install/images/*.png into ox_inventory/web/images/
    (overwrite any old outline or previous stills)

    Rebel Roleplay branch — item IDs differ from the Envy set so both
    versions can live in one inventory if needed.
]]

local drugUse = {
    export = 'djfivem-drugsv2.useDrugServer',
}

return {
    ['black_money'] = {
        label = 'Dirty Money',
    },

    ['horn_nugs'] = { label = 'Horn Nugs', weight = 30, stack = true, close = true, description = 'Grapeseed ranch nugs for Longhorn Kush' },
    ['road_nugs'] = { label = 'Road Nugs', weight = 30, stack = true, close = true, description = 'Chaparral haze nugs for Dirt Road Haze' },
    ['zip_bags'] = { label = 'Zip Bags', weight = 10, stack = true, close = true, description = 'Small zip bags for packaging product' },
    ['bush_leaves'] = { label = 'Bush Leaves', weight = 35, stack = true, close = true, description = 'Raw leaves for Chrome Snow' },
    ['lab_solvent'] = { label = 'Lab Solvent', weight = 120, stack = true, close = true, description = 'Industrial solvent for cook tables' },
    ['lithium_rocks'] = { label = 'Lithium Rocks', weight = 50, stack = true, close = true, description = 'Broken lithium rock for Sandlot Ice' },
    ['camp_fuel'] = { label = 'Camp Fuel', weight = 100, stack = true, close = true, description = 'Camp fuel used in desert cooks' },
    ['raw_tar'] = { label = 'Raw Tar', weight = 55, stack = true, close = true, description = 'Dock-side tar for Outlaw Brick' },
    ['wrap_tape'] = { label = 'Wrap Tape', weight = 15, stack = true, close = true, description = 'Heavy tape for wrapping bricks' },
    ['club_crystals'] = { label = 'Club Crystals', weight = 40, stack = true, close = true, description = 'Raw crystals for Honkytonk Rolls' },
    ['press_capsules'] = { label = 'Press Capsules', weight = 20, stack = true, close = true, description = 'Empty capsules for pressing pills' },
    ['stamp_dies'] = { label = 'Stamp Dies', weight = 20, stack = true, close = true, description = 'Press dies stamped for club rolls' },
    ['purple_syrup'] = { label = 'Purple Syrup', weight = 40, stack = true, close = true, description = 'Thick purple syrup base' },
    ['crushed_ice'] = { label = 'Crushed Ice', weight = 20, stack = true, close = true, description = 'Finely crushed ice for mixing' },
    ['foam_cups'] = { label = 'Foam Cups', weight = 15, stack = true, close = true, description = 'Styrofoam cups for Swamp Lean' },
    ['spark_soda'] = { label = 'Spark Soda', weight = 50, stack = true, close = true, description = 'Carbonated soda for lean mixing' },
    ['hard_candy'] = { label = 'Hard Candy', weight = 15, stack = true, close = true, description = 'Hard candy for flavor' },
    ['oil_sludge'] = { label = 'Oil Sludge', weight = 60, stack = true, close = true, description = 'Thick sludge from the oil fields' },
    ['spark_caps'] = { label = 'Spark Caps', weight = 25, stack = true, close = true, description = 'Stim caps used in Truck Juice' },
    ['desert_dust'] = { label = 'Desert Dust', weight = 35, stack = true, close = true, description = 'Gravel dust swept from the desert' },
    ['baking_soda'] = { label = 'Baking Soda', weight = 25, stack = true, close = true, description = 'Cut used for Gravel Dust' },
    ['cayo_palm_leaf'] = { label = 'Cayo Palm Leaf', weight = 35, stack = true, close = true, description = 'Tropical palm leaves from Cayo Perico' },
    ['reef_coral'] = { label = 'Reef Coral', weight = 40, stack = true, close = true, description = 'Ground coral dust from the island reef' },
    ['perico_resin'] = { label = 'Perico Resin', weight = 50, stack = true, close = true, description = 'Sticky resin tapped at Cayo docks' },
    ['gold_capsules'] = { label = 'Gold Capsules', weight = 20, stack = true, close = true, description = 'Premium gold capsules for Cayo Crown' },

    ['longhorn_kush'] = { label = 'Longhorn Kush', weight = 40, stack = true, close = true, description = 'Outlaw ranch kush — run + drunk haze', server = drugUse },
    ['dirt_road_haze'] = { label = 'Dirt Road Haze', weight = 40, stack = true, close = true, description = 'Chaparral haze — 1.40x sprint + screen FX', server = drugUse },
    ['chrome_snow'] = { label = 'Chrome Snow', weight = 45, stack = true, close = true, description = 'City snow — 45% armor + 1.38x run + screen FX', server = drugUse },
    ['sandlot_ice'] = { label = 'Sandlot Ice', weight = 40, stack = true, close = true, description = 'Sandy ice — 1.49x run with clown screen FX', server = drugUse },
    ['outlaw_brick'] = { label = 'Outlaw Brick', weight = 80, stack = true, close = true, description = 'Wrapped brick — 55% armor + health + drunk wreck', server = drugUse },
    ['honkytonk_rolls'] = { label = 'Honkytonk Rolls', weight = 25, stack = true, close = true, description = 'Pressed rolls — 1.49x sprint + alien screen FX', server = drugUse },
    ['swamp_lean'] = { label = 'Swamp Lean', weight = 80, stack = true, close = true, description = 'South-side lean — heavy drunk wreck + stress dump', server = drugUse },
    ['truck_juice'] = { label = 'Truck Juice', weight = 90, stack = true, close = true, description = 'Diesel stim — 45% armor + 1.49x run + screen FX', server = drugUse },
    ['gravel_dust'] = { label = 'Gravel Dust', weight = 35, stack = true, close = true, description = 'Desert speed — 1.49x run with clown screen FX', server = drugUse },
    ['cayo_crown'] = { label = 'Cayo Crown', weight = 25, stack = true, close = true, description = 'Island exclusive — 65% armor + run + screen FX', server = drugUse },

    -- Player-owned custom set (3 ingredients each)
    ['civic_bolts'] = { label = 'Civic Bolts', weight = 20, stack = true, close = true, description = 'Track-scrap bolts for Honda Pills' },
    ['shift_powder'] = { label = 'Shift Powder', weight = 25, stack = true, close = true, description = 'Gear-dust cut for Honda Pills' },
    ['red_keycaps'] = { label = 'Red Keycaps', weight = 15, stack = true, close = true, description = 'Red starter caps for Honda Pills' },
    ['rust_needles'] = { label = 'Rust Needles', weight = 15, stack = true, close = true, description = 'Scrap needles for Stab Juice' },
    ['iodine_swabs'] = { label = 'Iodine Swabs', weight = 20, stack = true, close = true, description = 'Clinic swabs for Stab Juice' },
    ['alley_tonic'] = { label = 'Alley Tonic', weight = 40, stack = true, close = true, description = 'Back-alley tonic for Stab Juice' },
    ['black_petals'] = { label = 'Black Petals', weight = 20, stack = true, close = true, description = 'Night-bloom petals for Black Lotus' },
    ['temple_ash'] = { label = 'Temple Ash', weight = 25, stack = true, close = true, description = 'Church-yard ash for Black Lotus' },
    ['ink_resin'] = { label = 'Ink Resin', weight = 40, stack = true, close = true, description = 'Studio ink resin for Black Lotus' },
    ['diesel_nugs'] = { label = 'Diesel Nugs', weight = 30, stack = true, close = true, description = 'House nugs for Diesels Pack' },
    ['grease_wrap'] = { label = 'Grease Wrap', weight = 15, stack = true, close = true, description = 'Shop wrap for Diesels Pack' },
    ['iron_filters'] = { label = 'Iron Filters', weight = 35, stack = true, close = true, description = 'Engine filters for Diesels Pack' },
    ['street_lace'] = { label = 'Street Lace', weight = 15, stack = true, close = true, description = 'Universal cut — lace any finished drug to sell for more' },

    ['honda_pills'] = { label = 'Honda Pills', weight = 25, stack = true, close = true, description = 'Player-owned racing pills — 1.49x run + armor', server = drugUse },
    ['stab_juice'] = { label = 'Stab Juice', weight = 80, stack = true, close = true, description = 'Player-owned combat tonic — 45% armor + 50 HP', server = drugUse },
    ['black_lotus'] = { label = 'Black Lotus', weight = 30, stack = true, close = true, description = 'Player-owned night bloom — 50% armor + screen FX', server = drugUse },
    ['diesels_pack'] = { label = 'Diesels Pack', weight = 45, stack = true, close = true, description = 'Player-owned house pack — 60% armor + 1.49x run', server = drugUse },
}
