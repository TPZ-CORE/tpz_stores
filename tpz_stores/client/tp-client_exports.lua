
-----------------------------------------------------------
--[[ Exports  ]]--
-----------------------------------------------------------

-- @param store : Requires the name of a store from Config.Stores.
exports('OpenStoreByName', function(store)
    OpenStoreCategoryMenu(store)
end)

-- @param IsBusy : returns when the player has store menu active.
exports('IsBusy', function()
    return GetPlayerData().IsBusy
end)
