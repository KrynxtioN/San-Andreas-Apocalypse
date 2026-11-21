Payday = {Timer = {}}

local Achievements = {
	{60,10},
	{300,111},
	{600,112},
	{1500,113},
	{3000,114},
	{6000,115},
	{15000,116},
	{30000,117},
	{60000,118},
}

function Payday.CreateTimer(player)
	if(not(Payday.Timer[player]))then
		Payday.Timer[player] = setTimer(function(player)
			if(isElement(player))then
				apocalypseSetElementData(player,"playtime",apocalypseGetElementData(player,"playtime")+1)
				local WeekTime = getPlayerData("character_stats","character_id",getCharacterID(player),"WeekTime")
				dbExec(handler,"UPDATE character_stats SET WeekTime = '"..WeekTime + 1 .."' WHERE character_id = '"..getCharacterID(player).."'")
				apocalypseSetElementData(player,"WeekTime",WeekTime + 1)
				if(apocalypseGetElementData(player,"AFK") == true)then
					local WeekTimeAFK = getPlayerData("character_stats","character_id",getCharacterID(player),"WeekTime")
					dbExec(handler,"UPDATE character_stats SET WeekTimeAFK = '"..WeekTimeAFK + 1 .."' WHERE character_id = '"..getCharacterID(player).."'")
					apocalypseSetElementData(player,"WeekTimeAFK",WeekTimeAFK+1)
				end
				
				for _,v in pairs(Achievements)do
					if(apocalypseGetElementData(player,"playtime") >= v[1])then
						setAchievement(player,v[2])
					end
				end
				
				if(isNoFoodTimerActive(player) == false)then
					if(math.random(1,3) == 2)then
						takeHunger(player,1)
					end
				end
				
				if(isNoThirstTimerActive(player) == false)then
					if(math.random(1,3) == 2)then
						takeThirst(player,1)
					end
				end
				
				if(apocalypseGetElementData(player,"player_muscles") > 0)then apocalypseSetElementData(player,"player_muscles",apocalypseGetElementData(player,"player_muscles")-1) end
				if(apocalypseGetElementData(player,"player_muscles") == 0 and apocalypseGetElementData(player,"player_fat") < 1000)then
					apocalypseSetElementData(player,"player_fat",apocalypseGetElementData(player,"player_fat")+1)
				end
				
				if(math.floor(apocalypseGetElementData(player,"playtime")/60) == (apocalypseGetElementData(player,"playtime")/60))then
					if(HalloweenEvent == true)then
						HalloweenTotem.giveRewards(player)
					end
					
					if(apocalypseGetElementData(player,"playtime") < 300)then
						giveItem(player,26,2)
					end
					
					local Level_Bonus_EXP = tonumber(apocalypseGetElementData(player,"level"))
					if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
				
					local experiencepoints = (15 * Level_Bonus_EXP) + (50 * apocalypseGetElementData(player,"rank"))
					local money = (5 * Level_Bonus_EXP) + (25 * apocalypseGetElementData(player,"rank"))
					
					giveEXP(player,experiencepoints)
					givePlayerServerMoney(player,money)
					setAchievement(player,13)
					giveItem(player,14,1)
					
					if(tonumber(getPlayerData("character_stats","character_id",getCharacterID(player),"survivor_pass_abo")) == 1)then
						if(getPlayerBankMoney(player) >= 750)then
							takeMoneyFromPlayerBank(player,750)
							outputChatBox(getText(player,"SSurvivorPass17"),player,0,150,0)
						else
							outputChatBox(getText(player,"SSurvivorPass15"),player,150,0,0)
						end
					end
					
					triggerClientEvent(player,"Payday.create",player,experiencepoints,money)
					outputLog("[PAYDAY] "..getPlayerName(player).." ("..getCharacterID(player)..") hat einen Payday erhalten ("..experiencepoints.." EXP, $"..money..")","payday", getCharacterID(player))
					
					if(HalloweenEvent == true)then
						giveHalloweenPumpkin(player,25)
					end
					if(ChristmasEvent == true)then
						giveChristmasPresent(player,25)
					end
					if(ValentineEvent == true)then
						giveValentineItem(player,25)
					end
					if(EasterEvent == true)then
						giveEasterEgg(player,25)
					end
				end
				Characters.SaveData(player)
			end
		end,60000,0,player)
	end
end
addEvent("Payday.CreateTimer",true)
addEventHandler("Payday.CreateTimer",root,Payday.CreateTimer)