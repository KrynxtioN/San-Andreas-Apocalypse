BigfootJail = {}

BigfootJail.Ped1 = createPed(9,319.85180664062,312.21853637695,999.1484375,270)
setElementInterior(BigfootJail.Ped1,5)
BigfootJail.Ped2 = createPed(9,318.98962402344,317.10122680664,999.1484375,253)
setElementInterior(BigfootJail.Ped2,5)

addEventHandler("onClientPedDamage",BigfootJail.Ped1,function() cancelEvent() end)
addEventHandler("onClientPedDamage",BigfootJail.Ped2,function() cancelEvent() end)

BigfootJail.Pickup = createPickup(323.63751220703,309.36120605469,999.1484375,3,1239,50)
setElementInterior(BigfootJail.Pickup,5)

addEventHandler("onPickupHit",BigfootJail.Pickup,function(player)
	if(getElementType(player) == "player")then
		if not isCharacterLoggedIn(player) then return end
		if(getElementDimension(player) == getElementDimension(source))then
			local bigfoot_heads = tonumber(getPlayerData("character_stats","character_id",getCharacterID(player),"bigfoot_heads"))
			if(bigfoot_heads < 5 and hasPlayerKey(player,14) == 0)then
				triggerClientEvent(player,"BigfootJail.openWindow",player)
			else
				NPC.MeMessage(player,getText(player,"SBigfoot8"))
			end
		end
	end
end)

function BigfootJail.getData(player)
	if(not(player))then player = client end
	local heads = tonumber(getPlayerData("character_stats","character_id",getCharacterID(player),"bigfoot_heads"))
	triggerClientEvent(player,"BigfootJail.setData",player,heads)
end
addEvent("BigfootJail.getData",true)
addEventHandler("BigfootJail.getData",root,BigfootJail.getData)

addEvent("BigfootJail.giveHead",true)
addEventHandler("BigfootJail.giveHead",root,function()
	local bigfoot_heads = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"bigfoot_heads"))
	if(bigfoot_heads >= 5)then
		if(hasPlayerKey(client,14) == 0)then
			giveKey(client,14)
			setAchievement(client,135)
			NPC.MeMessage(client,getText(client,"SBigfoot7"))
			outputLog(getPlayerName(client).." hat Quest #1 erledigt", "Bigfoot", getCharacterID(client))
		else
			NPC.MeMessage(client,getText(client,"SBigfoot14"))
		end
	else
		if(hasPlayerItem(client,128) >= 1)then
			Characters.addStats(client,"bigfoot_heads",bigfoot_heads + 1)
			takeItem(client,128,1)
			BigfootJail.getData(client)
			createInfobox(client,getText(client,"SBigfoot5"))
			giveEXP(client,2500)
			givePlayerSkillpoint(client,25)
			outputLog(getPlayerName(client).." hat einen Bigfoot Kopf abgegeben", "Bigfoot", getCharacterID(client))
		else
			NPC.MeMessage(client,getText(client,"SBigfoot6"))
		end
	end
end)