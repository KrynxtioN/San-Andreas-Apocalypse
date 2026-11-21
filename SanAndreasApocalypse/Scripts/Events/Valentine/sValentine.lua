ValentinesDay = {
	["Costs"] = {
		[1] = 500,
		[2] = 1000,
		[3] = 2000,
		[4] = 3000,
		[5] = 3500,
		[6] = 5000,
		[7] = 6500,
		[8] = 8000,
		[9] = 9000,
		[10] = 11500,
	},
	["EXP"] = {
		[1] = 1250,
		[2] = 2500,
		[3] = 5000,
		[4] = 7500,
		[5] = 8750,
		[6] = 12500,
		[7] = 16250,
		[8] = 20000,
		[9] = 22500,
		[10] = 28750,
	},
}

addCommandHandler("resetValentineEvent",function(player)
	dbExec(handler,"UPDATE character_stats SET valentine_coins = '0', valentine_quest_finished = '0', valentine_task = '0', valentine_collected_chocolate = '0'")
end)

function giveValentineItem(player,amount)
	if(ServerTime.GameDay == 6 or ServerTime.GameDay == 7)then amount = amount + 1 end
	triggerClientEvent(player,"ValentineAmountChange",player,hasPlayerItem(player,85)+amount)
	local collected = getPlayerData("server_event_data","ID",1,"community_progress")
	dbExec(handler,"UPDATE server_event_data SET community_progress = '"..collected + amount.."' WHERE ID = 1")
	local player_collected = getPlayerData("character_stats","character_id",getCharacterID(player),"valentine_collected_chocolate")
	dbExec(handler,"UPDATE character_stats SET valentine_collected_chocolate = '"..player_collected + amount.."' WHERE character_id = '"..getCharacterID(player).."'")
	giveItem(player,85,amount)
end

function ValentinesDay.getData(player)
	if(not(player))then player = client end
	local communityProgress = getPlayerData("server_event_data","ID",1,"community_progress")
	local playerCoins = getPlayerData("character_stats","character_id",getCharacterID(player),"valentine_coins")
	local questFinished = getPlayerData("character_stats","character_id",getCharacterID(player),"valentine_quest_finished")
	local task = getPlayerData("character_stats","character_id",getCharacterID(player),"valentine_task")
	
	local topPlayer = {}
	local result = dbPoll(dbQuery(handler,"SELECT character_id, valentine_collected_chocolate FROM character_stats ORDER BY valentine_collected_chocolate + 0 DESC LIMIT 10;"),-1)
	if(result and #result >= 1)then
		for i,v in ipairs(result)do
			local name = getPlayerData("characters","ID",v["character_id"],"name")
			table.insert(topPlayer,{name,v["valentine_collected_chocolate"]})
		end
	end
	
	triggerClientEvent(player,"ValentinesDay.UpdateData",player,communityProgress,playerCoins,questFinished,task,topPlayer)
end
addEvent("ValentinesDay.getData",true)
addEventHandler("ValentinesDay.getData",root,ValentinesDay.getData)

addEvent("ValentinesDay.nextLevel",true)
addEventHandler("ValentinesDay.nextLevel",root,function()
	local lvl = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"valentine_task"))
	local nextLevel = lvl + 1
	local costs = ValentinesDay["Costs"][nextLevel]
	
	if(costs)then
		if(hasPlayerItem(client,85) >= tonumber(costs))then
			takeItem(client,85,costs)
			dbExec(handler,"UPDATE character_stats SET valentine_task = '"..nextLevel.."' WHERE character_id = '"..getCharacterID(client).."'")
			local EventCoins = 0
			if(nextLevel == 1)then
				EventCoins = 20
			end
			if(nextLevel == 2)then
				EventCoins = 30
			end
			if(nextLevel == 3)then
				EventCoins = 50
			end
			if(nextLevel == 4)then
				EventCoins = 70
			end
			if(nextLevel == 5)then
				EventCoins = 90
			end
			if(nextLevel == 6)then
				EventCoins = 110
			end
			if(nextLevel == 7)then
				EventCoins = 130
			end
			if(nextLevel == 8)then
				EventCoins = 150
			end
			if(nextLevel == 9)then
				EventCoins = 170
			end
			if(nextLevel == 10)then
				EventCoins = 180
			end
			local playerCoins = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"valentine_coins"))
			dbExec(handler,"UPDATE character_stats SET valentine_coins = '"..playerCoins + EventCoins.."' WHERE character_id = '"..getCharacterID(client).."'")
			giveEXP(client,ValentinesDay["EXP"][nextLevel])
			createInfobox(client,getText(client,"SValentineDay2"))
			ValentinesDay.getData(client)
		else
			createInfobox(client,getText(client,"SValentineDay1"))
		end
	end
end)

addEvent("ValentinesDay.startQuest",true)
addEventHandler("ValentinesDay.startQuest",root,function()

end)

addEvent("ValentinesDay.buyVehicle",true)
addEventHandler("ValentinesDay.buyVehicle",root,function(VehicleModel,Price)
	local VehicleModel, Price = tonumber(VehicleModel), tonumber(Price)
	local playerCoins = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"valentine_coins"))
	if(VehicleModel == 495 or VehicleModel == 444)then
		local collected = tonumber(getPlayerData("server_event_data","ID",1,"community_progress"))
		if(collected < 100000)then
			createInfobox(client,getText(client,"SValentineDay5"))
			return
		end
	end
	
	if(playerCoins >= Price)then
		if(checkPlayerVehicleFreeSlot(client) == true)then
			dbExec(handler,"UPDATE character_stat SET valentine_coins = '"..playerCoins - Price.."' WHERE character_id = '"..getCharacterID(client).."'")
			addPlayerVehicle(client,model)
			setAchievement(client,56)
			triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SVehicles5"))
		else triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SVehicles4"))end
	else triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SValentineDay6"))end
end)

addEvent("ValentinesDay.buyItem",true)
addEventHandler("ValentinesDay.buyItem",root,function(Price,Item)
	local Price, Item = tonumber(Price), tonumber(Item)
	local playerCoins = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"valentine_coins"))
	local collected = tonumber(getPlayerData("server_event_data","ID",1,"community_progress"))
	if(playerCoins >= Price)then
		dbExec(handler,"UPDATE character_stats SET valentine_coins = '"..playerCoins - Price.."' WHERE character_id = '"..getCharacterID(client).."'")
		if(Item == 1)then
			apocalypseSetElementData(client, "freespins", apocalypseGetElementData(client, "freespins")+5)
			createInfobox(client,getText(client,"SValentineDay3"))
		end
		if(Item == 2)then
			local couponID = math.random(1,3)
			local itemID = 0
			if(couponID == 1)then itemID = 15 end
			if(couponID == 2)then itemID = 16 end
			if(couponID == 3)then itemID = 17 end
			if(item ~= 0)then
				giveItem(client,itemID,1)
				createInfobox(client,getText(client,"SValentineDay3"))
			end
		end
		if(Item == 3)then
			giveItem(client,74,1)
			createInfobox(client,getText(client,"SValentineDay3"))
		end
		if(Item == 4)then
			giveItem(client,77,1)
			createInfobox(client,getText(client,"SValentineDay3"))
		end
		if(Item == 5)then
			giveItem(client,68,1)
			createInfobox(client,getText(client,"SValentineDay3"))
		end
		if(Item == 6)then
			giveItem(client,69,1)
			createInfobox(client,getText(client,"SValentineDay3"))
		end
		if(Item == 7)then
			giveItem(client,93,1)
			createInfobox(client,getText(client,"SValentineDay3"))
		end
		if(Item == 8)then
			setStatus(client,3)
			createInfobox(client,getText(client,"SValentineDay3"))
		end
		if(Item == 9)then
			if(collected >= 10000)then
				local status = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"valentine_bonus_1"))
				if(status == 0)then
					if(hasPlayerStatus(client,4) ~= false)then return end
					local Level_Bonus_EXP = tonumber(apocalypseGetElementData(client,"level"))
					if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
					local experience = 7500 + (250 * Level_Bonus_EXP)
					giveEXP(client,experience)
					setStatus(client,4)
					createInfobox(client,getText(client,"SValentineDay8"):format(experience))
					dbExec(handler,"UPDATE character_stats SET valentine_bonus_1 = '1' WHERE character_id = '"..getCharacterID(client).."'")
				else
					createInfobox(client,getText(client,"SValentineDay7"))
				end
			else
				createInfobox(client,getText(client,"SValentineDay12"))
			end
		end
		if(Item == 10)then
			if(collected >= 25000)then
				local status = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"valentine_bonus_2"))
				if(status == 0)then
					local Level_Bonus_EXP = tonumber(apocalypseGetElementData(client,"level"))
					if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
					local experience = 12500 + (300 * Level_Bonus_EXP)
					giveEXP(client,experience)
					local vehicle_slots = getPlayerData("characters","ID",getCharacterID(client),"vehicle_slots")
					dbExec(handler,"UPDATE characters SET vehicle_slots = '"..vehicle_slots + 1 .."' WHERE ID = '"..getCharacterID(client).."'")
					createInfobox(client,getText(client,"SValentineDay9"):format(experience))
					dbExec(handler,"UPDATE character_stats SET valentine_bonus_2 = '1' WHERE character_id = '"..getCharacterID(client).."'")
				else
					createInfobox(client,getText(client,"SValentineDay7"))
				end
			else
				createInfobox(client,getText(client,"SValentineDay13"))
			end
		end
		if(Item == 11)then
			if(collected >= 50000)then
				local status = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"valentine_bonus_3"))
				if(status == 0)then
					local Level_Bonus_EXP = tonumber(apocalypseGetElementData(client,"level"))
					if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
					local experience = 20000 + (350 * Level_Bonus_EXP)
					giveEXP(client,experience)
					local money = 1250 * Level_Bonus_EXP
					givePlayerServerMoney(money)
					createInfobox(client,getText(client,"SValentineDay10"):format(money,experience))
					dbExec(handler,"UPDATE character_stats SET valentine_bonus_3 = '1' WHERE character_id = '"..getCharacterID(client).."'")
				else
					createInfobox(client,getText(client,"SValentineDay7"))
				end
			else
				createInfobox(client,getText(client,"SValentineDay14"))
			end
		end
		if(Item == 12)then
			if(collected >= 100000)then
				local status = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"valentine_bonus_4"))
				if(status == 0)then
					local Level_Bonus_EXP = tonumber(apocalypseGetElementData(client,"level"))
					if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end

					local experience = 25000 + (400 * Level_Bonus_EXP)
					giveEXP(client,experience)
					createInfobox(client,getText(client,"SValentineDay11"):format(experience))
					dbExec(handler,"UPDATE character_stats SET valentine_bonus_4 = '1', valentine_coins = '"..playerCoins + 250 .."' WHERE character_id = '"..getCharacterID(client).."'")
				else
					createInfobox(client,getText(client,"SValentineDay7"))
				end
			else
				createInfobox(client,getText(client,"SValentineDay15"))
			end
		end
	else triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SValentineDay6"))end
end)

addEvent("spawnPlayerValentine",true)
addEventHandler("spawnPlayerValentine",root,function(x,y,z)
	setElementPosition(client,x,y,z)
end)