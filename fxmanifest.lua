fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'djfivem-drugsv2'
author 'DieselJones21'
description 'Rebel Roleplay outlaw harvest → process → /trap sell drug economy (QBX + ox_inventory + custom NUI)'
version '2.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/utils.lua',
    'shared/bridge.lua',
    'config/config.lua',
    'config/drugs.lua',
}

client_scripts {
    'client/main.lua',
    'client/target.lua',
    'client/nui.lua',
    'client/harvest.lua',
    'client/process.lua',
    'client/sell.lua',
    'client/bulk.lua',
    'client/progress.lua',
    'client/effects.lua',
    'client/boost.lua',
    'client/informant.lua',
    'client/help.lua',
}

server_scripts {
    'server/main.lua',
    'server/dispatch.lua',
    'server/harvest.lua',
    'server/process.lua',
    'server/progress.lua',
    'server/sell.lua',
    'server/bulk.lua',
    'server/effects.lua',
    'server/boost.lua',
    'server/informant.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
    'html/img/*.png',
}

dependencies {
    'ox_lib',
    'ox_inventory',
    'qbx_core',
    'interact',
    'ox_target',
}

-- Preferred: ensure `interact` before this resource so weed plants, benches,
-- ingredient peds, informant, and bulk crates use E. Street buyers stay ox_target.
-- Optional: start wasabi_mdt (preferred) and/or ps-dispatch for snitch sale alerts.
-- Optional: set convar djdrugsv2_boost_webhook for Discord boost warnings.
