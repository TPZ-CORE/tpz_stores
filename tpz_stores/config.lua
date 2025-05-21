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

---------------------------------------------------------------
--[[ Stores & Locations ]]--
---------------------------------------------------------------

Config.Stores = {

    ['GENERAL_STORE_VALENTINE'] = {

        StoreName = "GENERAL STORE",

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

-- Available account types: "dollars", "gold"
Config.StoreProductPackages = {

    ['general_store'] = {

        ['buy'] = {

            -- tools
            { label = "Rolling Paper",          item = "rollingpaper",            account = "dollars",   price = 5,     isWeapon = false, category = "miscellaneous" },

            -- consumables
            { label = "Water Bottle",           item = "consumable_water_bottle", account = "dollars",   price = 15,    isWeapon = false, category = "consumables" },
            { label = "Coffee",                 item = "consumable_coffee",       account = "dollars",   price = 20,    isWeapon = false, category = "consumables" },
           
            -- food
            { label = "Peach",                  item = "consumable_peach",        account = "dollars",   price = 25,    isWeapon = false, category = "food" },
            { label = "Bread",                  item = "consumable_bread",        account = "dollars",   price = 35,    isWeapon = false, category = "food" },
        },

        ['sell'] = { -- (!) IsWeapon option does not exist on selling, we do not allow selling weapons.
            { label = "Empty Bottle",           item = "emptybottle",             account = "dollars",   price = 10,    category = "miscellaneous" },
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
