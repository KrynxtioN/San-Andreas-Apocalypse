function HouseLoot.createPickups()
    for i,v in ipairs(HouseLoot["Pickups"]) do
        HouseLoot.Pickup[i] = createPickup(v[1],v[2],v[3],3,1318,0)
        apocalypseSetElementData(HouseLoot.Pickup[i],"DoorBroken",false)
        apocalypseSetElementData(HouseLoot.Pickup[i],"Timer",0)
        apocalypseSetElementData(HouseLoot.Pickup[i],"ID",i)
		HouseLoot.Blips[i] = createBlip(v[1],v[2],v[3],0,1,0,125,0,255,_,50)
		setElementVisibleTo(HouseLoot.Blips[i],root,false)
		apocalypseSetElementData(HouseLoot.Pickup[i],"House:Bonus","")

        addEventHandler("onPickupHit",HouseLoot.Pickup[i],function(player)
			if(isCharacterLoggedIn(player))then
				if(not(isPedInVehicle(player)))then
					if(getElementInterior(player) == getElementInterior(source))then
						if(getElementDimension(player) == getElementDimension(source))then
							local doorBroken = apocalypseGetElementData(source,"DoorBroken")
							unbindKey(player,"e","down",HouseLoot.BreakDoor)
							apocalypseSetElementData(player,"HouseLoot:Pickup",source)
							bindKey(player,"e","down",HouseLoot.BreakDoor)
							if(doorBroken ~= true)then
								createInfobox(player,getText(player,"SHouseLoot1"))
							else
								createInfobox(player,getText(player,"SHouseLoot4"))
							end
						end
					end
				end
			end
        end)
    end
end
HouseLoot.createPickups()

local function hasPlayerLootMarker(player)
	local marker = apocalypseGetElementData(player,"HouseLoot:Marker")
	local loot = false
	if(marker)then
		local markerPlayer = apocalypseGetElementData(marker,"Player")
		local values = split(markerPlayer,"|")
		
		for _,v in pairs(values)do
			if(v == getCharacterName(player))then
				loot = true
				break
			end
		end
	end
	return loot
end

local function hasPlayerHouseBonus(player)
	local pickup = apocalypseGetElementData(player,"HouseLoot:Pickup")
	local bonus = false
	if(pickup)then
		local pickupPlayer = apocalypseGetElementData(pickup,"House:Bonus")
		local values = split(pickupPlayer,"|")
		
		for _,v in pairs(values)do
			if(v == getCharacterName(player))then
				bonus = true
				break
			end
		end
	end
	return bonus
end

function HouseLoot.BreakDoor(player)
	local Pickup = apocalypseGetElementData(player,"HouseLoot:Pickup")
	if(Pickup)then
		local x,y,z = getElementPosition(Pickup)
		if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(player)) <= 5)then
			local currentTime = getRealTime().timestamp
			local timer = apocalypseGetElementData(Pickup,"Timer")
			local doorBroken = apocalypseGetElementData(Pickup,"DoorBroken")

			if(doorBroken == false)then
				if(timer == 0 or currentTime - timer >= 1800)then
					if(hasPlayerItem(player,9) >= 1)then
						takeItem(player,9,1)
						apocalypseSetElementData(player,"doorbreaker",true)
						triggerClientEvent(player,"createWoodPlankGame",player,"HouseLoot.EnterHouse")
					else createInfobox(player,getText(player,"SHouseLoot3"))end
				else
					local remainingTime = (1800) - (currentTime - timer)
					createInfobox(player,getText(player,"SHouseLoot2"):format(formatTimeLeft(remainingTime)))
				end
			else
				HouseLoot.spawnPlayerInHouse(player)
			end
		end
	end
end

function HouseLoot.EnterHouse(player)
    local Pickup = apocalypseGetElementData(player,"HouseLoot:Pickup")
    local ID = tonumber(apocalypseGetElementData(Pickup,"ID"))
    if(Pickup)then
        HouseLoot.Data[ID] = {
            Interior = math.random(1,#HouseLoot["InteriorSpawn"]),
            Dimension = ID
        }
        local Coord = HouseLoot["InteriorSpawn"][HouseLoot.Data[ID].Interior]
        
        if(isElement(HouseLoot.OutMarker[ID])) then
            destroyElement(HouseLoot.OutMarker[ID])
            HouseLoot.OutMarker[ID] = nil
        end
		
		local currentTime = getRealTime().timestamp
		apocalypseSetElementData(Pickup,"LootTimer",currentTime)
		
		if(DailyTasks.playerTasks[player][3])then
			DailyTasks.updateProgress(player,3,DailyTasks.playerTasks[player][3].progress + 1)
		end
		if(WeeklyTasks.playerTasks[player][3])then
			WeeklyTasks.updateProgress(player,3,WeeklyTasks.playerTasks[player][3].progress + 1)
		end
		
		if(apocalypseGetElementData(player,"doorbreaker") == true)then
			apocalypseSetElementData(player,"doorbreaker",false)
			setAchievement(player,92)
		end

        HouseLoot.OutMarker[ID] = createPickup(Coord[1],Coord[2],Coord[3],3,1318,50)
        setElementInterior(HouseLoot.OutMarker[ID],HouseLoot["InteriorSpawn"][HouseLoot.Data[ID].Interior][4])
        setElementDimension(HouseLoot.OutMarker[ID],HouseLoot.Data[ID].Dimension)
                                        
        addEventHandler("onPickupHit",HouseLoot.OutMarker[ID],function(player)
            if(not(isPedInVehicle(player)))then
                if(getElementInterior(player) == getElementInterior(source))then
                    if(getElementDimension(player) == getElementDimension(source))then
						if(not(isPedDead(player)))then
							bindKey(player,"e","down",HouseLoot.leaveHouse)
							createInfobox(player,getText(player,"SHouseLoot5"))
						end
                    end
                end
            end
        end)
        
        apocalypseSetElementData(Pickup,"DoorBroken",true)
        setAchievement(player,42)
        HouseLoot.createLootObjects(HouseLoot.Data[ID].Interior, HouseLoot.Data[ID].Dimension)
        HouseLoot.Timer[apocalypseGetElementData(Pickup,"ID")] = setTimer(function(pickup)
            local ID = apocalypseGetElementData(pickup,"ID")
            local currentTime = getRealTime().timestamp
            apocalypseSetElementData(pickup,"DoorBroken",false)
            apocalypseSetElementData(pickup,"Timer",currentTime)
            HouseLoot.destroyLootObjects(_,ID)
                                        
            for _,v in pairs(getElementsByType("player"))do
                if(apocalypseGetElementData(v,"HouseLoot:Active") == true and getElementDimension(v) == ID)then
                    HouseLoot.leaveHouse(v)
                    NPC.MeMessage(v,getText(v,"SHouseLoot6"))
                end
            end
            setBlipColor(HouseLoot.Blips[ID],125,0,0,255)
        end,900000,1,Pickup)
        setTimer(function(ID)
            setBlipColor(HouseLoot.Blips[ID],0,125,0,255)
			apocalypseSetElementData(HouseLoot.Pickup[ID],"House:Bonus","")
        end,1800000,1,ID)
        
        if(math.random(1,5) == 3)then
            local x,y,z = getElementPosition(HouseLoot.Pickup[ID])
            for i = 1, math.random(2,4) do
                local house_zombie = createZombie(x,y,z)
                apocalypseSetElementData(house_zombie,"forcedtoexist",true)
            end
            NPC.MeMessage(player,getText(player,"MeMessage1"))
        else
            HouseLoot.spawnPlayerInHouse(player)
        end
    end
end
addEvent("HouseLoot.EnterHouse",true)
addEventHandler("HouseLoot.EnterHouse",root,HouseLoot.EnterHouse)

function HouseLoot.leaveHouse(player, force)
    local x,y,z = HouseLoot.savePos[player][1], HouseLoot.savePos[player][2], HouseLoot.savePos[player][3]
    if not force then
        local px,py,pz = getElementPosition(HouseLoot.OutMarker[getElementDimension(player)])
        if(getDistanceBetweenPoints3D(px,py,pz,getElementPosition(player)) > 5) then
            return
        end
    end
    unbindKey(player,"e","down",HouseLoot.leaveHouse)
    setElementPosition(player,x,y,z)
    setElementInterior(player,0)
    setElementDimension(player,0)
    apocalypseSetElementData(player,"HouseLoot:Active",false)
    apocalypseSetElementData(player,"TeleportInInterior",false)
    triggerClientEvent(player,"addTimer",player,0,getText(player,"Timer1"),"HouseLooting")
end

function HouseLoot.createLootObjects(Interior,Dimension)
	HouseLoot.lootMarker[Dimension] = {}
	HouseLoot.Zombies[Dimension] = {}
	
	local Table = HouseLoot["SafeSpawn"][Interior]
	HouseLoot.Safes[Dimension] = createObject(2332,Table[1],Table[2],Table[3],Table[4],Table[5],Table[6])
	setElementDimension(HouseLoot.Safes[Dimension],Dimension)
	setElementInterior(HouseLoot.Safes[Dimension],HouseLoot["InteriorSpawn"][Interior][4])
	apocalypseSetElementData(HouseLoot.Safes[Dimension], "ExplodableSafe", true)
	apocalypseSetElementData(HouseLoot.Safes[Dimension], "SafeID", Dimension)
	
	if(math.random(1,2) == 1)then
		for i,v in ipairs(HouseLoot["ZombieSpawn"][Interior])do
			HouseLoot.Zombies[Dimension][i] = createZombie(v[1],v[2],v[3])
			setElementInterior(HouseLoot.Zombies[Dimension][i],HouseLoot["InteriorSpawn"][Interior][4])
			setElementDimension(HouseLoot.Zombies[Dimension][i],Dimension)
		end
	end
	for i,v in ipairs(HouseLoot["InteriorMarker"][Interior])do
		HouseLoot.lootMarker[Dimension][i] = createMarker(v[1],v[2],v[3],"cylinder",v[4],_,_,_,0)
		
		setElementInterior(HouseLoot.lootMarker[Dimension][i],HouseLoot["InteriorSpawn"][Interior][4])
		setElementDimension(HouseLoot.lootMarker[Dimension][i],Dimension)
		apocalypseSetElementData(HouseLoot.lootMarker[Dimension][i],"Player","")
		
		addEventHandler("onMarkerHit",HouseLoot.lootMarker[Dimension][i],function(player)
			if(getElementType(player) == "player")then
				if(getElementDimension(player) == getElementDimension(source))then
					if(getElementInterior(player) == getElementInterior(source))then
						apocalypseSetElementData(player,"HouseLoot:Marker",source)
						if(hasPlayerLootMarker(player) == false)then
							triggerClientEvent(player,"HouseLoot.Info",player,getText(player,"SHouseLoot10"))
							bindKey(player,"space","down",HouseLoot.startLoot)
						end
					end
				end
			end
		end)
		
		addEventHandler("onMarkerLeave",HouseLoot.lootMarker[Dimension][i],function(player)
			if(getElementType(player) == "player")then
				if(getElementDimension(player) == getElementDimension(source))then
					if(getElementInterior(player) == getElementInterior(source))then
						triggerClientEvent(player,"HouseLoot.Info",player)
						unbindKey(player,"space","down",HouseLoot.startLoot)
						apocalypseSetElementData(player,"HouseLoot:Marker",nil)
					end
				end
			end
		end)
	end
end

function HouseLoot.destroyLootObjects(Interior,Dimension)
	for _,v in pairs(HouseLoot.lootMarker[Dimension])do
		if(isElement(v))then
			destroyElement(v)
		end
	end
	for _,v in pairs(HouseLoot.Zombies[Dimension])do
		if(isElement(v))then
			destroyElement(v)
		end
	end
	if(isElement(HouseLoot.Safes[Dimension]))then
		destroyElement(HouseLoot.Safes[Dimension])
	end
end

function HouseLoot.spawnPlayerInHouse(player)
	local x,y,z = getElementPosition(player)
	HouseLoot.savePos[player] = {x,y,z}

    local Pickup = apocalypseGetElementData(player,"HouseLoot:Pickup")
	local ID = apocalypseGetElementData(Pickup,"ID")
	local Int, Dim = HouseLoot.Data[ID].Interior, HouseLoot.Data[ID].Dimension
	local spawnx, spawny, spawnz = HouseLoot["InteriorSpawn"][Int][1],HouseLoot["InteriorSpawn"][Int][2],HouseLoot["InteriorSpawn"][Int][3]
	
	setElementPosition(player,spawnx,spawny,spawnz)
	apocalypseSetElementData(player,"TeleportInInterior",true)
	setElementInterior(player,HouseLoot["InteriorSpawn"][Int][4])
	setElementDimension(player,ID)
	
	HouseLoot.getLootAmount(player)
    unbindKey(player,"e","down",HouseLoot.BreakDoor)
	apocalypseSetElementData(player,"HouseLoot:Active",true)
	triggerClientEvent(player,"addTimer",player,tonumber(apocalypseGetElementData(Pickup,"LootTimer")) + 900,getText(player,"Timer1"),"HouseLooting")
	triggerClientEvent(player,"createActivitiesInformationText",player,getText(client,"CActivitiesInformation2"))
end

function HouseLoot.getLootAmount(player)
	if(not(player))then player = client end
	local dimension = getElementDimension(player)
	if(HouseLoot.lootMarker[dimension])then
		local totalLoot = 0
		local looted = 0
		for _,v in pairs(HouseLoot.lootMarker[dimension])do
			totalLoot = totalLoot + 1
			local objectPlayer = apocalypseGetElementData(v,"Player")
			local values = split(objectPlayer,"|")
		
			for _,v in pairs(values)do
				if(v == getCharacterName(player))then
					looted = looted + 1
				end
			end
		end
		
		if(hasPlayerHouseBonus(player) == false)then
			if(looted == totalLoot)then
				local Level_Bonus_EXP = tonumber(apocalypseGetElementData(player,"level"))
				if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end	
		
				local bonusEXP = totalLoot * 10 + (Level_Bonus_EXP * 1)
				if(SERVERBONUS.LOOTING == true)then
					bonusEXP = bonusEXP * 2
				end
				
				giveEXP(player,bonusEXP)
				
				SkillpointStreak.Houses(player)
				local looted_houses = tonumber(getPlayerData("character_stats","character_id",getCharacterID(player),"looted_houses"))
				Characters.addStats(player,"looted_houses",looted_houses + 1)
				if(looted_houses)then
					for _,v in pairs(Achievements)do
						if(looted_houses + 1 >= v[1])then
							setAchievement(player,v[2])
						end
					end
				end
				
				local pickup = apocalypseGetElementData(player,"HouseLoot:Pickup")
				local pickupPlayer = apocalypseGetElementData(pickup,"House:Bonus")
				local pickupPlayer = pickupPlayer..getCharacterName(player).."|"
				apocalypseSetElementData(pickup,"House:Bonus",pickupPlayer)
				NPC.MeMessage(player,getText(player,"SHouseLoot8"))
			end
		end
		
		if(looted == 0)then
			NPC.MeMessage(player,getText(player,"MeMessage6"))
		end
		
		triggerClientEvent(player,"HouseLoot.updateAmount",player,totalLoot,looted)
	end
end
addEvent("HouseLoot.getLootAmount",true)
addEventHandler("HouseLoot.getLootAmount",root,HouseLoot.getLootAmount)

function HouseLoot.startLoot(player)
	if(hasPlayerLootMarker(player) == false)then
		if(apocalypseGetElementData(player,"SearchingHouse") == nil)then
			apocalypseSetElementData(player,"SearchingHouse",false)
		end
		if(apocalypseGetElementData(player,"SearchingHouse") == false)then
			apocalypseSetElementData(player,"SearchingHouse",true)
			local marker = apocalypseGetElementData(player,"HouseLoot:Marker")
			local markerPlayer = apocalypseGetElementData(marker,"Player")
			local markerPlayer = markerPlayer..getCharacterName(player).."|"
			apocalypseSetElementData(marker,"Player",markerPlayer)
			setPedAnimation(player,"bomber","bom_plant_loop",-1,true,false,false,true)
			toggleAllControls(player,false)
			triggerClientEvent(player,"createProgressBar",player,4)
			setTimer(function(player)
				if(isElement(player))then
					toggleAllControls(player,true)
					triggerClientEvent(player,"HouseLoot.Info",player)
					setPedAnimation(player)
					apocalypseSetElementData(player,"SearchingHouse",false)
					local Level_Bonus_EXP = tonumber(apocalypseGetElementData(player,"level"))
					if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
					local EXP = 10 + (Level_Bonus_EXP * 1)
					local skillpoints_amount = 1
					if(SERVERBONUS.LOOTING == true)then
						EXP = EXP * 2
						skillpoints_amount = skillpoints_amount * 2
					end
					if(math.random(1,3) ~= 2)then
						if(marker and isElementWithinMarker(player,marker))then
							giveLootItems(player,math.random(1,3))
						end
					else
						NPC.MeMessage(player,getText(player,"SHouseLoot9"))
					end
					giveEXP(player,EXP)
					givePlayerSkillpoint(player,skillpoints_amount)
				end
			end,4000,1,player)
			HouseLoot.getLootAmount(player)
		end
	end
end

addEvent("HouseLoot.showBlipsFalse",true)
addEventHandler("HouseLoot.showBlipsFalse",root,function()
	for i = 1,#HouseLoot.Blips do
		setElementVisibleTo(HouseLoot.Blips[i],source,false)
	end
end)

function HouseLoot.showBlipsTrue(player)
	if(not(player))then player = client end
	for _,v in pairs(HouseLoot.Blips)do
		setElementVisibleTo(v,player,true)
	end
end
addEvent("HouseLoot.showBlipsTrue",true)
addEventHandler("HouseLoot.showBlipsTrue",root,HouseLoot.showBlipsTrue)

addEventHandler("onPlayerClick", root, function(button, state, clickedElement)
	if not isCharacterLoggedIn(source) then return end
	if button ~= "left" or state ~= "down" then return end
	if not isElement(clickedElement) then return end
	
	local ox,oy,oz = getElementPosition(clickedElement)

	if(getDistanceBetweenPoints3D(ox,oy,oz,getElementPosition(source)) <= 3.5)then
		if apocalypseGetElementData(clickedElement, "ExplodableSafe") == true then
			local safeID = apocalypseGetElementData(clickedElement, "SafeID")
			if not safeID then return end

			if hasPlayerItem(source, 26) >= 1 then
				takeItem(source, 26, 1)

				local x, y, z = getElementPosition(clickedElement)
				local dynamite = createObject(1654, x, y - 0.5, z - 0.85, -90, 0, 0)
				setElementDimension(dynamite, getElementDimension(clickedElement))
				setElementInterior(dynamite, getElementInterior(clickedElement))

				setElementFrozen(source, true)
				setPedAnimation(source, "BOMBER", "BOM_Plant_Loop", -1, true, false, false, true)

				setTimer(function(source)
					if(isElement(source))then
						setElementFrozen(source, false)
						setPedAnimation(source)
						NPC.MeMessage(source, getText(source, "MeMessage8"))
					end
				end, 3500, 1,source)

				setTimer(function(source)
					if isElement(dynamite) then destroyElement(dynamite) end
					createExplosion(x, y, z, 1)

					if isElement(HouseLoot.Safes[safeID]) then
						setElementModel(HouseLoot.Safes[safeID], 1829)
						apocalypseSetElementData(HouseLoot.Safes[safeID], "ExplodableSafe", false)
					end
					
					if(isElement(source))then
						giveLootItems(source,math.random(5,10))
						local Level_Bonus_EXP = tonumber(apocalypseGetElementData(player,"level"))
						if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
						local EXP = 250 + (Level_Bonus_EXP * 1)
						local skillpoints_amount = 10
						if(SERVERBONUS.LOOTING == true)then
							EXP = EXP * 2
							skillpoints_amount = skillpoints_amount * 2
						end
						giveEXP(source, EXP)
						givePlayerSkillpoint(source,skillpoints_amount)
						NPC.MeMessage(source, getText(source, "SafeExplosionSuccess"))
					end
				end, 7500, 1,source)
			else
				NPC.MeMessage(source, getText(source, "MeMessage7")) -- kein Dynamit
			end
		end
	end
end)

addEventHandler("onPlayerWasted",root,function()
	unbindKey(source,"e","down",HouseLoot.leaveHouse)
end)

addEventHandler("onPlayerQuit", root, function()
    HouseLoot.savePos[source] = nil
end)