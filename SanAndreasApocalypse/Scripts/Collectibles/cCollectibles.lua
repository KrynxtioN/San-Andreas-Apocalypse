Collectibles = {["Data"] = {}, open = false,
	["Categories"] = {
		["DE"] = {
			[1] = "Errungenschaften",
			[2] = "Dokumente",
			[3] = "Status",
			[4] = "Photos",
			[5] = "Herstellungsrezepte",
			[6] = "Orte",
			[7] = "Charaktere",
		},
		["EN"] = {
			[1] = "Achievements",
			[2] = "Documents",
			[3] = "Statuses",
			[4] = "Photos",
			[5] = "Crafting Recipes",
			[6] = "Places",
			[7] = "Characters",
		},
		["RU"] = {
			[1] = "Достижения",
			[2] = "Документы",
			[3] = "Статус",
			[4] = "Фотографии",
			[5] = "Рецепты крафта",
			[6] = "Места",
			[7] = "Персонажи",
		},
		["PT"] = {
			[1] = "Conquistas",
			[2] = "Documentos",
			[3] = "Status",
			[4] = "Fotos",
			[5] = "Receitas de Criação",
			[6] = "Locais",
			[7] = "Personagens",
		},
	},
}

local screenWidth, screenHeight = guiGetScreenSize()
local panelWidth, panelHeight = 200, screenHeight

local currentCategorie = 1
local scrollOffset = 0
local maxVisibleItems = 5
local itemHeight = 40
local selectedItem = nil
local lastClickTime = 0
local lastClickedItemID = nil
local doubleClickDelay = 500

local availableMaxItems = {
	[1] = 456,
	[2] = 9,
	[3] = 5,
	[4] = 5,
	[5] = 13,
	[6] = 22,
	[7] = 109,
}

local craftingRecipes = {
	[1] = {
		result = 163,
		grid = {
			{151,151,151},
			{153,152,153},
			{154,155,154},
		},
	},
	[2] = {
		result = 186,
		grid = {
			{157,157,157},
			{158,159,158},
			{162,162,162},
		},
	},
	[3] = {
		result = 169,
		grid = {
			{166,167,166},
			{160,165,160},
			{160,168,160},
		},
	},
	[4] = {
		result = 185,
		grid = {
			{28,28,28},
			{28,28,28},
			{28,28,28},
		},
	},
	[5] = {
		result = 26,
		grid = {
			{57,57,57},
			{57,57,57},
			{57,57,57},
		},
	},
	[6] = {
		result = 58,
		grid = {
			{160,160,160},
			{155,161,155},
			{81,81,81},
		},
	},
	[7] = {
		result = 164,
		grid = {
			{159,159,159},
			{156,158,156},
			{157,157,157},
		},
	},
	[8] = {
		result = 20,
		grid = {
			{19,19,19},
			{92,92,92},
			{19,19,19},
		},
	},
    [9] = {
        result = 106,
        grid = {
            {64, 64, 64},
            {66, 66, 66},
            {65, 65, 65},
        },
    },
	[10] = {
		result = 31,
		grid = {
			{0,149,0},
			{0,149,0},
			{0,148,0},
		},
	},
	[11] = {
		result = 146,
		grid = {
			{0,129,0},
			{129,129,129},
			{129,129,129},
		},
	},
	[12] = {
		result = 147,
		grid = {
			{0,130,0},
			{130,130,130},
			{130,130,130},
		},
	},
	[13] = {
		result = 35,
		grid = {
			{3,3,3},
			{3,3,3},
			{34,34,34},
		},
	},
}

local function drawCraftingGrid(recipeID, x, y, size)
    local recipe = craftingRecipes[recipeID]
    if not recipe then return end

    for row = 1, 3 do
        for col = 1, 3 do
            local itemID = recipe.grid[row][col]
            local rectX = x + (col - 1) * size
            local rectY = y + (row - 1) * size

            dxDrawRectangle(rectX, rectY, size, size, tocolor(50, 50, 50, 200))
            if itemID > 0 then
                local itemImage = "Files/Images/Inventory/" .. tostring(itemID) .. ".png"
                dxDrawImage(rectX, rectY, size, size, itemImage)
            end
        end
    end

    dxDrawRectangle(x + 3.5 * size, y + size, size, size, tocolor(100, 100, 100, 200))
    local resultImage = "Files/Images/Inventory/" .. tostring(recipe.result) .. ".png"
    dxDrawImage(x + 3.5 * size, y + size, size, size, resultImage)
end

local function isCollectibleCategory(category)
	return category == 1 or category == 2 or category == 3 or category == 4 or category == 6
end

local function getCollectedAmount(category, itemsInCategory)
	if not itemsInCategory then
		return 0
	end

	if isCollectibleCategory(category) then
		local amount = 0
		for _, item in ipairs(itemsInCategory) do
			if item.unlocked == true then
				amount = amount + 1
			end
		end
		return amount
	end

	return #itemsInCategory
end

function Collectibles.render()
    dxDrawRectangle(0, 0, panelWidth, panelHeight, tocolor(50, 50, 50, 200))

    local language = apocalypseGetElementData(localPlayer, "language") or "EN"
    local categoryText = Collectibles["Categories"][language][currentCategorie]
    dxDrawText(categoryText, 10, 10, panelWidth - 10, 50, tocolor(255, 255, 255, 255), 1.5, "default-bold", "center", "top")

    local itemsInCategory = Collectibles["Data"][currentCategorie]
    local collected = getCollectedAmount(currentCategorie, itemsInCategory)
    local maxItems = availableMaxItems[currentCategorie] or 1

    local progressText = collected .. "/" .. maxItems
    dxDrawText(progressText, 10, 50, panelWidth - 10, 70, tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "top")

    local barX, barY = 10, 80
    local barWidth, barHeight = panelWidth - 20, 20
    local progress = collected / maxItems
    local filledWidth = math.floor(barWidth * progress)

    dxDrawRectangle(barX, barY, barWidth, barHeight, tocolor(30, 30, 30, 200))
    dxDrawRectangle(barX, barY, barWidth, barHeight, tocolor(0, 0, 0, 255))
    dxDrawRectangle(barX, barY, filledWidth, barHeight, tocolor(0, 200, 0, 180))

    local percentText = string.format("%.0f%%", progress * 100)
    local textWidth = dxGetTextWidth(percentText, 1.0, "default-bold")
    local textHeight = dxGetFontHeight(1.0, "default-bold")
    local textX = barX + (barWidth - textWidth) / 2
    local textY = barY + (barHeight - textHeight) / 2

    dxDrawText(percentText, textX, textY, textX + textWidth, textY + textHeight, tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "center")

    if itemsInCategory and #itemsInCategory >= 1 then
        for i = 1, #itemsInCategory do
            local item = itemsInCategory[i]
            local itemY = 110 + (i - 1 - scrollOffset) * itemHeight

            if itemY >= 110 and itemY + itemHeight <= panelHeight then
                local isUnlocked = true
                if isCollectibleCategory(currentCategorie) then
                    isUnlocked = item.unlocked == true
                end

                local bgColor = isUnlocked and tocolor(70, 70, 70, 180) or tocolor(40, 40, 40, 180)
                local textColor = isUnlocked and tocolor(255, 255, 255, 255) or tocolor(140, 140, 140, 255)

                if isMouseInPosition(10, itemY, panelWidth - 20, itemHeight) then
                    bgColor = isUnlocked and tocolor(90, 90, 90, 220) or tocolor(55, 55, 55, 220)

                    local padding = 10
                    local desc = item.description or ""

                    if isCollectibleCategory(currentCategorie) and not isUnlocked then
                        desc = "???"
                    end

                    local hoverTextWidth = dxGetTextWidth(desc, 1.0, "default-bold") + 15
                    local hoverTextHeight = dxGetFontHeight(1.0, "default-bold") * #split(desc, "\n") + 15
                    local boxWidth = hoverTextWidth + 2 * padding
                    local boxHeight = hoverTextHeight + 2 * padding

                    local boxX = panelWidth + 10
                    local boxY = itemY + (itemHeight - boxHeight) / 2

                    if boxY < 10 then
                        boxY = 10
                    end

                    if boxY + boxHeight > panelHeight then
                        boxY = panelHeight - boxHeight - 10
                    end

                    if currentCategorie == 2 then
                        if isUnlocked then
                            local doc_imageW, doc_imageH = 512, 768
                            local doc_x = (screenWidth - doc_imageW) / 2
                            local doc_y = (screenHeight - doc_imageH) / 2
                            local docPadding = 40
                            local docTextX = doc_x + docPadding
                            local docTextY = doc_y + docPadding
                            local docTextW = doc_imageW - docPadding * 2
                            local docTextH = doc_imageH - docPadding * 2

                            dxDrawImage(doc_x, doc_y, doc_imageW, doc_imageH, "Files/Images/DocumentPaper.png")
                            dxDrawText(item.description or "", docTextX, docTextY, docTextX + docTextW, docTextY + docTextH,
                                tocolor(255, 255, 255, 255), 1.2, "default-bold", "left", "top", true, true, false)
                        else
                            dxDrawRectangle(boxX - 2, boxY - 2, boxWidth + 4, boxHeight + 4, tocolor(0, 0, 0, 75))
                            dxDrawRectangle(boxX, boxY, boxWidth, boxHeight, tocolor(30, 30, 30, 200))
                            dxDrawText(desc, boxX + padding, boxY + padding, boxX + boxWidth - padding, boxY + boxHeight - padding, tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "top")
                        end

                    elseif currentCategorie == 4 then
                        if isUnlocked and item.image then
                            local imgX = (screenWidth - 500) / 2
                            local imgY = (screenHeight - 500) / 2
                            dxDrawImage(imgX, imgY, 500, 500, item.image)
                        else
                            dxDrawRectangle(boxX - 2, boxY - 2, boxWidth + 4, boxHeight + 4, tocolor(0, 0, 0, 75))
                            dxDrawRectangle(boxX, boxY, boxWidth, boxHeight, tocolor(30, 30, 30, 200))
                            dxDrawText(desc, boxX + padding, boxY + padding, boxX + boxWidth - padding, boxY + boxHeight - padding, tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "top")
                        end

                    elseif currentCategorie == 6 then
                        if isUnlocked then
                            dxDrawRectangle(boxX - 2, boxY - 2, boxWidth + 4, boxHeight + 4, tocolor(0, 0, 0, 75))
                            dxDrawRectangle(boxX, boxY, boxWidth, boxHeight, tocolor(30, 30, 30, 200))
                            dxDrawText(desc, boxX + padding, boxY + padding, boxX + boxWidth - padding, boxY + boxHeight - padding, tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "top")

                            local tbl = DiscoverPlaces["CameraMatrix"][item.id]
                            if tbl then
                                if getElementInterior(localPlayer) == 0 and getElementDimension(localPlayer) == 0 then
                                    local x1, y1, z1, x2, y2, z2 = tbl[1], tbl[2], tbl[3], tbl[4], tbl[5], tbl[6]
                                    setCameraMatrix(x1, y1, z1, x2, y2, z2, 0, 70)
                                end
                            end
                        else
                            dxDrawRectangle(boxX - 2, boxY - 2, boxWidth + 4, boxHeight + 4, tocolor(0, 0, 0, 75))
                            dxDrawRectangle(boxX, boxY, boxWidth, boxHeight, tocolor(30, 30, 30, 200))
                            dxDrawText("???", boxX + padding, boxY + padding, boxX + boxWidth - padding, boxY + boxHeight - padding, tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "top")
                        end

                    elseif currentCategorie == 7 then
                        dxDrawRectangle(screenWidth*0.3, screenHeight*0.25, screenWidth*0.4, screenHeight*0.5, tocolor(0, 0, 0, 180))
                        dxDrawRectangle(screenWidth*0.32, screenHeight*0.27, screenWidth*0.1, screenHeight*0.25, tocolor(120, 120, 120, 255))
                        dxDrawImage(screenWidth*0.32, screenHeight*0.27, screenWidth*0.1, screenHeight*0.25, "Files/Images/Characters/"..item.model..".png")
                        dxDrawText("Name: "..item.name, screenWidth*0.44, screenHeight*0.27, screenWidth*0.68, screenHeight*0.3, tocolor(255,255,255,255), 1, "default-bold", "left", "top")
                        dxDrawText("Geschenke verschenkt: ", screenWidth*0.44, screenHeight*0.31, screenWidth*0.68, screenHeight*0.34, tocolor(255,255,255,255), 1, "default", "left", "top")
                        dxDrawText("Freundschaftsstatus:", screenWidth*0.44, screenHeight*0.35, screenWidth*0.68, screenHeight*0.38, tocolor(255,255,255,255), 1, "default", "left", "top")

                    else
                        dxDrawRectangle(boxX - 2, boxY - 2, boxWidth + 4, boxHeight + 4, tocolor(0, 0, 0, 75))
                        dxDrawRectangle(boxX, boxY, boxWidth, boxHeight, tocolor(30, 30, 30, 200))
                        dxDrawText(desc, boxX + padding, boxY + padding, boxX + boxWidth - padding, boxY + boxHeight - padding, tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "top")
                    end

                    if currentCategorie == 5 and item.id then
                        drawCraftingGrid(item.id, screenWidth - 200, screenHeight / 2 - 100, 40)
                    end
                end

                dxDrawRectangle(10, itemY, panelWidth - 20, itemHeight, bgColor)
                dxDrawText(item.name or "Unbekannt", 20, itemY + 10, panelWidth - 30, itemY + itemHeight - 10, textColor, 1.0, "default-bold", "left", "center")
            end
        end
    end

    local hintText = getText("CCollectibles1")
    local hintTextWidth = dxGetTextWidth(hintText, 1.0, "default")
    local hintTextHeight = dxGetFontHeight(1.0, "default")
    local hintX = panelWidth / 2 - hintTextWidth / 2
    local hintY = panelHeight - hintTextHeight - 20

    dxDrawText(hintText, hintX, hintY, hintX + hintTextWidth, hintY + hintTextHeight, tocolor(255, 255, 255, 200), 1.0, "default", "center", "top")
end

local function scrollList(direction)
    local itemsInCategory = Collectibles["Data"][currentCategorie]

	if itemsInCategory then
		if #itemsInCategory > maxVisibleItems then
			scrollOffset = scrollOffset + direction
			if scrollOffset < 0 then scrollOffset = 0 end
			if scrollOffset > #itemsInCategory - maxVisibleItems then
				scrollOffset = #itemsInCategory - maxVisibleItems
			end
		end
	end
end

local function changeCategory(direction)
    currentCategorie = currentCategorie + direction
    if currentCategorie < 1 then
		currentCategorie = #Collectibles["Categories"][apocalypseGetElementData(localPlayer,"language") or "EN"]
	end
    if currentCategorie > #Collectibles["Categories"][apocalypseGetElementData(localPlayer,"language") or "EN"] then
		currentCategorie = 1
	end
    selectedItem = nil
    scrollOffset = 0
	Collectibles.getData(currentCategorie)
	setCameraTarget(localPlayer)
end

local function onClientMouseWheel(key, state)
    if key == "mouse_wheel_up" then
        scrollList(-1)
    elseif key == "mouse_wheel_down" then
        scrollList(1)
    end
end

local function onClientKey(button, press)
    if press then
        if button == "arrow_l" then
            changeCategory(-1)
        elseif button == "arrow_r" then
            changeCategory(1)
        end
    end
end

local function onClientClick(button, state, absoluteX, absoluteY)
    if button ~= "left" or state ~= "down" then
        return
    end

    local itemsInCategory = Collectibles["Data"][currentCategorie]
    if not itemsInCategory then
        return
    end

    for i = 1, #itemsInCategory do
        local item = itemsInCategory[i]
        local itemY = 110 + (i - 1 - scrollOffset) * itemHeight

        if itemY >= 110 and itemY + itemHeight <= panelHeight then
            if isMouseInPosition(10, itemY, panelWidth - 20, itemHeight) then
                selectedItem = item

                if currentCategorie == 3 and item.id and item.unlocked == true then
                    local now = getTickCount()

                    if lastClickedItemID == item.id and (now - lastClickTime) <= doubleClickDelay then
                        triggerServerEvent("Status.changeStatus", localPlayer, item.id)
                        lastClickedItemID = nil
                        lastClickTime = 0
                    else
                        lastClickedItemID = item.id
                        lastClickTime = now
                    end
                end

                break
            end
        end
    end
end

bindKey("f2","down",function()
	if Collectibles.open == false then
		if isCharacterLoggedIn() and isWindowOpen() then
			showChat(false)
			setWindowData("no")
			showCursor(true)
			Collectibles.open = true
			addEventHandler("onClientRender",root,Collectibles.render)
			Collectibles.getData(currentCategorie)
			setPlayerHudComponentVisible("radar",false)

			bindKey("mouse_wheel_up", "down", onClientMouseWheel)
			bindKey("mouse_wheel_down", "down", onClientMouseWheel)
			addEventHandler("onClientKey", root, onClientKey)
			addEventHandler("onClientClick", root, onClientClick)
		end
	else
		showChat(true)
		Collectibles.open = false
		removeEventHandler("onClientRender",root,Collectibles.render)
		closeWindow("no")

		unbindKey("mouse_wheel_up", "down", onClientMouseWheel)
		unbindKey("mouse_wheel_down", "down", onClientMouseWheel)
		removeEventHandler("onClientKey", root, onClientKey)
		removeEventHandler("onClientClick", root, onClientClick)
		setCameraTarget(localPlayer)
	end
end)

function Collectibles.getData(category)
	if category == 1 then
		triggerServerEvent("Achievements.getData",localPlayer)
	elseif category == 2 then
		triggerServerEvent("Documents.getData",localPlayer)
	elseif category == 3 then
		triggerServerEvent("Status.getData",localPlayer)
	elseif category == 4 then
		triggerServerEvent("Photos.getData",localPlayer)
	elseif category == 5 then
		triggerServerEvent("CraftingRecipes.getData",localPlayer)
	elseif category == 6 then
		triggerServerEvent("DiscoverPlaces.getData",localPlayer)
	elseif category == 7 then
		triggerServerEvent("PlayerCharacters.getData",localPlayer)
	end
end

addEvent("Collectibles.updateData",true)
addEventHandler("Collectibles.updateData",root,function(Data)
	Collectibles["Data"][currentCategorie] = Data
end)

addEventHandler("onClientPlayerWasted",root,function(player)
	if player == localPlayer then
		if Collectibles.open == true then
			showCursor(false)
			Collectibles.open = false
			removeEventHandler("onClientRender",root,Collectibles.render)
			apocalypseSetElementData(localPlayer,"OpenWindow",false)

			unbindKey("mouse_wheel_up", "down", onClientMouseWheel)
			unbindKey("mouse_wheel_down", "down", onClientMouseWheel)
			removeEventHandler("onClientKey", root, onClientKey)
			removeEventHandler("onClientClick", root, onClientClick)
		end
	end
end)