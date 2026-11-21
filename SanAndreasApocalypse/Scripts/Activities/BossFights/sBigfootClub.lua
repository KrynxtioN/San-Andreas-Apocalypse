BigfootClub = {EXPTimer = {}}

BigfootClub.Pickup = createPickup(-263.75231933594,-2178.7307128906,28.967338562012,3,1239,50)
BigfootClub.MoneyPickup = createPickup(416.53665161133,2539.1997070312,10,3,1239,50)
setElementInterior(BigfootClub.MoneyPickup,10)
setElementDimension(BigfootClub.MoneyPickup,2)

addEventHandler("onPickupHit",BigfootClub.Pickup,function(player)
	if(getElementType(player) == "player")then
		if(not(isPedInVehicle(player)))then
			if(getElementDimension(player) == getElementDimension(source))then
				if(getElementInterior(player) == getElementInterior(source))then
					NPC.MeMessage(player,getText(player,"SBigfoot4"))
					setAchievement(player,119)
					
					local generatedEXP = tonumber(getPlayerData("character_stats","character_id",getCharacterID(player),"bigfootexp"))
					triggerClientEvent(player,"Bigfoot.updateGeneratedEXP",player,0)
					giveEXP(player,math.floor(generatedEXP))
					dbExec(handler,"UPDATE character_stats SET bigfootexp = '0' WHERE character_id = '"..getCharacterID(player).."'")
					outputLog(getPlayerName(player).." hat "..generatedEXP.." EXP eingesammelt", "Bigfoot", getCharacterID(player))
				end
			end
		end
	end
end)

function BigfootClub.playerLoadData(player)
	if(hasPlayerSpawn(player,6) == true)then
		if(not(isTimer(BigfootClub.EXPTimer[player])))then
			BigfootClub.EXPTimer[player] = setTimer(function(player)
				local generatedEXP = tonumber(getPlayerData("character_stats","character_id",getCharacterID(player),"bigfootexp"))
				generatedEXP = math.floor(generatedEXP + (apocalypseGetElementData(player,"level") * 0.5))
				dbExec(handler,"UPDATE character_stats SET bigfootexp = '"..generatedEXP.."' WHERE character_id = '"..getCharacterID(player).."'")
				triggerClientEvent(player,"Bigfoot.updateGeneratedEXP",player,generatedEXP)
			end,60000,0,player)
				
			local generatedEXP = tonumber(getPlayerData("character_stats","character_id",getCharacterID(player),"bigfootexp"))
			triggerClientEvent(player,"Bigfoot.updateGeneratedEXP",player,generatedEXP)
		end
	end
end

function BigfootClub.loadGate(player)
	if(hasPlayerPhoto(player,2) == false)then
		triggerClientEvent(player,"BigfootClub.createGate",player)
	end
end

addEventHandler("onPickupHit",BigfootClub.MoneyPickup,function(player)
	if(getElementType(player) == "player")then
		if(not(isPedInVehicle(player)))then
			if(getElementDimension(player) == getElementDimension(source))then
				triggerClientEvent(player,"BigfootClub.MoneyPickup",player)
			end
		end
	end
end)

addEvent("BigfootClub.MoneyPickup",true)
addEventHandler("BigfootClub.MoneyPickup",root,function()
	if(hasPlayerItem(client,128) >= 5)then
		local EXP = 6250
		local Level_Bonus_EXP = tonumber(apocalypseGetElementData(client,"level"))
		if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
		EXP = EXP + (25 * Level_Bonus_EXP)
		
		takeItem(client,128,5)
		giveEXP(client,EXP)
		giveKey(client,13)
		local rnd = math.random(1,20)
		local itemID = 72
		if(rnd >= 12 and rnd <= 17)then
			itemID = 73
		elseif(rnd >= 18 and rnd <= 20)then
			itemID = 74
		end
		giveItem(client,itemID,1)
		triggerClientEvent(client, "showItemBar", client, {{itemID,1}})
		setAchievement(client,136)
		createInfobox(client,getText(client,"SBigfoot9"):format(EXP,ItemInfos["items"][apocalypseGetElementData(localPlayer,"language") or "EN"][itemID]))
		outputLog(getPlayerName(client).." hat Quest #2 abgeschlossen und "..EXP.." EXP, einen Tresorschlüssel und das Item "..itemID.." (1x) bekommen", "Bigfoot", getCharacterID(client))
	else
		NPC.MeMessage(client,getText(client,"SBigfoot10"))
	end
end)

addEvent("BigfootClub.giveSpawnpoint",true)
addEventHandler("BigfootClub.giveSpawnpoint",root,function()
	if(hasPlayerSpawn(client,6) == false)then
		addPlayerSpawn(client,6)
		NPC.NormalMessage(client,getText(client,"SBigfoot11"))
		setAchievement(client,137)
		BigfootClub.playerLoadData(client)
		outputLog(getPlayerName(client).." hat den Bigfoot Club Spawnpunkt freigeschaltet", "Bigfoot", getCharacterID(client))
	else
		NPC.NormalMessage(client,getText(client,"SOutfits3"))
	end
end)

addEventHandler("onPlayerQuit",root,function()
	if(isTimer(BigfootClub.EXPTimer[source]))then
		killTimer(BigfootClub.EXPTimer[source])
	end
end)