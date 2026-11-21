TrophyHouse = {
	["Bonus"] = {
		[1] = {money = 2500, experiencePoints = 16250, extraBonus = false, resetTimer = 43200},
		[2] = {money = 1250, experiencePoints = 8125, extraBonus = false, resetTimer = 36000},
		[3] = {money = 1250, experiencePoints = 8125, extraBonus = false, resetTimer = 36000},
		[4] = {money = 1250, experiencePoints = 8125, extraBonus = false, resetTimer = 36000},
		[5] = {money = 2500, experiencePoints = 16250, extraBonus = false, resetTimer = 43200},
		[6] = {money = 1250, experiencePoints = 8125, extraBonus = false, resetTimer = 36000},
		[7] = {money = 1250, experiencePoints = 8125, extraBonus = false, resetTimer = 36000},
		[8] = {money = 2500, experiencePoints = 16250, extraBonus = false, resetTimer = 43200},
		[9] = {money = 1250, experiencePoints = 8125, extraBonus = false, resetTimer = 36000},
		[10] = {money = 1250, experiencePoints = 8125, extraBonus = false, resetTimer = 36000},
		[11] = {money = 2500, experiencePoints = 16250, extraBonus = false, resetTimer = 43200},
		[12] = {money = 1250, experiencePoints = 8125, extraBonus = false, resetTimer = 36000},
		[13] = {money = 1250, experiencePoints = 8125, extraBonus = false, resetTimer = 36000},
		[14] = {money = 3250, experiencePoints = 21125, extraBonus = false, resetTimer = 43200},
		[15] = {money = 1250, experiencePoints = 8125, extraBonus = false, resetTimer = 36000},
		[16] = {money = 1250, experiencePoints = 8125, extraBonus = false, resetTimer = 36000},
		[17] = {money = 1750, experiencePoints = 11375, extraBonus = false, resetTimer = 28800},
		[18] = {money = 3250, experiencePoints = 21125, extraBonus = false, resetTimer = 43200},
		[19] = {money = 1250, experiencePoints = 8125, extraBonus = false, resetTimer = 36000},
		[20] = {money = 2500, experiencePoints = 16250, extraBonus = false, resetTimer = 43200},
		[21] = {money = 1250, experiencePoints = 8125, extraBonus = false, resetTimer = 36000},
		[22] = {money = 3250, experiencePoints = 21125, extraBonus = false, resetTimer = 43200},
		[23] = {money = 1250, experiencePoints = 8125, extraBonus = false, resetTimer = 36000},
		[24] = {money = 1250, experiencePoints = 8125, extraBonus = false, resetTimer = 36000},
		[25] = {money = 1750, experiencePoints = 11375, extraBonus = false, resetTimer = 28800},
		[26] = {money = 1750, experiencePoints = 11375, extraBonus = false, resetTimer = 28800},
		[27] = {money = 1750, experiencePoints = 11375, extraBonus = false, resetTimer = 28800},
		[28] = {money = 1750, experiencePoints = 11375, extraBonus = false, resetTimer = 28800},
		[29] = {money = 3250, experiencePoints = 21125, extraBonus = false, resetTimer = 43200},
		[30] = {money = 5000, experiencePoints = 22750, extraBonus = false, resetTimer = 86400},
		[31] = {money = 6000, experiencePoints = 24375, extraBonus = false, resetTimer = 86400},
		[32] = {money = 1000, experiencePoints = 4125, extraBonus = false, resetTimer = 21600},
		[33] = {money = 1250, experiencePoints = 4875, extraBonus = false, resetTimer = 21600},
		[34] = {money = 1250, experiencePoints = 4875, extraBonus = false, resetTimer = 21600},
		[35] = {money = 1000, experiencePoints = 4500, extraBonus = false, resetTimer = 21600},
	},
}

addEventHandler("onClientRender",root,function()
	if(isCharacterLoggedIn() and isWindowOpen())then
		if(getElementInterior(localPlayer) == 5 and getElementDimension(localPlayer) == 0)then
			local x1,y1,z1 = 2759.0107421875,-2377.6220703125,819.23999023438
			local screenX1,screenY1 = getScreenFromWorldPosition(x1,y1,z1)
			local x2,y2,z2 = 2754.72265625,-2377.6220703125,819.23999023438
			local screenX2,screenY2 = getScreenFromWorldPosition(x2,y2,z2)
			local x3,y3,z3 = 2763.1469726562,-2377.6220703125,819.23999023
			local screenX3,screenY3 = getScreenFromWorldPosition(x3,y3,z3)
			local x4,y4,z4 = 2767.1704101562,-2377.6220703125,819.23999023438
			local screenX4,screenY4 = getScreenFromWorldPosition(x4,y4,z4)
			
			if(screenX1 and screenY1)then
				if(getDistanceBetweenPoints3D(x1,y1,z1,getElementPosition(localPlayer)) <= 7.5)then
					dxDrawText(getText("CTrophyHouse16"), screenX1 - 100, screenY1 - 20, screenX1 + 100, screenY1 + 20, tocolor(255, 255, 255), 1.2, "default-bold", "center", "center")
				end
			end
			
			if(screenX2 and screenY2)then
				if(getDistanceBetweenPoints3D(x2,y2,z2,getElementPosition(localPlayer)) <= 7.5)then
					dxDrawText(getText("CTrophyHouse15"), screenX2 - 100, screenY2 - 20, screenX2 + 100, screenY2 + 20, tocolor(255, 255, 255), 1.2, "default-bold", "center", "center")
				end
			end
			
			if(screenX3 and screenY3)then
				if(getDistanceBetweenPoints3D(x3,y3,z3,getElementPosition(localPlayer)) <= 7.5)then
					dxDrawText(getText("CTrophyHouse17"), screenX3 - 100, screenY3 - 20, screenX3 + 100, screenY3 + 20, tocolor(255, 255, 255), 1.2, "default-bold", "center", "center")
				end
			end
			
			if(screenX4 and screenY4)then
				if(getDistanceBetweenPoints3D(x4,y4,z4,getElementPosition(localPlayer)) <= 7.5)then
					dxDrawText(getText("CBadges1"), screenX4 - 100, screenY4 - 20, screenX4 + 100, screenY4 + 20, tocolor(255, 255, 255), 1.2, "default-bold", "center", "center")
				end
			end
		end
	end
end)

addEvent("TrophyHouse.createWindow",true)
addEventHandler("TrophyHouse.createWindow",root,function()
	if(isWindowOpen())then
        GUIEditor.window[1] = guiCreateWindow(575, 303, 621, 383, getText("CTrophyHouse5"), false)
        setWindowData()
		guiCreateCloseButton()

        GUIEditor.gridlist[1] = guiCreateGridList(10, 58, 249, 315, false, GUIEditor.window[1])
        trophy_grid = guiGridListAddColumn(GUIEditor.gridlist[1],getText("CTrophyHouse1"), 0.9)
        GUIEditor.gridlist[2] = guiCreateGridList(269, 124, 342, 214, false, GUIEditor.window[1])
        ach_grid = guiGridListAddColumn(GUIEditor.gridlist[2], getText("CTrophyHouse2"), 0.9)
        GUIEditor.button[1] = guiCreateButton(269, 348, 342, 25, getText("CTrophyHouse6"), false, GUIEditor.window[1])
        GUIEditor.label[1] = guiCreateLabel(10, 22, 249, 26, getText("CTrophyHouse3"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
        GUIEditor.label[2] = guiCreateLabel(269, 22, 342, 26, getText("CTrophyHouse4"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[2], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[2], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[2], "center")
        GUIEditor.label[3] = guiCreateLabel(269, 58, 342, 56, getText("CTrophyHouse7"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[3], "clear-normal")
        guiLabelSetHorizontalAlign(GUIEditor.label[3], "center", true)
        guiLabelSetVerticalAlign(GUIEditor.label[3], "center")
		
		triggerServerEvent("TrophyHouse.loadData",localPlayer)
		
		addEventHandler("onClientGUIClick",GUIEditor.gridlist[1],function()
			local selectedRow = guiGridListGetSelectedItem(GUIEditor.gridlist[1])
			if(selectedRow ~= -1)then
				local trophyID = guiGridListGetItemData(GUIEditor.gridlist[1], selectedRow, trophy_grid)
				triggerServerEvent("TrophyHouse.loadAchievementList",localPlayer,trophyID)
			end
		end,false)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
			local selectedRow = guiGridListGetSelectedItem(GUIEditor.gridlist[1])
			if(selectedRow ~= -1)then
				local trophyID = guiGridListGetItemData(GUIEditor.gridlist[1], selectedRow, trophy_grid)
				triggerServerEvent("TrophyHouse.claim",localPlayer,trophyID)
			end
		end,false)
    end
end)

addEvent("TrophyHouse.updateAchievementList",true)
addEventHandler("TrophyHouse.updateAchievementList",root,function(data)
	guiGridListClear(GUIEditor.gridlist[2])
	if(#data >= 1)then
		for _, v in pairs(data)do
			local row = guiGridListAddRow(GUIEditor.gridlist[2])
			guiGridListSetItemText(GUIEditor.gridlist[2], row, ach_grid, Achievements["Achievements"][apocalypseGetElementData(localPlayer,"language") or "EN"][v[1]][1], false, false)
			guiGridListSetItemData(GUIEditor.gridlist[2], row, ach_grid, v[1])
			if(v[2] == false)then
				guiGridListSetItemColor ( GUIEditor.gridlist[2], row, ach_grid, 255,0,0 )
			else
				guiGridListSetItemColor ( GUIEditor.gridlist[2], row, ach_grid, 0,255,0 )
			end
		end
	end
end)

addEvent("TrophyHouse.updateTrophys",true)
addEventHandler("TrophyHouse.updateTrophys",root,function(data)
	guiGridListClear(GUIEditor.gridlist[1])
	if(#data >= 1)then
		for _, v in pairs(data)do
			local row = guiGridListAddRow(GUIEditor.gridlist[1])
			guiGridListSetItemText(GUIEditor.gridlist[1], row, trophy_grid, v[1], false, false)
			guiGridListSetItemData(GUIEditor.gridlist[1], row, trophy_grid, v[3])
		end
	end
end)

addEvent("TrophyHouse.createAchievementListWindow",true)
addEventHandler("TrophyHouse.createAchievementListWindow",root,function()
	if(isWindowOpen())then
        GUIEditor.window[1] = guiCreateWindow(627, 289, 661, 448, "", false)
        setWindowData()
		guiCreateCloseButton()

        GUIEditor.gridlist[1] = guiCreateGridList(10, 46, 267, 357, false, GUIEditor.window[1])
		top20_grid_name = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CTrophyHouse8"), 0.6)
		top20_grid_count = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CTrophyHouse9"), 0.3)
        GUIEditor.gridlist[2] = guiCreateGridList(287, 46, 364, 357, false, GUIEditor.window[1])
		ach_grid = guiGridListAddColumn(GUIEditor.gridlist[2], getText("CTrophyHouse10"), 0.9)
        GUIEditor.label[1] = guiCreateLabel(10, 24, 267, 22, getText("CTrophyHouse11"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
        GUIEditor.label[2] = guiCreateLabel(287, 24, 364, 22, getText("CTrophyHouse12"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[2], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[2], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[2], "center")
        GUIEditor.edit[1] = guiCreateEdit(287, 413, 227, 26, "", false, GUIEditor.window[1])
        GUIEditor.button[1] = guiCreateButton(524, 413, 127, 26, getText("CTrophyHouse13"), false, GUIEditor.window[1])
        GUIEditor.label[3] = guiCreateLabel(10, 413, 267, 25, getText("CTrophyHouse14"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[3], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[3], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[3], "center")  
		
		triggerServerEvent("TrophyHouse.MostAchievementPlayer",localPlayer)
		
		addEventHandler("onClientGUIClick",GUIEditor.gridlist[1],function()
			local selectedRow = guiGridListGetSelectedItem(GUIEditor.gridlist[1])
			if(selectedRow ~= -1)then
				local playerName = guiGridListGetItemData(GUIEditor.gridlist[1], selectedRow, top20_grid_name)
				triggerServerEvent("TrophyHouse.loadPlayerAchievements",localPlayer,playerName)
			end
		end,false)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
			local playerName = guiGetText(GUIEditor.edit[1])
			if(#playerName >= 1)then
				triggerServerEvent("TrophyHouse.loadPlayerAchievements",localPlayer,playerName)
			end
		end,false)
	end
end)

addEvent("TrophyHouse.ReceiveTopPlayers", true)
addEventHandler("TrophyHouse.ReceiveTopPlayers", root, function(top20)
    guiGridListClear(GUIEditor.gridlist[1])

    if top20 and #top20 > 0 then
        for _, v in ipairs(top20) do
            local row = guiGridListAddRow(GUIEditor.gridlist[1])
            guiGridListSetItemText(GUIEditor.gridlist[1], row, top20_grid_name, v.username or "???", false, false)
			guiGridListSetItemData(GUIEditor.gridlist[1], row, top20_grid_name, v.username)
            guiGridListSetItemText(GUIEditor.gridlist[1], row, top20_grid_count, tostring(v.count or 0), false, true)
        end
    end
end)

addEvent("TrophyHouse.receivePlayerAchievements",true)
addEventHandler("TrophyHouse.receivePlayerAchievements",root,function(achievementTable)
    guiGridListClear(GUIEditor.gridlist[2])

    if achievementTable and #achievementTable > 0 then
        for _, v in ipairs(achievementTable) do
            local row = guiGridListAddRow(GUIEditor.gridlist[2])
            guiGridListSetItemText(GUIEditor.gridlist[2], row, ach_grid, Achievements["Achievements"][apocalypseGetElementData(localPlayer,"language") or "EN"][v][1], false, false)
        end
    end
end)