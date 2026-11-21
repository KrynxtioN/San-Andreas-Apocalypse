Tuningsystem = {
	["Marker"] = {
		{2644.9609375,-2045.8447265625,12.640233039856-0.9},
		{1041.7705078125,-1012.9990234375,32.080799102783-0.9},
		{2386.48828125,1051.6982421875,9.9280261993408-0.9},
		{-2725.255859375,217.642578125,4.484375-0.9},
		{-1935.8095703125,246.93359375,34.4609375-0.9},
	},
	["Spawn"] = {
		[1] = {2645.1435546875,-2034.6953125,13.553999900818,0},
		[2] = {1041.1796875,-1030.4844970703,32.079399108887,0},
		[3] = {2386.8608398438,1039.2142333984,10.820300102234,180},
		[4] = {-2710.8527832031,223.11390686035,4.1875,180},
		[5] = {-1929.6629638672,234.40969848633,34.394298553467,90},
	},
}

setGarageOpen( 7,true)
setGarageOpen(10,true)
setGarageOpen(15,true)
setGarageOpen(18,true)
setGarageOpen(33,true)

for i,v in ipairs(Tuningsystem["Marker"])do
	Tuningsystem[i] = createMarker(v[1],v[2],v[3],"cylinder",2,255,0,0,150)
	apocalypseSetElementData(Tuningsystem[i],"TuningID",i)
		
	addEventHandler("onMarkerHit",Tuningsystem[i],function(player)
		if(getElementDimension(player) == getElementDimension(source))then
			if(getElementType(player) == "vehicle")then

				local driver = getVehicleOccupant(player,0)
				if(not driver)then return end

				local veh = player
				local VehicleID_Database = getElementData(veh,"VehicleID_Database")
				if(VehicleID_Database)then
					local state = false
					for seat_id = 1,3 do
						if(getVehicleOccupant(veh,seat_id))then
							state = true
							createInfobox(driver,getText(driver,"STuning7"))
							break
						end
					end

					if(state == false)then
						local dim = getFreeDimension()
						setElementPosition(veh,614.44848632813,-124.11219787598,998.12097167969)
						setElementRotation(veh,0,0,90)
						setElementInterior(veh,3)
						setElementInterior(driver,3)
						setElementDimension(driver,dim)
						setElementDimension(veh,dim)

						apocalypseSetElementData(driver,"InTuninggarage",true)
						triggerClientEvent(driver,"Tuningsystem.openWindow",driver)

						apocalypseSetElementData(driver,"TuningID",getElementData(source,"TuningID"))
					else
						createInfobox(driver,getText(driver,"STuning1"))
					end
				else
					createInfobox(driver,getText(driver,"STuning2"))
				end
			end
		end
	end)
end

addEvent("Tuningsystem.spawnGarage",true)
addEventHandler("Tuningsystem.spawnGarage",root,function()
	setTimer(function(client)
		local ID = apocalypseGetElementData(client,"TuningID")
		apocalypseSetElementData(client,"InTuninggarage",false)
		local tbl = Tuningsystem["Spawn"][ID]
		local veh = getPedOccupiedVehicle(client)
		setElementPosition(veh,tbl[1],tbl[2],tbl[3])
		setElementRotation(veh,0,0,tbl[4])
		setElementInterior(veh,0)
		setElementInterior(client,0)
		setElementDimension(veh,0)
		setElementDimension(client,0)
		setCameraTarget(client)
		Tuningsystem.loadTunings(veh)
	end,50,1,client)
end)

addEvent("Tuningsystem.addRemoveTuning",true)
addEventHandler("Tuningsystem.addRemoveTuning",root,function(type,price,vehiclePart)
	local price = tonumber(price)
	local veh = getPedOccupiedVehicle(client)
	local vehiclePartsPrice = math.floor(price/100*10)
	if(type == "add")then
		if(hasPlayerItem(client,21) >= vehiclePartsPrice)then
			if(tonumber(apocalypseGetElementData(client,"money")) >= price)then
				addVehicleUpgrade(veh,vehiclePart)
				takeItem(client,21,vehiclePartsPrice)
				createInfobox(client,getText(client,"STuning3"))
				Tuningsystem.saveTunings(veh)
				setAchievement(client,265)
			else createInfobox(client,getText(client,"STuning6"))end
		else createInfobox(client,getText(client,"STuning5"))end
	elseif(type == "remove")then
		removeVehicleUpgrade(veh,vehiclePart)
		createInfobox(client,getText(client,"STuning4"))
		Tuningsystem.saveTunings(veh)
		setAchievement(client,270)
	elseif(type == "show")then
		addVehicleUpgrade(veh,vehiclePart)
	end
end)

function Tuningsystem.saveTunings(veh)
	local tunings = ""
	for i = 0,16 do
		local upgrade = getVehicleUpgradeOnSlot(veh,i)
		if(upgrade)then
			tunings = tunings..upgrade.."|"
		else
			tunings = tunings.."0|"
		end
	end
	dbExec(handler,"UPDATE vehicles SET tunings = '"..tunings.."' WHERE ID = '"..getElementData(veh,"VehicleID_Database").."'")
end

function Tuningsystem.loadTunings(veh)
	for i = 0,16 do
		local upgrade = getVehicleUpgradeOnSlot(veh,i)
		if(upgrade)then
			removeVehicleUpgrade(veh,upgrade)
		end
	end

	local result = dbPoll(dbQuery(handler,"SELECT tunings FROM vehicles WHERE ID = '"..getElementData(veh,"VehicleID_Database").."'"),-1)
	if(result and result[1])then
		local tunings = result[1]["tunings"]
		for i = 1,17 do
			local tstring = gettok(tunings,i,string.byte("|"))
			if(tstring and #tstring >= 1 and tstring ~= 0)then
				addVehicleUpgrade(veh,tstring)
			end
		end
	end
end
addEvent("Tuningsystem.loadTunings",true)
addEventHandler("Tuningsystem.loadTunings",root,Tuningsystem.loadTunings)