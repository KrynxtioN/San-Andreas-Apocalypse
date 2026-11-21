HalloweenChest = {}

addEvent("HalloweenChest.Open",true)
addEventHandler("HalloweenChest.Open",root,function(ChestID)
	local ChestID = tonumber(ChestID)
	local Level_Bonus_EXP = tonumber(apocalypseGetElementData(client,"level"))
	if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
	local Bonus_EXP = 250 * Level_Bonus_EXP
	if(ChestID == 1)then
		local result = tonumber(getPlayerData("halloween_data","character_id",getCharacterID(client),"chest1"))
		if(result == 0)then
			if(hasPlayerItem(client,188) >= 1)then
				giveEXP(client,25000 + Bonus_EXP)
				giveItem(client,12,1000)
				giveItem(client,18,100)
				givePlayerServerMoney(client,5000)
				NPC.NormalMessage(client,getText(client,"SHalloweenChest3"))
				dbExec(handler,"UPDATE halloween_data SET chest1 = '1' WHERE character_id = '"..getCharacterID(client).."'")
			else
				NPC.NormalMessage(client,getText(client,"SHalloweenChest2"))
			end
		else
			NPC.NormalMessage(client,getText(client,"SHalloweenChest1"))
		end
	end
	if(ChestID == 2)then
		local result = tonumber(getPlayerData("halloween_data","character_id",getCharacterID(client),"chest2"))
		if(result == 0)then
			if(hasPlayerItem(client,188) >= 1)then
				giveEXP(client,50000 + Bonus_EXP)
				giveItem(client,12,2500)
				giveItem(client,18,250)
				givePlayerServerMoney(client,10000)
				NPC.NormalMessage(client,getText(client,"SHalloweenChest3"))
				dbExec(handler,"UPDATE halloween_data SET chest2 = '1' WHERE character_id = '"..getCharacterID(client).."'")
			else
				NPC.NormalMessage(client,getText(client,"SHalloweenChest2"))
			end
		else
			NPC.NormalMessage(client,getText(client,"SHalloweenChest1"))
		end
	end
	if(ChestID == 3)then
		local result = tonumber(getPlayerData("halloween_data","character_id",getCharacterID(client),"chest1"))
		if(result == 0)then
			if(hasPlayerItem(client,188) >= 1)then
				giveEXP(client,75000 + Bonus_EXP)
				giveItem(client,12,5000)
				giveItem(client,18,500)
				givePlayerServerMoney(client,20000)
				givePlayerOutfit(client,5)
				NPC.NormalMessage(client,getText(client,"SHalloweenChest3"))
				dbExec(handler,"UPDATE halloween_data SET chest3 = '1' WHERE character_id = '"..getCharacterID(client).."'")
			else
				NPC.NormalMessage(client,getText(client,"SHalloweenChest2"))
			end
		else
			NPC.NormalMessage(client,getText(client,"SHalloweenChest1"))
		end
	end
end)