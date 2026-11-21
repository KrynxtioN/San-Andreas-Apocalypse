Market = {
	["Open"] = { -- x, y, z, Market ID
		{-1964.5678710938,97.696907043457,27.6875,1},
		{-1964.5666503906,93.612892150879,27.6875,2},
		{-1964.5667724609,89.666381835938,27.6875,3},
		{-1964.5667724609,85.71208190918,27.6875,4},
		{-1966.3170166016,82.55339050293,27.6875,5},
		{-1970.3432617188,82.554244995117,27.6875,6},
		{-1974.4333496094,82.55248260498,27.6875,7},
		{-1978.4177246094,82.552169799805,27.6875,8},
		{364.46908569336,-2029.4532470703,7.8359375,9},
		{364.46923828125,-2033.5250244141,7.8359375,10},
		{-2069.708984375,-2441.7595214844,30.625,11},
		{-2066.8781738281,-2444.0234375,30.625,12},
		{2317.1870117188,66.130744934082,26.483436584473,13},
		{652.06469726562,-462.52459716797,16.343704223633,14},
		{652.06475830078,-458.43966674805,16.343704223633,15},
		{652.06488037109,-454.48922729492,16.343704223633,16},
		{652.06719970703,-450.48364257812,16.343704223633,17},
		{652.06622314453,-446.55465698242,16.3359375,18},
		{213.54800415039,-268.26931762695,1.578125,19},
		{212.33311462402,-254.87312316895,1.578125,20},
		{-2227.3359375,2376.2358398438,4.984375,21},
		{431.46914672852,2536.1975097656,16.32105255127,22},
		{-2465.3293457031,-111.9641418457,25.817535400391,23},
		{-270.01760864258,-2183.8654785156,28.850036621094,24},
		{930.02496337891,-1073.5834960938,24.2890625,25},
		{930.02404785156,-1077.5837402344,24.2890625,26},
		{2317.9875488281,23.712301254272,26.476568222046,27},
		{1623.490234375,692.20434570312,10.8203125,28},
		{1623.4907226562,696.25524902344,10.8203125,29},
		{1681.3397216797,742.17327880859,10.8203125,30},
		{1681.3400878906,746.12994384766,10.8203125,31},
	},
}

Market.settingsMarker = {
	{-1981.7423095703,81.89616394043,27.6875},
	{652.22320556641,-465.7419128418,16.3359375},
}

for _,v in pairs(Market.settingsMarker)do
	local Pickup = createPickup(v[1],v[2],v[3],3,1239,50)
	
	addEventHandler("onPickupHit",Pickup,function(player)
		if(getElementType(player) == "player")then
			if(getElementDimension(player) == getElementDimension(source))then
				local result = dbPoll(dbQuery(handler,"SELECT * FROM market WHERE seller_character_id = '"..getCharacterID(player).."'"),-1)
				if(#result == 0)then
				
				else
					triggerClientEvent(player,"Market.settings",player)
				end
			end
		end
	end)
end

for _,v in pairs(Market["Open"])do
	local Pickup = createPickup(v[1],v[2],v[3],3,1239,50)
	apocalypseSetElementData(Pickup,"MarketID",v[4])
	
	addEventHandler("onPickupHit",Pickup,function(player)
		if(not(isPedInVehicle(player)))then
			if(getElementDimension(player) == getElementDimension(source))then
				local ID = apocalypseGetElementData(source,"MarketID")
				if(tonumber(getPlayerData("market","ID",ID,"status")) == 1)then
					local items = Market.getItemsFromMarket(ID)
					local ownerID = tonumber(getPlayerData("market","ID",ID,"seller_character_id"))
					local owner = getPlayerData("characters","ID",ownerID,"name")
					triggerClientEvent(player,"Market.createShopWindow",player,items,owner)
				else
					triggerClientEvent(player,"Market.createWindow",player)
				end
				apocalypseSetElementData(player,"MarketID",ID)
			end
		end
	end)
end

function Market.createPlayerPeds(player)
    local result = dbPoll(dbQuery(handler, "SELECT * FROM market WHERE status = '1'"), -1)
    if(#result >= 1)then
        local tbl = {}
        for _, v in pairs(result) do
            table.insert(tbl, v["ID"])
        end
        triggerClientEvent(player, "Market.createPlayerPeds", player, tbl)
    end
end

local function split(str, sep)
    local result = {}
    for match in (str..sep):gmatch("(.-)"..sep) do
        table.insert(result, match)
    end
    return result
end

function Market.createMarket(player)
	if(not(player))then player = client end
	local MarketID = tonumber(apocalypseGetElementData(player,"MarketID"))
	if(MarketID)then
		local marketResult = dbPoll(dbQuery(handler,"SELECT * FROM market WHERE ID = '"..MarketID.."' AND status = '0'"),-1)
		if(#marketResult >= 1)then
			local character_id = getCharacterID(player)
			local result = dbPoll(dbQuery(handler,"SELECT * FROM market WHERE seller_character_id = '"..character_id.."'"),-1)
			if(#result == 0)then
				if(tonumber(apocalypseGetElementData(player,"money")) >= 5000)then
					triggerClientEvent(player,"closeWindow",player)
					dbExec(handler,"UPDATE market SET seller_character_id = '"..character_id.."', status = '1' WHERE ID = '"..MarketID.."'")
					createInfobox(player,getText(player,"SMarket5"))
					
					for _,v in pairs(getElementsByType("player"))do
						if(isCharacterLoggedIn(v))then
							Market.createPlayerPeds(v)
						end
					end
					apocalypseSetElementData(player,"money",apocalypseGetElementData(player,"money")-5000)
				else
					NPC.MeMessage(player,getText(player,"SMarket1"))
				end
			else
				NPC.MeMessage(player,getText(player,"SMarket4"))
			end
		end
	end
end
addEvent("Market.createMarket",true)
addEventHandler("Market.createMarket",root,Market.createMarket)

function Market.addItemToMarket(MarketID, itemID, amount, price)
    local result = dbPoll(dbQuery(handler, "SELECT items FROM market WHERE ID = '"..MarketID.."' LIMIT 1"), -1)
    if not price then price = 0 end

    if result and #result > 0 then
        local items = result[1]["items"]
        if items == "" then
            dbExec(handler, "UPDATE market SET items = '"..itemID..","..amount..","..price.."' WHERE ID = '"..MarketID.."'")
            return
        end

        local itemList = split(items, "|")
        local updatedItems = {}
        local itemFound = false

        for _, item in ipairs(itemList) do
            local itemData = split(item, ",")
            local existingItemID = tonumber(itemData[1])
            local existingAmount = tonumber(itemData[2])
            local existingPrice = tonumber(itemData[3])

            if existingItemID == tonumber(itemID) then
                existingAmount = existingAmount + amount
                table.insert(updatedItems, existingItemID .. "," .. existingAmount .. "," .. price)
                itemFound = true
            else
                table.insert(updatedItems, item)
            end
        end

        if not itemFound then
            table.insert(updatedItems, itemID .. "," .. amount .. "," .. price)
        end

        local newItems = table.concat(updatedItems, "|")
        dbExec(handler, "UPDATE market SET items = '"..newItems.."' WHERE ID = '"..MarketID.."'")
    end
end

function Market.removeItemFromMarket(MarketID, itemID, amount)
    local result = dbPoll(dbQuery(handler, "SELECT items FROM market WHERE ID = '"..MarketID.."' LIMIT 1"), -1)
    if(result and #result > 0)then
        local items = result[1]["items"]
        if items == "" then return end

        local itemList = split(items, "|")
        local newItems = {}

        for _, item in ipairs(itemList) do
            local itemData = split(item, ",")
            local existingItemID = tonumber(itemData[1])
            local existingAmount = tonumber(itemData[2])
            local price = tonumber(itemData[3])

            if existingItemID == tonumber(itemID) then
                if amount and tonumber(amount) < existingAmount then
                    local newAmount = existingAmount - tonumber(amount)
                    table.insert(newItems, existingItemID .. "," .. newAmount .. "," .. price)
                end
            else
                table.insert(newItems, item)
            end
        end

        local updatedItems = table.concat(newItems, "|")
        dbExec(handler, "UPDATE market SET items = '"..updatedItems.."' WHERE ID = '"..MarketID.."'")
    end
end

function Market.getItemsFromMarket(MarketID)
    local result = dbPoll(dbQuery(handler, "SELECT items FROM market WHERE ID = '"..MarketID.."' LIMIT 1"), -1)
    if(result and #result > 0)then
        local items = result[1]["items"]
        local itemList = split(items, "|")
        local formattedItems = {}
        
        for _, item in ipairs(itemList) do
            local itemData = split(item, ",")
            local itemID = tonumber(itemData[1])
            local amount = tonumber(itemData[2])
            local price = tonumber(itemData[3])
            
            table.insert(formattedItems, {id = itemID, amount = amount, price = price})
        end
        return formattedItems
    end
end

addEvent("Market.buyItem", true)
addEventHandler("Market.buyItem", root, function(itemID, amountToBuy)
	local marketID = tonumber(apocalypseGetElementData(client, "MarketID"))
	local amountToBuy = tonumber(amountToBuy)
	itemID = tonumber(itemID)

	local marketItems = Market.getItemsFromMarket(marketID)
	for _, v in ipairs(marketItems) do
		if v.id == itemID then
			local amountToBuy = tonumber(amountToBuy)
			if v.amount >= amountToBuy then
				local priceTotal = v.price * amountToBuy
				local money = tonumber(apocalypseGetElementData(client, "money")) or 0

				if money >= priceTotal then
					apocalypseSetElementData(client, "money", money - priceTotal)
					Market.removeItemFromMarket(marketID, itemID, amountToBuy)
					NPC.MeMessage(client,getText(client,"SMarket3"))
					triggerClientEvent(client,"Market.updateShop",client,Market.getItemsFromMarket(marketID))
					local marketplaceOwnerID = getPlayerData("market","ID",marketID,"seller_character_id")
					local marketplaceMoney = getPlayerData("character_stats","character_id",marketplaceOwnerID,"marketplace_money")
					local playerPrice = priceTotal/100*90
					dbExec(handler,"UPDATE character_stats SET marketplace_money = '"..tonumber(marketplaceMoney) + playerPrice.."' WHERE character_id = '"..marketplaceOwnerID.."'")
				else
					NPC.MeMessage(client,getText(client,"SMarket1"))
				end
			else
				NPC.MeMessage(client,getText(client,"SMarket2"))
			end
			break
		end
	end
end)

function Market.getMarketData(player)
	if(not(player))then player = client end
	local marketID = tonumber(getPlayerData("market","seller_character_id",getCharacterID(player),"ID"))
	local marketplaceMoney = tonumber(getPlayerData("character_stats","character_id",getCharacterID(player),"marketplace_money"))
	if(marketID)then
		local playerItems = {}
		for _,v in pairs(TradeableItems)do
			if(hasPlayerItem(player,v) >= 1)then
				table.insert(playerItems,{v,hasPlayerItem(player,v)})
			end
		end
		local marketItems = Market.getItemsFromMarket(marketID)
		triggerClientEvent(player,"Market.updateMarketSettings",player,marketItems,playerItems,marketplaceMoney)
	end
end
addEvent("Market.getMarketData",true)
addEventHandler("Market.getMarketData",root,Market.getMarketData)

addEvent("Market.addItemToMarket",true)
addEventHandler("Market.addItemToMarket",root,function(itemID,amount)
	local itemID, amount = tonumber(itemID), tonumber(amount)
	local marketID = tonumber(getPlayerData("market","seller_character_id",getCharacterID(client),"ID"))
	if(hasPlayerItem(client,itemID) >= amount)then
		Market.addItemToMarket(marketID,itemID,amount)
		takeItem(client,itemID,amount)
		Market.getMarketData(client)
	end
end)

addEvent("Market.removeItemToMarket",true)
addEventHandler("Market.removeItemToMarket",root,function(itemID,amount)
	local itemID, amount = tonumber(itemID), tonumber(amount)
	local marketID = tonumber(getPlayerData("market","seller_character_id",getCharacterID(client),"ID"))
	Market.removeItemFromMarket(marketID,itemID,amount)
	giveItem(client,itemID,amount)
	Market.getMarketData(client)
end)

addEvent("Market.takeMoney",true)
addEventHandler("Market.takeMoney",root,function(amount)
	local amount = tonumber(amount)
	local marketplaceMoney = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"marketplace_money"))
	if(marketplaceMoney >= amount)then
		givePlayerServerMoney(client,amount)
		dbExec(handler,"UPDATE character_stats SET marketplace_money = '"..marketplaceMoney - amount.."' WHERE character_id = '"..getCharacterID(client).."'")
		Market.getMarketData(client)
	end
end)

addEvent("Market.changePrice",true)
addEventHandler("Market.changePrice",root,function(itemID,price)
	local itemID,price = tonumber(itemID),tonumber(price)
	local marketID = tonumber(getPlayerData("market","seller_character_id",getCharacterID(client),"ID"))
    local result = dbPoll(dbQuery(handler, "SELECT items FROM market WHERE ID = '"..marketID.."' LIMIT 1"), -1)
    if result and #result > 0 then
        local items = result[1]["items"]
        if items == "" then return end

        local itemList = split(items, "|")
        local updatedItems = {}

        for _, item in ipairs(itemList) do
            local itemData = split(item, ",")
            local existingItemID = tonumber(itemData[1])
            local existingAmount = tonumber(itemData[2])
            local existingPrice = tonumber(itemData[3])

            if existingItemID == tonumber(itemID) then
                table.insert(updatedItems, existingItemID .. "," .. existingAmount .. "," .. price)
            else
                table.insert(updatedItems, item)
            end
        end

        local newItems = table.concat(updatedItems, "|")
        dbExec(handler, "UPDATE market SET items = '"..newItems.."' WHERE ID = '"..marketID.."'")
		Market.getMarketData(client)
    end
end)