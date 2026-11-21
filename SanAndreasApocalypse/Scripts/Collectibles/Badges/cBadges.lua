local sx, sy = guiGetScreenSize()

local SERVER_COLOR = {220, 25, 25}

local badgeWindow = false
local selectedBadge = 1
local scroll = 0
local badgeData = {}

local windowW, windowH = 700, 455
local maxVisibleBadges = 5

local badgeRequirements = {
	[1] = 10,
	[2] = 25,
	[3] = 50,
	[4] = 100,
	[5] = 175,
	[6] = 250,
	[7] = 500,
	[8] = 750,
	[9] = 1000,
}

local badgeTextures = {}

local function isMouseInPosition(x, y, w, h)
	if not isCursorShowing() then return false end

	local cx, cy = getCursorPosition()
	cx, cy = cx * sx, cy * sy

	return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end

function getBadgeLanguage()
	return apocalypseGetElementData(localPlayer, "language") or "EN"
end

function getBadgeInfo(id)
	local lang = getBadgeLanguage()

	if Badges and Badges["Data"] and Badges["Data"][lang] and Badges["Data"][lang][id] then
		return Badges["Data"][lang][id]
	end

	if Badges and Badges["Data"] and Badges["Data"]["EN"] and Badges["Data"]["EN"][id] then
		return Badges["Data"]["EN"][id]
	end

	return nil
end

for id = 1, 9 do
	local info = getBadgeInfo(id)
	if info then
		badgeTextures[id] = dxCreateTexture(info[3])
	end
end

function getPlayerLevel()
	return tonumber(getElementData(localPlayer, "level")) or 0
end

function canClaimBadge(id)
	return getPlayerLevel() >= (badgeRequirements[id] or 999999)
end

function dxDrawButton(x, y, w, h, text, active)
	local r, g, b = SERVER_COLOR[1], SERVER_COLOR[2], SERVER_COLOR[3]

	dxDrawRectangle(x, y, w, h, active and tocolor(r, g, b, 235) or tocolor(65, 65, 65, 220))

	if isMouseInPosition(x, y, w, h) then
		dxDrawRectangle(x, y, w, h, tocolor(255, 255, 255, 25))
	end

	dxDrawText(text, x, y, x + w, y + h, tocolor(255, 255, 255), 1, "default-bold", "center", "center", true)
end

function getBadgeStatus(id)
	local has = badgeData[id] and badgeData[id].has
	local equipped = badgeData[id] and badgeData[id].equipped
	local unlocked = canClaimBadge(id)

	if equipped then
		return getText("CBadges2")
	elseif has then
		return getText("CBadges3")
	elseif unlocked then
		return getText("CBadges4")
	else
		return getText("CBadges5"):format(badgeRequirements[id])
	end
end

function renderBadgeWindow()
	if not badgeWindow then return end

	local x, y = sx / 2 - windowW / 2, sy / 2 - windowH / 2
	local r, g, b = SERVER_COLOR[1], SERVER_COLOR[2], SERVER_COLOR[3]

	local headerH = 45
	local padding = 18
	local gap = 12

	local listX = x + padding
	local listY = y + headerH + padding
	local listW = 305
	local itemH = 61
	local itemGap = 8
	local listH = (itemH * maxVisibleBadges) + (itemGap * (maxVisibleBadges - 1))

	local infoX = listX + listW + gap
	local infoY = listY
	local infoW = windowW - padding - infoX + x
	local infoH = listH

	dxDrawRectangle(x, y, windowW, windowH, tocolor(15, 15, 15, 245))
	dxDrawRectangle(x, y, windowW, headerH, tocolor(r, g, b, 245))

	dxDrawText(getText("CBadges1"), x + padding, y, x + windowW, y + headerH, tocolor(255,255,255), 1.25, "default-bold", "left", "center")
	dxDrawText("X", x + windowW - 40, y, x + windowW - 10, y + headerH, tocolor(255,255,255), 1.2, "default-bold", "center", "center")

	dxDrawRectangle(listX - 5, listY - 5, listW + 10, listH + 10, tocolor(25,25,25,180))
	dxDrawRectangle(infoX - 5, infoY - 5, infoW + 10, infoH + 10, tocolor(25,25,25,180))
	dxDrawRectangle(infoX, infoY, infoW, infoH, tocolor(25,25,25,225))

	for i = 1, maxVisibleBadges do
		local id = i + scroll
		local info = getBadgeInfo(id)

		if info then
			local bx = listX
			local by = listY + ((i - 1) * (itemH + itemGap))

			local bgColor = selectedBadge == id and tocolor(r, g, b, 180) or tocolor(38,38,38,235)

			dxDrawRectangle(bx, by, listW, itemH, bgColor)

			if badgeTextures[id] then
				dxDrawImage(bx + 8, by + 7, 47, 47, badgeTextures[id])
			end

			dxDrawText(info[1], bx + 65, by + 7, bx + listW - 8, by + 28, tocolor(255,255,255), 0.92, "default-bold", "left", "center", true)
			dxDrawText(getBadgeStatus(id), bx + 65, by + 32, bx + listW - 8, by + 54, tocolor(215,215,215), 0.82, "default", "left", "center", true)
		end
	end

	local data = getBadgeInfo(selectedBadge)
	if data then
		local imageSize = 92
		local imageX = infoX + infoW / 2 - imageSize / 2
		local imageY = infoY + 18

		if badgeTextures[selectedBadge] then
			dxDrawImage(imageX, imageY, imageSize, imageSize, badgeTextures[selectedBadge])
		end

		dxDrawText(data[1], infoX + 15, infoY + 122, infoX + infoW - 15, infoY + 148, tocolor(255,255,255), 1.12, "default-bold", "center", "center", true)
		dxDrawText(data[2], infoX + 20, infoY + 155, infoX + infoW - 20, infoY + 215, tocolor(220,220,220), 0.9, "default", "center", "top", true, true)

		dxDrawText(
			getText("CBadges6"):format(badgeRequirements[selectedBadge]),
			infoX + 15,
			infoY + 222,
			infoX + infoW - 15,
			infoY + 246,
			tocolor(200,200,200),
			0.9,
			"default-bold",
			"center",
			"center"
		)

		dxDrawText(
			getText("CBadges11"),
			infoX + 20,
			infoY + 252,
			infoX + infoW - 20,
			infoY + 292,
			tocolor(190,190,190),
			0.82,
			"default",
			"center",
			"top",
			true,
			true
		)

		local has = badgeData[selectedBadge] and badgeData[selectedBadge].has
		local equipped = badgeData[selectedBadge] and badgeData[selectedBadge].equipped
		local unlocked = canClaimBadge(selectedBadge)

		local btnText = getText("CBadges7")
		local active = false

		if equipped then
			btnText = getText("CBadges8")
			active = true
		elseif has then
			btnText = getText("CBadges9")
			active = true
		elseif unlocked then
			btnText = getText("CBadges10")
			active = true
		end

		dxDrawButton(infoX + infoW / 2 - 95, infoY + infoH - 50, 190, 38, btnText, active)
	end
end

function clickBadgeWindow(button, state, cx, cy)
	if not badgeWindow then return end
	if button ~= "left" or state ~= "down" then return end

	local x, y = sx / 2 - windowW / 2, sy / 2 - windowH / 2

	local headerH = 45
	local padding = 18
	local gap = 12

	local listX = x + padding
	local listY = y + headerH + padding
	local listW = 305
	local itemH = 61
	local itemGap = 8
	local listH = (itemH * maxVisibleBadges) + (itemGap * (maxVisibleBadges - 1))

	local infoX = listX + listW + gap
	local infoY = listY
	local infoW = windowW - padding - infoX + x
	local infoH = listH

	if cx >= x + windowW - 40 and cx <= x + windowW - 10 and cy >= y and cy <= y + headerH then
		closeBadgeWindow()
		return
	end

	for i = 1, maxVisibleBadges do
		local id = i + scroll
		local bx = listX
		local by = listY + ((i - 1) * (itemH + itemGap))

		if getBadgeInfo(id) then
			if cx >= bx and cx <= bx + listW and cy >= by and cy <= by + itemH then
				selectedBadge = id
				return
			end
		end
	end

	local btnX = infoX + infoW / 2 - 95
	local btnY = infoY + infoH - 50
	local btnW = 190
	local btnH = 38

	if cx >= btnX and cx <= btnX + btnW and cy >= btnY and cy <= btnY + btnH then
		local has = badgeData[selectedBadge] and badgeData[selectedBadge].has
		local equipped = badgeData[selectedBadge] and badgeData[selectedBadge].equipped

		if equipped then
			triggerServerEvent("unequipPlayerBadge", localPlayer)
		elseif has then
			triggerServerEvent("equipPlayerBadge", localPlayer, selectedBadge)
		elseif canClaimBadge(selectedBadge) then
			triggerServerEvent("givePlayerBadge", localPlayer, selectedBadge)
		end
	end
end

function keyBadgeWindow(button, press)
	if not badgeWindow or not press then return end

	local maxScroll = math.max(0, 9 - maxVisibleBadges)

	if button == "mouse_wheel_down" then
		scroll = math.min(scroll + 1, maxScroll)
	elseif button == "mouse_wheel_up" then
		scroll = math.max(scroll - 1, 0)
	elseif button == "escape" then
		closeBadgeWindow()
	end
end

function openBadgeWindow()
	if isWindowOpen() then
		if badgeWindow then return end

		badgeWindow = true
		selectedBadge = selectedBadge or 1
		scroll = 0
		setWindowData()

		showCursor(true)

		addEventHandler("onClientRender", root, renderBadgeWindow)
		addEventHandler("onClientClick", root, clickBadgeWindow)
		addEventHandler("onClientKey", root, keyBadgeWindow)

		triggerServerEvent("requestBadgeData", localPlayer)
	end
end
addEvent("openBadgeWindow", true)
addEventHandler("openBadgeWindow", root, openBadgeWindow)

function closeBadgeWindow()
	if not badgeWindow then return end

	badgeWindow = false
	showCursor(false)
	closeWindow()

	removeEventHandler("onClientRender", root, renderBadgeWindow)
	removeEventHandler("onClientClick", root, clickBadgeWindow)
	removeEventHandler("onClientKey", root, keyBadgeWindow)
end

addEvent("receiveBadgeData", true)
addEventHandler("receiveBadgeData", root, function(data)
	badgeData = data or {}
end)

addEvent("refreshBadgeWindow", true)
addEventHandler("refreshBadgeWindow", root, function()
	if badgeWindow then
		triggerServerEvent("requestBadgeData", localPlayer)
	end
end)

addEventHandler("onClientPlayerWasted", root, function(player)
	if player == localPlayer then
		closeBadgeWindow()
	end
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
	for _, texture in pairs(badgeTextures) do
		if isElement(texture) then
			destroyElement(texture)
		end
	end
end)