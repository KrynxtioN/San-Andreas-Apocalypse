addEvent("BigfootJail.openWindow",true)
addEventHandler("BigfootJail.openWindow",root,function()
	if(isWindowOpen())then
        GUIEditor.window[1] = guiCreateWindow(851, 462, 283, 132, getText("CBigfoot5"), false)
        guiWindowSetSizable(GUIEditor.window[1], false)
		setWindowData()
		guiCreateCloseButton()

        GUIEditor.label[1] = guiCreateLabel(10, 29, 263, 32, getText("CBigfoot6"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "left", true)
        GUIEditor.progressbar[1] = guiCreateProgressBar(10, 71, 263, 20, false, GUIEditor.window[1])

        GUIEditor.label[2] = guiCreateLabel(0, 0, 263, 20, "", false, GUIEditor.progressbar[1])
        guiSetFont(GUIEditor.label[2], "default-bold-small")
        guiLabelSetColor(GUIEditor.label[2], 0, 0, 0)
        guiLabelSetHorizontalAlign(GUIEditor.label[2], "center", true)
        guiLabelSetVerticalAlign(GUIEditor.label[2], "center")

        GUIEditor.button[1] = guiCreateButton(10, 101, 263, 21, getText("CBigfoot7"), false, GUIEditor.window[1])
		
		triggerServerEvent("BigfootJail.getData",localPlayer)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
			triggerServerEvent("BigfootJail.giveHead",localPlayer)
		end,false)
    end
end)

addEvent("BigfootJail.setData",true)
addEventHandler("BigfootJail.setData",root,function(heads)
	local heads = tonumber(heads)
	if(heads >= 5)then
		guiSetText(GUIEditor.button[1],getText("CBigfoot8"))
	end
	guiSetText(GUIEditor.label[2],heads.."/5")
	guiProgressBarSetProgress(GUIEditor.progressbar[1], (heads / 50) * 100)
end)