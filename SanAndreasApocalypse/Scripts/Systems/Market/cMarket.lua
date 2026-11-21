Market = {NPCs = {},
	["Peds"] = {
		[1] = {-1962.5380859375,97.692100524902,27.6875,90},
		[2] = {-1962.5380859375,93.692100524902,27.6875,90},
		[3] = {-1962.5380859375,89.692100524902,27.6875,90},
		[4] = {-1962.5380859375,85.692100524902,27.6875,90},
		[5] = {-1966.33984375,80.541015625,27.6875,0},
		[6] = {-1970.33984375,80.541015625,27.6875,0},
		[7] = {-1974.33984375,80.541015625,27.6875,0},
		[8] = {-1978.3403320312,80.541297912598,27.6875,0},
		[9] = {362.35549926758,-2033.4676513672,7.8301000595093,270},
		[10] = {362.27151489258,-2029.4680175781,7.8301000595093,270},
		[11] = {-2068.3745117188,-2445.8022460938,30.625,322},
		[12] = {-2071.0690917969,-2443.583984375,30.625,322},
		[13] = {2315.0673828125,66.103103637695,26.481399536133,270},
		[14] = {649.98168945312,-462.49389648438,16.335899353027,270},
		[15] = {650.07427978516,-458.65188598633,16.335899353027,270},
		[16] = {650.02282714844,-454.59671020508,16.33869934082,270},
		[17] = {650.04772949219,-450.50830078125,16.33869934082,270},
		[18] = {650.11151123047,-446.62991333008,16.335899353027,270},
		[19] = {213.61959838867,-270.29809570312,1.5780999660492,0},
		[20] = {210.71099853516,-253.80340576172,1.5780999660492,230},
		[21] = {-2229.2038574219,2377.0297851562,4.9843997955322,112},
		[22] = {431.51040649414,2538.1853027344,16.227300643921,180},
		[23] = {-2467.2492675781,-112.02529907227,25.707300186157,280},
		[24] = {-268.15670776367,-2183.0278320312,28.880899429321,114},
		[25] = {932.07940673828,-1073.5668945312,24.296199798584,90},
		[26] = {932.09838867188,-1077.6918945312,24.296199798584,90},
		[27] = {2315.9658203125,23.433000564575,26.484399795532,270},
		[28] = {1621.4416503906,692.19189453125,10.820300102234,270},
		[29] = {1621.4548339844,696.21740722656,10.820300102234,270},
		[30] = {1679.3341064453,742.03839111328,10.820300102234,270},
		[31] = {1679.2448730469,746.06237792969,10.820300102234,270},
	},
}

function Market.createPlayerPeds(tbl)
    if(tbl)then
        for _, v in pairs(tbl) do
            local pos = Market["Peds"][tonumber(v)]
            if(pos)then
				if(isElement(Market.NPCs[v]))then destroyElement(Market.NPCs[v])end
                Market.NPCs[v] = createPed(0, pos[1],pos[2],pos[3],pos[4])
            end
        end
    end
end
addEvent("Market.createPlayerPeds",true)
addEventHandler("Market.createPlayerPeds",root,Market.createPlayerPeds)

addEvent("Market.createWindow",true)
addEventHandler("Market.createWindow",root,function()
	if(isWindowOpen())then
	    GUIEditor.window[1] = guiCreateWindow(589, 393, 350, 133, getText("CMarket1"), false)
        setWindowData()
		guiCreateCloseButton()

        GUIEditor.label[1] = guiCreateLabel(12, 28, 328, 60, getText("CMarket2"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", true)
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
        GUIEditor.button[1] = guiCreateButton(12, 98, 328, 25, getText("CMarket3"), false, GUIEditor.window[1])
		
		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
			triggerServerEvent("Market.createMarket",localPlayer)
		end,false)
	end
end)

addEvent("Market.createShopWindow",true)
addEventHandler("Market.createShopWindow",root,function(items,owner)
	if(isWindowOpen())then
        GUIEditor.window[1] = guiCreateWindow(703, 362, 440, 328, getText("CMarket20"):format(owner), false)
        setWindowData()
		guiCreateCloseButton()

        GUIEditor.gridlist[1] = guiCreateGridList(10, 23, 421, 262, false, GUIEditor.window[1])
        Market.item = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CMarket4"), 0.3)
        Market.amount = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CMarket5"), 0.3)
        Market.price = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CMarket6"), 0.3)
        GUIEditor.button[1] = guiCreateButton(202, 295, 228, 23, getText("CMarket7"), false, GUIEditor.window[1])
        GUIEditor.label[1] = guiCreateLabel(10, 295, 109, 23, getText("CMarket8"), false, GUIEditor.window[1])
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
        GUIEditor.edit[1] = guiCreateEdit(129, 295, 63, 23, "", false, GUIEditor.window[1])
		
		Market.updateShop(items)

		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
			local selectedRow = guiGridListGetSelectedItem(GUIEditor.gridlist[1])
			if(selectedRow ~= -1)then
				local ItemID = guiGridListGetItemData(GUIEditor.gridlist[1], selectedRow, Market.item)
				local amount = guiGetText(GUIEditor.edit[1])
				if(#amount >= 1)then
					if(isOnlyNumbers(amount))then
						triggerServerEvent("Market.buyItem",localPlayer,ItemID,amount)
					end
				end
			end
		end,false)
    end
end)

function Market.updateShop(items)
	guiGridListClear(GUIEditor.gridlist[1])
	if(#items >= 1)then
		for _, v in pairs(items)do
			if(v.id and v.amount and v.price)then
				local row = guiGridListAddRow(GUIEditor.gridlist[1])
				guiGridListSetItemText(GUIEditor.gridlist[1], row, Market.item, ItemInfos["items"][apocalypseGetElementData(localPlayer,"language") or "EN"][v.id], false, false)
				guiGridListSetItemText(GUIEditor.gridlist[1], row, Market.amount, v.amount, false, false)
				guiGridListSetItemText(GUIEditor.gridlist[1], row, Market.price, "$"..v.price, false, false)
				guiGridListSetItemData(GUIEditor.gridlist[1], row, Market.item, v.id)
			end
		end
	end
end
addEvent("Market.updateShop",true)
addEventHandler("Market.updateShop",root,Market.updateShop)

addEvent("Market.settings",true)
addEventHandler("Market.settings",root,function()
	if(isWindowOpen())then
        GUIEditor.window[1] = guiCreateWindow(537, 291, 765, 413, "", false)
        setWindowData()
		guiCreateCloseButton()

        GUIEditor.gridlist[1] = guiCreateGridList(9, 55, 205, 348, false, GUIEditor.window[1])
        item_player = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CMarket9"), 0.7)
        amount_player = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CMarket10"), 0.3)
        GUIEditor.gridlist[2] = guiCreateGridList(307, 55, 298, 348, false, GUIEditor.window[1])
        item_market = guiGridListAddColumn(GUIEditor.gridlist[2], getText("CMarket9"), 0.5)
        amount_market = guiGridListAddColumn(GUIEditor.gridlist[2], getText("CMarket10"), 0.2)
        price_market = guiGridListAddColumn(GUIEditor.gridlist[2], getText("CMarket11"), 0.2)
        GUIEditor.button[1] = guiCreateButton(224, 202, 73, 26, ">>", false, GUIEditor.window[1])
        GUIEditor.button[2] = guiCreateButton(224, 238, 73, 26, "<<", false, GUIEditor.window[1])
        GUIEditor.label[1] = guiCreateLabel(224, 274, 73, 27, getText("CMarket12"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
        GUIEditor.edit[1] = guiCreateEdit(224, 311, 73, 24, "", false, GUIEditor.window[1])
        GUIEditor.label[2] = guiCreateLabel(9, 30, 205, 25, getText("CMarket13"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[2], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[2], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[2], "center")
        GUIEditor.label[3] = guiCreateLabel(307, 30, 298, 25, getText("CMarket14"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[3], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[3], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[3], "center")
        GUIEditor.edit[2] = guiCreateEdit(615, 346, 140, 24, "", false, GUIEditor.window[1])
        GUIEditor.label[4] = guiCreateLabel(615, 309, 140, 27, getText("CMarket15"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[4], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[4], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[4], "center")
        GUIEditor.button[3] = guiCreateButton(615, 380, 140, 23, getText("CMarket16"), false, GUIEditor.window[1])
        GUIEditor.label[5] = guiCreateLabel(615, 30, 140, 71, "", false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[5], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[5], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[5], "center")
        GUIEditor.label[6] = guiCreateLabel(615, 111, 140, 27, getText("CMarket18"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[6], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[6], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[6], "center")
        GUIEditor.edit[3] = guiCreateEdit(615, 148, 140, 24, "", false, GUIEditor.window[1])
        GUIEditor.button[4] = guiCreateButton(615, 182, 140, 23, getText("CMarket19"), false, GUIEditor.window[1])
		
		triggerServerEvent("Market.getMarketData",localPlayer)

		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
			local selectedRow = guiGridListGetSelectedItem(GUIEditor.gridlist[1])
			if(selectedRow ~= -1)then
				local ItemID = guiGridListGetItemData(GUIEditor.gridlist[1], selectedRow, item_player)
				local amount = guiGetText(GUIEditor.edit[1])
				if(#amount >= 1)then
					if(isOnlyNumbers(amount))then
						triggerServerEvent("Market.addItemToMarket",localPlayer,ItemID,amount)
					end
				end
			end
		end,false)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[2],function()
			local selectedRow = guiGridListGetSelectedItem(GUIEditor.gridlist[2])
			if(selectedRow ~= -1)then
				local ItemID = guiGridListGetItemData(GUIEditor.gridlist[2], selectedRow, item_player)
				local amount = guiGetText(GUIEditor.edit[1])
				if(#amount >= 1 and ItemID)then
					if(isOnlyNumbers(amount))then
						triggerServerEvent("Market.removeItemToMarket",localPlayer,ItemID,amount)
					end
				end
			end
		end,false)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[3],function()
			local selectedRow = guiGridListGetSelectedItem(GUIEditor.gridlist[2])
			if(selectedRow ~= -1)then
				local ItemID = guiGridListGetItemData(GUIEditor.gridlist[2], selectedRow, item_player)
				local price = guiGetText(GUIEditor.edit[2])
				if(#price >= 1 and ItemID)then
					if(isOnlyNumbers(price))then
						triggerServerEvent("Market.changePrice",localPlayer,ItemID,price)
					end
				end
			end
		end,false)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[4],function()
			local amount = guiGetText(GUIEditor.edit[3])
			if(#amount >= 1)then
				if(isOnlyNumbers(amount))then
					triggerServerEvent("Market.takeMoney",localPlayer,amount)
				end
			end
		end,false)
    end
end)

function Market.updateMarketSettings(marketItems,playerItems,marketplaceMoney)
	guiGridListClear(GUIEditor.gridlist[1])
	guiGridListClear(GUIEditor.gridlist[2])
	guiSetText(GUIEditor.label[5],getText("CMarket17"):format(marketplaceMoney))
	if(#playerItems >= 1)then
		for _, v in pairs(playerItems)do
			local row = guiGridListAddRow(GUIEditor.gridlist[1])
			guiGridListSetItemText(GUIEditor.gridlist[1], row, item_player, ItemInfos["items"][apocalypseGetElementData(localPlayer,"language") or "EN"][v[1]], false, false)
			guiGridListSetItemText(GUIEditor.gridlist[1], row, amount_player, v[2], false, false)
			guiGridListSetItemData(GUIEditor.gridlist[1], row, item_player, v[1])
		end
	end
	if(#marketItems >= 1)then
		for _, v in pairs(marketItems)do
			if(v.id and v.amount and v.price)then
				local row = guiGridListAddRow(GUIEditor.gridlist[2])
				guiGridListSetItemText(GUIEditor.gridlist[2], row, item_market, ItemInfos["items"][apocalypseGetElementData(localPlayer,"language") or "EN"][v.id], false, false)
				guiGridListSetItemText(GUIEditor.gridlist[2], row, amount_market, v.amount, false, false)
				guiGridListSetItemText(GUIEditor.gridlist[2], row, price_market, "$"..v.price, false, false)
				guiGridListSetItemData(GUIEditor.gridlist[2], row, item_market, v.id)
			end
		end
	end
end
addEvent("Market.updateMarketSettings",true)
addEventHandler("Market.updateMarketSettings",root,Market.updateMarketSettings)