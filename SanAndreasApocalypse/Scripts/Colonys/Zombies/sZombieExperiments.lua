ZombieExperiments = {}

ZombieExperiments.getZombiesPickup = createPickup(1766.5994873047, -1578.7486572266, 0.49058693647385, 3, 1239, 50)

local Info_Marker = createMarker(1765.1145019531,-1575.9923095703,0.48530757427216,"cylinder",10,0,0,0,0)

addEventHandler("onMarkerHit",Info_Marker,function(player)
	if(getElementType(player) == "player")then
		if(getElementDimension(player) == getElementDimension(source))then
			triggerClientEvent(player, "showInformationHelpBar", player, getText(player, "CZombieExperiments21"), getText(player, "CZombieExperiments23"))
		end
	end
end)

local EXPERIMENT_DURATION = 21600

function ZombieExperiments.getColonyEXPByLevel(level)
	level = tonumber(level) or 0

	if level >= 1 then
		return 2750 * level
	else
		return 1500
	end
end

function ZombieExperiments.getColonyZombies(colony)
	if not colony or tonumber(colony) < 1 then
		return {}
	end

	local result = dbPoll(dbQuery(handler, "SELECT * FROM colony_zombies WHERE colony = ?", tonumber(colony)), -1)
	local zombies = {}

	if result and #result > 0 then
		for _, row in ipairs(result) do
			table.insert(zombies, {
				id = tonumber(row.id) or 0,
				colony = tonumber(row.colony) or 0,
				zombie_id = tonumber(row.zombie_id) or 0,
				reward_timer = tonumber(row.reward_timer) or 0,
				level = tonumber(row.level) or 0
			})
		end
	end

	return zombies
end

function ZombieExperiments.sendColonyZombies(player)
	if not isElement(player) then
		return
	end

	local colony = tonumber(apocalypseGetElementData(player, "colony"))
	if colony and colony >= 1 then
		local zombies = ZombieExperiments.getColonyZombies(colony)
		triggerClientEvent(player, "ZombieExperiments.receiveColonyZombies", player, zombies)
	end
end

function ZombieExperiments.updateClientData(player)
	if not isElement(player) then
		player = client
	end

	if not isElement(player) then
		return
	end

	ZombieExperiments.sendColonyZombies(player)
end
addEvent("ZombieExperiments.updateClientData", true)
addEventHandler("ZombieExperiments.updateClientData", root, ZombieExperiments.updateClientData)

addEventHandler("onPickupHit", ZombieExperiments.getZombiesPickup, function(player)
	if getElementType(player) ~= "player" then
		return
	end

	if getElementDimension(player) ~= getElementDimension(source) then
		return
	end

	local colony = tonumber(apocalypseGetElementData(player, "colony"))
	if colony and colony >= 1 then
		ZombieExperiments.sendColonyZombies(player)
	else
		NPC.MeMessage(player, getText(player, "SZombieExperiments1"))
	end
end)

addEvent("ZombieExperiments.buyZombie", true)
addEventHandler("ZombieExperiments.buyZombie", root, function(zombieID, price)
	zombieID = tonumber(zombieID)
	price = tonumber(price) or 0

	if not zombieID then
		return
	end

	local colony = tonumber(apocalypseGetElementData(client, "colony"))
	if not colony or colony < 1 then
		return
	end

	local result = dbPoll(dbQuery(handler, "SELECT * FROM colony_zombies WHERE colony = ? AND zombie_id = ?", colony, zombieID), -1)
	if result and #result > 0 then
		NPC.MeMessage(client, getText(client, "SZombieExperiments3"))
		return
	end

	if getColonyMoney(colony) < price then
		NPC.MeMessage(client, getText(client, "SZombieExperiments1"))
		return
	end

	Colonys.takeMoney(colony, price)
	dbExec(handler, "INSERT INTO colony_zombies (colony, zombie_id, reward_timer, level) VALUES (?, ?, ?, ?)", colony, zombieID, 0, 0)
	outputLog(getPlayerName(client).." (Kolonie: "..colony..") hat Zombie "..zombieID.." für $"..price.." gekauft","Zombie Experiment",getCharacterID(client))

	NPC.MeMessage(client, getText(client, "SZombieExperiments2"))
	ZombieExperiments.getZombieData(client, zombieID)
end)

addEvent("ZombieExperiments.startExperiment", true)
addEventHandler("ZombieExperiments.startExperiment", root, function(zombieID)
	zombieID = tonumber(zombieID)
	if not zombieID then
		return
	end

	local colony = tonumber(apocalypseGetElementData(client, "colony"))
	if not colony or colony < 1 then
		return
	end

	if hasPlayerItem(client, 30) < 25 then
		NPC.MeMessage(client, getText(client, "SZombieExperiments7"))
		return
	end

	local player = client

	dbQuery(function(qh)
		local result = dbPoll(qh, 0)
		if not result or #result == 0 then
			return
		end

		local rewardTimer = tonumber(result[1].reward_timer) or 0
		local currentTimestamp = getRealTime().timestamp

		if rewardTimer > 0 then
			local timePassed = currentTimestamp - rewardTimer

			if timePassed < EXPERIMENT_DURATION then
				NPC.MeMessage(player, getText(player, "SZombieExperiments4"))
				return
			else
				NPC.MeMessage(player, getText(player, "SZombieExperiments5"))
				return
			end
		end

		takeItem(player, 30, 25)
		dbExec(handler, "UPDATE colony_zombies SET reward_timer = ? WHERE colony = ? AND zombie_id = ?", currentTimestamp, colony, zombieID)
		NPC.MeMessage(player, getText(player, "SZombieExperiments8"))
		ZombieExperiments.getZombieData(player, zombieID)
		outputLog(getPlayerName(client).." (Kolonie: "..colony..") hat ein Experiment an Zombie "..zombieID.." gestartet","Zombie Experiment",getCharacterID(client))
	end, handler, "SELECT reward_timer FROM colony_zombies WHERE colony = ? AND zombie_id = ?", colony, zombieID)
end)

addEvent("ZombieExperiments.getZombieRewards", true)
addEventHandler("ZombieExperiments.getZombieRewards", root, function(zombieID)
	zombieID = tonumber(zombieID)
	if not zombieID then
		return
	end

	local colony = tonumber(apocalypseGetElementData(client, "colony"))
	local player = client

	if not colony or colony < 1 then
		return
	end

	dbQuery(function(qh)
		local result = dbPoll(qh, 0)
		if not result or #result == 0 then
			return
		end

		local rewardTimer = tonumber(result[1].reward_timer) or 0
		local level = tonumber(result[1].level) or 0
		local currentTime = getRealTime().timestamp
		local timePassed = currentTime - rewardTimer

		if rewardTimer > 0 and timePassed >= EXPERIMENT_DURATION then
			dbExec(handler, "UPDATE colony_zombies SET reward_timer = 0 WHERE colony = ? AND zombie_id = ?", colony, zombieID)

			local colonyEXP = ZombieExperiments.getColonyEXPByLevel(level)

			giveEXP(player, 750)
			giveColonyEXP(player, colonyEXP)
			givePlayerServerMoney(player, 125)
			Colonys.giveMoney(colony, 75)
			local loot_items = math.random(3,5)
			giveLootItems(player, loot_items)

			NPC.MeMessage(player, getText(player, "SZombieExperiments6"))
			ZombieExperiments.getZombieData(player,zombieID)
			
			outputLog(getPlayerName(client).." (Kolonie: "..colony..") hat ein Experiment an Zombie "..zombieID.." beendet und 750 EXP, $125 und "..loot_items.." Loot-Items bekommen (+ Kolonie EXP: "..colonyEXP..", Kolonie Geld $75","Zombie Experiment",getCharacterID(client))
		else
			NPC.MeMessage(player, getText(player, "SZombieExperiments5"))
		end
	end, handler, "SELECT reward_timer, level FROM colony_zombies WHERE colony = ? AND zombie_id = ?", colony, zombieID)
end)

function ZombieExperiments.getZombieData(player, id)
	player = player or client
	id = tonumber(id)

	if not isElement(player) or not id then
		return
	end

	local colony = tonumber(apocalypseGetElementData(player, "colony"))
	if not colony or colony < 1 then
		return
	end

	local result = dbPoll(dbQuery(handler, "SELECT * FROM colony_zombies WHERE colony = ? AND zombie_id = ?", colony, id), -1)
	if not result or #result == 0 then
		triggerClientEvent(player, "ZombieExperiments.buyWindow", player, id)
		return
	end

	local rewardTimer = tonumber(result[1].reward_timer) or 0
	local level = tonumber(result[1].level) or 0
	local currentTime = getRealTime().timestamp
	local experimentState = "idle"
	local secondsRemaining = 0
	local colonyEXP = ZombieExperiments.getColonyEXPByLevel(level)

	if rewardTimer > 0 then
		local timePassed = currentTime - rewardTimer

		if timePassed < EXPERIMENT_DURATION then
			experimentState = "running"
			secondsRemaining = EXPERIMENT_DURATION - timePassed
		else
			experimentState = "claimable"
			secondsRemaining = 0
		end
	end

	triggerClientEvent(player, "ZombieExperiments.infoWindow", player, id, experimentState, secondsRemaining, colonyEXP)
end
addEvent("ZombieExperiments.getZombieData", true)
addEventHandler("ZombieExperiments.getZombieData", root, ZombieExperiments.getZombieData)

addEvent("ZombieExperiments.updateLevel", true)
addEventHandler("ZombieExperiments.updateLevel", root, function(zombieID)
	zombieID = tonumber(zombieID)
	local colony = tonumber(apocalypseGetElementData(client, "colony"))

	if not zombieID or not colony or colony < 1 then
		return
	end

	local result = dbPoll(dbQuery(handler, "SELECT * FROM colony_zombies WHERE colony = ? AND zombie_id = ?", colony, zombieID), -1)
	if not result or #result == 0 then
		return
	end

	local currentLevel = tonumber(result[1].level) or 0
	local price = 50 * (currentLevel + 1)
	
	if(currentLevel < 10)then
		if hasPlayerItem(client, 63) < price then
			NPC.MeMessage(client, getText(client, "SZombieExperiments10"):format(price))
			return
		end

		takeItem(client, 63, price)
		dbExec(handler, "UPDATE colony_zombies SET level = level + 1 WHERE colony = ? AND zombie_id = ?", colony, zombieID)

		NPC.MeMessage(client, getText(client, "SZombieExperiments11"))
		ZombieExperiments.sendColonyZombies(client)
		
		outputLog(getPlayerName(client).." (Kolonie: "..colony..") hat Zombie "..zombieID.." für "..price.." DNA Chips auf Level "..currentLevel.." erhöht","Zombie Experiment",getCharacterID(client))
	else
		NPC.MeMessage(client, getText(client, "SZombieExperiments12"))
	end
end)