function hasPlayerBadge(player, ID)
	ID = tonumber(ID)
	if not ID then return false end

	local charID = getCharacterID(player)
	local playerBadges = getPlayerData("characters", "ID", charID, "badges")

	if not playerBadges then
		dbExec(handler, "UPDATE characters SET badges = ? WHERE ID = ?", "", charID)
		playerBadges = ""
	end

	for _, v in pairs(split(playerBadges, "|")) do
		if tonumber(v) == ID then
			return true
		end
	end

	return false
end

function givePlayerBadge(player, ID)
	ID = tonumber(ID)
	if not ID then return false end
	if hasPlayerBadge(player, ID) then return false end

	local charID = getCharacterID(player)
	local playerBadges = getPlayerData("characters", "ID", charID, "badges") or ""

	dbExec(handler, "UPDATE characters SET badges = ? WHERE ID = ?", playerBadges..ID.."|", charID)
	outputLog(getPlayerName(player).." hat ein Badge bekommen (ID: "..ID..")", "Badges", charID)

	triggerClientEvent(player, "refreshBadgeWindow", player)
	setAchievement(player,467)
	return true
end
addEvent("givePlayerBadge", true)
addEventHandler("givePlayerBadge", root, function(ID)
	givePlayerBadge(client, ID)
end)

function getPlayerEquippedBadge(player)
	return tonumber(getPlayerData("characters", "ID", getCharacterID(player), "equippedBadge")) or 0
end

addEvent("equipPlayerBadge", true)
addEventHandler("equipPlayerBadge", root, function(ID)
	local player = client
	ID = tonumber(ID)
	if not player or not ID then return end

	if hasPlayerBadge(player, ID) then
		local charID = getCharacterID(player)

		dbExec(handler, "UPDATE characters SET equippedBadge = ? WHERE ID = ?", ID, charID)
		apocalypseSetElementData(player, "equippedBadge", ID)

		triggerClientEvent(player, "refreshBadgeWindow", player)
		setAchievement(player,468)
	end
end)

addEvent("unequipPlayerBadge", true)
addEventHandler("unequipPlayerBadge", root, function()
	local player = client
	if not player then return end

	local charID = getCharacterID(player)

	dbExec(handler, "UPDATE characters SET equippedBadge = ? WHERE ID = ?", 0, charID)
	apocalypseSetElementData(player, "equippedBadge", 0)

	triggerClientEvent(player, "refreshBadgeWindow", player)
end)

addEvent("requestBadgeData", true)
addEventHandler("requestBadgeData", root, function()
	local player = client
	if not player then return end

	local badges = {}
	local equipped = getPlayerEquippedBadge(player)

	for id = 1, 9 do
		badges[id] = {
			has = hasPlayerBadge(player, id),
			equipped = equipped == id
		}
	end

	triggerClientEvent(player, "receiveBadgeData", player, badges, equipped)
end)