VehicleEngineQuest = {
	Garages = {
		[1] = {
			gatePos = {2505.4665527344, -1690.9434814453, 14.33510017395, 0, 0, 270},
			vehiclePos = {2505.4699707031, -1695.470703125, 13.352600097656, 0, 0, 0},
		},
	},

	VehicleTimerSeconds = 900,
}

function VehicleEngineQuest.Load()
	for id, data in pairs(VehicleEngineQuest.Garages) do
		if isElement(data.gate) then destroyElement(data.gate) end
		if isElement(data.vehicle) then destroyElement(data.vehicle) end
		if isTimer(data.vehicleTimer) then killTimer(data.vehicleTimer) end

		data.gate = createObject(17951, unpack(data.gatePos))
		data.vehicle = createVehicle(411, unpack(data.vehiclePos))
		data.vehicleTimer = nil
		
		setVehicleDamageProof(data.vehicle, true)

		apocalypseSetElementData(data.gate, "VehicleEngineQuestID", id)
		apocalypseSetElementData(data.gate, "Lootable", true)

		apocalypseSetElementData(data.vehicle, "VehicleEngineQuest", true)
		apocalypseSetElementData(data.vehicle, "VehicleEngineQuestID", id)
		apocalypseSetElementData(data.vehicle, "VehicleEngineQuestActive", false)
		apocalypseSetElementData(data.vehicle, "VehicleEngineQuestEndTime", 0)
	end
end
VehicleEngineQuest.Load()

function VehicleEngineQuest.explode(id)
	local data = VehicleEngineQuest.Garages[id]
	if not data then return end
	if not isElement(data.gate) then return end

	local x, y, z = getElementPosition(data.gate)
	moveObject(data.gate, 3500, x, y, z - 5)

	if isElement(data.vehicle) then
		setVehicleDamageProof(data.vehicle, false)
	end

	setTimer(function()
		if isElement(data.gate) then
			moveObject(data.gate, 3500, x, y, z)
		end
	end, 900000, 1)

	setTimer(function()
		VehicleEngineQuest.Load()
	end, 1800000, 1)
end

function VehicleEngineQuest.startVehicleTimer(vehicle, player)
	if not isElement(vehicle) or not isElement(player) then return end
	if apocalypseGetElementData(vehicle, "VehicleEngineQuest") ~= true then return end
	if getVehicleController(vehicle) ~= player then return end

	local active = apocalypseGetElementData(vehicle, "VehicleEngineQuestActive")
	if active == true then return end

	local endTimestamp = getRealTime().timestamp + VehicleEngineQuest.VehicleTimerSeconds

	apocalypseSetElementData(vehicle, "VehicleEngineQuestActive", true)
	apocalypseSetElementData(vehicle, "VehicleEngineQuestEndTime", endTimestamp)

	local id = apocalypseGetElementData(vehicle, "VehicleEngineQuestID")
	local garageData = VehicleEngineQuest.Garages[id]
	if not garageData then return end

	if isTimer(garageData.vehicleTimer) then
		killTimer(garageData.vehicleTimer)
	end

	garageData.vehicleTimer = setTimer(function()
		if not isElement(vehicle) then return end

		local vx, vy, vz = getElementPosition(vehicle)
		createExplosion(vx, vy, vz, 2)

		apocalypseSetElementData(vehicle, "VehicleEngineQuestActive", false)
		apocalypseSetElementData(vehicle, "VehicleEngineQuestEndTime", 0)

		if isElement(vehicle) then
			destroyElement(vehicle)
		end
	end, VehicleEngineQuest.VehicleTimerSeconds * 1000, 1)
end

addEventHandler("onVehicleEnter", root, function(player, seat)
	if seat ~= 0 then return end
	if apocalypseGetElementData(source, "VehicleEngineQuest") ~= true then return end

	VehicleEngineQuest.startVehicleTimer(source, player)
end)

addEventHandler("onPlayerQuit", root, function()
	local vehicle = getPedOccupiedVehicle(source)
	if not vehicle then return end
	if apocalypseGetElementData(vehicle, "VehicleEngineQuest") ~= true then return end

	if getVehicleController(vehicle) == source then
		removePedFromVehicle(source)
	end
end)

addEventHandler("onPlayerClick", root, function(button, state, clickedElement)
	if not isCharacterLoggedIn(source) then return end
	if button ~= "left" or state ~= "down" then return end
	if not clickedElement or not isElement(clickedElement) then return end

	local id = apocalypseGetElementData(clickedElement, "VehicleEngineQuestID")
	local data = VehicleEngineQuest.Garages[id]
	if not id or not data then return end
	if getElementModel(clickedElement) ~= 17951 then return end
	if getElementDimension(source) ~= getElementDimension(clickedElement) then return end

	local x, y, z = getElementPosition(clickedElement)
	if getDistanceBetweenPoints3D(x, y, z, getElementPosition(source)) > 3.5 then return end
	if apocalypseGetElementData(clickedElement, "Lootable") == false then return end

	if hasPlayerItem(source, 26) >= 1 then
		takeItem(source, 26, 1)

		local px, py, pz = getElementPosition(source)
		local dynamite = createObject(1654, px - 0.5, py, pz - 0.85, -90, 0, 0)

		setElementFrozen(source, true)
		setPedAnimation(source, "BOMBER", "BOM_Plant_Loop", -1, true, false, false, true)
		apocalypseSetElementData(data.gate, "Lootable", false)

		setTimer(function(player)
			if not isElement(player) then return end
			setElementFrozen(player, false)
			setPedAnimation(player)
			NPC.MeMessage(player, getText(player, "MeMessage8"))
		end, 3500, 1, source)

		setTimer(function(data, dynamite, player, garageId)
			if not isElement(player) then return end
			if not isElement(data.gate) then return end

			local gx, gy, gz = getElementPosition(data.gate)
			createExplosion(gx, gy, gz, 1)

			if isElement(dynamite) then
				destroyElement(dynamite)
			end

			VehicleEngineQuest.explode(garageId)

			local Level_Bonus_EXP = tonumber(apocalypseGetElementData(player, "level")) or 0
			if Level_Bonus_EXP > 100 then
				Level_Bonus_EXP = 100
			end

			local EXP = 250 + (Level_Bonus_EXP * 5)
			local skillpoints = 10

			if SERVERBONUS.LOOTING == true then
				EXP = EXP * 2
				skillpoints = skillpoints * 2
			end

			giveEXP(player, EXP)
			givePlayerSkillpoint(player, skillpoints)
			LootableGarages.Achievements(player)

			outputLog(getPlayerName(player) .. " hat eine Garage geöffnet (Fahrzeug)", "Loot Garage", getCharacterID(player))
			
			local lootedGarages = tonumber(getPlayerData("character_stats", "character_id", getCharacterID(player), "looted_garages")) or 0
			Characters.addStats(player, "looted_garages", lootedGarages + 1)

			if DailyTasks.playerTasks[player] and DailyTasks.playerTasks[player][4] then
				DailyTasks.updateProgress(player, 4, DailyTasks.playerTasks[player][4].progress + 1)
			end

			if WeeklyTasks.playerTasks[player] and WeeklyTasks.playerTasks[player][4] then
				WeeklyTasks.updateProgress(player, 4, WeeklyTasks.playerTasks[player][4].progress + 1)
			end
		end, 7500, 1, data, dynamite, source, id)
	else
		NPC.MeMessage(source, getText(source, "MeMessage7"))
	end
end)