--[[
    Merge into ox_inventory/data/items.lua

    Finished drugs MUST include:
      server = { export = 'djfivem-drugsv2.useDrugServer' }

    Copy install/images/*.png into ox_inventory/web/images/
    (photorealistic product stills — overwrite any old outline icons)
]]

local drugUse = {
    export = 'djfivem-drugsv2.useDrugServer',
}

return {
    ['black_money'] = {
        label = 'Dirty Money',
    },

    ['ranch_bud'] = { label = 'Ranch Bud', weight = 30, stack = true, close = true, description = 'Grapeseed ranch buds for Lone Star Kush' },
    ['haze_bud'] = { label = 'Haze Bud', weight = 30, stack = true, close = true, description = 'Hill country haze buds' },
    ['zip_bags'] = { label = 'Zip Bags', weight = 10, stack = true, close = true, description = 'Small zip bags for packaging product' },
    ['coca_leaves'] = { label = 'Coca Leaves', weight = 35, stack = true, close = true, description = 'Raw leaves for Houston Snow' },
    ['lab_solvent'] = { label = 'Lab Solvent', weight = 120, stack = true, close = true, description = 'Industrial solvent for cook tables' },
    ['lithium_rocks'] = { label = 'Lithium Rocks', weight = 50, stack = true, close = true, description = 'Broken lithium rock for West Texas Ice' },
    ['camp_fuel'] = { label = 'Camp Fuel', weight = 100, stack = true, close = true, description = 'Camp fuel used in desert cooks' },
    ['raw_tar'] = { label = 'Raw Tar', weight = 55, stack = true, close = true, description = 'Dock-side tar for Border Brick' },
    ['wrap_tape'] = { label = 'Wrap Tape', weight = 15, stack = true, close = true, description = 'Heavy tape for wrapping bricks' },
    ['street_crystals'] = { label = 'Street Crystals', weight = 40, stack = true, close = true, description = 'Raw crystals for Sixth Street Rolls' },
    ['press_capsules'] = { label = 'Press Capsules', weight = 20, stack = true, close = true, description = 'Empty capsules for pressing pills' },
    ['stamp_dies'] = { label = 'Stamp Dies', weight = 20, stack = true, close = true, description = 'Press dies stamped for street rolls' },
    ['purple_syrup'] = { label = 'Purple Syrup', weight = 40, stack = true, close = true, description = 'Thick purple syrup base' },
    ['crushed_ice'] = { label = 'Crushed Ice', weight = 20, stack = true, close = true, description = 'Finely crushed ice for mixing' },
    ['foam_cups'] = { label = 'Foam Cups', weight = 15, stack = true, close = true, description = 'Styrofoam cups for Purple Drank' },
    ['spark_soda'] = { label = 'Spark Soda', weight = 50, stack = true, close = true, description = 'Carbonated soda for lean mixing' },
    ['hard_candy'] = { label = 'Hard Candy', weight = 15, stack = true, close = true, description = 'Hard candy for flavor' },
    ['oil_sludge'] = { label = 'Oil Sludge', weight = 60, stack = true, close = true, description = 'Thick sludge from the oil fields' },
    ['spark_caps'] = { label = 'Spark Caps', weight = 25, stack = true, close = true, description = 'Stim caps used in Rig Juice' },
    ['desert_dust'] = { label = 'Desert Dust', weight = 35, stack = true, close = true, description = 'Panhandle dust swept from the desert' },
    ['baking_soda'] = { label = 'Baking Soda', weight = 25, stack = true, close = true, description = 'Cut used for Panhandle Dust' },
    ['cayo_palm_leaf'] = { label = 'Cayo Palm Leaf', weight = 35, stack = true, close = true, description = 'Tropical palm leaves from Cayo Perico' },
    ['reef_coral'] = { label = 'Reef Coral', weight = 40, stack = true, close = true, description = 'Ground coral dust from the island reef' },
    ['perico_resin'] = { label = 'Perico Resin', weight = 50, stack = true, close = true, description = 'Sticky resin tapped at Cayo docks' },
    ['gold_capsules'] = { label = 'Gold Capsules', weight = 20, stack = true, close = true, description = 'Premium gold capsules for Perico Gold' },

    ['lone_star_kush'] = { label = 'Lone Star Kush', weight = 40, stack = true, close = true, description = 'Ranch kush — calms nerves, no screen FX', server = drugUse },
    ['hill_country_haze'] = { label = 'Hill Country Haze', weight = 40, stack = true, close = true, description = 'Country haze — light sprint, no screen FX', server = drugUse },
    ['houston_snow'] = { label = 'Houston Snow', weight = 45, stack = true, close = true, description = 'City snow — 20% armor + 1.20x run', server = drugUse },
    ['west_texas_ice'] = { label = 'West Texas Ice', weight = 40, stack = true, close = true, description = 'Desert ice — 1.40x run with screen FX', server = drugUse },
    ['border_brick'] = { label = 'Border Brick', weight = 80, stack = true, close = true, description = 'Wrapped brick — 30% armor with screen FX', server = drugUse },
    ['sixth_street_rolls'] = { label = 'Sixth Street Rolls', weight = 25, stack = true, close = true, description = 'Pressed rolls — 1.35x sprint with screen FX', server = drugUse },
    ['purple_drank'] = { label = 'Purple Drank', weight = 80, stack = true, close = true, description = 'County lean — stress relief, no screen FX', server = drugUse },
    ['rig_juice'] = { label = 'Rig Juice', weight = 90, stack = true, close = true, description = 'Oilfield stim — 25% armor + 1.38x run, no screen FX', server = drugUse },
    ['panhandle_dust'] = { label = 'Panhandle Dust', weight = 35, stack = true, close = true, description = 'Desert speed — 1.42x run with screen FX', server = drugUse },
    ['perico_gold'] = { label = 'Perico Gold', weight = 25, stack = true, close = true, description = 'Cayo exclusive — 40% armor, no screen FX', server = drugUse },
}
