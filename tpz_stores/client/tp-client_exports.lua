
-----------------------------------------------------------
--[[ Exports  ]]--
-----------------------------------------------------------

-- @IsBusy : returns when the player has store menu active.
exports('IsBusy', function()
    return GetPlayerData().IsBusy
end)