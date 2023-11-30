local TPZ          = {}
local TPZInv       = exports.tpz_inventory:getInventoryAPI()

TriggerEvent("getTPZCore", function(cb) TPZ = cb end)

RegisterServerEvent('tpz_stores:onSelectedProductPurchase')
AddEventHandler('tpz_stores:onSelectedProductPurchase', function(item, label, quantity, itemCost, currencyType)
	local _source   = source
	local xPlayer   = TPZ.GetPlayer(_source)
	
	quantity        = tonumber(quantity)
	local totalCost = itemCost * quantity

	-- Getting current account values.
	local money     = xPlayer.getAccount(0) -- cash
	local cents     = xPlayer.getAccount(1) -- cents
	local gold      = xPlayer.getAccount(2) -- gold

	-- Checking if player inventory can carry the requested item quantity.
	local canCarryItem = TPZInv.canCarryItem(_source, item, quantity)

	Wait(300)
	
	if canCarryItem then

		if currencyType == "dollars" then

			if money >= totalCost then

				xPlayer.removeAccount(0, totalCost)

				TPZInv.addItem(_source, item, quantity)
				SendNotification(_source, string.format(Locales['SUCESSFULLY_BOUGHT'], quantity, label, totalCost, Locales['CASH']), "success")

				-- The following client event updates the money account while having the store open.
				Wait(250)
				TriggerClientEvent("tpz_stores:requestPlayerAccountUpdate", _source)

			else
				SendNotification(_source, Locales['NOT_ENOUGH_CASH'], "error")
			end

		elseif currencyType == "cents" then

			local success = xPlayer.removeAccount(1, totalCost)

			if success then

				TPZInv.addItem(_source, item, quantity)
				SendNotification(_source, string.format(Locales['SUCESSFULLY_BOUGHT'], quantity, label, totalCost, Locales['CENTS']), "success")

				TriggerClientEvent("tpz_stores:requestPlayerAccountUpdate", _source)
			else

				SendNotification(_source, Locales['NOT_ENOUGH_CENTS_OR_CASH'], "error")
			end

		elseif currencyType == "gold" then

			if gold >= totalCost then

				xPlayer.removeAccount(2, totalCost)

				TPZInv.addItem(_source, item, quantity)
				SendNotification(_source, string.format(Locales['SUCESSFULLY_BOUGHT'], quantity, label, totalCost, Locales['GOLD']), "success")

				-- The following client event updates the money account while having the store open.
				TriggerClientEvent("tpz_stores:requestPlayerAccountUpdate", _source)

			else
				SendNotification(_source, Locales['NOT_ENOUGH_GOLD'], "error")
			end

		end

	else
		SendNotification(_source, Locales['CANNOT_CARRY'], "error")
	end
end)

RegisterServerEvent('tpz_stores:onSelectedProductSell')
AddEventHandler('tpz_stores:onSelectedProductSell', function(item, label, quantity, itemCost, currencyType)

	local _source      = source
	local xPlayer      = TPZ.GetPlayer(_source)

	quantity           = tonumber(quantity)
	local totalCost    = itemCost * quantity

	local itemQuantity = TPZInv.getItemQuantity(_source, item)

	print(itemQuantity)

	Wait(1000)
	print(itemQuantity)

    if tonumber(quantity) <= itemQuantity then

		if currencyType == "dollars" then

			xPlayer.addAccount(0, totalCost)

			TPZInv.removeItem(_source, item, quantity)
			VORPcore.NotifyRightTip( _source, Locales["yousold"] .. quantity .. " " .. label .. Locales["frcash"] .. totalCost .. Locales['ofcash'],3000)

			SendNotification(_source, string.format(Locales['SUCESSFULLY_SOLD'], quantity, label, totalCost, Locales['CASH']), "success")

			-- The following client event updates the money account while having the store open.
			TriggerClientEvent("tpz_stores:requestPlayerAccountUpdate", _source)
	
		elseif currencyType == "cents" then

			if totalCost < 100 then

				xPlayer.addAccount(1, totalCost)

				TPZInv.removeItem(_source, item, quantity)
				SendNotification(_source, string.format(Locales['SUCESSFULLY_SOLD'], quantity, label, totalCost, Locales['CENTS']), "success")
	
				-- The following client event updates the money account while having the store open.
				TriggerClientEvent("tpz_stores:requestPlayerAccountUpdate", _source)

			elseif totalCost > 100 then

				local fixedQuantity = 1 * (totalCost / 100)
				local fixedQuantity2 = totalCost - math.floor(fixedQuantity) * 100
	
				TPZInv.removeItem(_source, item, quantity)

				xPlayer.addAccount(0, math.floor(fixedQuantity))
				xPlayer.addAccount(1, math.floor(fixedQuantity2))
	
				SendNotification(_source, string.format(Locales['SUCESSFULLY_SOLD'], quantity, label, math.floor(fixedQuantity), Locales['CASH'], math.floor(fixedQuantity2), Locales['CENTS']), "success")

				-- The following client event updates the money account while having the store open.
				TriggerClientEvent("tpz_stores:requestPlayerAccountUpdate", _source)

			end
		end

	else
		SendNotification(_source, Locales['NO_QUANTITY_TO_SELL'], "error")
	end


end)
