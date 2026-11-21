WeeklyRewards = {}

function WeeklyRewards.load(player)
	local Reward1, Reward2, Reward3 = getPlayerData("characters","ID",getCharacterID(player),"weekly_reward1"), getPlayerData("characters","ID",getCharacterID(player),"weekly_reward2"), getPlayerData("characters","ID",getCharacterID(player),"weekly_reward3")
	local Reward1, Reward2, Reward3 = tonumber(Reward1), tonumber(Reward2), tonumber(Reward3)
	if(Reward1 == 0)then apocalypseSetElementData(player,"WeeklyReward1",0) else apocalypseSetElementData(player,"WeeklyReward1",1) end
	if(Reward2 == 0)then apocalypseSetElementData(player,"WeeklyReward2",0) else apocalypseSetElementData(player,"WeeklyReward2",1) end
	if(Reward3 == 0)then apocalypseSetElementData(player,"WeeklyReward3",0) else apocalypseSetElementData(player,"WeeklyReward3",1) end
	triggerClientEvent(player,"WeeklyRewards.Load",player,Reward1,Reward2,Reward3)
end
addEvent("WeeklyRewards.load",true)
addEventHandler("WeeklyRewards.load",root,WeeklyRewards.load)

addEvent("WeeklyRewards.collect",true)
addEventHandler("WeeklyRewards.collect",root,function(Reward)
	local WeekTime = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"WeekTime"))
	local Reward = tonumber(Reward)
	if(Reward == 1)then
		if(WeekTime >= 300)then
			if(tonumber(apocalypseGetElementData(client,"WeeklyReward1")) == 0)then
				local Level_Bonus_EXP = tonumber(apocalypseGetElementData(client,"level"))
				if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
			
				local EXP = 50 * Level_Bonus_EXP
				local Money = 25 * Level_Bonus_EXP
				dbExec(handler,"characters SET WeeklyReward1 = '1' WHERE ID = '"..getCharacterID(client).."'")
				apocalypseSetElementData(client,"WeeklyReward1",1)
				giveEXP(client,EXP)
				givePlayerServerMoney(client,Money)
				giveLootItems(client,25)
				giveItem(client,26,5)
				triggerClientEvent(client, "showItemBar", client, {{26,5}})
				createInfobox(client,getText(client,"SWeeklyRewards5"))
			else
				createInfobox(client,getText(client,"SWeeklyRewards4"))
			end
		else
			createInfobox(client,getText(client,"SWeeklyRewards1"))
		end
	end
	if(Reward == 2)then
		if(WeekTime >= 600)then
			if(tonumber(apocalypseGetElementData(client,"WeeklyReward2")) == 0)then
				local Level_Bonus_EXP = tonumber(apocalypseGetElementData(client,"level"))
				if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
			
				local EXP = 100 * Level_Bonus_EXP
				local Money = 50 * Level_Bonus_EXP
				dbExec(handler,"characters SET WeeklyReward2 = '1' WHERE ID = '"..getCharacterID(client).."'")
				apocalypseSetElementData(client,"WeeklyReward2",1)
				giveEXP(client,EXP)
				givePlayerServerMoney(client,Money)
				giveLootItems(client,50)
				giveItem(client,26,10)
				triggerClientEvent(client, "showItemBar", client, {{26,10}})
				createInfobox(client,getText(client,"SWeeklyRewards5"))
			else
				createInfobox(client,getText(client,"SWeeklyRewards4"))
			end
		else
			createInfobox(client,getText(client,"SWeeklyRewards2"))
		end
	end
	if(Reward == 3)then
		if(WeekTime >= 900)then
			if(tonumber(apocalypseGetElementData(client,"WeeklyReward3")) == 0)then
				local Level_Bonus_EXP = tonumber(apocalypseGetElementData(client,"level"))
				if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
			
				local EXP = 150 * Level_Bonus_EXP
				local Money = 75 * Level_Bonus_EXP
				
				dbExec(handler,"characters SET WeeklyReward3 = '1' WHERE ID = '"..getCharacterID(client).."'")
				apocalypseSetElementData(client,"WeeklyReward3",1)
				giveEXP(client,EXP)
				givePlayerServerMoney(client,Money)
				giveLootItems(client,75)
				giveItem(client,26,15)
				triggerClientEvent(client, "showItemBar", client, {{26,15}})
				createInfobox(client,getText(client,"SWeeklyRewards5"))
			else
				createInfobox(client,getText(client,"SWeeklyRewards4"))
			end
		else
			createInfobox(client,getText(client,"SWeeklyRewards3"))
		end
	end
	WeeklyRewards.load(client)
end)