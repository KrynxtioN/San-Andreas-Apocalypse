Graveyardshop = {
	["Items"] = {
		["DE"] = {
			{"Dünger",25},
			{"Superdünger",50},
			{"Spezial Dünger",500},
			{"Schaufel",250},
			{"Gießkanne",3500},
		},
		["EN"] = {
			{"Fertilizer", 25},
			{"Super Fertilizer", 50},
			{"Special Fertilizer", 500},
			{"Shovel", 250},
			{"Watering Can",3500},
		},
		["RU"] = {
			{"Удобрение",25},
			{"Суперудобрение",50},
			{"Специальное удобрение",500},
			{"Лопата",250},
			{"Лейка",3500},
		},
		["PT"] = {
			{"Fertilizante",25},
			{"Superfertilizante",50},
			{"Fertilizante Especial",500},
			{"Pá",250},
			{"Regador",3500},
		},
	},
}

function Graveyardshop.openWindow()
	if(isWindowOpen())then
        GUIEditor.window[1] = guiCreateWindow(254, 298, 421, 234, "", false)
        setWindowData()
		guiCreateCloseButton()

        GUIEditor.gridlist[1] = guiCreateGridList(9, 27, 230, 197, false, GUIEditor.window[1])
        local item = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CGraveyardshop1"), 0.7)
        local costs = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CGraveyardshop2"), 0.7)
        GUIEditor.button[1] = guiCreateButton(249, 202, 162, 21, getText("CGraveyardshop4"), false, GUIEditor.window[1])
        GUIEditor.label[1] = guiCreateLabel(249, 27, 162, 91, getText("CGraveyardshop3"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "left", true)
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
        GUIEditor.edit[1] = guiCreateEdit(249, 172, 162, 20, "", false, GUIEditor.window[1])
		
		NPC.NormalMessage(getText("CDrBrain6"))
		
		for _, v in pairs(Graveyardshop["Items"][apocalypseGetElementData(localPlayer,"language") or "EN"])do
			local row = guiGridListAddRow(GUIEditor.gridlist[1])
			guiGridListSetItemText(GUIEditor.gridlist[1],row,item,v[1],false,false)
			guiGridListSetItemText(GUIEditor.gridlist[1],row,costs,"$"..v[2],false,false)
		end
		
		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
			local amount = guiGetText(GUIEditor.edit[1])
			if(#amount == 0)then amount = 1 end
			if(isOnlyNumbers(amount) == true)then
				local clickedItem = guiGridListGetItemText(GUIEditor.gridlist[1], guiGridListGetSelectedItem(GUIEditor.gridlist[1]),1)
				if(clickedItem and clickedItem ~= "")then
					triggerServerEvent("Graveyardshop.buyItem",localPlayer,clickedItem,amount)
				end
			end
		end,false)
	end
end