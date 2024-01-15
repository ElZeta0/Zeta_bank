fx_version 'cerulean'
game 'gta5'

lua54 'yes'
descripion 'This bank system are create by Zeta'

ui_page 'html/index.html'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@es_extended/imports.lua',
	'server/main.lua'
}

files {
	'html/index.html',
	'html/js/index.js',
	'html/css/index.css',
	'html/css/img/*.png',
}

client_scripts {
	'@es_extended/locale.lua',
    "client/main.lua",
}

shared_scripts {
	'config.lua',
	'@ox_lib/init.lua',
}
