DrBrain = {
	["Items"] = { -- Name, Costs {Item, Amount}
		["EN"] = {
			{"Syringe",{1,5}},
			{"Syringe Crafting Recipe",{30,50}},
		},
		["DE"] = {
			{"Spritze",{1,5}},
			{"Spritze Herstellungsrezept",{30,50}},
		},
		["RU"] = {
			{"Шприц",{1,5}},
			{"Рецепт изготовления шприца",{30,50}},
		},
		["PT"] = {
			{"Seringa",{1,5}},
			{"Receita para fabricar seringa",{30,50}},
		},
	},
}

function DrBrain.Interact()
	if(isWindowOpen())then
        GUIEditor.window[1] = guiCreateWindow(254, 298, 421, 234, "", false)
        setWindowData()
		guiCreateCloseButton()

        GUIEditor.gridlist[1] = guiCreateGridList(9, 27, 230, 197, false, GUIEditor.window[1])
        local item = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CDrBrain1"), 0.7)
        local costs = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CDrBrain2"), 0.7)
        GUIEditor.button[1] = guiCreateButton(249, 202, 162, 21, getText("CDrBrain3"), false, GUIEditor.window[1])
        GUIEditor.label[1] = guiCreateLabel(249, 27, 162, 91, getText("CDrBrain4"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "left", true)
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
        GUIEditor.label[2] = guiCreateLabel(249, 150, 162, 22, getText("CDrBrain5"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[2], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[2], "left", true)
        guiLabelSetVerticalAlign(GUIEditor.label[2], "center")
        GUIEditor.edit[1] = guiCreateEdit(249, 172, 162, 20, "", false, GUIEditor.window[1])
		
		NPC.NormalMessage(getText("CDrBrain6"))
		
		for _, v in pairs(DrBrain["Items"][apocalypseGetElementData(localPlayer,"language") or "EN"])do
			local row = guiGridListAddRow(GUIEditor.gridlist[1])
			guiGridListSetItemText(GUIEditor.gridlist[1],row,item,v[1],false,false)
			guiGridListSetItemText(GUIEditor.gridlist[1],row,costs,v[2][2].." "..ItemInfos["items"][apocalypseGetElementData(localPlayer,"language") or "EN"][v[2][1]],false,false)
		end
		
		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
			local amount = guiGetText(GUIEditor.edit[1])
			if(#amount == 0)then amount = 1 end
			
			if(isOnlyNumbers(amount))then
				local clickedItem = guiGridListGetItemText(GUIEditor.gridlist[1], guiGridListGetSelectedItem(GUIEditor.gridlist[1]),1)
				if(clickedItem and clickedItem ~= "")then
					triggerServerEvent("DrBrain.Buy",localPlayer,clickedItem,amount)
				end
			end
		end,false)
	end
end
addEvent("DrBrain.Interact",true)
addEventHandler("DrBrain.Interact",root,DrBrain.Interact)