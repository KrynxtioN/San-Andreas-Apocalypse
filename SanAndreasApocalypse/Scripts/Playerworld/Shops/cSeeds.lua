SeedsShop = {
	player_shop = 0,
	["Seeds"] = {
		[1] = {
			["EN"] = {
				[1] = {"Apple Seed", 10, "Files/Images/Inventory/82.png",82},
				[2] = {"Orange Seed", 10, "Files/Images/Inventory/83.png",83},
				[3] = {"Hemp Seed", 15, "Files/Images/Inventory/84.png",84},
				[4] = {"Cactus Seed", 100, "Files/Images/Inventory/122.png",122},
				[5] = {"Seed Mix", 50, "Files/Images/Inventory/94.png",94},
				[6] = {"Mushroom Seed", 25, "Files/Images/Inventory/210.png",210},
			},
			["DE"] = {
				[1] = {"Apfelsamen", 10, "Files/Images/Inventory/82.png",82},
				[2] = {"Orangensamen", 10, "Files/Images/Inventory/83.png",83},
				[3] = {"Hanfsamen", 15, "Files/Images/Inventory/84.png",84},
				[4] = {"Kaktussamen", 100, "Files/Images/Inventory/122.png",122},
				[5] = {"Samen Mix", 50, "Files/Images/Inventory/94.png",94},
				[6] = {"Pilzsamen", 25, "Files/Images/Inventory/210.png",210},
			},
			["RU"] = {
				[1] = {"Семя яблони", 10, "Files/Images/Inventory/82.png",82},
				[2] = {"Семя апельсина", 10, "Files/Images/Inventory/83.png",83},
				[3] = {"Семя конопли", 15, "Files/Images/Inventory/84.png",84},
				[4] = {"Семя кактуса", 100, "Files/Images/Inventory/122.png",122},
				[5] = {"Смесь семян", 50, "Files/Images/Inventory/94.png",94},
				[6] = {"Семена грибов", 25, "Files/Images/Inventory/210.png",210},
			},
			["PT"] = {
				[1] = {"Semente de Maçã", 10, "Files/Images/Inventory/82.png",82},
				[2] = {"Semente de Laranja", 10, "Files/Images/Inventory/83.png",83},
				[3] = {"Semente de Cânhamo", 15, "Files/Images/Inventory/84.png",84},
				[4] = {"Semente de Cacto", 100, "Files/Images/Inventory/122.png",122},
				[5] = {"Mix de Sementes", 50, "Files/Images/Inventory/94.png",94},
				[6] = {"Sementes de cogumelo", 25, "Files/Images/Inventory/210.png",210},
			},
		},
	},
}

local x, y = guiGetScreenSize()

local shopVisible = false
local SeedsPerPage = 8
local currentPage = 1
local totalSeeds = 0
local SeedsWidth, SeedsHeight = 180, 100

function SeedsShop.renderWindow()
	local bgW, bgH = (SeedsWidth + 20) * 4 + 80, (SeedsHeight + 20) * 2 + 80
	local bgX, bgY = (x - bgW) / 2, (y - bgH) / 2

	local title = getText("CSeedshop4")
	local titleHeight = 25
	local titleY = bgY - titleHeight - 10
	dxDrawText(title, bgX, titleY, bgX + bgW, titleY + titleHeight, tocolor(255, 255, 255, 255), 1.5, "default-bold", "center", "center")

	dxDrawRectangle(bgX - 4, bgY - 4, bgW + 8, bgH + 8, tocolor(220, 25, 25, 200))
	dxDrawRectangle(bgX, bgY, bgW, bgH, tocolor(50, 50, 50, 180))
	
	local rows, cols = 2, 4
	local totalSeedsWidth = cols * SeedsWidth + (cols - 1) * 20
	local startX = bgX + (bgW - totalSeedsWidth) / 2
	local startY = bgY + 40
	local index = (currentPage - 1) * SeedsPerPage
	
	for row = 0, rows - 1 do
		for col = 0, cols - 1 do
			index = index + 1

			if index <= totalSeeds then
				local xPos = startX + col * (SeedsWidth + 20)
				local yPos = startY + row * (SeedsHeight + 20)
				
				local lang = apocalypseGetElementData(localPlayer, "language") or "EN"
				local SeedsInfos = SeedsShop["Seeds"][SeedsShop.player_shop][lang][index]
				local name, price, image = SeedsInfos[1], SeedsInfos[2], SeedsInfos[3]
				
				local hovered = isMouseInPosition(xPos, yPos, SeedsWidth, SeedsHeight)
				local scale = hovered and 1.1 or 1
				local drawWidth = SeedsWidth * scale
				local drawHeight = SeedsHeight * scale
				local drawX = xPos - (drawWidth - SeedsWidth) / 2
				local drawY = yPos - (drawHeight - SeedsHeight) / 2
				
				if hovered then
					dxDrawRectangle(drawX - 4, drawY - 4, drawWidth + 8, drawHeight + 8, tocolor(0, 255, 255, 150))
				end
				
				dxDrawRectangle(drawX - 2, drawY - 2, drawWidth + 4, drawHeight + 4, tocolor(0, 0, 0, 200))
				dxDrawImage(drawX, drawY, drawWidth, drawHeight, image)

				if hovered then
					local infoText = getText("CSeedshop2"):format(price, name)
					local rectHeight = 50
					local rectY = drawY + drawHeight - rectHeight

					dxDrawRectangle(drawX, rectY, drawWidth, rectHeight, tocolor(0, 0, 0, 150))
					dxDrawText(infoText, drawX, rectY, drawX + drawWidth, rectY + rectHeight, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center")
				end
			end
		end
	end

	local arrowSize = 35

	if currentPage > 1 then
		dxDrawText("<", bgX - arrowSize, bgY + bgH / 2 - arrowSize / 2, bgX, bgY + bgH / 2 + arrowSize / 2, tocolor(255, 255, 255, 255), 2, "default-bold", "center", "center")
	end
	
	if currentPage * SeedsPerPage < totalSeeds then
		dxDrawText(">", bgX + bgW, bgY + bgH / 2 - arrowSize / 2, bgX + bgW + arrowSize, bgY + bgH / 2 + arrowSize / 2, tocolor(255, 255, 255, 255), 2, "default-bold", "center", "center")
	end
	
	dxDrawText(getText("CSeedshop3"), bgX, bgY + bgH - 30, bgX + bgW, bgY + bgH, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center", _, true)
end

function SeedsShop.handleClick(button, state)
	if button == "left" and state == "down" then
		local bgW, bgH = (SeedsWidth + 20) * 4 + 80, (SeedsHeight + 20) * 2 + 80
		local bgX, bgY = (x - bgW) / 2, (y - bgH) / 2
		local rows, cols = 2, 4
		local startX = bgX + (bgW - (cols * SeedsWidth + (cols - 1) * 20)) / 2
		local startY = bgY + 40
		local index = (currentPage - 1) * SeedsPerPage
		local arrowSize = 35

		if isMouseInPosition(bgX - arrowSize, bgY + bgH/2 - arrowSize/2, arrowSize, arrowSize) then
			currentPage = currentPage - 1
			if currentPage < 1 then currentPage = 1 end
			return
		end

		if isMouseInPosition(bgX + bgW, bgY + bgH/2 - arrowSize/2, arrowSize, arrowSize) then
			currentPage = currentPage + 1
			local maxPage = math.ceil(totalSeeds / SeedsPerPage)
			if currentPage > maxPage then currentPage = maxPage end
			return
		end
		
		if isMouseInPosition(bgX, bgY + bgH - 30, bgX + bgW, bgY + bgH) then
			SeedsShop.close()
		end
	
		for row = 0, rows - 1 do
			for col = 0, cols - 1 do
				index = index + 1
				if index <= totalSeeds then
					local xPos = startX + col * (SeedsWidth + 20)
					local yPos = startY + row * (SeedsHeight + 20)
	
					if isMouseInPosition(xPos, yPos, SeedsWidth, SeedsHeight) then
						local SeedsInfos = SeedsShop["Seeds"][SeedsShop.player_shop][apocalypseGetElementData(localPlayer, "language") or "EN"][index]
						local price = SeedsInfos[2]
						local SeedsID = SeedsInfos[4]
						triggerServerEvent("SeedsShop.buy", localPlayer, SeedsID, price)
						return
					end
				end
			end
		end
	end
end

function SeedsShop.openWindow(shop_id)
	if isWindowOpen() then
		SeedsShop.player_shop = shop_id
		currentPage = 1
		totalSeeds = #SeedsShop["Seeds"][shop_id][apocalypseGetElementData(localPlayer, "language") or "EN"]
		addEventHandler("onClientRender", root, SeedsShop.renderWindow)
		addEventHandler("onClientClick", root, SeedsShop.handleClick)
		setWindowData()
		showCursor(true)
		bindKey("backspace", "down", SeedsShop.close)
	end
end

function SeedsShop.close()
	removeEventHandler("onClientRender", root, SeedsShop.renderWindow)
	removeEventHandler("onClientClick", root, SeedsShop.handleClick)
	closeWindow()
	unbindKey("backspace", "down", SeedsShop.close)
	NPC.Close()
end

addEventHandler("onClientPlayerWasted", root, function()
	if source == localPlayer then
		SeedsShop.close()
	end
end)