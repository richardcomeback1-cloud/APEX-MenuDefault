client_script "@bt_defender/module/client.lua"

fx_version 'adamant'

game 'gta5'

description 'ESX Menu Dialog'

version '1.1.0'

client_script 'client/main.lua'

ui_page 'html/ui.html'

files {
	'html/ui.html',

	'html/css/app.css',

	'html/js/mustache.min.js',
	'html/js/app.js',

	'html/fonts/PSL.ttf'
}

dependency 'es_extended'

lua54 'yes'