---@diagnostic disable: undefined-global
local MenuData = {}

TriggerEvent("tpz_menu_base:getData", function(call)
    MenuData = call
end)

local IMAGE_PATH <const>  = "<img style='max-height:1.7vw;max-width:1.7vw; float:%s; margin-top: -0.41vw;' src='nui://tpz_inventory/html/img/items/%s.png'>"
local TITLE_STYLE <const> = "<span style='opacity:1.0; float:left; margin-left: 0.3vw; margin-top: -0.2vw; text-align: right; font-size: 0.8vw;' >%s</span>"
local LABEL_STYLE <const> = "<span style='opacity:0.6; float:right; text-align: right; font-size: 0.6vw;' >%s</span>"

---------------------------------------------------------------
--[[ Local Functions ]]--
---------------------------------------------------------------

---------------------------------------------------------------
--[[ Functions ]]--
---------------------------------------------------------------

function CloseMenu()
    MenuData.CloseAll()
end

-- Main Menu (Displaying Store Categories)
function OpenStoreCategoryMenu(storeId)
    MenuData.CloseAll()

    local PlayerData = GetPlayerData()

    PlayerData.IsBusy = true
    TaskStandStill(PlayerPedId(), -1)

    local StoreData = Config.Stores[storeId]

    local elements = {}

    for _, category in pairs (StoreData.Categories) do 
        table.insert(elements, { label = category.label, value = category.type, desc = category.description, types = category.types })
    end

    MenuData.Open('default', GetCurrentResourceName(), 'main',
        {
            title    = StoreData.StoreName,
            subtext  = string.format(Locales['CURRENT_ACCOUNT'], PlayerData.Account[1], PlayerData.Account[2]),
            align    = "left",
            elements = elements,
            lastmenu = "notMenu"
        },

        function(data, menu)

            if (data.current == "backup") or (data.current.value == "exit") then 
                PlayerData.IsBusy = false
                TaskStandStill(PlayerPedId(), 1)

                menu.close()

                return
            else
                -- @data.current returns the selected element data directly from table.insert.
                OpenStoreCategoryByCategory(storeId, data.current.value, data.current)
                menu.close()
            end

        end,

    function(data, menu)
        PlayerData.IsBusy = false
        TaskStandStill(PlayerPedId(), 1)

        menu.close()
    end)

end

function OpenStoreCategoryByCategory(storeId, categoryName, configData)
    MenuData.CloseAll()

    local PlayerData = GetPlayerData()
    local StoreData  = Config.Stores[storeId]

    -- If the action types { buy, sell } are not more than 2 args, but only one: { buy } or { sell },
    -- we open directly the buy or sell menu than displaying the type categories.
    if GetTableLength(configData.types) <= 1 then
        OpenStoreCategoryByCategoryActionType(storeId, categoryName, configData, configData.types[1])
        return
    end

    local elements = {}

    for _, actionType in pairs (configData.types) do 
        table.insert(elements, { label = string.format(Locales['CATEGORY_' .. string.upper(actionType) ], configData.label ), value = actionType, desc = ''})
    end

    MenuData.Open('default', GetCurrentResourceName(), 'category',
        {
            title    = StoreData.StoreName,
            subtext  = string.format(Locales['CURRENT_ACCOUNT'], PlayerData.Account[1], PlayerData.Account[2]),
            align    = "left",
            elements = elements,
            lastmenu = "notMenu"
        },

        function(data, menu)

            if (data.current == "backup") then 
                OpenStoreCategoryMenu(storeId)

            else
                OpenStoreCategoryByCategoryActionType(storeId, categoryName, configData, data.current.value)
                menu.close()
            end

        end,

    function(data, menu)
        OpenStoreCategoryMenu(storeId)
    end)

end

function OpenStoreCategoryByCategoryActionType(storeId, categoryName, configData, actionType)
    MenuData.CloseAll()

    local PlayerData = GetPlayerData()
    local StoreData  = Config.Stores[storeId]

    local products = {}

    local PackageData = Config.StoreProductPackages[StoreData.StoreProductsPackage]

    if PackageData == nil or PackageData and PackageData[actionType] == nil then
        print(string.format('[Error] : Invalid products on [%s], [%s] category and [%s] action.', storeId, categoryName, actionType))
    else
        products = PackageData[actionType]
    end

    local elements = {}

    for _, product in pairs (products) do 

        if categoryName == product.category then

            local displayProduct = false

            if Config.tpz_leveling and product.requiredLevelingType ~= false then
                local levelTypeData = exports.tpz_leveling:GetLevelTypeExperienceData(product.requiredLevelingType)

                if levelTypeData and product.requiredLevel <= levelTypeData.level then
                    displayProduct = true
                end

            else
                displayProduct = true
            end

            if displayProduct then

                table.insert(elements, { 
                    label    = IMAGE_PATH:format("left", product.item) .. TITLE_STYLE:format(product.label) .. " " .. LABEL_STYLE:format("X1 " .. product.price .. " " .. product.account ),
                    value    = product.item,
                    cost     = product.price,
                    account  = product.account,
                    title    = product.label,
                    isWeapon = product.isWeapon,
                    desc     = string.format(Locales['PRESS_TO_' .. string.upper(actionType)], product.label, product.price, Locales[string.upper(product.account)])
                })

            end

        end

    end

    MenuData.Open('default', GetCurrentResourceName(), 'category_products',
        {
            title    = StoreData.StoreName,
            subtext  = string.format(Locales['CURRENT_ACCOUNT'], PlayerData.Account[1], PlayerData.Account[2]),
            align    = "left",
            elements = elements,
            lastmenu = "notMenu"
        },

        function(data, menu)

            if (data.current == "backup") then 

                if GetTableLength(configData.types) > 1 then
                    OpenStoreCategoryByCategory(storeId, categoryName, configData)
                else
                    OpenStoreCategoryMenu(storeId)
                end

                menu.close()
            else

                local returnedValue      = 1
                local finished           = false
                local isValidTransaction = false
            
                local SelectedItemData = data.current

                if not SelectedItemData.isWeapon then

                    local inputData = {
                        title = SelectedItemData.title,
                        desc  = string.format(Locales['INPUT_' .. string.upper(actionType) .. '_DESCRIPTION'], SelectedItemData.cost, Locales[string.upper(SelectedItemData.account)]),
                        buttonparam1 = Locales['INPUT_ACTION_BUTTON'],
                        buttonparam2 = Locales['INPUT_DECLINE_BUTTON']
                    }
            
                    TriggerEvent("tpz_inputs:getTextInput", inputData, function(cb)
            
                        if tonumber(cb) == nil or tonumber(cb) <= 0 then

                            if tostring(cb) ~= "DECLINE" then
                                SendNotification(nil, Locales['INVALID_QUANTITY'], "error")
                            end

                            Cooldown = false
                            finished = true
                            return 
                        end
            
                        if tostring(cb) ~= "DECLINE" then
                            returnedValue = tonumber(cb)
                            isValidTransaction = true
                        end
            
                        finished = true
            
                    end)
                
                else
                    finished = true
                    isValidTransaction = true
                end
            
                while not finished do
                    Wait(50)
                end
            
                if not isValidTransaction then
                    return
                end

                if actionType == "buy" then
                    
                    TriggerServerEvent("tpz_stores:server:buy", storeId, categoryName, SelectedItemData.value, returnedValue, SelectedItemData.cost, SelectedItemData.account)

                elseif actionType == 'sell' then

                    TriggerServerEvent("tpz_stores:server:sell", storeId, categoryName, SelectedItemData.value, returnedValue, SelectedItemData.cost, SelectedItemData.account)

                end

            end

        end,

    function(data, menu)

        if GetTableLength(configData.types) > 1 then
            OpenStoreCategoryByCategory(storeId, categoryName, configData)
        else
            OpenStoreCategoryMenu(storeId)
        end

        menu.close()
    end)

end