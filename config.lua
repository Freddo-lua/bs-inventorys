-- config.lua

Config = {}

-- Set the maximum allowed weight in the player's inventory
-- This weight is just a unit of measurement (you can use kilograms, pounds, etc.)
Config.MaxInventoryWeight = 50 -- Example: 50 units of weight

-- Set the weight for each item (this can vary per item type)
Config.ItemWeights = {
    ["Water"] = 2,      -- Example weight for water
    ["Bread"] = 1,      -- Example weight for bread
    ["First Aid Kit"] = 3, -- Example weight for first aid kit
    -- Add more items and their weights here
}
