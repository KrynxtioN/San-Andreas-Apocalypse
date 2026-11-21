SpecialAirdrop = {
	crateObjects = {},
	blips = {},
	parachute = {},
	sphere = {},
	radarAreas = {},
	activeGames = {},
	zombieToCrate = {},
	headObjects = {},
	zombieBlips = {},
}

local START_DELAY_SECONDS = 5
local NEXT_WAVE_DELAY_SECONDS = 5
local LOOT_SEARCH_SECONDS = 10
local FALL_TIME_MS = 60000
local SPAWN_INTERVAL_MS = 3600000
local LOOT_DESPAWN_SECONDS = 5 * 60

local ZOMBIE_MIN_SPAWN_RADIUS = 8
local ZOMBIE_SPAWN_Z_OFFSET = 1
local AIRDROP_RADAR_AREA_SIZE = 80

local Achievements = {
	{1,469},
	{5,470},
	{10,471},
	{25,472},
	{50,473},
	{100,474},
}

local specialDropPositions = {
	{ x = 98.586441040039, y = 2496.5031738281, z = 16.484375, interior = 0, dimension = 0 },
	{ x = 1763.2536621094, y = -2524.4887695312, z = 13.546875, interior = 0, dimension = 0 },
	{ x = 1431.1727294922, y = 1581.4268798828, z = 10.8203125, interior = 0, dimension = 0 },
	{ x = -1299.1583251953, y = -164.25398254395, z = 14.1484375, interior = 0, dimension = 0 },
}

local maxSpecialCrates = #specialDropPositions

local waveConfig = {
	[1] = { zombies = 10, radius = 15, time = 90 },
	[2] = { zombies = 20, radius = 18, time = 120 },
	[3] = { zombies = 30, radius = 22, time = 150 },
	[4] = { zombies = 40, radius = 25, time = 180 },
	[5] = { zombies = 50, radius = 30, time = 210 },
}

local function getUnixTime()
	return getRealTime().timestamp
end

local function msg(player, text, r, g, b)
	if isElement(player) then
		outputChatBox(text, player, r or 255, g or 255, b or 255)
	end
end

local function outputNearbyAirdrop(id, text, r, g, b, range)
	local sphere = SpecialAirdrop.sphere[id]
	if not isElement(sphere) then return end

	range = range or 80

	local x, y, z = getElementPosition(sphere)
	local interior = getElementInterior(sphere)
	local dimension = getElementDimension(sphere)

	for _, player in ipairs(getElementsByType("player")) do
		if isElement(player) and getElementInterior(player) == interior and getElementDimension(player) == dimension then
			local px, py, pz = getElementPosition(player)

			if getDistanceBetweenPoints3D(px, py, pz, x, y, z) <= range then
				outputChatBox(text, player, r or 255, g or 255, b or 255)
			end
		end
	end
end

local function getRandomPointInRing(cx, cy, minRadius, maxRadius)
	if maxRadius <= minRadius then
		maxRadius = minRadius + 1
	end

	local angle = math.rad(math.random(0, 359))
	local dist = minRadius + (math.random() * (maxRadius - minRadius))

	return cx + math.cos(angle) * dist, cy + math.sin(angle) * dist
end

local function getValidZombieSpawnPoint(cx, cy, cz, minRadius, maxRadius)
	local sx, sy = getRandomPointInRing(cx, cy, minRadius, maxRadius)
	return sx, sy, cz + ZOMBIE_SPAWN_Z_OFFSET
end

local function setAirdropRadarAreaActive(id, active)
	local area = SpecialAirdrop.radarAreas[id]
	if not isElement(area) then return end

	if active then
		setRadarAreaColor(area, 255, 0, 0, 120)
		setRadarAreaFlashing(area, true)
	else
		setRadarAreaColor(area, 255, 0, 0, 70)
		setRadarAreaFlashing(area, false)
	end
end

local function getPlayerFromKiller(killer)
	if not isElement(killer) then return nil end

	if getElementType(killer) == "player" then
		return killer
	end

	if getElementType(killer) == "vehicle" then
		local controller = getVehicleController(killer)

		if isElement(controller) and getElementType(controller) == "player" then
			return controller
		end
	end

	return nil
end

function SpecialAirdrop.setState(id, data)
	local sphere = SpecialAirdrop.sphere[id]
	if not isElement(sphere) then return end

	for k, v in pairs(data) do
		setElementData(sphere, "specialAirdrop:" .. k, v)
	end
end

function SpecialAirdrop.refreshState(id)
	local sphere = SpecialAirdrop.sphere[id]
	local crate = SpecialAirdrop.crateObjects[id]

	if not isElement(sphere) or not isElement(crate) then return end

	local game = SpecialAirdrop.activeGames[id]

	if game and game.active == true then
		SpecialAirdrop.setState(id, {
			isSpecialAirdrop = true,
			showInfo = true,
			active = true,
			locked = true,
			state = game.state or "aktiv",
			wave = game.wave or 0,
			alive = game.alive or 0,
			total = game.total or 0,
			timeLeft = math.max(0, (game.waveEndTime or 0) - getUnixTime()),
			lootReady = false,
		})
		return
	end

	local landed = getElementData(crate, "SpecialAirdrop:Landed") == true
	local finished = getElementData(crate, "SpecialAirdrop:Finished") == true
	local lootEndTime = tonumber(getElementData(crate, "SpecialAirdrop:LootEndTime")) or 0

	SpecialAirdrop.setState(id, {
		isSpecialAirdrop = true,
		showInfo = landed,
		active = false,
		locked = false,
		state = finished and "lootbar" or "bereit",
		wave = game and game.wave or 0,
		alive = 0,
		total = 0,
		timeLeft = finished and math.max(0, lootEndTime - getUnixTime()) or 0,
		lootReady = finished,
	})
end

function SpecialAirdrop.countCrates()
	local amount = 0

	for _, crate in pairs(SpecialAirdrop.crateObjects) do
		if isElement(crate) then
			amount = amount + 1
		end
	end

	return amount
end

function SpecialAirdrop.getFreeSpawn()
	local free = {}

	for i = 1, #specialDropPositions do
		if not isElement(SpecialAirdrop.crateObjects[i]) then
			table.insert(free, i)
		end
	end

	if #free == 0 then return false end

	return free[math.random(1, #free)]
end

function SpecialAirdrop.createCrateAt(id, x, y, z, interior, dimension, instantLand)
	if SpecialAirdrop.countCrates() >= maxSpecialCrates then
		return false
	end

	interior = interior or 0
	dimension = dimension or 0

	SpecialAirdrop.crateObjects[id] = createObject(3577, x, y, z + 1000)
	SpecialAirdrop.parachute[id] = createObject(2903, x, y, z + 1000)
	SpecialAirdrop.sphere[id] = createColSphere(x, y, z + 1, 4)
	SpecialAirdrop.blips[id] = createBlip(x, y, z, 18, 1, 255, 40, 40, 255, 0, 150)

	SpecialAirdrop.radarAreas[id] = createRadarArea(
		x - (AIRDROP_RADAR_AREA_SIZE / 2),
		y - (AIRDROP_RADAR_AREA_SIZE / 2),
		AIRDROP_RADAR_AREA_SIZE,
		AIRDROP_RADAR_AREA_SIZE,
		255,
		0,
		0,
		70
	)

	local elements = {
		SpecialAirdrop.crateObjects[id],
		SpecialAirdrop.parachute[id],
		SpecialAirdrop.sphere[id],
		SpecialAirdrop.blips[id],
		SpecialAirdrop.radarAreas[id],
	}

	for _, element in ipairs(elements) do
		if isElement(element) then
			setElementInterior(element, interior)
			setElementDimension(element, dimension)
		end
	end

	setAirdropRadarAreaActive(id, false)

	setElementData(SpecialAirdrop.crateObjects[id], "SpecialAirdrop:Landed", false)
	setElementData(SpecialAirdrop.crateObjects[id], "SpecialAirdrop:Finished", false)
	setElementData(SpecialAirdrop.crateObjects[id], "SpecialAirdrop:LootEndTime", 0)

	setElementData(SpecialAirdrop.sphere[id], "SpecialAirdropID", id)

	SpecialAirdrop.setState(id, {
		isSpecialAirdrop = true,
		showInfo = false,
		active = false,
		locked = false,
		state = "fallend",
		wave = 0,
		alive = 0,
		total = 0,
		timeLeft = 0,
		lootReady = false,
	})

	addEventHandler("onColShapeHit", SpecialAirdrop.sphere[id], SpecialAirdrop.onCrateHit)

	if instantLand then
		setElementPosition(SpecialAirdrop.crateObjects[id], x, y, z)

		if isElement(SpecialAirdrop.parachute[id]) then
			destroyElement(SpecialAirdrop.parachute[id])
		end

		setElementData(SpecialAirdrop.crateObjects[id], "SpecialAirdrop:Landed", true)
		SpecialAirdrop.refreshState(id)
	else
		moveObject(SpecialAirdrop.crateObjects[id], FALL_TIME_MS, x, y, z)
		moveObject(SpecialAirdrop.parachute[id], FALL_TIME_MS, x, y, z + 6.7)

		setTimer(function(crateID)
			if isElement(SpecialAirdrop.crateObjects[crateID]) then
				setElementData(SpecialAirdrop.crateObjects[crateID], "SpecialAirdrop:Landed", true)
			end

			if isElement(SpecialAirdrop.parachute[crateID]) then
				destroyElement(SpecialAirdrop.parachute[crateID])
			end

			SpecialAirdrop.refreshState(crateID)
		end, FALL_TIME_MS, 1, id)
	end

	local sphere = SpecialAirdrop.sphere[id]
	local sx, sy, sz = getElementPosition(sphere)
	local sInterior = getElementInterior(sphere)
	local sDimension = getElementDimension(sphere)

	for _, player in ipairs(getElementsByType("player")) do
		if isElement(player) and getElementInterior(player) == sInterior and getElementDimension(player) == sDimension then
			local px, py, pz = getElementPosition(player)

			if getDistanceBetweenPoints3D(px, py, pz, sx, sy, sz) <= 80 then
				outputChatBox(getText(player, "SSpecialAirdrop10"), player, 80, 80, 120)
			end
		end
	end

	return true
end

function SpecialAirdrop.createRandomCrate(instantLand)
	local id = SpecialAirdrop.getFreeSpawn()
	if not id then
		return false
	end

	local pos = specialDropPositions[id]
	return SpecialAirdrop.createCrateAt(id, pos.x, pos.y, pos.z, pos.interior, pos.dimension, instantLand)
end

function SpecialAirdrop.onCrateHit(player)
	if getElementType(player) ~= "player" then return end
	if isPedInVehicle(player) then return end

	local id = getElementData(source, "SpecialAirdropID")
	if not id then return end

	local crate = SpecialAirdrop.crateObjects[id]
	if not isElement(crate) then return end

	if getElementData(crate, "SpecialAirdrop:Landed") ~= true then
		return
	end

	local game = SpecialAirdrop.activeGames[id]

	if getElementData(crate, "SpecialAirdrop:Finished") == true then
		SpecialAirdrop.startLoot(player, id)
		return
	end

	if game and game.active == true then
		createInfobox(player, getText(player, "SSpecialAirdrop9"))
		return
	end

	SpecialAirdrop.startWaves(id, player)
end

function SpecialAirdrop.startWaves(id, starter)
	local crate = SpecialAirdrop.crateObjects[id]
	if not isElement(crate) then return end

	local x, y, z = getElementPosition(crate)

	SpecialAirdrop.activeGames[id] = {
		active = true,
		state = "pause",
		wave = 0,
		alive = 0,
		total = 0,
		zombies = {},
		killers = {},
		looted = {},
		lootTimers = {},
		despawnTimer = nil,
		x = x,
		y = y,
		z = z,
		interior = getElementInterior(crate),
		dimension = getElementDimension(crate),
		waveTimer = nil,
		waveEndTime = getUnixTime() + START_DELAY_SECONDS,
	}

	setAirdropRadarAreaActive(id, true)

	SpecialAirdrop.setState(id, {
		isSpecialAirdrop = true,
		showInfo = true,
		active = true,
		locked = true,
		state = "pause",
		wave = 1,
		alive = 0,
		total = 0,
		timeLeft = START_DELAY_SECONDS,
		lootReady = false,
	})

	local sphere = SpecialAirdrop.sphere[id]
	local sx, sy, sz = getElementPosition(sphere)
	local interior = getElementInterior(sphere)
	local dimension = getElementDimension(sphere)

	for _, player in ipairs(getElementsByType("player")) do
		if isElement(player) and getElementInterior(player) == interior and getElementDimension(player) == dimension then
			local px, py, pz = getElementPosition(player)

			if getDistanceBetweenPoints3D(px, py, pz, sx, sy, sz) <= 80 then
				outputChatBox(getText(player, "SSpecialAirdrop11"):format(getPlayerName(starter)), player, 255, 160, 40)
			end
		end
	end

	setTimer(function(crateID)
		SpecialAirdrop.startNextWave(crateID)
	end, START_DELAY_SECONDS * 1000, 1, id)
end

function SpecialAirdrop.startNextWave(id)
	local game = SpecialAirdrop.activeGames[id]
	if not game or game.active ~= true then return end

	if isTimer(game.waveTimer) then
		killTimer(game.waveTimer)
		game.waveTimer = nil
	end

	game.wave = game.wave + 1

	local cfg = waveConfig[game.wave]
	if not cfg then
		SpecialAirdrop.finishWaves(id)
		return
	end

	game.state = "aktiv"
	game.alive = 0
	game.total = cfg.zombies
	game.zombies = {}
	game.waveEndTime = getUnixTime() + cfg.time

	for player, kills in pairs(game.killers) do
		if isElement(player) and kills and kills > 0 then
			outputChatBox(getText(player, "SSpecialAirdrop6"):format(game.wave), player, 255, 160, 40)
		end
	end

	for i = 1, cfg.zombies do
		local sx, sy, sz = getValidZombieSpawnPoint(game.x, game.y, game.z, ZOMBIE_MIN_SPAWN_RADIUS, cfg.radius)
		local zomb = createZombie(sx, sy, sz, game.interior, game.dimension)

		if isElement(zomb) then
			setElementData(zomb, "specialAirdropZombie", true)
			setElementData(zomb, "specialAirdropID", id)
			setElementData(zomb, "specialAirdropDead", false)
			setElementData(zomb, "forcedtoexist", true)

			SpecialAirdrop.zombieToCrate[zomb] = id
			table.insert(game.zombies, zomb)
			game.alive = game.alive + 1

			SpecialAirdrop.attachZombieObject(zomb)
			SpecialAirdrop.attachZombieBlip(zomb)
		end
	end

	game.waveTimer = setTimer(function(crateID)
		SpecialAirdrop.cancelWaves(crateID)
	end, cfg.time * 1000, 1, id)

	SpecialAirdrop.refreshState(id)

	if game.alive <= 0 then
		SpecialAirdrop.finishCurrentWave(id)
	end
end

function SpecialAirdrop.finishCurrentWave(id)
	local game = SpecialAirdrop.activeGames[id]
	if not game or game.active ~= true then return end

	if isTimer(game.waveTimer) then
		killTimer(game.waveTimer)
		game.waveTimer = nil
	end

	local nextWave = game.wave + 1

	if not waveConfig[nextWave] then
		SpecialAirdrop.finishWaves(id)
		return
	end

	game.state = "pause"
	game.waveEndTime = getUnixTime() + NEXT_WAVE_DELAY_SECONDS

	SpecialAirdrop.setState(id, {
		isSpecialAirdrop = true,
		showInfo = true,
		active = true,
		locked = true,
		state = "pause",
		wave = nextWave,
		alive = 0,
		total = 0,
		timeLeft = NEXT_WAVE_DELAY_SECONDS,
		lootReady = false,
	})

	for player, kills in pairs(game.killers) do
		if isElement(player) and kills and kills > 0 then
			outputChatBox(getText(player, "SSpecialAirdrop7"), player, 80, 200, 255)
		end
	end

	setTimer(function(crateID)
		SpecialAirdrop.startNextWave(crateID)
	end, NEXT_WAVE_DELAY_SECONDS * 1000, 1, id)
end

function SpecialAirdrop.finishWaves(id)
	local game = SpecialAirdrop.activeGames[id]
	local crate = SpecialAirdrop.crateObjects[id]
	if not game then return end

	if isTimer(game.waveTimer) then
		killTimer(game.waveTimer)
		game.waveTimer = nil
	end

	for _, zomb in ipairs(game.zombies) do
		SpecialAirdrop.destroyZombieObject(zomb)
		SpecialAirdrop.destroyZombieBlip(zomb)

		if isElement(zomb) then
			SpecialAirdrop.zombieToCrate[zomb] = nil
			destroyElement(zomb)
		end
	end

	game.active = false
	game.state = "lootbar"
	game.alive = 0
	game.total = 0
	game.lootEndTime = getUnixTime() + LOOT_DESPAWN_SECONDS

	setAirdropRadarAreaActive(id, false)

	if isElement(crate) then
		setElementData(crate, "SpecialAirdrop:Finished", true)
		setElementData(crate, "SpecialAirdrop:LootEndTime", game.lootEndTime)
	end

	SpecialAirdrop.setState(id, {
		isSpecialAirdrop = true,
		showInfo = true,
		active = false,
		locked = false,
		state = "lootbar",
		wave = game.wave,
		alive = 0,
		total = 0,
		timeLeft = LOOT_DESPAWN_SECONDS,
		lootReady = true,
	})

	for player, kills in pairs(game.killers) do
		if isElement(player) and kills and kills > 0 then
			outputChatBox(getText(player, "SSpecialAirdrop8"), player, 80, 255, 80)
		end
	end

	if isTimer(game.despawnTimer) then
		killTimer(game.despawnTimer)
	end

	game.despawnTimer = setTimer(function(crateID)
		if isElement(SpecialAirdrop.crateObjects[crateID]) then
			SpecialAirdrop.destroyCrate(crateID)
		end
	end, LOOT_DESPAWN_SECONDS * 1000, 1, id)
end

function SpecialAirdrop.cancelWaves(id)
	local game = SpecialAirdrop.activeGames[id]
	if not game then return end

	if isTimer(game.waveTimer) then
		killTimer(game.waveTimer)
	end

	for _, zomb in ipairs(game.zombies) do
		SpecialAirdrop.destroyZombieObject(zomb)
		SpecialAirdrop.destroyZombieBlip(zomb)

		if isElement(zomb) then
			SpecialAirdrop.zombieToCrate[zomb] = nil
			destroyElement(zomb)
		end
	end

	local sphere = SpecialAirdrop.sphere[id]

	if isElement(sphere) then
		local sx, sy, sz = getElementPosition(sphere)
		local interior = getElementInterior(sphere)
		local dimension = getElementDimension(sphere)

		for _, player in ipairs(getElementsByType("player")) do
			if isElement(player) and getElementInterior(player) == interior and getElementDimension(player) == dimension then
				local px, py, pz = getElementPosition(player)

				if getDistanceBetweenPoints3D(px, py, pz, sx, sy, sz) <= 80 then
					outputChatBox(getText(player, "SSpecialAirdrop12"), player, 255, 160, 40)
				end
			end
		end
	end

	setAirdropRadarAreaActive(id, false)

	SpecialAirdrop.activeGames[id] = nil
	SpecialAirdrop.refreshState(id)
end

function SpecialAirdrop.handleZombieDeath(zomb, killer)
	if not isElement(zomb) then return end
	if getElementData(zomb, "specialAirdropZombie") ~= true then return end
	if getElementData(zomb, "specialAirdropDead") == true then return end

	setElementData(zomb, "specialAirdropDead", true)

	SpecialAirdrop.destroyZombieObject(zomb)
	SpecialAirdrop.destroyZombieBlip(zomb)

	local id = SpecialAirdrop.zombieToCrate[zomb]
	if not id then return end

	local game = SpecialAirdrop.activeGames[id]
	if not game or game.active ~= true then
		SpecialAirdrop.zombieToCrate[zomb] = nil
		return
	end

	local player = getPlayerFromKiller(killer)

	if isElement(player) then
		local oldKills = game.killers[player] or 0
		game.killers[player] = oldKills + 1

		if oldKills == 0 then
			outputChatBox(getText(player, "SSpecialAirdrop5"), player, 80, 255, 80)
		end
	end

	SpecialAirdrop.zombieToCrate[zomb] = nil

	if game.alive > 0 then
		game.alive = game.alive - 1
	end

	SpecialAirdrop.refreshState(id)

	if game.alive <= 0 then
		SpecialAirdrop.finishCurrentWave(id)
	end
end

addEventHandler("onPedWasted", root, function(ammo, killer)
	if getElementType(source) ~= "ped" then return end
	SpecialAirdrop.handleZombieDeath(source, killer)
end)

addEventHandler("onElementDestroy", root, function()
	if getElementType(source) ~= "ped" then return end
	if getElementData(source, "specialAirdropZombie") ~= true then return end

	SpecialAirdrop.destroyZombieObject(source)
	SpecialAirdrop.destroyZombieBlip(source)
end)

function SpecialAirdrop.startLoot(player, id)
	local game = SpecialAirdrop.activeGames[id]
	if not game then return end

	local kills = game.killers[player] or 0

	if kills <= 0 then
		createInfobox(player, getText(player, "SSpecialAirdrop3"))
		return
	end

	if game.looted[player] == true then
		NPC.MeMessage(player, getText(player, "SSpecialAirdrop2"))
		return
	end

	if isTimer(game.lootTimers[player]) then return end

	setElementData(player, "SearchingSpecialAirdrop", true)
	setElementData(player, "SpecialAirdropID", id)

	setPedAnimation(player, "ped", "ATM")
	toggleAllControls(player, false)

	triggerClientEvent(player, "createProgressBar", player, LOOT_SEARCH_SECONDS)
	triggerClientEvent(player, "createActivitiesInformationText", player, getText(player, "SSpecialAirdrop4"))

	game.lootTimers[player] = setTimer(function(thePlayer, crateID)
		SpecialAirdrop.finishLoot(thePlayer, crateID)
	end, LOOT_SEARCH_SECONDS * 1000, 1, player, id)
end

function SpecialAirdrop.finishLoot(player, id)
	if not isElement(player) then return end

	local game = SpecialAirdrop.activeGames[id]
	if not game then return end

	game.lootTimers[player] = nil

	setElementData(player, "SearchingSpecialAirdrop", false)
	setElementData(player, "SpecialAirdropID", nil)

	setPedAnimation(player)
	toggleAllControls(player, true)

	local kills = game.killers[player] or 0

	if kills <= 0 or game.looted[player] == true then return end

	game.looted[player] = true

	SpecialAirdrop.giveLoot(player, kills)
	msg(player, getText(player, "SSpecialAirdrop1"):format(kills), 80, 255, 80)
	Characters.addStats(player,"special_airdrops",getPlayerData("character_stats","character_id",getCharacterID(player),"special_airdrops")+1)
	local looted = getPlayerData("character_stats","character_id",getCharacterID(player),"special_airdrops")
	for _,v in pairs(Achievements)do
		if(looted >= v[1])then
			setAchievement(client,v[2])
		end
	end
				
	SpecialAirdrop.checkDestroyCrate(id)
end

addEvent("onCancelSpecialAirdropSearch", true)
addEventHandler("onCancelSpecialAirdropSearch", root, function()
	local player = source

	if getElementData(player, "SearchingSpecialAirdrop") ~= true then return end

	local id = getElementData(player, "SpecialAirdropID")
	local game = id and SpecialAirdrop.activeGames[id]

	if game and isTimer(game.lootTimers[player]) then
		killTimer(game.lootTimers[player])
		game.lootTimers[player] = nil
	end

	setPedAnimation(player)
	toggleAllControls(player, true)

	setElementData(player, "SearchingSpecialAirdrop", false)
	setElementData(player, "SpecialAirdropID", nil)

	triggerClientEvent(player, "ProgressBar.close", player)
end)

function SpecialAirdrop.giveLoot(player, kills)
	local itemAmount = 5 + math.floor(kills / 2)
	if itemAmount > 50 then itemAmount = 50 end

	giveLootItems(player, itemAmount)

	local xp = 250 + kills * 25

	if SERVERBONUS and SERVERBONUS.AIRDROP == true then
		xp = xp * 2
	end

	giveEXP(player, xp)

	local skillpoints = 1

	if kills >= 25 then
		skillpoints = 10
	elseif kills >= 15 then
		skillpoints = 6
	elseif kills >= 10 then
		skillpoints = 4
	elseif kills >= 5 then
		skillpoints = 2
	end

	givePlayerSkillpoint(player, skillpoints)

	if kills >= 25 then
		local items = { 74, 77 }
		giveItem(player, items[math.random(1, #items)], 1)
	elseif kills >= 10 then
		local items = { 73, 76 }
		giveItem(player, items[math.random(1, #items)], 1)
	elseif kills >= 5 then
		local items = { 72, 75 }
		giveItem(player, items[math.random(1, #items)], 1)
	end
end

function SpecialAirdrop.checkDestroyCrate(id)
	local game = SpecialAirdrop.activeGames[id]
	if not game then return end

	for player, kills in pairs(game.killers) do
		if isElement(player) and kills > 0 and game.looted[player] ~= true then
			return
		end
	end

	SpecialAirdrop.destroyCrate(id)
end

function SpecialAirdrop.destroyCrate(id)
	local game = SpecialAirdrop.activeGames[id]

	if game then
		if isTimer(game.waveTimer) then
			killTimer(game.waveTimer)
		end

		if isTimer(game.despawnTimer) then
			killTimer(game.despawnTimer)
		end

		if game.lootTimers then
			for player, timer in pairs(game.lootTimers) do
				if isTimer(timer) then
					killTimer(timer)
				end

				if isElement(player) then
					setPedAnimation(player)
					toggleAllControls(player, true)
					setElementData(player, "SearchingSpecialAirdrop", false)
					setElementData(player, "SpecialAirdropID", nil)
					triggerClientEvent(player, "ProgressBar.close", player)
				end
			end
		end

		if game.zombies then
			for _, zomb in ipairs(game.zombies) do
				SpecialAirdrop.destroyZombieObject(zomb)
				SpecialAirdrop.destroyZombieBlip(zomb)

				if isElement(zomb) then
					SpecialAirdrop.zombieToCrate[zomb] = nil
					destroyElement(zomb)
				end
			end
		end
	end

	if isElement(SpecialAirdrop.crateObjects[id]) then destroyElement(SpecialAirdrop.crateObjects[id]) end
	if isElement(SpecialAirdrop.blips[id]) then destroyElement(SpecialAirdrop.blips[id]) end
	if isElement(SpecialAirdrop.sphere[id]) then destroyElement(SpecialAirdrop.sphere[id]) end
	if isElement(SpecialAirdrop.parachute[id]) then destroyElement(SpecialAirdrop.parachute[id]) end
	if isElement(SpecialAirdrop.radarAreas[id]) then destroyElement(SpecialAirdrop.radarAreas[id]) end

	SpecialAirdrop.crateObjects[id] = nil
	SpecialAirdrop.blips[id] = nil
	SpecialAirdrop.sphere[id] = nil
	SpecialAirdrop.parachute[id] = nil
	SpecialAirdrop.radarAreas[id] = nil
	SpecialAirdrop.activeGames[id] = nil
end

function SpecialAirdrop.clearAll()
	for id, _ in pairs(SpecialAirdrop.crateObjects) do
		SpecialAirdrop.destroyCrate(id)
	end

	for zomb, _ in pairs(SpecialAirdrop.zombieToCrate) do
		if isElement(zomb) then
			destroyElement(zomb)
		end
	end

	SpecialAirdrop.zombieToCrate = {}
end

function SpecialAirdrop.attachZombieObject(zomb)
	if not isElement(zomb) then return false end

	if isElement(SpecialAirdrop.headObjects[zomb]) then
		destroyElement(SpecialAirdrop.headObjects[zomb])
	end

	local obj = createObject(1318, 0, 0, 0)
	if not isElement(obj) then return false end

	setElementInterior(obj, getElementInterior(zomb))
	setElementDimension(obj, getElementDimension(zomb))
	setElementCollisionsEnabled(obj, false)

	attachElements(obj, zomb, 0, 0, 1.6)

	SpecialAirdrop.headObjects[zomb] = obj
	return true
end

function SpecialAirdrop.destroyZombieObject(zomb)
	if isElement(SpecialAirdrop.headObjects[zomb]) then
		destroyElement(SpecialAirdrop.headObjects[zomb])
	end

	SpecialAirdrop.headObjects[zomb] = nil
end

function SpecialAirdrop.attachZombieBlip(zomb)
	if not isElement(zomb) then return false end

	if isElement(SpecialAirdrop.zombieBlips[zomb]) then
		destroyElement(SpecialAirdrop.zombieBlips[zomb])
	end

	local blip = createBlipAttachedTo(zomb, 0, 1, 255, 40, 40, 255, 0, 300)
	if not isElement(blip) then return false end

	setElementInterior(blip, getElementInterior(zomb))
	setElementDimension(blip, getElementDimension(zomb))

	SpecialAirdrop.zombieBlips[zomb] = blip
	return true
end

function SpecialAirdrop.destroyZombieBlip(zomb)
	if isElement(SpecialAirdrop.zombieBlips[zomb]) then
		destroyElement(SpecialAirdrop.zombieBlips[zomb])
	end

	SpecialAirdrop.zombieBlips[zomb] = nil
end

setTimer(function()
	for id, game in pairs(SpecialAirdrop.activeGames) do
		if game then
			SpecialAirdrop.refreshState(id)
		end
	end
end, 1000, 0)

addEventHandler("onResourceStart", resourceRoot, function()
	SpecialAirdrop.createRandomCrate(false)

	setTimer(function()
		SpecialAirdrop.createRandomCrate(false)
	end, SPAWN_INTERVAL_MS, 0)
end)

addEventHandler("onPlayerQuit", root, function()
	local player = source

	for _, game in pairs(SpecialAirdrop.activeGames) do
		if game.lootTimers and isTimer(game.lootTimers[player]) then
			killTimer(game.lootTimers[player])
			game.lootTimers[player] = nil
		end
	end
end)

addEventHandler("onPlayerWasted", root, function()
	triggerEvent("onCancelSpecialAirdropSearch", source)
end)

addEventHandler("onResourceStop", resourceRoot, function()
	SpecialAirdrop.clearAll()

	for _, obj in pairs(SpecialAirdrop.headObjects) do
		if isElement(obj) then destroyElement(obj) end
	end

	for _, blip in pairs(SpecialAirdrop.zombieBlips) do
		if isElement(blip) then destroyElement(blip) end
	end
end)