StorageCrate = {}

addEvent("StorageCrate.createWindow", true)
addEventHandler("StorageCrate.createWindow", root, function(items, spaceUsed, playerItems)
    if isWindowOpen() then
        GUIEditor.window[1] = guiCreateWindow(235, 168, 613, 307, getText("CStorageCrate1"), false)
        centerWindow(GUIEditor.window[1])
        setWindowData()
        guiCreateCloseButton()

        GUIEditor.gridlist[1] = guiCreateGridList(11, 27, 395, 195, false, GUIEditor.window[1])
        item = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CStorageCrate2"), 0.5)
        amount = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CStorageCrate3"), 0.5)
        GUIEditor.label[1] = guiCreateLabel(11, 232, 395, 21, getText("CStorageCrate4"):format(spaceUsed), false, GUIEditor.window[1])
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
        GUIEditor.label[2] = guiCreateLabel(11, 276, 59, 21, getText("CStorageCrate5"), false, GUIEditor.window[1])
        guiLabelSetHorizontalAlign(GUIEditor.label[2], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[2], "center")
        GUIEditor.edit[1] = guiCreateEdit(80, 276, 98, 21, "", false, GUIEditor.window[1])
        GUIEditor.button[1] = guiCreateButton(188, 276, 104, 21, getText("CStorageCrate6"), false, GUIEditor.window[1])
        GUIEditor.button[2] = guiCreateButton(302, 276, 104, 21, getText("CStorageCrate7"), false, GUIEditor.window[1])
        GUIEditor.gridlist[2] = guiCreateGridList(416, 47, 187, 250, false, GUIEditor.window[1])
        item_player = guiGridListAddColumn(GUIEditor.gridlist[2], getText("CStorageCrate2"), 0.5)
        amount_player = guiGridListAddColumn(GUIEditor.gridlist[2], getText("CStorageCrate2"), 0.5)
        GUIEditor.label[3] = guiCreateLabel(416, 26, 187, 21, getText("CStorageCrate8"), false, GUIEditor.window[1])
        guiLabelSetHorizontalAlign(GUIEditor.label[3], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[3], "center")    
		
		StorageCrate.updateShop(items, spaceUsed, playerItems)

        addEventHandler("onClientGUIClick", GUIEditor.button[1], function()
            local row = guiGridListGetSelectedItem(GUIEditor.gridlist[2])
            if row ~= -1 then
                local itemID = guiGridListGetItemData(GUIEditor.gridlist[2], row, item)
                local amount = guiGetText(GUIEditor.edit[1])
                if #amount >= 1 and isOnlyNumbers(amount) then
                    triggerServerEvent("StorageCrate.addItemToChest", localPlayer, itemID, amount)
                end
            end
        end, false)

        addEventHandler("onClientGUIClick", GUIEditor.button[2], function()
            local row = guiGridListGetSelectedItem(GUIEditor.gridlist[1])
            if row ~= -1 then
                local itemID = guiGridListGetItemData(GUIEditor.gridlist[1], row, item_player)
                local amount = guiGetText(GUIEditor.edit[1])
                if #amount >= 1 and isOnlyNumbers(amount) then
                    triggerServerEvent("StorageCrate.removeItemFromChest", localPlayer, itemID, amount)
                end
            end
        end, false)
    end
end)

function StorageCrate.updateShop(items,totalAmount,playerItems)
	guiGridListClear(GUIEditor.gridlist[1])
	guiGridListClear(GUIEditor.gridlist[2])
	guiSetText(GUIEditor.label[1],getText("CStorageCrate4"):format(totalAmount))
	if(#items >= 1)then
		for _, v in pairs(items)do
			if(v.id and v.amount)then
				local row = guiGridListAddRow(GUIEditor.gridlist[1])
				guiGridListSetItemText(GUIEditor.gridlist[1], row, item, ItemInfos["items"][apocalypseGetElementData(localPlayer,"language") or "EN"][v.id], false, false)
				guiGridListSetItemText(GUIEditor.gridlist[1], row, amount, v.amount, false, false)
				guiGridListSetItemData(GUIEditor.gridlist[1], row, item, v.id)
			end
		end
	end
	if(#playerItems >= 1)then
		for _, v in pairs(playerItems)do
			local row = guiGridListAddRow(GUIEditor.gridlist[2])
			guiGridListSetItemText(GUIEditor.gridlist[2], row, item_player, ItemInfos["items"][apocalypseGetElementData(localPlayer,"language") or "EN"][v[1]], false, false)
			guiGridListSetItemText(GUIEditor.gridlist[2], row, amount_player, v[2], false, false)
			guiGridListSetItemData(GUIEditor.gridlist[2], row, item_player, v[1])
		end
	end
end
addEvent("StorageCrate.updateShop",true)
addEventHandler("StorageCrate.updateShop",root,StorageCrate.updateShop)