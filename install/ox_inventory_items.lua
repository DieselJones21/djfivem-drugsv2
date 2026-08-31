--[[
    Merge into ox_inventory/data/items.lua

    Finished drugs MUST include:
      server = { export = 'djfivem-drugsv2.useDrugServer' }

    Copy install/images/*.png into ox_inventory/web/images/
]]

local drugUse = {
    export = 'djfivem-drugsv2.useDrugServer',
}

return {
    ['black_money'] = {
        label = 'Dirty Money',
    },

    -- 305 Heat ingredients
    ['neon_crystals'] = { label = 'Neon Crystals', weight = 50, stack = true, close = true, description = 'Glowing pink crystals for 305 Heat' },
    ['miami_solvent'] = { label = 'Miami Solvent', weight = 100, stack = true, close = true, description = 'Chemical solvent brewed in Little Havana' },
    ['vice_jars'] = { label = 'Vice Jars', weight = 80, stack = true, close = true, description = 'Empty jars for mixing Miami stimulants' },
    ['espresso_powder'] = { label = 'Espresso Powder', weight = 40, stack = true, close = true, description = 'Hyper-concentrated espresso powder' },

    -- South Beach Kush ingredients
    ['beach_bud'] = { label = 'Beach Bud', weight = 30, stack = true, close = true, description = 'Premium buds grown near Vespucci Beach' },
    ['zip_bags'] = { label = 'Zip Bags', weight = 10, stack = true, close = true, description = 'Small zip bags for packaging product' },

    -- Brickell Snow ingredients
    ['tropical_leaves'] = { label = 'Tropical Leaves', weight = 35, stack = true, close = true, description = 'Raw tropical leaves for processing' },
    ['lab_solvent'] = { label = 'Lab Solvent', weight = 120, stack = true, close = true, description = 'Industrial solvent for downtown labs' },

    -- Vice Purple ingredients
    ['purple_syrup'] = { label = 'Purple Syrup', weight = 40, stack = true, close = true, description = 'Thick purple cough syrup base' },
    ['crushed_ice'] = { label = 'Crushed Ice', weight = 20, stack = true, close = true, description = 'Finely crushed ice for mixing' },
    ['foam_cups'] = { label = 'Foam Cups', weight = 15, stack = true, close = true, description = 'Styrofoam cups for Vice Purple' },
    ['spark_soda'] = { label = 'Spark Soda', weight = 50, stack = true, close = true, description = 'Carbonated soda for lean mixing' },
    ['hard_candy'] = { label = 'Hard Candy', weight = 15, stack = true, close = true, description = 'Neon hard candies for flavor' },

    -- Ocean Drive Rolls ingredients
    ['drive_crystals'] = { label = 'Drive Crystals', weight = 40, stack = true, close = true, description = 'Raw crystals from Del Perro' },
    ['neon_powder'] = { label = 'Neon Powder', weight = 40, stack = true, close = true, description = 'Bright neon dye powder' },
    ['press_capsules'] = { label = 'Press Capsules', weight = 20, stack = true, close = true, description = 'Empty capsules for pressing pills' },
    ['vice_stamps'] = { label = 'Vice Stamps', weight = 20, stack = true, close = true, description = 'Press dies stamped with vice logos' },

    -- Neon Rush ingredients
    ['rush_powder'] = { label = 'Rush Powder', weight = 30, stack = true, close = true, description = 'Raw stimulant powder from the port' },
    ['neon_candy'] = { label = 'Neon Candy', weight = 20, stack = true, close = true, description = 'Sweet neon candy base' },
    ['tropical_concentrate'] = { label = 'Tropical Concentrate', weight = 45, stack = true, close = true, description = 'Thick tropical juice concentrate' },

    -- Perico Gold ingredients (Cayo Perico)
    ['cayo_palm_leaf'] = { label = 'Cayo Palm Leaf', weight = 35, stack = true, close = true, description = 'Tropical palm leaves from Cayo Perico' },
    ['reef_coral'] = { label = 'Reef Coral', weight = 40, stack = true, close = true, description = 'Ground coral dust from the island reef' },
    ['perico_resin'] = { label = 'Perico Resin', weight = 50, stack = true, close = true, description = 'Sticky resin tapped at Cayo docks' },
    ['gold_capsules'] = { label = 'Gold Capsules', weight = 20, stack = true, close = true, description = 'Premium gold capsules for Perico Gold' },

    -- Finished products (usable)
    ['heat_305'] = { label = '305 Heat', weight = 150, stack = true, close = true, description = 'Miami neon stim — 25% armor + 45s stamina', server = drugUse },
    ['south_beach_kush'] = { label = 'South Beach Kush', weight = 40, stack = true, close = true, description = 'Premium beach kush ready to sell', server = drugUse },
    ['brickell_snow'] = { label = 'Brickell Snow', weight = 45, stack = true, close = true, description = 'Refined downtown snow ready to move', server = drugUse },
    ['vice_purple'] = { label = 'Vice Purple', weight = 80, stack = true, close = true, description = 'Classic Miami purple cup', server = drugUse },
    ['ocean_drive_rolls'] = { label = 'Ocean Drive Rolls', weight = 25, stack = true, close = true, description = 'Neon-pressed rolls — 1.35x sprint + stamina', server = drugUse },
    ['neon_rush'] = { label = 'Neon Rush', weight = 90, stack = true, close = true, description = 'Port-side neon juice — 25% armor + stamina', server = drugUse },
    ['perico_gold'] = { label = 'Perico Gold', weight = 25, stack = true, close = true, description = 'Cayo exclusive — 40% armor + 60s stamina', server = drugUse },
}
