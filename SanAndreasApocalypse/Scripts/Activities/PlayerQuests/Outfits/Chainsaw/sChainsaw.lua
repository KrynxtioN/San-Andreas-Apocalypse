CollectibleChainsaw = {
	["Positions"] = {
		{-2183.5766601562,-2422.8405761719,36.132373809814,0,0},
		{-2457.5778808594,-2471.3244628906,39.513626098633,0,0},
		{-1828.5294189453,-2641.0893554688,55.253841400146,0,0},
		{-2058.9936523438,-2260.2416992188,31.889770507812,0,0},
		{-2520.3076171875,-2144.8952636719,39.041439056396,0,0},
		{-2624.701171875,-2198.9763183594,20.011474609375,0,0},
		{-2232.6762695312,-2570.8603515625,31.921875,0,0},
		{-2129.6691894531,-2412.9675292969,30.625,0,0},
		{-2067.1154785156,-2562.7150878906,33.594120025635,0,0},
		{-1564.7846679688,-2731.7487792969,51.496891021729,0,0},
	},
}

function CollectibleChainsaw.load(player)
	if(getQuest(player,26) ~= false and tonumber(getQuest(player,26)) >= 2)then
		triggerClientEvent(player,"ChainsawPickup",player)
	end
end

function giveCollectibleChainsaw(ID)
	if(hasPlayerCollectibleChainsaw(client, ID) == false)then
		local playerChainsaws = getPlayerData("characters", "ID", getCharacterID(client), "collectible_chainsaw")
		dbExec(handler, "UPDATE characters SET collectible_chainsaw = '"..playerChainsaws..ID.."|' WHERE ID = '"..getCharacterID(client).."'")
		giveItem(client,132,1)
		giveEXP(client, 100)
		triggerClientEvent(client,"showItemBar",client,{{132,1}})
		setAchievement(client,236)
		outputLog(getPlayerName(client).." hat eine Kettensäge eingesammelt", "Rusty Chainsaw", getCharacterID(client))
	end
end
addEvent("giveCollectibleChainsaw",true)
addEventHandler("giveCollectibleChainsaw",root,giveCollectibleChainsaw)

function hasPlayerCollectibleChainsaw(player, ID)
	local playerChainsaws = getPlayerData("characters", "ID", getCharacterID(player), "collectible_chainsaw")
	
	if(not(playerChainsaws))then
		dbExec(handler, "UPDATE characters SET collectible_chainsaw = '' WHERE ID = '"..getCharacterID(player).."'")
		playerChainsaws = getPlayerData("characters", "ID", getCharacterID(player), "collectible_chainsaw")
	end
	
	local values = split(playerChainsaws, "|")
	local hasChainsaw = false

	if(playerChainsaws and ID) then
		ID = tonumber(ID)
		for _, v in pairs(values) do
			local documentID = tonumber(v)
			if(documentID == ID) then
				hasChainsaw = true
				break
			end
		end
	end
	return hasChainsaw
end

function CollectibleChainsaw.createPickup(player)
	for i,v in pairs(CollectibleChainsaw["Positions"])do
		if(hasPlayerCollectibleChainsaw(player,i) == false)then
			triggerClientEvent(player,"CollectibleChainsaw.createPickup",player,i,v[1],v[2],v[3],v[4],v[5])
		end
	end
end

addEvent("addChainsaw",true)
addEventHandler("addChainsaw",root,function()
	PlayerWeapons.addNewWeapon(client,9,1)
end)