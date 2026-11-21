Mining = { Marker = {}, Timer = {},
	["MarkerPos"] = {
		[1] = {1180.1170654297,188.98760986328,-4.8399376869202,180},
		[2] = {1176.4741210938,165.1376953125,-6.4882974624634,90},
		[3] = {1157.9415283203,161.7854309082,-9.0371923446655,102},
		[4] = {1142.9761962891,202.70260620117,-8.8768358230591,310},
		[5] = {1119.1439208984,207.24128723145,-11.31173324585,174},
		[6] = {1092.7843017578,246.4154510498,-10.171684265137,111},
		[7] = {1081.8717041016,272.21206665039,-7.1419458389282,329},
		[8] = {1072.7766113281,256.14117431641,-6.5082321166992,294},
		[9] = {1063.4627685547,237.51876831055,-4.8399376869202,312},
		[10] = {1046.3897705078,256.81231689453,-4.8399376869202,170},
	},
}

local Achievements = {
	{1,203},
	{5,204},
	{10,205},
	{25,206},
	{50,207},
	{75,208},
	{125,209},
	{175,210},
	{250,211},
}

local possibleMiningItemsDiamonds = {87,88,89,90,91}

for i,v in pairs(Mining["MarkerPos"])do
	Mining.Marker[i] = createMarker(v[1],v[2],v[3],"corona",1.25,255,255,255,100)
	apocalypseSetElementData(Mining.Marker[i],"MiningMarkerID",i)
	apocalypseSetElementData(Mining.Marker[i],"PlayerInMarker",false)
	
	addEventHandler("onMarkerHit",Mining.Marker[i],function(player)
		if(getElementType(player) == "player")then
			if(not(apocalypseGetElementData(player,"MiningMarker")))then
				if(not(isPedInVehicle(player)))then
					if(getElementDimension(player) == getElementDimension(source))then
						if(apocalypseGetElementData(source,"PlayerInMarker") ~= true)then
							local MiningMarkerID = apocalypseGetElementData(source,"MiningMarkerID")
							local tbl = Mining["MarkerPos"][MiningMarkerID]
							apocalypseSetElementData(source,"PlayerInMarker",true)
							apocalypseSetElementData(player,"MiningMarker",source)
							setElementPosition(player,tbl[1],tbl[2],tbl[3])
							setElementRotation(player,0,0,tbl[4])
							setElementFrozen(player,true)
							toggleAllControls(player,false)
							bindKey(player,"e","down",Mining.start)
							bindKey(player,"backspace","down",Mining.stop)
							triggerClientEvent(player,"createActivitiesInformationText",player,getText(player,"SMining1"))
							triggerClientEvent(player,"mining.setStuff",player)
							triggerClientEvent(player,"JobInformation.createWindow",player,6)
						end
					end
				end
			end
		end
	end)
end

function Mining.start(player)
	if(not(isTimer(Mining.Timer[player])))then
		if(hasPlayerItem(player,102) >= 1)then
			setTimer(function(player)
				giveWeapon(player,5,1,true)
			end,50,1,player)
			setPedAnimation(player,"baseball","Bat_1")
			triggerClientEvent(player, "startMiningMinigame", player)
			Mining.Timer[player] = setTimer(function() end, 12500, 1)
		else
			NPC.MeMessage(player,getText(player,"MeMessage17"))
		end
	end
end

addEvent("onClientMiningSuccess", true)
addEventHandler("onClientMiningSuccess", root, function()
	if client and isElement(client) then
		if(isTimer(Mining.Timer[client]))then
			killTimer(Mining.Timer[client])
			Mining.giveItem(client)
		end
	end
end)

function Mining.stop(player)
	if(isTimer(Mining.Timer[player]))then killTimer(Mining.Timer[player])end
	setPedAnimation(player)
	setElementFrozen(player,false)
	toggleAllControls(player,true)
	takeAllWeapons(player)
	unbindKey(player,"e","down",Mining.start)
	unbindKey(player,"backspace","down",Mining.stop)
	triggerClientEvent(player,"miningGame.close",player,true)
	if(apocalypseGetElementData(player,"MiningMarker"))then
		local marker = apocalypseGetElementData(player,"MiningMarker")
		apocalypseSetElementData(marker,"PlayerInMarker",false)
		apocalypseSetElementData(player,"MiningMarker",nil)
	end
end

function Mining.giveItem(player)
	local chance = math.random(1,100)

	local EXP = 0
	local Level_Bonus_EXP = tonumber(apocalypseGetElementData(player,"level"))
	if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
	
	if(chance <= 3)then
		EXP = 25 + (Level_Bonus_EXP * 5)
		if(SERVERBONUS.JOB_ACTIVITIES == true)then EXP = EXP * 2 end
		local item = possibleMiningItemsDiamonds[math.random(1,#possibleMiningItemsDiamonds)]
		giveItem(player,item,1)
		NPC.MeMessage(player,getText(player,"SMining3"))
		giveEXP(player,EXP)
		triggerClientEvent(client, "showItemBar", client, {{67,item}})
	else
		EXP = 5 + (Level_Bonus_EXP * 1)
		if(chance > 3 and chance <= 80)then
			local amount = math.random(2,4)
			giveItem(player,86,amount)
			NPC.MeMessage(player,getText(player,"SMining2"):format(amount))
			triggerClientEvent(client, "showItemBar", client, {{86,amount}})
		elseif(chance >= 81 and chance <= 100)then
			if(math.random(1,3) == 2)then
				giveItem(player,115,1)
				triggerClientEvent(client, "showItemBar", client, {{115,1}})
				NPC.MeMessage(player,getText(player,"SMining5"))
			else
				giveItem(player,114,1)
				triggerClientEvent(client, "showItemBar", client, {{114,1}})
				NPC.MeMessage(player,getText(player,"SMining4"))
			end
		end
		if(SERVERBONUS.JOB_ACTIVITIES == true)then EXP = EXP * 2 end
		giveEXP(player,EXP)
	end
	local skillpoints = 2
	if(SERVERBONUS.JOB_ACTIVITIES == true)then skillpoints = skillpoints + 2 end
	givePlayerSkillpoint(player,skillpoints)
	setPedAnimation(player)
	local miningPoints = tonumber(getPlayerData("character_stats","character_id",getCharacterID(player),"mining"))
	Characters.addStats(player,"mining",miningPoints + 1)
	outputLog(getPlayerName(player).." hat etwas in der Mine gefunden und "..skillpoints.." Skillpunkte und "..xp.." Erfahrungspunkte erhalten", "Mining", getCharacterID(player))
	
	if(DailyTasks.playerTasks[player][17])then
		DailyTasks.updateProgress(player,17,DailyTasks.playerTasks[player][17].progress + 1)
	end
	
	if(WeeklyTasks.playerTasks[player][17])then
		WeeklyTasks.updateProgress(player,17,WeeklyTasks.playerTasks[player][17].progress + 1)
	end
	
	for _,v in pairs(Achievements)do
		if(miningPoints + 1 >= v[1])then
			setAchievement(player,v[2])
		end
	end
end

addEventHandler("onPlayerQuit",root,function()
	Mining.stop(source)
end)

addEventHandler("onPlayerWasted",root,function()
	Mining.stop(source)
end)