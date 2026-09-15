--[[
    Merge into ox_inventory/data/items.lua

    Finished drugs MUST include:
      server = { export = 'djfivem-drugsv2.useDrugServer' }

    Copy install/images/*.png into ox_inventory/web/images/
    Icons are photoreal product stills with transparent backgrounds.
]]

local drugUse = {
    export = 'djfivem-drugsv2.useDrugServer',
}

return {
    ['black_money'] = {
        label = 'Dirty Money',
    },

    ['beach_bud'] = { label = 'Beach Bud', weight = 30, stack = true, close = true, description = 'South Beach nugs for South Beach Kush' },
    ['canal_nugs'] = { label = 'Canal Nugs', weight = 30, stack = true, close = true, description = 'Calle Ocho canal nugs for Calle Ocho Haze' },
    ['zip_bags'] = { label = 'Zip Bags', weight = 10, stack = true, close = true, description = 'Small zip bags for packaging product' },
    ['tropical_leaves'] = { label = 'Tropical Leaves', weight = 35, stack = true, close = true, description = 'Raw leaves for Brickell Snow' },
    ['lab_solvent'] = { label = 'Lab Solvent', weight = 120, stack = true, close = true, description = 'Industrial solvent for downtown cooks' },
    ['tide_rocks'] = { label = 'Tide Rocks', weight = 50, stack = true, close = true, description = 'Marina rocks for Biscayne Ice' },
    ['boat_fuel'] = { label = 'Boat Fuel', weight = 100, stack = true, close = true, description = 'Marina fuel used in ice and rush cooks' },
    ['port_tar'] = { label = 'Port Tar', weight = 55, stack = true, close = true, description = 'Dock-side tar for Port Brick' },
    ['wrap_tape'] = { label = 'Wrap Tape', weight = 15, stack = true, close = true, description = 'Heavy tape for wrapping bricks' },
    ['drive_crystals'] = { label = 'Drive Crystals', weight = 40, stack = true, close = true, description = 'Raw crystals for Ocean Drive Rolls' },
    ['press_capsules'] = { label = 'Press Capsules', weight = 20, stack = true, close = true, description = 'Empty capsules for pressing pills' },
    ['vice_stamps'] = { label = 'Vice Stamps', weight = 20, stack = true, close = true, description = 'Press dies stamped for strip rolls' },
    ['purple_syrup'] = { label = 'Purple Syrup', weight = 40, stack = true, close = true, description = 'Thick purple syrup base' },
    ['crushed_ice'] = { label = 'Crushed Ice', weight = 20, stack = true, close = true, description = 'Finely crushed ice for mixing' },
    ['foam_cups'] = { label = 'Foam Cups', weight = 15, stack = true, close = true, description = 'Styrofoam cups for Vice Purple' },
    ['spark_soda'] = { label = 'Spark Soda', weight = 50, stack = true, close = true, description = 'Carbonated soda for lean mixing' },
    ['hard_candy'] = { label = 'Hard Candy', weight = 15, stack = true, close = true, description = 'Hard candy for flavor' },
    ['rush_sludge'] = { label = 'Rush Sludge', weight = 60, stack = true, close = true, description = 'Thick sludge from the port' },
    ['neon_caps'] = { label = 'Neon Caps', weight = 25, stack = true, close = true, description = 'Stim caps used in Neon Rush' },
    ['neon_dust'] = { label = 'Neon Dust', weight = 35, stack = true, close = true, description = 'Pink cut swept for 305 Heat' },
    ['baking_soda'] = { label = 'Baking Soda', weight = 25, stack = true, close = true, description = 'Cut used for 305 Heat' },
    ['cayo_palm_leaf'] = { label = 'Cayo Palm Leaf', weight = 35, stack = true, close = true, description = 'Tropical palm leaves from Cayo Perico' },
    ['reef_coral'] = { label = 'Reef Coral', weight = 40, stack = true, close = true, description = 'Ground coral dust from the island reef' },
    ['perico_resin'] = { label = 'Perico Resin', weight = 50, stack = true, close = true, description = 'Sticky resin tapped at Cayo docks' },
    ['gold_capsules'] = { label = 'Gold Capsules', weight = 20, stack = true, close = true, description = 'Premium gold capsules for Perico Gold' },
    ['street_lace'] = { label = 'Vice Lace', weight = 15, stack = true, close = true, description = 'Universal cut — lace any finished drug to sell for more' },

    ['south_beach_kush'] = { label = 'South Beach Kush', weight = 40, stack = true, close = true, description = 'Boardwalk kush — run + drunk haze', server = drugUse },
    ['calle_ocho_haze'] = { label = 'Calle Ocho Haze', weight = 40, stack = true, close = true, description = 'Canal haze — 1.40x sprint + screen FX', server = drugUse },
    ['vice_purple'] = { label = 'Vice Purple', weight = 80, stack = true, close = true, description = 'South-side lean — heavy drunk wreck + stress dump', server = drugUse },
    ['heat_305'] = { label = '305 Heat', weight = 35, stack = true, close = true, description = 'Calle stim — 1.49x run with clown screen FX', server = drugUse },
    ['brickell_snow'] = { label = 'Brickell Snow', weight = 45, stack = true, close = true, description = 'Tower snow — 45% armor + 1.38x run + screen FX', server = drugUse },
    ['biscayne_ice'] = { label = 'Biscayne Ice', weight = 40, stack = true, close = true, description = 'Marina ice — 1.49x run with clown screen FX', server = drugUse },
    ['port_brick'] = { label = 'Port Brick', weight = 80, stack = true, close = true, description = 'Wrapped brick — 55% armor + health + drunk wreck', server = drugUse },
    ['ocean_drive_rolls'] = { label = 'Ocean Drive Rolls', weight = 25, stack = true, close = true, description = 'Pressed rolls — 1.49x sprint + alien screen FX', server = drugUse },
    ['neon_rush'] = { label = 'Neon Rush', weight = 90, stack = true, close = true, description = 'Port stim — 45% armor + 1.49x run + screen FX', server = drugUse },
    ['perico_gold'] = { label = 'Perico Gold', weight = 25, stack = true, close = true, description = 'Island exclusive — 65% armor + run + screen FX', server = drugUse },
}
