Garage = {
	["Spawn"] = {
		["Ground"] = {
			[1] = {700.67083740234,-460.25772094727,15.725325584412,180},
			[2] = {-1991.8802490234,86.920700073242,27.679899215698,0},
			[3] = {-2099.0166015625,-2410.3461914062,30.625,140},
			[4] = {-2463.1157226562,-117.05239868164,25.673599243164,180},
		},
		["Air"] = {
			[1] = {1438.6131591797,-2494.0681152344,13.819700241089,270},
			[2] = {-1639.2279052734,-146.58160400391,14.41339969635,315},
			[3] = {-1639.2279052734,-146.58160400391,14.41339969635,315},
			[4] = {-1639.2279052734,-146.58160400391,14.41339969635,315},
		},
		["Water"] = {
			[1] = {1402.5197753906,-262.94259643555,0,286},
			[2] = {-1739.4782714844,-203.62690734863,0,326},
			[3] = {-2816.3332519531,-2551.8032226562,0,52},
			[4] = {-1739.4782714844,-203.62690734863,0,326},
		},
	},
}

local playerPos = {}

function Garage.getPlayerVehicles(player)
	if(not(player))then player = client end
	local vehicles = {}
	local result = dbPoll(dbQuery(handler,"SELECT * FROM vehicles WHERE owner_character_id = '"..getCharacterID(player).."'"),-1)
	if(result and #result >= 1)then
		for _,v in pairs(result)do
			table.insert(vehicles,{v["ID"],v["owner_character_id"],v["model"],v["exploded"],v["parkstatus"],v["fuel"]})
		end
	end
	triggerClientEvent(player,"Garage.updatePlayerVehicles",player,vehicles)
end
addEvent("Garage.getPlayerVehicles",true)
addEventHandler("Garage.getPlayerVehicles",root,Garage.getPlayerVehicles)

addEvent("Garage.park",true)
addEventHandler("Garage.park",root,function(vehicleID,garageID)
	local parkstatus = getPlayerData("vehicles","ID",vehicleID,"parkstatus")
	if(parkstatus == 1)then
		local model = getPlayerData("vehicles","ID",vehicleID,"model")
		local Type = "Ground"
		if(model == 473)then
			Type = "Water"
		end
		if(model == 512 or model == 460 or model == 513 or model == 511 or model == 593 or model == 487 or model == 447 or model == 469)then
			Type = "Air"
		end
		
		local spawnX = Garage["Spawn"][Type][garageID][1]
		local spawnY = Garage["Spawn"][Type][garageID][2]
		local spawnZ = Garage["Spawn"][Type][garageID][3]
		local Rotation = Garage["Spawn"][Type][garageID][4]
		
		dbExec(handler,"UPDATE vehicles SET parkstatus = '0' WHERE ID = '"..vehicleID.."'")
		Garage.createPlayerVehicle(client,vehicleID,spawnX,spawnY,spawnZ,Rotation)
	else
		if(isElement(Vehiclesystem.server_vehicles[vehicleID]))then destroyElement(Vehiclesystem.server_vehicles[vehicleID])end
		dbExec(handler,"UPDATE vehicles SET parkstatus = '1' WHERE ID = '"..vehicleID.."'")
		Garage.getPlayerVehicles(client)
	end
end)

function Garage.createPlayerVehicle(player,ID,x,y,z,rz)
	if(isElement(Vehiclesystem.server_vehicles[ID]))then destroyElement(Vehiclesystem.server_vehicles[ID])end
	local model = getPlayerData("vehicles","ID",ID,"model")
	triggerClientEvent(player,"Garage.close",player)
	Vehiclesystem.server_vehicles[ID] = createVehicle(model,x,y,z,0,0,rz)
	apocalypseSetElementData(Vehiclesystem.server_vehicles[ID],"vehicle_owner",getPlayerData("vehicles","ID",ID,"owner_character_id"))
	warpPedIntoVehicle(player,Vehiclesystem.server_vehicles[ID])
	apocalypseSetElementData(Vehiclesystem.server_vehicles[ID],"VehicleID_Database",ID)
	apocalypseSetElementData(Vehiclesystem.server_vehicles[ID],"kilometre",getPlayerData("vehicles","ID",ID,"kilometre"))
	Tuningsystem.loadTunings(Vehiclesystem.server_vehicles[ID])
	SpecialEngine.load(Vehiclesystem.server_vehicles[ID])
	
	local color = Garage.getVehicleColor(tonumber(ID))
	setVehicleColor(Vehiclesystem.server_vehicles[ID],color[1],color[2],color[3])
end

function Garage.getVehicleColor(ID)
	local query = dbQuery(handler, "SELECT color FROM vehicles WHERE ID = ?", ID)
	local result = dbPoll(query, -1)
	if(result and #result > 0)then
		local rgbString = result[1].color
		if(rgbString)then
			local rgbTable = split(rgbString,"|")
			if(#rgbTable == 3)then
				local r = tonumber(rgbTable[1])
				local g = tonumber(rgbTable[2])
				local b = tonumber(rgbTable[3])
				return {r,g,b}
			end
		end
	end
end

addEvent("Garage.checkOpen",true)
addEventHandler("Garage.checkOpen",root,function()
	local result = dbPoll(dbQuery(handler,"SELECT * FROM vehicles WHERE owner_character_id = '"..getCharacterID(client).."'"),-1)
	if(tonumber(getPlayerVehicleSlots(client)) >= 1)then
		if(result and #result >= 1)then
			local x,y,z = getElementPosition(client)
			playerPos[client] = {x,y,z}
			triggerClientEvent(client,"Garage.open",client)
		else createInfobox(client,getText(client,"SGarage4"))end
	else createInfobox(client,getText(client,"SGarage3"))end
end)

addEvent("Garage.spawnPlayerOutside",true)
addEventHandler("Garage.spawnPlayerOutside",root,function()
	if(playerPos[client])then
		setElementPosition(client,playerPos[client][1],playerPos[client][2],playerPos[client][3])
		setElementInterior(client,0)
		setElementDimension(client,0)
	end
end)

addEventHandler("onPlayerQuit", root, function()
	playerPos[source] = nil
end)