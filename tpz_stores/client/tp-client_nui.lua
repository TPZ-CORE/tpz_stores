
local openedStoreId = 0

local UIData = {category = nil, storeCategoryType = nil}

------------------------------------------------------------------
-- Events
------------------------------------------------------------------

RegisterNetEvent("tpz_stores:closeNUI")
AddEventHandler("tpz_stores:closeNUI", function()
	SendNUIMessage({action = 'closeUI'})
end)

-- Update Player Account.
RegisterNetEvent("tpz_stores:requestPlayerAccountUpdate")
AddEventHandler("tpz_stores:requestPlayerAccountUpdate", function()

	TriggerEvent("tpz_core:ExecuteServerCallBack", "tpz_core:getPlayerData", function(data) 
		SendNUIMessage({ action = 'updatePlayerAccountInformation', accounts = {dollars = data.money, cents = data.cents, gold = data.gold } })
	end)

end)

------------------------------------------------------------------
-- Functions
------------------------------------------------------------------

OpenStoreCategory = function (storeId, cb)
	openedStoreId     = storeId

	local storeConfig = Config.Stores[storeId]

	TriggerEvent("tpz_core:ExecuteServerCallBack", "tpz_core:getPlayerData", function(data) 

		SendNUIMessage({ action = 'updateStoreHeaderTitle', header = storeConfig.StoreName, footer = Locales['choose_category']})
		SendNUIMessage({ action = 'updatePlayerAccountInformation', accounts = {dollars = data.money, cents = data.cents, gold = data.gold } })
	
		for k, v in pairs(storeConfig.Categories) do
	
			SendNUIMessage({
				action = 'addStoreCategories',
				label = v.category,
			})
			
		end
	
		Wait(500)
				
		UIType = "enable_shop"
		EnableGui(true, UIType)
	end)
end

EnableGui = function(state, ui)
	SetNuiFocus(state, state)

    if state == false then
        TaskStandStill(PlayerPedId(), 1)
    end

    IsInMenu = state
	SendNUIMessage({
		type = ui,
		enable = state
	})
end

------------------------------------------------------------------
-- NUI CallBacks
------------------------------------------------------------------

RegisterNUICallback('closeNUI', function()
	EnableGui(false, UIType)
end)


RegisterNUICallback('loadCategories', function(data)

	local storeConfig = Config.Stores[openedStoreId]

	SendNUIMessage({ action = 'updateStoreHeaderTitle', header = storeConfig.StoreName, footer = Locales['choose_category']})

	for k, v in pairs(storeConfig.Categories) do
		SendNUIMessage({ action = 'addStoreCategories', label = v.category })
	end
	
end)

RegisterNUICallback('loadStoreTypeCategories', function(data)

	local storeConfig = Config.Stores[openedStoreId]

	SendNUIMessage({ action = 'updateStoreHeaderTitle', header = storeConfig.StoreName, footer = Locales['choose_category']})

	-- returns the selected category (ex. food, tools, other)
	UIData.storeCategoryType = data.category

	for k, v in pairs(storeConfig.Categories) do

		if v.category == data.category then

			for _, type in pairs (v.types) do
				
				SendNUIMessage({
					action = 'addStoreCategoryTypes',
					label = type,
				})
			end
		end
	end


end)

RegisterNUICallback('loadStoreTypeCategoryProducts', function(data)

	local storeConfig = Config.Stores[openedStoreId]

	local levelingData  = storeConfig.LevelingData
	local currentLevel = 1

	if levelingData ~= nil and levelingData.Allowed then
		--currentLevel = exports.tp_leveling:getLevel(levelingData.Type)
	end

	SendNUIMessage({ action = 'updateStoreHeaderTitle', header = storeConfig.StoreName, footer = Locales[data.category .. "_menu"]})

	-- returns the selected type category (ex. sell, buy)
	UIData.category = data.category

	for k, v in pairs(storeConfig.Categories) do

		--print(v.category, UIData.storeCategoryType, v.types, UIData.category)

		if v.category == UIData.storeCategoryType  then

			local productsList = Config.StoreProductPackages[ storeConfig.StoreProductsPackage ] [UIData.category]

			for _, product in pairs (productsList) do
		
				if product.category == UIData.storeCategoryType then

					local hasJob = CheckJob(product.jobs, ClientData.job)

					if levelingData == nil or not levelingData.Allowed then


						if product.jobs == nil or product.jobs ~= nil and hasJob then
							product.hasRequiredLevel = true

							product.availableCount = 0
	
							SendNUIMessage({
								action = 'addStoreSelectedCategoryProducts',
								item_data = product,
								store_type = data.category,
							})
						end
					else

						if product.jobs == nil or product.jobs ~= nil and hasJob then
							local hasRequiredLevel = product.requiredLevel <= currentLevel

							product.hasRequiredLevel = hasRequiredLevel
	
							product.availableCount = 0
	
							SendNUIMessage({
								action = 'addStoreSelectedCategoryProducts',
								item_data = product,
								store_type = data.category,
							})
						end
			
					end
				end
				
			end
		end
	end


end)


local hasCooldownAction = false

RegisterNUICallback('performActionOnSelectedProduct', function(data)
	-- data.item, data.label, data.quantity, data.category, data.currency


	if data.item == nil then
		SendNotification(nil, Locales['NOT_SELECTED'], "error")
		return
	end

	if data.quantity == nil or tonumber(data.quantity) == nil or tonumber(data.quantity) <= 0 then 
		SendNotification(nil, Locales['WRONG_INPUT'], "error")
		return 
	end

	if not hasCooldownAction then

		hasCooldownAction = true

		if data.category == "buy" then

			TriggerServerEvent("tpz_stores:onSelectedProductPurchase", data.item, data.label, tonumber(data.quantity), tonumber(data.cost), data.currency)
	
		elseif data.category == "sell" then

			TriggerServerEvent("tpz_stores:onSelectedProductSell", data.item, data.label, tonumber(data.quantity), tonumber(data.cost), data.currency)

		end

		Wait(3000)
		hasCooldownAction = false
	else
		SendNotification(nil, Locales['SPAMMING'], "error")
	end
end)