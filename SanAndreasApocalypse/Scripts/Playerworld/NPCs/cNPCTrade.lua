NPC.TradePreview = nil
NPC.TradeWindow = nil

local tradeSX, tradeSY = guiGetScreenSize()
local TRADE_COLOR_R, TRADE_COLOR_G, TRADE_COLOR_B = 220, 25, 25

local TradePreviewRenderActive = false
local TradeWindowRenderActive = false

local function isMouseInTradePosition(posX, posY, width, height)
	if not isCursorShowing() then return false end

	local cx, cy = getCursorPosition()
	if not cx or not cy then return false end

	cx, cy = cx * tradeSX, cy * tradeSY

	return cx >= posX and cx <= posX + width and cy >= posY and cy <= posY + height
end

local function drawTradeText(text, x1, y1, x2, y2, color, scale, font, alignX, alignY, clip)
	text = tostring(text or "")
	dxDrawText(text, x1 + 1, y1 + 1, x2 + 1, y2 + 1, tocolor(0, 0, 0, 190), scale, font, alignX, alignY, clip or false, true, true)
	dxDrawText(text, x1, y1, x2, y2, color, scale, font, alignX, alignY, clip or false, true, true)
end

local function getPriceText(price)
	if not price or not price.item then return "Kein Preis" end
	return tostring(price.amount or 1) .. "x " .. tostring(price.itemName or ("Item " .. tostring(price.item)))
end

local function openTradePreviewRender()
	if not TradePreviewRenderActive then
		addEventHandler("onClientRender", root, NPC.RenderTradePreview)
		TradePreviewRenderActive = true
	end
end

function closeTradePreviewRender()
	NPC.TradePreview = nil

	if TradePreviewRenderActive then
		removeEventHandler("onClientRender", root, NPC.RenderTradePreview)
		TradePreviewRenderActive = false
	end
end

local function openTradeWindowRender()
	if not TradeWindowRenderActive then
		setWindowData()
		addEventHandler("onClientRender", root, NPC.RenderTradeWindow)
		TradeWindowRenderActive = true
	end
end

local function closeTradeWindowRender()
	if TradeWindowRenderActive then
		removeEventHandler("onClientRender", root, NPC.RenderTradeWindow)
		TradeWindowRenderActive = false
	end
end

function NPC.CloseTradeWindow()
	NPC.TradeWindow = nil
	showCursor(false)
	closeTradeWindowRender()
	apocalypseSetElementData(localPlayer, "ActiveNPCConversation", false)
	closeWindow()
end

addEvent("NPC.updateTradePreview", true)
addEventHandler("NPC.updateTradePreview", root, function(data)
	NPC.TradePreview = data
	openTradePreviewRender()
end)

addEvent("NPC.clearTradePreview", true)
addEventHandler("NPC.clearTradePreview", root, function()
	closeTradePreviewRender()
end)

addEvent("NPC.closeTradeWindow", true)
addEventHandler("NPC.closeTradeWindow", root, function()
	NPC.CloseTradeWindow()
end)

addEvent("NPC.openTradeWindow", true)
addEventHandler("NPC.openTradeWindow", root, function(data)
	if not isWindowOpen() then return end

	NPC.TradeWindow = data
	showCursor(true)
	openTradeWindowRender()
end)

function NPC.RenderTradePreview()
	if not NPC.TradePreview then
		closeTradePreviewRender()
		return
	end

	if not isCharacterLoggedIn() or not isWindowOpen() or isPedDead(localPlayer) then return end
	if apocalypseGetElementData(localPlayer, "ActiveNPCConversation") == true then return end

	local sx, sy = tradeSX / 1920, tradeSY / 1080

	local boxW, boxH = 300 * sx, 112 * sy
	local boxX, boxY = tradeSX - boxW - 24 * sx, tradeSY - boxH - 185 * sy

	local rewardSize = 44 * sx
	local priceSize = 24 * sx

	local rewardX, rewardY = boxX + 12 * sx, boxY + 32 * sy
	local priceX, priceY = boxX + 70 * sx, boxY + 68 * sy

	local rewardPath = "Files/Images/Inventory/" .. tostring(NPC.TradePreview.item) .. ".png"
	local pricePath = "Files/Images/Inventory/" .. tostring(NPC.TradePreview.price and NPC.TradePreview.price.item or 0) .. ".png"

	dxDrawRectangle(boxX + 3 * sx, boxY + 3 * sy, boxW, boxH, tocolor(0, 0, 0, 105), true)
	dxDrawRectangle(boxX, boxY, boxW, boxH, tocolor(13, 13, 13, 235), true)
	dxDrawRectangle(boxX, boxY, boxW, 3 * sy, tocolor(TRADE_COLOR_R, TRADE_COLOR_G, TRADE_COLOR_B, 255), true)

	drawTradeText(getText("CNPCTrade1"), boxX + 12 * sx, boxY + 7 * sy, boxX + boxW, boxY + 26 * sy, tocolor(TRADE_COLOR_R, TRADE_COLOR_G, TRADE_COLOR_B, 255), 0.9 * sx, "default-bold", "left", "top")

	dxDrawRectangle(rewardX - 3 * sx, rewardY - 3 * sy, rewardSize + 6 * sx, rewardSize + 6 * sy, tocolor(38, 38, 38, 235), true)

	if fileExists(rewardPath) then
		dxDrawImage(rewardX, rewardY, rewardSize, rewardSize, rewardPath, 0, 0, 0, tocolor(255,255,255,255), true)
	end

	drawTradeText(
		NPC.TradePreview.amount .. "x " .. NPC.TradePreview.itemName,
		boxX + 68 * sx,
		boxY + 31 * sy,
		boxX + boxW - 10 * sx,
		boxY + 52 * sy,
		tocolor(255,255,255,255),
		0.86 * sx,
		"default-bold",
		"left",
		"top",
		true
	)

	if NPC.TradePreview.price and NPC.TradePreview.price.item and fileExists(pricePath) then
		dxDrawImage(priceX, priceY, priceSize, priceSize, pricePath, 0, 0, 0, tocolor(255,255,255,255), true)
	end

	drawTradeText(
		getPriceText(NPC.TradePreview.price),
		boxX + 100 * sx,
		boxY + 69 * sy,
		boxX + boxW - 10 * sx,
		boxY + 91 * sy,
		tocolor(230,230,230,255),
		0.78 * sx,
		"default-bold",
		"left",
		"top",
		true
	)

	local hint = tonumber(NPC.TradePreview.bought) == 1 and getText("CNPCTrade2") or getText("CNPCTrade3")

	drawTradeText(
		hint,
		boxX + 10 * sx,
		boxY + boxH - 20 * sy,
		boxX + boxW - 10 * sx,
		boxY + boxH,
		tonumber(NPC.TradePreview.bought) == 1 and tocolor(150,150,150,255) or tocolor(TRADE_COLOR_R, TRADE_COLOR_G, TRADE_COLOR_B,255),
		0.76 * sx,
		"default-bold",
		"right",
		"top",
		true
	)
end

function NPC.RenderTradeWindow()
	if not NPC.TradeWindow then
		NPC.CloseTradeWindow()
		return
	end

	local data = NPC.TradeWindow
	local sx, sy = tradeSX / 1920, tradeSY / 1080

	local w, h = 390 * sx, 285 * sy
	local bx, by = tradeSX / 2 - w / 2, tradeSY / 2 - h / 2

	local closeW, closeH = 26 * sx, 24 * sy
	local closeX, closeY = bx + w - closeW - 10 * sx, by + 10 * sy

	local rewardSize = 58 * sx
	local priceSize = 48 * sx

	local rewardBoxX, rewardBoxY = bx + 18 * sx, by + 68 * sy
	local rewardBoxW, rewardBoxH = w - 36 * sx, 74 * sy

	local priceBoxX, priceBoxY = bx + 18 * sx, by + 152 * sy
	local priceBoxW, priceBoxH = w - 36 * sx, 64 * sy

	local rewardX, rewardY = bx + 24 * sx, by + 75 * sy
	local priceX, priceY = bx + 29 * sx, by + 160 * sy

	local buyW, buyH = 130 * sx, 32 * sy
	local buyX, buyY = bx + w - buyW - 18 * sx, by + h - buyH - 16 * sy

	local rewardPath = "Files/Images/Inventory/" .. tostring(data.item) .. ".png"
	local pricePath = "Files/Images/Inventory/" .. tostring(data.price and data.price.item or 0) .. ".png"

	dxDrawRectangle(bx + 4 * sx, by + 4 * sy, w, h, tocolor(0, 0, 0, 125), true)
	dxDrawRectangle(bx, by, w, h, tocolor(13, 13, 13, 245), true)
	dxDrawRectangle(bx, by, w, 4 * sy, tocolor(TRADE_COLOR_R, TRADE_COLOR_G, TRADE_COLOR_B, 255), true)

	drawTradeText(getText("CNPCTrade1"), bx + 18 * sx, by + 14 * sy, bx + w, by + 40 * sy, tocolor(TRADE_COLOR_R, TRADE_COLOR_G, TRADE_COLOR_B, 255), 1.05 * sx, "default-bold", "left", "top")
	drawTradeText(getText("CNPCTrade4"), bx + 18 * sx, by + 42 * sy, bx + w, by + 63 * sy, tocolor(190,190,190,255), 0.86 * sx, "default", "left", "top")

	dxDrawRectangle(closeX, closeY, closeW, closeH, isMouseInTradePosition(closeX, closeY, closeW, closeH) and tocolor(TRADE_COLOR_R, TRADE_COLOR_G, TRADE_COLOR_B, 230) or tocolor(42,42,42,235), true)
	drawTradeText("X", closeX, closeY + 4 * sy, closeX + closeW, closeY + closeH, tocolor(255,255,255,255), 0.8 * sx, "default-bold", "center", "top")

	dxDrawRectangle(rewardBoxX, rewardBoxY, rewardBoxW, rewardBoxH, tocolor(24,24,24,235), true)
	dxDrawRectangle(rewardX - 4 * sx, rewardY - 4 * sy, rewardSize + 8 * sx, rewardSize + 8 * sy, tocolor(42,42,42,245), true)

	if fileExists(rewardPath) then
		dxDrawImage(rewardX, rewardY, rewardSize, rewardSize, rewardPath, 0, 0, 0, tocolor(255,255,255,255), true)
	end

	drawTradeText(getText("CNPCTrade5"), bx + 100 * sx, by + 76 * sy, bx + w - 18 * sx, by + 96 * sy, tocolor(170,170,170,255), 0.76 * sx, "default-bold", "left", "top", true)
	drawTradeText(data.amount .. "x " .. data.itemName, bx + 100 * sx, by + 99 * sy, bx + w - 18 * sx, by + 122 * sy, tocolor(255,255,255,255), 0.9 * sx, "default-bold", "left", "top", true)

	dxDrawRectangle(priceBoxX, priceBoxY, priceBoxW, priceBoxH, tocolor(24,24,24,235), true)
	dxDrawRectangle(priceX - 4 * sx, priceY - 4 * sy, priceSize + 8 * sx, priceSize + 8 * sy, tocolor(42,42,42,245), true)

	if data.price and data.price.item and fileExists(pricePath) then
		dxDrawImage(priceX, priceY, priceSize, priceSize, pricePath, 0, 0, 0, tocolor(255,255,255,255), true)
	end

	drawTradeText(getText("CNPCTrade6"), bx + 100 * sx, by + 160 * sy, bx + w - 18 * sx, by + 180 * sy, tocolor(170,170,170,255), 0.76 * sx, "default-bold", "left", "top", true)
	drawTradeText(getPriceText(data.price), bx + 100 * sx, by + 183 * sy, bx + w - 18 * sx, by + 207 * sy, tocolor(255,255,255,255), 0.88 * sx, "default-bold", "left", "top", true)

	local buyText = tonumber(data.bought) == 1 and getText("CNPCTrade2") or getText("CNPCTrade7")
	local enabled = tonumber(data.bought) ~= 1
	local hover = enabled and isMouseInTradePosition(buyX, buyY, buyW, buyH)

	dxDrawRectangle(
		buyX,
		buyY,
		buyW,
		buyH,
		enabled and (hover and tocolor(TRADE_COLOR_R,TRADE_COLOR_G,TRADE_COLOR_B,255) or tocolor(TRADE_COLOR_R,TRADE_COLOR_G,TRADE_COLOR_B,215)) or tocolor(80,80,80,220),
		true
	)

	drawTradeText(buyText, buyX, buyY + 8 * sy, buyX + buyW, buyY + buyH, tocolor(255,255,255,255), 1 * sx, "default-bold", "center", "top")
end

local function tryOpenNPCTrade()
	if NPC.TradeWindow then return end
	if apocalypseGetElementData(localPlayer, "ActiveNPCConversation") == true then return end

	local npcID = tonumber(apocalypseGetElementData(localPlayer, "NPC.InteractionID"))
	if not npcID then return end

	if isElement(NPC.Colsphere[npcID]) and isElementWithinColShape(localPlayer, NPC.Colsphere[npcID]) then
		triggerServerEvent("NPC.requestTrade", localPlayer, npcID)
		apocalypseSetElementData(localPlayer, "ActiveNPCConversation", true)
	end
end

addEventHandler("onClientClick", root, function(button, state, _, _, _, _, _, clickedElement)
	if button ~= "left" or state ~= "down" then return end

	if NPC.TradeWindow then
		local sx, sy = tradeSX / 1920, tradeSY / 1080

		local w, h = 390 * sx, 285 * sy
		local bx, by = tradeSX / 2 - w / 2, tradeSY / 2 - h / 2

		local closeW, closeH = 26 * sx, 24 * sy
		local closeX, closeY = bx + w - closeW - 10 * sx, by + 10 * sy

		local buyW, buyH = 130 * sx, 32 * sy
		local buyX, buyY = bx + w - buyW - 18 * sx, by + h - buyH - 16 * sy

		if isMouseInTradePosition(closeX, closeY, closeW, closeH) then
			NPC.CloseTradeWindow()
			return
		end

		if tonumber(NPC.TradeWindow.bought) ~= 1 and isMouseInTradePosition(buyX, buyY, buyW, buyH) then
			triggerServerEvent("NPC.buyTradeOffer", localPlayer, NPC.TradeWindow.npcID)
			return
		end

		return
	end

	if clickedElement and isElement(clickedElement) then
		local npcID = tonumber(apocalypseGetElementData(clickedElement, "NPC.ID"))

		if npcID and isElement(NPC.Colsphere[npcID]) and isElementWithinColShape(localPlayer, NPC.Colsphere[npcID]) then
			triggerServerEvent("NPC.requestTrade", localPlayer, npcID)
			apocalypseSetElementData(localPlayer, "ActiveNPCConversation", true)
		end
	end
end)

addEventHandler("onClientPlayerWasted",root,function(player)
	if(player == localPlayer)then
		closeTradeWindowRender()
		NPC.CloseTradeWindow()
	end
end)