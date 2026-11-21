MissionTerminal = {
	visible = false,
	tab = "standard",
	selected = 1,
	detailScroll = 0,
	scroll = {
		standard = 0,
		series = 0,
		colony = 0,
	},
	data = {
		level = 0,
		standard = {},
		series = {},
		colony = {},
	}
}

local sx, sy = guiGetScreenSize()

local W, H = 960, 620
local X, Y = (sx - W) / 2, (sy - H) / 2

local serverColor = tocolor(220, 25, 25, 255)

local TerminalPickup = createPickup(503.31292724609,-75.394165039062,998.76507568359,3,1239,50)
setElementInterior(TerminalPickup,11)

addEventHandler("onClientRender",root,function()
	if(isCharacterLoggedIn() and isWindowOpen())then
		local x1,y1,z1 = getElementPosition(TerminalPickup)
		local screenX1,screenY1 = getScreenFromWorldPosition(x1,y1,z1)
		
		if(screenX1 and screenY1)then
			if(tonumber(apocalypseGetElementData(localPlayer,"level")))then
				if(getDistanceBetweenPoints3D(x1,y1,z1,getElementPosition(localPlayer)) <= 5)then
					dxDrawText(getText("MissionTerminalText"), screenX1 - 100, screenY1 - 20, screenX1 + 100, screenY1 + 20, tocolor(255, 255, 255), 1.2, "default-bold", "center", "center")
				end
			end
		end
	end
end)

addEventHandler("onClientPickupHit",TerminalPickup,function(player)
	if(player == localPlayer)then
		if(getElementDimension(player) == getElementDimension(source))then
			triggerServerEvent("MissionTerminal.openWindow",localPlayer)
		end
	end
end)

local c = {
	bg = tocolor(8, 8, 8, 245),
	header = tocolor(14, 14, 14, 250),
	box = tocolor(20, 20, 20, 245),
	box2 = tocolor(34, 34, 34, 245),
	box3 = tocolor(45, 45, 45, 245),
	line = tocolor(80, 80, 80, 180),
	text = tocolor(240, 240, 240, 255),
	muted = tocolor(175, 175, 175, 255),
	red = serverColor,
	green = tocolor(70, 190, 90, 255),
	yellow = tocolor(220, 170, 50, 255),
	disabled = tocolor(75, 75, 75, 220),
	button = tocolor(42, 42, 42, 245),
	buttonHover = tocolor(58, 58, 58, 245),
}

local function cursorIn(x, y, w, h)
	if not isCursorShowing() then return false end
	local cx, cy = getCursorPosition()
	cx, cy = cx * sx, cy * sy
	return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end

local function getList()
	return MissionTerminal.data[MissionTerminal.tab] or {}
end

local function getSelectedQuest()
	return getList()[MissionTerminal.selected]
end

local function setTab(tab)
	MissionTerminal.tab = tab
	MissionTerminal.selected = 1
	MissionTerminal.detailScroll = 0
end

local function tabName(tab)
	if tab == "standard" then return getText("MT_STANDARD") end
	if tab == "series" then return getText("MT_SERIES") end
	if tab == "colony" then return getText("MT_COLONY") end
	return tab
end

local function actionText()
	if MissionTerminal.tab == "standard" then return getText("MT_BUY_QUEST") end
	if MissionTerminal.tab == "series" then return getText("MT_CLAIM_SERIES") end
	if MissionTerminal.tab == "colony" then return getText("MT_START_MISSION") end
	return getText("MT_START_MISSION")
end

local function canUse(q)
	if not q then return false end
	if q.hasQuest then return false end
	if tonumber(MissionTerminal.data.level or 0) < tonumber(q.minLevel or 0) then return false end
	return true
end

local function drawBorder(x, y, w, h, color)
	dxDrawRectangle(x, y, w, 1, color)
	dxDrawRectangle(x, y + h - 1, w, 1, color)
	dxDrawRectangle(x, y, 1, h, color)
	dxDrawRectangle(x + w - 1, y, 1, h, color)
end

local function drawButton(x, y, w, h, text, enabled)
	local bg = enabled and c.button or c.disabled

	if enabled and cursorIn(x, y, w, h) then
		bg = c.buttonHover
	end

	dxDrawRectangle(x, y, w, h, bg)
	dxDrawRectangle(x, y, 4, h, enabled and c.red or c.line)
	dxDrawText(text, x, y, x + w, y + h, c.text, 1.05, "default-bold", "center", "center")
end

local function drawTab(x, y, w, h, tab)
	local active = MissionTerminal.tab == tab

	dxDrawRectangle(x, y, w, h, active and c.box3 or c.box2)

	if active then
		dxDrawRectangle(x, y + h - 3, w, 3, c.red)
	end

	dxDrawText(tabName(tab), x, y, x + w, y + h, c.text, 1.05, "default-bold", "center", "center")
end

local function getStatus(q)
	if not q then return "", c.muted end

	if q.hasQuest then
		return getText("MT_ACCEPTED"), c.yellow
	end

	if tonumber(MissionTerminal.data.level or 0) < tonumber(q.minLevel or 0) then
		return getText("MT_LEVEL_STATUS"):format(q.minLevel), c.muted
	end

	return getText("MT_AVAILABLE"), c.green
end

local function splitLines(text)
	local lines = {}
	text = tostring(text or "")

	for line in string.gmatch(text .. "\n", "(.-)\n") do
		table.insert(lines, line)
	end

	return lines
end

local function wrapLine(line, maxWidth, scale, font)
	local wrapped = {}

	if line == "" then
		table.insert(wrapped, "")
		return wrapped
	end

	local current = ""

	for word in string.gmatch(line, "%S+") do
		local test = current == "" and word or current .. " " .. word

		if dxGetTextWidth(test, scale, font) <= maxWidth then
			current = test
		else
			if current ~= "" then
				table.insert(wrapped, current)
			end
			current = word
		end
	end

	if current ~= "" then
		table.insert(wrapped, current)
	end

	return wrapped
end

local function addWrapped(lines, text, color, scale, font, maxWidth)
	for _, rawLine in ipairs(splitLines(text)) do
		local wrapped = wrapLine(rawLine, maxWidth, scale, font)

		for _, line in ipairs(wrapped) do
			table.insert(lines, {
				text = line,
				color = color,
				scale = scale,
				font = font,
			})
		end
	end
end

local function buildDetailLines(q)
	local lines = {}
	if not q then return lines end

	local maxWidth = 430

	local detailTitle
	if MissionTerminal.tab == "colony" then
		detailTitle = tostring(q.name)
	else
		detailTitle = "#" .. tostring(q.id) .. " " .. tostring(q.name)
	end
	table.insert(lines, {text = detailTitle, color = c.text, scale = 1.15, font = "default-bold"})
	table.insert(lines, {text = "", color = c.text, scale = 0.95, font = "default"})
	table.insert(lines, {text = getText("MT_REQUIRED_LEVEL"):format(q.minLevel or 0), color = c.muted, scale = 1.0, font = "default-bold"})

	if MissionTerminal.tab == "standard" then
		table.insert(lines, {text = getText("MT_PRICE"):format(q.price or 0), color = c.muted, scale = 1.0, font = "default-bold"})
	end

	--local statusText, statusColor = getStatus(q)
	--table.insert(lines, {text = getText("MT_STATUS"):format(statusText), color = statusColor, scale = 1.0, font = "default-bold"})

	if MissionTerminal.tab == "standard" then
		addWrapped(lines, getText("MT_STANDARD_F4_INFO"), c.muted, 0.95, "default-bold", maxWidth)
	elseif MissionTerminal.tab == "series" then
		addWrapped(lines, getText("MT_SERIES_F4_INFO"), c.muted, 0.95, "default-bold", maxWidth)
	elseif MissionTerminal.tab == "colony" then
		addWrapped(lines, q.info or "", c.muted, 0.95, "default-bold", maxWidth)
	end

	table.insert(lines, {text = "", color = c.text, scale = 0.95, font = "default"})
	table.insert(lines, {text = getText("MT_DESCRIPTION"), color = c.text, scale = 1.0, font = "default-bold"})
	table.insert(lines, {text = "────────────────────", color = c.red, scale = 0.9, font = "default-bold"})

	addWrapped(lines, q.description or "", c.text, 0.95, "default", maxWidth)

	table.insert(lines, {text = "", color = c.text, scale = 0.95, font = "default"})
	table.insert(lines, {text = getText("MT_REWARD_INFO"), color = c.text, scale = 1.0, font = "default-bold"})
	table.insert(lines, {text = "────────────────────", color = c.red, scale = 0.9, font = "default-bold"})

	for _, rawLine in ipairs(splitLines(q.rewards or "")) do
		local color = c.text
		local scale = 0.95
		local font = "default"

		if string.find(rawLine, "^STUFE") or string.find(rawLine, "^Stufe") or string.find(rawLine, "^STAGE") or string.find(rawLine, "^ETAPA") or string.find(rawLine, "^ЭТАП") then
			color = c.yellow
			scale = 0.98
			font = "default-bold"
		end

		for _, line in ipairs(wrapLine(rawLine, maxWidth, scale, font)) do
			table.insert(lines, {
				text = line,
				color = color,
				scale = scale,
				font = font,
			})
		end
	end

	return lines
end

local function drawDetail(q)
	if not q then
		dxDrawText(getText("MT_SELECT_MISSION"), X + 455, Y + 145, X + 940, Y + 530, c.muted, 1.05, "default-bold", "center", "center")
		return
	end

	local lines = buildDetailLines(q)
	local tx = X + 475
	local ty = Y + 165
	local bottom = Y + 510
	local lineH = 18
	local visibleLines = math.floor((bottom - ty) / lineH)
	local start = MissionTerminal.detailScroll + 1

	for i = 0, visibleLines - 1 do
		local data = lines[start + i]

		if data then
			local ly = ty + (i * lineH)

			dxDrawText(
				data.text,
				tx,
				ly,
				X + 920,
				ly + lineH,
				data.color,
				data.scale,
				data.font,
				"left",
				"top",
				false,
				false
			)
		end
	end

	if MissionTerminal.detailScroll > 0 then
		dxDrawText("↑", X + 920, Y + 150, X + 940, Y + 170, c.muted, 1.0, "default-bold", "center", "center")
	end

	if #lines > start + visibleLines - 1 then
		dxDrawText("↓", X + 920, Y + 510, X + 940, Y + 530, c.muted, 1.0, "default-bold", "center", "center")
	end
end

local function renderTerminal()
	if not MissionTerminal.visible then return end

	dxDrawRectangle(X, Y, W, H, c.bg)
	drawBorder(X, Y, W, H, c.line)

	dxDrawRectangle(X, Y, W, 70, c.header)
	dxDrawRectangle(X, Y + 69, W, 2, c.red)

	dxDrawText(getText("MT_TITLE"), X + 22, Y + 6, X + W - 22, Y + 38, c.text, 1.45, "default-bold", "left", "center")
	dxDrawText(getText("MT_LEVEL"):format(MissionTerminal.data.level or 0), X + 22, Y + 36, X + W - 22, Y + 66, c.muted, 1.0, "default-bold", "left", "center")

	drawTab(X + 20, Y + 88, 185, 38, "standard")
	drawTab(X + 212, Y + 88, 185, 38, "series")
	drawTab(X + 404, Y + 88, 185, 38, "colony")

	dxDrawRectangle(X + 20, Y + 145, 420, 385, c.box)
	dxDrawRectangle(X + 455, Y + 145, 485, 385, c.box)

	drawBorder(X + 20, Y + 145, 420, 385, c.line)
	drawBorder(X + 455, Y + 145, 485, 385, c.line)

	local list = getList()
	local scroll = MissionTerminal.scroll[MissionTerminal.tab] or 0
	local rowH = 42
	local rows = 8

	if #list == 0 then
		dxDrawText(getText("MT_NO_ENTRIES"), X + 20, Y + 145, X + 440, Y + 530, c.muted, 1.05, "default-bold", "center", "center")
	else
		for i = 1, rows do
			local index = scroll + i
			local q = list[index]

			if q then
				local ry = Y + 156 + ((i - 1) * rowH)
				local selected = MissionTerminal.selected == index

				dxDrawRectangle(X + 30, ry, 400, rowH - 6, selected and c.box3 or c.box2)

				if selected then
					dxDrawRectangle(X + 30, ry, 4, rowH - 6, c.red)
				end

				local statusText, statusColor = getStatus(q)

				local displayId = "#" .. tostring(q.id)
				local nameX = X + 88

				if MissionTerminal.tab == "colony" then
					displayId = ""
					nameX = X + 42
				end

				dxDrawText(displayId, X + 42, ry, X + 82, ry + rowH - 6, c.muted, 0.95, "default-bold", "left", "center")
				dxDrawText(tostring(q.name), nameX, ry, X + 320, ry + rowH - 6, c.text, 0.95, "default-bold", "left", "center", true)
				dxDrawText(statusText, X + 320, ry, X + 420, ry + rowH - 6, statusColor, 0.82, "default-bold", "right", "center")
			end
		end
	end

	drawDetail(getSelectedQuest())

	drawButton(X + 455, Y + 550, 235, 42, actionText(), canUse(getSelectedQuest()))
	drawButton(X + 705, Y + 550, 235, 42, getText("MT_CLOSE"), true)
end

local function openTerminal()
	if(isWindowOpen())then
		setWindowData()
		MissionTerminal.visible = true
		showCursor(true)
		triggerServerEvent("MissionTerminal.requestData", localPlayer)
	end
end

local function closeTerminal()
	MissionTerminal.visible = false
	showCursor(false)
	closeWindow()
end

addEventHandler("onClientRender", root, renderTerminal)

addEvent("MissionTerminal.open", true)
addEventHandler("MissionTerminal.open", root, openTerminal)

addEvent("MissionTerminal.receiveData", true)
addEventHandler("MissionTerminal.receiveData", root, function(data)
	MissionTerminal.data = data or MissionTerminal.data

	local list = getList()
	if MissionTerminal.selected > #list then
		MissionTerminal.selected = 1
	end
end)

addEventHandler("onClientClick", root, function(button, state)
	if not MissionTerminal.visible or button ~= "left" or state ~= "down" then return end

	if cursorIn(X + 20, Y + 88, 185, 38) then setTab("standard") return end
	if cursorIn(X + 212, Y + 88, 185, 38) then setTab("series") return end
	if cursorIn(X + 404, Y + 88, 185, 38) then setTab("colony") return end

	local list = getList()
	local scroll = MissionTerminal.scroll[MissionTerminal.tab] or 0
	local rowH = 42

	for i = 1, 8 do
		local index = scroll + i

		if list[index] then
			local ry = Y + 156 + ((i - 1) * rowH)

			if cursorIn(X + 30, ry, 400, rowH - 6) then
				MissionTerminal.selected = index
				MissionTerminal.detailScroll = 0
				return
			end
		end
	end

	if cursorIn(X + 455, Y + 550, 235, 42) then
		local q = getSelectedQuest()
		if not canUse(q) then return end

		if MissionTerminal.tab == "standard" then
			triggerServerEvent("MissionTerminal.buyStandardQuest", localPlayer, q.id)
		elseif MissionTerminal.tab == "series" then
			triggerServerEvent("MissionTerminal.claimQuestSeries", localPlayer, q.id)
		elseif MissionTerminal.tab == "colony" then
			triggerServerEvent("MissionTerminal.claimColonyMission", localPlayer, q.id)
		end

		return
	end

	if cursorIn(X + 705, Y + 550, 235, 42) then
		closeTerminal()
		return
	end
end)

addEventHandler("onClientKey", root, function(key, press)
	if not MissionTerminal.visible or not press then return end

	local list = getList()
	local maxScroll = math.max(0, #list - 8)

	if key == "mouse_wheel_down" then
		if cursorIn(X + 455, Y + 145, 485, 385) then
			local lines = buildDetailLines(getSelectedQuest())
			local maxDetailScroll = math.max(0, #lines - 18)
			MissionTerminal.detailScroll = math.min(maxDetailScroll, MissionTerminal.detailScroll + 1)
		else
			MissionTerminal.scroll[MissionTerminal.tab] = math.min(maxScroll, (MissionTerminal.scroll[MissionTerminal.tab] or 0) + 1)
		end
	elseif key == "mouse_wheel_up" then
		if cursorIn(X + 455, Y + 145, 485, 385) then
			MissionTerminal.detailScroll = math.max(0, MissionTerminal.detailScroll - 1)
		else
			MissionTerminal.scroll[MissionTerminal.tab] = math.max(0, (MissionTerminal.scroll[MissionTerminal.tab] or 0) - 1)
		end
	elseif key == "escape" or key == "backspace" then
		closeTerminal()
	end
end)

bindKey("0", "down", function()
	if MissionTerminal.visible then
		closeTerminal()
	else
		openTerminal()
	end
end)