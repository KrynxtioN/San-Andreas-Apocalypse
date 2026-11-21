CasinoLoot = {Door = {}, Marker = {}, plantDoorTimer = {}, bombDoorObject = {}, explodeDoorTimer = {}, playerPlantTimer = {}, explodedSafes = {}, moneyPickups = {}, DoorInfoMarker = {},
	["MarkerPos"] = { -- x, y, z
		{2147.3225097656,1629.3365478516,992.67608642578},
		{2147.314453125,1633.2674560547,992.55108642578},
		{2147.2062988281,1637.1588134766,992.72607421875},
		{2147.4089355469,1641.1163330078,992.47607421875},
		{2141.0524902344,1641.1018066406,992.57611083984},
		{2141.05078125,1637.1917724609,992.57611083984},
		{2141.06640625,1633.1145019531,992.42608642578},
		{2141.06640625,1629.3225097656,992.42608642578},
	},
}

local Achievements = {
	{1,368},
	{5,369},
	{10,370},
	{25,371},
	{50,372},
	{75,373},
	{125,374},
	{175,375},
	{250,376},
}

function CasinoLoot.create(Dimension)
	if(CasinoLoot.Marker[Dimension])then
		if(#CasinoLoot.Marker[Dimension] >= 1)then
			for _,v in pairs(CasinoLoot.Marker[Dimension])do
				if(isElement(v))then
					destroyElement(v)
				end
			end
		end
	end
	if(CasinoLoot.moneyPickups[Dimension])then
		if(#CasinoLoot.moneyPickups[Dimension] >= 1)then
			for _,v in pairs(CasinoLoot.moneyPickups[Dimension])do
				if(isElement(v))then
					destroyElement(v)
				end
			end
		end
	end
	
	if(CasinoLoot.Door[Dimension])then
		if(isElement(CasinoLoot.Door[Dimension]))then destroyElement(CasinoLoot.Door[Dimension])end
		if(isElement(CasinoLoot.bombDoorObject[Dimension]))then destroyElement(CasinoLoot.bombDoorObject[Dimension])end
		if(isTimer(CasinoLoot.plantDoorTimer[Dimension]))then killTimer(CasinoLoot.plantDoorTimer[Dimension])end
		if(isTimer(CasinoLoot.explodeDoorTimer[Dimension]))then killTimer(CasinoLoot.explodeDoorTimer[Dimension])end
		if(isElement(CasinoLoot.DoorInfoMarker[Dimension]))then destroyElement(CasinoLoot.DoorInfoMarker[Dimension])end
	end
	
	CasinoLoot.explodedSafes[Dimension] = 0
	CasinoLoot.Door[Dimension] = {}
	CasinoLoot.Marker[Dimension] = {}
	CasinoLoot.bombDoorObject[Dimension] = {}
	CasinoLoot.plantDoorTimer[Dimension] = {}
	CasinoLoot.explodeDoorTimer[Dimension] = {}
	CasinoLoot.DoorInfoMarker[Dimension] = {}
	CasinoLoot.moneyPickups[Dimension] = {}
	
	CasinoLoot.Door[Dimension] = createObject(2634,2144.1794433594,1627.0300292969,994.28692626953,0,0,180)
	setElementInterior(CasinoLoot.Door[Dimension],1)
	setElementDimension(CasinoLoot.Door[Dimension],Dimension)
	apocalypseSetElementData(CasinoLoot.Door[Dimension],"CasinoLoot",true)
	CasinoLoot.DoorInfoMarker[Dimension] = createMarker(2144.189453125,1626.5557861328,993.68817138672,"cylinder",2.5,255,255,0,0)
	setElementInterior(CasinoLoot.DoorInfoMarker[Dimension],1)
	setElementDimension(CasinoLoot.DoorInfoMarker[Dimension],Dimension)
	
	addEventHandler("onMarkerHit",CasinoLoot.DoorInfoMarker[Dimension],function(player)
		if(getElementDimension(player) == getElementDimension(source))then
			triggerClientEvent(player,"createActivitiesInformationText",player,getText(player,"CActivitiesInformation3"))
		end
	end)
	
	for _,v in pairs(CasinoLoot["MarkerPos"])do
		local marker = createMarker(v[1],v[2],v[3],"cylinder",3,0,0,0,0)
		setElementInterior(marker,1)
		setElementDimension(marker,Dimension)
		table.insert(CasinoLoot.Marker[Dimension],marker)
		apocalypseSetElementData(marker,"explode",false)
		
		addEventHandler("onMarkerHit",marker,function(player)
			if(getElementDimension(player) == getElementDimension(source))then
				triggerClientEvent(player,"createActivitiesInformationText",player,getText(player,"SNests1"))
				bindKey(player,"e","down",CasinoLoot.placeDynamite)
			end
		end)
	end
end
CasinoLoot.create(0)
CasinoLoot.create(1)
CasinoLoot.create(2)

addEventHandler("onPlayerClick",root,function(button,state,clickedElement)
	if(isCharacterLoggedIn(source))then
		if(button == "left" and state == "down")then
			if(clickedElement and isElement(clickedElement))then
				if(getElementType(clickedElement) == "object")then
					if(getElementModel(clickedElement) == 2634)then
						if(hasPlayerItem(source,26) >= 1)then
							if(apocalypseGetElementData(clickedElement,"CasinoLoot") == true)then
								local dimension = getElementDimension(clickedElement)
								if(getElementDimension(source) == dimension)then
									if(not(isElement(CasinoLoot.bombDoorObject[dimension])))then
										takeItem(source,26,1)
										CasinoLoot.bombDoorObject[dimension] = createObject(1654,2143.8537597656,1626.8013916016,994.21417236328,0,0,0)
										setElementInterior(CasinoLoot.bombDoorObject[dimension],1)
										setElementDimension(CasinoLoot.bombDoorObject[dimension],dimension)
										NPC.MeMessage(source,getText(source,"MeMessage8"))
										destroyElement(CasinoLoot.DoorInfoMarker[dimension])
												
										CasinoLoot.explodeDoorTimer[dimension] = setTimer(function(dimension)
											local x,y,z = getElementPosition(CasinoLoot.bombDoorObject[dimension])
											destroyElement(CasinoLoot.bombDoorObject[dimension])
											destroyElement(CasinoLoot.Door[dimension])
											createExplosion(x,y,z,10)
										end,7500,1,dimension)
									end
								end
							end
						else
							NPC.MeMessage(source,getText(source,"MeMessage7"))
						end
					end
				end
			end
		end
	end
end)

function CasinoLoot.placeDynamite(player)
	local status = false
	local playerMarker
	local dimension = getElementDimension(player)
	for _,v in pairs(CasinoLoot.Marker[dimension])do
		if(isElement(v))then
			if(isElementWithinMarker(player,v))then
				if(apocalypseGetElementData(v,"explode") == false)then
					status = true
					playerMarker = v
					break
				end
			end
		end
	end
	if(status == true)then
		if(hasPlayerItem(player,26) >= 1)then
			if(not(CasinoLoot.playerPlantTimer[player]))then CasinoLoot.playerPlantTimer[player] = {} end
			
			local x,y,z = getElementPosition(player)
			setElementFrozen(player,true)
			setTimer(function(player)
				setPedAnimation(player,"BOMBER", "BOM_Plant_Loop",-1,true,false,false,true)
			end,50,1,player)
			local bombObject = createObject(1654,x-0.5,y,z-0.85,-90,0,0)
			setElementInterior(bombObject,getElementInterior(player))
			setElementDimension(bombObject,getElementDimension(player))
			setElementData(bombObject,"explode",true)
			unbindKey(player,"e","down",CasinoLoot.placeDynamite)
			
			CasinoLoot.explodedSafes[dimension] = CasinoLoot.explodedSafes[dimension] + 1
			if(CasinoLoot.explodedSafes[dimension] >= 8)then
				setTimer(function(dimension)
					CasinoLoot.create(dimension)
				end,3600000,1,dimension)
			end
			
			CasinoLoot.playerPlantTimer[player] = setTimer(function(player,dimension,playerMarker,bombObject)
				if(isElement(player))then
					setPedAnimation(player)
					setElementFrozen(player,false)
					NPC.MeMessage(player,getText(player,"MeMessage8"))
				end
			end,3500,1,player)
			
			local px,py,pz = getElementPosition(player)
			setTimer(function(player,dimension, playerMarker, bombObject,px,py,pz)
				local mx,my,mz = getElementPosition(playerMarker)
				local pickup = createPickup(px,py,pz, 3, 1550, 50)
				setElementInterior(pickup, 1)
				setElementDimension(pickup, dimension)
				table.insert(CasinoLoot.moneyPickups[dimension], pickup)
					
				addEventHandler("onPickupHit", pickup, function(player)
					if not isElement(source) then return end
					if getElementDimension(player) == getElementDimension(source) then
						giveEXP(player,125)
						givePlayerServerMoney(player, math.random(300, 525))
						destroyElement(source)
					end
				end)
				
				if(DailyTasks.playerTasks[player][25])then
					DailyTasks.updateProgress(player,25,DailyTasks.playerTasks[player][25].progress + 1)
				end
				if(WeeklyTasks.playerTasks[player][25])then
					WeeklyTasks.updateProgress(player,25,WeeklyTasks.playerTasks[player][25].progress + 1)
				end
				
				local casino_safe_destroyed = getPlayerData("character_stats","character_id",getCharacterID(player),"casino_safe_destroyed")
				Characters.addStats(player,"casino_safe_destroyed",casino_safe_destroyed + 1)
				for _,v in pairs(Achievements)do
					if(casino_safe_destroyed + 1 >= v[1])then
						setAchievement(player,v[2])
					end
				end

				destroyElement(playerMarker)
				destroyElement(bombObject)
				createExplosion(mx, my, mz, 3)
			end, 11000, 1, player, dimension, playerMarker, bombObject,px,py,pz)
		else
			NPC.MeMessage(player,getText(player,"MeMessage7"))
		end
	end
end

addEventHandler("onPlayerWasted",root,function()
	unbindKey(source,"e","down",CasinoLoot.placeDynamite)
end)