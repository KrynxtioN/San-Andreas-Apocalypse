LootableGarages = {Object = {}, GarageLoot = {}, PlayerSearched = {},
	["Garages"] = {
		[1] = {11102,631.51898193359,-452.08090209961,17.533000946045,0,0,0},
		[2] = {11102,1019.0991210938,-339.79348754883,75.157501220703,0,0,0},
		[3] = {11102,2247.3051757812,28.537799835205,27.590799331665,0,0,90},
		[4] = {11102,1353.40625,449.16088867188,21.201200485229,0,0,61.25},
		[5] = {11102,46.714900970459,-199.17300415039,2.3701999187469,0,0,87},
		[6] = {11102,-1996.8889160156,-36.899501800537,36.455200195312,0,0,0},
	},
	["Loot"] = {
		[1] = {
			{3066,624.11309814453,-453.79870605469,17.109899520874,0,0,0},
		},
		[2] = {
			{3066,1011.9334716797,-341.62969970703,74.046501159668,0,0,0},
		},
		[3] = {
			{3066,2249.0205078125,21.157899856567,26.526899337769,0,0,90},
		},
		[4] = {
			{3066,1351.3087158203,442.3039855957,20.190299987793,0,0,62},
		},
		[5] = {
			{3066,46.247798919678,-192.07620239258,1.6598000526428,0,0,87.25},
		},
		[6] = {
			{3066,-1989.7473144531,-36.140098571777,35.334098815918,0,0,0},
		},
	},
}

local Achievements = {
	{1,181},
	{5,182},
	{10,183},
	{25,184},
	{50,185},
	{75,186},
	{125,187},
	{200,188},
	{250,188},
}

function LootableGarages.load()
	for i,v in ipairs(LootableGarages["Garages"])do
		LootableGarages.Object[i] = createObject(v[1],v[2],v[3],v[4],v[5],v[6],v[7])
		local Object = LootableGarages.Object[i]
		apocalypseSetElementData(Object,"LootableGarage",true)
		apocalypseSetElementData(Object,"Lootable",true)
		apocalypseSetElementData(Object,"LootableGarageID",i)
	end
end
LootableGarages.load()

function LootableGarages.explode(ID)
	LootableGarages.GarageLoot[ID] = {}
	LootableGarages.PlayerSearched[ID] = {}
	local x,y,z = getElementPosition(LootableGarages.Object[ID])
	moveObject(LootableGarages.Object[ID],3500,x,y,z-5)
	
	for _,v in pairs(LootableGarages["Loot"][ID])do
		local loot = createObject(v[1],v[2],v[3],v[4],v[5],v[6],v[7])
		table.insert(LootableGarages.GarageLoot[ID],loot)
		apocalypseSetElementData(loot,"LootableGarage",true)
		apocalypseSetElementData(loot,"LootableGarageStatus",true)
		apocalypseSetElementData(loot,"LootableGarageID",ID)
	end
	
	setTimer(function(ID,x,y,z)
		for _,v in pairs(LootableGarages.GarageLoot[ID])do
			if(isElement(v))then
				destroyElement(v)
			end
		end
		LootableGarages.GarageLoot[ID] = {}
		moveObject(LootableGarages.Object[ID],3500,x,y,z)
	end,900000,1,ID,x,y,z)
	
	setTimer(function(ID)
		local Object = LootableGarages.Object[ID]
		apocalypseSetElementData(Object,"Lootable",true)
		LootableGarages.PlayerSearched[ID] = {}
	end,1800000,1,ID)
end

addEventHandler("onPlayerClick",root,function(button,state,clickedElement)
	if(isCharacterLoggedIn(source))then
		if(button == "left" and state == "down")then
			if(clickedElement and isElement(clickedElement))then
				if(apocalypseGetElementData(clickedElement,"LootableGarage") == true)then
					local x,y,z = getElementPosition(clickedElement)
					if(getElementDimension(source) == getElementDimension(clickedElement))then
						if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(source)) <= 3.5)then
							if(getElementModel(clickedElement) == 11102)then
								if(apocalypseGetElementData(clickedElement,"Lootable") == true)then
									if(hasPlayerItem(source,26) >= 1)then
										local ID = apocalypseGetElementData(clickedElement,"LootableGarageID")
										takeItem(source,26,1)
										local x,y,z = getElementPosition(source)
										local dynamite = createObject(1654,x-0.5,y,z-0.85,-90,0,0)
										setElementFrozen(source,true)
										setPedAnimation(source,"BOMBER", "BOM_Plant_Loop",-1,true,false,false,true)
										apocalypseSetElementData(LootableGarages.Object[ID],"Lootable",false)
										
										setTimer(function(source)
											setElementFrozen(source,false)
											setPedAnimation(source)
											NPC.MeMessage(source,getText(source,"MeMessage8"))
										end,3500,1,source)
										
										setTimer(function(ID, dynamite, player)
											local x,y,z = getElementPosition(LootableGarages.Object[ID])
											createExplosion(x,y,z,1)
											destroyElement(dynamite)
											LootableGarages.explode(ID)
											local Level_Bonus_EXP = tonumber(apocalypseGetElementData(player,"level"))
											if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
											local EXP = 250 + (Level_Bonus_EXP * 5)
											local skillpoints = 10
											if(SERVERBONUS.LOOTING == true)then
												EXP = EXP * 2
												skillpoints = skillpoints * 2
											end
											
											giveEXP(player,EXP)
											givePlayerSkillpoint(player,skillpoints)
											LootableGarages.Achievements(player)
										end,7500,1,ID, dynamite, source)
									else
										NPC.MeMessage(source,getText(source,"MeMessage7"))
									end
								end
							elseif(getElementModel(clickedElement) == 3066)then
								if(apocalypseGetElementData(clickedElement,"LootableGarageStatus") == true)then
									local ID = apocalypseGetElementData(clickedElement,"LootableGarageID")
									LootableGarages.PlayerSearched[ID] = LootableGarages.PlayerSearched[ID] or {}
									if not LootableGarages.PlayerSearched[ID][source] then
										LootableGarages.PlayerSearched[ID][source] = true
										giveLootItems(source,math.random(35,40))
									else
										NPC.MeMessage(source,getText(source,"SBuildingsLoot9"))
									end
								else
									NPC.MeMessage(source,getText(source,"SBuildingsLoot9"))
								end
							end
						end
					end
				end
			end
		end
	end
end)

function LootableGarages.Achievements(player)
	setAchievement(player,94)
	local lootedGarages = tonumber(getPlayerData("character_stats","character_id",getCharacterID(player),"looted_garages"))
	Characters.addStats(player,"looted_garages",lootedGarages + 1)
	if(DailyTasks.playerTasks[player][4])then
		DailyTasks.updateProgress(player,4,DailyTasks.playerTasks[player][4].progress + 1)
	end
	if(WeeklyTasks.playerTasks[player][4])then
		WeeklyTasks.updateProgress(player,4,WeeklyTasks.playerTasks[player][4].progress + 1)
	end
											
	for _,v in pairs(Achievements)do
		if(lootedGarages + 1 >= v[1])then
			setAchievement(player,v[2])
		end
	end
end