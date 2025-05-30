Config = {}

Config.PromptAction = { Key = 0x760A9C6F, HoldMode = 1000 }

Config.DevMode = false
Config.Debug   = false

---------------------------------------------------------------
--[[ General Settings ]]--
---------------------------------------------------------------

-- When close to x distance, the npc will spawn, if you go farther away from that distance, the npc will be automatically deleted.
-- This system is for preventing Pool AI Crashes and not loading all NPC's for no reason when the player is not close to that location.
Config.NPCRenderingSpawnDistance = 20

-- Set tpz_leveling true to use the leveling api functions for specific
-- products to buy or sell. 
Config.tpz_leveling = false

---------------------------------------------------------------
--[[ Stores & Locations ]]--
---------------------------------------------------------------

Config.Stores = {

    ['POLICE'] = { -- USED IN tpz_society! 

        StoreName = "POLICE",

        -- THE SPECIFIED STORE IS AN EXAMPLE FOR CUSTOM STORES, A CUSTOM STORE IS FOR GETTING OPENED THROUGH AN EXPORT.
        -- IT DOES NOT HAVE BLIPS, COORDS, DISTANCE TO OPEN, NPC OR ANYTHING, ONLY PRODUCTS.
        IsCustom  = true, -- <---------

        Categories = { 
            { type = "gear",        label = 'Gear',       description = '',  types = {"buy"} },
            { type = "weapons",     label = 'Weaponry',   description = '',  types = {"buy"} },
        }, 
        

        -- The store name that has been created on Config.StoreProductPackages.
        StoreProductsPackage = "butcher_store",
    },

    ['BUTCHER'] = {

        StoreName = "BUTCHER",

        -- THE SPECIFIED STORE IS AN EXAMPLE FOR CUSTOM STORES, A CUSTOM STORE IS FOR GETTING OPENED THROUGH AN EXPORT.
        -- IT DOES NOT HAVE BLIPS, COORDS, DISTANCE TO OPEN, NPC OR ANYTHING, ONLY PRODUCTS.
        IsCustom  = true, -- <---------

        Categories = { 
            { type = "hunting",        label = 'Hunting',       description = '',  types = {"sell"} },
            { type = "birds",          label = 'Animals',       description = '',  types = {"sell"} },
            { type = "small_animals",  label = 'Small Animals', description = '',  types = {"sell"} },
            { type = "reptiles",       label = 'Repites',       description = '',  types = {"sell"} },
        }, 
        

        -- The store name that has been created on Config.StoreProductPackages.
        StoreProductsPackage = "butcher_store",
    },
    
    ['GENERAL_STORE_VALENTINE'] = {

        StoreName = "GENERAL STORE",

        -- THE SPECIFIED STORE IS AN EXAMPLE FOR CUSTOM STORES, A CUSTOM STORE IS FOR GETTING OPENED THROUGH AN EXPORT.
        -- IT DOES NOT HAVE BLIPS, COORDS, DISTANCE TO OPEN, NPC OR ANYTHING, ONLY PRODUCTS.
        IsCustom  = false, -- <---------
        
        -- Blip & Store Prompt Action Positions.
        Coords = { x = -324.628, y = 803.9818, z = 116.88, h = -81.17 },

        DistanceOpenStore = 3.0,
        
        BlipData = { 
            Allowed = true,
            Name    = "General Store",
            Sprite  = 1475879922,

            OpenBlipModifier = 'BLIP_MODIFIER_MP_COLOR_32',
            DisplayClosedHours = { Enabled = true, Sprite = 1475879922, BlipModifier = "BLIP_MODIFIER_MP_COLOR_2" },
        },

        NPCData = {
            Allowed = true,
            Model   = "u_m_m_walgeneralstoreowner_01",
            Coords  = { x = -324.628, y = 803.9818, z = 116.88, h = -81.17 },
            
        },

        Hours = { Allowed = true, Opening = 7, Closing = 23 },

        Categories = { 
            { type = "consumables",   label = 'Consumables',   description = 'Buy consumable items',    types = {"buy"} },
            { type = "food",          label = 'Food',          description = 'Buy food items',          types = {"buy"} },
            { type = "miscellaneous", label = 'Miscellaneous', description = 'Buy miscellaneous items', types = {"buy", "sell"} },
        }, 

        -- Set to false if you don't want any required jobs.
        -- If you want required jobs, it should be: RequiredJobs = { 'jobname' }
        RequiredJobs = false,

        -- If the following store is using a Target Script, set HasTarget to true.
        -- It will disable the prompts.
        HasTarget = false,

        -- The store name that has been created on Config.StoreProductPackages.
        StoreProductsPackage = "general_store",
    },

}

-- @param account: Available account types: "dollars", "gold"

-- @param requiredLevelingType : The tpz_leveling types such as: mining, lumberjack, hunting, farming, fishing
-- Set @requiredLevelingType = false to disable. 

-- @param requiredLevel : The required minimum level to buy or sell a product. 

Config.StoreProductPackages = {

    ['general_store'] = {

        ['buy'] = {

            -- tools
            { label = "Rolling Paper",        item = "rollingpaper",           account = "dollars",  price = 5,     isWeapon = false, category = "miscellaneous", requiredLevelingType = false, requiredLevel = 1 },

            -- consumables
            { label = "Water Bottle",           item = "consumable_water_bottle", account = "dollars",   price = 15,    isWeapon = false, category = "consumables", requiredLevelingType = false, requiredLevel = 1 },
            { label = "Coffee",                 item = "consumable_coffee",       account = "dollars",   price = 20,    isWeapon = false, category = "consumables", requiredLevelingType = false, requiredLevel = 1 },
           
            -- food
            { label = "Peach",                  item = "consumable_peach",        account = "dollars",   price = 25,    isWeapon = false, category = "food", requiredLevelingType = false, requiredLevel = 1 },
            { label = "Bread",                  item = "consumable_bread",        account = "dollars",   price = 35,    isWeapon = false, category = "food", requiredLevelingType = false, requiredLevel = 1 },
        },

        ['sell'] = { -- (!) IsWeapon option does not exist on selling, we do not allow selling weapons.
            { label = "Empty Bottle",           item = "emptybottle",             account = "dollars",   price = 10,    category = "miscellaneous", requiredLevelingType = false, requiredLevel = 1 },
        },

    },

    ['butcher_store'] = {

        ['sell'] = {

            { label = "Fish Bones",                  item = "animal_fish_bones",           account = "dollars",   price = 0.10,  category = "hunting", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Fibers",                      item = "fibers",                      account = "dollars",   price = 0.20,  category = "hunting", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Leather",                     item = "leather",                     account = "dollars",   price = 0.30,  category = "hunting", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Feathers",                    item = "feathers",                    account = "dollars",   price = 0.40,  category = "hunting", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Fabric",                      item = "fabric",                      account = "dollars",   price = 0.60,  category = "hunting", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Snake Skin",                  item = "SnakeSkin",                   account = "dollars",   price = 0.60,  category = "hunting", requiredLevelingType = false, requiredLevel = 1  },

            { label = "Fur",                         item = "fur",                         account = "dollars",   price = 0.7,   category = "hunting", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Pelt",                        item = "pelt",                        account = "dollars",   price = 0.7,   category = "hunting", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Bird Meat",                   item = "birdmeat",                    account = "dollars",   price = 0.8,   category = "hunting", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Fish Meat",                   item = "fish_meat",                   account = "dollars",   price = 0.9,   category = "hunting", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Meat",                        item = "meat",                        account = "dollars",   price = 0.9,   category = "hunting", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Big Game Meat",               item = "biggame",                     account = "dollars",   price = 0.10,  category = "hunting", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Bison Meat",                  item = "bison_meat",                  account = "dollars",   price = 0.12,  category = "hunting", requiredLevelingType = false, requiredLevel = 1  },
            -- Animals

            -- [BIRDS]
            { label = "Crow",                        item = "a_c_crow_01",                 account = "dollars",   price = 0.50, category = "birds", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Songbird",                    item = "a_c_songbird_01",             account = "dollars",   price = 0.50, category = "birds", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Sparrow",                     item = "a_c_sparrow_01",              account = "dollars",   price = 0.50, category = "birds", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Wood Pecker",                 item = "a_c_woodpecker_01",           account = "dollars",   price = 0.50, category = "birds", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Robin",                       item = "a_c_robin_01",                account = "dollars",   price = 0.50, category = "birds", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Pigeon",                      item = "a_c_pigeon",                  account = "dollars",   price = 0.50, category = "birds", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Oriole",                      item = "a_c_oriole_01",               account = "dollars",   price = 0.50, category = "birds", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Carolina Parakeet",           item = "a_c_carolinaparakeet_01",     account = "dollars",   price = 0.50, category = "birds", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Blue Jay",                    item = "a_c_bluejay_01",              account = "dollars",   price = 0.50, category = "birds", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Cardinal",                    item = "a_c_cardinal_01",             account = "dollars",   price = 0.50, category = "birds", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Cedar Waxwing",               item = "a_c_cedarwaxwing_01",         account = "dollars",   price = 0.50, category = "birds", requiredLevelingType = false, requiredLevel = 1  },

            -- [SMALL ANIMALS]
            { label = "Rat",                         item = "a_c_rat_01",                  account = "dollars",   price = 0.60, category = "small_animals", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Chipmunk",                    item = "a_c_chipmunk_01",             account = "dollars",   price = 0.60, category = "small_animals", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Skunk",                       item = "a_c_skunk_01",                account = "dollars",   price = 0.60, category = "small_animals", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Muskrat",                     item = "a_c_muskrat_01",              account = "dollars",   price = 0.60, category = "small_animals", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Possum",                      item = "a_c_possum_01",               account = "dollars",   price = 0.60, category = "small_animals", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Badger",                      item = "a_c_badger_01",               account = "dollars",   price = 0.60, category = "small_animals", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Squirrel",                    item = "a_c_squirrel_01",             account = "dollars",   price = 0.60, category = "small_animals", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Raccoon",                     item = "a_c_raccoon_01",              account = "dollars",   price = 0.60, category = "small_animals", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Rabbit",                      item = "a_c_rabbit_01",               account = "dollars",   price = 0.60, category = "small_animals", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Armadillo",                   item = "a_c_armadillo_01",            account = "dollars",   price = 1.0,  category = "small_animals", requiredLevelingType = false, requiredLevel = 1  },

            -- [REPTILES]
            { label = "Frogbull",                    item = "a_c_frogbull_01",             account = "dollars",   price = 0.65, category = "reptiles", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Toad",                        item = "a_c_toad_01",                 account = "dollars",   price = 0.65, category = "reptiles", requiredLevelingType = false, requiredLevel = 1  },

            { label = "Black-Tailed Rattlesnake",    item = "a_c_snakeblacktailrattle_01", account = "dollars",   price = 0.65, category = "reptiles", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Snake Fer-De-Lance",          item = "a_c_snakeferdelance_01",      account = "dollars",   price = 0.65, category = "reptiles", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Snake Red Boa",               item = "a_c_snakeredboa_01",          account = "dollars",   price = 0.65, category = "reptiles", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Water Snake",                 item = "a_c_snakewater_01",           account = "dollars",   price = 0.65, category = "reptiles", requiredLevelingType = false, requiredLevel = 1  },
            { label = "Snake",                       item = "a_c_snake_01",                account = "dollars",   price = 0.65, category = "reptiles", requiredLevelingType = false, requiredLevel = 1  },

        },

    },

}


---------------------------------------------------------------
--[[ Discord Webhooking ]]--
---------------------------------------------------------------

Config.Webhooks = {

    ['DEVTOOLS_INJECTION_CHEAT'] = { -- Warnings and Logs about players who used or atleast tried to use devtools injection.
    
        Enabled = false, 
        Url = "", 
        Color = 10038562,
    },

    ['BOUGHT'] = {
        Enabled = false, 
        Title   = 'Bought Items',
        Url     = "", 
        Color   = 10038562
    },

    ['SOLD'] = {
        Enabled = false, 
        Title   = 'Sold Items',
        Url     = "", 
        Color   = 10038562
    },

}

-----------------------------------------------------------
--[[ Notification Functions  ]]--
-----------------------------------------------------------

-- @param source is always null when called from client.
-- @param messageType returns "success" or "error" depends when and where the message is sent.
function SendNotification(source, message, messageType)

    if not source then
        TriggerEvent('tpz_core:sendBottomTipNotification', message, 3000)
    else
        TriggerClientEvent('tpz_core:sendBottomTipNotification', source, message, 3000)
    end
  
end
