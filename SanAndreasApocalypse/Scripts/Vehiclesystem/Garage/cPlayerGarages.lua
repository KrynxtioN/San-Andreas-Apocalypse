addEvent("PlayerGarages.createWindow",true)
addEventHandler("PlayerGarages.createWindow",root,function(owner,price)
	if(isWindowOpen())then
        GUIEditor.window[1] = guiCreateWindow(504, 330, 418, 145, getText("CPlayerGarages1"), false)
		setWindowData()
		guiCreateCloseButton()

        GUIEditor.label[1] = guiCreateLabel(10, 30, 398, 70, getText("CPlayerGarages2"):format(owner,price), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", true)
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
        GUIEditor.button[1] = guiCreateButton(9, 110, 399, 25, getText("CPlayerGarages3"), false, GUIEditor.window[1])
		
		if(owner ~= "/")then guiSetText(GUIEditor.button[1],getText("CPlayerGarages4"))end
		
		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
			if(guiGetText(GUIEditor.button[1]) == getText("CPlayerGarages4"))then
				triggerServerEvent("PlayerGarages.sell",localPlayer)
			else
				triggerServerEvent("PlayerGarages.buy",localPlayer)
			end
		end,false)
    end
end)