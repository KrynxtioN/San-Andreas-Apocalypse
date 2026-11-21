Vehiclesystem = {server_vehicles = {}, fuel_timer = {}}

function addPlayerVehicle(player, model)
	dbExec(handler,"INSERT into vehicles (owner_character_id,model,exploded,parkstatus) VALUES ('"..getCharacterID(player).."','"..model.."','0','1')")
end

function loadPlayerVehicles(player)
	local result = dbPoll(dbQuery(handler,"SELECT * FROM vehicles WHERE owner_character_id = '"..getCharacterID(player).."' AND parkstatus = '0'"),-1)
	if(#result >= 1)then
		for _,v in pairs(result)do
			if(not(isElement(Vehiclesystem.server_vehicles[v["ID"]])))then
				if(not(v["x"] == 0))then
					Vehiclesystem.server_vehicles[v["ID"]] = createVehicle(v["model"],v["x"],v["y"],v["z"],0,0,v["rotz"])
					apocalypseSetElementData(Vehiclesystem.server_vehicles[v["ID"]],"vehicle_owner",getPlayerData("vehicles","ID",v["ID"],"owner_character_id"))
					apocalypseSetElementData(Vehiclesystem.server_vehicles[v["ID"]],"VehicleID_Database",v["ID"])
					apocalypseSetElementData(Vehiclesystem.server_vehicles[v["ID"]],"kilometre",v["kilometre"])
					Tuningsystem.loadTunings(Vehiclesystem.server_vehicles[v["ID"]])
					SpecialEngine.load(Vehiclesystem.server_vehicles[v["ID"]])
					setVehicleLocked(Vehiclesystem.server_vehicles[v["ID"]],true)
				end
			end
		end
	end
end

function checkPlayerVehicleFreeSlot(player)
	local vehicle_slots = getPlayerData("characters","ID",getCharacterID(player),"vehicle_slots")
	local result = dbPoll(dbQuery(handler,"SELECT * FROM vehicles WHERE owner_character_id = '"..getCharacterID(player).."'"),-1)
	if(#result < vehicle_slots)then
		return true
	else
		return false
	end
end

function getPlayerVehicleSlots(player)
	local vehicle_slots = getPlayerData("characters","ID",getCharacterID(player),"vehicle_slots")
	return vehicle_slots
end

function Vehiclesystem.bindKey(player)
	bindKey(player,"x","down",changeMotorKey)
	bindKey(player,"l","down",changeLightKey)
end

function changeMotorKey(player)
	if(isPedInVehicle(player))then
		if(getPedOccupiedVehicleSeat(player) == 0)then
			local vehicle = getPedOccupiedVehicle(player)
			if(apocalypseGetElementData(vehicle,"LootVehicle") ~= true)then
				local model = getElementModel(vehicle)
				if(model == 509 or model == 481 or model == 510)then
					return
				end
				changeMotor(vehicle)
			end
		end
	end
end

function changeLightKey(player)
	if(isPedInVehicle(player))then
		if(getPedOccupiedVehicleSeat(player) == 0)then
			local vehicle = getPedOccupiedVehicle(player)
			if(apocalypseGetElementData(vehicle,"LootVehicle") ~= true)then
				local model = getElementModel(vehicle)
				if(model == 509 or model == 481 or model == 510)then
					return
				end
				changeLights(vehicle)
			end
		end
	end
end

function changeMotor(vehicle)
	if(apocalypseGetElementData(vehicle,"engine") == "on")then
		setVehicleEngineState(vehicle,false)
		apocalypseSetElementData(vehicle,"engine","off")
		if(isTimer(Vehiclesystem.fuel_timer[vehicle]))then
			killTimer(Vehiclesystem.fuel_timer[vehicle])
		end
	else
		if(apocalypseGetElementData(vehicle,"fuel") > 0)then
			setVehicleEngineState(vehicle,true)
			apocalypseSetElementData(vehicle,"engine","on")
			if(not(isTimer(Vehiclesystem.fuel_timer[vehicle])))then
				Vehiclesystem.fuel_timer[vehicle] = setTimer(function(vehicle)
					local fuel = apocalypseGetElementData(vehicle,"fuel")
					if(fuel and fuel > 0)then
						local player = getVehicleOccupant(vehicle,0)
						local state = true
						if(player)then
							if(getSkillLevel(player,2) >= 2)then
								if(math.random(1,2) == 1)then
									state = false
								end
							end
						end
						if(state == true)then
							local model = getElementModel(vehicle)
							if(model == 509 or model == 481 or model == 510)then return end
							apocalypseSetElementData(vehicle,"fuel",apocalypseGetElementData(vehicle,"fuel")-1)
							if(apocalypseGetElementData(vehicle,"fuel") == 0)then
								setVehicleEngineState(vehicle,false)
								apocalypseSetElementData(vehicle,"engine","off")
							end
						end
					end
				end,10000,0,vehicle)
			end
		end
	end
end

function changeLights(vehicle)
	if(apocalypseGetElementData(vehicle,"lights") == "on")then
		setVehicleOverrideLights(vehicle,1)
		apocalypseSetElementData(vehicle,"lights","off")
	else
		setVehicleOverrideLights(vehicle,2)
		apocalypseSetElementData(vehicle,"lights","on")
	end
end

addEvent("Vehiclesystem.park",true)
addEventHandler("Vehiclesystem.park",root,function()
	local vehicle_interaction_id = tonumber(apocalypseGetElementData(client,"vehicle_interaction_id"))
	if(isElement(Vehiclesystem.server_vehicles[vehicle_interaction_id]))then
		local vehicle = Vehiclesystem.server_vehicles[vehicle_interaction_id]
		local x,y,z = getElementPosition(vehicle)
		local rx,ry,rz = getElementRotation(vehicle)
		dbExec(handler,"UPDATE vehicles SET x = '"..x.."', y = '"..y.."', z = '"..z.."', rotz = '"..rz.."' WHERE ID = '"..vehicle_interaction_id.."'")
		createInfobox(client,getText(client,"SVehicles11"))
	end
end)

addEvent("Vehiclesystem.lock",true)
addEventHandler("Vehiclesystem.lock",root,function()
	local vehicle_interaction_id = tonumber(apocalypseGetElementData(client,"vehicle_interaction_id"))
	if(isElement(Vehiclesystem.server_vehicles[vehicle_interaction_id]))then
		local vehicle = Vehiclesystem.server_vehicles[vehicle_interaction_id]
		local lockState = isVehicleLocked(vehicle)
		if(lockState)then
			setVehicleLocked(vehicle,false)
			createInfobox(client,getText(client,"SVehicles9"))
		else
			setVehicleLocked(vehicle,true)
			createInfobox(client,getText(client,"SVehicles8"))
		end
	end
end)

addEventHandler("onPlayerClick", root, function(mouseButton, buttonState, clickedElement)
    if(mouseButton == "left" and buttonState == "down")then
        if(isElement(clickedElement) and getElementType(clickedElement) == "vehicle")then
            local vehicle_id = tonumber(apocalypseGetElementData(clickedElement,"VehicleID_Database"))
			if(vehicle_id)then
				local ownerID = apocalypseGetElementData(clickedElement,"vehicle_owner")
				local ownerName = getPlayerData("characters","ID",ownerID,"name")
				apocalypseSetElementData(source,"vehicle_interaction_id",vehicle_id)
				apocalypseSetElementData(source,"vehicle_interaction_owner",ownerName)
				triggerClientEvent(source,"Vehiclesystem.createWindow",source)
			end
		end
	end
end)

addEventHandler("onVehicleEnter",root,function(player)
	if(getPedOccupiedVehicleSeat(player) == 0)then
		local vehicle = getPedOccupiedVehicle(player)
		local model = getElementModel(vehicle)
		if(model == 509 or model == 481 or model == 510)then
			apocalypseSetElementData(source,"engine","on")
			apocalypseSetElementData(source,"lights","off")
		end
	
		if(not(apocalypseGetElementData(source,"engine")))then
			apocalypseSetElementData(source,"engine","off")
			apocalypseSetElementData(source,"lights","off")
		end
		if(not(apocalypseGetElementData(source,"fuel")))then
			apocalypseSetElementData(source,"fuel",100)
		end
		if(apocalypseGetElementData(source,"fuel") < 1)then
			apocalypseSetElementData(source,"engine","off")
		end

		if(apocalypseGetElementData(source,"engine") == "on")then
			setVehicleEngineState(source,true)
		else
			setVehicleEngineState(source,false)
		end
			
		if(apocalypseGetElementData(source,"lights") == "on")then
			setVehicleOverrideLights(source,2)
		else
			setVehicleOverrideLights(source,1)
		end
		if(not(apocalypseGetElementData(source,"kilometre")))then
			apocalypseSetElementData(source,"kilometre",0)
		end
		if(apocalypseGetElementData(source,"LootVehicle") ~= true)then
			triggerClientEvent(player,"createActivitiesInformationText",player,getText(player,"SVehicles13"))
		end
	end
end)

setTimer(function()
	for _,v in pairs(getElementsByType("vehicle"))do
		local nx,ny,nz = getElementPosition(v)
		if(not(apocalypseGetElementData(v,"OldX")))then
			apocalypseSetElementData(v,"OldX",nx)
			apocalypseSetElementData(v,"OldY",ny)
			apocalypseSetElementData(v,"OldZ",nz)
		end
		
		local ox,oy,oz = apocalypseGetElementData(v,"OldX"),apocalypseGetElementData(v,"OldY"),apocalypseGetElementData(v,"OldZ")
		local distance = getDistanceBetweenPoints3D(ox,oy,oz,nx,ny,nz)
		if(not(apocalypseGetElementData(v,"kilometre")))then
			apocalypseSetElementData(v,"kilometre",0)
		end
		apocalypseSetElementData(v,"kilometre",math.floor(apocalypseGetElementData(v,"kilometre") + distance/100))
		local ID = apocalypseGetElementData(v,"VehicleID_Database")
		if(ID)then
			dbExec(handler,"UPDATE vehicles SET kilometre = '"..apocalypseGetElementData(v,"kilometre").."' WHERE ID = '"..ID.."'")
		end
		apocalypseSetElementData(v,"OldX",ox)
		apocalypseSetElementData(v,"OldY",oy)
		apocalypseSetElementData(v,"OldZ",oz)
	end
end,60000,0)

addEvent("Vehiclesystem.openTrunk",true)
addEventHandler("Vehiclesystem.openTrunk",root,function()
    local itemString = getPlayerData("vehicles", "ID", apocalypseGetElementData(client,"vehicle_interaction_id"), "trunk")
	local trunk = {}
    if(itemString)then
		if(#itemString >= 1)then
			local itemPairs = split(itemString, "|")
			for _, v in ipairs(itemPairs)do
				local itemInfo = split(v, ",")
				local itemID = tonumber(itemInfo[1])
				local amount = tonumber(itemInfo[2])
				table.insert(trunk, {item = itemID, amount = amount})
			end
		end
    end
	triggerClientEvent(client,"Vehiclesystem.openTrunk",client,trunk)
end)

function updateTrunk(player)
    local itemString = getPlayerData("vehicles", "ID", apocalypseGetElementData(player,"vehicle_interaction_id"), "trunk")
	local trunk = {}
    if(itemString)then
		if(#itemString >= 1)then
			local itemPairs = split(itemString, "|")
			for _, v in ipairs(itemPairs)do
				local itemInfo = split(v, ",")
				local itemID = tonumber(itemInfo[1])
				local amount = tonumber(itemInfo[2])
				table.insert(trunk, {item = itemID, amount = amount})
			end
		end
    end
	triggerClientEvent(player,"Vehiclesystem.updateTrunk",player,trunk)
end

addEvent("Vehiclesystem.addItemToTrunk", true)
addEventHandler("Vehiclesystem.addItemToTrunk", root, function(itemID, amount)
	if(hasPlayerItem(client,tonumber(itemID)) >= tonumber(amount))then
		local vehicleID = apocalypseGetElementData(client, "vehicle_interaction_id")
		local result = dbPoll(dbQuery(handler, "SELECT trunk FROM vehicles WHERE ID = '" .. vehicleID .. "'"), -1)
		
		if #result >= 1 then
			local trunkData = result[1].trunk
			local newTrunk = {}
			local found = false
			
			for item in string.gmatch(trunkData, "([^|]+)") do
				local id, amt = string.match(item, "(%d+),(%d+)")
				if tonumber(id) == tonumber(itemID) then
					table.insert(newTrunk, id .. "," .. (tonumber(amt) + amount))
					found = true
				else
					table.insert(newTrunk, item)
				end
			end
			
			if not found then
				table.insert(newTrunk, itemID .. "," .. amount)
			end
			
			local updatedTrunkData = table.concat(newTrunk, "|")
			dbExec(handler, "UPDATE vehicles SET trunk = ? WHERE ID = ?", updatedTrunkData, vehicleID)
			takeItem(client,tonumber(itemID),tonumber(amount))
			updateTrunk(client)
		end
	else NPC.MeMessage(client,getText(client,"STrunk1"))end
end)

addEvent("Vehiclesystem.removeItemFromTrunk", true)
addEventHandler("Vehiclesystem.removeItemFromTrunk", root, function(itemID, amount)
    local vehicleID = apocalypseGetElementData(client, "vehicle_interaction_id")
    local result = dbPoll(dbQuery(handler, "SELECT trunk FROM vehicles WHERE ID = '" .. vehicleID .. "'"), -1)
	local owner_id = apocalypseGetElementData(Vehiclesystem.server_vehicles[vehicleID],"vehicle_owner")
	if(tonumber(owner_id) == getCharacterID(client))then
		if #result >= 1 then
			local trunkData = result[1].trunk
			local newTrunk = {}
			local itemFound = false
			local hasEnough = false
			
			for item in string.gmatch(trunkData, "([^|]+)") do
				local id, amt = string.match(item, "(%d+),(%d+)")
				if tonumber(id) == tonumber(itemID) then
					itemFound = true
					if tonumber(amt) >= tonumber(amount) then
						hasEnough = true
					end
				end
			end
			
			if not itemFound then
				return
			end
			
			if not hasEnough then
				NPC.MeMessage(client,getText(client,"STrunk2"))
				return
			end

			for item in string.gmatch(trunkData, "([^|]+)") do
				local id, amt = string.match(item, "(%d+),(%d+)")
				if tonumber(id) == tonumber(itemID) then
					local newAmount = tonumber(amt) - amount
					if newAmount > 0 then
						table.insert(newTrunk, id .. "," .. newAmount)
					end
				else
					table.insert(newTrunk, item)
				end
			end
			
			local updatedTrunkData = table.concat(newTrunk, "|")
			dbExec(handler, "UPDATE vehicles SET trunk = ? WHERE ID = ?", updatedTrunkData, vehicleID)
			giveItem(client, tonumber(itemID), tonumber(amount))
			updateTrunk(client)
		end
	else
		NPC.MeMessage(client,getText(client,"SVehicles12"))
	end
end)

function MechanicSkillRepairVehicle(player)
	if(isPedInVehicle(player))then
		local vehicle = getPedVehicle(player)
		if(vehicle)then
			if(getSkillLevel(player,2) >= 1)then
				local health = getElementHealth(vehicle)
				if(health < 1000)then
					local neededRepairkits = math.floor((1000 - health) / 50)
					if(hasPlayerItem(player,8) >= neededRepairkits)then
						takeItem(player,neededRepairkits)
						fixVehicle(vehicle)
						NPC.MeMessage(player,getText(player,"SMechanicSkill1"))
						setAchievement(player,269)
					else
						NPC.MeMessage(player,getText(player,"SMechanicSkill2"):format(neededRepairkits))
					end
				else
					NPC.MeMessage(player,getText(player,"SMechanicSkill3"))
				end
			end
		end
	end
end