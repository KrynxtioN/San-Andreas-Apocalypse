SellTrash = {
	Ped = {},
	Marker = {},
	Window = {
		state = false,
		scroll = 0,
		cart = {}
	},

	["Peds"] = {
		{689.30651855469,-461.5133972168,16.53630065918,270,0,0},
		{202.51460266113,-248.28019714355,1.9115999937057,60,0,0},
		{2322.8425292969,32.072399139404,26.484399795532,230,0,0},
		{-2100.6608886719,-2402.2407226562,30.625,190,0,0},
		{-2228.078125,2381.4309082031,4.9843997955322,148,0,0},
		{-1962.2270507812,161.03019714355,27.6875,200,0,0},
	},

	["AvailableItems"] = {
		151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168
	},

	["ItemPrices"] = {
		[151] = 2, [152] = 2, [153] = 3, [154] = 1, [155] = 3, [156] = 4,
		[157] = 2, [158] = 1, [159] = 3, [160] = 4, [161] = 5, [162] = 3,
		[163] = 8, [164] = 7, [165] = 5, [166] = 6, [167] = 9, [168] = 4,
	}
}

apocalypseSetElementData(localPlayer, "SellTrashBind", false)

local sx, sy = guiGetScreenSize()
local serverColor = {220, 25, 25}

local function isMouseInPosition(x, y, w, h)
	if not isCursorShowing() then return false end
	local cx, cy = getCursorPosition()
	cx, cy = cx * sx, cy * sy
	return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end

local function getItemName(itemID)
	local language = apocalypseGetElementData(localPlayer, "language") or "EN"

	if ItemInfos and ItemInfos["items"] and ItemInfos["items"][language] and ItemInfos["items"][language][itemID] then
		return ItemInfos["items"][language][itemID]
	end

	return "Item " .. itemID
end

local function getCartTotal()
	local total = 0

	for itemID, amount in pairs(SellTrash.Window.cart) do
		total = total + ((SellTrash.ItemPrices[itemID] or 0) * amount)
	end

	return total
end

local function getCartCount()
	local count = 0

	for _, amount in pairs(SellTrash.Window.cart) do
		count = count + amount
	end

	return count
end

local function addToCart(itemID)
	local currentAmount = SellTrash.Window.cart[itemID] or 0
	local inventoryAmount = hasPlayerItem(itemID) or 0

	if inventoryAmount <= 0 then
		NPC.NormalMessage(getText("CSellTrash1"))
		return
	end

	if currentAmount >= inventoryAmount then
		NPC.NormalMessage(getText("CSellTrash2"))
		return
	end

	SellTrash.Window.cart[itemID] = currentAmount + 1
end

local function removeFromCart(itemID)
	local currentAmount = SellTrash.Window.cart[itemID] or 0

	if currentAmount <= 0 then return end

	SellTrash.Window.cart[itemID] = currentAmount - 1

	if SellTrash.Window.cart[itemID] <= 0 then
		SellTrash.Window.cart[itemID] = nil
	end
end

for i, v in pairs(SellTrash["Peds"]) do
	local int = v[5] or 0
	local dim = v[6] or 0

	SellTrash.Ped[i] = createPed(0, v[1], v[2], v[3], v[4])
	setElementInterior(SellTrash.Ped[i], int)
	setElementDimension(SellTrash.Ped[i], dim)
	setElementFrozen(SellTrash.Ped[i], true)

	SellTrash.Marker[i] = createMarker(v[1], v[2], v[3] - 1, "cylinder", 3, 255, 255, 255, 0)
	setElementInterior(SellTrash.Marker[i], int)
	setElementDimension(SellTrash.Marker[i], dim)

	addEventHandler("onClientMarkerHit", SellTrash.Marker[i], function(player)
		if player == localPlayer and getElementDimension(localPlayer) == getElementDimension(source) then
			if apocalypseGetElementData(localPlayer, "SellTrashBind") == false then
				bindKey("e", "down", SellTrash.openWindow)
				apocalypseSetElementData(localPlayer, "SellTrashBind", true)
				createActivitiesInformationText(getText("CSellTrash3"))
			end
		end
	end)

	addEventHandler("onClientMarkerLeave", SellTrash.Marker[i], function(player)
		if player == localPlayer then
			unbindKey("e", "down", SellTrash.openWindow)
			apocalypseSetElementData(localPlayer, "SellTrashBind", false)

			if SellTrash.Window.state then
				SellTrash.closeWindow()
			end
		end
	end)

	addEventHandler("onClientPedDamage", SellTrash.Ped[i], function()
		cancelEvent()
	end)
end

function SellTrash.openWindow()
	if SellTrash.Window.state then
		SellTrash.closeWindow()
		closeWindow()
		return
	end

	SellTrash.Window.state = true
	SellTrash.Window.scroll = 0
	SellTrash.Window.cart = {}

	showCursor(true)
	setWindowData()
	addEventHandler("onClientRender", root, SellTrash.renderWindow)
	addEventHandler("onClientClick", root, SellTrash.clickWindow)
	addEventHandler("onClientKey", root, SellTrash.keyWindow)
end

function SellTrash.closeWindow()
	SellTrash.Window.state = false
	SellTrash.Window.scroll = 0
	SellTrash.Window.cart = {}

	showCursor(false)
	closeWindow()
	removeEventHandler("onClientRender", root, SellTrash.renderWindow)
	removeEventHandler("onClientClick", root, SellTrash.clickWindow)
	removeEventHandler("onClientKey", root, SellTrash.keyWindow)
end

function SellTrash.renderWindow()
	local w, h = 720, 500
	local x, y = sx / 2 - w / 2, sy / 2 - h / 2

	dxDrawRectangle(x, y, w, h, tocolor(15, 15, 15, 240))
	dxDrawRectangle(x, y, w, 45, tocolor(serverColor[1], serverColor[2], serverColor[3], 245))
	dxDrawText(getText("CSellTrash4"), x, y, x + w, y + 45, tocolor(255,255,255), 1.25, "default-bold", "center", "center")

	dxDrawText(getText("CSellTrash5"),
		x + 20, y + 55, x + w - 20, y + 78, tocolor(220,220,220), 1, "default", "left", "center")

	local listX, listY = x + 20, y + 90
	local listW, listH = 450, 335
	local cartX, cartY = x + 490, y + 90
	local cartW, cartH = 210, 335

	dxDrawRectangle(listX, listY, listW, listH, tocolor(25,25,25,230))
	dxDrawRectangle(cartX, cartY, cartW, cartH, tocolor(25,25,25,230))

	dxDrawText(getText("CSellTrash6"), listX + 10, listY, listX + listW, listY + 30, tocolor(255,255,255), 1, "default-bold", "left", "center")
	dxDrawText(getText("CSellTrash7"), cartX + 10, cartY, cartX + cartW, cartY + 30, tocolor(255,255,255), 1, "default-bold", "left", "center")

	local rowH = 62
	local visibleRows = 5
	local maxScroll = math.max(0, #SellTrash.AvailableItems - visibleRows)

	if SellTrash.Window.scroll > maxScroll then
		SellTrash.Window.scroll = maxScroll
	end

	for i = 1, visibleRows do
		local index = i + SellTrash.Window.scroll
		local itemID = SellTrash.AvailableItems[index]

		if itemID then
			local rowY = listY + 35 + ((i - 1) * rowH)
			local amount = hasPlayerItem(itemID) or 0
			local cartAmount = SellTrash.Window.cart[itemID] or 0
			local price = SellTrash.ItemPrices[itemID] or 0
			local itemName = getItemName(itemID)

			local hover = isMouseInPosition(listX + 8, rowY, listW - 16, rowH - 6)
			dxDrawRectangle(listX + 8, rowY, listW - 16, rowH - 6, hover and tocolor(45,45,45,240) or tocolor(35,35,35,230))

			local img = "Files/Images/Inventory/" .. itemID .. ".png"
			dxDrawImage(listX + 16, rowY + 8, 40, 40, img)

			dxDrawText(itemName, listX + 65, rowY + 7, listX + 250, rowY + 25, tocolor(255,255,255), 0.95, "default-bold", "left", "top", true)
			dxDrawText(getText("CSellTrash8"):format(amount,price), listX + 65, rowY + 31, listX + 250, rowY + 50, tocolor(210,210,210), 0.9, "default", "left", "top")

			local minusX, minusY = listX + 285, rowY + 16
			local plusX, plusY = listX + 385, rowY + 16

			dxDrawRectangle(minusX, minusY, 28, 28, tocolor(serverColor[1], serverColor[2], serverColor[3], 220))
			dxDrawText("-", minusX, minusY, minusX + 28, minusY + 28, tocolor(255,255,255), 1.2, "default-bold", "center", "center")

			dxDrawText(tostring(cartAmount), minusX + 30, minusY, plusX - 2, minusY + 28, tocolor(255,255,255), 1, "default-bold", "center", "center")

			dxDrawRectangle(plusX, plusY, 28, 28, tocolor(serverColor[1], serverColor[2], serverColor[3], 220))
			dxDrawText("+", plusX, plusY, plusX + 28, plusY + 28, tocolor(255,255,255), 1.2, "default-bold", "center", "center")
		end
	end

	if maxScroll > 0 then
		local barX = listX + listW - 8
		local barY = listY + 35
		local barH = listH - 45
		local gripH = math.max(35, barH * (visibleRows / #SellTrash.AvailableItems))
		local gripY = barY + ((barH - gripH) * (SellTrash.Window.scroll / maxScroll))

		dxDrawRectangle(barX, barY, 4, barH, tocolor(70,70,70,200))
		dxDrawRectangle(barX, gripY, 4, gripH, tocolor(serverColor[1], serverColor[2], serverColor[3], 240))
	end

	local cartRowY = cartY + 35
	local cartIndex = 0

	for itemID, amount in pairs(SellTrash.Window.cart) do
		cartIndex = cartIndex + 1

		if cartIndex <= 8 then
			local price = SellTrash.ItemPrices[itemID] or 0
			local itemName = getItemName(itemID)

			dxDrawText(itemName, cartX + 10, cartRowY, cartX + cartW - 10, cartRowY + 18, tocolor(255,255,255), 0.85, "default-bold", "left", "top", true)
			dxDrawText(amount .. "x  =  $" .. (amount * price), cartX + 10, cartRowY + 18, cartX + cartW - 10, cartRowY + 36, tocolor(210,210,210), 0.85, "default", "left", "top")

			cartRowY = cartRowY + 38
		end
	end

	if cartIndex == 0 then
		dxDrawText(getText("CSellTrash9"), cartX, cartY + 150, cartX + cartW, cartY + 180, tocolor(180,180,180), 0.95, "default", "center", "center")
	end

	local total = getCartTotal()
	local count = getCartCount()

	dxDrawText(getText("CSellTrash10"):format(count), x + 20, y + h - 65, x + 200, y + h - 40, tocolor(220,220,220), 1, "default-bold", "left", "center")
	dxDrawText(getText("CSellTrash11"):format(total), x + 200, y + h - 65, x + 430, y + h - 40, tocolor(serverColor[1], serverColor[2], serverColor[3]), 1, "default-bold", "left", "center")

	local sellX, sellY, sellW, sellH = x + w - 180, y + h - 65, 160, 38
	dxDrawRectangle(sellX, sellY, sellW, sellH, tocolor(serverColor[1], serverColor[2], serverColor[3], 230))
	dxDrawText(getText("CSellTrash12"), sellX, sellY, sellX + sellW, sellY + sellH, tocolor(255,255,255), 1, "default-bold", "center", "center")

	local closeX, closeY, closeW, closeH = x + w - 35, y + 10, 25, 25
	dxDrawRectangle(closeX, closeY, closeW, closeH, tocolor(0,0,0,100))
	dxDrawText("X", closeX, closeY, closeX + closeW, closeY + closeH, tocolor(255,255,255), 1, "default-bold", "center", "center")
end

function SellTrash.clickWindow(button, state)
	if button ~= "left" or state ~= "down" or not SellTrash.Window.state then return end

	local w, h = 720, 500
	local x, y = sx / 2 - w / 2, sy / 2 - h / 2

	if isMouseInPosition(x + w - 35, y + 10, 25, 25) then
		SellTrash.closeWindow()
		return
	end

	if isMouseInPosition(x + w - 180, y + h - 65, 160, 38) then
		if getCartCount() <= 0 then
			outputChatBox(getText("CSellTrash13"), 220, 25, 25)
			return
		end

		triggerServerEvent("SellTrash.sellItems", localPlayer, SellTrash.Window.cart)
		SellTrash.closeWindow()
		return
	end

	local listX, listY = x + 20, y + 90
	local rowH = 62
	local visibleRows = 5

	for i = 1, visibleRows do
		local index = i + SellTrash.Window.scroll
		local itemID = SellTrash.AvailableItems[index]

		if itemID then
			local rowY = listY + 35 + ((i - 1) * rowH)

			local minusX, minusY = listX + 285, rowY + 16
			local plusX, plusY = listX + 385, rowY + 16

			if isMouseInPosition(minusX, minusY, 28, 28) then
				removeFromCart(itemID)
				return
			end

			if isMouseInPosition(plusX, plusY, 28, 28) then
				addToCart(itemID)
				return
			end
		end
	end
end

function SellTrash.keyWindow(button, press)
	if not SellTrash.Window.state or not press then return end

	local visibleRows = 5
	local maxScroll = math.max(0, #SellTrash.AvailableItems - visibleRows)

	if button == "mouse_wheel_up" then
		SellTrash.Window.scroll = math.max(0, SellTrash.Window.scroll - 1)
	elseif button == "mouse_wheel_down" then
		SellTrash.Window.scroll = math.min(maxScroll, SellTrash.Window.scroll + 1)
	elseif button == "backspace" or button == "escape" then
		SellTrash.closeWindow()
	end
end

function SellTrash.renderPedTexts()
	for _, ped in pairs(SellTrash.Ped) do
		if isElement(ped) then
			local px, py, pz = getElementPosition(ped)
			local lx, ly, lz = getElementPosition(localPlayer)

			if getDistanceBetweenPoints3D(px, py, pz, lx, ly, lz) <= 5 then
				local x, y = getScreenFromWorldPosition(px, py, pz + 1.15)

				if x and y then
					dxDrawText(getText("CSellTrash14"), x - 1, y - 1, x - 1, y - 1, tocolor(0, 0, 0, 255), 1.2, "default-bold", "center", "center")
					dxDrawText(getText("CSellTrash14"), x + 1, y + 1, x + 1, y + 1, tocolor(0, 0, 0, 255), 1.2, "default-bold", "center", "center")
					dxDrawText(getText("CSellTrash14"), x, y, x, y, tocolor(255, 255, 255, 255), 1.2, "default-bold", "center", "center")
				end
			end
		end
	end
end
addEventHandler("onClientRender", root, SellTrash.renderPedTexts)

addEventHandler("onClientPlayerWasted", root, function(player)
	if player == localPlayer then
		unbindKey("e", "down", SellTrash.openWindow)
		apocalypseSetElementData(localPlayer, "SellTrashBind", false)

		if SellTrash.Window.state then
			SellTrash.closeWindow()
		end
	end
end)