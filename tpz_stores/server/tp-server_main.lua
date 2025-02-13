local TPZ = exports.tpz_core:getCoreAPI()

-----------------------------------------------------------
--[[ Local Functions  ]]--
-----------------------------------------------------------

-- @GetTableLength returns the length of a table.
local function GetTableLength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

local function Round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

local function GetPlayerData(source)
	local _source = source
    local xPlayer = TPZ.GetPlayer(_source)

	return {
        steamName      = GetPlayerName(_source),
        username       = xPlayer.getFirstName() .. ' ' .. xPlayer.getLastName(),
		identifier     = xPlayer.getIdentifier(),
        charIdentifier = xPlayer.getCharacterIdentifier(),
		job            = xPlayer.getJob(),
		jobGrade       = xPlayer.getJobGrade(),
		dollars        = xPlayer.getAccount(0),
		gold           = xPlayer.getAccount(1),
	}

end

local GetProductDataByStorePackage = function(productList, item)

	for index, product in pairs (productList) do

		if item == product.item then
			return product
		end

	end

	return nil

end

-----------------------------------------------------------
--[[ General Events  ]]--
-----------------------------------------------------------

RegisterServerEvent("tpz_stores:server:requestAccountInformation")
AddEventHandler("tpz_stores:server:requestAccountInformation", function()
    local _source = source
    local xPlayer = TPZ.GetPlayer(_source)

    if not xPlayer.loaded() then
		return
	end

	local dollars = xPlayer.getAccount(0)
	local gold    = xPlayer.getAccount(1)

	TriggerClientEvent('tpz_stores:client:updateAccount', _source, { dollars, gold })

end)

RegisterServerEvent('tpz_stores:server:buy')
AddEventHandler('tpz_stores:server:buy', function(storeId, categoryName, item, quantity, itemCost, accountType)
	local _source        = source
	local xPlayer        = TPZ.GetPlayer(_source)
	local PlayerData     = GetPlayerData(_source)

	quantity             = tonumber(quantity)

	local oldCost        = itemCost
	local totalCost      = (itemCost * quantity)

	if storeId == nil or categoryName == nil or Config.Stores[storeId] == nil then
		-- devmode?
		return
	end

	local StoreData     = Config.Stores[storeId]
	local Package       = Config.StoreProductPackages[StoreData.StoreProductsPackage]

	local Products      = Package['buy']

	if Package == nil or Package and Package['buy'] == nil then
		-- devmode?
		return
	end

	local ItemData = GetProductDataByStorePackage(Products, item)

	-- 100% Devtools / Injection cheating.
	if ItemData == nil or ItemData.price ~= oldCost or ItemData.account ~= accountType or ItemData.category ~= categoryName then
        if Config.Webhooks['DEVTOOLS_INJECTION_CHEAT'].Enabled then
            local _w, _c      = Config.Webhooks['DEVTOOLS_INJECTION_CHEAT'].Url, Config.Webhooks['DEVTOOLS_INJECTION_CHEAT'].Color
            local description = 'The specified user attempted to use devtools / injection cheat on stores for buying products.'
            TPZ.SendToDiscordWithPlayerParameters(_w, Locales['DEVTOOLS_INJECTION_DETECTED_TITLE_LOG'], _source, PlayerData.steamName, PlayerData.username, PlayerData.identifier, PlayerData.charIdentifier, description, _c)
        end

        xPlayer.disconnect(Locales['DEVTOOLS_INJECTION_DETECTED'])
		return
	end

	local currentMoney = PlayerData.dollars

	if accountType == 'gold' then
		currentMoney = PlayerData.gold
	end

	if currentMoney < totalCost then
		SendNotification(_source, Locales["NOT_ENOUGH_".. string.upper(accountType)], "error")
		return
	end

	local hasBought, boughtText = false, nil

	if ItemData.isWeapon then

		local canCarryWeapon = xPlayer.canCarryWeapon(string.upper(item))

		if not canCarryWeapon then
			SendNotification(_source, Locales['CANNOT_CARRY_WEAPON'], "error")
			return
		end

		xPlayer.addWeapon(string.upper(item))

		local updatedDollars, updatedGold = xPlayer.getAccount(0), xPlayer.getAccount(1)
		TriggerClientEvent("tpz_stores:client:updateAccount", _source, { updatedDollars, updatedGold })

		boughtText = string.format(Locales['BOUGHT_WEAPON_' .. string.upper(accountType)], ItemData.label, oldCost )
		hasBought  = 'WEAPON'

	else

		local canCarryItem = xPlayer.canCarryItem(item, quantity)

		if not canCarryItem then
			SendNotification(_source, Locales['CANNOT_CARRY_ITEM'], "error")
			return
		end

		xPlayer.addItem(item, quantity)

		boughtText = string.format(Locales['BOUGHT_ITEM_' .. string.upper(accountType)], quantity, ItemData.label, Round(totalCost, 2) )
		hasBought  = 'ITEM'
	end

	if hasBought ~= false then

		if accountType == 'dollars' then
			xPlayer.removeAccount(0, totalCost)

		elseif accountType == 'gold' then
			xPlayer.removeAccount(1, totalCost)
		end

		SendNotification(_source, boughtText, "success")

		local updatedDollars, updatedGold = xPlayer.getAccount(0), xPlayer.getAccount(1)
		TriggerClientEvent("tpz_stores:client:updateAccount", _source, { updatedDollars, updatedGold })

		local WebhookData = Config.Webhooks['BOUGHT']

		if WebhookData.Enabled then
			local description = string.format('The specified user has bought X%s %s for %s %s', quantity, ItemData.label, Round(totalCost, 2), Locales[string.upper(accountType)])
			TPZ.SendToDiscordWithPlayerParameters(WebhookData.Url, WebhookData.Title, _source, PlayerData.steamName, PlayerData.username, PlayerData.identifier, PlayerData.charIdentifier, description, WebhookData.Color)
		end
	end

end)


RegisterServerEvent('tpz_stores:server:sell')
AddEventHandler('tpz_stores:server:sell', function(storeId, categoryName, item, quantity, itemCost, accountType)
	local _source        = source
	local xPlayer        = TPZ.GetPlayer(_source)
	local PlayerData     = GetPlayerData(_source)

	quantity             = tonumber(quantity)

	local oldCost        = itemCost
	local totalCost      = (itemCost * quantity)

	if storeId == nil or categoryName == nil or Config.Stores[storeId] == nil then
		-- devmode?
		return
	end

	local StoreData     = Config.Stores[storeId]
	local Package       = Config.StoreProductPackages[StoreData.StoreProductsPackage]

	local Products      = Package['sell']

	if Package == nil or Package and Package['sell'] == nil then
		-- devmode?
		return
	end

	local ItemData = GetProductDataByStorePackage(Products, item)

	-- 100% Devtools / Injection cheating.
	if ItemData == nil or ItemData.price ~= oldCost or ItemData.account ~= accountType or ItemData.category ~= categoryName then
        if Config.Webhooks['DEVTOOLS_INJECTION_CHEAT'].Enabled then
            local _w, _c      = Config.Webhooks['DEVTOOLS_INJECTION_CHEAT'].Url, Config.Webhooks['DEVTOOLS_INJECTION_CHEAT'].Color
            local description = 'The specified user attempted to use devtools / injection cheat on stores for selling products.'
            TPZ.SendToDiscordWithPlayerParameters(_w, Locales['DEVTOOLS_INJECTION_DETECTED_TITLE_LOG'], _source, PlayerData.steamName, PlayerData.username, PlayerData.identifier, PlayerData.charIdentifier, description, _c)
        end

        xPlayer.disconnect(Locales['DEVTOOLS_INJECTION_DETECTED'])
		return
	end

	local itemQuantity = xPlayer.getItemQuantity(item)

    if itemQuantity == nil or itemQuantity and itemQuantity < quantity then
		SendNotification(_source, Locales["NOT_ENOUGH_QUANTITY"], "error")
		return
	end

	xPlayer.removeItem(item, quantity)

	if currencyType == 'dollars' then
		xPlayer.addAccount(0, totalCost)

	elseif currencyType == 'gold' then
		xPlayer.addAccount(1, totalCost)
	end

	local text = string.format(Locales['SOLD_ITEM_' .. string.upper(accountType)], quantity, ItemData.label, Round(totalCost, 2) )
	SendNotification(_source, text, "success")
	
	local updatedDollars, updatedGold = xPlayer.getAccount(0), xPlayer.getAccount(1)
	TriggerClientEvent("tpz_stores:client:updateAccount", _source, { updatedDollars, updatedGold })

	local WebhookData = Config.Webhooks['SOLD']

	if WebhookData.Enabled then
		local description = string.format('The specified user has sold X%s %s and received %s %s', quantity, ItemData.label, Round(totalCost, 2), Locales[string.upper(accountType)])
		TPZ.SendToDiscordWithPlayerParameters(WebhookData.Url, WebhookData.Title, _source, PlayerData.steamName, PlayerData.username, PlayerData.identifier, PlayerData.charIdentifier, description, WebhookData.Color)
	end

end)
