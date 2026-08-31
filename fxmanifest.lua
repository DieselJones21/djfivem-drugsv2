fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'djfivem-drugsv2'
author 'DieselJones21'
description 'Envy Roleplay harvest → process → /trap sell drug economy v2 (QBX + ox_inventory + custom NUI)'
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
    'client/nui.lua',
    'client/harvest.lua',
    'client/process.lua',
    'client/sell.lua',
    'client/progress.lua',
    'client/effects.lua',
    'client/boost.lua',
}

server_scripts {
    'server/main.lua',
    'server/harvest.lua',
    'server/process.lua',
    'server/progress.lua',
    'server/sell.lua',
    'server/effects.lua',
    'server/boost.lua',
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
    'ox_target',
    'ox_inventory',
    'qbx_core',
}
