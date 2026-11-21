ZombieExperiments = {
	Peds = {},
	Marker = {},
	UpdateTimer = nil,
	InfoTimer = nil,
	CurrentZombies = {},
	GridRowsByZombieID = {},
	playerZombieID = nil,
	CurrentInfoZombieID = nil,
	CurrentInfoState = "idle",
	CurrentInfoSeconds = 0,
	CurrentInfoColonyEXP = 0,

	["BuyableZombiePeds"] = {
		[1] = {0, 1769.4107666016, -1578.1292724609, 0.77881269454956, 244},
		[2] = {0, 1773.3895263672, -1578.1292724609, 0.77881269454956, 244},
		[3] = {0,1777.4136962891,-1578.1292724609,0.47881269454956, 244},
		[4] = {0,1781.4603271484,-1578.1292724609,0.47881269454956, 244},
		[5] = {0,1785.2827148438,-1578.1292724609,0.47881269454956, 244},
		[6] = {0,1789.3481445312,-1578.1292724609,0.47881269454956, 244},
		[7] = {0,1793.2546386719,-1578.1292724609,0.47881269454956, 244},
		[8] = {0,1797.4178466797,-1578.1292724609,0.47881269454956, 244},
		[9] = {0,1800.560546875,-1574.0104980469,0.47881269454956, 270},
		[10] = {0,1800.560546875,-1569.8963623047,0.47881269454956, 270},
		[11] = {0,1800.4780273438,-1565.9104003906,0.47881269454956, 270},
		[12] = {0,1800.5670166016,-1561.953125,0.47881269454956, 270},
		[13] = {0,1800.7333984375,-1557.9356689453,0.47881269454956, 270},
		[14] = {0,1797.5056152344,-1554.7243652344,0.47881269454956,360},
		[15] = {0,1793.8328857422,-1554.7243652344,0.47881269454956,360},
		[16] = {0,1789.6513671875,-1554.7243652344,0.47881269454956,360},
		[17] = {0,1785.7091064453,-1554.7243652344,0.47881269454956,360},
		[18] = {0,1781.8151855469,-1554.7243652344,0.47881269454956,360},
		[19] = {0,1777.8669433594,-1554.7243652344,0.47881269454956,360},
		[20] = {0,1773.6624755859,-1554.7243652344,0.47881269454956,360},
	},

	["BuyableZombieMarker"] = {
		[1] = {1767.7940673828, -1575.6136474609, 0.47556549310684},
		[2] = {1771.7468261719, -1575.6163330078, 0.47556549310684},
		[3] = {1775.7687988281,-1575.6158447266,0.47556549310684},
		[4] = {1779.7868652344,-1575.6151123047,0.47556549310684},
		[5] = {1783.7601318359,-1575.6149902344,0.47556549310684},
		[6] = {1787.7423095703,-1575.6141357422,0.47556549310684},
		[7] = {1791.7501220703,-1575.6143798828,0.47556549310684},
		[8] = {1795.7615966797,-1575.6151123047,0.47556549310684},
		[9] = {1799.0372314453,-1575.6156005859,0.47881269454956},
		[10] = {1799.0378417969,-1571.5808105469,0.47881269454956},
		[11] = {1799.0384521484,-1567.6456298828,0.47881269454956},
		[12] = {1799.0379638672,-1563.5981445312,0.47881269454956},
		[13] = {1799.0383300781,-1559.6091308594,0.47881269454956},
		[14] = {1799.0321044922,-1556.3193359375,0.47881269454956},
		[15] = {1795.2694091797,-1556.3187255859,0.47556549310684},
		[16] = {1791.3374023438,-1556.3201904297,0.47556549310684},
		[17] = {1787.3704833984,-1556.3187255859,0.47556549310684},
		[18] = {1783.3255615234,-1556.3204345703,0.47556549310684},
		[19] = {1779.3221435547,-1556.3195800781,0.47556549310684},
		[20] = {1775.3685302734,-1556.3247070312,0.47556549310684},
	},

	["Costs"] = {
		[1] = 5000,
		[2] = 10000,
		[3] = 25000,
		[4] = 50000,
		[5] = 75000,
		[6] = 100000,
		[7] = 125000,
		[8] = 150000,
		[9] = 175000,
		[10] = 200000,
		[11] = 225000,
		[12] = 250000,
		[13] = 275000,
		[14] = 300000,
		[15] = 325000,
		[16] = 350000,
		[17] = 375000,
		[18] = 400000,
		[19] = 425000,
		[20] = 450000,
	},

	["Names"] = {
		["EN"] = {
			[1] = "Zombie #1",
			[2] = "Zombie #2",
			[3] = "Zombie #3",
			[4] = "Zombie #4",
			[5] = "Zombie #5",
			[6] = "Zombie #6",
			[7] = "Zombie #7",
			[8] = "Zombie #8",
			[9] = "Zombie #9",
			[10] = "Zombie #10",
			[11] = "Zombie #11",
			[12] = "Zombie #12",
			[13] = "Zombie #13",
			[14] = "Zombie #14",
			[15] = "Zombie #15",
			[16] = "Zombie #16",
			[17] = "Zombie #17",
			[18] = "Zombie #18",
			[19] = "Zombie #19",
			[20] = "Zombie #20",
		},
	},
}

local EXPERIMENT_DURATION = 21600

local function formatSeconds(seconds)
	seconds = math.max(0, tonumber(seconds) or 0)
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor((seconds % 3600) / 60)
	local secs = math.floor(seconds % 60)
	return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

function ZombieExperiments.stopUpdateTimer()
	if isTimer(ZombieExperiments.UpdateTimer) then
		killTimer(ZombieExperiments.UpdateTimer)
	end
	ZombieExperiments.UpdateTimer = nil
end

function ZombieExperiments.stopInfoTimer()
	if isTimer(ZombieExperiments.InfoTimer) then
		killTimer(ZombieExperiments.InfoTimer)
	end
	ZombieExperiments.InfoTimer = nil
end

function ZombieExperiments.isListWindowOpen()
	return isElement(GUIEditor.window[1]) and isElement(GUIEditor.gridlist[1])
end

function ZombieExperiments.getZombieStatusText(zombie)
	local rewardTimer = tonumber(zombie.reward_timer) or 0

	if rewardTimer <= 0 then
		return getText("CZombieExperiments16")
	end

	local currentTime = getRealTime().timestamp
	local timePassed = currentTime - rewardTimer

	if timePassed < EXPERIMENT_DURATION then
		local secondsLeft = EXPERIMENT_DURATION - timePassed
		return formatSeconds(secondsLeft)
	end

	return getText("CZombieExperiments20")
end

function ZombieExperiments.buildZombieGrid()
	if not ZombieExperiments.isListWindowOpen() then
		return
	end

	guiGridListClear(GUIEditor.gridlist[1])
	ZombieExperiments.GridRowsByZombieID = {}

	for _, zombie in ipairs(ZombieExperiments.CurrentZombies) do
		local zombieID = tonumber(zombie.zombie_id) or 0
		local level = tonumber(zombie.level) or 0

		local row = guiGridListAddRow(GUIEditor.gridlist[1])
		ZombieExperiments.GridRowsByZombieID[zombieID] = row

		guiGridListSetItemText(GUIEditor.gridlist[1], row, 1, tostring(zombieID), false, false)
		guiGridListSetItemText(GUIEditor.gridlist[1], row, 2, ZombieExperiments.getZombieStatusText(zombie), false, false)
		guiGridListSetItemText(GUIEditor.gridlist[1], row, 3, tostring(level).."/10", false, false)
		guiGridListSetItemData(GUIEditor.gridlist[1], row, 1, zombieID)
		guiGridListSetItemData(GUIEditor.gridlist[1], row, 3, level)
	end
end

function ZombieExperiments.refreshZombieGrid()
	if not ZombieExperiments.isListWindowOpen() then
		ZombieExperiments.stopUpdateTimer()
		return
	end

	local selectedRow = guiGridListGetSelectedItem(GUIEditor.gridlist[1])
	local selectedZombieID = nil

	if selectedRow and selectedRow ~= -1 then
		selectedZombieID = guiGridListGetItemData(GUIEditor.gridlist[1], selectedRow, 1)
	end

	for _, zombie in ipairs(ZombieExperiments.CurrentZombies) do
		local zombieID = tonumber(zombie.zombie_id) or 0
		local level = tonumber(zombie.level) or 0
		local row = ZombieExperiments.GridRowsByZombieID[zombieID]

		if row ~= nil then
			guiGridListSetItemText(GUIEditor.gridlist[1], row, 2, ZombieExperiments.getZombieStatusText(zombie), false, false)
			guiGridListSetItemText(GUIEditor.gridlist[1], row, 3, tostring(level).."/10", false, false)
		end
	end

	if selectedZombieID then
		local row = ZombieExperiments.GridRowsByZombieID[selectedZombieID]
		if row ~= nil then
			guiGridListSetSelectedItem(GUIEditor.gridlist[1], row, 1)
		end
	end
end

function ZombieExperiments.startGridAutoUpdate()
	ZombieExperiments.stopUpdateTimer()
	ZombieExperiments.UpdateTimer = setTimer(function()
		ZombieExperiments.refreshZombieGrid()
	end, 1000, 0)
end

function ZombieExperiments.openZombieList(zombies)
	ZombieExperiments.CurrentZombies = zombies or {}

	if isElement(GUIEditor.window[1]) then
		destroyElement(GUIEditor.window[1])
	end

	GUIEditor.window[1] = guiCreateWindow(634, 335, 548, 343, getText("CZombieExperiments11"), false)
	setWindowData()
	guiCreateCloseButton()

	GUIEditor.label[1] = guiCreateLabel(20, 22, 511, 55, getText("CZombieExperiments10"), false, GUIEditor.window[1])
	guiSetFont(GUIEditor.label[1], "default-bold-small")
	guiLabelSetHorizontalAlign(GUIEditor.label[1], "left", true)
	guiLabelSetVerticalAlign(GUIEditor.label[1], "center")

	GUIEditor.gridlist[1] = guiCreateGridList(10, 87, 528, 213, false, GUIEditor.window[1])
	guiGridListAddColumn(GUIEditor.gridlist[1], getText("CZombieExperiments12"), 0.3)
	guiGridListAddColumn(GUIEditor.gridlist[1], getText("CZombieExperiments13"), 0.3)
	guiGridListAddColumn(GUIEditor.gridlist[1], getText("CZombieExperiments14"), 0.3)

	GUIEditor.button[1] = guiCreateButton(10, 310, 528, 23, getText("CZombieExperiments22"), false, GUIEditor.window[1])

	ZombieExperiments.buildZombieGrid()
	ZombieExperiments.startGridAutoUpdate()

	addEventHandler("onClientGUIClick", GUIEditor.button[1], function()
		local row = guiGridListGetSelectedItem(GUIEditor.gridlist[1])
		if row and row ~= -1 then
			local zombieID = guiGridListGetItemData(GUIEditor.gridlist[1], row, 1)
			local zombieLevel = guiGridListGetItemData(GUIEditor.gridlist[1], row, 3)
			if zombieID then
				triggerServerEvent("ZombieExperiments.updateLevel", localPlayer, zombieID)
				guiSetText(GUIEditor.button[1],getText("CZombieExperiments15"):format(50 * (zombieLevel + 1)))
			end
		else
			createInfobox(getText("CZombieExperiments17"), 255, 0, 0)
		end
	end, false)
	
	addEventHandler("onClientGUIClick", GUIEditor.gridlist[1], function()
		local row = guiGridListGetSelectedItem(GUIEditor.gridlist[1])
		if row and row ~= -1 then
			local zombieID = guiGridListGetItemData(GUIEditor.gridlist[1], row, 1)
			local zombieLevel = guiGridListGetItemData(GUIEditor.gridlist[1], row, 3)
			if zombieID then
				guiSetText(GUIEditor.button[1],getText("CZombieExperiments15"):format(50 * (zombieLevel + 1)))
			end
		end
	end, false)
end

addEvent("ZombieExperiments.receiveColonyZombies", true)
addEventHandler("ZombieExperiments.receiveColonyZombies", root, function(zombies)
	ZombieExperiments.openZombieList(zombies)
end)

addEvent("ZombieExperiments.buyWindow", true)
addEventHandler("ZombieExperiments.buyWindow", root, function(zombieID)
	if isWindowOpen() then
		ZombieExperiments.stopInfoTimer()

		GUIEditor.window[1] = guiCreateWindow(555, 368, 318, 113, getText("CZombieExperiments1"):format(zombieID), false)
		setWindowData()
		guiCreateCloseButton()

		ZombieExperiments.playerZombieID = zombieID

		GUIEditor.button[1] = guiCreateButton(10, 85, 299, 18, getText("CZombieExperiments2"):format(ZombieExperiments["Costs"][zombieID]), false, GUIEditor.window[1])
		GUIEditor.label[1] = guiCreateLabel(10, 29, 298, 46, getText("CZombieExperiments3"), false, GUIEditor.window[1])
		guiSetFont(GUIEditor.label[1], "default-bold-small")
		guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", true)
		guiLabelSetVerticalAlign(GUIEditor.label[1], "center")

		addEventHandler("onClientGUIClick", GUIEditor.button[1], function()
			triggerServerEvent("ZombieExperiments.buyZombie", localPlayer, ZombieExperiments.playerZombieID, ZombieExperiments["Costs"][zombieID])
		end, false)
	end
end)

function ZombieExperiments.updateInfoWindow()
	if not isElement(GUIEditor.window[1]) or not isElement(GUIEditor.label[2]) or not isElement(GUIEditor.button[1]) then
		ZombieExperiments.stopInfoTimer()
		return
	end

	if ZombieExperiments.CurrentInfoState == "running" then
		guiSetText(GUIEditor.label[1], getText("CZombieExperiments9"))
		guiSetText(GUIEditor.label[2], getText("CZombieExperiments8"):format(formatSeconds(ZombieExperiments.CurrentInfoSeconds)))
		guiSetText(GUIEditor.button[1], getText("CZombieExperiments7"))

		if ZombieExperiments.CurrentInfoSeconds > 0 then
			ZombieExperiments.CurrentInfoSeconds = ZombieExperiments.CurrentInfoSeconds - 1
		else
			ZombieExperiments.CurrentInfoState = "claimable"
			guiSetText(GUIEditor.label[1], getText("CZombieExperiments18"))
			guiSetText(GUIEditor.label[2], getText("CZombieExperiments19"):format(ZombieExperiments.CurrentInfoColonyEXP))
			guiSetText(GUIEditor.button[1], getText("CZombieExperiments7"))
		end
	elseif ZombieExperiments.CurrentInfoState == "claimable" then
		guiSetText(GUIEditor.label[1], getText("CZombieExperiments18"))
		guiSetText(GUIEditor.label[2], getText("CZombieExperiments19"):format(ZombieExperiments.CurrentInfoColonyEXP))
		guiSetText(GUIEditor.button[1], getText("CZombieExperiments7"))
	else
		guiSetText(GUIEditor.label[1], getText("CZombieExperiments4"))
		guiSetText(GUIEditor.label[2], getText("CZombieExperiments5"))
		guiSetText(GUIEditor.button[1], getText("CZombieExperiments6"))
	end
end

addEvent("ZombieExperiments.infoWindow", true)
addEventHandler("ZombieExperiments.infoWindow", root, function(zombieID, experimentState, secondsRemaining, colonyEXP)
	if(isElement(GUIEditor.window[1]))then destroyElement(GUIEditor.window[1])end
	ZombieExperiments.stopInfoTimer()

	GUIEditor.window[1] = guiCreateWindow(750, 368, 406, 154, getText("CZombieExperiments1"):format(zombieID), false)
	setWindowData()
	guiCreateCloseButton()

	ZombieExperiments.playerZombieID = zombieID
	ZombieExperiments.CurrentInfoZombieID = zombieID
	ZombieExperiments.CurrentInfoState = tostring(experimentState or "idle")
	ZombieExperiments.CurrentInfoSeconds = tonumber(secondsRemaining) or 0
	ZombieExperiments.CurrentInfoColonyEXP = tonumber(colonyEXP) or 0

	GUIEditor.label[1] = guiCreateLabel(11, 29, 387, 31, "", false, GUIEditor.window[1])
	guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", false)
	guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
	guiSetFont(GUIEditor.label[1], "default-bold-small")

	GUIEditor.label[2] = guiCreateLabel(11, 70, 386, 38, "", false, GUIEditor.window[1])
	guiSetFont(GUIEditor.label[2], "default-bold-small")
	guiLabelSetHorizontalAlign(GUIEditor.label[2], "left", true)
	guiLabelSetVerticalAlign(GUIEditor.label[2], "center")

	GUIEditor.button[1] = guiCreateButton(10, 118, 387, 26, "", false, GUIEditor.window[1])

	ZombieExperiments.updateInfoWindow()

	addEventHandler("onClientGUIClick", GUIEditor.button[1], function()
		if ZombieExperiments.CurrentInfoState == "running" or ZombieExperiments.CurrentInfoState == "claimable" then
			triggerServerEvent("ZombieExperiments.getZombieRewards", localPlayer, ZombieExperiments.playerZombieID)
		else
			triggerServerEvent("ZombieExperiments.startExperiment", localPlayer, ZombieExperiments.playerZombieID)
		end
	end, false)

	if ZombieExperiments.CurrentInfoState == "running" then
		ZombieExperiments.InfoTimer = setTimer(function()
			ZombieExperiments.updateInfoWindow()
		end, 1000, 0)
	end
end)

for i, v in ipairs(ZombieExperiments["BuyableZombiePeds"]) do
	ZombieExperiments.Peds[i] = createPed(zombies["Skins"][math.random(1, #zombies["Skins"])], v[2], v[3], v[4], v[5])
	apocalypseSetElementData(ZombieExperiments.Peds[i], "ZombieExperimentID", i)
end

for i, v in ipairs(ZombieExperiments["BuyableZombieMarker"]) do
	ZombieExperiments.Marker[i] = createPickup(v[1], v[2], v[3], 3, 1239, 50)
	apocalypseSetElementData(ZombieExperiments.Marker[i], "ZombieExperimentID", i)

	addEventHandler("onClientPickupHit", ZombieExperiments.Marker[i], function(player)
		if player == localPlayer then
			local id = apocalypseGetElementData(source, "ZombieExperimentID")
			triggerServerEvent("ZombieExperiments.getZombieData", localPlayer, localPlayer, id)
		end
	end)
end

addEventHandler("onClientRender", root, function()
	for _, ped in pairs(ZombieExperiments.Peds) do
		if isElement(ped) then
			local rx, ry, rz = getElementRotation(ped)
			setElementRotation(ped, rx, ry, rz + 1)
		end
	end

	local cx, cy, cz = getCameraMatrix()

	if(isWindowOpen())then
		for i, pickup in pairs(ZombieExperiments.Marker) do
			if isElement(pickup) then
				if getElementDimension(localPlayer) == getElementDimension(pickup) and getElementInterior(localPlayer) == getElementInterior(pickup) then
					local px, py, pz = getElementPosition(pickup)
					local dist = getDistanceBetweenPoints3D(cx, cy, cz, px, py, pz)

					if dist <= 7.5 then
						local sx, sy = getScreenFromWorldPosition(px, py, pz + 0.6)
						if sx and sy then
							local zombieID = apocalypseGetElementData(pickup, "ZombieExperimentID") or i
							local text = ZombieExperiments["Names"][apocalypseGetElementData(localPlayer,"language") or "EN"][zombieID] or ("Zombie " .. tostring(zombieID))

							dxDrawText(
								text,
								sx - 100, sy - 20, sx + 100, sy + 20,
								tocolor(255, 255, 255, 255),
								1.2,
								"default-bold",
								"center",
								"center",
								false,
								false,
								false,
								true
							)
						end
					end
				end
			end
		end
		
		if not (isCharacterLoggedIn() and isWindowOpen()) then return end

		local x1, y1, z1 = 1766.5994873047, -1578.7486572266, 0.49058693647385
		local screenX1, screenY1 = getScreenFromWorldPosition(x1, y1, z1 + 0.6)

		if screenX1 and screenY1 and getDistanceBetweenPoints3D(x1, y1, z1, getElementPosition(localPlayer)) <= 7.5 then
			dxDrawText(getText("CZombieExperiments21"),
				screenX1 - 100, screenY1 - 20, screenX1 + 100, screenY1 + 20,
				tocolor(255,255,255), 1.2, "default-bold", "center", "center")
		end
	end
end)