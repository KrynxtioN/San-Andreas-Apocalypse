Skillsystem = {
	["Pickups"] = {
		{2022.1755371094,-1402.6043701172,17.180549621582,5},
		{1172.630859375,-1328.0463867188,15.402812004089,5},
		{1244.9196777344,325.29544067383,19.7555103302,5},
		{1581.8811035156,1757.9847412109,10.8203125,5},
		{-308.61837768555,1039.978515625,19.727632522583,5},
		{-2594.1000976562,617.60998535156,14.453125,5},
		{-2194.4897460938,-2296.1833496094,30.625,5},
		{-1518.4763183594,2519.7785644531,55.904094696045,5},
		{-1574.6002197266,657.65045166016,7.1901206970215,5},
		{-218.82009887695,984.19140625,19.537002563477,5},
		{-1392.5268554688,2639.5595703125,55.964595794678,5},
		{2290.13671875,2431.4685058594,10.8203125,5},
		{1576.2486572266,-1633.8115234375,13.557028770447,5},
		{-2048.9848632812,64.332626342773,28.390625,5},
		{-1251.4801025391,65.757385253906,14.1484375,5},
		{1748.9024658203,2080.9904785156,10.8203125,5},

		{2726.4497070312,-2330.0512695312,3,6},
		{504.55313110352,-69.516716003418,998.7578125,7,11},
		{2332.5405273438,-3.5911033153534,26.557689666748,8},
	},

	["Data"] = {
		[1] = {[1]=50,[2]=100,[3]=250,[4]=500,[5]=1000},
		[2] = {[1]=50,[2]=100},
		[3] = {[1]=50,[2]=100,[3]=250,[4]=500,[5]=1000},
		[4] = {
			[1]=50,[2]=100,[3]=150,[4]=200,[5]=250,[6]=300,[7]=350,[8]=400,[9]=450,[10]=500,
			[11]=550,[12]=600,[13]=650,[14]=700,[15]=750,[16]=800,[17]=850,[18]=900,[19]=950,[20]=1000,
		},
		[5] = {[1]=50,[2]=100,[3]=250,[4]=500,[5]=1000},
		[6] = {[1]=50,[2]=100,[3]=250,[4]=500,[5]=1000},
		[7] = {[1]=50,[2]=100,[3]=250,[4]=500,[5]=1000},
		[8] = {[1]=50,[2]=100,[3]=250,[4]=500,[5]=1000},
	},
}

Skillsystem.SkillPickups = {}

for _, v in pairs(Skillsystem["Pickups"]) do
	local pickup = createPickup(v[1], v[2], v[3], 3, 1239, 50)

	apocalypseSetElementData(pickup, "SkillID", v[4])

	if v[5] then
		setElementInterior(pickup, v[5])
	end

	table.insert(Skillsystem.SkillPickups, {
		element = pickup,
		skillID = v[4],
	})

	addEventHandler("onPickupHit", pickup, function(player)
		if getElementType(player) == "player" then
			if getElementDimension(player) == getElementDimension(source) then
				if not isPedInVehicle(player) then
					triggerClientEvent(player, "Skillsystem.createWindow", player, apocalypseGetElementData(source, "SkillID"))
				end
			end
		end
	end)
end

addEvent("Skillsystem.requestPickupLabels", true)
addEventHandler("Skillsystem.requestPickupLabels", root, function()
	for _, data in ipairs(Skillsystem.SkillPickups) do
		if isElement(data.element) then
			triggerClientEvent(client, "Skillsystem.addPickupLabel", client, data.element, data.skillID)
		end
	end
end)

function givePlayerSkillpoint(player, points)
	local skillPoints = tonumber(getPlayerData("characters", "ID", getCharacterID(player), "skillpoints")) or 0
	skillPoints = skillPoints + tonumber(points)

	if isDoubleSkillpointsActive(player) == true then
		skillPoints = skillPoints * 2
	end

	dbExec(handler, "UPDATE characters SET skillpoints = ? WHERE ID = ?", skillPoints, getCharacterID(player))
end

function increaseSkillLevel(player, ID)
	local playerID = getCharacterID(player)
	local playerSkills = getPlayerData("characters", "ID", playerID, "playerskills")

	if not playerSkills or playerSkills == "" then
		local newSkillData = ID .. ",1"
		dbExec(handler, "UPDATE characters SET playerskills = ? WHERE ID = ?", newSkillData, playerID)
		return
	end

	local values = split(playerSkills, "|")
	local updated = false
	local newSkillString = ""

	for _, v in ipairs(values) do
		local skillData = split(v, ",")
		local skillID = tonumber(skillData[1])
		local skillLevel = tonumber(skillData[2])

		if skillID == tonumber(ID) then
			skillLevel = skillLevel + 1
			updated = true
		end

		newSkillString = newSkillString .. skillID .. "," .. skillLevel .. "|"
	end

	if not updated then
		newSkillString = newSkillString .. ID .. ",1|"
	end

	newSkillString = newSkillString:sub(1, -2)

	dbExec(handler, "UPDATE characters SET playerskills = ? WHERE ID = ?", newSkillString, playerID)
end

function getSkillLevel(player, ID)
	local playerID = getCharacterID(player)
	local playerSkills = getPlayerData("characters", "ID", playerID, "playerskills")

	if not playerSkills or playerSkills == "" then
		return 0
	end

	local values = split(playerSkills, "|")

	for _, v in ipairs(values) do
		local skillData = split(v, ",")
		local skillID = tonumber(skillData[1])
		local skillLevel = tonumber(skillData[2])

		if skillID == tonumber(ID) then
			return skillLevel
		end
	end

	return 0
end

function Skillsystem.getWindowData(player, ID)
	ID = tonumber(ID)
	if not ID or not Skillsystem["Data"][ID] then return end

	local skillLevel = tonumber(getSkillLevel(client, ID)) or 0
	local cost = Skillsystem["Data"][ID][skillLevel + 1] or 0

	triggerClientEvent(client, "Skillsystem.updateWindowData", client, skillLevel, cost, #Skillsystem["Data"][ID])
end

addEvent("Skillsystem.getWindowData", true)
addEventHandler("Skillsystem.getWindowData", root, Skillsystem.getWindowData)

addEvent("Skillsystem.buyUpgrade", true)
addEventHandler("Skillsystem.buyUpgrade", root, function(ID)
	if ID then
		ID = tonumber(ID)
		if not ID or not Skillsystem["Data"][ID] then return end

		local skillLevel = tonumber(getSkillLevel(client, ID)) or 0
		local cost = Skillsystem["Data"][ID][skillLevel + 1] or 0
		local skillpoints = tonumber(getPlayerData("characters", "ID", getCharacterID(client), "skillpoints")) or 0

		if skillLevel < #Skillsystem["Data"][ID] then
			if skillpoints >= cost then
				increaseSkillLevel(client, ID)
				Skillsystem.getWindowData(client, ID)

				dbExec(handler, "UPDATE characters SET skillpoints = ? WHERE ID = ?", skillpoints - cost, getCharacterID(client))

				createInfobox(client, getText(client, "SSkillsystem2"))

				outputLog(
					"[SKILL] " .. getPlayerName(client) .. " (" .. ID .. ") hat ein neues Skillevel erreicht (Skill ID: " .. ID .. ", Level: " .. skillLevel + 1 .. ", Kosten: " .. cost .. " Skillpunkte)",
					"Skillsystem",
					getCharacterID(client)
				)

				if tonumber(ID) == 4 then
					local vehicle_slots = tonumber(getPlayerData("characters", "ID", getCharacterID(client), "vehicle_slots")) or 0
					dbExec(handler, "UPDATE characters SET vehicle_slots = ? WHERE ID = ?", vehicle_slots + 1, getCharacterID(client))
				end
			else
				createInfobox(client, getText(client, "SSkillsystem1"))
			end
		else
			createInfobox(client, getText(client, "SSkillsystem3"))
		end
	end
end)