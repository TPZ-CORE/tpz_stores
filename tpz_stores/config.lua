Config = {}

Config.DevMode = false

Config.OpenKey = 0x760A9C6F
Config.QTarget = false

Config.RenderNPCDistance = 30

Config.Stores = {

    ['GuarmaGeneralStore'] = {

        StoreName = "GENERAL STORE",
        PromptName = "general store",

        Coords = { x = 1303.562, y = -6863.20, z = 42.348, h = 87.829803466797}, -- Blip / Prompt & NPC Positions.

        DistanceOpenStore = 3.0,

        BlipData = {
            Allowed = true,
            Name    = "General Store",
            Sprite  = 1475879922,
        },

        NPCData = {
            Allowed = true,
            Model = "u_f_m_tumgeneralstoreowner_01",
        },

        Hours = {
            Allowed = false,
            Opening = 7,
            Closing = 23,
        },

        JobsData = {
            Allowed = false,
            Jobs    = {},
        },

        Categories = { 
            { category = "food",  types = {"buy"} },
            { category = "tools", types = {"buy"} },
        }, 

        StoreProductsPackage = "general_store", -- The store name that has been created on Config.StoreProductPackages.
    },

    ['GuarmaFishingStore'] = {

        StoreName = "FISHING STORE",
        PromptName = "baits store",

        Coords = { x = 1301.850, y = -6830.11, z = 42.330, h = 259.69055175781}, -- Blip / Prompt & NPC Positions.

        DistanceOpenStore = 2.0,

        BlipData = {
            Allowed = true,
            Name    = "Baits & Fish Store",
            Sprite  = -852241114,
        },

        NPCData = {
            Allowed = true,
            Model = "mp_dr_u_f_m_missingfisherman_01",
        },

        Hours = {
            Allowed = false,
            Opening = 7,
            Closing = 23,
        },

        JobsData = {
            Allowed = false,
            Jobs    = {},
        },
        
        Categories = { 
            { category = "baits", types = {"buy"} },
            { category = "fishes", types = {"sell"} },
        }, 

        StoreProductsPackage = "fishing_store", -- The store name that has been created on Config.StoreProductPackages.
    },


}

Config.StoreProductPackages = {

    ['general_store'] = {

        ['buy'] = {
            -- tools
            { label = "Notes Paper",            item = "paper",                   currency = "cents",   price = 5,  category = "tools" },
            { label = "Pen",                    item = "pen",                     currency = "cents",   price = 50, category = "tools" },
            { label = "Crafting Book",          item = "crafting_book",           currency = "dollars", price = 2,  category = "tools" },

            -- food
            { label = "Water",                  item = "consumable_water_bottle", currency = "cents",   price = 25, category = "food" },
            { label = "Meat",                   item = "meat", currency = "cents",   price = 25, category = "food" },
            { label = "Bread",                  item = "consumable_bread",        currency = "cents",   price = 80, category = "food" },
            { label = "Horse Meal",             item = "horsemeal",               currency = "cents",   price = 25, category = "food" },


        },

    },

    ['fishing_store'] = {

        ['buy'] = {

            { label = "Bread Bait",    item = "p_baitBread01x",          currency = "cents",   price = 2, category = "baits" },
            { label = "Corn Bait",     item = "p_baitCorn01x",           currency = "cents",   price = 2, category = "baits" },
            { label = "Cheese Bait",   item = "p_baitCheese01x",         currency = "cents",   price = 2, category = "baits" },
            { label = "Cricket Bait",  item = "p_baitCricket01x",        currency = "cents",   price = 2, category = "baits" },
            { label = "Worm Bait",     item = "p_baitWorm01x",           currency = "cents",   price = 2, category = "baits" },
            
            { label = "Lake Lure",     item = "fishing_lake_lure",       currency = "cents",   price = 5, category = "baits" },
            { label = "River Lure",    item = "fishing_river_lure",      currency = "cents",   price = 5, category = "baits" },
            { label = "Swamp Lure",    item = "fishing_swamp_lure",      currency = "cents",   price = 5, category = "baits" },
        },

        ['sell'] = {

            { label = "Blue Gil (Medium)",              item = "a_c_fishbluegil_01_ms",               currency = "cents",   price = 30, category = "fishes" },
            { label = "Blue Gil (Small)",               item = "a_c_fishbluegil_01_sm",               currency = "cents",   price = 15, category = "fishes" },
            { label = "Bullhead Cat (Medium)",          item = "a_c_fishbullheadcat_01_ms",           currency = "cents",   price = 30, category = "fishes" },
            { label = "Bullhead Cat (Small)",           item = "a_c_fishbullheadcat_01_sm",           currency = "cents",   price = 15, category = "fishes" },
            { label = "Chain Pickerel (Medium)",        item = "a_c_fishchainpickerel_01_ms",         currency = "cents",   price = 30, category = "fishes" },
            { label = "Chain Pickerel (Small)",         item = "a_c_fishchainpickerel_01_sm",         currency = "cents",   price = 15, category = "fishes" },
            { label = "Channel Catfish (Large)",        item = "a_c_fishchannelcatfish_01_lg",        currency = "cents",   price = 40, category = "fishes" },
            { label = "Channel Catfish (E-Large)",      item = "a_c_fishchannelcatfish_01_xl",        currency = "cents",   price = 50, category = "fishes" },
            { label = "Lake Sturgeon (Large)",          item = "a_c_fishlakesturgeon_01_lg",          currency = "cents",   price = 40, category = "fishes" },
            { label = "Large Mouth Bass (Large)",       item = "a_c_fishlargemouthbass_01_lg",        currency = "cents",   price = 40, category = "fishes" },
            { label = "Large Mouth Bass (Medium)",      item = "a_c_fishlargemouthbass_01_ms",        currency = "cents",   price = 30, category = "fishes" },
            { label = "Long Nose Gar (Large)",          item = "a_c_fishlongnosegar_01_lg",           currency = "cents",   price = 40, category = "fishes" },
            { label = "Muskie (Large)",                 item = "a_c_fishmuskie_01_lg",                currency = "cents",   price = 40, category = "fishes" },
            { label = "Northern Pike (Large)",          item = "a_c_fishnorthernpike_01_lg",          currency = "cents",   price = 40, category = "fishes" },
            { label = "Perch (Medium)",                 item = "a_c_fishperch_01_ms",                 currency = "cents",   price = 30, category = "fishes" },
            { label = "Perch (Small)",                  item = "a_c_fishperch_01_sm",                 currency = "cents",   price = 15, category = "fishes" },
            { label = "Rainbow Trout (Large)",          item = "a_c_fishrainbowtrout_01_lg",          currency = "cents",   price = 40, category = "fishes" },
            { label = "Rainbow Trout (Medium)",         item = "a_c_fishrainbowtrout_01_ms",          currency = "cents",   price = 30, category = "fishes" },
            { label = "Red Fin Pickerel (Medium)",      item = "a_c_fishredfinpickerel_01_ms",        currency = "cents",   price = 30, category = "fishes" },
            { label = "Red Fin Pickerel (Small)",       item = "a_c_fishredfinpickerel_01_sm",        currency = "cents",   price = 15, category = "fishes" },
            { label = "Rock Bass (Medium)",             item = "a_c_fishrockbass_01_ms",              currency = "cents",   price = 30, category = "fishes" },
            { label = "Rock Bass (Small)",              item = "a_c_fishrockbass_01_sm",              currency = "cents",   price = 15, category = "fishes" },
            { label = "Salmon Sockeye (Large)",         item = "a_c_fishsalmonsockeye_01_lg",         currency = "cents",   price = 40, category = "fishes" },
            { label = "Salmon Sockeye (M-Large)",       item = "a_c_fishsalmonsockeye_01_ml",         currency = "cents",   price = 35, category = "fishes" },
            { label = "Salmon Sockeye (Medium)",        item = "a_c_fishsalmonsockeye_01_ms",         currency = "cents",   price = 30, category = "fishes" },
            { label = "Small Mouth Bass (Large)",       item = "a_c_fishsmallmouthbass_01_lg",        currency = "cents",   price = 40, category = "fishes" },
            { label = "Small Mouth Bass (Medium)",      item = "a_c_fishsmallmouthbass_01_ms",        currency = "cents",   price = 30, category = "fishes" },
            { label = "Crab",                           item = "a_c_crawfish_01",                     currency = "cents",   price = 30, category = "fishes" },
        },
        
    },

}

-----------------------------------------------------------
--[[ Notification Functions  ]]--
-----------------------------------------------------------

-- @param source is always null when called from client.
-- @param messageType returns "success" or "error" depends when and where the message is sent.
function SendNotification(source, message, messageType)

    if not source then
        TriggerEvent('tpz_core:sendRightTipNotification', message, 3000)
    else
        TriggerClientEvent('tpz_core:sendRightTipNotification', source, message, 3000)
    end
  
end
