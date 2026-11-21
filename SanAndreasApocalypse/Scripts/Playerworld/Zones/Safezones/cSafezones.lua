Safezone = {
	Data = {}}
apocalypseSetElementData(localPlayer, "generatorWindowOpen", false)

function isPointInRectangle(px, py, zonex, zoney, zonewidth, zoneheight)
	return px >= zonex and px <= zonex + zonewidth and py >= zoney and py <= zoney + zoneheight
end

addEvent("Safezone.updateClient", true)
addEventHandler("Safezone.updateClient", root, function(data)
	for _, v in ipairs(data)do
		local id = v[1]
		local status = v[2]
		local fuel = v[3]
		local oil = v[4]
		local x, y, z = unpack(v[5])
		
		if(not(Safezone.Data[id]))then
			table.insert(Safezone.Data, {x, y, z, status, fuel, oil})
		else
			Safezone.Data[id] = {x, y, z, status, fuel, oil}
		end
	end
end)

local function drawTextAndProgressBar()
	if(#Safezone.Data >= 1)then
		if(apocalypseGetElementData(localPlayer,"generatorWindowOpen") == false)then
			for _, v in pairs(Safezone.Data)do
				local x, y, z = v[1], v[2], v[3]
				local status, fuel, oil = v[4], v[5], v[6]

				local screenX, screenY = getScreenFromWorldPosition(x, y, z, 0.07)
				if(screenX and screenY)then
					if(getDistanceBetweenPoints3D(x, y, z, getElementPosition(localPlayer)) <= 5)then
						dxDrawText(getText("CSafezone1"):format(fuel, oil), screenX - 50, screenY - 40, screenX + 50, screenY, tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "top")

						local barWidth, barHeight = 135, 15
						local barX, barY = screenX - (barWidth / 2), screenY - 20
						
						local textX = barX + barWidth / 2
						local textY = barY + barHeight / 2
						
						dxDrawRectangle(barX, barY, barWidth, barHeight, tocolor(0, 0, 0, 150))
						dxDrawRectangle(barX, barY, barWidth * status / 100, barHeight, tocolor(0, 255, 0, 200))
						dxDrawText(getText("CSafezone2"):format(status), textX, textY, textX, textY, tocolor(255, 255, 255, 255), 1-0, "default-bold", "center", "center")
					end
				end
			end
		end
	end
end
addEventHandler("onClientRender", root, drawTextAndProgressBar)

addEvent("Safezone.openGeneratorWindow", true)
addEventHandler("Safezone.openGeneratorWindow", root, function(ID)
	if(isWindowOpen())then
        GUIEditor.window[1] = guiCreateWindow(667, 326, 400, 162, getText("CSafezone3"), false)
		apocalypseSetElementData(localPlayer, "generatorWindowOpen", true)

        GUIEditor.progressbar[1] = guiCreateProgressBar(10, 25, 254, 25, false, GUIEditor.window[1])
        guiProgressBarSetProgress(GUIEditor.progressbar[1], 38)
        GUIEditor.progressbar[2] = guiCreateProgressBar(10, 60, 254, 25, false, GUIEditor.window[1])
        guiProgressBarSetProgress(GUIEditor.progressbar[2], 38)
        GUIEditor.progressbar[3] = guiCreateProgressBar(10, 95, 254, 25, false, GUIEditor.window[1])
        guiProgressBarSetProgress(GUIEditor.progressbar[3], 38)
        GUIEditor.button[1] = guiCreateButton(274, 25, 116, 25, getText("CSafezone4"), false, GUIEditor.window[1])
        GUIEditor.button[2] = guiCreateButton(274, 60, 116, 25, getText("CSafezone4"), false, GUIEditor.window[1])
        GUIEditor.button[3] = guiCreateButton(274, 95, 116, 25, getText("CSafezone5"), false, GUIEditor.window[1])
        GUIEditor.label[1] = guiCreateLabel(10, 25, 254, 25, getText("CSafezone7"):format(Safezone.Data[ID][5]), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        guiLabelSetColor(GUIEditor.label[1], 0, 0, 0)
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
        GUIEditor.label[2] = guiCreateLabel(10, 60, 254, 25, getText("CSafezone8"):format(Safezone.Data[ID][6]), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[2], "default-bold-small")
        guiLabelSetColor(GUIEditor.label[2], 0, 0, 0)
        guiLabelSetHorizontalAlign(GUIEditor.label[2], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[2], "center")
        GUIEditor.label[3] = guiCreateLabel(10, 95, 254, 25, getText("CSafezone2"):format(Safezone.Data[ID][4]), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[3], "default-bold-small")
        guiLabelSetColor(GUIEditor.label[3], 0, 0, 0)
        guiLabelSetHorizontalAlign(GUIEditor.label[3], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[3], "center")
        GUIEditor.button[4] = guiCreateButton(10, 130, 380, 22, getText("CSafezone6"), false, GUIEditor.window[1])
		
		setWindowData()
		triggerServerEvent("Safezone.sendDataToClient",localPlayer)
		
		addEventHandler("onClientGUIClick", GUIEditor.button[1], function()
			triggerServerEvent("generatorAdd", localPlayer, "fuel")
		end, false)
		
		addEventHandler("onClientGUIClick", GUIEditor.button[2], function()
			triggerServerEvent("generatorAdd", localPlayer, "oil")
		end, false)
		
		addEventHandler("onClientGUIClick", GUIEditor.button[3], function()
			triggerServerEvent("generatorAdd", localPlayer, "repair")
		end, false)
		
		addEventHandler("onClientGUIClick", GUIEditor.button[4], function()
			closeWindow()
			apocalypseSetElementData(localPlayer, "generatorWindowOpen", false)
		end, false)
	end
end)

addEvent("updateGeneratorInfos", true)
addEventHandler("updateGeneratorInfos", root, function()
	if(apocalypseGetElementData(localPlayer,"generatorWindowOpen") == true)then
		local generatorID = apocalypseGetElementData(localPlayer, "GeneratorID")
		guiSetText(GUIEditor.label[1], getText("CSafezone7"):format(Safezone.Data[generatorID][5]))
		guiSetText(GUIEditor.label[2], getText("CSafezone8"):format(Safezone.Data[generatorID][6]))
		guiSetText(GUIEditor.label[3], getText("CSafezone2"):format(Safezone.Data[generatorID][4]))
		
		guiProgressBarSetProgress(GUIEditor.progressbar[1], Safezone.Data[generatorID][5]/100*Safezone.Data[generatorID][5])
		guiProgressBarSetProgress(GUIEditor.progressbar[2], Safezone.Data[generatorID][6]/100*Safezone.Data[generatorID][6])
		guiProgressBarSetProgress(GUIEditor.progressbar[3], Safezone.Data[generatorID][4]/100*Safezone.Data[generatorID][4])
	end
end)