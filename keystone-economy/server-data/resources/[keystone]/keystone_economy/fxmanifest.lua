fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'keystone_economy'
author 'Keystone'
description 'Server-authoritative supply/demand pricing + supply-chain engine with dupe-proof atomic transactions.'
version '0.0.1'

shared_scripts {
  '@ox_lib/init.lua',
  'config/config.lua',
  'shared/pricing.lua',
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server/state.lua',
  'server/adapters/interface.lua',
  'server/adapters/mock.lua',
  'server/adapters/qbox.lua',
  'server/persistence.lua',
  'server/transactions.lua',
  'server/main.lua',
  'server/exports.lua',
}

client_scripts {
  'client/main.lua',
}

dependencies {
  'oxmysql',
  'ox_lib',
}
