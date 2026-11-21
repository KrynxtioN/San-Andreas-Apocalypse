ColonyWarehouse = {
	["Marker"] = {
        {1591.3603515625,739.3515625,10.8203125,1}, 
        {1621.0200195312,739.43225097656,10.8203125,2}, 
		{1648.8345947266,739.35119628906,10.8203125,3},
		{1678.4948730469,739.38659667969,10.8203125,4},
		{1710.1187744141,739.36706542969,10.8203125,5},
		{1739.7778320312,739.41748046875,10.8203125,6},
		{1590.9685058594,701.48791503906,10.827854156494,7},
		{1620.6279296875,701.51110839844,10.8203125,8},
		{1649.6179199219,701.50524902344,10.8203125,9},
		{1679.279296875,701.54223632812,10.8203125,10},
		{1709.7264404297,701.48315429688,10.8203125,11},
		{1739.3894042969,701.51165771484,10.8203125,12},
	},
}

addEventHandler("onClientRender",root,function()
	if(isCharacterLoggedIn())then
		if(isWindowOpen())then
			for _,v in pairs(ColonyWarehouse["Marker"])do
				local vx,vy,vz = v[1],v[2],v[3]
				local distanceText = getText("CColonyWarehouse9"):format(v[4])
				local screenX,screenY = getScreenFromWorldPosition(vx,vy,vz+2)
				if(getDistanceBetweenPoints3D(vx,vy,vz,getElementPosition(localPlayer)) <= 7.5)then
					if(screenX and screenY)then
						dxDrawText(distanceText, screenX - 100, screenY - 50, screenX + 100, screenY + 50, tocolor(255, 255, 255), 1.2, "default-bold", "center", "center")
					end
				end
			end
		end
	end
end)

addEvent("ColonyWarehouse.createWindow", true)
addEventHandler("ColonyWarehouse.createWindow", root, function(WarehouseID)
    if(isWindowOpen())then
        GUIEditor.window[1] = guiCreateWindow(235, 168, 613, 307, getText("CColonyWarehouse1"), false)
        centerWindow(GUIEditor.window[1])
        setWindowData()
        guiCreateCloseButton()

        GUIEditor.gridlist[1] = guiCreateGridList(11, 27, 395, 195, false, GUIEditor.window[1])
        item = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CColonyWarehouse2"), 0.5)
        amount = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CColonyWarehouse3"), 0.5)
        GUIEditor.label[1] = guiCreateLabel(11, 232, 395, 21, getText("CColonyWarehouse4"):format(0,0), false, GUIEditor.window[1])
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
        GUIEditor.label[2] = guiCreateLabel(11, 276, 59, 21, getText("CColonyWarehouse5"), false, GUIEditor.window[1])
        guiLabelSetHorizontalAlign(GUIEditor.label[2], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[2], "center")
        GUIEditor.edit[1] = guiCreateEdit(80, 276, 98, 21, "", false, GUIEditor.window[1])
        GUIEditor.button[1] = guiCreateButton(188, 276, 104, 21, getText("CColonyWarehouse6"), false, GUIEditor.window[1])
        GUIEditor.button[2] = guiCreateButton(302, 276, 104, 21, getText("CColonyWarehouse7"), false, GUIEditor.window[1])
        GUIEditor.gridlist[2] = guiCreateGridList(416, 47, 187, 250, false, GUIEditor.window[1])
        item_player = guiGridListAddColumn(GUIEditor.gridlist[2], getText("CColonyWarehouse2"), 0.5)
        amount_player = guiGridListAddColumn(GUIEditor.gridlist[2], getText("CColonyWarehouse2"), 0.5)
        GUIEditor.label[3] = guiCreateLabel(416, 26, 187, 21, getText("CColonyWarehouse8"), false, GUIEditor.window[1])
        guiLabelSetHorizontalAlign(GUIEditor.label[3], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[3], "center")
		apocalypseSetElementData(localPlayer,"WarehouseID_inUse",WarehouseID)
		
		triggerServerEvent("ColonyWarehouse.getData",localPlayer,localPlayer,tonumber(WarehouseID))

        addEventHandler("onClientGUIClick", GUIEditor.button[1], function()
            local row = guiGridListGetSelectedItem(GUIEditor.gridlist[2])
            if row ~= -1 then
                local itemID = guiGridListGetItemData(GUIEditor.gridlist[2], row, item_player)
                local amount = guiGetText(GUIEditor.edit[1])
                if #amount >= 1 and isOnlyNumbers(amount) then
                    triggerServerEvent("ColonyWarehouse.storeItem", localPlayer, apocalypseGetElementData(localPlayer,"WarehouseID_inUse"), itemID, amount)
                end
            end
        end, false)

        addEventHandler("onClientGUIClick", GUIEditor.button[2], function()
            local row = guiGridListGetSelectedItem(GUIEditor.gridlist[1])
            if row ~= -1 then
                local itemID = guiGridListGetItemData(GUIEditor.gridlist[1], row, item_player)
                local amount = guiGetText(GUIEditor.edit[1])
                if #amount >= 1 and isOnlyNumbers(amount) then
                    triggerServerEvent("ColonyWarehouse.removeItem", localPlayer, apocalypseGetElementData(localPlayer,"WarehouseID_inUse"), itemID, amount)
                end
            end
        end, false)
    end
end)

function ColonyWarehouse.updateData(items,totalAmount,playerItems,maxAmount)
	guiGridListClear(GUIEditor.gridlist[1])
	guiGridListClear(GUIEditor.gridlist[2])
	guiSetText(GUIEditor.label[1],getText("CColonyWarehouse4"):format(totalAmount,maxAmount))
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
addEvent("ColonyWarehouse.updateData",true)
addEventHandler("ColonyWarehouse.updateData",root,ColonyWarehouse.updateData)