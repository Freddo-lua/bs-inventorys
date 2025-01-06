local playerInventories = {}

-- Function to load the inventory from the saved file (on server start)
local function loadInventory()
    local filePath = 'inventory.json'
    if file.exists(filePath) then
        local file = io.open(filePath, 'r')
        local data = file:read('*a')
        file:close()
        local inventories = json.decode(data) or {}
        playerInventories = inventories
    else
        print("No existing inventory file found, starting with empty inventories.")
    end
end

-- Function to save the inventory to a file (called every time an update occurs)
local function saveInventory()
    local filePath = 'inventory.json'
    local file = io.open(filePath, 'w')
    if file then
        file:write(json.encode(playerInventories))
        file:close()
    else
        print("Error saving inventory to file.")
    end
end

-- Load inventory when the server starts
AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        loadInventory()
    end
end)

-- When a player joins, send them their saved inventory
RegisterServerEvent('inventory:getInventory')
AddEventHandler('inventory:getInventory', function()
    local _source = source
    local inventory = playerInventories[_source] or {}
    TriggerClientEvent('inventory:loadInventory', _source, inventory)
end)

-- Function to calculate the player's inventory weight
local function calculateInventoryWeight(inventory)
    local totalWeight = 0
    for _, item in ipairs(inventory) do
        local itemWeight = item.weight or 0
        totalWeight = totalWeight + (itemWeight * item.quantity)
    end
    return totalWeight
end

-- When an item is updated (e.g., item used or quantity changed), update the player's inventory
RegisterServerEvent('inventory:updateItem')
AddEventHandler('inventory:updateItem', function(updatedItem)
    local _source = source
    playerInventories[_source] = playerInventories[_source] or {}

    local inventory = playerInventories[_source]
    local currentWeight = calculateInventoryWeight(inventory)

    -- Calculate the weight change based on the updated item
    local itemWeight = updatedItem.weight or 0
    local weightChange = itemWeight * updatedItem.quantity

    -- Ensure that the new weight does not exceed the max allowed weight
    if currentWeight + weightChange > Config.MaxInventoryWeight then
        print("Player " .. _source .. " exceeds max inventory weight!")
        TriggerClientEvent('inventory:exceedsWeightLimit', _source)
        return
    end

    -- Update the item in the player's inventory
    for i, item in ipairs(inventory) do
        if item.name == updatedItem.name then
            inventory[i] = updatedItem
            break
        end
    end

    -- Save the updated inventory
    saveInventory()
end)
