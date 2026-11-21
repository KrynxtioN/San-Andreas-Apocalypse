function addPlayerBlip(player, ID)
	local playerBlips = getPlayerData("characters","ID",getCharacterID(player),"blips")
	
	if(not(playerBlips))then
		dbExec(handler, "UPDATE characters SET blips = '' WHERE ID = '"..getCharacterID(player).."'")
		playerBlips = getPlayerData("characters", "ID", getCharacterID(player), "blips")
	end
	
	local values = split(playerBlips, "|")
	local hasBlip = false
	
	if(playerBlips and ID)then
		for _,v in pairs(values)do
			if(tonumber(v) == ID)then
				hasBlip = true
				break
			end
		end
	end
	
	if(hasBlip == false)then
		dbExec(handler, "UPDATE characters SET blips = '"..playerBlips..ID.."|' WHERE ID = '"..getCharacterID(player).."'")
		triggerClientEvent(player,"addPlayerBlip",player,ID)
		triggerClientEvent(player,"updateBlipStatus",player)
	end
end

function hasPlayerBlip(player, ID)
	local playerBlips = getPlayerData("characters","ID",getCharacterID(player),"blips")
	
	if(not(playerBlips))then
		dbExec(handler, "UPDATE characters SET blips = '' WHERE ID = '"..getCharacterID(player).."'")
		playerBlips = getPlayerData("characters", "ID", getCharacterID(player), "blips")
	end
	
	local values = split(playerBlips, "|")
	local hasBlip = false
	
	if(playerBlips and ID)then
		for _,v in pairs(values)do
			if(tonumber(v) == ID)then
				hasBlip = true
				break
			end
		end
	end
	return hasBlip
end

function loadPlayerBlips(player)
	local playerBlips = getPlayerData("characters","ID",getCharacterID(player),"blips")
	
	if(not(playerBlips))then
		dbExec(handler, "UPDATE characters SET blips = '' WHERE ID = '"..getCharacterID(player).."'")
		playerBlips = getPlayerData("characters", "ID", getCharacterID(player), "blips")
	end
	
	if(playerBlips)then
		local values = split(playerBlips, "|")
		for i,v in pairs(values)do
			triggerClientEvent(player,"addPlayerBlip",player,v)
		end
	end
	triggerClientEvent(player,"updateBlipStatus",player)
end