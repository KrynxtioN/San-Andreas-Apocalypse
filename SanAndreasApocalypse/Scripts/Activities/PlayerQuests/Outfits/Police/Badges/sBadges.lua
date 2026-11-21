PoliceBadges = {
	["Positions"] = {
		{624.95971679688,-581.205078125,24.118200302124,2,0,0},
		{819.32897949219,-583.77911376953,17.354200363159,2,0,0},
		{875.83697509766,-594.16760253906,16.006200790405,2,0,0},
		{823.2177734375,-484.14828491211,15.285900115967,2,0,0},
		{656.04602050781,-621.22448730469,14.210900306702,2,0,0},
	},
}

function givePoliceBadge(ID)
	if(hasPlayerPoliceBadge(client, ID) == false)then
		local playerBadges = getPlayerData("characters", "ID", getCharacterID(client), "police_badges")
		dbExec(handler, "UPDATE characters SET police_badges = '"..playerBadges..ID.."|' WHERE ID = '"..getCharacterID(client).."'")
		setAchievement(client, 44)
		giveItem(client, 10, 1)
		giveEXP(client, 25)
		triggerClientEvent(client,"showItemBar",client,{{10,1}})
		toggleAllControls(client,false)
		outputLog(getPlayerName(client).." hat eine Polizeimarke eingesammelt", "Police Badge", getCharacterID(client))
		setTimer(function(client)
			setPedAnimation(client,"BOMBER", "BOM_Plant_Loop",-1,true,false,false,true)
		end,250,1,client)
		setTimer(function(client)
			if(isElement(client))then
				setPedAnimation(client)
				setElementFrozen(client,false)
				toggleAllControls(client,true)
			end
		end,3500,1,client)
	end
end
addEvent("givePoliceBadge",true)
addEventHandler("givePoliceBadge",root,givePoliceBadge)

function hasPlayerPoliceBadge(player, ID)
	local playerBadges = getPlayerData("characters", "ID", getCharacterID(player), "police_badges")
	
	if(not(playerBadges))then
		dbExec(handler, "UPDATE characters SET police_badges = '' WHERE ID = '"..getCharacterID(player).."'")
		playerBadges = getPlayerData("characters", "ID", getCharacterID(player), "police_badges")
	end
	
	local values = split(playerBadges, "|")
	local hasBadge = false

	if(playerBadges and ID) then
		ID = tonumber(ID)
		for _, v in pairs(values) do
			local documentID = tonumber(v)
			if(documentID == ID) then
				hasBadge = true
				break
			end
		end
	end
	return hasBadge
end

function PoliceBadges.createMarker(player)
	for i,v in pairs(PoliceBadges["Positions"])do
		if(hasPlayerPoliceBadge(player,i) == false)then
			triggerClientEvent(player,"PoliceBadges.createMarker",player,i,v[1],v[2],v[3],v[4],v[5],v[6])
		end
	end
end