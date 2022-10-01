fx_version 'cerulean'
game 'gta5'

description 'QB-MechanicJob'
version '2.0.1'

shared_scripts {
    '@qb-core/shared/locale.lua',
	'config.lua',
	'locales/en.lua',
    'locales/*.lua'
}

client_scripts {
    'client/main.lua',
	'client/drivingdistance.lua',
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/CircleZone.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua'
}

lua54 'yes'
