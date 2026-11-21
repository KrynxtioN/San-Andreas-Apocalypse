RaceMinigame = {
	["MarkerPos"] = {
		[1] = {
			{2046.9425048828,1536.6884765625,10.671875},
			{2100.416015625,1530.6752929688,10.671875},
			{2136.1096191406,1480.6820068359,10.8203125},
			{2184.4331054688,1427.7645263672,10.8203125},
			{2228.3122558594,1427.5290527344,10.8203125},
			{2245.4230957031,1416.2369384766,10.671875},
			{2225.3588867188,1371.6096191406,10.84473323822},
			{2225.0637207031,1287.2799072266,10.671875},
		},
		[2] = {
			{2328.3154296875,1353.0386962891,7.2382092475891},
			{2424.5290527344,1353.2203369141,10.730695724487},
			{2537.5173339844,1372.9937744141,10.716639518738},
			{2627.1384277344,1338.7745361328,10.746398925781},
			{2688.6823730469,1313.1770019531,12.926328659058},
			{2797.2639160156,1313.4020996094,10.818221092224},
		},
		[3] = {
			{2828.3720703125,1429.0285644531,10.785259246826},
			{2779.3044433594,1529.2850341797,9.825343132019},
			{2728.9626464844,1764.8552246094,6.7949094772339},
			{2729.2373046875,1919.8272705078,6.8024587631226},
			{2770.109375,2042.7341308594,9.1866493225098},
			{2771.8896484375,2180.7053222656,9.317310333252},
			{2726.1645507812,2316.8588867188,6.7945756912231},
			{2665.4323730469,2477.4992675781,6.7948832511902},
			{2529.5017089844,2598.1926269531,4.9041767120361},
			{2323.3601074219,2629.8923339844,6.8045349121094},
			{2181.8063964844,2608.7138671875,6.8252120018005},
			{2054.5986328125,2624.2565917969,10.898306846619},
			{1933.9583740234,2646.3669433594,10.746004104614},
		},
		[4] = {
			{644.1669921875,-425.39993286133,16.252502441406},
			{535.31695556641,-413.05728149414,28.370685577393},
			{388.45672607422,-396.96719360352,25.882373809814},
			{227.88554382324,-356.27462768555,6.5030660629272},
			{210.85249328613,-288.64971923828,1.4842972755432},
		},
		[5] = {
			{935.55999755859,-527.88934326172,35.344215393066},
			{1104.0261230469,-438.51782226562,42.946491241455},
			{1245.7138671875,-419.33679199219,3.0008330345154},
			{1332.2562255859,-354.0065612793,3.0335423946381},
			{1476.7821044922,-315.99798583984,3.5095555782318},
			{1628.6916503906,-326.45709228516,22.049251556396},
			{1831.1645507812,-346.15353393555,44.157749176025},
			{1854.1134033203,-217.2481842041,41.065116882324},
			{1885.5520019531,-43.450439453125,34.927886962891},
			{1900.2767333984,105.61172485352,34.161724090576},
			{1873.9365234375,159.58682250977,33.995998382568},
		},
	},
}

RaceMinigame.RaceMarkers = {}
RaceMinigame.RaceBlips = {}
RaceMinigame.Timer = nil
RaceMinigame.CountdownTimer = nil
RaceMinigame.CurrentMarker = 1
RaceMinigame.TotalTime = 0
RaceMinigame.Distance = 0
RaceMinigame.TimeLeft = 0
RaceMinigame.showDX = false

addEvent("RaceMinigame.openWindow", true)
addEventHandler("RaceMinigame.openWindow", root, function()
	if(isWindowOpen())then
		GUIEditor.window[1] = guiCreateWindow(700, 463, 286, 130, getText("CRaceMinigame3"), false)
		setWindowData()
		guiCreateCloseButton()

		GUIEditor.label[1] = guiCreateLabel(10, 28, 266, 48, getText("CRaceMinigame4"), false, GUIEditor.window[1])
		guiSetFont(GUIEditor.label[1], "default-bold-small")
		guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", true)
		guiLabelSetVerticalAlign(GUIEditor.label[1], "center")

		GUIEditor.button[1] = guiCreateButton(10, 86, 266, 34, getText("CRaceMinigame5"), false, GUIEditor.window[1])

		addEventHandler("onClientGUIClick", GUIEditor.button[1], function()
			local ID = apocalypseGetElementData(localPlayer, "RaceMinigameID")
			if ID then
				triggerServerEvent("RaceMinigame.start", localPlayer)
			end
		end, false)
	end
end)

function RaceMinigame.startRace(ID)
	local positions = RaceMinigame.MarkerPos[ID]
	if not positions then return end
	RaceMinigame.CurrentMarker = 1

	for i,v in ipairs(RaceMinigame.RaceMarkers) do if isElement(v) then destroyElement(v) end end
	for i,v in ipairs(RaceMinigame.RaceBlips) do if isElement(v) then destroyElement(v) end end
	RaceMinigame.RaceMarkers = {}
	RaceMinigame.RaceBlips = {}

	local startPos = positions[1]
	local endPos = positions[#positions]
	local dist = getDistanceBetweenPoints3D(startPos[1], startPos[2], startPos[3], endPos[1], endPos[2], endPos[3])
	RaceMinigame.Distance = dist

	RaceMinigame.TotalTime = dist * 0.075
	RaceMinigame.TimeLeft = RaceMinigame.TotalTime
	RaceMinigame.showDX = true

	if isTimer(RaceMinigame.Timer) then killTimer(RaceMinigame.Timer) end
	RaceMinigame.Timer = setTimer(function()
		RaceMinigame.endRace(false)
	end, RaceMinigame.TotalTime*1000, 1)

	if isTimer(RaceMinigame.CountdownTimer) then killTimer(RaceMinigame.CountdownTimer) end
	RaceMinigame.CountdownTimer = setTimer(function()
		RaceMinigame.TimeLeft = RaceMinigame.TimeLeft - 0.025
	end, 25, math.floor(RaceMinigame.TotalTime/0.025))

	RaceMinigame.createNextMarkers(ID)

	addEventHandler("onClientRender", root, RaceMinigame.drawRaceTimer)
end

addEvent("RaceMinigame.startRace", true)
addEventHandler("RaceMinigame.startRace", root, RaceMinigame.startRace)

function RaceMinigame.drawRaceTimer()
	if not RaceMinigame.showDX then return end
	Levelsystem.Visible = false
	local timeLeft = math.max(0, RaceMinigame.TimeLeft)
	local minutes = math.floor(timeLeft / 60)
	local seconds = timeLeft % 60
	local timeText = string.format("%02d:%05.2f", minutes, seconds)
	local sw, sh = guiGetScreenSize()
	dxDrawText(getText("CRaceMinigame6").." "..timeText, 0, 20, sw, 20, tocolor(255,255,255,255), 2, "default-bold", "center", "top")
end

function RaceMinigame.createNextMarkers(ID)
	local positions = RaceMinigame.MarkerPos[ID]
	local current = RaceMinigame.CurrentMarker

	for i,v in ipairs(RaceMinigame.RaceMarkers) do if isElement(v) then destroyElement(v) end end
	for i,v in ipairs(RaceMinigame.RaceBlips) do if isElement(v) then destroyElement(v) end end
	RaceMinigame.RaceMarkers = {}
	RaceMinigame.RaceBlips = {}

	if positions[current] then
		local x, y, z = positions[current][1], positions[current][2], positions[current][3]
		local m = createMarker(x, y, z, "checkpoint", 3, 255,0,0,255)
		local b = createBlip(x, y, z, 0, 2, 255,0,0,255, 0, 9999)
		RaceMinigame.RaceMarkers[1] = m
		RaceMinigame.RaceBlips[1] = b

		addEventHandler("onClientMarkerHit", m, function(hitPlayer)
			if hitPlayer ~= localPlayer then return end
			if RaceMinigame.CurrentMarker == current then
				RaceMinigame.CurrentMarker = RaceMinigame.CurrentMarker + 1
				if not positions[RaceMinigame.CurrentMarker] then
					RaceMinigame.endRace(true)
				else
					RaceMinigame.createNextMarkers(ID)
				end
			end
		end)
	end

	if positions[current+1] then
		local x2, y2, z2 = positions[current+1][1], positions[current+1][2], positions[current+1][3]
		local m2 = createMarker(x2, y2, z2, "checkpoint", 3, 255,0,0,100)
		local b2 = createBlip(x2, y2, z2, 0, 2, 255,0,0,100, 0, 9999)
		RaceMinigame.RaceMarkers[2] = m2
		RaceMinigame.RaceBlips[2] = b2
	end
end

function RaceMinigame.endRace(success)
	if(RaceMinigame.showDX == true)then
		for i,v in ipairs(RaceMinigame.RaceMarkers) do if isElement(v) then destroyElement(v) end end
		for i,v in ipairs(RaceMinigame.RaceBlips) do if isElement(v) then destroyElement(v) end end
		RaceMinigame.RaceMarkers = {}
		RaceMinigame.RaceBlips = {}
		RaceMinigame.CurrentMarker = 1

		if isTimer(RaceMinigame.Timer) then killTimer(RaceMinigame.Timer) end
		RaceMinigame.Timer = nil
		if isTimer(RaceMinigame.CountdownTimer) then killTimer(RaceMinigame.CountdownTimer) end
		RaceMinigame.CountdownTimer = nil
		RaceMinigame.showDX = false
		removeEventHandler("onClientRender",root,RaceMinigame.drawRaceTimer)
		Levelsystem.Visible = true

		if success then
			createInfobox(getText("CRaceMinigame1"))
			triggerServerEvent("RaceMinigame.reward",localPlayer)
		else
			createInfobox(getText("CRaceMinigame2"))
		end
	end
end

addEventHandler("onClientPlayerWasted", localPlayer, function()
	RaceMinigame.endRace(false)
end)