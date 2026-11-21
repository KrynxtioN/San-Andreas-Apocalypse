VehicleEngineQuestClient = {
	blip = nil,
	renderActive = false,
	fontScale = 1.2,
	maxDistance = 40,
}

local function formatQuestTime(seconds)
	seconds = math.max(0, tonumber(seconds) or 0)
	local minutes = math.floor(seconds / 60)
	local secs = seconds % 60
	return string.format("%02d:%02d", minutes, secs)
end

local function getQuestVehicle()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if not vehicle or not isElement(vehicle) then return nil end
	if getVehicleController(vehicle) ~= localPlayer then return nil end
	if apocalypseGetElementData(vehicle, "VehicleEngineQuest") ~= true then return nil end
	return vehicle
end

local function destroyQuestBlip()
	if isElement(VehicleEngineQuestClient.blip) then
		destroyElement(VehicleEngineQuestClient.blip)
	end
	VehicleEngineQuestClient.blip = nil
end

local function createQuestBlip(vehicle)
	if not isElement(vehicle) then return end
	if isElement(VehicleEngineQuestClient.blip) then return end

	VehicleEngineQuestClient.blip = createBlip(1848.8012695312,-1856.5090332031,13.3828125, 41)
end

local function renderQuestTimer()
	local vehicle = getQuestVehicle()
	if not vehicle then
		return
	end

	local active = apocalypseGetElementData(vehicle, "VehicleEngineQuestActive")
	if active ~= true then
		return
	end

	local endTime = tonumber(apocalypseGetElementData(vehicle, "VehicleEngineQuestEndTime")) or 0
	if endTime <= 0 then
		return
	end

	local now = getRealTime().timestamp
	local remaining = endTime - now
	if remaining < 0 then
		remaining = 0
	end

	local vx, vy, vz = getElementPosition(vehicle)
	local sx, sy = getScreenFromWorldPosition(vx, vy, vz + 1.4)

	if not sx or not sy then
		return
	end

	local cx, cy, cz = getCameraMatrix()
	local distance = getDistanceBetweenPoints3D(vx, vy, vz, cx, cy, cz)
	if distance > VehicleEngineQuestClient.maxDistance then
		return
	end

	local text = getText("CVehicleEngineQuest1"):format(formatQuestTime(remaining))

	dxDrawText(
		text,
		sx + 1, sy + 1, sx + 1, sy + 1,
		tocolor(0, 0, 0, 220),
		VehicleEngineQuestClient.fontScale,
		"default-bold",
		"center",
		"center",
		false,
		false,
		false
	)

	dxDrawText(
		text,
		sx, sy, sx, sy,
		tocolor(255, 180, 0, 255),
		VehicleEngineQuestClient.fontScale,
		"default-bold",
		"center",
		"center",
		false,
		false,
		false
	)
end

local function stopQuestRender()
	if VehicleEngineQuestClient.renderActive then
		removeEventHandler("onClientRender", root, renderQuestTimer)
		VehicleEngineQuestClient.renderActive = false
	end

	destroyQuestBlip()
end

local function startQuestRender()
	local vehicle = getQuestVehicle()
	if not vehicle then
		stopQuestRender()
		return
	end

	createQuestBlip(vehicle)

	if not VehicleEngineQuestClient.renderActive then
		addEventHandler("onClientRender", root, renderQuestTimer)
		VehicleEngineQuestClient.renderActive = true
	end
end

local function refreshQuestUI()
	local vehicle = getQuestVehicle()
	if vehicle then
		startQuestRender()
	else
		stopQuestRender()
	end
end

addEventHandler("onClientVehicleEnter", root, function(player, seat)
	if player ~= localPlayer then return end
	if seat ~= 0 then return end

	if apocalypseGetElementData(source, "VehicleEngineQuest") ~= true then
		stopQuestRender()
		return
	end

	startQuestRender()
end)

addEventHandler("onClientVehicleExit", root, function(player, seat)
	if player ~= localPlayer then return end
	if seat ~= 0 then return end

	stopQuestRender()
end)

addEventHandler("onClientPlayerVehicleEnter", localPlayer, function(vehicle, seat)
	if seat ~= 0 then return end

	if apocalypseGetElementData(vehicle, "VehicleEngineQuest") ~= true then
		stopQuestRender()
		return
	end

	startQuestRender()
end)

addEventHandler("onClientPlayerVehicleExit", localPlayer, function(vehicle, seat)
	if seat ~= 0 then return end
	stopQuestRender()
end)

addEventHandler("onClientElementDestroy", root, function()
	local vehicle = getQuestVehicle()

	if source == VehicleEngineQuestClient.blip then
		VehicleEngineQuestClient.blip = nil
		return
	end

	if vehicle and source == vehicle then
		stopQuestRender()
	end
end)

addEventHandler("onClientPlayerWasted", localPlayer, function(player)
	if(player == localPlayer)then
		stopQuestRender()
	end
end)

setTimer(function()
	if not VehicleEngineQuestClient.renderActive then return end
	refreshQuestUI()
end, 1000, 0)