PlayerFurniture = {}

function hasPlayerFurniture(player, furnitureID)
	if not PlayerFurniture[player] then return 0 end
	for _, v in ipairs(PlayerFurniture[player]) do
		if v.id == furnitureID then
			return v.amount
		end
	end
	return 0
end

function giveFurniture(player, furnitureID, amount)
	if not PlayerFurniture[player] then PlayerFurniture[player] = {} end
	local found = false
	for _, v in ipairs(PlayerFurniture[player]) do
		if v.id == furnitureID then
			v.amount = v.amount + amount
			found = true
			break
		end
	end
	if not found then
		table.insert(PlayerFurniture[player], {id=furnitureID, amount=amount})
	end
	savePlayerFurniture(player)
	updateClientFurniture(player)
end
addEvent("giveFurniture", true)
addEventHandler("giveFurniture", root, giveFurniture)

function takeFurniture(player, furnitureID, amount)
	if not PlayerFurniture[player] then return end
	for i,v in ipairs(PlayerFurniture[player]) do
		if v.id == furnitureID then
			v.amount = v.amount - amount
			if v.amount <= 0 then
				table.remove(PlayerFurniture[player], i)
			end
			break
		end
	end
	savePlayerFurniture(player)
	updateClientFurniture(player)
end

function loadPlayerFurniture(player)
	local itemString = getPlayerData("characters","ID",getCharacterID(player),"furniture")
	PlayerFurniture[player] = {}
	if itemString and #itemString >= 1 then
		local items = split(itemString,"|")
		for _,v in ipairs(items) do
			local data = split(v,",")
			local id = tonumber(data[1])
			local amount = tonumber(data[2])
			table.insert(PlayerFurniture[player], {id=id, amount=amount})
		end
	end
	updateClientFurniture(player)
end

function savePlayerFurniture(player)
	if not isCharacterLoggedIn(player) then return end
	local str = ""
	for _,v in ipairs(PlayerFurniture[player]) do
		str = str..v.id..","..v.amount.."|"
	end
	str = str:sub(1,-2)
	dbExec(handler, "UPDATE characters SET furniture=? WHERE ID=?", str, getCharacterID(player))
end

function updateClientFurniture(player)
	triggerClientEvent(player, "updatePlayerFurniture", player, PlayerFurniture[player])
end

addEvent("useFurnitureItem", true)
addEventHandler("useFurnitureItem", root, function(furnitureID)
	local amount = hasPlayerFurniture(client, furnitureID)
	if amount >= 1 then
		takeFurniture(client, furnitureID, 1)
		triggerClientEvent(client, "FurnitureSystem.placeObject", client, furnitureID)
	else
		outputChatBox("You don't have this furniture!", client, 255,0,0)
	end
end)

addEvent("Moebel.buy",true)
addEventHandler("Moebel.buy",root,function(model,price)
	local model,price = tonumber(model),tonumber(price)
	if(tonumber(apocalypseGetElementData(client,"money")) >= price)then
		apocalypseSetElementData(client,"money",tonumber(apocalypseGetElementData(client,"money"))-price)
		giveFurniture(client,model,1)
		createInfobox(client,getText(client,"SFurniture1"))
	else
		createInfobox(client,getText(client,"SFurniture2"))
	end
end)