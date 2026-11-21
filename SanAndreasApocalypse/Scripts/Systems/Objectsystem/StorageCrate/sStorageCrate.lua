StorageCrate = {}

local function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

function StorageCrate.getItemsFromChest(chestID)
    local result = dbPoll(dbQuery(handler, "SELECT storage FROM objects WHERE ID = '"..chestID.."' LIMIT 1"), -1)
    if(result and #result > 0)then
        local items = result[1]["storage"]
        local itemList = split(items, "|")
        local formattedItems = {}
        
        for _, item in ipairs(itemList) do
            local itemData = split(item, ",")
            local itemID = tonumber(itemData[1])
            local amount = tonumber(itemData[2])
            
            table.insert(formattedItems, {id = itemID, amount = amount})
        end
        return formattedItems
    end
end

function StorageCrate.getTotalItemAmount(chestID)
    local result = dbPoll(dbQuery(handler, "SELECT storage FROM objects WHERE ID = ? LIMIT 1", chestID), -1)
    if result and #result > 0 then
        local storage = result[1]["storage"]
        if storage == "" then return 0 end

        local itemList = split(storage, "|")
        local totalAmount = 0

        for _, item in ipairs(itemList) do
            local itemData = split(item, ",")
            local amount = tonumber(itemData[2]) or 0
            totalAmount = totalAmount + amount
        end

        return totalAmount
    end
    return 0
end

function StorageCrate.addItemToChest(itemID, amount)
	local chestID = apocalypseGetElementData(client,"StorageCrate_ActiveID")
	local itemID, amount = tonumber(itemID),tonumber(amount)
	if(hasPlayerItem(client,itemID) >= amount)then
		if((StorageCrate.getTotalItemAmount(chestID) + amount) < 500)then
			local result = dbPoll(dbQuery(handler, "SELECT storage FROM objects WHERE ID = '"..chestID.."' LIMIT 1"), -1)

			if result and #result > 0 then
				local items = result[1]["storage"]
				if items == "" then
					dbExec(handler, "UPDATE storage SET objects = '"..itemID..","..amount.."' WHERE ID = '"..chestID.."'")
					return
				end

				local itemList = split(items, "|")
				local updatedItems = {}
				local itemFound = false

				for _, item in ipairs(itemList) do
					local itemData = split(item, ",")
					local existingItemID = tonumber(itemData[1])
					local existingAmount = tonumber(itemData[2])

					if existingItemID == tonumber(itemID) then
						existingAmount = existingAmount + amount
						table.insert(updatedItems, existingItemID .. "," .. existingAmount)
						itemFound = true
					else
						table.insert(updatedItems, item)
					end
				end

				if not itemFound then
					table.insert(updatedItems, itemID .. "," .. amount)
				end

				local newItems = table.concat(updatedItems, "|")
				dbExec(handler, "UPDATE objects SET storage = '"..newItems.."' WHERE ID = '"..chestID.."'")
				takeItem(client,itemID,amount)
				createInfobox(client,getText(client,"SStorageCrate1"))
				
				local players_items = {}
				for _,v in pairs(TradeableItems)do
					if(hasPlayerItem(client,v) >= 1)then
						table.insert(players_items,{v,hasPlayerItem(client,v)})
					end
				end
				
				triggerClientEvent(client,"StorageCrate.updateShop",client,StorageCrate.getItemsFromChest(chestID),StorageCrate.getTotalItemAmount(chestID),players_items)
			end
		else
			createInfobox(client,getText(client,"SStorageCrate5"))
		end
	else
		createInfobox(client,getText(client,"SStorageCrate3"))
	end
end
addEvent("StorageCrate.addItemToChest",true)
addEventHandler("StorageCrate.addItemToChest",root,StorageCrate.addItemToChest)

function StorageCrate.removeItemFromChest(itemID, amount)
    local chestID = apocalypseGetElementData(client, "StorageCrate_ActiveID")
    itemID, amount = tonumber(itemID), tonumber(amount)
    if not itemID or not amount then return end

    local result = dbPoll(dbQuery(handler, "SELECT storage FROM objects WHERE ID = ? LIMIT 1", chestID), -1)
    if result and #result > 0 then
        local items = result[1]["storage"]
        if items == "" then return end

        local itemList = split(items, "|")
        local newItems = {}
        local itemFound = false
        local enoughAmount = false

        for _, item in ipairs(itemList) do
            local itemData = split(item, ",")
            local existingItemID = tonumber(itemData[1])
            local existingAmount = tonumber(itemData[2])

            if existingItemID == itemID then
                itemFound = true
                if existingAmount >= amount then
                    enoughAmount = true
                    local newAmount = existingAmount - amount
                    if newAmount > 0 then
                        table.insert(newItems, existingItemID .. "," .. newAmount)
                    end
                else
                    createInfobox(client, getText(client, "SStorageCrate4"))
                    return
                end
            else
                table.insert(newItems, item)
            end
        end

        if not itemFound then
            createInfobox(client, getText(client, "SStorageCrate4"))
            return
        end

        if enoughAmount then
            local updatedItems = table.concat(newItems, "|")
            dbExec(handler, "UPDATE objects SET storage = ? WHERE ID = ?", updatedItems, chestID)
            giveItem(client, itemID, amount)
            createInfobox(client, getText(client, "SStorageCrate2"))
			
			local players_items = {}
			for _,v in pairs(TradeableItems)do
				if(hasPlayerItem(client,v) >= 1)then
					table.insert(players_items,{v,hasPlayerItem(client,v)})
				end
			end
			
            triggerClientEvent(client, "StorageCrate.updateShop", client, StorageCrate.getItemsFromChest(chestID),StorageCrate.getTotalItemAmount(chestID),players_items)
        end
    end
end
addEvent("StorageCrate.removeItemFromChest", true)
addEventHandler("StorageCrate.removeItemFromChest", root, StorageCrate.removeItemFromChest)