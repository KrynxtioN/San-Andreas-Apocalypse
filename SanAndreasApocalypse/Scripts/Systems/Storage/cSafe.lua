addEvent("Safe.open", true)
addEventHandler("Safe.open", root, function()
	if(isCharacterLoggedIn() and isWindowOpen())then
		if(tonumber(apocalypseGetElementData(localPlayer, "level")) >= 5)then
			GUIEditor.window[1] = guiCreateWindow(627,  424,  316,  130,  getText("CSafe1"),  false)
			setWindowData()

			GUIEditor.label[1] = guiCreateLabel(10,  27,  296,  31,  "",  false,  GUIEditor.window[1])
			guiSetFont(GUIEditor.label[1],  "default-bold-small")
			guiLabelSetHorizontalAlign(GUIEditor.label[1],  "center",  false)
			guiLabelSetVerticalAlign(GUIEditor.label[1],  "center")
			GUIEditor.label[2] = guiCreateLabel(10,  68,  90,  21,  getText("CSafe3"),  false,  GUIEditor.window[1])
			guiSetFont(GUIEditor.label[2],  "default-bold-small")
			guiLabelSetHorizontalAlign(GUIEditor.label[2],  "center",  false)
			guiLabelSetVerticalAlign(GUIEditor.label[2],  "center")
			GUIEditor.button[1] = guiCreateButton(10,  99,  130,  21,  getText("CSafe4"),  false,  GUIEditor.window[1])
			GUIEditor.edit[1] = guiCreateEdit(110,  68,  196,  21,  "",  false,  GUIEditor.window[1])
			GUIEditor.button[2] = guiCreateButton(143,  99,  130,  21,  getText("CSafe5"),  false,  GUIEditor.window[1])
			GUIEditor.button[3] = guiCreateButton(281,  99,  25,  21,  "[X]",  false,  GUIEditor.window[1])    
			
			triggerServerEvent("Safe.getData", localPlayer)
			
			addEventHandler("onClientGUIClick", GUIEditor.button[1], function()
				local amount = guiGetText(GUIEditor.edit[1])
				if(#amount >= 1 and isOnlyNumbers(amount))then
					triggerServerEvent("Safe.StorageMoney_PutIn", localPlayer, amount)
				else
					createInfobox(getText("CSafe6"))
				end
			end, false)
			
			addEventHandler("onClientGUIClick", GUIEditor.button[2], function()
				local amount = guiGetText(GUIEditor.edit[1])
				if(#amount >= 1 and isOnlyNumbers(amount))then
					triggerServerEvent("Safe.StorageMoney_TakeOut", localPlayer, amount)
				else
					createInfobox(getText("CSafe6"))
				end
			end, false)
			
			addEventHandler("onClientGUIClick", GUIEditor.button[3], function()
				closeWindow()
			end, false)
		end
	end
end)

addEvent("Safe.updateLabel", true)
addEventHandler("Safe.updateLabel", root, function(amount)
	guiSetText(GUIEditor.label[1], getText("CSafe2"):format(tonumber(amount)))
end)