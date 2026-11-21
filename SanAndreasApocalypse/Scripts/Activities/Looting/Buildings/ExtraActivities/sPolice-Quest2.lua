EvidenceRoom = {DimensionData = {}, plantTimer = {}, ExplodeTimer = {},
	["RobObjectPositions"] = {
		{1550,276.85778808594,112.44470214844,1008.213684082,0,0,0},
		{1550,277.07620239258,111.92990112305,1008.213684082,0,0,0},
		{1550,277.40640258789,112.41480255127,1008.213684082,0,0,0},
		{1550,277.63821411133,111.93409729004,1008.213684082,0,0,0},
		{1550,278.03329467773,112.38069915771,1008.213684082,0,0,0},
		{1550,278.31939697266,111.88870239258,1008.213684082,0,0,0},
		{1550,278.57110595703,112.3516998291,1008.213684082,0,0,0},
		{2060,278.20568847656,107.38220214844,1007.9769897461,0,0,0},
		{2060,276.94650268555,107.48090362549,1007.9769897461,0,0,0},
		{2060,275.74661254883,107.39099884033,1007.9769897461,0,0,0},
		{1279,271.72689819336,107.41079711914,1007.891418457,0,0,0},
		{1279,270.58740234375,107.39730072021,1007.891418457,0,0,0},
		{1279,269.41650390625,107.44039916992,1007.891418457,0,0,0},
	},
}

function EvidenceRoom.loadRoom(Dimension)
	EvidenceRoom.unloadRoom(Dimension)

	EvidenceRoom.DimensionData[Dimension] = {}
	EvidenceRoom.DimensionData[Dimension].Objects = {}
	EvidenceRoom.DimensionData[Dimension].SecurityPed = createZombie(256.36019897461,119.20079803467,1008.8203125,10,Dimension)
	setElementInterior(EvidenceRoom.DimensionData[Dimension].SecurityPed,10)
	setElementDimension(EvidenceRoom.DimensionData[Dimension].SecurityPed,Dimension)
	EvidenceRoom.DimensionData[Dimension].Keypad = createObject(2886,268.33178710938,107.76820373535,1009.1972045898,0,0,270)
	setElementInterior(EvidenceRoom.DimensionData[Dimension].Keypad,10)
	setElementDimension(EvidenceRoom.DimensionData[Dimension].Keypad,Dimension)
	apocalypseSetElementData(EvidenceRoom.DimensionData[Dimension].Keypad,"EvidenceRoom",true)
	EvidenceRoom.DimensionData[Dimension].Door = createObject(2634,268.47821044922,109.08809661865,1009.103515625,0,0,90)
	setElementInterior(EvidenceRoom.DimensionData[Dimension].Door,10)
	setElementDimension(EvidenceRoom.DimensionData[Dimension].Door,Dimension)
	apocalypseSetElementData(EvidenceRoom.DimensionData[Dimension].Door,"Exploded",false)
	EvidenceRoom.DimensionData[Dimension].DoorMarker = createMarker(268.47821044922,109.08809661865,1008.103515625,"cylinder",2,0,0,0,0)
	setElementInterior(EvidenceRoom.DimensionData[Dimension].DoorMarker,10)
	setElementDimension(EvidenceRoom.DimensionData[Dimension].DoorMarker,Dimension)
	apocalypseSetElementData(EvidenceRoom.DimensionData[Dimension].DoorMarker,"BombPlanted",false)
	
	for i,v in ipairs(EvidenceRoom["RobObjectPositions"])do
		EvidenceRoom.DimensionData[Dimension].Objects[i] = createObject(v[1],v[2],v[3],v[4],v[5],v[6],v[7])
		setElementInterior(EvidenceRoom.DimensionData[Dimension].Objects[i],10)
		setElementDimension(EvidenceRoom.DimensionData[Dimension].Objects[i],Dimension)
		apocalypseSetElementData(EvidenceRoom.DimensionData[Dimension].Objects[i],"EvidenceRoom",true)
		apocalypseSetElementData(EvidenceRoom.DimensionData[Dimension].Objects[i],"EvidenceRoomLooted",false)
	end
	
	addEventHandler("onMarkerHit",EvidenceRoom.DimensionData[Dimension].DoorMarker,function(player)
		if(getElementDimension(player) == getElementDimension(source))then
			unbindKey(player,"e","down",EvidenceRoom.plantBomb)
			bindKey(player,"e","down",EvidenceRoom.plantBomb)
			triggerClientEvent(player,"createActivitiesInformationText",player,getText(player,"SNests1"))
		end
	end)
	
	addEventHandler("onPedWasted",EvidenceRoom.DimensionData[Dimension].SecurityPed,function(_,player)
		local x,y,z = getElementPosition(source)
		setTimer(function(dim)
			EvidenceRoom.DimensionData[dim].Keycard = createPickup(x,y,z,3,1581,50)
			setElementInterior(EvidenceRoom.DimensionData[dim].Keycard,10)
			setElementDimension(EvidenceRoom.DimensionData[dim].Keycard,dim)
			apocalypseSetElementData(EvidenceRoom.DimensionData[dim].Keycard,"EvidenceRoomDimension",dim)
			
			addEventHandler("onPickupHit",EvidenceRoom.DimensionData[dim].Keycard,function(player)
				if(not(isPedInVehicle(player)))then
					apocalypseSetElementData(player,"EvidenceRoomDimension",apocalypseGetElementData(source,"EvidenceRoomDimension"))
					destroyElement(source)
				end
			end)
		end,500,1,getElementDimension(player))
	end)
end

function EvidenceRoom.unloadRoom(Dimension)
	if(EvidenceRoom.DimensionData[Dimension])then
		if(isElement(EvidenceRoom.DimensionData[Dimension].SecurityPed))then destroyElement(EvidenceRoom.DimensionData[Dimension].SecurityPed)end
		if(isElement(EvidenceRoom.DimensionData[Dimension].Keypad))then destroyElement(EvidenceRoom.DimensionData[Dimension].Keypad)end
		if(isElement(EvidenceRoom.DimensionData[Dimension].Door))then destroyElement(EvidenceRoom.DimensionData[Dimension].Door)end
		if(isElement(EvidenceRoom.DimensionData[Dimension].DoorMarker))then destroyElement(EvidenceRoom.DimensionData[Dimension].DoorMarker)end
		for _,v in pairs(EvidenceRoom.DimensionData[Dimension].Objects)do
			destroyElement(v)
		end
		EvidenceRoom.DimensionData[Dimension] = nil
	end
end

function EvidenceRoom.DropKeycard(player)
	if(apocalypseGetElementData(player,"EvidenceRoomDimension"))then
		local Dimension = tonumber(apocalypseGetElementData(player,"EvidenceRoomDimension"))
		if(Dimension and EvidenceRoom.DimensionData[Dimension])then
			if(isElement(EvidenceRoom.DimensionData[Dimension].Keycard))then
				destroyElement(EvidenceRoom.DimensionData[Dimension].Keycard)
			end
			local x,y,z = getElementPosition(player)
			EvidenceRoom.DimensionData[Dimension].Keycard = createPickup(x,y,z,3,1581,50)
			setElementInterior(EvidenceRoom.DimensionData[Dimension].Keycard,getElementInterior(player))
			setElementDimension(EvidenceRoom.DimensionData[Dimension].Keycard,getElementDimension(player))
			
			addEventHandler("onPickupHit",EvidenRoom.DimensionData[Dimension].Keycard,function(player)
				if(not(isPedInVehicle(player)))then
					apocalypseSetElementData(player,"EvidenceRoomDimension",apocalypseGetElementData(source,"EvidenceRoomDimension"))
					destroyElement(source)
				end
			end)
		end
	end
	apocalypseSetElementData(player,"EvidenceRoomDimension",nil)
end

function EvidenceRoom.plantBomb(player)
	if(not(isTimer(EvidenceRoom.plantTimer[player])))then
		local Dimension = getElementDimension(player)
		if(not(isTimer(EvidenceRoom.ExplodeTimer[Dimension])))then
			if(EvidenceRoom.DimensionData[Dimension])then
				if(isElement(EvidenceRoom.DimensionData[Dimension].DoorMarker) and isElementWithinMarker(player,EvidenceRoom.DimensionData[Dimension].DoorMarker))then
					if(apocalypseGetElementData(EvidenceRoom.DimensionData[Dimension].DoorMarker,"BombPlanted") == false)then
						if(hasPlayerItem(player,26) >= 1)then
							local x,y,z = getElementPosition(player)
							setElementFrozen(player,true)
							setPedAnimation(player,"BOMBER", "BOM_Plant_Loop",-1,true,false,false,true)
							EvidenceRoom.DimensionData[Dimension].BombObject = createObject(1654,x-0.5,y,z-0.85,-90,0,0)
							setElementInterior(EvidenceRoom.DimensionData[Dimension].BombObject,getElementInterior(player))
							setElementDimension(EvidenceRoom.DimensionData[Dimension].BombObject,getElementDimension(player))
							apocalypseSetElementData(EvidenceRoom.DimensionData[Dimension].DoorMarker,"BombPlanted",true)
							takeItem(player,26,1)
							
							EvidenceRoom.plantTimer[player] = setTimer(function(player,Dimension)
								setPedAnimation(player)
								setElementFrozen(player,false)
								unbindKey(player,"e","down",EvidenceRoom.plantBomb)
								NPC.MeMessage(player,getText(player,"SPrisonQuest1"))
								
								EvidenceRoom.ExplodeTimer[Dimension] = setTimer(function(Dimension)
									local x,y,z = getElementPosition(EvidenceRoom.DimensionData[Dimension].BombObject)
									destroyElement(EvidenceRoom.DimensionData[Dimension].DoorMarker)
									destroyElement(EvidenceRoom.DimensionData[Dimension].BombObject)
									destroyElement(EvidenceRoom.DimensionData[Dimension].Door)
									createExplosion(x,y,z,9)
								end,7500,1,Dimension)
							end,5000,1,player,Dimension)
						else
							NPC.MeMessage(player,getText(player,"MeMessage7"))
						end
					end
				end
			end
		end
	end
end

function EvidenceRoom.startLoot(player)
	local object = apocalypseGetElementData(player,"EvidenceRoomClicked")
	triggerClientEvent(player,"createProgressBar",player,6)
	setTimer(function(player,object)
		if(isElement(player))then
			setPedAnimation(player)
			apocalypseSetElementData(player,"EvidenceRoomTimer",false)
			toggleAllControls(player,true)
			apocalypseSetElementData(player,"EvidenceRoomClicked",nil)
			
			local model = getElementModel(object)
			giveEXP(player,50)
			givePlayerSkillpoint(player,1)
			if(model == 1550)then
				givePlayerServerMoney(player,math.random(10,35))
			elseif(model == 2060)then
				giveLootItems(player,math.random(3,6))
				if(math.random(1,5) <= 2)then
					giveItem(player,57,math.random(1,2))
				end
			elseif(model == 1279)then
				if(math.random(1,5) <= 2)then
					giveItem(player,57,math.random(1,2))
				end
			end
			destroyElement(object)
		end
	end,6000,1,player,object)
end

addEventHandler("onPlayerClick", root, function(button, state, clickedElement)
    if(button == "left" and state == "down" and clickedElement)then
        if(apocalypseGetElementData(clickedElement, "EvidenceRoom") == true)then
			if apocalypseGetElementData(clickedElement,"EvidenceRoomLooted") == true then return end
			
			if(getElementModel(clickedElement) == 2886)then
				local Dimension = getElementDimension(clickedElement)
				if(isElement(EvidenceRoom.DimensionData[Dimension].Door))then
					if(apocalypseGetElementData(source,"EvidenceRoomDimension") == Dimension)then
						local x,y,z = getElementPosition(EvidenceRoom.DimensionData[Dimension].Door)
						moveObject(EvidenceRoom.DimensionData[Dimension].Door,3500,x,y,z-10)
						destroyElement(EvidenceRoom.DimensionData[Dimension].DoorMarker)
						setTimer(function(Dimension)
							destroyElement(EvidenceRoom.DimensionData[Dimension].Door)
						end,3500,1,Dimension)
					end
				end
			else
				local px, py, pz = getElementPosition(source)
				local ox, oy, oz = getElementPosition(clickedElement)

				local maxDistance = 2.5
				local groundTolerance = 0.5

				if(getDistanceBetweenPoints3D(px, py, pz, ox, oy, oz) <= maxDistance)then
					local player = source
						
					if(apocalypseGetElementData(player, "EvidenceRoomTimer") == nil) then
						apocalypseSetElementData(player, "EvidenceRoomTimer", false)
					end

					if(apocalypseGetElementData(player, "EvidenceRoomTimer") == false)then
						if((pz - oz)  >= groundTolerance) then
							setPedAnimation(player,"bomber","bom_plant_loop",-1,true,false,false,true)
						else
							setPedAnimation(player, "ped", "ATM")
						end
						toggleAllControls(player, false)
						apocalypseSetElementData(player, "EvidenceRoomTimer", true)
						apocalypseSetElementData(source, "EvidenceRoomClicked", clickedElement)
						EvidenceRoom.startLoot(player)
						apocalypseSetElementData(clickedElement,"EvidenceRoomLooted",true)
					end
				end
			end
        end
    end
end)

function EvidenceRoom.cancelPlant(player)
    toggleAllControls(player,true)
    setElementFrozen(player,false)
    setPedAnimation(player)
end

addEventHandler("onPlayerWasted",root,function()
	EvidenceRoom.DropKeycard(source)
	EvidenceRoom.cancelPlant(source)
end)

addEventHandler("onPlayerQuit",root,function()
	EvidenceRoom.DropKeycard(source)
	EvidenceRoom.cancelPlant(source)
end)