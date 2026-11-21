Vehiclesystem = {}

function Vehiclesystem.createWindow()
	if(isWindowOpen())then
		GUIEditor.window[1] = guiCreateWindow(346, 340, 294, 120, getText("CVehicles13"), false)
		guiCreateCloseButton()

		GUIEditor.button[1] = guiCreateButton(10, 33, 132, 33, getText("CVehicles8"), false, GUIEditor.window[1])
		GUIEditor.button[2] = guiCreateButton(152, 33, 132, 33, getText("CVehicles9"), false, GUIEditor.window[1])
		GUIEditor.button[3] = guiCreateButton(10, 74, 132, 33, getText("CVehicles10"), false, GUIEditor.window[1])
		GUIEditor.button[4] = guiCreateButton(152, 74, 132, 33, getText("CVehicles11"), false, GUIEditor.window[1])    
			
		setWindowData()
			
		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
			triggerServerEvent("Vehiclesystem.lock",localPlayer)
		end,false)
			
		addEventHandler("onClientGUIClick",GUIEditor.button[2],function()
			createInfobox(getText("CVehicles12"):format(apocalypseGetElementData(localPlayer,"vehicle_interaction_owner")))
		end)
			
		addEventHandler("onClientGUIClick",GUIEditor.button[3],function()
			triggerServerEvent("Vehiclesystem.park",localPlayer)
		end)
			
		addEventHandler("onClientGUIClick",GUIEditor.button[4],function()
			triggerServerEvent("Vehiclesystem.openTrunk",localPlayer)
		end)
	end
end
addEvent("Vehiclesystem.createWindow",true)
addEventHandler("Vehiclesystem.createWindow",root,Vehiclesystem.createWindow)

addEvent("Vehiclesystem.openTrunk",true)
addEventHandler("Vehiclesystem.openTrunk",root,function(trunk)
	destroyElement(GUIEditor.window[1])
    GUIEditor.window[1] = guiCreateWindow(654, 199, 384, 459, "", false)
    guiCreateCloseButton()
	centerWindow(GUIEditor.window[1])

    GUIEditor.gridlist[1] = guiCreateGridList(9, 56, 365, 125, false, GUIEditor.window[1])
    item = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CTrunk1"), 0.5)
    amount = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CTrunk2"), 0.5)
    GUIEditor.label[1] = guiCreateLabel(10, 26, 364, 20, getText("CTrunk3"), false, GUIEditor.window[1])
    guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", false)
    guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
    GUIEditor.label[2] = guiCreateLabel(10, 191, 364, 20, getText("CTrunk4"), false, GUIEditor.window[1])
    guiLabelSetHorizontalAlign(GUIEditor.label[2], "center", false)
    guiLabelSetVerticalAlign(GUIEditor.label[2], "center")
    GUIEditor.gridlist[2] = guiCreateGridList(9, 221, 365, 125, false, GUIEditor.window[1])
    item2 = guiGridListAddColumn(GUIEditor.gridlist[2], getText("CTrunk1"), 0.5)
    amount2 = guiGridListAddColumn(GUIEditor.gridlist[2], getText("CTrunk2"), 0.5)
    GUIEditor.label[3] = guiCreateLabel(10, 356, 111, 23, getText("CTrunk2")..":", false, GUIEditor.window[1])
    guiLabelSetHorizontalAlign(GUIEditor.label[3], "center", false)
    guiLabelSetVerticalAlign(GUIEditor.label[3], "center")
    GUIEditor.edit[1] = guiCreateEdit(10, 389, 111, 23, "", false, GUIEditor.window[1])
    GUIEditor.button[1] = guiCreateButton(130, 389, 244, 23, getText("CTrunk5"), false, GUIEditor.window[1])
    GUIEditor.button[2] = guiCreateButton(130, 356, 244, 23, getText("CTrunk6"), false, GUIEditor.window[1])
	
	guiGridListClear(GUIEditor.gridlist[1])
	guiGridListClear(GUIEditor.gridlist[2])
	for _, v in pairs(trunk)do
		local row = guiGridListAddRow(GUIEditor.gridlist[1])
		guiGridListSetItemText(GUIEditor.gridlist[1], row, item, ItemInfos["items"][apocalypseGetElementData(localPlayer,"language") or "EN"][v.item], false, false)
		guiGridListSetItemText(GUIEditor.gridlist[1], row, amount, v.amount, false, false)
		guiGridListSetItemData(GUIEditor.gridlist[1], row, item, v.item)
	end
	
	for _, v in pairs(PlayerItems)do
		local row = guiGridListAddRow(GUIEditor.gridlist[2])
		guiGridListSetItemText(GUIEditor.gridlist[2], row, item2, ItemInfos["items"][apocalypseGetElementData(localPlayer,"language") or "EN"][v.item], false, false)
		guiGridListSetItemText(GUIEditor.gridlist[2], row, amount2, v.amount, false, false)
		guiGridListSetItemData(GUIEditor.gridlist[2], row, item2, v.item)
	end
	
	addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
		local clicked = guiGridListGetItemText(GUIEditor.gridlist[1],  guiGridListGetSelectedItem(GUIEditor.gridlist[1]),  1)
		local amount = guiGetText(GUIEditor.edit[1])
		local row = guiGridListGetSelectedItem(GUIEditor.gridlist[1])
		local itemID = guiGridListGetItemData(GUIEditor.gridlist[1], row, item)
		if(clicked ~= "" and amount ~= "" and isOnlyNumbers(amount))then
			triggerServerEvent("Vehiclesystem.removeItemFromTrunk",localPlayer,itemID,amount)
		end
	end,false)
	
	addEventHandler("onClientGUIClick",GUIEditor.button[2],function()
		local clicked = guiGridListGetItemText(GUIEditor.gridlist[2],  guiGridListGetSelectedItem(GUIEditor.gridlist[2]),  1)
		local amount = guiGetText(GUIEditor.edit[1])
		local row = guiGridListGetSelectedItem(GUIEditor.gridlist[2])
		local itemID = guiGridListGetItemData(GUIEditor.gridlist[2], row, item2)
		if(clicked ~= "" and amount ~= "" and isOnlyNumbers(amount))then
			triggerServerEvent("Vehiclesystem.addItemToTrunk",localPlayer,itemID,amount)
		end
	end,false)
end)

addEvent("Vehiclesystem.updateTrunk",true)
addEventHandler("Vehiclesystem.updateTrunk",root,function(trunk)
	guiGridListClear(GUIEditor.gridlist[1])
	guiGridListClear(GUIEditor.gridlist[2])
	for _, v in pairs(trunk)do
		local row = guiGridListAddRow(GUIEditor.gridlist[1])
		guiGridListSetItemText(GUIEditor.gridlist[1], row, item, v.item, false, false)
		guiGridListSetItemText(GUIEditor.gridlist[1], row, amount, v.amount, false, false)
		guiGridListSetItemData(GUIEditor.gridlist[1], row, item, v.item)
	end
	
	for _, v in pairs(PlayerItems)do
		local row = guiGridListAddRow(GUIEditor.gridlist[2])
		guiGridListSetItemText(GUIEditor.gridlist[2], row, item2, v.item, false, false)
		guiGridListSetItemText(GUIEditor.gridlist[2], row, amount2, v.amount, false, false)
		guiGridListSetItemData(GUIEditor.gridlist[2], row, item2, v.item)
	end
end)