SideQuests = {
	Peds = {},
	Marker = {},
	PlayerQuests = {},
	BlockedIDS = {},
	bindPos = {},
	["PossibleSpawns"] = {
		{675.06207275391,-448.63375854492,16.3359375,359.5817565918},
		{615.52124023438,-560.03405761719,23.08060836792,0.78353196382523},
		{704.07385253906,-613.37823486328,16.3359375,268.39764404297},
		{852.46838378906,-605.19696044922,18.421875,359.75262451172},
		{1054.1937255859,-346.01202392578,73.9921875,359.95297241211},
		{1112.8288574219,-311.5823059082,73.9921875,92.839485168457},
	},
	["PossibleQuests"] = {
		[1] = {
			questType = "Collectible",
			ID = 1,
		},
	},
}

function SideQuests.createQuestPeds()
	for PedID, pos in ipairs(SideQuests["PossibleSpawns"]) do
		if not SideQuests.BlockedIDS[PedID] and not isElement(SideQuests.Peds[PedID]) then
			local QuestID = math.random(1, #SideQuests["PossibleQuests"])

			local ped = createPed(0, pos[1], pos[2], pos[3], pos[4])
			SideQuests.Peds[PedID] = ped
			apocalypseSetElementData(ped, "SideQuests_PedID", PedID)
			apocalypseSetElementData(ped, "SideQuestID", QuestID)
			setPedAnimation(ped, "on_lookers", "wave_loop")

			local marker = createMarker(pos[1], pos[2], pos[3], "cylinder", 3, 255, 0, 0, 0)
			SideQuests.Marker[PedID] = marker
			apocalypseSetElementData(marker, "SideQuests_PedID", PedID)
			apocalypseSetElementData(marker, "SideQuestID", QuestID)

			local function onMarkerHit(player)
				if getElementType(player) ~= "player" or not isCharacterLoggedIn(player) then return end
				if isPedInVehicle(player) then return end
				if getElementDimension(player) ~= getElementDimension(source) then return end
				if getElementInterior(player) ~= getElementInterior(source) then return end

				if not apocalypseGetElementData(player, "SideQuestBind") then
					local x,y,z = getElementPosition(player)
					SideQuests.bindPos[player] = {x,y,z}
					bindKey(player, "e", "down", SideQuests.acceptQuest)
					apocalypseSetElementData(player, "SideQuestBind", true)
				end
				outputChatBox(getText(player, "SMiniSideQuests1"), player, 255, 255, 255)
			end
			SideQuests.Marker[PedID .. "_handler"] = onMarkerHit
			addEventHandler("onMarkerHit", marker, onMarkerHit)
		end
	end
end
SideQuests.createQuestPeds()
setTimer(SideQuests.createQuestPeds, 360000, 0)

function SideQuests.acceptQuest(player)
	local tbl = SideQuests.bindPos[player]
	if(getDistanceBetweenPoints3D(tbl[1],tbl[2],tbl[3],getElementPosition(player)) <= 5)then
		unbindKey(player, "e", "down", SideQuests.acceptQuest)
		apocalypseSetElementData(player, "SideQuestBind", false)

		local PedID = nil
		for _, marker in pairs(SideQuests.Marker) do
			if isElementWithinMarker(player, marker) then
				PedID = apocalypseGetElementData(marker, "SideQuests_PedID")
				break
			end
		end

		if PedID then
			local QuestID = apocalypseGetElementData(SideQuests.Marker[PedID], "SideQuestID")
			local questKey = tostring(PedID) .. "_" .. tostring(QuestID)

			if not SideQuests.PlayerQuests[player] then
				SideQuests.PlayerQuests[player] = {}
			end

			if SideQuests.PlayerQuests[player][questKey] then
				return
			end

			SideQuests.PlayerQuests[player][questKey] = true

			local questData = SideQuests["PossibleQuests"][QuestID]
			local x,y,z = getElementPosition(SideQuests.Peds[PedID])
			local rx,ry,rz = getElementRotation(SideQuests.Peds[PedID])
			triggerClientEvent(player, "SideQuests.createQuest", player, PedID, questData,x,y,z,rz)
			outputChatBox(getText(player,"SMiniSideQuests2"),player,255,255,255)
			SideQuests.BlockedIDS[PedID] = true

			destroyElement(SideQuests.Peds[PedID])
			destroyElement(SideQuests.Marker[PedID])
			SideQuests.Peds[PedID] = nil
			SideQuests.Marker[PedID] = nil
		end
	end
end

addEvent("SideQuests.resetID",true)
addEventHandler("SideQuests.resetID",root,function(PedID,QuestID)
	SideQuests.BlockedIDS[PedID] = nil
	local questKey = tostring(PedID) .. "_" .. tostring(QuestID)
	SideQuests.PlayerQuests[client][questKey] = nil
end)

addEvent("SideQuests.finished",true)
addEventHandler("SideQuests.finished",root,function()
	local Level_Bonus_EXP = tonumber(apocalypseGetElementData(client,"level"))
	if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
	local EXP = 500 + (Level_Bonus_EXP * 5)
	local Money = 250
	if(SERVERBONUS.SIDE_QUESTS == true)then
		EXP = EXP * 2
		Money = Money * 2
	end
	giveEXP(client,EXP)
	givePlayerServerMoney(client,Money)
end)

addEventHandler("onPlayerQuit",root,function()
	SideQuests.PlayerQuests[source] = nil
end)