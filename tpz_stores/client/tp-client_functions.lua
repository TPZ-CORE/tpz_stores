local PromptGroup  = GetRandomIntInRange(0, 0xffffff)
local PromptList   = nil


--[[-------------------------------------------------------
 Base Events
]]---------------------------------------------------------

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    Citizen.InvokeNative(0x00EDE88D4D13CF59, PromptGroup) -- UiPromptDelete

    if GetPlayerData().IsBusy then
        ClearPedTasksImmediately(PlayerPedId())
        PromptDelete(PromptList)
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


--[[-------------------------------------------------------
 Prompts
]]---------------------------------------------------------

RegisterActionPrompt = function()
    local str = Locales["PROMPT_TEXT"]
    PromptList = PromptRegisterBegin()
    PromptSetControlAction(PromptList, Config.PromptAction.Key)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(PromptList, str)
    PromptSetEnabled(PromptList, 1)
    PromptSetVisible(PromptList, 1)
    PromptSetStandardMode(PromptList, 1)
    PromptSetHoldMode(PromptList, Config.PromptAction.HoldMode)
    PromptSetGroup(PromptList, PromptGroup)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, PromptList, true)
    PromptRegisterEnd(PromptList)
end

GetPromptData = function ()
    return PromptGroup, PromptList
end

--[[-------------------------------------------------------
 Blips
]]---------------------------------------------------------


function AddBlip(Store)
    if Config.Stores[Store].BlipData then
        Config.Stores[Store].BlipHandle = N_0x554d9d53f696d002(1664425300, Config.Stores[Store].Coords.x, Config.Stores[Store].Coords.y, Config.Stores[Store].Coords.z)

        SetBlipSprite(Config.Stores[Store].BlipHandle, Config.Stores[Store].BlipData.Sprite, 1)
        SetBlipScale(Config.Stores[Store].BlipHandle, 0.2)
        Citizen.InvokeNative(0x9CB1A1623062F402, Config.Stores[Store].BlipHandle, Config.Stores[Store].BlipData.Name)
    end
end


--[[-------------------------------------------------------
 NPC
]]---------------------------------------------------------

LoadModel = function(inputModel)
    local model = GetHashKey(inputModel)
 
    RequestModel(model)
 
    while not HasModelLoaded(model) do RequestModel(model)
        Citizen.Wait(10)
    end
end

RemoveEntityProperly = function(entity, objectHash)
	DeleteEntity(entity)
	DeletePed(entity)
	SetEntityAsNoLongerNeeded( entity )

	if objectHash then
		SetModelAsNoLongerNeeded(objectHash)
	end
end

function SpawnNPC(Store)
    local v = Config.Stores[Store]

    LoadModel(v.NPCData.Model)

    local coords = v.NPCData.Coords
    local npc = CreatePed(v.NPCData.Model, coords.x, coords.y, coords.z, coords.h, false, true, true, true)

    Citizen.InvokeNative(0x283978A15512B2FE, npc, true) -- SetRandomOutfitVariation
    SetEntityNoCollisionEntity(PlayerPedId(), npc, false)
    SetEntityCanBeDamaged(npc, false)
    SetEntityInvincible(npc, true)
    Wait(1000)
    FreezeEntityPosition(npc, true) -- NPC can't escape
    SetBlockingOfNonTemporaryEvents(npc, true) -- NPC can't be scared

    Config.Stores[Store].NPC = npc
end

--[[-------------------------------------------------------
 Other
]]---------------------------------------------------------

ShowNotification = function(_message, rgbData, timer)

    if timer == nil or timer == 0 then
        timer = 200
    end
    local r, g, b, a = 161, 3, 0, 255

    if rgbData then
        r, g, b, a = rgbData.r, rgbData.g, rgbData.b, rgbData.a
    end

	while timer > 0 do
		DisplayHelp(_message, 0.50, 0.90, 0.6, 0.6, true, r, g, b, a, true)

		timer = timer - 1
		Citizen.Wait(0)
	end

end

DisplayHelp = function(_message, x, y, w, h, enableShadow, col1, col2, col3, a, centre)

	local str = CreateVarString(10, "LITERAL_STRING", _message, Citizen.ResultAsLong())

	SetTextScale(w, h)
	SetTextColor(col1, col2, col3, a)

	SetTextCentre(centre)

	if enableShadow then
		SetTextDropshadow(1, 0, 0, 0, 255)
	end

	Citizen.InvokeNative(0xADA9255D, 10);

	DisplayText(str, x, y)

end


-- @GetTableLength returns the length of a table.
function GetTableLength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function ContainsRequiredParameterOnTable(table, element)

    if table == nil then table = {} end

    for k, v in pairs(table) do

        if v == element then
            return true
        end
    end

    return false
end

function StartsWith(String,Start)
    return string.sub(String,1,string.len(Start))==Start
end