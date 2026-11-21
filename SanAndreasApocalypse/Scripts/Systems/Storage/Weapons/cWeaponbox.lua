Weaponbox = {}

addEvent("Weaponbox.open",true)
addEventHandler("Weaponbox.open",root,function()
	if(isWindowOpen())then
        GUIEditor.window[1] = guiCreateWindow(625, 303, 437, 292, getText("CWeaponbox1"), false)
        setWindowData()

        GUIEditor.gridlist[1] = guiCreateGridList(9, 54, 170, 228, false, GUIEditor.window[1])
		weaponsOnHandWeapon = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CWeaponbox2"), 0.5)
		weaponsOnHandAmmo = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CWeaponbox3"), 0.4)
		
        GUIEditor.button[1] = guiCreateButton(189, 165, 58, 23, "<<<", false, GUIEditor.window[1])
        GUIEditor.button[2] = guiCreateButton(189, 119, 58, 23, ">>>", false, GUIEditor.window[1])
        GUIEditor.gridlist[2] = guiCreateGridList(257, 54, 170, 228, false, GUIEditor.window[1])
		weaponsInStorage = guiGridListAddColumn(GUIEditor.gridlist[2], getText("CWeaponbox2"), 0.5)
		weaponsInStorageAmmo = guiGridListAddColumn(GUIEditor.gridlist[2], getText("CWeaponbox3"), 0.4)
		
        GUIEditor.label[1] = guiCreateLabel(9, 26, 169, 18, getText("CWeaponbox4"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", false)
        GUIEditor.label[2] = guiCreateLabel(257, 26, 169, 18, getText("CWeaponbox5"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[2], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[2], "center", false)
        GUIEditor.button[3] = guiCreateButton(189, 257, 58, 23, "[X]", false, GUIEditor.window[1])
		
		triggerServerEvent("Weaponbox.getData",localPlayer)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
           local selectedRow, selectedCol = guiGridListGetSelectedItem(GUIEditor.gridlist[2])
            if(selectedRow ~= -1)then
                local weaponName = guiGridListGetItemText(GUIEditor.gridlist[2], selectedRow, weaponsInStorage)
                local weaponAmmo = guiGridListGetItemText(GUIEditor.gridlist[2], selectedRow, weaponsInStorageAmmo)
                triggerServerEvent("Weaponbox.withdrawWeapon", localPlayer, weaponName, tonumber(weaponAmmo))
            else createInfobox(getText("CWeaponbox6"))end
		end,false)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[2],function()
           local selectedRow, selectedCol = guiGridListGetSelectedItem(GUIEditor.gridlist[1])
            if(selectedRow ~= -1)then
                local weaponName = guiGridListGetItemText(GUIEditor.gridlist[1], selectedRow, weaponsOnHandWeapon)
                local weaponAmmo = guiGridListGetItemText(GUIEditor.gridlist[1], selectedRow, weaponsOnHandAmmo)
				local ID = guiGridListGetItemData(GUIEditor.gridlist[1], selectedRow, weaponsInStorage)
				if(ID)then
					triggerServerEvent("Weaponbox.storeWeapon", localPlayer, weaponName, weaponAmmo, ID)
				end
            else createInfobox(getText("CWeaponbox6"))end
		end,false)

		addEventHandler("onClientGUIClick",GUIEditor.button[3],function()
			closeWindow()
		end,false)
    end
end)

addEvent("Weaponbox.updateData",true)
addEventHandler("Weaponbox.updateData",root,function(playerWeapons,weaponboxWeapons)
	if(playerWeapons and weaponboxWeapons)then
		guiGridListClear(GUIEditor.gridlist[1])
		guiGridListClear(GUIEditor.gridlist[2])
		
		if(#playerWeapons >= 1)then
			for _,v in pairs(playerWeapons) do
				local weaponName = getWeaponNameFromID(v.weapon)
				local row = guiGridListAddRow(GUIEditor.gridlist[1])
				guiGridListSetItemText(GUIEditor.gridlist[1], row, weaponsOnHandWeapon, tostring(weaponName), false, false)
				guiGridListSetItemText(GUIEditor.gridlist[1], row, weaponsOnHandAmmo, tostring(v.ammo), false, false)
				guiGridListSetItemData(GUIEditor.gridlist[1], row, weaponsInStorage, tonumber(v.id) )
			end
		end
		
		if(#weaponboxWeapons >= 1)then
			for _,v in ipairs(weaponboxWeapons) do
				local weaponName = getWeaponNameFromID(v.weapon)
				if(weaponName)then
					local row = guiGridListAddRow(GUIEditor.gridlist[2])
					guiGridListSetItemText(GUIEditor.gridlist[2], row, weaponsInStorage, tostring(weaponName), false, false)
					guiGridListSetItemText(GUIEditor.gridlist[2], row,weaponsInStorageAmmo, tostring(v.ammo), false, false)
				end
			end
		end
	end
end)