local menuOpen = false
local playerInventory = {}

-- Function to calculate the total weight of the player's inventory
local function calculateInventoryWeight()
    local totalWeight = 0
    for _, item in ipairs(playerInventory) do
        local itemWeight = item.weight or 0
        totalWeight = totalWeight + (itemWeight * item.quantity)
    end
    return totalWeight
end

-- Function to open the inventory menu
local function openInventoryMenu()
    if not menuOpen then
        menuOpen = true
        local menu = MenuV:CreateMenu("Inventory", "Select an item", "bottomright")

        -- Calculate total weight
        local totalWeight = calculateInventoryWeight()

        -- Display weight info in the menu
        local weightInfo = string.format("Weight: %d / %d", totalWeight, Config.MaxInventoryWeight)
        menu:Label(weightInfo)

        -- Create a list of items in the inventory
        for _, item in ipairs(playerInventory) do
            local itemButton = MenuV:CreateItem(item.name, nil, "bottomright")  -- Removed icon reference
            itemButton:On("select", function()
                -- Check if using the item will exceed the max weight
                local newWeight = totalWeight - (item.weight * item.quantity)
                if newWeight > Config.MaxInventoryWeight then
                    print("You can't carry more items, weight limit reached!")
                    return
                end

                -- Handle item selection (e.g., use item, drop item, etc.)
                print("Selected item: " .. item.name)
                -- Example action: Decrease quantity
                item.quantity = item.quantity - 1
                if item.quantity <= 0 then
                    print(item.name .. " has been used up.")
                end
                -- Send update to server
                TriggerServerEvent('inventory:updateItem', item)
            end)
            itemButton:On("hover", function()
                -- Optional: Show item details when hovering
                print("Hovered over item: " .. item.name)
            end)
            itemButton:Label(item.quantity .. " left")
            menu:AddItem(itemButton)
        end

        -- Add the Close button
        local closeButton = MenuV:CreateItem("Close", "close", "bottomright")
        closeButton:On("select", function()
            print("Closing inventory")
            menu:Close()
            menuOpen = false
        end)
        menu:AddItem(closeButton)

        -- Show the menu
        menu:Open()
    end
end

-- Load inventory from the server when the player joins
RegisterNetEvent('inventory:loadInventory')
AddEventHandler('inventory:loadInventory', function(inventory)
    playerInventory = inventory
end)

-- Register the command to open the inventory menu
RegisterCommand("open_inventory", function()
    openInventoryMenu()
end)

-- Bind the inventory opening to the 'I' key by default
RegisterKeyMapping('open_inventory', 'Open Inventory', 'keyboard', 'I')

-- Request inventory data when player joins the server
AddEventHandler('playerSpawned', function()
    TriggerServerEvent('inventory:getInventory')
end)
