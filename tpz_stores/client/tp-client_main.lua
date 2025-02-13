local TPZInv = exports.tpz_inventory:getInventoryAPI()

local PlayerData = { 
    Job               = nil, 
    Account           = { 0, 0 },
    IsBusy            = false,
}

---------------------------------------------------------------
--[[ Local Functions ]]--
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

                local coordsDist  = vector3(coords.x, coords.y, coords.z)
                local coordsStore = vector3(storeConfig.Coords.x, storeConfig.Coords.y, storeConfig.Coords.z)
                local distance    = #(coordsDist - coordsStore)

                -- Before everything, we are removing spawned entities if the rendering distance
                -- is bigger than the configurable max distance.
                if storeConfig.NPC and distance > Config.NPCRenderingSpawnDistance then
                    RemoveEntityProperly(storeConfig.NPC, GetHashKey(storeConfig.NPCData.Model) )
                    storeConfig.NPC = nil
                end

                local isAllowed = false
                
                if storeConfig.Hours.Allowed then

                    if hour >= storeConfig.Hours.Opening and hour < storeConfig.Hours.Closing then
                        isAllowed = true
                    end

                else
                    isAllowed = true
                end

                if storeConfig.BlipHandle and not isAllowed then
                    RemoveBlip(storeConfig.BlipHandle)
                    storeConfig.BlipHandle = nil
                end

                if storeConfig.NPC and not isAllowed then
                    RemoveEntityProperly(storeConfig.NPC, GetHashKey(storeConfig.NPCData.Model) )
                    storeConfig.NPC = nil
                end

                if isAllowed then

                    if not storeConfig.BlipHandle and storeConfig.BlipData.Allowed then
                        AddBlip(storeId)
                    end

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