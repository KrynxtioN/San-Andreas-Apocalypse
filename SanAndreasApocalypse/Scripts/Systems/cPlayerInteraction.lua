PlayerInteraction = {}

addEvent("PlayerInteraction",true)
addEventHandler("PlayerInteraction",root,function()
	if(isWindowOpen())then
        GUIEditor.window[1] = guiCreateWindow(755, 389, 337, 344, getText("CPlayerInteraction1"), false)
		setWindowData()
		guiCreateCloseButton()

        GUIEditor.tabpanel[1] = guiCreateTabPanel(10, 28, 317, 254, false, GUIEditor.window[1])

        GUIEditor.tab[1] = guiCreateTab(getText("CPlayerInteraction2"), GUIEditor.tabpanel[1])

        GUIEditor.gridlist[1] = guiCreateGridList(10, 10, 297, 210, false, GUIEditor.tab[1])
        item = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CPlayerInteraction3"), 0.5)
        amount = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CPlayerInteraction4"), 0.5)
		
        GUIEditor.button[1] = guiCreateButton(166, 292, 161, 20, getText("CPlayerInteraction6"), false, GUIEditor.window[1])
        GUIEditor.edit[1] = guiCreateEdit(90, 292, 66, 20, "", false, GUIEditor.window[1])
        GUIEditor.label[1] = guiCreateLabel(10, 292, 70, 20, getText("CPlayerInteraction5"), false, GUIEditor.window[1])
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
        GUIEditor.button[2] = guiCreateButton(10, 316, 317, 18, getText("CPlayerInteraction7"), false, GUIEditor.window[1])
		
		triggerServerEvent("PlayerInteraction.getItems",localPlayer)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
			local selectedRow = guiGridListGetSelectedItem(GUIEditor.gridlist[1])
			if(selectedRow ~= -1)then
				local ItemID = guiGridListGetItemData(GUIEditor.gridlist[1], selectedRow, item)
				if(ItemID)then
					local amount = guiGetText(GUIEditor.edit[1])
					if(#amount >= 1)then
						if(isOnlyNumbers(amount))then
							triggerServerEvent("PlayerInteraction.giveItem",localPlayer,ItemID,amount)
						end
					end
				end
			end
		end,false)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[2],function()
			triggerServerEvent("addFriend",localPlayer)
		end,false)
    end
end)

addEvent("PlayerInteraction.updateItems",true)
addEventHandler("PlayerInteraction.updateItems",root,function(items, vehicles)
	guiGridListClear(GUIEditor.gridlist[1])
	for _, v in pairs(items)do
		local row = guiGridListAddRow(GUIEditor.gridlist[1])
		guiGridListSetItemText(GUIEditor.gridlist[1], row, item, ItemInfos["items"][apocalypseGetElementData(localPlayer,"language") or "EN"][v[1]], false, false)
		guiGridListSetItemText(GUIEditor.gridlist[1], row, amount, v[2], false, false)
		guiGridListSetItemData(GUIEditor.gridlist[1], row, item, v[1])
	end
end)