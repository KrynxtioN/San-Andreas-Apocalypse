Nests = {

	Marker = {},
	Data = {},
	BindKey = {},
	PlayerTimer = {},
	
	["Coordinates"] = {
		{-395.36968994141,1241.9760742188,5.858099937439,4},
		{2876.6560058594,-2124.5776367188,3.9080998897552,4},
		{-2533.9814453125,-2143.5200195312,30.975324630737,4},
		{-2551.7138671875,-2673.5578613281,7.701000213623,4},
		{-2018.1905517578,-2553.2770996094,29.772899627686,4},
		{-1849.1796875,-2339.6860351562,36.879501342773,4},
		{-1968.8382568359,-1588.5570068359,87.395599365234,4},
		{-1315.4656982422,-2409.1618652344,24.593700408936,4},
		{-311.70901489258,-2095.583984375,27.977800369263,5},
		{-710.67022705078,-2779.4819335938,51.288200378418,4},
		{-1038.5871582031,-2097.8005371094,49.96960067749,4},
		{-702.701171875,-2188.1623535156,20.333099746704,5},
		{-777.29302978516,-1855.8450927734,11.524299621582,5},
		{399.89370727539,-1890.1732177734,0.89170002937317,4},
		{1005.7570800781,-2112.7016601562,12.393799781799,5},
		{1274.3770751953,-2356.2111816406,12.252200126648,4},
		{1433.1551513672,-1921.3924560547,13.888899803162,4},
		{1699.8721923828,-1797.7227783203,12.621899604797,4},
	},
}

local Achievements = {
	{1,138},
	{5,139},
	{10,140},
	{25,141},
	{50,142},
	{100,143},
}

function Nests.load()
	for i,v in ipairs(Nests["Coordinates"])do
		Nests.Marker[i] = createMarker(v[1],v[2],v[3],"cylinder",v[4],0,0,0,0)
		apocalypseSetElementData(Nests.Marker[i],"NestID",i)
		
		addEventHandler("onMarkerHit",Nests.Marker[i],function(player)
			if(not(isPedInVehicle(player)))then
				if(getElementInterior(player) == 0 and getElementDimension(player) == 0)then
					if(Nests.Data[apocalypseGetElementData(source,"NestID")].dynamite == 0)then
						triggerClientEvent(player,"createActivitiesInformationText",player,getText(player,"SNests1"))
					end
				end
			end
		end)
		
		Nests.Data[i] = {
			dynamite = 0,
			bombObject = nil,
			explodeTimer = nil,
			Zombies = {},
		}
	end
end
Nests.load()

addEventHandler("onPlayerWasted", root, function()
	local player = source
	if(Nests.PlayerTimer[player] and isTimer(Nests.PlayerTimer[player])) then
		killTimer(Nests.PlayerTimer[player])
		Nests.PlayerTimer[player] = nil
	end
	if(Nests.BindKey[player]) then
		unbindKey(player,"e","down",Nests.placeDynamite)
		Nests.BindKey[player] = false
	end
end)

function Nests.placeDynamite(player)
	for _, v in pairs(Nests.Marker)do
		if(isElementWithinMarker(player,v))then
			local ID = apocalypseGetElementData(v,"NestID")
			if(Nests.Data[ID] and Nests.Data[ID].dynamite == 0)then
				if(hasPlayerItem(player,26) >= 1)then
					if(not(isTimer(Nests.PlayerTimer[player])))then
						takeItem(player,26,1)
						Nests.Data[ID].dynamite = 1
						setElementFrozen(player,true)
						toggleAllControls(player,false)
						setPedAnimation(player,"BOMBER","BOM_Plant_Loop")
						triggerClientEvent(player,"createProgressBar",player,5)

						Nests.PlayerTimer[player] = setTimer(function(player,ID)
							if not isElement(player) then return end
							local x, y, z = getElementPosition(player)
							Nests.Data[ID].bombObject = createObject(1654,x-0.5,y,z-0.85,-90,0,0)
							setElementCollisionsEnabled(Nests.Data[ID].bombObject,false)

							Nests.Data[ID].explodeTimer = setTimer(function(player,ID)
								local x,y,z = getElementPosition(Nests.Marker[ID])
								createExplosion(x,y,z,10)
								if isElement(Nests.Data[ID].bombObject) then destroyElement(Nests.Data[ID].bombObject) end

								local totalZombies = 25
								local batchSize = 5
								local spawned = 0
								Nests.Data[ID].Zombies = {}

								local function spawnBatch()
									for i = 1, batchSize do
										if spawned < totalZombies then
											spawned = spawned + 1
											Nests.Data[ID].Zombies[spawned] = createZombie(
												x + math.random(1,3),
												y + math.random(1,3),
												z
											)
											apocalypseSetElementData(Nests.Data[ID].Zombies[spawned],"nestZombie",true)
										end
									end
									if spawned < totalZombies then
										setTimer(spawnBatch,2500,1)
									end
								end
								spawnBatch()

								triggerClientEvent(player,"createInformationMessage",player,getText(player,"SNests2"))
								
								local Level_Bonus_EXP = tonumber(apocalypseGetElementData(player,"level"))
								if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end	
							
								local exp_amount = 750 + (Level_Bonus_EXP * 25)
								local amount_skillpoints = 15
								if(SERVERBONUS.ZOMBIE_NESTS == true)then
									exp_amount = exp_amount * 2
									amount_skillpoints = amount_skillpoints * 2
								end
								giveEXP(player,exp_amount)
								givePlayerSkillpoint(player,amount_skillpoints)
								outputLog(getPlayerName(player).." hat ein Zombie Nest zerstört und "..exp_amount.." Erfahrungspunkte und "..amount_skillpoints.." Skillpunkte erhalten","Zombie Nests", getCharacterID(player))

								local destroyed_nest = tonumber(getPlayerData("character_stats","character_id",getCharacterID(player),"destroyed_nest"))
								Characters.addStats(player,"destroyed_nest",destroyed_nest + 1)

								if(DailyTasks.playerTasks[player][10])then
									DailyTasks.updateProgress(player,10,DailyTasks.playerTasks[player][10].progress + 1)
								end
								if(WeeklyTasks.playerTasks[player][10])then
									WeeklyTasks.updateProgress(player,10,WeeklyTasks.playerTasks[player][10].progress + 1)
								end

								for _,v in pairs(Achievements)do
									if(destroyed_nest + 1 >= v[1])then
										setAchievement(player,v[2])
									end
								end

								setTimer(function(ID)
									Nests.Data[ID].dynamite = 0
								end,600000,1,ID)

							end,5000,1,player,ID)

							setElementFrozen(player,false)
							toggleAllControls(player,true)
							setPedAnimation(player)
							NPC.MeMessage(player,getText(player,"MeMessage8"))

						end,5000,1,player,ID)
					end
				else
					NPC.MeMessage(player,getText(player,"MeMessage7"))
				end
			else
				createInfobox(player,getText(player,"SNests3"))
			end
			break
		end
	end
end

function Nests.bindKey(player)
	if(not(Nests.BindKey[player]))then
		bindKey(player,"e","down",Nests.placeDynamite)
		Nests.BindKey[player] = true
	end
end

addEventHandler("onPlayerQuit",root,function()
	if(Nests.BindKey[source]) then
		unbindKey(source,"e","down",Nests.placeDynamite)
		Nests.BindKey[source] = false
	end
end)