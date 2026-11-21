addEvent("PrestigeObjects.createWindow",true)
addEventHandler("PrestigeObjects.createWindow",root,function(ID,ownerName,money,experience)
	if(isWindowOpen())then
		local ID = tonumber(ID)
		local costs_money = PrestigeObjects["Infos"][ID]["Costs"].money
		local costs_brain = PrestigeObjects["Infos"][ID]["Costs"].brain
		local level = PrestigeObjects["Infos"][ID].level
		local objectName = PrestigeObjects["Infos"][ID]["Name"][apocalypseGetElementData(localPlayer,"language") or "EN"]
		local bonusText = PrestigeObjects["Bonus"][ID][apocalypseGetElementData(localPlayer,"language") or "EN"]
		local max_money, max_exp = PrestigeObjects["Infos"][ID].max_money, PrestigeObjects["Infos"][ID].max_exp

		GUIEditor.window[1] = guiCreateWindow(588, 324, 430, 219, "", false)
		setWindowData()
		guiCreateCloseButton()

		GUIEditor.label[1] = guiCreateLabel(10, 29, 410, 75, objectName, false, GUIEditor.window[1])
		guiSetFont(GUIEditor.label[1], "sa-header")
		guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", true)
		guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
		GUIEditor.label[2] = guiCreateLabel(10, 94, 410, 34, getText("CPrestige1"):format(costs_money,costs_brain,level,ownerName), false, GUIEditor.window[1])
		guiLabelSetHorizontalAlign(GUIEditor.label[2], "center", false)
		guiLabelSetVerticalAlign(GUIEditor.label[2], "center")
		GUIEditor.label[3] = guiCreateLabel(10, 128, 410, 53, bonusText, false, GUIEditor.window[1])
		guiLabelSetHorizontalAlign(GUIEditor.label[3], "center", true)
		guiLabelSetVerticalAlign(GUIEditor.label[3], "center")

		if(ownerName == "/")then
			GUIEditor.button[1] = guiCreateButton(10, 186, 200, 23, getText("CPrestige2"), false, GUIEditor.window[1])
			addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
				triggerServerEvent("PrestigeObjects.buy",localPlayer,ID)
			end,false)
		else
			if(ownerName == getCharacterName())then
				GUIEditor.button[1] = guiCreateButton(10, 186, 200, 23, "$"..money.."/$"..max_money.." und "..experience.."/"..max_exp.." EXP einsammeln.", false, GUIEditor.window[1])
				addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
					triggerServerEvent("PrestigeObjects.takeStuff",localPlayer,ID)
				end,false)

				GUIEditor.button[2] = guiCreateButton(220, 186, 200, 23, getText("CPrestige3"), false, GUIEditor.window[1])
				addEventHandler("onClientGUIClick",GUIEditor.button[2],function()
					triggerServerEvent("PrestigeObjects.sell",localPlayer,ID)
					closeWindow()
				end,false)
			end
		end
	end
end)