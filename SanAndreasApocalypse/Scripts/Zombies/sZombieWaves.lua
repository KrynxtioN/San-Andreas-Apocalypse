waveSystem = {}

local waveMarkers = {}
local activeWaveGames = {}
local zombieToGame = {}
local waveHeadObjects = {}
local waveZombieBlips = {}

local waveConfig = {
	[1] = { zombies = 10, radius = 15, time = 60 },
	[2] = { zombies = 20, radius = 18, time = 90 },
	[3] = { zombies = 30, radius = 20, time = 120 },
	[4] = { zombies = 40, radius = 22, time = 150 },
	[5] = { zombies = 50, radius = 25, time = 180 },
}

local RESET_COOLDOWN_SECONDS = 30 * 60
local START_DELAY_SECONDS = 3
local NEXT_WAVE_DELAY_SECONDS = 5

local wavePositions = {
	{ x = -2507.4001464844, y = 2397.3625488281, z = 16.406700134277, interior = 0, dimension = 0 },
	{ x = -917.66271972656, y = 2747.3510742188, z = 46.53279876709, interior = 0, dimension = 0 },
	{ x = 572.9951171875, y = 2499.6262207031, z = 37.850498199463, interior = 0, dimension = 0 },
	{ x = 1209.4884033203, y = 2678.5463867188, z = 10.759699821472, interior = 0, dimension = 0 },
	{ x = 2457.6027832031, y = 2736.7670898438, z = 10.44670009613, interior = 0, dimension = 0 },
	{ x = -754.08740234375, y = 1235.5843505859, z = 13.402299880981, interior = 0, dimension = 0 },
	{ x = 868.892578125, y = 2211.2543945312, z = 10.912300109863, interior = 0, dimension = 0 },
	{ x = 1766.7062988281, y = 1753.5635986328, z = 8.4202003479004, interior = 0, dimension = 0 },
	{ x = 849.18218994141, y = 1302.8361816406, z = 26.387500762939, interior = 0, dimension = 0 },
	{ x = 2850.9611816406, y = 1083.7531738281, z = 10.819999694824, interior = 0, dimension = 0 },
	{ x = -406.91421508789, y = 731.78277587891, z = 26.893899917603, interior = 0, dimension = 0 },
}

local Achievements = {
	{1,458},
	{5,459},
	{10,460},
	{25,461},
	{50,462},
	{75,463},
	{125,464},
	{175,465},
	{250,466},
}

local function getTextSafe(player, key)
	if getText then
		local result = getText(player, key)
		if result and result ~= "" then
			return result
		end
	end

	return texts[key] or key
end

local function getUnixTime()
	return getRealTime().timestamp
end

function waveSystem.formatTime(seconds)
	seconds = math.max(0, math.floor(seconds or 0))
	local m = math.floor(seconds / 60)
	local s = seconds % 60
	return string.format("%02d:%02d", m, s)
end

function waveSystem.setMarkerState(marker, stateTable)
	if (not isElement(marker)) then return end
	for k, v in pairs(stateTable) do
		setElementData(marker, "wave:" .. k, v)
	end
end

function waveSystem.refreshMarkerState(marker)
	local markerData = waveMarkers[marker]
	if (not markerData or not isElement(marker)) then return end

	local game = activeWaveGames[marker]
	local cooldownUntil = markerData.cooldownUntil or 0

	if (game and game.active == true) then
		local currentState = getElementData(marker, "wave:state")

		if (currentState == "pause") then
			waveSystem.setMarkerState(marker, {
				isWaveMarker = true,
				active = true,
				state = "pause",
				wave = getElementData(marker, "wave:wave") or game.wave or 0,
				alive = 0,
				total = 0,
				timeLeft = math.max(0, (game.waveEndTime or 0) - getUnixTime()),
				cooldownUntil = 0
			})
		else
			waveSystem.setMarkerState(marker, {
				isWaveMarker = true,
				active = true,
				state = "aktiv",
				wave = game.wave or 0,
				alive = game.alive or 0,
				total = game.total or 0,
				timeLeft = math.max(0, (game.waveEndTime or 0) - getUnixTime()),
				cooldownUntil = 0
			})
		end
	else
		local remainingCooldown = math.max(0, cooldownUntil - getUnixTime())

		if (remainingCooldown > 0) then
			waveSystem.setMarkerState(marker, {
				isWaveMarker = true,
				active = false,
				state = "cooldown",
				wave = 0,
				alive = 0,
				total = 0,
				timeLeft = 0,
				cooldownUntil = cooldownUntil
			})
		else
			waveSystem.setMarkerState(marker, {
				isWaveMarker = true,
				active = false,
				state = "bereit",
				wave = 0,
				alive = 0,
				total = 0,
				timeLeft = 0,
				cooldownUntil = 0
			})
		end
	end
end

function waveSystem.outputNearby(marker, textKey, r, g, b)
	local markerData = waveMarkers[marker]
	if (not markerData) then return end

	for _, player in ipairs(getElementsByType("player")) do
		if (isElement(player)) then
			if (getElementInterior(player) == markerData.interior and getElementDimension(player) == markerData.dimension) then
				local px, py, pz = getElementPosition(player)
				local dist = getDistanceBetweenPoints3D(px, py, pz, markerData.x, markerData.y, markerData.z)
				if (dist <= 40) then
					outputChatBox(getTextSafe(player, textKey), player, r or 255, g or 255, b or 255)
				end
			end
		end
	end
end

function waveSystem.getRandomPointInRadius(cx, cy, radius)
	local angle = math.rad(math.random(0, 359))
	local dist = math.random() * radius
	local x = cx + math.cos(angle) * dist
	local y = cy + math.sin(angle) * dist
	return x, y
end

function waveSystem.attachWaveObject(zomb)
	if (not isElement(zomb)) then return false end

	if (isElement(waveHeadObjects[zomb])) then
		destroyElement(waveHeadObjects[zomb])
	end

	local obj = createObject(1318, 0, 0, 0)
	if (not isElement(obj)) then return false end

	setElementInterior(obj, getElementInterior(zomb))
	setElementDimension(obj, getElementDimension(zomb))
	setElementCollisionsEnabled(obj, false)

	attachElements(obj, zomb, 0, 0, 1.60)

	waveHeadObjects[zomb] = obj
	return true
end

function waveSystem.destroyWaveObject(zomb)
	if (isElement(waveHeadObjects[zomb])) then
		destroyElement(waveHeadObjects[zomb])
	end
	waveHeadObjects[zomb] = nil
end

function waveSystem.attachWaveBlip(zomb)
	if (not isElement(zomb)) then return false end

	if (isElement(waveZombieBlips[zomb])) then
		destroyElement(waveZombieBlips[zomb])
	end

	local blip = createBlipAttachedTo(zomb, 0, 1, 255, 40, 40, 255, 0, 300)
	if (not isElement(blip)) then
		return false
	end

	setElementInterior(blip, getElementInterior(zomb))
	setElementDimension(blip, getElementDimension(zomb))

	waveZombieBlips[zomb] = blip
	return true
end

function waveSystem.destroyWaveBlip(zomb)
	if (isElement(waveZombieBlips[zomb])) then
		destroyElement(waveZombieBlips[zomb])
	end
	waveZombieBlips[zomb] = nil
end

function waveSystem.getPlayerFromKiller(killer)
	if (not isElement(killer)) then
		return nil
	end

	if (getElementType(killer) == "player") then
		return killer
	end

	if (getElementType(killer) == "vehicle") then
		local controller = getVehicleController(killer)
		if (isElement(controller) and getElementType(controller) == "player") then
			return controller
		end
	end

	return nil
end

function waveSystem.getWaveRewards(kills, wave)
	kills = tonumber(kills) or 0
	wave = tonumber(wave) or 1

	local EXP = (kills * 5) * wave

	return EXP
end

function waveSystem.notifyWaveKillers(marker)
	local game = activeWaveGames[marker]
	if (not game or not game.currentWaveKillers) then return end

	for player, kills in pairs(game.currentWaveKillers) do
		if (isElement(player) and getElementType(player) == "player" and kills and kills > 0) then
			local EXP = waveSystem.getWaveRewards(kills, game.wave)
			local msg = string.format(
				getTextSafe(player, "SZombieWaves6"),
				tostring(kills),
				tostring(game.wave),
				tostring(EXP)
			)

			outputChatBox(getText(player,"SZombieWaves6"):format(tostring(kills),tostring(game.wave),tostring(EXP)), player, 50, 255, 50)
			if(SERVERBONUS.ZOMBIE_WAVES == true)then EXP = EXP * 2 end
			giveEXP(player,tonumber(EXP))
			outputLog(getPlayerName(player).." hat "..EXP.." EXP durch Zombie Wellen erhalten","Zombie Waves",getCharacterID(player))
			
            local finished_zombie_waves = getPlayerData("character_stats","character_id",getCharacterID(player),"finished_zombie_waves")
            Characters.addStats(player,"finished_zombie_waves",finished_zombie_waves + 1)

            for _,v in pairs(Achievements) do
				if finished_zombie_waves + 1 >= v[1] then
					setAchievement(player,v[2])
                end
            end
		end
	end
end

function waveSystem.createMarkers()
	for i, pos in ipairs(wavePositions) do
		local marker = createMarker(pos.x, pos.y, pos.z, "cylinder", 2.0, 200, 30, 30, 140)
		if (isElement(marker)) then
			setElementInterior(marker, pos.interior or 0)
			setElementDimension(marker, pos.dimension or 0)

			waveMarkers[marker] = {
				id = i,
				x = pos.x,
				y = pos.y,
				z = pos.z,
				interior = pos.interior or 0,
				dimension = pos.dimension or 0,
				cooldownUntil = 0,
			}

			waveSystem.refreshMarkerState(marker)
			addEventHandler("onMarkerHit", marker, waveSystem.onMarkerHit)
		end
	end
end
addEventHandler("onResourceStart", resourceRoot, waveSystem.createMarkers)

function waveSystem.onMarkerHit(player, matchingDimension)
	if (not matchingDimension) then return end
	if (getElementType(player) ~= "player") then return end
	if (isPedInVehicle(player)) then return end

	local marker = source
	local markerData = waveMarkers[marker]
	if (not markerData) then return end

	if (activeWaveGames[marker] and activeWaveGames[marker].active == true) then
		return
	end

	if (markerData.cooldownUntil and markerData.cooldownUntil > getUnixTime()) then
		return
	end

	waveSystem.startMinigame(marker, player)
end

function waveSystem.startMinigame(marker, player)
	if (not waveMarkers[marker]) then return false end

	activeWaveGames[marker] = {
		active = true,
		wave = 0,
		alive = 0,
		total = 0,
		zombies = {},
		player = player,
		startTick = getTickCount(),
		waveTimer = nil,
		waveEndTime = 0,
		currentWaveKillers = {},
	}

	waveSystem.outputNearby(marker, "SZombieWaves5", 255, 200, 0)

	activeWaveGames[marker].waveEndTime = getUnixTime() + START_DELAY_SECONDS
	waveSystem.setMarkerState(marker, {
		isWaveMarker = true,
		active = true,
		state = "pause",
		wave = 1,
		alive = 0,
		total = 0,
		timeLeft = START_DELAY_SECONDS,
		cooldownUntil = 0
	})

	setTimer(function(theMarker)
		if (activeWaveGames[theMarker] and activeWaveGames[theMarker].active == true) then
			waveSystem.startNextWave(theMarker)
		end
	end, START_DELAY_SECONDS * 1000, 1, marker)

	return true
end

function waveSystem.startNextWave(marker)
	local game = activeWaveGames[marker]
	local markerData = waveMarkers[marker]

	if (not game or not markerData) then return false end
	if (game.active ~= true) then return false end

	if (isTimer(game.waveTimer)) then
		killTimer(game.waveTimer)
		game.waveTimer = nil
	end

	game.wave = game.wave + 1

	local cfg = waveConfig[game.wave]
	if (not cfg) then
		waveSystem.finishMinigame(marker)
		return false
	end

	game.alive = 0
	game.total = cfg.zombies
	game.zombies = {}
	game.currentWaveKillers = {}
	game.waveEndTime = getUnixTime() + cfg.time

	waveSystem.outputNearby(marker, "SZombieWaves4", 50, 255, 50)

	for i = 1, cfg.zombies do
		local sx, sy = waveSystem.getRandomPointInRadius(markerData.x, markerData.y, cfg.radius)
		local sz = markerData.z

		local zomb = createZombie(sx, sy, sz, markerData.interior, markerData.dimension)
		if (isElement(zomb)) then
			setElementData(zomb, "waveZombie", true)
			setElementData(zomb, "waveNumber", game.wave)
			setElementData(zomb, "waveMarkerID", markerData.id)
			setElementData(zomb, "waveCountedDead", false)
			setElementData(zomb, "forcedtoexist", true)

			zombieToGame[zomb] = marker
			table.insert(game.zombies, zomb)
			game.alive = game.alive + 1

			waveSystem.attachWaveObject(zomb)
			waveSystem.attachWaveBlip(zomb)
		end
	end

	game.waveTimer = setTimer(function(theMarker)
		if (activeWaveGames[theMarker] and activeWaveGames[theMarker].active == true) then
			waveSystem.cancelMinigame(theMarker)
		end
	end, cfg.time * 1000, 1, marker)

	waveSystem.setMarkerState(marker, {
		isWaveMarker = true,
		active = true,
		state = "aktiv",
		wave = game.wave,
		alive = game.alive,
		total = game.total,
		timeLeft = cfg.time,
		cooldownUntil = 0
	})

	if (game.alive <= 0) then
		game.waveEndTime = getUnixTime() + START_DELAY_SECONDS
		waveSystem.setMarkerState(marker, {
			isWaveMarker = true,
			active = true,
			state = "pause",
			wave = game.wave + 1,
			alive = 0,
			total = 0,
			timeLeft = START_DELAY_SECONDS,
			cooldownUntil = 0
		})

		setTimer(function(theMarker)
			if (activeWaveGames[theMarker] and activeWaveGames[theMarker].active == true) then
				waveSystem.startNextWave(theMarker)
			end
		end, START_DELAY_SECONDS * 1000, 1, marker)
	end

	return true
end

function waveSystem.finishCurrentWave(marker)
	local game = activeWaveGames[marker]
	if (not game or game.active ~= true) then return end

	if (isTimer(game.waveTimer)) then
		killTimer(game.waveTimer)
		game.waveTimer = nil
	end

	waveSystem.notifyWaveKillers(marker)

	local nextWave = game.wave + 1
	if (not waveConfig[nextWave]) then
		waveSystem.finishMinigame(marker)
		return
	end

	game.waveEndTime = getUnixTime() + NEXT_WAVE_DELAY_SECONDS

	waveSystem.setMarkerState(marker, {
		isWaveMarker = true,
		active = true,
		state = "pause",
		wave = nextWave,
		alive = 0,
		total = 0,
		timeLeft = NEXT_WAVE_DELAY_SECONDS,
		cooldownUntil = 0
	})

	waveSystem.outputNearby(marker, "SZombieWaves3", 50, 200, 255)

	setTimer(function(theMarker)
		if (activeWaveGames[theMarker] and activeWaveGames[theMarker].active == true) then
			waveSystem.startNextWave(theMarker)
		end
	end, NEXT_WAVE_DELAY_SECONDS * 1000, 1, marker)
end

function waveSystem.finishMinigame(marker)
	local game = activeWaveGames[marker]
	local markerData = waveMarkers[marker]
	if (not game or not markerData) then return end

	if (isTimer(game.waveTimer)) then
		killTimer(game.waveTimer)
		game.waveTimer = nil
	end

	waveSystem.outputNearby(marker, "SZombieWaves2", 255, 215, 0)

	for _, zomb in ipairs(game.zombies) do
		waveSystem.destroyWaveObject(zomb)
		waveSystem.destroyWaveBlip(zomb)

		if (isElement(zomb)) then
			zombieToGame[zomb] = nil
			destroyElement(zomb)
		end
	end

	game.currentWaveKillers = {}

	markerData.cooldownUntil = getUnixTime() + RESET_COOLDOWN_SECONDS

	activeWaveGames[marker] = nil
	waveSystem.refreshMarkerState(marker)
end

function waveSystem.cancelMinigame(marker, reason)
	local game = activeWaveGames[marker]
	local markerData = waveMarkers[marker]
	if (not game or not markerData) then return end

	if (isTimer(game.waveTimer)) then
		killTimer(game.waveTimer)
		game.waveTimer = nil
	end

	for _, zomb in ipairs(game.zombies) do
		waveSystem.destroyWaveObject(zomb)
		waveSystem.destroyWaveBlip(zomb)

		if (isElement(zomb)) then
			zombieToGame[zomb] = nil
			destroyElement(zomb)
		end
	end

	game.currentWaveKillers = {}

	markerData.cooldownUntil = getUnixTime() + RESET_COOLDOWN_SECONDS

	waveSystem.outputNearby(marker, "SZombieWaves1", 255, 50, 50)

	activeWaveGames[marker] = nil
	waveSystem.refreshMarkerState(marker)
end

function waveSystem.handleZombieDeath(zomb, killer)
	if (not isElement(zomb)) then return end
	if (getElementData(zomb, "waveZombie") ~= true) then return end
	if (getElementData(zomb, "waveCountedDead") == true) then return end

	setElementData(zomb, "waveCountedDead", true)
	waveSystem.destroyWaveObject(zomb)
	waveSystem.destroyWaveBlip(zomb)

	local marker = zombieToGame[zomb]
	if (not marker) then return end

	local game = activeWaveGames[marker]
	if (not game or game.active ~= true) then
		zombieToGame[zomb] = nil
		return
	end

	local killerPlayer = waveSystem.getPlayerFromKiller(killer)
	if (isElement(killerPlayer)) then
		game.currentWaveKillers[killerPlayer] = (game.currentWaveKillers[killerPlayer] or 0) + 1
	end

	zombieToGame[zomb] = nil

	if (game.alive > 0) then
		game.alive = game.alive - 1
	end

	waveSystem.setMarkerState(marker, {
		isWaveMarker = true,
		active = true,
		state = "aktiv",
		wave = game.wave,
		alive = game.alive,
		total = game.total,
		timeLeft = math.max(0, (game.waveEndTime or 0) - getUnixTime()),
		cooldownUntil = 0
	})

	if (game.alive <= 0) then
		waveSystem.finishCurrentWave(marker)
	end
end

addEventHandler("onPedWasted", root, function(ammo, killer, weapon, bodypart)
	if (getElementType(source) ~= "ped") then return end
	if (getElementData(source, "waveZombie") ~= true) then return end
	waveSystem.handleZombieDeath(source, killer)
end)

addEventHandler("onElementDestroy", root, function()
	if (getElementType(source) ~= "ped") then return end
	if (getElementData(source, "waveZombie") ~= true) then return end

	waveSystem.destroyWaveObject(source)
	waveSystem.destroyWaveBlip(source)
	waveSystem.handleZombieDeath(source, nil)
end)

setTimer(function()
	for marker, _ in pairs(waveMarkers) do
		if (isElement(marker)) then
			waveSystem.refreshMarkerState(marker)
		end
	end
end, 1000, 0)

addEventHandler("onResourceStop", resourceRoot, function()
	for zomb, obj in pairs(waveHeadObjects) do
		if (isElement(obj)) then
			destroyElement(obj)
		end
	end
	waveHeadObjects = {}

	for zomb, blip in pairs(waveZombieBlips) do
		if (isElement(blip)) then
			destroyElement(blip)
		end
	end
	waveZombieBlips = {}

	for marker, game in pairs(activeWaveGames) do
		if (game and game.zombies) then
			if (isTimer(game.waveTimer)) then
				killTimer(game.waveTimer)
			end

			for _, zomb in ipairs(game.zombies) do
				if (isElement(zomb)) then
					destroyElement(zomb)
				end
			end
		end
	end

	activeWaveGames = {}
end)