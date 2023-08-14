fx_version 'adamant'

game 'gta5'

author 'Rubinz'
description 'RB Wood Cutter Job'
version '1.0.0'

shared_script '@es_extended/imports.lua'

client_scripts {
  '@es_extended/locale.lua',
  'locales/cs.lua',
  'config.lua',
  'client/main.lua'
}

server_scripts {
  '@es_extended/locale.lua',
  'locales/cs.lua',
  'config.lua',
  'server/main.lua'
}