local TPZInv = exports.tpz_inventory:getInventoryAPI()

local PlayerData = { 
    Job               = nil, 
    Account           = { 0, 0 },
    IsBusy            = false,
}

---------------------------------------------------------------
--[[ Local Functions ]]--
---------------------------------------------------------------

local function IsStoreOpen(storeConfig)

    if not storeConfig.Hours.Allowed then
        return true
    end

    local hour = GetClockHours()
    
    if storeConfig.Hours.Opening < storeConfig.Hours.Closing then
        -- Normal hours: Opening and closing on the same day (e.g., 08 to 20)
        if hour < storeConfig.Hours.Opening or hour >= storeConfig.Hours.Closing then
            return false
        end
    else
        -- Overnight hours: Closing time is on the next day (e.g., 21 to 05)
        if hour < storeConfig.Hours.Opening and hour >= storeConfig.Hours.Closing then
            return false
        end
    end

    return true

end

---------------------------------------------------------------
--[[ Functions ]]--
---------------------------------------------------------------

-- @GetPlayerData returns PlayerData list with all the available player information.
GetPlayerData = function ()
    return PlayerData
end

---------------------------------------------------------------
--[[ Base Events ]]--
---------------------------------------------------------------

-- Gets the player job when devmode set to false and character is selected.
AddEventHandler("tpz_core:isPlayerReady", function()

    Wait(2000)
    
    local data = exports.tpz_core:getCoreAPI().getPlayerClientData()

    if data == nil then
        return
    end

    PlayerData.Job = data.job
end)

-- Gets the player job when devmode set to true.
if Config.DevMode then

    Citizen.CreateThread(function ()

        Wait(2000)

        local data = exports.tpz_core:getCoreAPI().getPlayerClientData()

        if data == nil then
            return
        end

        PlayerData.Job = data.job
    end)
    
end

-- Updates the player job and job grade in case if changes.
RegisterNetEvent("tpz_core:getPlayerJob")
AddEventHandler("tpz_core:getPlayerJob", function(data)
    PlayerData.Job = data.job
end)

---------------------------------------------------------------
--[[ General Events ]]--
---------------------------------------------------------------

RegisterNetEvent("tpz_stores:client:updateAccount")
AddEventHandler("tpz_stores:client:updateAccount", function(account)
    PlayerData.Account = account

    if PlayerData.IsBusy then -- Updating subtext (description) on MenuData (tpz_menu_base) when the account has been updated.
        local subtext = string.format(Locales['CURRENT_ACCOUNT'], PlayerData.Account[1], PlayerData.Account[2])
        exports.tpz_menu_base:UpdateCurrentSubtextDescription(subtext)
    end
    
end)

---------------------------------------------------------------
--[[ Threads ]]--
---------------------------------------------------------------

Citizen.CreateThread(function()

    RegisterActionPrompt()

    while true do
        Citizen.Wait(0)

        local sleep        = true

        local player       = PlayerPedId()
        local isPlayerDead = IsEntityDead(player)

        -- We close the menu in case the player is dead and menu is active.
        if PlayerData.IsBusy and isPlayerDead then
            CloseMenu()
            DisplayRadar(true)
        end

        if not PlayerData.IsBusy and not isPlayerDead then

            local coords = GetEntityCoords(player)
            local hour   = GetClockHours()

            for storeId, storeConfig in pairs(Config.Stores) do

                if not storeConfig.IsCustom then
                    local coordsDist  = vector3(coords.x, coords.y, coords.z)
                    local coordsStore = vector3(storeConfig.Coords.x, storeConfig.Coords.y, storeConfig.Coords.z)
                    local distance    = #(coordsDist - coordsStore)
    
                    -- Before everything, we are removing spawned entities if the rendering distance
                    -- is bigger than the configurable max distance.
                    if storeConfig.NPC and distance > Config.NPCRenderingSpawnDistance then
                        RemoveEntityProperly(storeConfig.NPC, GetHashKey(storeConfig.NPCData.Model) )
                        storeConfig.NPC = nil
                    end
    
                    local isAllowed = IsStoreOpen(storeConfig)
    
                    if storeConfig.BlipData.Allowed then
        
                        local ClosedHoursData = storeConfig.BlipData.DisplayClosedHours
    
                        if isAllowed ~= storeConfig.IsAllowed and storeConfig.BlipHandle then
    
                            RemoveBlip(storeConfig.BlipHandle)
                            
                            Config.Stores[storeId].BlipHandle = nil
                            Config.Stores[storeId].IsAllowed = isAllowed
    
                        end
    
                        if (isAllowed and storeConfig.BlipHandle == nil) or (not isAllowed and ClosedHoursData and ClosedHoursData.Enabled and storeConfig.BlipHandle == nil ) then
                            local blipModifier = isAllowed and 'OPEN' or 'CLOSED'
                            AddBlip(storeId, blipModifier)
    
                            Config.Stores[storeId].IsAllowed = isAllowed
                        end
    
                    end
    
                    if storeConfig.NPC and not isAllowed then
                        RemoveEntityProperly(storeConfig.NPC, GetHashKey(storeConfig.NPCData.Model) )
                        storeConfig.NPC = nil
                    end
    
    
                    if isAllowed then
    
                        if not storeConfig.NPC and storeConfig.NPCData.Allowed and distance <= Config.NPCRenderingSpawnDistance then
                            SpawnNPC(storeId)
                        end
    
                        if (distance <= storeConfig.DistanceOpenStore) and (not storeConfig.HasTarget) then
                            sleep = false
    
                            local promptGroup, promptList = GetPromptData()
    
                            local label = CreateVarString(10, 'LITERAL_STRING', storeConfig.StoreName)
                            PromptSetActiveGroupThisFrame(promptGroup, label)
    
                            if PromptHasHoldModeCompleted(promptList) then
    
                                local hasRequiredJob = true
    
                                if storeConfig.RequiredJobs then
                                    hasRequiredJob = ContainsRequiredParameterOnTable(storeConfig.RequiredJobs, PlayerData.Job)
                                end
        
                                if hasRequiredJob then
                                    TriggerServerEvent('tpz_stores:server:requestAccountInformation')
    
                                    Wait(500)
                                    OpenStoreCategoryMenu(storeId)
    
                                else
                                    SendNotification(nil, Locales['NOT_VALID_JOB'], "error")
                                end
        
                                Wait(1000)
                            
                            end
    
                        end
    
                    end

                end

            end

        end

        if sleep then
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()

    while true do

        Wait(1)

        if PlayerData.IsBusy then
            DisplayRadar(false)
            
            if TPZInv.isInventoryActive() then
                TPZInv.closeInventory()
            end

        else
            Wait(1200)
        end

    end

end)
