PlayerOutfits = {}

function hasPlayerOutfit(player, ID)
	local playerOutfits = getPlayerData("characters","ID",getCharacterID(player),"outfits")
	
	if(not(playerOutfits) or playerOutfits == 0)then
		dbExec(handler, "UPDATE characters SET outfits = '' WHERE ID = '"..getCharacterID(player).."'")
		playerOutfits = getPlayerData("characters","ID",getCharacterID(player),"outfits")
	end
	
	local values = split(playerOutfits, "|")
	local hasOutfit = false
	
	if(playerOutfits and ID)then
		for _, v in pairs(values)do
			if(tonumber(v) == ID)then
				hasOutfit = true
			end
		end
	end
	return hasOutfit
end

function givePlayerOutfit(player, ID)
	local playerOutfits = getPlayerData("characters","ID",getCharacterID(player),"outfits")
	
	if(not(playerOutfits) or playerOutfits == 0)then
		dbExec(handler, "UPDATE characters SET outfits = '' WHERE ID = ?", getCharacterID(player))
		playerOutfits = getPlayerData("characters","ID",getCharacterID(player),"outfits")
	end
	
	local values = split(playerOutfits, "|")
	local hasOutfit = false
	
	if(playerOutfits and ID)then
		for _, v in pairs(values)do
			if(tonumber(v) == ID)then
				hasOutfit = true
				break
			end
		end
	end
	
	if(hasOutfit == false)then
		dbExec(handler, "UPDATE characters SET outfits = '"..playerOutfits..ID.."|' WHERE ID = '"..getCharacterID(player).."'")
		table.insert(PlayerOutfits[player],{outfit = ID, amount = 1})
		updateClientOutfits(player)
	end
end

function Outfits.loadQuestWindow(id)
	local id = tonumber(id)
	local status = true
	if(id == 1)then
		setQuest(client,4)
	end
	if(id == 2)then
		setQuest(client,5)
	end
	if(id == 3)then
		if(hasPlayerItem(client,5) == 0)then
			status = false
			NPC.NormalMessage(client,getText(client,"SOutfits4"))
		else
			setQuest(client,6)
		end
	end
	if(id == 4)then
		if(hasPlayerItem(client,5) == 0)then
			status = false
			NPC.NormalMessage(client,getText(client,"SOutfits4"))
		else
			if(hasPlayerPhoto(client,1) == false)then
				setQuest(client,7)
				giveRadioData(client,1)
				NPC.NormalMessage(client,getText(client,"SOutfits6"))
			end
		end
	end
	if(id == 5)then
		setQuest(client,8)
	end
	if(id == 6)then
		setQuest(client,9)
	end
	if(id == 7)then
		if(hasPlayerItem(client,5) == 0)then
			status = false
			NPC.NormalMessage(client,getText(client,"SOutfits4"))
		else
			setQuest(client,10)
		end
	end
	if(id == 8)then
		setQuest(client,11)
	end
	if(id == 9)then
		setQuest(client,12)
	end
	if(id == 10)then
		setQuest(client,13)
		giveRadioData(client,10)
	end
	if(id == 11)then
		setQuest(client,14)
	end
	if(id == 12)then
		setQuest(client,15)
	end
	if(id == 13)then
		setQuest(client,16)
	end
	if(id == 14)then
		setQuest(client,17)
	end
	if(id == 15)then
		setQuest(client,19)
	end
	if(id == 16)then
		setQuest(client,20)
	end
	if(id == 17)then
		setQuest(client,21)
	end
	if(id == 18)then
		setQuest(client,22)
	end
	if(id == 19)then
		if(hasPlayerItem(client,107) < 1)then
			setQuest(client,23)
			giveItem(client,107,1)
		end
	end
	if(id == 20)then
		if(hasPlayerItem(client,5) == 0)then
			status = false
			NPC.NormalMessage(client,getText(client,"SOutfits4"))
		else
			if(hasPlayerSpawn(client,5) == false)then
				setQuest(client,24)
				giveRadioData(client,5)
			end
		end
	end
	if(id == 21)then
		setQuest(client,25)
	end
	if(id == 22)then
		setQuest(client,26)
	end
	if(id == 23)then
		if(hasPlayerKey(client,14) == 0)then
			NPC.NormalMessage(client,getText(client,"SOutfits38"))
			return
		end
		setQuest(client,27)
	end
	if(id == 24)then
		setQuest(client,28)
	end
	if(id == 25)then
		setQuest(client,29)
	end
	if(id == 26)then
		if(hasPlayerItem(client,5) == 0)then
			status = false
			NPC.NormalMessage(client,getText(client,"SOutfits4"))
		else
			setQuest(client,30)
			giveRadioData(client,14)
		end
	end
	if(id == 27)then
		setQuest(client,31)
	end
	if(id == 28)then
		setQuest(client,34)
	end
	if(id == 29)then
		setQuest(client,35)
	end
	if(id == 30)then
		setQuest(client,36)
	end
	if(id == 31)then
		setQuest(client,37)
	end
	
	if(status == true)then
		local outfitID = id
		if(id == 5)then outfitID = 4 end
		if(id == 7)then outfitID = 5 end
		if(id == 4)then
			if(hasPlayerPhoto(client,1) == false)then
				triggerClientEvent(client,"Outfits.createQuestWindow",client,id)
			else
				triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SOutfits3"))
			end
		elseif(id == 6)then
			if(hasPlayerSpawn(client,3) == false)then
				triggerClientEvent(client,"Outfits.createQuestWindow",client,id)
			else
				triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SOutfits3"))
			end
		elseif(id == 7)then
			if(hasPlayerCraftingRecipe(client,2) == false)then
				triggerClientEvent(client,"Outfits.createQuestWindow",client,id)
			else
				triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SOutfits3"))
			end
		elseif(id == 8)then
			if(hasPlayerCraftingRecipe(client,3) == false)then
				triggerClientEvent(client,"Outfits.createQuestWindow",client,id)
			else
				triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SOutfits3"))
			end
		elseif(id == 9)then
			if(hasPlayerCraftingRecipe(client,4) == false)then
				triggerClientEvent(client,"Outfits.createQuestWindow",client,id)
			else
				triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SOutfits3"))
			end
		elseif(id == 10)then
			if(hasPlayerKey(client,8) < 1)then
				triggerClientEvent(client,"Outfits.createQuestWindow",client,id)
			else
				triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SOutfits3"))
			end
		elseif(id == 11)then
			if(hasPlayerKey(client,9) < 1)then
				triggerClientEvent(client,"Outfits.createQuestWindow",client,id)
			else
				triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SOutfits3"))
			end
		elseif(id == 12)then
			if(hasPlayerKey(client,10) < 1)then
				triggerClientEvent(client,"Outfits.createQuestWindow",client,id)
			else
				triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SOutfits3"))
			end
		elseif(id == 13)then
			if(hasPlayerCraftingRecipe(client,5) == false)then
				triggerClientEvent(client,"Outfits.createQuestWindow",client,id)
			else
				triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SOutfits3"))
			end
		elseif(id == 14)then
			if(hasRadioLocation(client,11) == false)then
				triggerClientEvent(client,"Outfits.createQuestWindow",client,id)
			else
				triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SOutfits3"))
			end
		elseif(id == 15)then
			if(getQuest(client,19) <= 1)then
				triggerClientEvent(client,"Outfits.createQuestWindow",client,id)
			else
				triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SOutfits3"))
			end
		elseif(id == 16)then
			if(getQuest(client,20) <= 1)then
				QuestSeries.giveQuest(client,2)
				triggerClientEvent(client,"Outfits.createQuestWindow",client,id)
			else
				triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SOutfits3"))
			end
		elseif(id == 17)then
			if(hasPlayerKey(client,11) == 0)then
				triggerClientEvent(client,"Outfits.createQuestWindow",client,id)
			else
				triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SOutfits3"))
			end
		elseif(id == 18)then
			if(hasPlayerCraftingRecipe(client,11) == false)then
				triggerClientEvent(client,"Outfits.createQuestWindow",client,id)
			else
				triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SOutfits3"))
			end
		elseif(id == 19)then
			if(hasPlayerSpawn(client,5) == false)then
				triggerClientEvent(client,"Outfits.createQuestWindow",client,id)
			else
				triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SOutfits3"))
			end
		elseif(id == 20)then
			if(hasRadioLocation(client,6) == false)then
				triggerClientEvent(client,"Outfits.createQuestWindow",client,id)
			else
				triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SOutfits3"))
			end
		elseif(id == 21)then
			if(tonumber(getQuest(client,25)) <= 1)then
				triggerClientEvent(client,"Outfits.createQuestWindow",client,id)
			else
				triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SOutfits3"))
			end
		elseif(id == 22)then
			if(tonumber(getQuest(client,26)) <= 1)then
				triggerClientEvent(client,"Outfits.createQuestWindow",client,id)
			else
				triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SOutfits3"))
			end
		elseif(id == 23)then
			if(hasPlayerSpawn(client,6) == true)then
				triggerClientEvent(client,"Outfits.createQuestWindow",client,id)
				giveRadioData(client, 7)
			else
				triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SBigfoot12"))
			end
		elseif(id == 24)then
			if(tonumber(getQuest(client,28)) <= 1)then
				triggerClientEvent(client,"Outfits.createQuestWindow",client,id)
			else
				triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SOutfits3"))
			end
		elseif(id == 25)then
			if(tonumber(hasPlayerKey(client,17)) < 1)then
				triggerClientEvent(client,"Outfits.createQuestWindow",client,id)
			else
				triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SOutfits3"))
			end
		elseif(id == 26)then
			if(hasRadioLocation(client,15) == false)then
				triggerClientEvent(client,"Outfits.createQuestWindow",client,id)
			else
				triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SOutfits3"))
			end
		elseif(id == 27)then
			if(tonumber(getQuest(client,31)) <= 1)then
				triggerClientEvent(client,"Outfits.createQuestWindow",client,id)
			else
				triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SOutfits3"))
			end
		elseif(id == 28)then
			if(tonumber(getQuest(client,34)) <= 1)then
				triggerClientEvent(client,"Outfits.createQuestWindow",client,id)
			else
				triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SOutfits3"))
			end
		elseif(id == 29)then
			triggerClientEvent(client,"Outfits.createQuestWindow",client,id)
		elseif(id == 30)then
			if(tonumber(hasPlayerItem(client,207)) < 1)then
				triggerClientEvent(client,"Outfits.createQuestWindow",client,id)
			else
				triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SOutfits3"))
			end
		elseif(id == 31)then
			if(tonumber(getQuest(client,37)) <= 1)then
				triggerClientEvent(client,"Outfits.createQuestWindow",client,id)
			else
				triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SOutfits3"))
			end
		else
			if(hasPlayerOutfit(client,outfitID) == false)then
				triggerClientEvent(client,"Outfits.createQuestWindow",client,id)
			else
				triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SOutfits3"))
			end
		end
	end
end
addEvent("Outfits.loadQuestWindow",true)
addEventHandler("Outfits.loadQuestWindow",root,Outfits.loadQuestWindow)

addEvent("RedCountyMonster.finishQuest",true)
addEventHandler("RedCountyMonster.finishQuest",root,function()
	if(hasPlayerPhoto(client,6) == true)then
		Quests.finishQuest(client,35)
		NPC.NormalMessage(client,getText(client,"SOutfits45"))
		addPlayerCraftingRecipe(client,14)
		triggerClientEvent(client,"Outfits.closeQuestWindow",client)
	else
		NPC.NormalMessage(client,getText(client,"SOutfits44"))
	end
end)

addEvent("InventoryAmmoExpansion.finishQuest",true)
addEventHandler("InventoryAmmoExpansion.finishQuest",root,function()
	if(hasPlayerItem(client,22) >= 1000)then
		takeItem(client,22,1000)
		giveItem(client,207,1)
		Quests.finishQuest(client,36)
		NPC.NormalMessage(client,getText(client,"SOutfits43"))
		triggerClientEvent(client,"Outfits.closeQuestWindow",client)
	else
		NPC.NormalMessage(client,getText(client,"SOutfits42"))
	end
end)

addEvent("PirateIslandPostcard.finishQuest",true)
addEventHandler("PirateIslandPostcard.finishQuest",root,function()
	if(hasPlayerItem(client,208) >= 1)then
		Quests.finishQuest(client,37)
		takeItem(client,208,1)
		NPC.NormalMessage(client,getText(client,"SOutfits41"))
		triggerClientEvent(client,"Outfits.closeQuestWindow",client)
	else
		NPC.NormalMessage(client,getText(client,"SOutfits40"))
	end
end)

addEvent("Outfits.policeOutfit",true)
addEventHandler("Outfits.policeOutfit",root,function()
	if(hasPlayerItem(client, 10) >= 5 and hasPlayerItem(client, 11) >= 10)then
		takeItem(client,10,5)
		takeItem(client,11,10)
		givePlayerOutfit(client,1)
		giveKey(client,4)
		triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SOutfits2"))
		triggerClientEvent(client,"Outfits.closeQuestWindow",client)
		Quests.finishQuest(client,4)
	else triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SOutfits1"))end
end)

addEvent("Outfits.sexOutfit",true)
addEventHandler("Outfits.sexOutfit",root,function()
	if(hasPlayerItem(client,23) >= 50)then
		takeItem(client,23,50)
		givePlayerOutfit(client,3)
		giveKey(client,5)
		triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SOutfits5"))
		triggerClientEvent(client,"Outfits.closeQuestWindow",client)
		Quests.finishQuest(client,6)
	else triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SOutfits7"))end
end)

addEvent("Outfits.liamParker",true)
addEventHandler("Outfits.liamParker",root,function()
	if(hasPlayerItem(client,25) >= 5)then
		takeItem(client,25,5)
		givePlayerPhoto(client,1)
		addPlayerCraftingRecipe(client,1)
		triggerClientEvent(client,"Outfits.closeQuestWindow",client)
		NPC.NormalMessage(client,getText(client,"SOutfits9"))
		Quests.finishQuest(client,7)
	else NPC.NormalMessage(client,getText(client,"SOutfits8"))end
end)

addEvent("Outfits.RogerMoore",true)
addEventHandler("Outfits.RogerMoore",root,function()
	if(hasPlayerItem(client,27) >= 50)then
		takeItem(client,27,50)
		givePlayerOutfit(client,4)
		NPC.NormalMessage(client,getText(client,"SOutfits11"))
		triggerClientEvent(client,"Outfits.closeQuestWindow",client)
		Quests.finishQuest(client,8)
	else NPC.NormalMessage(client,getText(client,"SOutfits10"))end
end)

addEvent("Outfits.JasonBrooks",true)
addEventHandler("Outfits.JasonBrooks",root,function()
	if(hasPlayerItem(client,29) >= 50)then
		takeItem(client,29,50)
		triggerClientEvent(client,"Outfits.closeQuestWindow",client)
		NPC.NormalMessage(client,getText(client,"SOutfits13"))
		addPlayerCraftingRecipe(client,2)
		Quests.finishQuest(client,10)
	else NPC.NormalMessage(client,getText(client,"SOutfits12"))end
end)

addEvent("Outfits.FirefighterQuest",true)
addEventHandler("Outfits.FirefighterQuest",root,function()
	if(hasPlayerItem(client,54) >= 50)then
		NPC.NormalMessage(client,getText(client,"SOutfits16"))
		addPlayerCraftingRecipe(client,3)
		takeItem(client,54,50)
		triggerClientEvent(client,"Outfits.closeQuestWindow",client)
		Quests.finishQuest(client,11)
	else NPC.NormalMessage(client,getText(client,"SOutfits14"))end
end)

addEvent("Outfits.MedicQuest",true)
addEventHandler("Outfits.MedicQuest",root,function()
	if(hasPlayerItem(client,28) >= 50)then
		NPC.NormalMessage(client,getText(client,"SOutfits17"))
		addPlayerCraftingRecipe(client,4)
		takeItem(client,28,50)
		triggerClientEvent(client,"Outfits.closeQuestWindow",client)
		Quests.finishQuest(client,12)
	else NPC.NormalMessage(client,getText(client,"SOutfits15"))end
end)

addEvent("Outfits.fabricfactory",true)
addEventHandler("Outfits.fabricfactory",root,function()
	if(hasPlayerItem(client,32) >= 50)then
		giveKey(client,8,1)
		takeItem(client,32,50)
		giveRadioData(client,16)
		triggerClientEvent(client,"Outfits.closeQuestWindow",client)
		NPC.NormalMessage(client,getText(client,"SOutfits19"))
		Quests.finishQuest(client,13)
	else NPC.NormalMessage(client,getText(client,"SOutfits18"))end
end)

addEvent("Outfits.tattoo",true)
addEventHandler("Outfits.tattoo",root,function()
	if(hasPlayerItem(client,48) >= 50)then
		giveKey(client,9,1)
		takeItem(client,48,50)
		triggerClientEvent(client,"Outfits.closeQuestWindow",client)
		NPC.NormalMessage(client,getText(client,"SOutfits21"))
		giveRadioData(client,13)
		Quests.finishQuest(client,14)
	else NPC.NormalMessage(client,getText(client,"SOutfits20"))end
end)

addEvent("Outfits.barbershops",true)
addEventHandler("Outfits.barbershops",root,function()
	if(hasPlayerItem(client,53) >= 50)then
		giveKey(client,10,1)
		takeItem(client,53,50)
		triggerClientEvent(client,"Outfits.closeQuestWindow",client)
		NPC.NormalMessage(client,getText(client,"SOutfits23"))
		Quests.finishQuest(client,15)
	else NPC.NormalMessage(client,getText(client,"SOutfits22"))end
end)

addEvent("Outfits.zombienestQuest",true)
addEventHandler("Outfits.zombienestQuest",root,function()
	local destroyed_nest = getPlayerData("character_stats","character_id",getCharacterID(client),"destroyed_nest")
	if(tonumber(destroyed_nest) >= 10)then
		addPlayerCraftingRecipe(client,5)
		triggerClientEvent(client,"Outfits.closeQuestWindow",client)
		NPC.NormalMessage(client,getText(client,"SOutfits25"))
		Quests.finishQuest(client,16)
	else NPC.NormalMessage(client,getText(client,"SOutfits39"))end
end)

addEvent("Outfits.tuningQuest",true)
addEventHandler("Outfits.tuningQuest",root,function()
	local killed_infected_survivors = getPlayerData("character_stats","character_id",getCharacterID(client),"killed_infected_survivors")
	if(tonumber(killed_infected_survivors) >= 500)then
		triggerClientEvent(client,"Outfits.closeQuestWindow",client)
		Quests.finishQuest(client,17)
		giveRadioData(client,11)
	else
		NPC.NormalMessage(client,getText(client,"SOutfits24"))
	end
end)

addEvent("RhinoQuest",true)
addEventHandler("RhinoQuest",root,function()
	local rhinos_destroyed = getPlayerData("character_stats","character_id",getCharacterID(client),"rhinos_destroyed")
	if(tonumber(rhinos_destroyed) >= 15)then
		Quests.finishQuest(client,19)
		triggerClientEvent(client,"Outfits.closeQuestWindow",client)
		NPC.NormalMessage(client,getText(client,"SOutfits28"))
		giveRadioData(client,3)
	else
		NPC.NormalMessage(client,getText(client,"SOutfits27"))
	end
end)

addEvent("MoonflightQuest",true)
addEventHandler("MoonflightQuest",root,function()
	if(getQuestSeriesProgress(client,2,1) >= tonumber(QuestSeries["QuestData"][1]["Stages"][1].required) and getQuestSeriesProgress(client,2,2) >= tonumber(QuestSeries["QuestData"][1]["Stages"][2].required) and getQuestSeriesProgress(client,2,3) >= tonumber(QuestSeries["QuestData"][1]["Stages"][3].required))then
		Quests.finishQuest(client,20)
		triggerClientEvent(client,"Outfits.closeQuestWindow",client)
		givePlayerOutfit(client,6)
		NPC.NormalMessage(client,getText(client,"SOutfits30"))
	else
		NPC.NormalMessage(client,getText(client,"SOutfits29"))
	end
end)

addEvent("JunkyardQuest",true)
addEventHandler("JunkyardQuest",root,function()
	local junkyard_vehicles = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"junkyard_vehicles"))
	if(junkyard_vehicles >= 25)then
		Quests.finishQuest(client,21)
		triggerClientEvent(client,"Outfits.closeQuestWindow",client)
		giveKey(client,11)
		NPC.NormalMessage(client,getText(client,"SOutfits32"))
	else
		NPC.NormalMessage(client,getText(client,"SOutfits31"))
	end
end)

addEvent("TreasureHunterQuest",true)
addEventHandler("TreasureHunterQuest",root,function()
	local found_treasures = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"found_treasures"))
	if(found_treasures >= 25)then
		if(checkPlayerVehicleFreeSlot(client) == true)then
			Quests.finishQuest(client,22)
			triggerClientEvent(client,"Outfits.closeQuestWindow",client)
			addPlayerVehicle(client,453)
			NPC.NormalMessage(client,getText(client,"SOutfits34"))
		else
			NPC.NormalMessage(client,getText(client,"SOutfits35"))
		end
	else
		NPC.NormalMessage(client,getText(client,"SOutfits33"))
	end
end)

addEvent("BearFurQuest",true)
addEventHandler("BearFurQuest",root,function()
	if(hasPlayerItem(client,108) >= 25)then
		addPlayerSpawn(client,5)
		Quests.finishQuest(client,23)
		triggerClientEvent(client,"Outfits.closeQuestWindow",client)
	else
		NPC.NormalMessage(client,getText(client,"SOutfits37"))
	end
end)

addEvent("BigfootQuest",true)
addEventHandler("BigfootQuest",root,function()
	local killed_bigfoot = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"killed_bigfoot"))
	if(killed_bigfoot >= 1)then
		Quests.finishQuest(client,24)
		triggerClientEvent(client,"Outfits.closeQuestWindow",client)
		NPC.NormalMessage(client,getText(client,"SBigfoot1"))
		giveRadioData(client,6)
	else
		NPC.NormalMessage(client,getText(client,"SOutfits36"))
	end
end)

addEvent("sweeperQuest",true)
addEventHandler("sweeperQuest",root,function()
	local sweeper_trash = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"sweeper_trash"))
	if(sweeper_trash >= 500)then
		if(checkPlayerVehicleFreeSlot(client) == true)then
			Quests.finishQuest(client,25)
			triggerClientEvent(client,"Outfits.closeQuestWindow",client)
			addPlayerVehicle(client,574)
			NPC.NormalMessage(client,getText(client,"SStreetCleaner2"))
		else
			NPC.NormalMessage(client,getText(client,"SOutfits35"))
		end
	else
		NPC.NormalMessage(client,getText(client,"SStreetCleaner1"))
	end
end)

addEvent("chainsawQuest",true)
addEventHandler("chainsawQuest",root,function()
	if(hasPlayerItem(client,132) >= 10)then
		Quests.finishQuest(client,26)
		triggerClientEvent(client,"Outfits.closeQuestWindow",client)
		NPC.NormalMessage(client,getText(client,"SChainsaw2"))
		setAchievement(client,237)
	else
		NPC.NormalMessage(client,getText(client,"SChainsaw1"))
	end
end)

addEvent("metalDetectorWoodQuest",true)
addEventHandler("metalDetectorWoodQuest",root,function()
	local status = tonumber(getPlayerData("characters","ID",getCharacterID(client),"quest_wood_removed"))
	if(status == 1)then
		if(hasPlayerKey(client,15) < 1)then
			giveKey(client,15,1)
			Quests.finishQuest(client,28)
			triggerClientEvent(client,"MetalDetector.destroyClientWood",client)
			triggerClientEvent(client,"Outfits.closeQuestWindow",client)
			NPC.NormalMessage(client,getText(client,"SMetalDetector4"))
		end
	else
		NPC.NormalMessage(client,getText(client,"SMetalDetector2"))
	end
end)

addEvent("triadSuppliesQuest",true)
addEventHandler("triadSuppliesQuest",root,function()
	if(hasPlayerItem(client,33) >= 50 and hasPlayerItem(client,51) >= 50 and hasPlayerItem(client,52) >= 50 and hasPlayerItem(client,49) >= 50)then
		if(hasPlayerKey(client,17) < 1)then
			giveKey(client,17,1)
			Quest.finishQuest(client,29)
			NPC.NormalMessage(client,getText(client,"STriadQuest2"))
			takeItem(client,33,50)
			takeItem(client,51,50)
			takeItem(client,52,50)
			takeItem(client,49,50)
			triggerClientEvent(client,"Outfits.closeQuestWindow",client)
		end
	else
		NPC.NormalMessage(client,getText(client,"STriadQuest1"))
	end
end)

addEvent("oilDeliveryQuest",true)
addEventHandler("oilDeliveryQuest",root,function()
	local oil_delivery = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"oil_delivery"))
	if(oil_delivery >= 10)then
		if(getQuest(client,30) <= 1)then
			Quest.finishQuest(client,30)
			giveRadioData(client,15)
			NPC.NormalMessage(client,getText(client,"SOilDeliveryQuest2"))
			triggerClientEvent(client,"Outfits.closeQuestWindow",client)
		end
	else
		NPC.NormalMessage(client,getText(client,"SOilDeliveryQuest1"))
	end
end)

addEvent("VehicleDismantlingQuest",true)
addEventHandler("VehicleDismantlingQuest",root,function()
	if(hasPlayerItem(client,70) >= 5 and hasPlayerItem(client,71) >= 20)then
		if(getQuest(client,31) <= 1)then
			local vehicle_slots = getPlayerData("characters","ID",getCharacterID(client),"vehicle_slots")
			dbExec(handler,"UPDATE characters SET vehicle_slots = '"..vehicle_slots + 2 .."' WHERE ID = '"..getCharacterID(client).."'")
			Quest.finishQuest(client,31)
			NPC.NormalMessage(client,getText(client,"SVehicleDismantlingQuest2"))
			triggerClientEvent(client,"Outfits.closeQuestWindow",client)
		end
	else
		NPC.NormalMessage(client,getText(client,"SVehicleDismantlingQuest1"))
	end
end)

function loadPlayerOutfits(player)
    local outfitString = getPlayerData("characters", "ID", getCharacterID(player), "outfits")
    if(outfitString)then
        PlayerOutfits[player] = {}
		if(#outfitString >= 1)then
		local outfitPairs = split(outfitString, "|")
			for _, v in ipairs(outfitPairs)do
				local outfitInfo = split(v, "|")
				local outfitID = tonumber(outfitInfo[1])
				table.insert(PlayerOutfits[player], {outfit = outfitID, amount = 1})
			end
		end
    end
	updateClientOutfits(player)
end

function updateClientOutfits(player)
	triggerClientEvent(player,"updateClientOutfits", player, PlayerOutfits[player])
end

addEvent("onPlayerOutfitDoubleClicked",true)
addEventHandler("onPlayerOutfitDoubleClicked",root,function(id)
	local id = tonumber(id)
	if(id == 1)then
		addPedClothes(client,"policetr","policetr",17)
	elseif(id == 2)then
		addPedClothes(client,"countrytr","countrytr",17)
	elseif(id == 3)then
		addPedClothes(client,"balaclava","balaclava",17)
	elseif(id == 4)then
		addPedClothes(client,"garageleg","garagetr",17)
	elseif(id == 5)then
		setElementModel(client,64)
	end
end)

addEvent("removePlayerOutfit",true)
addEventHandler("removePlayerOutfit",root,function(id)
	local id = tonumber(id)
	if(id == 1)then
		removePedClothes(client,17,"policetr","policetr")
	elseif(id == 2)then
		removePedClothes(client,17,"countrytr","countrytr")
	elseif(id == 3)then
		removePedClothes(client,17,"balaclava","balaclava")
	elseif(id == 4)then
		removePedClothes(client,17,"garageleg","garagetr")
	elseif(id == 5)then
		setElementModel(client,0)
		loadPlayerClothes(client)
	end
end)

function checkOutfitBonus(player)
	if(player and getElementType(player) == "player")then
		local bonus = 0
		local texture, model = getPedClothes(player,17)
		if(getElementModel(player) == 64)then
			bonus = bonus + 15
			giveHalloweenPumpkin(player,1)
		else
			if(texture and model)then
				if(texture == "policetr" and model == "policetr")then
					bonus = bonus + 10
				elseif(texture == "countrytr" and model == "countrytr")then
					bonus = bonus + 10
				elseif(texture == "balaclava" and model == "balaclava")then
					bonus = bonus + 10
				elseif(texture == "garageleg" and model == "garagetr")then
					bonus = bonus + 10
				end
			end
		end
		return bonus
	end
end