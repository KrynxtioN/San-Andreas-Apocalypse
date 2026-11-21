KeysShop = {
	player_shop = 0,
	["Keys"] = {
		[1] = {
			["EN"] = {
				[1] = {"Dillimore's Hope Zone 1/3\nStorage Room", 750, 112, 5, 2},
				[2] = {"Dillimore's Hope Zone 1/3\n Gas Station", 1250, 187, 5, 3},
				[3] = {"Dillimore's Hope Zone 1/3\n Backroom Storage Room", 2500, 375, 10, 6},
				[4] = {"Dillimore's Hope Zone 1/3\n Crazy Joe's Barn", 3000, 450, 10, 12},
			},
			["DE"] = {
				[1] = {"Dillimore's Hope Zone 1/3\nAbstellkammer", 750, 112, 5, 2},
				[2] = {"Dillimore's Hope Zone 1/3\nTankstelle", 1250, 187, 5, 3},
				[3] = {"Dillimore's Hope Zone 1/3\nHinterräume Abstellkammer", 2500, 375, 10, 6},
				[4] = {"Dillimore's Hope Zone 1/3\n Crazy Joe's Scheune", 3000, 450, 10, 12},
			},
			["RU"] = {
				[1] = {"Зона Диллиморс Хоуп 1/3\nСкладское помещение", 750, 112, 5, 2},
				[2] = {"Зона Диллиморс Хоуп 1/3\nАвтозаправка", 1250, 187, 5, 3},
				[3] = {"Зона Диллиморс Хоуп 1/3\nСклад за задней комнатой", 2500, 375, 10, 6},
				[4] = {"Зона Диллиморс Хоуп 1/3\nСарай Безумного Джо", 3000, 450, 10, 12},
			},
			["PT"] = {
				[1] = {"Zona Dillimore's Hope 1/3\nDepósito", 750, 112, 5, 2},
				[2] = {"Zona Dillimore's Hope 1/3\nPosto de Gasolina", 1250, 187, 5, 3},
				[3] = {"Zona Dillimore's Hope 1/3\nDepósito dos Fundos", 2500, 375, 10, 6},
				[4] = {"Zona Dillimore's Hope 1/3\nCeleiro do Joe Maluco", 3000, 450, 10, 12},
			},
		},
	},
}

local x, y = guiGetScreenSize()

local shopVisible = false
local keysPerPage = 8
local currentPage = 1
local totalKeys = 0
local keyWidth, keyHeight = 180, 100

function KeysShop.renderWindow()
	local bgW, bgH = (keyWidth + 20) * 4 + 80, (keyHeight + 20) * 2 + 80
	local bgX, bgY = (x - bgW) / 2, (y - bgH) / 2

	local title = getText("CKeyshop4")
	local titleHeight = 25
	local titleY = bgY - titleHeight - 10
	dxDrawText(title, bgX, titleY, bgX + bgW, titleY + titleHeight, tocolor(255, 255, 255, 255), 1.5, "default-bold", "center", "center")

	dxDrawRectangle(bgX - 4, bgY - 4, bgW + 8, bgH + 8, tocolor(220, 25, 25, 200))
	dxDrawRectangle(bgX, bgY, bgW, bgH, tocolor(50, 50, 50, 180))
	
	local rows, cols = 2, 4
	local totalKeyWidth = cols * keyWidth + (cols - 1) * 20
	local startX = bgX + (bgW - totalKeyWidth) / 2
	local startY = bgY + 40
	local index = (currentPage - 1) * keysPerPage
	
	for row = 0, rows - 1 do
		for col = 0, cols - 1 do
			index = index + 1
			if index <= totalKeys then
				local xPos = startX + col * (keyWidth + 20)
				local yPos = startY + row * (keyHeight + 20)
				
				local keyInfos = KeysShop["Keys"][KeysShop.player_shop][apocalypseGetElementData(localPlayer, "language") or "EN"][index]
				local name, price_money, price_brain, key_level = keyInfos[1], keyInfos[2], keyInfos[3], keyInfos[4]
				
				local hovered = isMouseInPosition(xPos, yPos, keyWidth, keyHeight)
				local scale = hovered and 1.1 or 1
				local drawWidth = keyWidth * scale
				local drawHeight = keyHeight * scale
				local drawX = xPos - (drawWidth - keyWidth) / 2
				local drawY = yPos - (drawHeight - keyHeight) / 2
				
				if hovered then
					dxDrawRectangle(drawX - 4, drawY - 4, drawWidth + 8, drawHeight + 8, tocolor(0, 255, 255, 150))
				end
				
				dxDrawRectangle(drawX - 2, drawY - 2, drawWidth + 4, drawHeight + 4, tocolor(0, 0, 0, 200))
				dxDrawImage(drawX, drawY, drawWidth, drawHeight, "Files/Images/Keyshop.png")

				if tonumber(apocalypseGetElementData(localPlayer, "level")) < key_level then
					local lockedText = getText("CKeyshop1"):format(key_level)
					dxDrawText(lockedText, drawX, drawY + drawHeight / 2 - 10, drawX + drawWidth, drawY + drawHeight, tocolor(255, 0, 0, 255), 0.7, "default-bold", "center", "center")
				else
					if hovered then
						local infoText = getText("CKeyshop2"):format(price_money, price_brain, name)
						local rectHeight = 50
						local rectY = drawY + drawHeight - rectHeight
						dxDrawRectangle(drawX, rectY, drawWidth, rectHeight, tocolor(0, 0, 0, 150))
						dxDrawText(infoText, drawX, rectY, drawX + drawWidth, rectY + rectHeight, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center")
					end
				end
			end
		end
	end

	local arrowSize = 35
	if currentPage > 1 then
		dxDrawText("<", bgX - arrowSize, bgY + bgH/2 - arrowSize/2, bgX, bgY + bgH/2 + arrowSize/2, tocolor(255, 255, 255, 255), 2, "default-bold", "center", "center")
	end
	
	if currentPage * keysPerPage < totalKeys then
		dxDrawText(">", bgX + bgW, bgY + bgH/2 - arrowSize/2, bgX + bgW + arrowSize, bgY + bgH/2 + arrowSize/2, tocolor(255, 255, 255, 255), 2, "default-bold", "center", "center")
	end
	
	dxDrawText(getText("CKeyshop3"), bgX, bgY + bgH - 30, bgX + bgW, bgY + bgH, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center", _, true)
end

function KeysShop.handleClick(button, state)
	if button == "left" and state == "down" then
		local bgW, bgH = (keyWidth + 20) * 4 + 80, (keyHeight + 20) * 2 + 80
		local bgX, bgY = (x - bgW) / 2, (y - bgH) / 2
		local rows, cols = 2, 4
		local startX = bgX + (bgW - (cols * keyWidth + (cols - 1) * 20)) / 2
		local startY = bgY + 40
		local index = (currentPage - 1) * keysPerPage
		local arrowSize = 35

		if isMouseInPosition(bgX - arrowSize, bgY + bgH/2 - arrowSize/2, arrowSize, arrowSize) then
			currentPage = currentPage - 1
			if currentPage < 1 then currentPage = 1 end
			return
		end

		if isMouseInPosition(bgX + bgW, bgY + bgH/2 - arrowSize/2, arrowSize, arrowSize) then
			currentPage = currentPage + 1
			local maxPage = math.ceil(totalKeys / keysPerPage)
			if currentPage > maxPage then currentPage = maxPage end
			return
		end
		
		if isMouseInPosition(bgX, bgY + bgH - 30, bgX + bgW, bgY + bgH) then
			KeysShop.close()
		end
	
		for row = 0, rows - 1 do
			for col = 0, cols - 1 do
				index = index + 1
				if index <= totalKeys then
					local xPos = startX + col * (keyWidth + 20)
					local yPos = startY + row * (keyHeight + 20)
	
					if isMouseInPosition(xPos, yPos, keyWidth, keyHeight) then
						local keyInfos = KeysShop["Keys"][KeysShop.player_shop][apocalypseGetElementData(localPlayer, "language") or "EN"][index]
						local price_money, price_brain, key_name, key_level = keyInfos[2], keyInfos[3], keyInfos[1], keyInfos[4]
						local keyID = keyInfos[5]
						triggerServerEvent("KeysShop.buy", localPlayer, keyID, key_level, price_money, price_brain)
						return
					end
				end
			end
		end
	end
end

function KeysShop.openWindow(shop_id)
	if isWindowOpen() then
		KeysShop.player_shop = shop_id
		currentPage = 1
		totalKeys = #KeysShop["Keys"][shop_id][apocalypseGetElementData(localPlayer, "language") or "EN"]
		addEventHandler("onClientRender", root, KeysShop.renderWindow)
		addEventHandler("onClientClick", root, KeysShop.handleClick)
		setWindowData()
		showCursor(true)
		bindKey("backspace", "down", KeysShop.close)
	end
end

function KeysShop.close()
	removeEventHandler("onClientRender", root, KeysShop.renderWindow)
	removeEventHandler("onClientClick", root, KeysShop.handleClick)
	closeWindow()
	unbindKey("backspace", "down", KeysShop.close)
	NPC.Close()
end

addEventHandler("onClientPlayerWasted", root, function()
	if source == localPlayer then
		KeysShop.close()
	end
end)