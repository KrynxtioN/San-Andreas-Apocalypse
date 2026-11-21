PlayerKeys = {}

function hasPlayerKey(player, keyID)
	local amount = 0
	if(#PlayerKeys[player] >= 1)then
		for i, v in ipairs(PlayerKeys[player]) do
			if(v.key == keyID)then
				amount = amount + 1
			end
		end
	end
	return amount
end

function getPlayerKeys(player, keyID)
	local amount = 0
	if(#PlayerKeys[player] >= 1)then
		for i, v in ipairs(PlayerKeys[player]) do
			if(v.key == keyID)then
				amount = v.amount
			end
		end
	end
	return amount
end

function giveKey(player, keyID, amount)
    if(not(PlayerKeys[player]))then PlayerKeys[player] = {} end
    local found = false
	if(not(amount))then amount = 1 end
    
    for _,v in ipairs(PlayerKeys[player])do
        if(v.key == keyID)then
            v.amount = v.amount + amount
            found = true
        end
    end

    if(found == false)then
        table.insert(PlayerKeys[player], {key = keyID, amount = amount})
    end
    savePlayerKeys(player)
	updateClientKeys(player)
	
	setAchievement(player, 36)
	outputLog(getPlayerName(player).." hat einen Schlüssel bekommen (ID: "..keyID..", Anzahl: "..amount..")", "Keys", getCharacterID(player))
end

function takeKey(player, keyID, amount)
    for i, v in ipairs(PlayerKeys[player]) do
        local storedkeyID = tonumber(v.key)
        local requestedkeyID = tonumber(keyID)
        
        if(storedkeyID == requestedkeyID)then
            v.amount = v.amount - amount

            if(v.amount <= 0)then
                table.remove(PlayerKeys[player], i)
            end
            break
        end
    end
    savePlayerKeys(player)
    updateClientKeys(player)
end

function loadPlayerKeys(player)
    local keyString = getPlayerData("characters", "ID", getCharacterID(player), "playerkeys")
    if(keyString)then
        PlayerKeys[player] = {}
		if(#keyString >= 1)then
			local keyPairs = split(keyString, "|")
			for _, v in ipairs(keyPairs)do
				local keyInfo = split(v, ",")
				local keyID = tonumber(keyInfo[1])
				local amount = tonumber(keyInfo[2])
				table.insert(PlayerKeys[player], {key = keyID, amount = amount})
			end
		end
    end
	updateClientKeys(player)
end

function savePlayerKeys(player)
    if(isCharacterLoggedIn(player))then
        local keys = ""
        for _, v in ipairs(PlayerKeys[player])do
            keys = keys .. v.key .. "," .. v.amount .. "|"
        end
        keys = keys:sub(1, -2)
        dbExec(handler, "UPDATE characters SET playerkeys = '" .. keys .. "' WHERE ID = '" .. getCharacterID(player) .. "'")
    end
end

function updateClientKeys(player)
	triggerClientEvent(player,"updatePlayerKeys", player, PlayerKeys[player])
end

addEventHandler("onPlayerQuit",root,function()
	savePlayerKeys(source)
	PlayerKeys[source] = nil
end)