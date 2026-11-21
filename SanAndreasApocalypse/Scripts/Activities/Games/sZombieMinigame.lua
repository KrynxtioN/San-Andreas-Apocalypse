ZombieMinigame = {killedZombies = {}, activeGame = {}, timer = {}}

setTimer(function()
	for _,v in pairs(getElementsByType("player"))do
		if(isCharacterLoggedIn(v))then
			ZombieMinigame.setData(v)
		end
	end
end,1800000,0)

function ZombieMinigame.setData(player)
	if(not(ZombieMinigame.activeGame[player]))then
		ZombieMinigame.activeGame[player] = true
		ZombieMinigame.killedZombies[player] = 0
		
		local Level_Bonus_EXP = tonumber(apocalypseGetElementData(player,"level"))
		if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
		
		local money, EXP = 15 * Level_Bonus_EXP, 50 * Level_Bonus_EXP
		if(SERVERBONUS.ZOMBIE_KILLGAME == true)then
			money = money * 2
			EXP = EXP * 2
		end
		
		outputChatBox(getText(player,"SZombieMinigame2"):format(money,EXP),player,0,200,0)
		setAchievement(player,407)
		
		ZombieMinigame.timer[player] = setTimer(function(player)
			ZombieMinigame.delData(player)
			outputChatBox(getText(player,"SZombieMinigame3"),player,200,0,0)
		end,600000,1,player)
	end
end

function ZombieMinigame.addZombie(player)
	if(ZombieMinigame.activeGame[player])then
		ZombieMinigame.killedZombies[player] = ZombieMinigame.killedZombies[player] + 1
		triggerClientEvent(player,"showFloatingText", player, ZombieMinigame.killedZombies[player].."/200", 255,255,255)
		if(ZombieMinigame.killedZombies[player] >= 200)then
			local Level_Bonus_EXP = tonumber(apocalypseGetElementData(player,"level"))
			if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
		
			local money, EXP = 15 * Level_Bonus_EXP, 50 * Level_Bonus_EXP
			if(SERVERBONUS.ZOMBIE_KILLGAME == true)then
				money = money * 2
				EXP = EXP * 2
			end
			givePlayerServerMoney(player,money)
			giveEXP(player,EXP)
			ZombieMinigame.delData(player)
			setAchievement(player,408)
			outputChatBox(getText(player,"SZombieMinigame1"):format(money,EXP),player,0,200,0)
			outputLog(getPlayerName(client).." hat ein Zombie Kill Challenge beendet und $"..money.." und "..EXP.." EXP bekommen","Zombie Kill Challenge",getCharacterID(client))
		end
	end
end

function ZombieMinigame.delData(player)
	ZombieMinigame.killedZombies[player] = nil
	ZombieMinigame.activeGame[player] = nil
	if(isTimer(ZombieMinigame.timer[player]))then
		killTimer(ZombieMinigame.timer[player])
	end
	ZombieMinigame.timer[player] = nil
end

addEventHandler("onPlayerQuit",root,function()
	ZombieMinigame.delData(source)
end)