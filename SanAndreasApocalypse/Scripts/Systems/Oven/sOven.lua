Oven = {
	["SmeltDuration"] = {
		["Iron"] = 5/60,
		["Gold"] = 10/60,
	},
	["ItemID"] = {
		["Iron"] = 114,
		["Gold"] = 115,
	},
}

function getSecTime(offset)
	local rt = getRealTime()
	return math.floor(rt.timestamp + (offset or 0) * 3600)
end

addEvent("Oven.open", true)
addEventHandler("Oven.open", root, function()
	local characterID = getCharacterID(client)
	local tbl = {}
	local currentTime = getSecTime(0)
	local result = dbPoll(dbQuery(handler, "SELECT * FROM oven WHERE character_id = '" .. characterID .. "'"), -1)
	if (#result >= 1) then
		for _, v in pairs(result) do
			local finishTime = tonumber(v["stime"]) or 0
			local remaining = finishTime - currentTime
			if remaining < 0 then remaining = 0 end
			local formattedTime = formatTimeLeft(remaining)
			table.insert(tbl, {v["ID"], v["stime"], v["barstype"], v["amount"], formattedTime})
		end
	end
	triggerClientEvent(client, "Oven.updateClientData", client, tbl, currentTime)
end)

addEvent("Oven.server", true)
addEventHandler("Oven.server", root, function(Type, amount)
	local characterID = getCharacterID(client)
	local result = dbPoll(dbQuery(handler, "SELECT * FROM oven WHERE character_id = '" .. characterID .. "'"), -1)
	if (#result <= 5) then
		local durationPerBarrel = tonumber(Oven["SmeltDuration"][Type])
		local item = tonumber(Oven["ItemID"][Type])
		if(hasPlayerItem(client,item) >= 10)then
			createInfobox(client,getText(client,"SOven1"))
			takeItem(client, item, 10)
			local totalDuration = durationPerBarrel * tonumber(amount)
			dbExec(handler, "INSERT INTO oven (character_id, stime, barstype, amount) VALUES ('" .. characterID .. "', '" .. getSecTime(totalDuration) .. "', '" .. Type .. "', '" .. amount .. "')")
		else
			NPC.MeMessage(client,getText(client,"SOven5"))
		end
	end
end)

addEvent("Oven.finished", true)
addEventHandler("Oven.finished", root, function(ID)
	local ID = tonumber(ID)
	local result = tonumber(getPlayerData("oven", "ID", ID, "stime"))
	local barsType = getPlayerData("oven", "ID", ID, "barstype")
	if (result) then
		if (result ~= 0) then
			if (result <= getSecTime(0)) then
				dbExec(handler, "DELETE FROM oven WHERE ID = '" .. ID .. "'")
				if (barsType == "Iron") then
					NPC.MeMessage(client,getText(client,"SOven3"))
					giveItem(client,129,1)
					triggerClientEvent(client, "showItemBar", client, {{129,1}})
				elseif (barsType == "Gold") then
					NPC.MeMessage(client,getText(client,"SOven4"))
					giveItem(client,130,1)
					triggerClientEvent(client, "showItemBar", client, {{130,1}})
				end
			end
		end
	end
end)

addEvent("Oven.cancel", true)
addEventHandler("Oven.cancel", root, function(ID)
	local ID = tonumber(ID)
	dbExec(handler, "DELETE FROM oven WHERE ID = '" .. ID .. "'")
	createInfobox(client, getText(client,"SOven2"))
end)