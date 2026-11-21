ColonyWarehouse = {
    ["Costs"] = {
        [1] = 25000,
		[2] = 50000,
		[3] = 75000,
		[4] = 125000,
		[5] = 150000,
		[6] = 175000,
		[7] = 225000,
		[8] = 250000,
		[9] = 275000,
		[10] = 325000,
		[11] = 350000,
		[12] = 500000,
    },
    ["Marker"] = {
        {1591.3603515625,739.3515625,10.8203125,1}, 
        {1621.0200195312,739.43225097656,10.8203125,2}, 
		{1648.8345947266,739.35119628906,10.8203125,3},
		{1678.4948730469,739.38659667969,10.8203125,4},
		{1710.1187744141,739.36706542969,10.8203125,5},
		{1739.7778320312,739.41748046875,10.8203125,6},
		{1590.9685058594,701.48791503906,10.827854156494,7},
		{1620.6279296875,701.51110839844,10.8203125,8},
		{1649.6179199219,701.50524902344,10.8203125,9},
		{1679.279296875,701.54223632812,10.8203125,10},
		{1709.7264404297,701.48315429688,10.8203125,11},
		{1739.3894042969,701.51165771484,10.8203125,12},
    },
    ["Capacity"] = {
        [1] = 5000,
		[2] = 7500,
		[3] = 10000,
		[4] = 15000,
		[5] = 17500,
		[6] = 20000,
		[7] = 22500,
		[8] = 25000,
		[9] = 30000,
		[10] = 32500,
		[11] = 35000,
		[12] = 50000,
    },
	["NeededLevel"] = {
        [1] = 10,
		[2] = 15,
		[3] = 20,
		[4] = 25,
		[5] = 30,
		[6] = 35,
		[7] = 40,
		[8] = 45,
		[9] = 50,
		[10] = 55,
		[11] = 60,
		[12] = 65,
	},
}

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

function ColonyWarehouse.hasColonyWarehouse(player)
    if not isElement(player) then return false end

    local colony = apocalypseGetElementData(player, "colony")
    if not colony or tonumber(colony) < 1 then return false end

    local result = dbPoll(dbQuery(handler, "SELECT COUNT(*) as count FROM colony_warehouse WHERE colony = ?", colony), -1)
    if result and result[1] and tonumber(result[1].count) > 0 then
        return true
    end
    return false
end

function ColonyWarehouse.getTotalItemAmount(colony,ID)
    local result = dbPoll(dbQuery(handler, "SELECT items FROM colony_warehouse WHERE warehouse_id = ? AND colony = ? LIMIT 1", ID, colony), -1)
    if result and #result > 0 then
        local storage = result[1]["items"]
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

function ColonyWarehouse.createMarker()
    for _,v in ipairs(ColonyWarehouse["Marker"])do
        local pickup = createPickup(v[1],v[2],v[3],3,1239,50)
        apocalypseSetElementData(pickup,"ColonyWarehouseID",v[4])
        
        addEventHandler("onPickupHit",pickup,function(player)
            if(getElementType(player) == "player")then
                local Colony = tonumber(apocalypseGetElementData(player,"colony"))
                if(Colony >= 1)then
                    local ColonyWarehouseID = apocalypseGetElementData(source,"ColonyWarehouseID")
					 local result = dbPoll(dbQuery(handler,"SELECT * FROM colony_warehouse WHERE colony = '"..Colony.."' AND warehouse_id = '"..ColonyWarehouseID.."'"),-1)
					 if(#result >= 1)then
						triggerClientEvent(player,"ColonyWarehouse.createWindow",player,ColonyWarehouseID)
					else
						createInfobox(player,getText(player,"SColonyWarehouse2"))
					end
				else
					createInfobox(player,getText(player,"SColonyWarehouse1"))
                end
            end
        end)
    end
end
ColonyWarehouse.createMarker()

function ColonyWarehouse.buy(ID)
    if(ID)then
        local ID = tonumber(ID)
        local Colony = apocalypseGetElementData(client,"colony")
        if(Colony >= 1)then
			local colonyLevel = tonumber(getPlayerData("colonys","ID",Colony,"level"))
			if(colonyLevel >= tonumber(ColonyWarehouse["NeededLevel"][ID]))then
				local Price = ColonyWarehouse["Costs"][ID]
				local result = dbPoll(dbQuery(handler,"SELECT * FROM colony_warehouse WHERE colony = '"..Colony.."' AND warehouse_id = '"..ID.."'"),-1)
				if(#result == 0)then
					if(getColonyMoney(Colony) >= Price)then
						Colonys.takeMoney(Colony,Price)
						dbExec(handler,"INSERT INTO colony_warehouse (colony,warehouse_id) VALUES ('"..Colony.."','"..ID.."')")
						createInfobox(client,getText(client,"SColonyWarehouse8"))
						Colonys.getWarehouseData(client)
						outputLog(getPlayerName(client).." (Kolonie: "..Colony..") hat Warenhaus "..ID.." für $"..Price.." gekauft","Kolonie Warenhaus",getCharacterID(client))
					else
						NPC.MeMessage(client,getText(client,"SColonyWarehouse3"))
					end
				else
					NPC.MeMessage(client,getText(client,"SColonyWarehouse7"))
				end
			else
				createInfobox(client,getText(client,"SColonyWarehouse9"):format(ColonyWarehouse["NeededLevel"][ID]))
			end
        end
    end
end
addEvent("ColonyWarehouse.buy",true)
addEventHandler("ColonyWarehouse.buy",root,ColonyWarehouse.buy)

function ColonyWarehouse.getData(player,ID,colonyMenu)
    if(ID)then
        local ID = tonumber(ID)
		local Colony = apocalypseGetElementData(client,"colony")
		if(Colony >= 1)then
			local result = dbPoll(dbQuery(handler, "SELECT items FROM colony_warehouse WHERE colony = ? AND warehouse_id = ? LIMIT 1", Colony, ID), -1)
			if(result and #result > 0)then
				local items = result[1]["items"]
				local itemList = split(items, "|")
				local formattedItems = {}
				local max_amount = ColonyWarehouse["Capacity"][ID]
					
				for _, item in ipairs(itemList) do
					local itemData = split(item, ",")
					local itemID = tonumber(itemData[1])
					local amount = tonumber(itemData[2])
						
					table.insert(formattedItems, {id = itemID, amount = amount})
				end
				
				local players_items = {}
				for _,v in pairs(TradeableItems)do
					if(hasPlayerItem(client,v) >= 1)then
						table.insert(players_items,{v,hasPlayerItem(client,v)})
					end
				end
				
				if(colonyMenu)then
					triggerClientEvent(client,"Colonys.updateWarehouseItems",client,formattedItems,ColonyWarehouse.getTotalItemAmount(Colony,ID),max_amount)
				else
					triggerClientEvent(client,"ColonyWarehouse.updateData",client,formattedItems,ColonyWarehouse.getTotalItemAmount(Colony,ID),players_items,max_amount)
				end
			else
				if(colonyMenu)then
					triggerClientEvent(client,"Colonys.updateWarehouseText",client,ColonyWarehouse["Costs"][ID],ColonyWarehouse["Capacity"][ID],ColonyWarehouse["NeededLevel"][ID])
				end
            end
        end
    end
end
addEvent("ColonyWarehouse.getData",true)
addEventHandler("ColonyWarehouse.getData",root,ColonyWarehouse.getData)

function ColonyWarehouse.storeItem(ID, item, amount)
    if ID and item and amount then
        local id = tonumber(ID)
        local itemID = tonumber(item)
        local amt = tonumber(amount)
        local Colony = apocalypseGetElementData(client, "colony")
        if Colony and Colony >= 1 then
            local result = dbPoll(dbQuery(handler, "SELECT items FROM colony_warehouse WHERE colony = ? AND warehouse_id = ? LIMIT 1", Colony, id), -1)
            if #result >= 1 then
                if hasPlayerItem(client, itemID) >= amt then
                    local Capacity = ColonyWarehouse["Capacity"][id]
                    if (ColonyWarehouse.getTotalItemAmount(Colony,id) + amt) < Capacity then
                        local items = result[1]["items"]
						if items == "" then
							dbExec(handler, "UPDATE colony_warehouse SET items = ? WHERE colony = ? AND warehouse_id = ?", itemID..","..amt, Colony, id)
							takeItem(client, itemID, amt)
							ColonyWarehouse.getData(client, id)
							return
						end

                        local itemList = split(items, "|")
                        local updatedItems = {}
                        local itemFound = false

                        for _, entry in ipairs(itemList) do
                            local itemData = split(entry, ",")
                            local existingItemID = tonumber(itemData[1])
                            local existingAmount = tonumber(itemData[2])

                            if existingItemID == itemID then
                                existingAmount = existingAmount + amt
                                table.insert(updatedItems, existingItemID .. "," .. existingAmount)
                                itemFound = true
                            else
                                table.insert(updatedItems, entry)
                            end
                        end

                        if not itemFound then
                            table.insert(updatedItems, itemID .. "," .. amt)
                        end

                        local newItems = table.concat(updatedItems, "|")
                        dbExec(handler, "UPDATE colony_warehouse SET items = ? WHERE colony = ? AND warehouse_id = ?", newItems, Colony, id)
                        takeItem(client, itemID, amt)
                        ColonyWarehouse.getData(client, id)
						createInfobox(client,getText(client,"SColonyWarehouse4"))
                    end
                end
            end
        end
    end
end
addEvent("ColonyWarehouse.storeItem",true)
addEventHandler("ColonyWarehouse.storeItem",root,ColonyWarehouse.storeItem)

function ColonyWarehouse.removeItem(ID, item, amount)
    if ID and item and amount then
        local id = tonumber(ID)
        local itemID = tonumber(item)
        local amt = tonumber(amount)
        local Colony = apocalypseGetElementData(client, "colony")

        if Colony and Colony >= 1 then
            local result = dbPoll(dbQuery(handler, "SELECT items FROM colony_warehouse WHERE colony = ? AND warehouse_id = ? LIMIT 1", Colony, id), -1)
            if result and #result >= 1 then
                local items = result[1]["items"]
                if items == "" then return end

                local itemList = split(items, "|")
                local updatedItems = {}
                local itemFound = false

                for _, entry in ipairs(itemList) do
                    local itemData = split(entry, ",")
                    local storedID = tonumber(itemData[1])
                    local storedAmount = tonumber(itemData[2])

                    if storedID == itemID then
                        if storedAmount >= amt then
                            storedAmount = storedAmount - amt
                            itemFound = true

                            if storedAmount > 0 then
                                table.insert(updatedItems, storedID .. "," .. storedAmount)
                            end
                        else
							NPC.MeMessage(client,getText(client,"SColonyWarehouse6"))
                            return
                        end
                    else
                        table.insert(updatedItems, entry)
                    end
                end

                if itemFound then
                    local newItems = table.concat(updatedItems, "|")
                    dbExec(handler, "UPDATE colony_warehouse SET items = ? WHERE colony = ? AND warehouse_id = ?", newItems, Colony, id)
                    giveItem(client, itemID, amt)
                    ColonyWarehouse.getData(client, id)
					createInfobox(client,getText(client,"SColonyWarehouse5"))
                end
            end
        end
    end
end
addEvent("ColonyWarehouse.removeItem", true)
addEventHandler("ColonyWarehouse.removeItem", root, ColonyWarehouse.removeItem)