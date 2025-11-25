fx_version "adamant"
games {"rdr3"}
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'Nosmakos'
description 'TPZ-CORE - Stores'
version '1.0.1'

shared_scripts { 'config.lua', 'locales.lua' }
server_scripts { 'server/*.lua' }
client_scripts { 'client/*.lua' }

dependencies {
    'tpz_core',
    'tpz_characters',
    'tpz_inventory',
    'tpz_menu_base',
    'tpz_inputs',
}

lua54 'yes'
