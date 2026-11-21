SpecialEngine = {Marker = {},
	["Marker"] = {
		{2442.8051757812,-1896.2073974609,12.496899604797,4},
	},
}

for i,v in ipairs(SpecialEngine["Marker"])do
	local marker = createMarker(v[1],v[2],v[3],"cylinder",v[4],255,255,255,75)
	apocalypseSetElementData(marker,"SpecialEngineGarageID",i)
	SpecialEngine.Marker[i] = marker
end

function SpecialEngine.createGarage(ID)
	SpecialEngine.PlayerVehicle = nil
	for _,v in pairs(getElementsByType("vehicle"))do
		if(isElementWithinMarker(v,SpecialEngine.Marker[ID]))then
			SpecialEngine.PlayerVehicle = v
			break
		end
	end
	if(SpecialEngine.PlayerVehicle ~= nil)then
		if(isWindowOpen())then
			GUIEditor.window[1] = guiCreateWindow(494, 364, 385, 258, getText("CSpecialEngine8"), false)
			guiWindowSetSizable(GUIEditor.window[1], false)
			setWindowData()
			guiCreateCloseButton()

			GUIEditor.label[1] = guiCreateLabel(10, 28, 365, 35, getText("CSpecialEngine3"), false, GUIEditor.window[1])
			guiSetFont(GUIEditor.label[1], "default-bold-small")
			guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", true)
			guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
			GUIEditor.label[2] = guiCreateLabel(10, 73, 116, 21, getText("CSpecialEngine4"):format(getVehicleNameFromModel(getElementModel(SpecialEngine.PlayerVehicle))), false, GUIEditor.window[1])
			guiSetFont(GUIEditor.label[2], "default-bold-small")
			guiLabelSetHorizontalAlign(GUIEditor.label[2], "center", true)
			guiLabelSetVerticalAlign(GUIEditor.label[2], "center")
			GUIEditor.label[3] = guiCreateLabel(136, 73, 239, 69, "", false, GUIEditor.window[1])
			guiSetFont(GUIEditor.label[3], "default-bold-small")
			guiLabelSetHorizontalAlign(GUIEditor.label[3], "center", true)
			guiLabelSetVerticalAlign(GUIEditor.label[3], "center")
			GUIEditor.button[1] = guiCreateButton(10, 229, 365, 19, getText("CSpecialEngine6"), false, GUIEditor.window[1])
			GUIEditor.label[4] = guiCreateLabel(10, 152, 365, 22, getText("CSpecialEngine7"), false, GUIEditor.window[1])
			guiSetFont(GUIEditor.label[4], "default-bold-small")
			guiLabelSetHorizontalAlign(GUIEditor.label[4], "center", true)
			guiLabelSetVerticalAlign(GUIEditor.label[4], "center")    
			NPC.NormalMessage(getText("CSpecialEngine2"))
			triggerServerEvent("SpecialEngine.getPrice",localPlayer,SpecialEngine.PlayerVehicle)
			
			addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
				triggerServerEvent("SpecialEngine.add",localPlayer,SpecialEngine.PlayerVehicle)
			end,false)
		end
	else
		NPC.NormalMessage(getText("CSpecialEngine1"))
	end
end

addEvent("SpecialEngine.updateText",true)
addEventHandler("SpecialEngine.updateText",root,function(level,money,vehicleParts,brainMass)
	guiSetText(GUIEditor.label[3],getText("CSpecialEngine5"):format(money,brainMass,vehicleParts))
end)