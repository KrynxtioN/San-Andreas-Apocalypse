Motel = {}
apocalypseSetElementData(localPlayer,"MotelBindKey",false)

function Motel.openWindow(membership)
	if(isWindowOpen())then
        GUIEditor.window[1] = guiCreateWindow(632, 327, 392, 154, getText("CMotel1"), false)
        setWindowData()
		guiCreateCloseButton()
		Motel.membership = tonumber(membership)

        GUIEditor.label[1] = guiCreateLabel(10, 31, 372, 79, getText("CMotel2"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", true)
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
        GUIEditor.button[1] = guiCreateButton(10, 120, 373, 24, getText("CMotel3"), false, GUIEditor.window[1])
		if(Motel.membership == 1)then
			guiSetText(GUIEditor.button[1],getText("CMotel4"))
		end

		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
			if(Motel.membership == 1)then
				triggerServerEvent("Motel.unrentRoom",localPlayer)
			else
				triggerServerEvent("Motel.rentRoom",localPlayer)
			end
		end,false)
    end
end
addEvent("Motel.openWindow",true)
addEventHandler("Motel.openWindow",root,Motel.openWindow)