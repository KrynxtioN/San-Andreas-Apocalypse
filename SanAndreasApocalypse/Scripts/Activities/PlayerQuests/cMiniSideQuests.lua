SideQuests = { Peds = {}, Collectibles = {}, UsedCollectiblePositions = {} }
apocalypseSetElementData(localPlayer, "SideQuestBind", false)

addEvent("SideQuests.createQuest", true)
addEventHandler("SideQuests.createQuest", root, function(PedID, questData, x, y, z, rz)
    PedID = tonumber(PedID)
    local questType = questData.questType

    if isElement(SideQuests.Peds[PedID]) then
        destroyElement(SideQuests.Peds[PedID])
    end

    SideQuests.Peds[PedID] = createPed(0, x, y, z, rz)

    if isElement(SideQuests.Peds[PedID .. "_marker"]) then
        destroyElement(SideQuests.Peds[PedID .. "_marker"])
    end

    SideQuests.Peds[PedID .. "_marker"] = createMarker(x, y, z, "cylinder", 3, 255, 0, 0, 0)

	addEventHandler("onClientMarkerHit", SideQuests.Peds[PedID .. "_marker"], function(hitElement)
		if hitElement == localPlayer then
			if apocalypseGetElementData(localPlayer, "SideQuest_" .. PedID .. "_done") then
				outputChatBox(getText("CMiniSideQuests2"),255,255,255)

				if isElement(SideQuests.Peds[PedID]) then
					destroyElement(SideQuests.Peds[PedID])
					SideQuests.Peds[PedID] = nil
				end
				if isElement(SideQuests.Peds[PedID .. "_marker"]) then
					destroyElement(SideQuests.Peds[PedID .. "_marker"])
					SideQuests.Peds[PedID .. "_marker"] = nil
				end

				for i, pos in ipairs(SideQuests.UsedCollectiblePositions) do
					if pos[1] == x and pos[2] == y and pos[3] == z then
						table.remove(SideQuests.UsedCollectiblePositions, i)
						break
					end
				end

				apocalypseSetElementData(localPlayer, "SideQuest_" .. PedID .. "_done", false)
				triggerServerEvent("SideQuests.resetID",localPlayer,PedID,questData.ID)
				triggerServerEvent("SideQuests.finished",localPlayer)
			else
				outputChatBox(getText("CMiniSideQuests1"),255,255,255)
			end
		end
	end)

    if questType == "Collectible" then
		local possibleCollectiblePositions = {
			{1251.7141113281,152.38969421387,19.589576721191},
			{1636.9764404297,296.06076049805,21.0859375},
			{1874.3402099609,-77.546600341797,34.8515625},
			{1694.8332519531,-536.63049316406,35.075260162354},
			{1354.6279296875,-877.91333007812,39.140850067139},
			{985.15258789062,-1044.9688720703,30.543956756592},
		}

		local availablePositions = {}
		for _, posC in ipairs(possibleCollectiblePositions) do
			local taken = false
			for _, usedPos in ipairs(SideQuests.UsedCollectiblePositions) do
				if posC[1] == usedPos[1] and posC[2] == usedPos[2] and posC[3] == usedPos[3] then
					taken = true
					break
				end
			end
			if not taken then
				table.insert(availablePositions, posC)
			end
		end

		if #availablePositions == 0 then
			--outputChatBox("Keine freien Sammelorte mehr verfügbar!")
			return
		end

		local chosenPos = availablePositions[math.random(1, #availablePositions)]
		table.insert(SideQuests.UsedCollectiblePositions, chosenPos)

		local collectible = createPickup(chosenPos[1], chosenPos[2], chosenPos[3], 3, 1274)
		table.insert(SideQuests.Collectibles, collectible)

		local blip = createBlip(chosenPos[1], chosenPos[2], chosenPos[3], 53, 2, 255, 0, 0, 255, 0)

		addEventHandler("onClientPickupHit", collectible, function(hitElement)
			if hitElement == localPlayer then
				if isElement(collectible) then
					destroyElement(collectible)
				end
				if isElement(blip) then
					destroyElement(blip)
				end

				apocalypseSetElementData(localPlayer, "SideQuest_" .. PedID .. "_done", true)

				for i, pos in ipairs(SideQuests.UsedCollectiblePositions) do
					if pos[1] == chosenPos[1] and pos[2] == chosenPos[2] and pos[3] == chosenPos[3] then
						table.remove(SideQuests.UsedCollectiblePositions, i)
						break
					end
				end
			end
		end)
	end
end)