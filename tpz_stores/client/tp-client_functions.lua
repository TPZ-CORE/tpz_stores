
Prompt, CloseStores = nil, nil
CurrentDayName          = nil
IsInMenu                = false


AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    if IsInMenu == true then
        ClearPedTasksImmediately(PlayerPedId())
    end

    for i, v in pairs(Config.Stores) do
        if v.BlipHandle then
            RemoveBlip(v.BlipHandle)
        end
        if v.NPC then
            DeleteEntity(v.NPC)
            DeletePed(v.NPC)
            SetEntityAsNoLongerNeeded(v.NPC)
        end
    end
end)

-----------------------------------------------------------
--[[ Prompts  ]]--
-----------------------------------------------------------

PromptGroup  = GetRandomIntInRange(0, 0xffffff)
Prompt       = nil

function PromptSetUp()
    local str = Locales["PROMPT_DISPLAY_TEXT"]

    Prompt = PromptRegisterBegin()

    PromptSetControlAction(Prompt, Config.OpenKey)

    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(Prompt, str)
    PromptSetEnabled(Prompt, 1)
    PromptSetVisible(Prompt, 1)
    PromptSetStandardMode(Prompt, 1)
    PromptSetHoldMode(Prompt, 500)
    PromptSetGroup(Prompt, PromptGroup)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, Prompt, true)
    PromptRegisterEnd(Prompt)
    
end

-----------------------------------------------------------
--[[ Blips  ]]--
-----------------------------------------------------------

function AddBlip(Store)
    if Config.Stores[Store].BlipData then
        Config.Stores[Store].BlipHandle = N_0x554d9d53f696d002(1664425300, Config.Stores[Store].Coords.x, Config.Stores[Store].Coords.y, Config.Stores[Store].Coords.z)

        SetBlipSprite(Config.Stores[Store].BlipHandle, Config.Stores[Store].BlipData.Sprite, 1)
        SetBlipScale(Config.Stores[Store].BlipHandle, 0.2)
        Citizen.InvokeNative(0x9CB1A1623062F402, Config.Stores[Store].BlipHandle, Config.Stores[Store].BlipData.Name)
    end
end


-----------------------------------------------------------
--[[ NPC  ]]--
-----------------------------------------------------------

LoadModel = function(model)

    local model = GetHashKey(model)

    if IsModelValid(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(100)
        end
    else
        print(model .. " is not valid") -- Concatenations
    end
end

function SpawnNPC(Store)
    local v = Config.Stores[Store]

    if v.NPCData.Allowed then

        LoadModel(v.NPCData.Model)

        local npc = CreatePed(v.NPCData.Model, v.Coords.x, v.Coords.y, v.Coords.z, v.Coords.h, false, true, true, true)

        Citizen.InvokeNative(0x283978A15512B2FE, npc, true) -- SetRandomOutfitVariation
        SetEntityNoCollisionEntity(PlayerPedId(), npc, false)
        SetEntityCanBeDamaged(npc, false)
        SetEntityInvincible(npc, true)
        Wait(1000)
        FreezeEntityPosition(npc, true) -- NPC can't escape
        SetBlockingOfNonTemporaryEvents(npc, true) -- NPC can't be scared

        Config.Stores[Store].NPC = npc

        if Config.QTarget then
            exports.qtarget:AddLocalTargetEntity(npc, {
                options = {
                    {
                        event = 'tpz_stores',
                        store = Store,
                        param1 = false,
                        icon = "fas fa-box-circle-check",
                        label = v.StoreName,
                        num = 1
                    },
        
                },
                
                distance = 2.5
            }) 
        end
    end
end

-----------------------------------------------------------
--[[ General  ]]--
-----------------------------------------------------------

function CheckJob(table, element)

    if table == nil then table = {} end

    for k, v in pairs(table) do
        if v == element then
            return true
        end
    end
    return false
end
