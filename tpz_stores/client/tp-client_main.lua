
ClientData = { loaded = false, job = nil, jobGrade = 0, money = 0, cents = 0, gold = 0 }

-----------------------------------------------------------
--[[ Base  ]]--
-----------------------------------------------------------

-- Updating player job
RegisterNetEvent("tpz_core:getPlayerJob")
AddEventHandler("tpz_core:getPlayerJob", function(data)
    ClientData.job      = data.job
    ClientData.jobGrade = tonumber(data.jobGrade)
end)

RegisterNetEvent('tpz_core:isPlayerReady')
AddEventHandler("tpz_core:isPlayerReady", function()

    if Config.DevMode then 
        return 
    end

    PromptSetUp()

    TriggerEvent("tpz_core:ExecuteServerCallBack", "tpz_core:getPlayerData", function(data) 
        
        ClientData.job, ClientData.jobGrade, ClientData.money, ClientData.cents, ClientData.gold = data.job, data.jobGrade, data.money, data.cents, data.gold

        ClientData.loaded = true
    end)

end)

if Config.DevMode then
    Citizen.CreateThread(function()

        PromptSetUp()

        TriggerEvent("tpz_core:ExecuteServerCallBack", "tpz_core:getPlayerData", function(data) 

            ClientData.job, ClientData.jobGrade, ClientData.money, ClientData.cents, ClientData.gold = data.job, data.jobGrade, data.money, data.cents, data.gold

            ClientData.loaded = true
        end)

    end)
end
-----------------------------------------------------------
--[[ Threads  ]]--
-----------------------------------------------------------

Citizen.CreateThread(function()

    while true do
        Citizen.Wait(0)

        local sleep        = true
        local player       = PlayerPedId()
        local isPlayerDead = IsEntityDead(player)

        while not ClientData.loaded do
            Wait(1000)
        end

        if not IsInMenu and not isPlayerDead then

            local coords = GetEntityCoords(player)
            local hour = GetClockHours()

            for storeId, storeConfig in pairs(Config.Stores) do

                local coordsDist  = vector3(coords.x, coords.y, coords.z)
                local coordsStore = vector3(storeConfig.Coords.x, storeConfig.Coords.y, storeConfig.Coords.z)
                local distance    = #(coordsDist - coordsStore)

                if storeConfig.Hours.Allowed then
      
                    if hour >= storeConfig.Hours.Closing or hour < storeConfig.Hours.Opening then

                        if Config.Stores[storeId].BlipHandle then
                            RemoveBlip(Config.Stores[storeId].BlipHandle)
                            Config.Stores[storeId].BlipHandle = nil
                        end

                        if Config.Stores[storeId].NPC then
                            DeleteEntity(Config.Stores[storeId].NPC)
                            DeletePed(Config.Stores[storeId].NPC)
                            SetEntityAsNoLongerNeeded(Config.Stores[storeId].NPC)
                            Config.Stores[storeId].NPC = nil
                        end

                    elseif hour >= storeConfig.Hours.Opening then
                        if not Config.Stores[storeId].BlipHandle and storeConfig.BlipData.Allowed then
                            AddBlip(storeId)
                        end

                        if Config.Stores[storeId].NPC and distance > Config.RenderNPCDistance then
                            DeleteEntity(Config.Stores[storeId].NPC)
                            DeletePed(Config.Stores[storeId].NPC)
                            SetEntityAsNoLongerNeeded(Config.Stores[storeId].NPC)
                            Config.Stores[storeId].NPC = nil
      
                        end
                        
                        if not Config.Stores[storeId].NPC and storeConfig.NPCData.Allowed and distance <= Config.RenderNPCDistance then
                            SpawnNPC(storeId)
                        end

                        if not Config.QTarget  then
                            if not storeConfig.JobsData.Allowed then 

                                if (distance <= storeConfig.DistanceOpenStore) then 
    
                                    sleep = false
                                    local label = CreateVarString(10, 'LITERAL_STRING', storeConfig.PromptName)
                                    PromptSetActiveGroupThisFrame(PromptGroup, label)
    
                                    if PromptHasHoldModeCompleted(Prompt) then 
                                        OpenStoreCategory(storeId)
    
                                        TaskStandStill(player, -1)

                                        Wait(1000)
                                    end
    
                                end
    
                            else 

                                if (distance <= storeConfig.DistanceOpenStore) then
    
                                    if CheckJob(storeConfig.JobsData.Jobs, ClientData.job) then
                                        sleep = false
                                        local label = CreateVarString(10, 'LITERAL_STRING', storeConfig.PromptName)
    
                                        PromptSetActiveGroupThisFrame(PromptGroup, label)
    
                                        if PromptHasHoldModeCompleted(Prompt) then 
                                            OpenStoreCategory(storeId)
    
                                            TaskStandStill(player, -1)

                                            Wait(1000)
                                        end
                                    end
                                end
                            end
                        end
                    end
                else

                    if not Config.Stores[storeId].BlipHandle and storeConfig.BlipData.Allowed then
                        AddBlip(storeId)
                    end

                    if Config.Stores[storeId].NPC and distance > Config.RenderNPCDistance then
                        DeleteEntity(Config.Stores[storeId].NPC)
                        DeletePed(Config.Stores[storeId].NPC)
                        SetEntityAsNoLongerNeeded(Config.Stores[storeId].NPC)
                        Config.Stores[storeId].NPC = nil
                    end
                    
                    if not Config.Stores[storeId].NPC and storeConfig.NPCData.Allowed and distance <= Config.RenderNPCDistance then
                        SpawnNPC(storeId)
                    end

                    if not Config.QTarget then
                        if not storeConfig.JobsData.Allowed then 
 
                            if (distance <= storeConfig.DistanceOpenStore) then -- check distance
    
                                sleep = false
                                local label = CreateVarString(10, 'LITERAL_STRING', storeConfig.PromptName)
                                PromptSetActiveGroupThisFrame(PromptGroup, label)
    
                                if PromptHasHoldModeCompleted(Prompt) then 
                                    OpenStoreCategory(storeId)
                                    TaskStandStill(player, -1)

                                    Wait(1000)
                                end
    
                            end
    
                        else -- job only
    
                            if (distance <= storeConfig.DistanceOpenStore) then
                                if CheckJob(storeConfig.JobsData.Jobs, ClientData.job) then
           
                                    sleep = false
                                    local label = CreateVarString(10, 'LITERAL_STRING', storeConfig.PromptName)
    
                                    PromptSetActiveGroupThisFrame(PromptGroup, label)
    
                                    if PromptHasHoldModeCompleted(Prompt) then 

                                        OpenStoreCategory(storeId)

                                        TaskStandStill(player, -1)

                                        Wait(1000)
                                    end
                                end
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