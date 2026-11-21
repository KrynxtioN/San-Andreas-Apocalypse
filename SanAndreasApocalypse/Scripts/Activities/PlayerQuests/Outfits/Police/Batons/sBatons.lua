PoliceBatons = {
	["Positions"] = {
		{725.88897705078,-438.71148681641,16.3359375,0,0},
		{795.89324951172,-498.12435913086,18.013332366943,0,0},
		{860.77795410156,-604.76574707031,18.421875,0,0},
		{799.41430664062,-620.72369384766,16.3359375,0,0},
		{706.19268798828,-642.78295898438,16.3359375,0,0},
		{617.42620849609,-611.89141845703,17.2265625,0,0},
		{624.49609375,-505.17294311523,16.352542877197,0,0},
		{668.00866699219,-556.08477783203,20.646862030029,0,0},
		{753.93072509766,-589.04180908203,17.3359375,0,0},
		{819.13360595703,-562.66442871094,16.3359375,0,0},
	},
}

function givePoliceBaton(ID)
	if(hasPlayerPoliceBaton(client, ID) == false)then
		local playerBatons = getPlayerData("characters", "ID", getCharacterID(client), "police_batons")
		dbExec(handler, "UPDATE characters SET police_batons = '"..playerBatons..ID.."|' WHERE ID = '"..getCharacterID(client).."'")
		giveItem(client,11,1)
		setAchievement(client,43)
		giveEXP(client, 25)
		triggerClientEvent(client,"showItemBar",client,{{11,1}})
		outputLog(getPlayerName(client).." hat einen Schlagstock eingesammelt", "Baton", getCharacterID(client))
	end
end
addEvent("givePoliceBaton",true)
addEventHandler("givePoliceBaton",root,givePoliceBaton)

function hasPlayerPoliceBaton(player, ID)
	local playerBatons = getPlayerData("characters", "ID", getCharacterID(player), "police_batons")
	
	if(not(playerBatons))then
		dbExec(handler, "UPDATE characters SET police_batons = '' WHERE ID = '"..getCharacterID(player).."'")
		playerBatons = getPlayerData("characters", "ID", getCharacterID(player), "police_batons")
	end
	
	local values = split(playerBatons, "|")
	local hasBaton = false

	if(playerBatons and ID) then
		ID = tonumber(ID)
		for _, v in pairs(values) do
			local documentID = tonumber(v)
			if(documentID == ID) then
				hasBaton = true
				break
			end
		end
	end
	return hasBaton
end

function PoliceBatons.createPickup(player)
	for i,v in pairs(PoliceBatons["Positions"])do
		if(hasPlayerPoliceBaton(player,i) == false)then
			triggerClientEvent(player,"PoliceBatons.createPickup",player,i,v[1],v[2],v[3],v[4],v[5])
		end
	end
end