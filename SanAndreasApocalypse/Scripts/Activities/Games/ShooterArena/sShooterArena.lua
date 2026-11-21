Shooterarena = {
	veh = {},
	dim = 999,
	players = 0,
	activePowerUps = {},
	maxPowerUps = 5,
	lastHitTick = {},
	["Spawns"] = {
		{-1474.1329345703,-236.41520690918,5.5183262825012,269.79806518555},
		{-1447.9411621094,-60.932662963867,5.5183262825012,179.28034973145},
		{-1475.8150634766,36.750099182129,5.5183253288269,269.94268798828},
		{-1369.2614746094,-9.1996870040894,5.5183258056641,89.615509033203},
		{-1369.9016113281,-113.15093994141,5.5183258056641,89.549278259277},
		{-1368.5080566406,-247.41772460938,5.5183258056641,359.55120849609},
	},
	["Power_Ups"] = {
		{-1446.2309570312,37.206378936768,5.5183238983154},
		{-1426.3143310547,-18.660467147827,5.5183253288269},
		{-1466.56640625,-49.225688934326,5.5252513885498},
		{-1432.8021240234,-87.596260070801,5.5183243751526},
		{-1452.0296630859,-137.28666687012,5.5183253288269},
		{-1466.7603759766,-205.7833404541,5.5183262825012},
		{-1435.9858398438,-239.12791442871,5.5183262825012},
		{-1360.7308349609,-239.15396118164,5.5183272361755},
		{-1344.19921875,-187.03022766113,5.518226146698},
		{-1366.1480712891,-136.37077331543,5.5183258056641},
		{-1365.6696777344,-68.842666625977,5.5183243751526},
		{-1344.5183105469,9.2179374694824,5.5182247161865},
		{-1378.0634765625,4.7702617645264,5.5182228088379},
		{-1397.7094726562,-31.747877120972,5.5183238983154},
		{-1412.4738769531,-128.91345214844,5.518247127533},
		{-1399.46484375,-186.49122619629,5.5182323455811},
	},
}

local Achievements = {
	{1,386},
	{5,387},
	{10,388},
	{25,389},
	{50,390},
	{100,391},
}

Shooterarena.joinMarker = createMarker(2695.8618164062,-1706.7642822266,10.84375,"cylinder",2,0,150,100,100)

addEventHandler("onMarkerHit", Shooterarena.joinMarker, function(player)
	if not isPedInVehicle(player) then
		if getElementDimension(player) == getElementDimension(source) then
			triggerClientEvent(player, "Shooterarena.openWindow", player, Shooterarena.players)
		end
	end
end)

function giveTemporaryNitro(vehicle)
	if not isElement(vehicle) then return end
	addVehicleUpgrade(vehicle, 1010)
	setVehicleNitroActivated(vehicle, true)

	setTimer(function(v)
		if isElement(v) then
			setVehicleNitroActivated(v, false)
			removeVehicleUpgrade(v, 1010)
		end
	end, 3500, 1, vehicle)
end

function Shooterarena.join(player)
	local Lobby = apocalypseGetElementData(player, "Lobby")

	if isPedDead(player) then
		spawnPlayer(player, 0, 0, 0)
	end

	if Lobby ~= "Shooter-Arena" then
		apocalypseSetElementData(player, "Lobby", "Shooter-Arena")
		Shooterarena.players = Shooterarena.players + 1
		Shooterarena.refreshPlayer()
		SAALobby.removeApocalypsePlayer()
		SAALobby.addShooterPlayer()
	end

	local rnd = math.random(1, #Shooterarena["Spawns"])
	local x, y, z = Shooterarena["Spawns"][rnd][1], Shooterarena["Spawns"][rnd][2], Shooterarena["Spawns"][rnd][3]
	local rot = Shooterarena["Spawns"][rnd][4]

	if isElement(Shooterarena.veh[player]) then
		destroyElement(Shooterarena.veh[player])
	end

	Shooterarena.veh[player] = createVehicle(411, x, y, z, 0, 0, rot)
	setElementDimension(Shooterarena.veh[player], Shooterarena.dim)

	apocalypseSetElementData(Shooterarena.veh[player], "shooterVehicle", true)
	apocalypseSetElementData(Shooterarena.veh[player], "Shooterarena.Hits", 3)
	apocalypseSetElementData(Shooterarena.veh[player], "Shooterarena.Owner", player)
	apocalypseSetElementData(Shooterarena.veh[player], "lastAttacker", false)

	setElementDimension(player, Shooterarena.dim)

	setTimer(function(thePlayer)
		if isElement(thePlayer) and isElement(Shooterarena.veh[thePlayer]) then
			warpPedIntoVehicle(thePlayer, Shooterarena.veh[thePlayer])
			fadeCamera(thePlayer, true)
		end
	end, 250, 1, player)

	triggerClientEvent(player, "Shooterarena.join", player, "bind")
	setAchievement(player, 287)

	addEventHandler("onVehicleStartExit", Shooterarena.veh[player], function(thePlayer)
		if isElement(source) then
			destroyElement(source)
		end

		apocalypseSetElementData(thePlayer, "Lobby", "Apocalypse")
		triggerClientEvent(thePlayer, "Shooterarena.join", thePlayer)

		setTimer(function(p)
			if isElement(p) then
				setElementPosition(p, 2692.9716796875, -1703.9333496094, 11.472283363342)
				setPedRotation(p, 37)
				setElementDimension(p, 0)
			end

			Shooterarena.players = Shooterarena.players - 1
			Shooterarena.refreshPlayer()
			SAALobby.addApocalypsePlayer()
			SAALobby.removeShooterPlayer()
		end, 100, 1, thePlayer)
	end)
end
addEvent("Shooterarena.join", true)
addEventHandler("Shooterarena.join", root, Shooterarena.join)

function Shooterarena.refreshPlayer()
	for _, v in pairs(getElementsByType("player")) do
		if apocalypseGetElementData(v, "Lobby") == "Shooter-Arena" then
			triggerClientEvent(v, "Shooterarena.refreshPlayer", v, Shooterarena.players)
		end
	end
end

addEventHandler("onPlayerQuit", root, function()
	if isElement(Shooterarena.veh[source]) then
		destroyElement(Shooterarena.veh[source])
	end

	if apocalypseGetElementData(source, "Lobby") == "Shooter-Arena" then
		Shooterarena.players = Shooterarena.players - 1
		SAALobby.removeShooterPlayer()
	end
end)

addEvent("Shooterarena.vehicleHit", true)
addEventHandler("Shooterarena.vehicleHit", root, function(targetVeh)
	local attacker = client
	if not isElement(attacker) then return end
	if not isElement(targetVeh) then return end
	if getElementType(targetVeh) ~= "vehicle" then return end

	local attackerVeh = getPedOccupiedVehicle(attacker)
	if not attackerVeh then return end
	if attackerVeh == targetVeh then return end

	if apocalypseGetElementData(attacker, "Lobby") ~= "Shooter-Arena" then return end
	if apocalypseGetElementData(attackerVeh, "shooterVehicle") ~= true then return end
	if apocalypseGetElementData(targetVeh, "shooterVehicle") ~= true then return end

	if getElementDimension(attackerVeh) ~= Shooterarena.dim then return end
	if getElementDimension(targetVeh) ~= Shooterarena.dim then return end

	local targetDriver = apocalypseGetElementData(targetVeh, "Shooterarena.Owner")
	if not isElement(targetDriver) then return end
	if targetDriver == attacker then return end

	local ax, ay, az = getElementPosition(attackerVeh)
	local tx, ty, tz = getElementPosition(targetVeh)

	if getDistanceBetweenPoints3D(ax, ay, az, tx, ty, tz) > 80 then
		return
	end

	local now = getTickCount()
	if Shooterarena.lastHitTick[targetVeh] and now - Shooterarena.lastHitTick[targetVeh] < 700 then
		return
	end
	Shooterarena.lastHitTick[targetVeh] = now

	local hits = tonumber(apocalypseGetElementData(targetVeh, "Shooterarena.Hits")) or 3
	hits = hits - 1
	if hits < 0 then
		hits = 0
	end

	apocalypseSetElementData(targetVeh, "Shooterarena.Hits", hits)
	apocalypseSetElementData(targetVeh, "lastAttacker", attacker)

	if hits <= 0 then
		blowVehicle(targetVeh)
	end
end)

addEventHandler("onVehicleExplode", root, function()
	if apocalypseGetElementData(source, "shooterVehicle") ~= true then
		return
	end

	local victim = apocalypseGetElementData(source, "Shooterarena.Owner")
	local attacker = apocalypseGetElementData(source, "lastAttacker")

	Shooterarena.lastHitTick[source] = nil

	if isElement(victim) and isElement(attacker) and victim ~= attacker then
		setAchievement(victim, 288)
	end

	if isElement(attacker) and isElement(victim) and victim ~= attacker then
		local shooter_arena_killed_players = tonumber(getPlayerData("character_stats","character_id",getCharacterID(attacker),"shooter_arena_killed_players")) or 0
		Characters.addStats(attacker, "shooter_arena_killed_players", shooter_arena_killed_players + 1)

		if DailyTasks.playerTasks[attacker] and DailyTasks.playerTasks[attacker][26] then
			DailyTasks.updateProgress(attacker, 26, DailyTasks.playerTasks[attacker][26].progress + 1)
		end

		if WeeklyTasks.playerTasks[attacker] and WeeklyTasks.playerTasks[attacker][26] then
			WeeklyTasks.updateProgress(attacker, 26, WeeklyTasks.playerTasks[attacker][26].progress + 1)
		end

		for _, v in pairs(Achievements) do
			if shooter_arena_killed_players + 1 >= v[1] then
				setAchievement(attacker, v[2])
			end
		end

		local amount = 50
		if SERVERBONUS.SHOOTER_ARENA == true then
			amount = amount * 2
		end

		giveEXP(attacker, amount)

		local attackerName = getPlayerName(attacker) or "Unbekannt"
		local victimName = getPlayerName(victim) or "Unbekannt"

		outputLog(
			attackerName.." hat "..victimName.." in der Shooter Arena getötet und "..amount.." EXP erhalten",
			"Shooter Arena",
			getCharacterID(attacker)
		)

		for _, v in pairs(getElementsByType("player")) do
			if apocalypseGetElementData(v, "Lobby") == "Shooter-Arena" then
				triggerClientEvent(v, "Shooterarena.addKillFeed", v, attackerName, victimName)
			end
		end
	end
end)

function Shooterarena.createPowerUp()
	if Shooterarena.players < 1 then return end

	local currentPowerUps = 0
	for _, data in pairs(Shooterarena.activePowerUps) do
		if data and isElement(data.pickup) and isElement(data.marker) then
			currentPowerUps = currentPowerUps + 1
		end
	end

	if currentPowerUps >= Shooterarena.maxPowerUps then return end

	local rnd = math.random(1, #Shooterarena["Power_Ups"])
	local x = Shooterarena["Power_Ups"][rnd][1]
	local y = Shooterarena["Power_Ups"][rnd][2]
	local z = Shooterarena["Power_Ups"][rnd][3]

	local rnd_type = math.random(1, 100)
	local pickup_model

	if rnd_type >= 1 and rnd_type <= 30 then
		pickup_model = 1240
	elseif rnd_type >= 31 and rnd_type <= 100 then
		pickup_model = 1947
	end

	local pickupZ = z
	if pickup_model == 1947 then
		pickupZ = z + 0.5
	end

	local pickup = createPickup(x, y, pickupZ, 3, pickup_model, 0)
	setElementDimension(pickup, Shooterarena.dim)

	local marker = createMarker(x, y, z - 1, "cylinder", 3.5, 255, 0, 0, 25)
	setElementDimension(marker, Shooterarena.dim)

	local powerUpData = {
		pickup = pickup,
		marker = marker,
		model = pickup_model,
	}

	addEventHandler("onMarkerHit", marker, function(player, matchingDimension)
		if not matchingDimension then return end
		if getElementType(player) ~= "player" then return end
		if apocalypseGetElementData(player, "Lobby") ~= "Shooter-Arena" then return end
		if getElementDimension(player) ~= getElementDimension(source) then return end
		if not isElement(powerUpData.pickup) then return end

		local veh = getPedOccupiedVehicle(player)
		if not veh then return end

		if powerUpData.model == 1240 then
			local hits = tonumber(apocalypseGetElementData(veh, "Shooterarena.Hits")) or 0
			if hits < 4 then
				apocalypseSetElementData(veh, "Shooterarena.Hits", hits + 1)
			end
		elseif powerUpData.model == 1947 then
			giveTemporaryNitro(veh)
		end

		for i, v in pairs(Shooterarena.activePowerUps) do
			if v == powerUpData then
				table.remove(Shooterarena.activePowerUps, i)
				break
			end
		end

		if isElement(powerUpData.pickup) then
			destroyElement(powerUpData.pickup)
		end
		if isElement(powerUpData.marker) then
			destroyElement(powerUpData.marker)
		end
	end)

	table.insert(Shooterarena.activePowerUps, powerUpData)
end
setTimer(Shooterarena.createPowerUp, 5000, 0)