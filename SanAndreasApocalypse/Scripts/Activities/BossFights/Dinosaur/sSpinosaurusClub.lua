SpinosaurusClub = {}

SpinosaurusClub.EXPPickup = createPickup(2486.6328125,-1859.6248779297,1245.1112060547,3,1239,50)
SpinosaurusClub.EXPTimer = {}

addEventHandler("onPickupHit",SpinosaurusClub.EXPPickup,function(player)
	if(getElementType(player) == "player")then
		if(not(isPedInVehicle(player)))then
			if(getElementDimension(player) == getElementDimension(source))then
				if(getElementInterior(player) == getElementInterior(source))then
					NPC.MeMessage(player,getText(player,"SSpinosaurus7"))
					setAchievement(player,422)
					
					local generatedEXP = tonumber(getPlayerData("character_stats","character_id",getCharacterID(player),"spinosaurusexp"))
					triggerClientEvent(player,"SpinosaurusClub.updateGeneratedEXP",player,0)
					giveEXP(player,math.floor(generatedEXP))
					dbExec(handler,"UPDATE character_stats SET spinosaurusexp = '0' WHERE character_id = '"..getCharacterID(player).."'")
					outputLog(getPlayerName(player).." hat "..generatedEXP.." EXP eingesammelt", "Spinosaurus", getCharacterID(player))
				end
			end
		end
	end
end)

function SpinosaurusClub.playerLoadData(player)
	if(hasPlayerKey(player,21) == true)then
		if(not(isTimer(SpinosaurusClub.EXPTimer[player])))then
			SpinosaurusClub.EXPTimer[player] = setTimer(function(player)
				local generatedEXP = tonumber(getPlayerData("character_stats","character_id",getCharacterID(player),"spinosaurusexp"))
				generatedEXP = math.floor(generatedEXP + (apocalypseGetElementData(player,"level") * 0.5))
				dbExec(handler,"UPDATE character_stats SET spinosaurusexp = '"..generatedEXP.."' WHERE character_id = '"..getCharacterID(player).."'")
				triggerClientEvent(player,"SpinosaurusClub.updateGeneratedEXP",player,generatedEXP)
			end,60000,0,player)
				
			local generatedEXP = tonumber(getPlayerData("character_stats","character_id",getCharacterID(player),"spinosaurusexp"))
			triggerClientEvent(player,"SpinosaurusClub.updateGeneratedEXP",player,generatedEXP)
		end
	end
end

function SpinosaurusClub.loadGate(player)
	if(hasPlayerPhoto(player,3) == false)then
		triggerClientEvent(player,"SpinosaurusClub.Gate",player)
	end
end

addEvent("SpinosaurusClub.checkQuest1",true)
addEventHandler("SpinosaurusClub.checkQuest1",root,function()
	if(hasPlayerPhoto(client,3) == true)then
		triggerClientEvent(client,"Spinosaurus.handOverBones",client)
	else
		NPC.NormalMessage(client,getText(client,"SSpinosaurus4"))
	end
end)

addEvent("SpinosaurusClub.handOverBones",true)
addEventHandler("SpinosaurusClub.handOverBones",root,function()
	if(hasPlayerItem(client,193) >= 10)then
		if(hasPlayerKey(client,21) == 0)then
			takeItem(client,193,10)
			giveKey(client,21)
			giveEXP(client,5000)
			givePlayerSkillpoint(client,50)
			NPC.NomalMessage(client,getText(client,"SSpinosaurus3"))
			triggerClientEvent(client,"closeWindow",client)
			outputLog(getPlayerName(client).." hat Quest #1 erledigt", "Spinosaurus", getCharacterID(client))
		else
			NPC.NomalMessage(client,getText(client,"SSpinosaurus2"))
		end
	else
		NPC.NomalMessage(client,getText(client,"SSpinosaurus1"))
	end
end)

addEvent("SpinosaurusClub.MoneyPickup",true)
addEventHandler("SpinosaurusClub.MoneyPickup",root,function()
	if(hasPlayerItem(client,193) >= 15)then
		local EXP = 12500
		local Level_Bonus_EXP = tonumber(apocalypseGetElementData(client,"level"))
		if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
		EXP = EXP + (25 * Level_Bonus_EXP)
		
		takeItem(client,193,15)
		giveEXP(client,EXP)
		giveKey(client,13)
		local rnd = math.random(1,20)
		local itemID = 72
		if(rnd >= 12 and rnd <= 17)then
			itemID = 73
		elseif(rnd >= 18 and rnd <= 20)then
			itemID = 74
		end
		giveItem(client,itemID,2)
		triggerClientEvent(client, "showItemBar", client, {{itemID,2}})
		setAchievement(client,406)
		createInfobox(client,getText(client,"SSpinosaurus5"):format(EXP,ItemInfos["items"][apocalypseGetElementData(localPlayer,"language") or "EN"][itemID]))
		outputLog(getPlayerName(client).." hat Quest #2 abgeschlossen und "..EXP.." EXP, einen Tresorschlüssel und das Item "..itemID.." (1x) bekommen", "Spinosaurus", getCharacterID(client))
	else
		NPC.MeMessage(client,getText(client,"SSpinosaurus6"))
	end
end)

addEventHandler("onPlayerQuit",root,function()
	if(isTimer(SpinosaurusClub.EXPTimer[source]))then
		killTimer(SpinosaurusClub.EXPTimer[source])
	end
end)