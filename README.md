# bs-inventorys

## Overview
This resource adds a basic inventory system to your FiveM server using the MenuV library. Players can interact with an inventory UI to view and select items.

## Requirements
- [MenuV](https://github.com/Darkmyre/MenuV) must be installed and running as a dependency for this script to work.

## Installation

1. Install [MenuV](https://github.com/Darkmyre/MenuV) and ensure it is running on your server.
2. Add this resource to your server's resources folder.
3. Add `start my_inventory_resource` to your server configuration file (`server.cfg`).

## Commands
- `/open_inventory`: Opens the inventory menu.
- You can also open the inventory by pressing the **I** key.

## Features
- List of items with icons and quantity.
- Ability to select and "use" an item.
- Inventory is displayed in a simple menu format.
- Set Item Weights and inventory max weight via config file
