local SettingsOpen = false
local Languages = {"English","German","Pусский","Português"}

bindKey("f5", "down", function()
	if(SettingsOpen == true)then
		closeWindow()
		SettingsOpen = false
	else
		if(isCharacterLoggedIn())then
			if(isWindowOpen())then
				GUIEditor.window[1] = guiCreateWindow(711,  401,  464,  234,  "",  false)
				setWindowData()
				SettingsOpen = true

				GUIEditor.tabpanel[1] = guiCreateTabPanel(9,  26,  445,  198,  false,  GUIEditor.window[1])

				GUIEditor.tab[1] = guiCreateTab(getText("CSettings1"),  GUIEditor.tabpanel[1])

				GUIEditor.label[1] = guiCreateLabel(10,  10,  146,  22,  getText("CSettings2"),  false,  GUIEditor.tab[1])
				guiLabelSetVerticalAlign(GUIEditor.label[1],  "center")
				GUIEditor.label[2] = guiCreateLabel(10,  42,  146,  22,  getText("CSettings3"),  false,  GUIEditor.tab[1])
				guiLabelSetVerticalAlign(GUIEditor.label[2],  "center")
				GUIEditor.checkbox[1] = guiCreateCheckBox(166,  10,  15,  22,  "",  false,  false,  GUIEditor.tab[1])
				GUIEditor.checkbox[2] = guiCreateCheckBox(166,  42,  15,  22,  "",  true,  false,  GUIEditor.tab[1])
				GUIEditor.label[3] = guiCreateLabel(191,  10,  244,  54,  getText("CSettings4"),  false,  GUIEditor.tab[1])
				guiLabelSetHorizontalAlign(GUIEditor.label[3], "left", true)
				guiLabelSetVerticalAlign(GUIEditor.label[3], "center")
				GUIEditor.gridlist[1] = guiCreateGridList(10,  74,  425,  90,  false,  GUIEditor.tab[1])
				favoritecharacter_id = guiGridListAddColumn(GUIEditor.gridlist[1],  "ID",  0.2)
				favoritecharacter_name = guiGridListAddColumn(GUIEditor.gridlist[1],  getText("CSettings5"),  0.3)
				favoritecharacter_level = guiGridListAddColumn(GUIEditor.gridlist[1],  getText("CSettings6"),  0.2)
				favoritecharacter_playtime = guiGridListAddColumn(GUIEditor.gridlist[1],  getText("CSettings7"),  0.2)

				GUIEditor.tab[2] = guiCreateTab(getText("CSettings11"),  GUIEditor.tabpanel[1])

				GUIEditor.label[4] = guiCreateLabel(10,  10,  146,  22,  getText("CSettings8"),  false,  GUIEditor.tab[2])
				guiLabelSetVerticalAlign(GUIEditor.label[4],  "center")
				GUIEditor.label[5] = guiCreateLabel(10,  42,  146,  22,  getText("CSettings8"),  false,  GUIEditor.tab[2])
				guiLabelSetVerticalAlign(GUIEditor.label[5],  "center")
				GUIEditor.edit[1] = guiCreateEdit(166,  10,  269,  22,  "",  false,  GUIEditor.tab[2])
				GUIEditor.edit[2] = guiCreateEdit(166,  42,  269,  22,  "",  false,  GUIEditor.tab[2])
				GUIEditor.label[6] = guiCreateLabel(10,  76,  425,  22,  getText("CSettings9"),  false,  GUIEditor.tab[2])
				guiLabelSetHorizontalAlign(GUIEditor.label[6],  "center",  false)
				guiLabelSetVerticalAlign(GUIEditor.label[6],  "center")
				GUIEditor.edit[3] = guiCreateEdit(10,  108,  425,  22,  "",  false,  GUIEditor.tab[2])
				GUIEditor.button[1] = guiCreateButton(10,  140,  425,  24,  getText("CSettings10"),  false,  GUIEditor.tab[2])

				GUIEditor.tab[3] = guiCreateTab(getText("CSettings14"), GUIEditor.tabpanel[1])

				GUIEditor.button[2] = guiCreateButton(10, 10, 425, 24, getText("CSettings15"), false, GUIEditor.tab[3])
				GUIEditor.gridlist[2] = guiCreateGridList(10, 40, 425, 120, false, GUIEditor.tab[3])
				thirdTabColumn = guiGridListAddColumn(GUIEditor.gridlist[2], getText("CSettings16"), 0.9)
				
				GUIEditor.tab[4] = guiCreateTab(getText("CSettings17"), GUIEditor.tabpanel[1])

				GUIEditor.button[3] = guiCreateButton(10, 10, 425, 24, getText("CSettings18"), false, GUIEditor.tab[4])
				GUIEditor.gridlist[3] = guiCreateGridList(10, 40, 425, 120, false, GUIEditor.tab[4])
				languageColumn = guiGridListAddColumn(GUIEditor.gridlist[3], getText("CSettings17"), 0.9)
				
				GUIEditor.tab[5] = guiCreateTab(getText("CSettings19"), GUIEditor.tabpanel[1])
				GUIEditor.label[7] = guiCreateLabel(10, 10, 425, 22, getText("CSettings20"), false, GUIEditor.tab[5])
				guiLabelSetHorizontalAlign(GUIEditor.label[7], "center", false)
				GUIEditor.edit[4] = guiCreateEdit(10, 42, 425, 22, "", false, GUIEditor.tab[5])
				GUIEditor.button[4] = guiCreateButton(10, 74, 425, 24, getText("CSettings21"), false, GUIEditor.tab[5])
				
				for _, v in pairs(Languages) do
					local row = guiGridListAddRow(GUIEditor.gridlist[3])
					guiGridListSetItemText(GUIEditor.gridlist[3], row, languageColumn, v, false, false)
				end
				
				triggerServerEvent("PlayerSpawn.getSpawns",localPlayer)
				
				addEventHandler("onClientGUIClick", GUIEditor.button[1], function()
					local password = guiGetText(GUIEditor.edit[3])
					local newpassword1,  newpassword2 = guiGetText(GUIEditor.edit[1]),  guiGetText(GUIEditor.edit[2])
					if(password ~= "" and newpassword1 ~= "" and newpassword2 ~= "")then
						if(#newpassword1 >= 8)then
							triggerServerEvent("changePassword", localPlayer, password, newpassword1, newpassword2)
						else
							createInfobox(getText("CSettings13"))
						end
					else
						createInfobox(getText("CSettings12"))
					end
				end, false)
				
				addEventHandler("onClientGUIClick", GUIEditor.checkbox[1], function()
					triggerServerEvent("changeAutologin", localPlayer)
				end, false)
				
				addEventHandler("onClientGUIClick", GUIEditor.checkbox[2], function()
					triggerServerEvent("changeSkipintro", localPlayer)
				end, false)
				
				addEventHandler("onClientGUIDoubleClick", GUIEditor.gridlist[1], function()
					local clicked = guiGridListGetItemText(GUIEditor.gridlist[1],  guiGridListGetSelectedItem(GUIEditor.gridlist[1]),  1)
                    if(clicked ~= "")then
                        triggerServerEvent("setFavoriteCharacter", localPlayer, clicked)
                    end
				end, false)
				
				addEventHandler("onClientGUIClick", GUIEditor.button[2], function()
					local selectedRow = guiGridListGetSelectedItem(GUIEditor.gridlist[2])
					if(selectedRow ~= -1)then
						local questID = guiGridListGetItemData(GUIEditor.gridlist[2], selectedRow, thirdTabColumn)
						triggerServerEvent("PlayerSpawn.set",localPlayer,questID)
					end
				end, false)
				
				addEventHandler("onClientGUIClick", GUIEditor.button[3], function()
					local clicked = guiGridListGetItemText(GUIEditor.gridlist[3],  guiGridListGetSelectedItem(GUIEditor.gridlist[3]),  1)
                    if(clicked ~= "")then
                        triggerServerEvent("changeLanguage", localPlayer, clicked)
                    end
				end, false)
				
				addEventHandler("onClientGUIClick", GUIEditor.button[4], function()
					local edit = guiGetText(GUIEditor.edit[4])
                    if(#edit >= 1)then
                        triggerServerEvent("useBonuscode", localPlayer, edit)
                    end
				end, false)
				
				triggerServerEvent("getSettingData", localPlayer)
				triggerServerEvent("getSettingCharacters", localPlayer)
			end
		end
	end
end)

addEvent("Settings.updatePlayerSpawnData",true)
addEventHandler("Settings.updatePlayerSpawnData",root,function(spawns)
	guiGridListClear(GUIEditor.gridlist[2])
    if(spawns)then
        for _, v in pairs(spawns) do
			local row = guiGridListAddRow(GUIEditor.gridlist[2])
			guiGridListSetItemText(GUIEditor.gridlist[2], row, thirdTabColumn, PlayerSpawn["Spawns"][apocalypseGetElementData(localPlayer, "language") or "EN"][tonumber(v)], false, false)
			guiGridListSetItemData(GUIEditor.gridlist[2], row, thirdTabColumn, v)
        end
    end
end)

addEvent("updateSettingData", true)
addEventHandler("updateSettingData", root, function(autologin,  skipintro)
	if(autologin == 1)then
		guiCheckBoxSetSelected(GUIEditor.checkbox[1], true)
	else
		guiCheckBoxSetSelected(GUIEditor.checkbox[1], false)
	end
	
	if(skipintro == 1)then
		guiCheckBoxSetSelected(GUIEditor.checkbox[2], true)
	else
		guiCheckBoxSetSelected(GUIEditor.checkbox[2], false)
	end
end)

addEvent("updateSettingCharacters", true)
addEventHandler("updateSettingCharacters", root, function(characters)
	for _, v in pairs(characters)do
		local row = guiGridListAddRow(GUIEditor.gridlist[1])
		guiGridListSetItemText(GUIEditor.gridlist[1], row, favoritecharacter_id, v[1], false, false)
		guiGridListSetItemText(GUIEditor.gridlist[1], row, favoritecharacter_name, v[2], false, false)
		guiGridListSetItemText(GUIEditor.gridlist[1], row, favoritecharacter_level, v[3], false, false)
		guiGridListSetItemText(GUIEditor.gridlist[1], row, favoritecharacter_playtime, formatMinutes(v[4]), false, false)
	end
end)

addEventHandler("onClientPlayerWasted",root,function()
	if(source == localPlayer)then
		SettingsOpen = false
	end
end)