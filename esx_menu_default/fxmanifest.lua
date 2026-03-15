--client_script "@bt_defender/module/client.lua"

-- @bt_defender
 




fx_version 'adamant'

game 'gta5'

description 'ESX Menu Default'

version '1.0.4'

client_scripts {
	'@es_extended/client/wrapper.lua',
	'client/main.lua'
}

ui_page {
	'html/ui.html'
}

files {
	'html/ui.html',
	'html/css/app.css',
	'html/js/mustache.min.js',
	'html/js/app.js',
	'html/fonts/pdown.ttf',
	'html/fonts/bankgothic.ttf',
	'html/sound/select.mp3',
	'html/sound/cancel.wav',
	'html/sound/Click_SFX.ogg',
	'html/sound/Select_SFX.ogg',
	'html/img/*.**',
}

dependencies {
	'es_extended'
}

lua54 'yes'
