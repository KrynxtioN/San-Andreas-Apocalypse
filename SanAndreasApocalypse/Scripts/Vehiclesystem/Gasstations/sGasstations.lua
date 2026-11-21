Gasstations = {
	MarkerElement = {},
	Timer = {},

	["Marker"] = {
		{1939.3531494141, -1778.4748535156, 12.368292808533},
		{1943.9680175781, -1767.0120849609, 12.368292808533},
		{-1326.7840576172, 2687.9543457031, 49.026786804199},
		{-1327.5114746094, 2682.4382324219, 49.026786804199},
		{-1328.2937011719, 2677.0065917969, 49.026786804199},
		{-1328.9842529297, 2671.6020507813, 49.026786804199},
		{-736.98919677734, 2742.7680664063, 46.198112487793},
		{1601.8836669922, 2206.7055664063, 9.7824573516846},
		{1590.3991699219, 2202.2297363281, 9.7824573516846},
		{1590.4012451172, 2195.9235839844, 9.7824573516846},
		{1602.0209960938, 2191.4221191406, 9.7824573516846},
		{2141.7067871094, 2740.1899414063, 9.8008241653442},
		{2153.3122558594, 2744.8349609375, 9.8008241653442},
		{2153.3288574219, 2751.001953125, 9.8008241653442},
		{2141.6652832031, 2755.7067871094, 9.8008241653442},
		{2210.1022949219, 2470.3361816406, 9.7928237915039},
		{2205.3889160156, 2480.2214355469, 9.7928237915039},
		{2199.3537597656, 2480.3156738281, 9.7928237915039},
		{2194.5483398438, 2470.1640625, 9.7928237915039},
		{2634.6647949219, 1114.0942382813, 9.7911911010742},
		{2645.1147460938, 1109.4194335938, 9.7911911010742},
		{2645.1416015625, 1103.3073730469, 9.7911911010742},
		{2634.6774902344, 1098.5855712891, 9.7911911010742},
		{2120.8210449219, 912.38262939453, 9.8142318725586},
		{2109.0131835938, 917.06329345703, 9.8142318725586},
		{2109.2189941406, 923.08605957031, 9.8142318725586},
		{2120.7482910156, 927.90014648438, 9.8142318725586},
		{653.09423828125, -559.79583740234, 15.3068151474},
		{658.03625488281, -570.35491943359, 15.3068151474},
		{-88.285507202148, -1177.6329345703, 1.0961662530899},
		{-89.970191955566, -1162.8072509766, 1.1401661634445},
		{-2239.6813964844, -2563.3857421875, 30.912017822266},
		{-2244.5764160156, -2560.7238769531, 30.912017822266},
		{-1677.6182861328, 401.35681152344, 6.1611566543579},
		{-1667.3293457031, 418.50671386719, 6.1611566543579},
		{-1670.4390869141, 421.75216674805, 6.1611566543579},
		{-1687.7368164063, 411.40512084961, 6.1611566543579},
		{71.172088623047, 1220.0618896484, 17.782121658325},
		{1009.2421264648, -933.67761230469, 41.157382965088},
		{998.51336669922, -939.96142578125, 41.157382965088},
	},
}

for i, v in ipairs(Gasstations["Marker"]) do
	Gasstations.MarkerElement[i] = createMarker(v[1], v[2], v[3], "cylinder", 3, 255, 0, 0, 25)

	local marker = Gasstations.MarkerElement[i]

	apocalypseSetElementData(marker, "Gasoline", 250)

	addEventHandler("onMarkerHit", marker, function(hitElement)
		if getElementType(hitElement) ~= "vehicle" then return end

		local driver = getVehicleOccupant(hitElement, 0)
		if not driver then return end

		if getElementDimension(hitElement) ~= getElementDimension(source) then return end
		if getElementInterior(hitElement) ~= getElementInterior(source) then return end

		local vehicleFuel = tonumber(apocalypseGetElementData(hitElement, "fuel")) or 0
		local stationGasoline = tonumber(apocalypseGetElementData(source, "Gasoline")) or 0

		triggerClientEvent(driver, "Gasstations.createPanel", driver, vehicleFuel, stationGasoline)
	end)
end

function Gasstations.getMarker(player)
	local vehicle = getPedOccupiedVehicle(player)
	if not vehicle then return false end

	for _, marker in pairs(Gasstations.MarkerElement) do
		if isElement(marker) and isElementWithinMarker(vehicle, marker) then
			return marker
		end
	end

	return false
end

setTimer(function()
	for _, marker in pairs(Gasstations.MarkerElement) do
		if isElement(marker) then
			local gasoline = tonumber(apocalypseGetElementData(marker, "Gasoline")) or 0
			local newGasoline = gasoline + math.random(30, 65)

			if newGasoline > 250 then
				newGasoline = 250
			end

			apocalypseSetElementData(marker, "Gasoline", newGasoline)
		end
	end
end, 3600000, 0)

addEvent("Gasstations.server", true)
addEventHandler("Gasstations.server", root, function(liter)
	liter = tonumber(liter)

	if not liter or liter < 1 then
		createInfobox(client, getText(client, "SGasstations1"))
		return
	end

	liter = math.floor(liter)

	local veh = getPedOccupiedVehicle(client)
	if not veh then return end

	if getPedOccupiedVehicleSeat(client) ~= 0 then return end

	local marker = Gasstations.getMarker(client)
	if not marker then return end

	local currentFuel = tonumber(apocalypseGetElementData(veh, "fuel")) or 0
	local fillup = 100 - currentFuel

	if fillup <= 0 then
		NPC.MeMessage(client, getText(client, "SGasstations2"))
		return
	end

	if liter > fillup then
		NPC.MeMessage(client, getText(client, "SGasstations2"))
		return
	end

	local gasoline = tonumber(apocalypseGetElementData(marker, "Gasoline")) or 0

	if gasoline <= 0 then
		NPC.MeMessage(client, getText(client, "MeMessage9"))
		return
	end

	if gasoline < liter then
		NPC.MeMessage(client, getText(client, "MeMessage10"))
		return
	end

	apocalypseSetElementData(marker, "Gasoline", gasoline - liter)

	setElementFrozen(veh, true)
	createInfobox(client, getText(client, "SGasstations3"))
	apocalypseSetElementData(veh, "refuel", true)

	if isTimer(Gasstations.Timer[client]) then
		killTimer(Gasstations.Timer[client])
	end

	Gasstations.Timer[client] = setTimer(function(player, vehicle, fuelLiter)
		if isElement(player) and isElement(vehicle) then
			local oldFuel = tonumber(apocalypseGetElementData(vehicle, "fuel")) or 0
			local newFuel = oldFuel + fuelLiter

			if newFuel > 100 then
				newFuel = 100
			end

			apocalypseSetElementData(vehicle, "fuel", newFuel)
			apocalypseSetElementData(vehicle, "refuel", false)

			setElementFrozen(vehicle, false)

			createInfobox(player, getText(player, "SGasstations4"))
			setAchievement(player, 271)
		end

		Gasstations.Timer[player] = nil
	end, liter * 150, 1, client, veh, liter)
end)

addEventHandler("onPlayerQuit", root, function()
	if isTimer(Gasstations.Timer[source]) then
		killTimer(Gasstations.Timer[source])
	end

	Gasstations.Timer[source] = nil
end)

addEventHandler("onVehicleExit", root, function(player)
	if isTimer(Gasstations.Timer[player]) then
		killTimer(Gasstations.Timer[player])
		Gasstations.Timer[player] = nil
	end

	if isElement(source) then
		setElementFrozen(source, false)
		apocalypseSetElementData(source, "refuel", false)
	end
end)