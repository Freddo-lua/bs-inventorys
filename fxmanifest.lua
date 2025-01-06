fx_version 'cerulean'
game 'gta5'

author 'BootStrap-Devlopment'
description 'bs-inventorys'
version '1.0.0'

client_scripts {
    'config.lua',
    'shared.lua', -- Include shared.lua
    'client/client.lua'
}

server_scripts {
    'config.lua',
    'shared.lua', -- Include shared.lua
    'server/server.lua'
}

-- Remove HTML and image files since they are no longer required
dependencies {
    'menuv' -- Declaring MenuV as a dependency
}
