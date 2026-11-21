SellFish = {WindowOpen = false,
	["FishNames"] = {
		["DE"] = {
			[133] = "Glühkiefer",
			[134] = "Blitzflosse",
			[135] = "Schleicher",
			[136] = "Streifenclown",
			[137] = "Korallenritter",
			[138] = "Pustekugel",
			[139] = "Strömungsschnapper",
			[140] = "Riffgleiter",
			[141] = "Blubberlin",
			[142] = "Sonnenflosser",
		},
		["EN"] = {
			[133] = "Glowjaw",
			[134] = "Thunderfin",
			[135] = "Creeper",
			[136] = "Stripeclown",
			[137] = "Coral Knight",
			[138] = "Puffball",
			[139] = "Current Snapper",
			[140] = "Reef Glider",
			[141] = "Bubblerlin",
			[142] = "Sunfin",
		},
		["RU"] = {
			[133] = "Светочелюсть",       -- Glowjaw
			[134] = "Громоплавник",       -- Thunderfin
			[135] = "Крипер",             -- Creeper
			[136] = "Полосатый клоун",    -- Stripeclown
			[137] = "Рыцарь кораллов",    -- Coral Knight
			[138] = "Пухляш",             -- Puffball
			[139] = "Токовый щелкун",     -- Current Snapper
			[140] = "Рифовый скользун",   -- Reef Glider
			[141] = "Пузырьлин",          -- Bubblerlin
			[142] = "Солнечный плавник",  -- Sunfin
		},
		["PT"] = {
			[133] = "Mandíbula Brilhante",  -- Glowjaw
			[134] = "Barbatrovão",          -- Thunderfin
			[135] = "Assombrador",          -- Creeper
			[136] = "Palhaço Listrado",     -- Stripeclown
			[137] = "Cavaleiro Coral",      -- Coral Knight
			[138] = "Bolinchudo",           -- Puffball
			[139] = "Estalador da Corrente",-- Current Snapper
			[140] = "Planador de Recife",   -- Reef Glider
			[141] = "Borbulhinho",          -- Bubblerlin
			[142] = "Barbatana Solar",      -- Sunfin
		},
	},
	["FishPrice"] = {},
}

local fishList = {133,134,135,136,137,138,139,140,141,142}

SellFish.buyShellsPickup = createPickup(369.14215087891,-2074.7175292969,7.8359375,3,1239,50)

addEventHandler("onClientRender",root,function()
	if(isCharacterLoggedIn() and isWindowOpen())then
		local x1,y1,z1 = 369.14215087891,-2074.7175292969,7.8359375
		local screenX1,screenY1 = getScreenFromWorldPosition(x1,y1,z1)
			
		if(screenX1 and screenY1)then
			if(getDistanceBetweenPoints3D(x1,y1,z1,getElementPosition(localPlayer)) <= 5)then
				dxDrawText(getText("CSellFish13"), screenX1 - 100, screenY1 - 20, screenX1 + 100, screenY1 + 20, tocolor(255, 255, 255), 1.2, "default-bold", "center", "center")
			end
		end
	end
end)

addEventHandler("onClientPickupHit",SellFish.buyShellsPickup,function(player)
	if(player == localPlayer)then
		if(getElementDimension(localPlayer) == getElementDimension(source))then
			if(not(isPedInVehicle(localPlayer)))then
				if(isWindowOpen())then
					GUIEditor.window[1] = guiCreateWindow(609, 538, 400, 128, getText("CSellFish12"), false)
					setWindowData()
					guiCreateCloseButton()

					GUIEditor.label[1] = guiCreateLabel(10, 24, 380, 24, getText("CSellFish8"), false, GUIEditor.window[1])
					guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", false)
					guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
					GUIEditor.label[2] = guiCreateLabel(10, 58, 104, 24, getText("CSellFish9"), false, GUIEditor.window[1])
					guiLabelSetHorizontalAlign(GUIEditor.label[2], "center", false)
					guiLabelSetVerticalAlign(GUIEditor.label[2], "center")
					GUIEditor.edit[1] = guiCreateEdit(124, 58, 111, 24, "", false, GUIEditor.window[1])
					GUIEditor.label[3] = guiCreateLabel(245, 58, 145, 24, getText("CSellFish10"), false, GUIEditor.window[1])
					guiLabelSetHorizontalAlign(GUIEditor.label[3], "center", false)
					guiLabelSetVerticalAlign(GUIEditor.label[3], "center")
					GUIEditor.button[1] = guiCreateButton(10, 92, 380, 26, getText("CSellFish11"), false, GUIEditor.window[1])

					addEventHandler("onClientGUIClick", GUIEditor.button[1], function()
						local amount = tonumber(guiGetText(GUIEditor.edit[1]))
						if not amount or amount <= 0 or isOnlyNumbers(amount) == false then
							NPC.NormalMessage(getText("CSellFish2"))
							return
						end
						triggerServerEvent("SellFish.buyShell",localPlayer,amount)
					end, false)
					
					triggerServerEvent("SellFish.getShells",localPlayer,localPlayer)
				end
			end
		end
	end
end)

function SellFish.createWindow()
	if(isWindowOpen())then
        GUIEditor.window[1] = guiCreateWindow(585, 373, 508, 281, "", false)
        guiCreateCloseButton()
		setWindowData()
		SellFish.WindowOpen = true

        GUIEditor.gridlist[1] = guiCreateGridList(11, 27, 244, 244, false, GUIEditor.window[1])
        guiGridListAddColumn(GUIEditor.gridlist[1], getText("CSellFish5"), 0.5)
        guiGridListAddColumn(GUIEditor.gridlist[1], getText("CSellFish6"), 0.5)
		
        GUIEditor.label[1] = guiCreateLabel(260, 150, 238, 28, getText("CSellFish7"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
        GUIEditor.edit[1] = guiCreateEdit(260, 188, 238, 32, "", false, GUIEditor.window[1])

        GUIEditor.label[2] = guiCreateLabel(265, 27, 233, 113, getText("CSellFish3"), false, GUIEditor.window[1])
		guiLabelSetHorizontalAlign(GUIEditor.label[2], "left", true)  

        GUIEditor.button[1] = guiCreateButton(260, 239, 238, 32, getText("CSellFish4"), false, GUIEditor.window[1])
		
        addEventHandler("onClientGUIClick", GUIEditor.button[1], function()
            local selectedRow = guiGridListGetSelectedItem(GUIEditor.gridlist[1])
            if selectedRow == -1 then
				 NPC.NormalMessage(getText("CSellFish1"))
                return
            end

            local fishID = guiGridListGetItemData(GUIEditor.gridlist[1], selectedRow, 1)
            local amount = tonumber(guiGetText(GUIEditor.edit[1]))
			if not amount or amount <= 0 or isOnlyNumbers(amount) == false then
                NPC.NormalMessage(getText("CSellFish2"):format(hasPlayerItem(fishID)))
                return
            end

            triggerServerEvent("SellFish", localPlayer, fishID, amount)
        end, false)
		
        addEventHandler("onClientGUIClick", GUIEditor.gridlist[1], function()
            local selectedRow = guiGridListGetSelectedItem(GUIEditor.gridlist[1])
            if selectedRow == -1 then
                return
            end

            local fishID = guiGridListGetItemData(GUIEditor.gridlist[1], selectedRow, 1)
            guiSetText(GUIEditor.label[2],getText("CSellFish2"):format(hasPlayerItem(fishID)))
        end, false)
		
		triggerServerEvent("SellFish.getPrices",localPlayer)
    end
end

addEvent("SellFish.updatePrices",true)
addEventHandler("SellFish.updatePrices",root,function(prices)
	if(prices)then
		for _,v in pairs(prices)do
			SellFish["FishPrice"][v[1]] = v[2]
		end
	end
	if(SellFish.WindowOpen == true)then
		SellFish.updateGridlist()
	end
end)

addEvent("SellFish.updateShells",true)
addEventHandler("SellFish.updateShells",root,function(amount)
	guiSetText(GUIEditor.label[1],getText("CSellFish8"):format(tonumber(amount)))
end)

function SellFish.updateGridlist()
	guiGridListClear(GUIEditor.gridlist[1])
    for i, fish in ipairs(fishList) do
		if(SellFish["FishPrice"][fish])then
			local row = guiGridListAddRow(GUIEditor.gridlist[1])
			guiGridListSetItemText(GUIEditor.gridlist[1], row, 1, SellFish["FishNames"][apocalypseGetElementData(localPlayer,"language") or "EN"][fish], false, false)
			guiGridListSetItemText(GUIEditor.gridlist[1], row, 2, tostring(SellFish["FishPrice"][fish]), false, false)
			guiGridListSetItemData(GUIEditor.gridlist[1], row, 1, fish)
		end
    end
end