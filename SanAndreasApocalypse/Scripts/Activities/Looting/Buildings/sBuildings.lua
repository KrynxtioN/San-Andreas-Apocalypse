local FireDepartmentDocumentClick = {}
local FireDepartmentDocument = {}

local Achievements = {
	{5,318},
	{10,319},
	{25,320},
	{50,321},
	{75,322},
	{125,323},
	{175,324},
	{250,325},
}


for i,v in ipairs(BuildingsLoot["Coordinates"])do
	BuildingsLoot.Pickups[i] = createPickup(v[1],v[2],v[3],3,1318,50)
    apocalypseSetElementData(BuildingsLoot.Pickups[i],"DoorBroken",false)
    apocalypseSetElementData(BuildingsLoot.Pickups[i],"Timer",0)
    apocalypseSetElementData(BuildingsLoot.Pickups[i],"ID",i)
	apocalypseSetElementData(BuildingsLoot.Pickups[i],"NeededCrowbars",v[5])
	apocalypseSetElementData(BuildingsLoot.Pickups[i],"Type",v[4])
	BuildingsLoot.Blips[i] = createBlip(v[1],v[2],v[3],0,1,0,125,0,255,_,50)
	setElementVisibleTo(BuildingsLoot.Blips[i],root,false)
	apocalypseSetElementData(BuildingsLoot.Pickups[i],"PoliceDepartmentKeypadKey",false)
	
	addEventHandler("onPickupHit",BuildingsLoot.Pickups[i],function(player)
		if(isCharacterLoggedIn(player))then
			if(not(isPedInVehicle(player)))then
				if(getElementDimension(player) == getElementDimension(source))then
					if(getElementInterior(player) == getElementInterior(source))then
						local doorBroken = apocalypseGetElementData(source,"DoorBroken")
						unbindKey(player,"e","down",BuildingsLoot.BreakDoor)
						apocalypseSetElementData(player,"BuildingsLoot:Pickup",source)
						local id = apocalypseGetElementData(source,"ID")
						apocalypseSetElementData(player,"BuildingsLoot:ID",id)
						bindKey(player,"e","down",BuildingsLoot.BreakDoor)
						if(doorBroken ~= true)then
							createInfobox(player,getText(player,"SBuildingsLoot1"))
						else
							createInfobox(player,getText(player,"SBuildingsLoot4"))
						end
					end
				end
			end
		end
	end)
end

function BuildingsLoot.BreakDoor(player)
	local Pickup = apocalypseGetElementData(player,"BuildingsLoot:Pickup")
	if(Pickup)then
		local x,y,z = getElementPosition(Pickup)
		if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(player)) <= 5)then
			local currentTime = getRealTime().timestamp
			local timer = apocalypseGetElementData(Pickup,"Timer")
			local doorBroken = apocalypseGetElementData(Pickup,"DoorBroken")

			if(doorBroken == false)then
				if(timer == 0 or currentTime - timer >= 1800)then
					local NeededCrowbars = tonumber(apocalypseGetElementData(Pickup,"NeededCrowbars"))
					if(hasPlayerItem(player,9) >= NeededCrowbars)then
						takeItem(player,9,NeededCrowbars)
						triggerClientEvent(player,"createWoodPlankGame",player,"BuildingsLoot.EnterBuilding")
						apocalypseSetElementData(player,"doorbreakerbuilding",true)
					else NPC.MeMessage(player,getText(player,"SBuildingsLoot3"):format(NeededCrowbars))end
				else
					local remainingTime = (1800) - (currentTime - timer)
					createInfobox(player,getText(player,"SBuildingsLoot2"):format(formatTimeLeft(remainingTime)))
				end
			else
				BuildingsLoot.spawnPlayerInHouse(player)
			end
		end
	end
end

function BuildingsLoot.EnterBuilding(player)
	local Pickup = apocalypseGetElementData(player,"BuildingsLoot:Pickup")
	local ID = apocalypseGetElementData(Pickup,"ID")
	local Type = apocalypseGetElementData(Pickup,"Type")
	BuildingsLoot.Data[ID] = {
		Interior = math.random(1,#BuildingsLoot["Data"][Type]),
		Dimension = ID
	}
	apocalypseSetElementData(player,"TeleportInInterior",true)
	local Coord = BuildingsLoot["Data"][Type][BuildingsLoot.Data[ID].Interior]
	setBlipColor(BuildingsLoot.Blips[ID],255,150,0,255)
	
	local currentTime = getRealTime().timestamp
	apocalypseSetElementData(Pickup,"LootTimer",currentTime)
							
    if(isElement(BuildingsLoot.Outobject[ID])) then
        destroyElement(BuildingsLoot.Outobject[ID])
        BuildingsLoot.Outobject[ID] = nil
    end
	
	BuildingsLoot.Outobject[ID] = createPickup(Coord[1],Coord[2],Coord[3],3,1318,50)
	setElementInterior(BuildingsLoot.Outobject[ID],BuildingsLoot["Data"][Type][BuildingsLoot.Data[ID].Interior][5])
	setElementDimension(BuildingsLoot.Outobject[ID],BuildingsLoot.Data[ID].Dimension)
								
	addEventHandler("onPickupHit",BuildingsLoot.Outobject[ID],function(player)
		if(not(isPedInVehicle(player)))then
			if(getElementInterior(player) == getElementInterior(source))then
				if(getElementDimension(player) == getElementDimension(source))then
					bindKey(player,"e","down",BuildingsLoot.leaveHouse)
					createInfobox(player,getText(player,"SBuildingsLoot5"))
				end
			end
		end
	end)

	apocalypseSetElementData(Pickup,"DoorBroken",true)
	BuildingsLoot.createLootObjects(Type,BuildingsLoot.Data[ID].Interior, BuildingsLoot.Data[ID].Dimension)
	givePlayerSkillpoint(player,5)
	
	if(apocalypseGetElementData(player,"doorbreakerbuilding") == true)then
		apocalypseSetElementData(player,"doorbreakerbuilding",false)
		setAchievement(player,93)
	end
	
	if(DailyTasks.playerTasks[player][2])then
		DailyTasks.updateProgress(player,2,DailyTasks.playerTasks[player][2].progress + 1)
	end
	if(WeeklyTasks.playerTasks[player][2])then
		WeeklyTasks.updateProgress(player,2,WeeklyTasks.playerTasks[player][2].progress + 1)
	end

							
	if(Type == "Hospital")then
		if(not(isElement(BuildingsLoot.HospitalGate[ID])))then
			BuildingsLoot.HospitalGate[ID] = createObject(2957,368.95230102539,162.06460571289,1020.6041870117,0,0,90)
			setElementInterior(BuildingsLoot.HospitalGate[ID],BuildingsLoot["Data"][Type][BuildingsLoot.Data[ID].Interior][5])
			setElementDimension(BuildingsLoot.HospitalGate[ID],BuildingsLoot.Data[ID].Dimension)
		end
	end
	
	if(Type == "Sexshop")then
		if(BuildingsLoot.Data[ID].Interior == 3)then
			if(not(isElement(BuildingsLoot.SexshopWall[ID])))then
				BuildingsLoot.SexshopWall[ID] = createObject(3095,968.26538085938,-55.082599639893,1000.1171875,0,90,0)
				setElementInterior(BuildingsLoot.SexshopWall[ID],BuildingsLoot["Data"][Type][BuildingsLoot.Data[ID].Interior][5])
				setElementDimension(BuildingsLoot.SexshopWall[ID],BuildingsLoot.Data[ID].Dimension)
			end
		end
	end
	
	if(Type == "PoliceDepartment")then
		if(BuildingsLoot["Data"][Type][BuildingsLoot.Data[ID].Interior][5] == 3)then
			PoliceDepartmentDocumentClick[ID] = createObject(1235,194.89669799805,161.7760925293,1002.1015014648,0,90,110)
			setElementAlpha(PoliceDepartmentDocumentClick[ID],0)
			PoliceDepartmentDocument[ID] = createObject(2894,194.89599609375,161.63150024414,1002.0233764648,0,0,294)
			setElementInterior(PoliceDepartmentDocumentClick[ID],3)
			setElementInterior(PoliceDepartmentDocument[ID],3)
			setElementDimension(PoliceDepartmentDocumentClick[ID],BuildingsLoot.Data[ID].Dimension)
			setElementDimension(PoliceDepartmentDocument[ID],BuildingsLoot.Data[ID].Dimension)
			apocalypseSetElementData(PoliceDepartmentDocumentClick[ID],"DocumentID",5)
			apocalypseSetElementData(PoliceDepartmentDocument[ID],"DocumentID",5)
		
			PoliceDepartmentKeypad[ID] = createObject(2886,200.34379577637,163.99899291992,1003.5289916992,0,0,90)
			setElementInterior(PoliceDepartmentKeypad[ID],BuildingsLoot["Data"][Type][BuildingsLoot.Data[ID].Interior][5])
			setElementDimension(PoliceDepartmentKeypad[ID],BuildingsLoot.Data[ID].Dimension)
			apocalypseSetElementData(PoliceDepartmentKeypad[ID],"PoliceDepartmentKeypad",true)
		
			createPoliceDepartmentObjects(BuildingsLoot["Data"][Type][BuildingsLoot.Data[ID].Interior][5],BuildingsLoot.Data[ID].Dimension)
			local id = math.random(1,#PoliceDepartmentPrisoners)
			local pos = PoliceDepartmentPrisoners[id]
			local x,y,z,rot = pos[1],pos[2],pos[3],pos[4]
			PoliceDepartmentPrisonersPed[ID] = createPed(zombies["Skins"][math.random(1,#zombies["Skins"])],x,y,z,rot)
			setElementInterior(PoliceDepartmentPrisonersPed[ID],BuildingsLoot["Data"][Type][BuildingsLoot.Data[ID].Interior][5])
			setElementDimension(PoliceDepartmentPrisonersPed[ID],BuildingsLoot.Data[ID].Dimension)
			
			addEventHandler("onPedWasted",PoliceDepartmentPrisonersPed[ID],function(player)
				local x,y,z = getElementPosition(source)
				local dim,int = getElementDimension(source),getElementInterior(source)
				PoliceDepartmentPickup[dim] = createPickup(x,y,z,3,334,50)
				setElementInterior(PoliceDepartmentPickup[dim],int)
				setElementDimension(PoliceDepartmentPickup[dim],dim)
				
				addEventHandler("onPickupHit",PoliceDepartmentPickup[dim],function(player)
					if(getElementDimension(player) == getElementDimension(source))then
						destroyElement(source)
						giveItem(player,11,1)
						triggerClientEvent(player, "showItemBar", player, {{11,1}})
					end
				end)
			end)
				
			setTimer(function(ped)
				setPedAnimation(ped,"sunbathe", "parksit_m_idlea",-1,true,false,false,true)
			end,500,1,PoliceDepartmentPrisonersPed[ID])
		elseif(BuildingsLoot["Data"][Type][BuildingsLoot.Data[ID].Interior][5] == 10)then
			EvidenceRoom.loadRoom(BuildingsLoot.Data[ID].Dimension)
		end
	end
	
	if(Type == "FireDepartment")then
		FireDepartmentDocumentClick[ID] = createObject(1235,235.70599365234,75.977798461914,1004.9699707031,0,90,150)
		setElementAlpha(FireDepartmentDocumentClick[ID],0)
		FireDepartmentDocument[ID] = createObject(2894,235.75799560547,75.948600769043,1004.8668823242,0,0,324)
		setElementInterior(FireDepartmentDocumentClick[ID],6)
		setElementInterior(FireDepartmentDocument[ID],6)
		setElementDimension(FireDepartmentDocumentClick[ID],BuildingsLoot.Data[ID].Dimension)
		setElementDimension(FireDepartmentDocument[ID],BuildingsLoot.Data[ID].Dimension)
		apocalypseSetElementData(FireDepartmentDocumentClick[ID],"DocumentID",6)
		apocalypseSetElementData(FireDepartmentDocument[ID],"DocumentID",6)
	end
							
	BuildingsLoot.Timer[apocalypseGetElementData(Pickup,"ID")] = setTimer(function(pickup)
		local ID = apocalypseGetElementData(pickup,"ID")
		local currentTime = getRealTime().timestamp
		apocalypseSetElementData(pickup,"DoorBroken",false)
		apocalypseSetElementData(pickup,"Timer",currentTime)
		BuildingsLoot.destroyLootObjects(_,ID)
		apocalypseSetElementData(BuildingsLoot.Pickups[ID],"PoliceDepartmentKeypadKey",false)
								
		if(isElement(BuildingsLoot.HospitalGate[ID]))then
			destroyElement(BuildingsLoot.HospitalGate[ID])
		end
		if(isElement(BuildingsLoot.SexshopWall[ID]))then
			destroyElement(BuildingsLoot.SexshopWall[ID])
		end
		destroyPoliceDepartmentObjects(BuildingsLoot.Data[ID].Dimension)
		if(isElement(PoliceDepartmentPrisonersPed[ID]))then
			destroyElement(PoliceDepartmentPrisonersPed[ID])
		end
		if(isElement(PoliceDepartmentPickup[ID]))then
			destroyElement(PoliceDepartmentPickup[ID])
		end
		if(isElement(PoliceDepartmentDocumentClick[ID]))then
			destroyElement(PoliceDepartmentDocumentClick[ID])
			destroyElement(PoliceDepartmentDocument[ID])
		end
		if(isElement(FireDepartmentDocumentClick[ID]))then
			destroyElement(FireDepartmentDocumentClick[ID])
			destroyElement(FireDepartmentDocument[ID])
		end
		EvidenceRoom.unloadRoom(BuildingsLoot.Data[ID].Dimension)
								
		for _,v in pairs(getElementsByType("player"))do
			if(apocalypseGetElementData(v,"BuildingsLoot:Active") == true and getElementDimension(v) == ID)then
				BuildingsLoot.leaveHouse(v)
				NPC.MeMessage(v,getText(v,"SBuildingsLoot6"))
			end
		end
		setBlipColor(BuildingsLoot.Blips[ID],125,0,0,255)
	end,900000,1,Pickup)
	setTimer(function(ID)
		setBlipColor(BuildingsLoot.Blips[ID],0,125,0,255)
	end,3600000,1,ID)
	
	if(math.random(1,5) == 3)then
		local x,y,z = getElementPosition(BuildingsLoot.Pickups[ID])
		for i = 1, math.random(2,4) do
			createZombie(x,y,z)
		end
		NPC.MeMessage(player,getText(player,"MeMessage1"))
	else
		BuildingsLoot.spawnPlayerInHouse(player)
	end
end
addEvent("BuildingsLoot.EnterBuilding",true)
addEventHandler("BuildingsLoot.EnterBuilding",root,BuildingsLoot.EnterBuilding)

function BuildingsLoot.spawnPlayerInHouse(player)
	local x,y,z = getElementPosition(player)
	BuildingsLoot.savePos[player] = {x,y,z}

    local Pickup = apocalypseGetElementData(player,"BuildingsLoot:Pickup")
	local Type = apocalypseGetElementData(Pickup,"Type")
	local ID = apocalypseGetElementData(Pickup,"ID")
	local Int, Dim = BuildingsLoot.Data[ID].Interior, BuildingsLoot.Data[ID].Dimension
	local spawnx, spawny, spawnz = BuildingsLoot["Data"][Type][Int][1],BuildingsLoot["Data"][Type][Int][2],BuildingsLoot["Data"][Type][Int][3]
	
	setElementPosition(player,spawnx,spawny,spawnz)
	setElementInterior(player,BuildingsLoot["Data"][Type][Int][5])
	setElementDimension(player,ID)
	
    unbindKey(player,"e","down",BuildingsLoot.BreakDoor)
	apocalypseSetElementData(player,"BuildingsLoot:Active",true)
	triggerClientEvent(player,"BuildingsLoot.Info",player,getText(player,"CBuildingsLoot1"))
	triggerClientEvent(player,"addTimer",player,tonumber(apocalypseGetElementData(Pickup,"LootTimer")) + 900,getText(player,"Timer1"),"HouseLooting")
	
	BuildingsLoot.getLootAmount(player)
end

function BuildingsLoot.leaveHouse(player,Type)
	local x,y,z = BuildingsLoot.savePos[player][1],BuildingsLoot.savePos[player][2],BuildingsLoot.savePos[player][3]
	local px,py,pz = getElementPosition(BuildingsLoot.Outobject[getElementDimension(player)])
	if(getDistanceBetweenPoints3D(px,py,pz,getElementPosition(player)) <= 5)then
		unbindKey(player,"e","down",BuildingsLoot.leaveHouse)
		setElementPosition(player,x,y,z)
		setElementInterior(player,0)
		setElementDimension(player,0)
		apocalypseSetElementData(player,"BuildingsLoot:Active",false)
		apocalypseSetElementData(player,"TeleportInInterior",false)
		triggerClientEvent(player,"BuildingsLoot.Info",player)
		triggerClientEvent(player,"addTimer",player,0,getText(player,"Timer1"),"HouseLooting")
	end
end

function BuildingsLoot.createLootObjects(Type,Interior,Dimension)
	BuildingsLoot.lootObjects[Dimension] = {}
	if(#BuildingsLoot["LootObjects"][Type][Interior] >= 1)then
		for i,v in ipairs(BuildingsLoot["LootObjects"][Type][Interior])do
			BuildingsLoot.lootObjects[Dimension][i] = createObject(v[7],v[1],v[2],v[3],v[4],v[5],v[6])
			setElementInterior(BuildingsLoot.lootObjects[Dimension][i],BuildingsLoot["Data"][Type][Interior][5])
			setElementDimension(BuildingsLoot.lootObjects[Dimension][i],Dimension)
			apocalypseSetElementData(BuildingsLoot.lootObjects[Dimension][i],"Player","")
			apocalypseSetElementData(BuildingsLoot.lootObjects[Dimension][i],"LootPlace",true)
			apocalypseSetElementData(BuildingsLoot.lootObjects[Dimension][i],"Type",Type)
		end
	end
end

addEventHandler("onPlayerClick", root, function(button, state, clickedElement)
	if(isCharacterLoggedIn(source))then
		if(button == "left" and state == "down" and clickedElement)then
			if(apocalypseGetElementData(clickedElement, "LootPlace") == true)then
				local px, py, pz = getElementPosition(source)
				local ox, oy, oz = getElementPosition(clickedElement)

				local maxDistance = 2.5
				local groundTolerance = 0.5

				if(getDistanceBetweenPoints3D(px, py, pz, ox, oy, oz) <= maxDistance)then
					local player = source

					if(apocalypseGetElementData(player, "SearchBuildingLoot") == nil) then
						apocalypseSetElementData(player, "SearchBuildingLoot", false)
					end

					if(apocalypseGetElementData(player, "SearchBuildingLoot") == false)then
						if((pz - oz)  >= groundTolerance) then
							setPedAnimation(player,"bomber","bom_plant_loop",-1,true,false,false,true)
						else
							setPedAnimation(player, "ped", "ATM")
						end
						toggleAllControls(player, false)
						apocalypseSetElementData(player, "SearchBuildingLoot", true)
						apocalypseSetElementData(source, "BuildingsLoot:Object", clickedElement)
						BuildingsLoot.startLoot(player)
					end
				end
			end
		end
	end
end)

function BuildingsLoot.destroyLootObjects(Interior,Dimension)
	for _,v in pairs(BuildingsLoot.lootObjects[Dimension])do
		destroyElement(v)
	end
	destroyPoliceDepartmentObjects(Dimension)
end

local function hasPlayerLootObject(player)
	local object = apocalypseGetElementData(player,"BuildingsLoot:Object")
	local loot = false
	if(object)then
		local objectPlayer = apocalypseGetElementData(object,"Player")
		local values = split(objectPlayer,"|")
		
		for _,v in pairs(values)do
			if(v == getCharacterName(player))then
				loot = true
				break
			end
		end
	end
	return loot
end

function BuildingsLoot.getLootAmount(player)
	if(not(player))then player = client end
	local dimension = getElementDimension(player)
	if(BuildingsLoot.lootObjects[dimension])then
		local totalLoot = 0
		local looted = 0
		for _,v in pairs(BuildingsLoot.lootObjects[dimension])do
			totalLoot = totalLoot + 1
			local objectPlayer = apocalypseGetElementData(v,"Player")
			local values = split(objectPlayer,"|")
		
			for _,v in pairs(values)do
				if(v == getCharacterName(player))then
					looted = looted + 1
				end
			end
		end
		
		if(looted == totalLoot)then
			local bonusEXP = totalLoot * 10
			if(SERVERBONUS.LOOTING == true)then bonusEXP = bonusEXP * 2 end
			giveEXP(player,bonusEXP)
			
			SkillpointStreak.Buildings(player)
			local looted_places = getPlayerData("character_stats","character_id",getCharacterID(player),"looted_places")
			Characters.addStats(player,"looted_places",looted_places + 1)
			for _,v in pairs(Achievements)do
				if(looted_places + 1 >= v[1])then
					setAchievement(player,v[2])
				end
			end
		end
		
		if(looted == 0)then
			NPC.MeMessage(player,getText(player,"MeMessage6"))
		end
		
		triggerClientEvent(player,"BuildingsLoot.updateAmount",player,totalLoot,looted)
	end
end
addEvent("BuildingsLoot.getLootAmount",true)
addEventHandler("BuildingsLoot.getLootAmount",root,BuildingsLoot.getLootAmount)

function BuildingsLoot.startLoot(player)
	if(hasPlayerLootObject(player) == false)then
		local object = apocalypseGetElementData(player,"BuildingsLoot:Object")
		local objectPlayer = apocalypseGetElementData(object,"Player")
		local objectPlayer = objectPlayer..getCharacterName(player).."|"
		local Type = apocalypseGetElementData(object,"Type")
		apocalypseSetElementData(object,"Player",objectPlayer)
		triggerClientEvent(player,"createProgressBar",player,3)
		setTimer(function(player)
			if(isElement(player))then
				setPedAnimation(player)
				apocalypseSetElementData(player,"SearchBuildingLoot",false)
				toggleAllControls(player,true)
				if(math.random(1,3) ~= 2)then
					if(object)then
						local specialItem = false
						if(Type == "Sexshop" or Type == "Gasstation" or Type == "Ammunation" or Type == "Hospital" or Type == "Pizza" or Type == "Supermarket" or Type == "Skinshop" or Type == "CluckinBell" or Type == "FireDepartment" or Type == "PoliceDepartment" or Type == "Bar" or Type == "Burgershot" or Type == "Donutshop" or Type == "Barbershop" or Type == "Tattoo")then
							if(math.random(1,3) == 2)then
								specialItem = true
							end
						end
						if(specialItem == true)then
							if(Type == "Sexshop")then
								giveItem(player,23,1)
								NPC.MeMessage(player,getText(player,"SBuildingsLoot11"))
								triggerClientEvent(player, "showItemBar", player, {{23,1}})
							elseif(Type == "Gasstation")then
								giveItem(player,27,1)
								NPC.MeMessage(player,getText(player,"SBuildingsLoot12"))
								triggerClientEvent(player, "showItemBar", player, {{27,1}})
							elseif(Type == "Ammunation")then
								giveItem(player,22,1)
								NPC.MeMessage(player,getText(player,"SBuildingsLoot13"))
								triggerClientEvent(player, "showItemBar", player, {{22,1}})
							elseif(Type == "Hospital")then
								NPC.MeMessage(player,getText(player,"SBuildingsLoot14"))
								giveItem(player,28,1)
								triggerClientEvent(player, "showItemBar", player, {{28,1}})
							elseif(Type == "Pizza")then
								NPC.MeMessage(player,getText(player,"SBuildingsLoot15"))
								giveItem(player,29,1)
								triggerClientEvent(player, "showItemBar", player, {{29,1}})
							elseif(Type == "Supermarket")then
								NPC.MeMessage(player,getText(player,"SBuildingsLoot16"))
								giveItem(player,33,1)
								triggerClientEvent(player, "showItemBar", player, {{33,1}})
							elseif(Type == "Skinshop")then
								NPC.MeMessage(player,getText(player,"SBuildingsLoot17"))
								giveItem(player,32,1)
								triggerClientEvent(player, "showItemBar", player, {{32,1}})
							elseif(Type == "CluckinBell")then
								NPC.MeMessage(player,getText(player,"SBuildingsLoot18"))
								giveItem(player,52,1)
								triggerClientEvent(player, "showItemBar", player, {{52,1}})
							elseif(Type == "FireDepartment")then
								NPC.MeMessage(player,getText(player,"SBuildingsLoot24"))
								giveItem(player,55,1)
								triggerClientEvent(player, "showItemBar", player, {{55,1}})
							elseif(Type == "PoliceDepartment")then
								NPC.MeMessage(player,getText(player,"SBuildingsLoot25"))
								giveItem(player,54,1)
								triggerClientEvent(player, "showItemBar", player, {{54,1}})
								local BuildingsLootID = apocalypseGetElementData(player,"BuildingsLoot:ID")
								if(math.random(1,2) == 2 and apocalypseGetElementData(BuildingsLoot.Pickups[BuildingsLootID],"PoliceDepartmentKeypadKey") ~= true)then
									apocalypseGetElementData(BuildingsLoot.Pickups[BuildingsLootID],"PoliceDepartmentKeypadKey",true)
									apocalypseSetElementData(player,"PoliceDepartmentKeypadKey",getElementDimension(player))
									NPC.MeMessage(player,getText(player,"SBuildingsLoot27"))
								end
							elseif(Type == "Bar")then
								NPC.MeMessage(player,getText(player,"SBuildingsLoot18"))
								giveItem(player,51,1)
								triggerClientEvent(player, "showItemBar", player, {{51,1}})
							elseif(Type == "Burgershot")then
								NPC.MeMessage(player,getText(player,"SBuildingsLoot20"))
								giveItem(player,49,1)
								triggerClientEvent(player, "showItemBar", player, {{49,1}})
							elseif(Type == "Donutshop")then
								NPC.MeMessage(player,getText(player,"SBuildingsLoot21"))
								giveItem(player,50,1)
								triggerClientEvent(player, "showItemBar", player, {{50,1}})
							elseif(Type == "Tattoo")then
								NPC.MeMessage(player,getText(player,"SBuildingsLoot22"))
								giveItem(player,48,1)
								triggerClientEvent(player, "showItemBar", player, {{48,1}})
							elseif(Type == "Barbershop")then
								NPC.MeMessage(player,getText(player,"SBuildingsLoot23"))
								giveItem(player,53,1)
								triggerClientEvent(player, "showItemBar", player, {{53,1}})
							end
						else
							giveLootItems(player,math.random(1,3))
						end
						local Level_Bonus_EXP = tonumber(apocalypseGetElementData(player,"level"))
						if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
						local EXP = 10 + (Level_Bonus_EXP * 1)
						local skillpoints = 1
						if(SERVERBONUS.LOOTING == true)then
							EXP = EXP * 2
							skillpoints = skillpoints * 2
						end
						giveEXP(player,EXP)
						givePlayerSkillpoint(player,skillpoints)
					end
				else
					local Level_Bonus_EXP = tonumber(apocalypseGetElementData(player,"level"))
					if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
					local EXP = 10 + (Level_Bonus_EXP * 1)
					local skillpoints = 1
					if(SERVERBONUS.LOOTING == true)then
						EXP = EXP * 2
						skillpoints = skillpoints * 2
					end
				
					giveEXP(player,EXP)
					givePlayerSkillpoint(player,skillpoints)
					NPC.MeMessage(player,getText(player,"SBuildingsLoot9"))
				end
			end
		end,3000,1,player)
		BuildingsLoot.getLootAmount(player)
	else
		setPedAnimation(player)
		apocalypseSetElementData(player,"SearchBuildingLoot",false)
		toggleAllControls(player,true)
		NPC.MeMessage(player,getText(player,"SBuildingsLoot7"))
	end
end

addEvent("BuildingsLoot.showBlipsFalse",true)
addEventHandler("BuildingsLoot.showBlipsFalse",root,function()
	for i = 1,#BuildingsLoot.Blips do
		setElementVisibleTo(BuildingsLoot.Blips[i],source,false)
	end
end)

function BuildingsLoot.showBlipsTrue(player)
	if(not(player))then player = client end
	for _,v in pairs(BuildingsLoot.Blips)do
		setElementVisibleTo(v,player,true)
	end
end
addEvent("BuildingsLoot.showBlipsTrue",true)
addEventHandler("BuildingsLoot.showBlipsTrue",root,BuildingsLoot.showBlipsTrue)