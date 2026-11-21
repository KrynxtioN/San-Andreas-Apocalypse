PlayerHeads = {}
local PlayerHeadObject = {}

function givePlayerHead(player, ID)
	local playerHeads = getPlayerData("characters","ID",getCharacterID(player),"heads")
	
	if(not(playerHeads) or playerHeads == 0)then
		dbExec(handler, "UPDATE characters SET heads = '' WHERE ID = '"..getCharacterID(player).."')")
		playerHeads = getPlayerData("characters","ID",getCharacterID(player),"heads")
	end
	
	local values = split(playerHeads, "|")
	local hasHead = false
	
	if(playerHeads and ID)then
		for _, v in pairs(values)do
			if(tonumber(v) == ID)then
				hasHead = true
				break
			end
		end
	end
	
	if(hasHead == false)then
		dbExec(handler, "UPDATE characters SET heads = '"..playerHeads..ID.."|' WHERE ID = '"..getCharacterID(player).."'")
		table.insert(PlayerHeads[player], {head = ID, amount = 1})
		updateClientHeads(player)
	end
end

function loadPlayerHeads(player)
    local headString = getPlayerData("characters", "ID", getCharacterID(player), "heads")
    if(headString)then
        PlayerHeads[player] = {}
		if(#headString >= 1)then
			local headPairs = split(headString, "|")
			for _, v in ipairs(headPairs)do
				local headInfo = split(v, "|")
				local headID = tonumber(headInfo[1])
				table.insert(PlayerHeads[player], {head = headID, amount = 1})
			end
		end
    end
	updateClientHeads(player)
end

function updateClientHeads(player)
	triggerClientEvent(player,"updateClientHeads", player, PlayerHeads[player])
end

addEvent("onPlayerHeadDoubleClicked",true)
addEventHandler("onPlayerHeadDoubleClicked",root,function(id)
	local id = tonumber(id)
	if(id == 1)then
		if(isElement(PlayerHeadObject[client]))then destroyElement(PlayerHeadObject[client])end
		PlayerHeadObject[client] = createObject(1935,0,0,0)
		exports.bone_attach:attachElementToBone(PlayerHeadObject[client],client,2,0,0,0.2,0,0,195)
		setElementCollisionsEnabled(PlayerHeadObject[client],false)
		setObjectScale(PlayerHeadObject[client],0.75)
	elseif(id == 2)then
		if(isElement(PlayerHeadObject[client]))then destroyElement(PlayerHeadObject[client])end
		PlayerHeadObject[client] = createObject(1879,0,0,0)
		exports.bone_attach:attachElementToBone(PlayerHeadObject[client],client,2,0.02,0,0.15,0,0,195)
		setElementCollisionsEnabled(PlayerHeadObject[client],false)
		setObjectScale(PlayerHeadObject[client],0.75)
	end
end)

addEvent("removePlayerHead",true)
addEventHandler("removePlayerHead",root,function()
	if(isElement(PlayerHeadObject[client]))then
		destroyElement(PlayerHeadObject[client])
	end
end)

addEventHandler("onPlayerWasted",root,function()
	if(isElement(PlayerHeadObject[source]))then
		destroyElement(PlayerHeadObject[source])
	end
end)