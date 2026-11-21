Bar = { BenchObjects = {},  BenchData = {},  HealPlayerTimer = {}, 
	["Bench:Objects"] = {
		{1368, -229.1708984375, 1403.6376953125, 27.504829406738, 0, 0, 180}, 
		{1368, -229.1708984375, 1405.2568359375, 27.504829406738, 0, 0, 0}, 
		{1368, -229.1708984375, 1405.974609375, 27.504829406738, 0, 0, 180}, 
		{1368, -229.1708984375, 1407.5537109375, 27.504829406738, 0, 0, 0}, 
		{1368, -229.1708984375, 1408.216796875, 27.504829406738, 0, 0, 180}, 
		{1368, -229.1708984375, 1409.8740234375, 27.504829406738, 0, 0, 0}, 
		{1368, -229.1708984375, 1410.546875, 27.504829406738, 0, 0, 180}, 
		{1368, -229.1708984375, 1412.208984375, 27.504829406738, 0, 0, 0}, 
	}, 
	["Bench:SitCoordinates"] = {
		[1] = {[1] = {-0.1, -0.4, 0.50, 0, 0, 0},  [2] = {-0.8, -0.4, 0.50, 0, 0, 0}}, 
		[2] = {[1] = {0.1, -0.4, 0.50, 0, 0, 180},  [2] = {0.8, -0.4, 0.50, 0, 0, 180}}, 
		[3] = {[1] = {-0.1, -0.4, 0.50, 0, 0, 0},  [2] = {-0.8, -0.4, 0.50, 0, 0, 0}}, 
		[4] = {[1] = {0.1, -0.4, 0.50, 0, 0, 180},  [2] = {0.8, -0.4, 0.50, 0, 0, 180}}, 
		[5] = {[1] = {-0.1, -0.4, 0.50, 0, 0, 0},  [2] = {-0.8, -0.4, 0.50, 0, 0, 0}}, 
		[6] = {[1] = {0.1, -0.4, 0.50, 0, 0, 180},  [2] = {0.8, -0.4, 0.50, 0, 0, 180}}, 
		[7] = {[1] = {-0.1, -0.4, 0.50, 0, 0, 0},  [2] = {-0.8, -0.4, 0.50, 0, 0, 0}}, 
		[8] = {[1] = {0.1, -0.4, 0.50, 0, 0, 180},  [2] = {0.8, -0.4, 0.50, 0, 0, 180}}, 
	}, 
}

for _,v in pairs(getElementsByType("player"))do
	apocalypseSetElementData(v,"Bar:UseBench",false)
end

function Bar.CreateObjects()
	for i, v in ipairs(Bar["Bench:Objects"])do
		if(not(isElement(Bar.BenchObjects[i])))then
			Bar.BenchObjects[i] = createObject(v[1], v[2], v[3], v[4], v[5], v[6], v[7])
			setElementDimension(Bar.BenchObjects[i], 0)
			setElementInterior(Bar.BenchObjects[i], 18)
			apocalypseSetElementData(Bar.BenchObjects[i], "Bar:BenchUsed", false)
			setElementAlpha(Bar.BenchObjects[i], 0)
			Bar.BenchData[i] = {"Unused", "Unused"}
			apocalypseSetElementData(Bar.BenchObjects[i], "Bar:BenchID", i)
			setElementCollisionsEnabled(Bar.BenchObjects[i], false)
		end
	end
	Bar.BenchZone = createColRectangle(-227.55505371094, 1403.2857666016, 0.7, 9.5)
	
	addEventHandler("onColShapeHit", Bar.BenchZone, function(player)
		if(getElementInterior(player) == 18)then
			if(getElementDimension(player) == 0)then
				if(apocalypseGetElementData(player, "Bar:UseBench") ~= true)then
					triggerClientEvent(player, "Bar.RenderBenchInfo", player)
					bindKey(player, "e", "down", Bar.UseBench)
				end
			end
		end
	end)
	
	addEventHandler("onColShapeLeave", Bar.BenchZone, function(player)
		if(getElementInterior(player) == 18)then
			if(getElementDimension(player) == 0)then
				triggerClientEvent(player, "Bar.UnrenderBenchInfo", player)
				if(apocalypseGetElementData(player, "Bar:UseBench") == false)then
					unbindKey(player, "e", "down", Bar.UseBench)
				end
			end
		end
	end)
end
Bar.CreateObjects()

local OldPosition = {}
function Bar.UseBench(player)
	local x, y, z = getElementPosition(player)
	local prevDistance,  nearestBench
	for _, v in pairs(Bar.BenchObjects)do
		local distance = getDistanceBetweenPoints3D(x, y, z, getElementPosition(v))
		if(distance <= (prevDistance or distance + 1))then
			prevDistance = distance
			nearestBench = v
		end
	end
	
	local ID,  SEAT = apocalypseGetElementData(nearestBench, "Bar:BenchID"),  nil
	if(Bar.BenchData[ID][1] == "Unused")then
		SEAT = 1
	else
		if(Bar.BenchData[ID][2] == "Unused")then
			SEAT = 2
		end
	end
	
	if(apocalypseGetElementData(player, "Bar:UseBench") == true)then
		if(apocalypseGetElementData(player,"AFK") ~= true)then
			detachElements(player)
			if(OldPosition[player])then
				local x, y, z = OldPosition[player][1], OldPosition[player][2], OldPosition[player][3]
				setElementPosition(player, x, y, z)
				OldPosition[player] = nil
			end
			Bar.BenchData[apocalypseGetElementData(player, "Bar:BenchID")][apocalypseGetElementData(player, "Bar:BenchIDSitz")] = "Unused"
			setPedAnimation(player)
			apocalypseSetElementData(player, "Bar:UseBench", false)
			apocalypseSetElementData(player, "Bar:BenchID", nil)
			apocalypseSetElementData(player, "Bar:BenchIDSitz", nil)
			if(isTimer(Bar.HealPlayerTimer[player]))then killTimer(Bar.HealPlayerTimer[player])end
			apocalypseSetElementData(player, "BarHealing", false)
		end
	else
		if(SEAT ~= nil)then
			setAchievement(player, 31)
			local Data = Bar["Bench:SitCoordinates"][ID][SEAT]
			setPedAnimation(player, "ped", "SEAT_idle", -1, true, false, true)
			OldPosition[player] = {x, y, z}, 
			apocalypseSetElementData(player, "Bar:UseBench", true)
			setTimer(function(player)
				setElementRotation(player, 0, 0, Data[6])
				attachElements(player, nearestBench, Data[1], Data[2], Data[3], Data[4], Data[5], Data[6])
			end, 100, 1, player)
			Bar.BenchData[ID][SEAT] = "Used"
			apocalypseSetElementData(player, "Bar:BenchID", ID)
			apocalypseSetElementData(player, "Bar:BenchIDSitz", SEAT)
			apocalypseSetElementData(player, "BarHealing", true)
			
			Bar.HealPlayerTimer[player] = setTimer(function(player)
				setElementHealth(player, getElementHealth(player)+1)
				giveEXP(player,5)
			end, 10000, 0, player)
		end
	end
end

addEvent("Bar.buyDrink", true)
addEventHandler("Bar.buyDrink", root, function(price, thirst, armor, level)
	if(price and thirst and armor and level)then
		if(tonumber(apocalypseGetElementData(client, "level")) >= tonumber(level))then
			if(tonumber(apocalypseGetElementData(client, "money")) >= tonumber(price))then
				apocalypseSetElementData(client, "money", apocalypseGetElementData(client, "money")-tonumber(price))
				giveThirst(client,thirst)
				giveHunger(client, armor)
				NPC.NormalMessage(client, getText(client, "SBar3"))
				setAchievement(client, 4)
				outputLog(getPlayerName(client).." hat für $"..price.." etwas gekauft","Bar",getCharacterID(client))
			else NPC.NormalMessage(client, getText(client, "SBar2"):format(tonumber(price)))end
		else NPC.NormalMessage(client, getText(client, "SBar1"):format(level))end
	end
end)

addEventHandler("onPlayerWasted", root, function()
	if(apocalypseGetElementData(source, "Bar:UseBench") == true)then
		detachElements(source)
		Bar.BenchData[apocalypseGetElementData(source, "Bar:BenchID")][apocalypseGetElementData(source, "Bar:BenchIDSitz")] = "Unused"
	end
	triggerClientEvent(source, "Bar.Close", source)
	if(isTimer(Bar.HealPlayerTimer[source]))then killTimer(Bar.HealPlayerTimer[source])end
end)

addEventHandler("onPlayerQuit", root, function()
	if(apocalypseGetElementData(source, "Bar:UseBench") == true)then
		detachElements(source)
		Bar.BenchData[apocalypseGetElementData(source, "Bar:BenchID")][apocalypseGetElementData(source, "Bar:BenchIDSitz")] = "Unused"
	end
	if(isTimer(Bar.HealPlayerTimer[source]))then killTimer(Bar.HealPlayerTimer[source])end
	apocalypseSetElementData(source, "BarHealing", false)
end)