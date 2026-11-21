Inventory = {
	["CategorieText"] = {
		["EN"] = {["items"] = "Items", ["keys"] = "Keys", ["heads"] = "Heads", ["outfits"] = "Outfits", ["weapons"] = "Weapons", ["furniture"] = "Furniture", ["ammo"] = "Ammo"},
		["DE"] = {["items"] = "Items", ["keys"] = "Keys", ["heads"] = "Hüte", ["outfits"] = "Outfits", ["weapons"] = "Waffen", ["furniture"] = "Möbel", ["ammo"] = "Munition"}, 
		["RU"] = {["items"] = "Предметы", ["keys"] = "Ключи", ["heads"] = "Головы", ["outfits"] = "Одежда", ["weapons"] = "Оружие", ["furniture"] = "Мебель", ["ammo"] = "Патроны"},
		["PT"] = {["items"] = "Itens", ["keys"] = "Chaves", ["heads"] = "Cabeças", ["outfits"] = "Roupas", ["weapons"] = "Armas", ["furniture"] = "Móveis", ["ammo"] = "Munição"},
	},
	itemSubCategories = {"all", "food", "remedies", "consumables", "crates", "resources", "objects","fish","cards"},
	selectedItemSubCategory = "all",
	ItemSubCategorieText = {
		["EN"] = {all = "All", food = "Food/Drinks", remedies = "Remedies", consumables = "Consumables", crates = "Crates", resources = "Resources", objects = "Objects", fish = "Fish", cards = "Trading Cards"},
		["DE"] = {all = "Alle", food = "Essen/Trinken", remedies = "Heilmittel", consumables = "Konsumierbares", crates = "Kisten", resources = "Ressourcen", objects = "Objekte", fish = "Fische", cards = "Sammelkarten"},
		["RU"] = {all = "Все", food = "Еда/Напитки", remedies = "Лекарства", consumables = "Расходники", crates = "Ящики", resources = "Ресурсы", objects = "Объекты", fish = "Рыбы", "Коллекционные карты"},
		["PT"] = {all = "Todos", food = "Comidas/Bebidas", remedies = "Remédios", consumables = "Consumíveis", crates = "Caixas", resources = "Recursos", objects = "Objetos", fish = "Peixes", cards = "Cartas Colecionáveis"},
	},
	AmmoCraftText = {
		["EN"] = "Click ammo to craft. Cost: weapon parts",
		["DE"] = "Klicke Munition zum Herstellen. Kosten: Waffenteile",
		["RU"] = "Нажмите на патроны для крафта. Цена: детали оружия",
		["PT"] = "Clique na munição para fabricar. Custo: peças de arma",
	},
	itemSubCategoryMapping = {
		[2] = "consumables",
		[19] = "consumables",
		[20] = "consumables",
		
		[28] = "remedies",
		
		[68] = "crates",
		[69] = "crates",
		[72] = "crates",
		[73] = "crates",
		[74] = "crates",
		[75] = "crates",
		[76] = "crates",
		[77] = "crates",
		
		[18] = "food",
		[29] = "food",
		[33] = "food",
		[36] = "food",
		[41] = "food",
		[42] = "food",
		[43] = "food",
		[49] = "food",
		[50] = "food",
		[51] = "food",
		[52] = "food",
		[59] = "food",
		[60] = "food",
		[61] = "food",
		[95] = "food",
		[96] = "food",
		[97] = "food",
		[98] = "food",
		[99] = "food",
		[100] = "food",
		[101] = "food",
		[117] = "food",
		[124] = "food",
		[125] = "food",
		[126] = "food",
		[176] = "food",
		[177] = "food",
		[178] = "food",
		[179] = "food",
		[182] = "food",
		
		[34] = "resources",
		[78] = "resources",
		[79] = "resources",
		[80] = "resources",
		[81] = "resources",
		[86] = "resources",
		[87] = "resources",
		[88] = "resources",
		[89] = "resources",
		[90] = "resources",
		[91] = "resources",
		[114] = "resources",
		[115] = "resources",
		[118] = "resources",
		[151] = "resources",
		[152] = "resources",
		[153] = "resources",
		[154] = "resources",
		[155] = "resources",
		[156] = "resources",
		[157] = "resources",
		[158] = "resources",
		[159] = "resources",
		[160] = "resources",
		[161] = "resources",
		[162] = "resources",
		[163] = "resources",
		[165] = "resources",
		[166] = "resources",
		[167] = "resources",
		[168] = "resources",
		
		[10] = "collectibles",
		[11] = "collectibles",
		[12] = "collectibles",
		[14] = "collectibles",
		[36] = "collectibles",
		[37] = "collectibles",
		[38] = "collectibles",
		[132] = "collectibles",
		[180] = "collectibles",
		
		[35] = "objects",
		[123] = "objects",
		[116] = "objects",
		[127] = "objects",
		[131] = "objects",
		[181] = "objects",
	
		[211] = "cards",
		[212] = "cards",
		[213] = "cards",
		[214] = "cards",
		[215] = "cards",
		[216] = "cards",
		[217] = "cards",
		[218] = "cards",
		[219] = "cards",
		[220] = "cards",
		[221] = "cards",
		[222] = "cards",
		[223] = "cards",
		[224] = "cards",
		[225] = "cards",
		[226] = "cards",
		[227] = "cards",
		[228] = "cards",
		[229] = "cards",
		[230] = "cards",
		[231] = "cards",
		[232] = "cards",
		[233] = "cards",
		[234] = "cards",
		[235] = "cards",
		[236] = "cards",
		[237] = "cards",
		[238] = "cards",
		[239] = "cards",
		[240] = "cards",
	},
	Open = false,
	selectedCategory = "items",
	categories = {"items", "keys", "heads", "outfits", "weapons", "furniture", "ammo"},
	playerInventory = {items = {}, keys = {}, heads = {}, outfits = {}, weapons = {}, furniture = {}},
	itemOrder = {1,14,5},
}

local InventoryAmmoFactory = {
	[1] = {ammoType = 1, itemID = 44, cost = 2},
	[2] = {ammoType = 2, itemID = 45, cost = 4},
	[3] = {ammoType = 3, itemID = 46, cost = 4},
	[4] = {ammoType = 4, itemID = 47, cost = 8},
}

local InventoryAmmoFactoryNames = {
	["EN"] = {
		[1] = "Ammo: Handguns",
		[2] = "Ammo: Submachine Guns",
		[3] = "Ammo: Assault Rifles",
		[4] = "Ammo: Rifles",
	},
	["DE"] = {
		[1] = "Munition: Pistolen",
		[2] = "Munition: Maschinenpistolen",
		[3] = "Munition: Sturmgewehre",
		[4] = "Munition: Gewehre",
	},
	["RU"] = {
		[1] = "Патроны: Пистолеты",
		[2] = "Патроны: ПП",
		[3] = "Патроны: Штурмовые винтовки",
		[4] = "Патроны: Винтовки",
	},
	["PT"] = {
		[1] = "Munição: Pistolas",
		[2] = "Munição: Submetralhadoras",
		[3] = "Munição: Rifles de Assalto",
		[4] = "Munição: Rifles",
	},
}

local screenWidth, screenHeight = guiGetScreenSize()

local ClickableItemsInInventory = {2,5,6,7,13,15,16,17,18,19,20,28,29,33,35,36,37,38,41,42,43,44,45,46,47,49,50,51,52,59,60,61,68,69,72,73,74,75,76,77,82,83,84,93,94,95,96,97,98,99,100,101,103,104,105,106,117,121,124,125,126,127,131,133,134,135,136,137,138,139,140,141,142,143,145,146,147,169,176,177,178,179,181,182,184,185,186,187,198,202,205,206,207,209,210,241}

local inventorySlotsPerPage = 32
local currentPage = 1
local blockSize = 60
local padding = 5

local animationStartTimeWeaponbar = nil
local animationDurationWeaponbar = 500
animationWeaponbarTimer1 = nil
animationWeaponbarTimer2 = nil

function Inventory.getPlayerItemAmount(itemID)
	local amount = 0
	for _, item in ipairs(Inventory.playerInventory.items) do
		if item.id == itemID then
			amount = amount + item.amount
		end
	end
	return amount
end

function Inventory.getDisplayItems()
	if Inventory.selectedCategory == "items" then
		local displayItems = {}
		for _, item in ipairs(Inventory.playerInventory.items) do
			local itemCat = Inventory.itemSubCategoryMapping[item.id] or "other"
			if Inventory.selectedItemSubCategory == "all" or itemCat == Inventory.selectedItemSubCategory then
				table.insert(displayItems, item)
			end
		end

		local orderMapping = {}
		for index, id in ipairs(Inventory.itemOrder or {}) do
			orderMapping[id] = index
		end

		table.sort(displayItems, function(a, b)
			local orderA = orderMapping[a.id] or math.huge
			local orderB = orderMapping[b.id] or math.huge
			return orderA < orderB
		end)
		return displayItems
	elseif Inventory.selectedCategory == "ammo" then
		return {}
	else
		return Inventory.playerInventory[Inventory.selectedCategory]
	end
end

function isInventoryOpen()
	return Inventory.Open
end

function UpdatePlayerFurnitureForInventory()
    Inventory.playerInventory.furniture = {}
    for _, v in pairs(PlayerFurniture) do 
        table.insert(Inventory.playerInventory.furniture, {
            id = tonumber(v.id),
            amount = tonumber(v.amount)
        })
    end
end

function UpdatePlayerItemsForInventory()
    Inventory.playerInventory.items = {}
    for _, v in pairs(PlayerItems) do 
        table.insert(Inventory.playerInventory.items, {id = v.item, amount = v.amount})
    end
end

function UpdatePlayerKeysForInventory()
	Inventory.playerInventory.keys = {}
	for _,v in pairs(PlayerKeys)do
		table.insert(Inventory.playerInventory.keys, {id = v.key, amount = v.amount})
	end
end

function UpdatePlayerHeadsForInventory()
	Inventory.playerInventory.heads = {}
	for _,v in pairs(PlayerHeads)do
		table.insert(Inventory.playerInventory.heads, {id = v.head, amount = v.amount})
	end
end

function UpdatePlayerOutfitsForInventory()
	Inventory.playerInventory.outfits = {}
	for _,v in pairs(PlayerOutfits)do
		table.insert(Inventory.playerInventory.outfits, {id = v.outfit, amount = v.amount})
	end
end

function UpdatePlayerWeaponsForInventory()
	Inventory.playerInventory.weapons = {}
	PlayerWeaponsOnHand = {}
	for _,v in pairs(PlayerWeapons)do
		if(v[5] == 0)then
			table.insert(Inventory.playerInventory.weapons, {id = v[1], amount = v[2], databaseID = v[4]})
		else
			table.insert(PlayerWeaponsOnHand,{id = v[1], amount = v[2], databaseID = v[4]})
		end
	end
end

local inventoryWidth = blockSize * 8 + padding * 9
local inventoryHeight = blockSize * 4 + padding * 5
local inventoryX, inventoryY = (screenWidth - inventoryWidth) / 2, (screenHeight - inventoryHeight) / 2
local blocksPerRow = 8
local buttonWidth, buttonHeight = 150, 40
local buttonX, buttonY = inventoryX + inventoryWidth + 10, inventoryY

function Inventory.drawAmmoFactory()
	local lang = apocalypseGetElementData(localPlayer, "language") or "EN"
	local weaponParts = Inventory.getPlayerItemAmount(22)

	dxDrawText(getText("CInventory8"), inventoryX, inventoryY + 10, inventoryX + inventoryWidth, inventoryY + 35, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center")
	dxDrawText(getText("CInventory9"):format(weaponParts), inventoryX, inventoryY + 35, inventoryX + inventoryWidth, inventoryY + 60, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center")

	for i, data in ipairs(InventoryAmmoFactory) do
		local boxWidth = inventoryWidth - padding * 2
		local boxHeight = 45
		local boxX = inventoryX + padding
		local boxY = inventoryY + 70 + (i - 1) * (boxHeight + padding)

		local canCraft = weaponParts >= data.cost
		local color = canCraft and tocolor(50, 50, 50, 200) or tocolor(80, 20, 20, 200)

		dxDrawRectangle(boxX, boxY, boxWidth, boxHeight, color)
		dxDrawImage(boxX + 8, boxY + 5, 35, 35, "Files/Images/Inventory/" .. data.itemID .. ".png", _, _, _, true)

		dxDrawText(
			InventoryAmmoFactoryNames[lang][data.ammoType],
			boxX + 50,
			boxY,
			boxX + boxWidth - 100,
			boxY + boxHeight,
			tocolor(255, 255, 255, 255),
			1,
			"default-bold",
			"left",
			"center"
		)

		dxDrawText(data.cost .. "x", boxX + boxWidth - 90, boxY, boxX + boxWidth - 50, boxY + boxHeight, tocolor(255, 255, 255, 255), 1, "default-bold", "right", "center")
		dxDrawImage(boxX + boxWidth - 45, boxY + 5, 35, 35, "Files/Images/Inventory/22.png", _, _, _, true)

		if isMouseInPosition(boxX, boxY, boxWidth, boxHeight) then
			dxDrawRectangle(boxX, boxY, boxWidth, boxHeight, tocolor(0, 0, 0, 100), false)
		end
	end
end

function Inventory.draw()
	if(tonumber(apocalypseGetElementData(localPlayer,"level")) >= 25)then
		dxDrawRectangle(buttonX, buttonY, buttonWidth, buttonHeight, tocolor(50, 50, 50, 200))
		dxDrawText(getText("CCraftMenu1"), buttonX, buttonY, buttonX + buttonWidth, buttonY + buttonHeight, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center")
	end

    dxDrawRectangle(inventoryX, inventoryY, inventoryWidth, inventoryHeight, tocolor(0, 0, 0, 150))

	for i, v in ipairs(Inventory.categories) do
		if v == "ammo" and hasPlayerItem(207) < 1 then

		else
			local categoryX = inventoryX + (i - 1) * (inventoryWidth / #Inventory.categories)
			local categoryY = inventoryY - 40
			local categoryWidth = inventoryWidth / #Inventory.categories
			local categoryHeight = 30

			dxDrawRectangle(categoryX, categoryY, categoryWidth, categoryHeight, tocolor(50, 50, 50, 200))
			dxDrawText(Inventory["CategorieText"][apocalypseGetElementData(localPlayer, "language") or "EN"][v], categoryX, categoryY, categoryX + categoryWidth, categoryY + categoryHeight, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center", _, _, true)

			if Inventory.selectedCategory == v then
				dxDrawRectangle(categoryX, categoryY, categoryWidth, categoryHeight, tocolor(0, 0, 0, 100), false)
			end
		end
	end
	
	if Inventory.selectedCategory == "items" then
		local subCatWidth = 120
		local subCatHeight = 30
		local subCatX = inventoryX - subCatWidth - padding
		local firstSubCatY = inventoryY
		local lang = apocalypseGetElementData(localPlayer, "language") or "EN"
		for i, subCat in ipairs(Inventory.itemSubCategories) do
			local buttonY = firstSubCatY + (i-1) * (subCatHeight + padding)
			local color = tocolor(50, 50, 50, 200)
			if Inventory.selectedItemSubCategory == subCat then
				color = tocolor(0, 0, 0, 100)
			end
			dxDrawRectangle(subCatX, buttonY, subCatWidth, subCatHeight, color)
			local text = Inventory.ItemSubCategorieText[lang][subCat]
			dxDrawText(text, subCatX, buttonY, subCatX + subCatWidth, buttonY + subCatHeight, tocolor(255,255,255,255), 1, "default-bold", "center", "center")
		end
	end

	if Inventory.selectedCategory == "ammo" then
		Inventory.drawAmmoFactory()
		return
	end

	local infoText = ""
	if(Inventory.selectedCategory == "items")then
		infoText = getText("CInventory3")
	elseif(Inventory.selectedCategory == "keys")then
		infoText = getText("CInventory4")
	elseif(Inventory.selectedCategory == "heads")then
		infoText = getText("CInventory5")
	elseif(Inventory.selectedCategory == "outfits")then
		infoText = getText("CInventory6")
	elseif(Inventory.selectedCategory == "weapons")then
		infoText = getText("CInventory7")
	end
		
    local infoTextWidth = dxGetTextWidth(infoText, 1, "default-bold")
    local infoTextX = (screenWidth - infoTextWidth) / 2
    local infoTextY = inventoryY + inventoryHeight + 10

	dxDrawText(infoText, infoTextX, infoTextY, infoTextX + infoTextWidth, infoTextY + 20, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center")

	local displayItems = Inventory.getDisplayItems()
	
    for i = 1, inventorySlotsPerPage do
		local row = math.floor((i - 1) / blocksPerRow)
        local column = (i - 1) % blocksPerRow

        local blockX = inventoryX + padding + column * (blockSize + padding)
        local blockY = inventoryY + padding + row * (blockSize + padding)

        dxDrawRectangle(blockX, blockY, blockSize, blockSize, tocolor(255, 255, 255, 50))

        if (#displayItems >= 1) then
            local item = displayItems[(currentPage - 1) * inventorySlotsPerPage + i]

            if (item) then
                local imagePath = nil
				if(item.id)then
					if (Inventory.selectedCategory == "items") then
						imagePath = "Files/Images/Inventory/" .. item.id .. ".png" 
					elseif (Inventory.selectedCategory == "keys") then
						imagePath = "Files/Images/Inventory/Keys/Key.png"
					elseif (Inventory.selectedCategory == "outfits") then
						imagePath = "Files/Images/Inventory/Outfits/"..item.id..".png"
					elseif (Inventory.selectedCategory == "heads") then
						imagePath = "Files/Images/Inventory/Heads/"..item.id..".png"
					elseif (Inventory.selectedCategory == "weapons")then
						imagePath = "Files/Images/Weapons/"..item.id..".png"
					elseif (Inventory.selectedCategory == "furniture")then
						if(fileExists("Files/Images/Furniture/"..item.id..".jpg"))then
							imagePath = "Files/Images/Furniture/"..item.id..".jpg"
						else
							imagePath = "Files/Images/Furniture/NoImage.png"
						end
					end
				end
                if (imagePath) then
                    dxDrawImage(blockX, blockY, blockSize, blockSize, imagePath, _, _, _, true)
					if(Inventory.selectedCategory == "items" or Inventory.selectedCategory == "weapons" or Inventory.selectedCategory == "furniture")then
						dxDrawText(math.floor(item.amount), blockX, blockY, blockX + blockSize, blockY + blockSize, tocolor(255, 255, 255, 255), 1.2, "default-bold", "center", "center", _, _, true)
					end
                    
                    local isClickable = false
                    for _, clickableID in ipairs(ClickableItemsInInventory) do
                        if item.id == clickableID then
                            isClickable = true
                            break
                        end
                    end
					
					if(Inventory.selectedCategory == "items")then
						if isClickable then
							dxDrawRectangle(blockX, blockY, blockSize, blockSize, tocolor(255, 215, 0, 35), false)
						end
					end
                end
            end

            if (isMouseInPosition(blockX, blockY, blockSize, blockSize)) then
                dxDrawRectangle(blockX, blockY, blockSize, blockSize, tocolor(0, 0, 0, 100), false)

                local item = displayItems[(currentPage - 1) * inventorySlotsPerPage + i]

                local infoBoxWidth = 200
                local infoBoxHeight = 50
                local infoBoxX = (screenWidth - infoBoxWidth) / 2
                local infoBoxY = inventoryY - 100

                if (item) then
					local weight = itemWeights[item.id]
					if(not(weight))then weight = "/" end
                    dxDrawRectangle(infoBoxX, infoBoxY, infoBoxWidth, infoBoxHeight, tocolor(0, 0, 0, 200))
					if(ItemInfos[Inventory.selectedCategory][apocalypseGetElementData(localPlayer, "language") or "EN"][item.id])then
						dxDrawText(ItemInfos[Inventory.selectedCategory][apocalypseGetElementData(localPlayer, "language") or "EN"][item.id].. " ("..weight.."kg)", infoBoxX, infoBoxY, infoBoxX + infoBoxWidth, infoBoxY + infoBoxHeight, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center")
					end
                end
            end
        end
    end
end

function Inventory.drawWeaponBar()
    local screenWidth, screenHeight = guiGetScreenSize()
    local barHeight = 60
    local barWidth = 10 * 50 + 9 * 5
    local barX = (screenWidth - barWidth) / 2
    local targetBarY = screenHeight - barHeight - 20
    local startBarY = screenHeight + barHeight + 20
    local barY = targetBarY

    if not animationStartTimeWeaponbar then
        animationStartTimeWeaponbar = getTickCount()
    end

    local now = getTickCount()
    local elapsedTime = now - animationStartTimeWeaponbar

    if isWeaponBarHiding then
        if elapsedTime < animationDurationWeaponbar then
            local progress = elapsedTime / animationDurationWeaponbar
            barY = interpolateBetween(targetBarY, 0, 0, startBarY, 0, 0, progress, "Linear")
        else
            removeEventHandler("onClientRender", root, Inventory.drawWeaponBar)
            isWeaponBarHiding = false
            return
        end
    else
        if elapsedTime < animationDurationWeaponbar then
            local progress = elapsedTime / animationDurationWeaponbar
            barY = interpolateBetween(startBarY, 0, 0, targetBarY, 0, 0, progress, "Linear")
        else
            barY = targetBarY
        end
    end

    local slotSize = 50

    dxDrawRectangle(barX - 5, barY - 5, barWidth + 10, barHeight + 10, tocolor(0, 0, 0, 150))
    dxDrawRectangle(barX, barY, barWidth, barHeight, tocolor(0, 0, 0, 200))
    
    if (#PlayerWeaponsOnHand >= 1) then
        for i, v in pairs(PlayerWeaponsOnHand) do
            local slotX = barX + (i - 1) * (slotSize + 5)
            local slotY = barY + 5

            if i == PlayerSelectedWeapon then
                dxDrawRectangle(slotX - 2, slotY - 2, slotSize + 4, slotSize + 4, tocolor(255, 255, 0, 200))
            end
            
            dxDrawRectangle(slotX, slotY, slotSize, slotSize, tocolor(40, 40, 40, 150))
            dxDrawRectangle(slotX + 3, slotY + 3, slotSize - 6, slotSize - 6, tocolor(60, 60, 60, 100))
            
            local weaponID = v[1] or v.id
            local ammo = v[2] or v.amount
            local imagePath = "Files/Images/Weapons/" .. weaponID .. ".png" 

            dxDrawImage(slotX + 5, slotY + 5, slotSize - 10, slotSize - 10, imagePath)
            dxDrawRectangle(slotX + 5, slotY + slotSize - 15, slotSize - 10, 15, tocolor(0, 0, 0, 150), true)
            dxDrawText(ammo, slotX + 5, slotY + slotSize - 15, slotX + slotSize - 5, slotY + slotSize, tocolor(255, 255, 255, 255), 1.2, "default-bold", "center", "center", _, _, true)
        end
    end
end

function Inventory.weaponBarClick(button, state)
    if button == "left" and state == "down" then
        local screenWidth, screenHeight = guiGetScreenSize()
        local barHeight = 60
        local barWidth = 10 * 50 + 9 * 5
        local barX = (screenWidth - barWidth) / 2
        local barY = screenHeight - barHeight - 20
        local slotSize = 50

        if #PlayerWeaponsOnHand >= 1 then
            for i, v in pairs(PlayerWeaponsOnHand) do
                local slotX = barX + (i - 1) * (slotSize + 5)
                local slotY = barY + 5
				
                if(isMouseInPosition(slotX, slotY, slotSize, slotSize))then
                    triggerServerEvent("PlayerWeapons.storeWeapon", localPlayer, v.databaseID)
                    return
                end
            end
        end
    end
end

function Inventory.showWeaponBar()
    if(not(isTimer(animationWeaponbarTimer2)))then
        animationStartTimeWeaponbar = nil
        animationDurationWeaponbar = 500
        isWeaponBarHiding = false
        addEventHandler("onClientRender", root, Inventory.drawWeaponBar)
        
       animationWeaponbarTimer1 = setTimer(function()
			isWeaponBarHiding = true
            animationStartTimeWeaponbar = getTickCount()
        end, 3000, 1)
		animationWeaponbarTimer2 = setTimer(function()
			removeEventHandler("onClientRender", root, Inventory.drawWeaponBar)
		end,4000,1)
    end
end
addEvent("Inventory.showWeaponBar", true)
addEventHandler("Inventory.showWeaponBar", root, Inventory.showWeaponBar)

function Inventory.switchPage(direction)
    local displayItems = Inventory.getDisplayItems()
    local maxPages = math.ceil(#displayItems / inventorySlotsPerPage)
    if(direction == "left" and currentPage > 1)then
        currentPage = currentPage - 1
    elseif(direction == "right" and currentPage < maxPages)then
        currentPage = currentPage + 1
    end
end

function Inventory.click(button, state, absoluteX, absoluteY)
    if(button == "left" and state == "down")then
		if Inventory.selectedCategory == "ammo" then
			for i, data in ipairs(InventoryAmmoFactory) do
				local boxWidth = inventoryWidth - padding * 2
				local boxHeight = 45
				local boxX = inventoryX + padding
				local boxY = inventoryY + 70 + (i - 1) * (boxHeight + padding)

				if(isMouseInPosition(boxX, boxY, boxWidth, boxHeight))then
					triggerServerEvent("WeaponFactory.craft", localPlayer, data.ammoType, 1, "inv")
					return
				end
			end
		end

		if Inventory.selectedCategory == "items" then
			local subCatWidth = 120
			local subCatHeight = 30
			local subCatX = inventoryX - subCatWidth - padding
			local firstSubCatY = inventoryY
			for i, subCat in ipairs(Inventory.itemSubCategories) do
				local buttonY = firstSubCatY + (i-1) * (subCatHeight + padding)
				if(isMouseInPosition(subCatX, buttonY, subCatWidth, subCatHeight))then
					Inventory.selectedItemSubCategory = subCat
					currentPage = 1
					return
				end
			end
		end

        for i, v in ipairs(Inventory.categories) do
            local categoryX = inventoryX + (i - 1) * (inventoryWidth / #Inventory.categories)
            local categoryY = inventoryY - 40
            local categoryWidth = inventoryWidth / #Inventory.categories
            local categoryHeight = 30
			
			if(isMouseInPosition(categoryX, categoryY, categoryWidth, categoryHeight))then
                Inventory.selectedCategory = v
				if(v ~= "items") then
					Inventory.selectedItemSubCategory = "all"
				end
                currentPage = 1
                return
            end
        end

		if(isMouseInPosition(buttonX, buttonY, buttonWidth, buttonHeight))then
			if(tonumber(apocalypseGetElementData(localPlayer,"level")) >= 25)then
				triggerServerEvent("CraftingRecipes.getData", localPlayer)
				
				dxDrawRectangle(buttonX, buttonY, buttonWidth, buttonHeight, tocolor(100, 100, 100, 200))
				addEventHandler("onClientRender", root, renderCraftingPanel)
				addEventHandler("onClientClick", root, onMouseClickCrafting)
				bindKey("mouse_wheel_up", "down", craftingPanelScrollUp)
				bindKey("mouse_wheel_down", "down", craftingPanelScrollDown)
				setWindowData("no")
				
				Inventory.Open = false
				removeEventHandler("onClientRender", root, Inventory.draw)
				removeEventHandler("onClientClick", root, Inventory.click)
				removeEventHandler("onClientClick", root, Inventory.rightClick)
				removeEventHandler("onClientClick", root, Inventory.weaponBarClick)
				removeEventHandler("onClientClick", root, Inventory.weaponClick)
				removeEventHandler("onClientDoubleClick", root, Inventory.doubleClick)
				removeEventHandler("onClientRender",root,Inventory.drawWeaponBar)
				Radio.close()
			end
		end
    end
end

function Inventory.weaponClick(button, state, absoluteX, absoluteY)
    if(button == "left" and state == "down" and Inventory.selectedCategory == "weapons") then
        local inventoryX, inventoryY = (screenWidth - inventoryWidth) / 2, (screenHeight - inventoryHeight) / 2
        local blocksPerRow = 8
		
		if(#PlayerWeaponsOnHand < 10)then
			for i = 1, inventorySlotsPerPage do
				local row = math.floor((i - 1) / blocksPerRow)
				local column = (i - 1) % blocksPerRow

				local blockX = inventoryX + padding + column * (blockSize + padding)
				local blockY = inventoryY + padding + row * (blockSize + padding)

				if(isMouseInPosition(blockX, blockY, blockSize, blockSize)) then
					local categoryItems = Inventory.playerInventory[Inventory.selectedCategory]
					local weapon = categoryItems and categoryItems[(currentPage - 1) * inventorySlotsPerPage + i]

					if(weapon)then
						triggerServerEvent("PlayerWeapons.takeWeapon",localPlayer,weapon.databaseID)
						return
					end
				end
			end
		end
    end
end

function Inventory.doubleClick(button, absoluteX, absoluteY)
    if(button == "left") then
        local inventoryX, inventoryY = (screenWidth - inventoryWidth) / 2, (screenHeight - inventoryHeight) / 2
        local blocksPerRow = 8
		
        for i = 1, inventorySlotsPerPage do
            local row = math.floor((i - 1) / blocksPerRow)
            local column = (i - 1) % blocksPerRow

            local blockX = inventoryX + padding + column * (blockSize + padding)
            local blockY = inventoryY + padding + row * (blockSize + padding)

            if(isMouseInPosition(blockX, blockY, blockSize, blockSize)) then
                local displayItems = Inventory.getDisplayItems()
                local item = displayItems and displayItems[(currentPage - 1) * inventorySlotsPerPage + i]

                if(item)then
					if(Inventory.selectedCategory == "items")then
						if(item.id == 5)then
							Radio.open()
						else
							triggerServerEvent("onPlayerItemDoubleClicked", localPlayer, item.id)
						end
					elseif(Inventory.selectedCategory == "outfits")then
						triggerServerEvent("onPlayerOutfitDoubleClicked", localPlayer, item.id)
					elseif(Inventory.selectedCategory == "heads")then
						triggerServerEvent("onPlayerHeadDoubleClicked", localPlayer, item.id)
					elseif(Inventory.selectedCategory == "furniture")then
						apocalypseSetElementData(localPlayer,"furniture_shop",true)
						Objectsystem.createObject(item.id)
					end
                    return
                end
            end
        end
    end
end

function Inventory.rightClick(button, state, absoluteX, absoluteY)
    if(button == "right" and state == "down")then
        local inventoryX, inventoryY = (screenWidth - inventoryWidth) / 2, (screenHeight - inventoryHeight) / 2
        local blocksPerRow = 8
		
        for i = 1, inventorySlotsPerPage do
            local row = math.floor((i - 1) / blocksPerRow)
            local column = (i - 1) % blocksPerRow

            local blockX = inventoryX + padding + column * (blockSize + padding)
            local blockY = inventoryY + padding + row * (blockSize + padding)

            if(isMouseInPosition(blockX, blockY, blockSize, blockSize)) then
                local categoryItems = Inventory.playerInventory[Inventory.selectedCategory]
                local item = categoryItems and categoryItems[(currentPage - 1) * inventorySlotsPerPage + i]

                if(item)then
					if(Inventory.selectedCategory == "outfits")then
						triggerServerEvent("removePlayerOutfit", localPlayer, item.id)
					elseif(Inventory.selectedCategory == "heads")then
						triggerServerEvent("removePlayerHead", localPlayer)
					end
                    return
                end
            end
        end
    end
end

function Inventory.close()
    if(Inventory.Open == true)then
		closeInventory()
	else
		if(isCharacterLoggedIn() and isWindowOpen())then
			Inventory.Open = true
			setWindowData("no")
			animationStartTimeWeaponbar = nil
			animationDurationWeaponbar = 500
			removeEventHandler("onClientRender", root, Inventory.drawWeaponBar)
			
			if(isTimer(animationWeaponbarTimer1))then killTimer(animationWeaponbarTimer1)end
			if(isTimer(animationWeaponbarTimer2))then killTimer(animationWeaponbarTimer2)end
			
			addEventHandler("onClientRender", root, Inventory.draw)
			addEventHandler("onClientClick", root, Inventory.click)
			addEventHandler("onClientClick", root, Inventory.rightClick)
			addEventHandler("onClientClick", root, Inventory.weaponClick)
			addEventHandler("onClientClick", root, Inventory.weaponBarClick)
			addEventHandler("onClientDoubleClick", root, Inventory.doubleClick)
			addEventHandler("onClientRender",root,Inventory.drawWeaponBar)
			showCursor(true)
			triggerServerEvent("setAchievement", localPlayer, localPlayer, 34)
		end
	end
end
bindKey("i", "down", Inventory.close)

function backFromCraftingMenu()
	Inventory.Open = true
	setWindowData("no")
	animationStartTimeWeaponbar = nil
	animationDurationWeaponbar = 500
	removeEventHandler("onClientRender", root, Inventory.drawWeaponBar)
			
	if(isTimer(animationWeaponbarTimer1))then killTimer(animationWeaponbarTimer1)end
	if(isTimer(animationWeaponbarTimer2))then killTimer(animationWeaponbarTimer2)end
			
	addEventHandler("onClientRender", root, Inventory.draw)
	addEventHandler("onClientClick", root, Inventory.click)
	addEventHandler("onClientClick", root, Inventory.rightClick)
	addEventHandler("onClientClick", root, Inventory.weaponClick)
	addEventHandler("onClientClick", root, Inventory.weaponBarClick)
	addEventHandler("onClientDoubleClick", root, Inventory.doubleClick)
	addEventHandler("onClientRender",root,Inventory.drawWeaponBar)
	showCursor(true)
end

function closeInventory()
	Inventory.Open = false
	removeEventHandler("onClientRender", root, Inventory.draw)
	removeEventHandler("onClientClick", root, Inventory.click)
	removeEventHandler("onClientClick", root, Inventory.rightClick)
	removeEventHandler("onClientClick", root, Inventory.weaponBarClick)
	removeEventHandler("onClientClick", root, Inventory.weaponClick)
	removeEventHandler("onClientDoubleClick", root, Inventory.doubleClick)
	removeEventHandler("onClientRender",root,Inventory.drawWeaponBar)
	closeWindow("no")
	showCursor(false)
	Radio.close()
end
addEvent("closeInventory",true)
addEventHandler("closeInventory",root,closeInventory)

function Inventory.wheelUp()
    if(Inventory.Open)then
        Inventory.switchPage("left")
    end
end

function Inventory.wheelDown()
    if(Inventory.Open)then
        Inventory.switchPage("right")
    end
end

addEvent("bindKeyInventoryScroll",true)
addEventHandler("bindKeyInventoryScroll",root,function()
	bindKey("mouse_wheel_up","down",Inventory.wheelUp)
	bindKey("mouse_wheel_down","down",Inventory.wheelDown)
end)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	if(source == localPlayer)then
		if(Inventory.Open == true)then
			closeInventory()
		end
	end
end)