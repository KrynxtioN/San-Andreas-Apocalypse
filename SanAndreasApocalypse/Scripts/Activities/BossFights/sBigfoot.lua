local MinigunPickup = { -- x,y,z,int,dim
	{-2817.76171875,-1521.9071044922,140.84375,0,0},
	{322.56936645508,317.0087890625,999.1484375,5,0},
}

addEvent("Bigfoot.givePlayerPhoto",true)
addEventHandler("Bigfoot.givePlayerPhoto",root,function()
	givePlayerPhoto(client,5)
	NPC.MeMessage(client,getText(client,"SBigfoot15"))
end)

function BigfootCheckPhotoMarker(player)
	if(hasPlayerPhoto(player,5) == false)then
		triggerClientEvent(player,"Bigfoot.createPhotoMarker",player)
	end
end

for _,v in pairs(MinigunPickup)do
	local pickup = createPickup(v[1],v[2],v[3],3,362,50)
	setElementInterior(pickup,v[4])
	setElementDimension(pickup,v[5])

	addEventHandler("onPickupHit",pickup,function(player)
		if(getElementType(player) == "player")then
			if(isCharacterLoggedIn(player))then
				if(getElementDimension(player) == getElementDimension(source))then
					local time = getRealTime()
					local available = tonumber(getPlayerData("character_stats", "character_id", getCharacterID(player), "minigun_timer")) or 0
					local currentTimestamp = time.timestamp
					if(hasPlayerPhoto(player,2) == true)then
						if((currentTimestamp - available) >= 14400)then
							local bigfoot_killed = getPlayerData("character_stats","character_id",getCharacterID(player),"killed_bigfoot")
							local ammo = 500 + (tonumber(bigfoot_killed) * 5)
							if(ammo > 9999)then ammo = 9999 end
							PlayerWeapons.addNewWeapon(player,38, ammo)
							local timestamp = time.timestamp
							dbExec(handler, "UPDATE character_stats SET minigun_timer = '"..timestamp.."' WHERE character_id = '"..getCharacterID(player).."'")
							NPC.MeMessage(player,getText(player,"SBigfoot2"))
							outputLog(getPlayerName(player).." hat eine Minigun mit "..ammo.." Munition eingesammelt", "Bigfoot", getCharacterID(player))
						else
							local timeLeft = 14400 - (currentTimestamp - available)
							createInfobox(player,getText(player,"SBigfoot3"):format(formatTimeLeft(timeLeft)))
						end
					else
						NPC.MeMessage(player,getText(player,"SBigfoot13"))
					end
				end
			end
		end
	end)
end

local Achievements = {
	{3,121},
	{5,122},
	{7,123},
	{10,124},
	{15,125},
	{25,126},
	{35,127},
	{50,128},
}

addEvent("Bigfoot.collectHead",true)
addEventHandler("Bigfoot.collectHead",root,function()
	local killed_bigfoot = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"killed_bigfoot"))
	Characters.addStats(client,"killed_bigfoot",killed_bigfoot + 1)
	local amount = 1
	if(SERVERBONUS.BIGFOOT == true)then amount = 2 end
	giveItem(client,128,amount)
	triggerClientEvent(client, "showItemBar", client, {{128,amount}})
	NPC.MeMessage(client,getText(client,"MeMessage25"))
	setAchievement(client,91)
	givePlayerPhoto(client,2)
	
	local EXP = 300
	local Level_Bonus_EXP = tonumber(apocalypseGetElementData(client,"level"))
	if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
	EXP = EXP + (25 * Level_Bonus_EXP)
	
	giveEXP(client, EXP)
	triggerClientEvent(client,"BigfootClub.destroyGate",client)
	triggerClientEvent(client,"Killed_Bigfoot_Counter_Pickup_Update",client,killed_bigfoot + 1)
	outputLog(getPlayerName(client).." hat einen Bigfoot Kopf eingesammelt", "Bigfoot", getCharacterID(client))
	
	for _,v in pairs(Achievements)do
		if(killed_bigfoot + 1 >= v[1])then
			setAchievement(client,v[2])
		end
	end
end)

addEvent("Bigfoot.Task",true)
addEventHandler("Bigfoot.Task",root,function()
	if(DailyTasks.playerTasks[client][8])then
		DailyTasks.updateProgress(client,8,DailyTasks.playerTasks[client][8].progress + 1)
	end
	
	if(WeeklyTasks.playerTasks[client][8])then
		WeeklyTasks.updateProgress(client,8,WeeklyTasks.playerTasks[client][8].progress + 1)
	end
	outputLog(getPlayerName(client).." hat Bigfoot getötet", "Bigfoot", getCharacterID(client))
end)