SpinosaurusClub = {generatedEXP = 0}

addEventHandler("onClientRender",root,function()
	if(isWindowOpen())then
		if (getElementDimension(localPlayer) == 0 and getElementInterior(localPlayer) == 0) then
			local posx, posy, posz = 2486.6328125,-1859.6248779297,1245.1112060547
			local sx, sy = getScreenFromWorldPosition(posx, posy, posz + 0.5)

			if (sx and sy) then
				if(SpinosaurusClub.generatedEXP ~= nil)then
					local px, py, pz = getElementPosition(localPlayer)
					local distance = getDistanceBetweenPoints3D(px, py, pz, posx, posy, posz)
					if (distance <= 7.5) then
						dxDrawText(getText("CBigfoot12"):format(math.floor(SpinosaurusClub.generatedEXP)), sx - 100, sy - 20, sx + 100, sy + 20, tocolor(255, 255, 255), 1.2, "default-bold", "center", "center")
					end
				end
			end
		end
	end
end)

addEvent("SpinosaurusClub.updateGeneratedEXP",true)
addEventHandler("SpinosaurusClub.updateGeneratedEXP",root,function(amount)
	SpinosaurusClub.generatedEXP = tonumber(amount)
end)

addEvent("SpinosaurusClub.Gate",true)
addEventHandler("SpinosaurusClub.Gate",root,function()
	SpinosaurusClub.Gate1 = createObject(969,-2490.939453125,-132.18359375,27.873699188232,0,0,90)
	SpinosaurusClub.Gate2 = createObject(969,-2490.939453125,-132.18359375,24.648700714111,0,0,90)
end)

addEvent("SpinosaurusClub.destroyGate",true)
addEventHandler("SpinosaurusClub.destroyGate",root,function()
	if(isElement(SpinosaurusClub.Gate1))then destroyElement(Spinosaurus.Gate1) end
	if(isElement(SpinosaurusClub.Gate2))then destroyElement(Spinosaurus.Gate2) end
end)

addEvent("Spinosaurus.handOverBones",true)
addEventHandler("Spinosaurus.handOverBones",root,function()
	if(isWindowOpen())then
        GUIEditor.window[1] = guiCreateWindow(851, 462, 283, 132, getText("CSpinosaurus1"), false)
        guiWindowSetSizable(GUIEditor.window[1], false)
		setWindowData()
		guiCreateCloseButton()

        GUIEditor.label[1] = guiCreateLabel(10, 29, 263, 32, getText("CSpinosaurus2"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "left", true)
        GUIEditor.progressbar[1] = guiCreateProgressBar(10, 71, 263, 20, false, GUIEditor.window[1])

        GUIEditor.button[1] = guiCreateButton(10, 101, 263, 21, getText("CSpinosaurus3"), false, GUIEditor.window[1])
		
		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
			triggerServerEvent("SpinosaurusClub.handOverBones",localPlayer)
		end,false)
    end
end)

function SpinosaurusClub.MoneyPickup()
	if(isWindowOpen())then
        GUIEditor.window[1] = guiCreateWindow(632, 335, 270, 151, getText("CSpinosaurus4"), false)
		setWindowData()
		guiCreateCloseButton()

        GUIEditor.label[1] = guiCreateLabel(10, 30, 250, 72, getText("CSpinosaurus5"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "left", true)
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
        GUIEditor.button[1] = guiCreateButton(10, 112, 250, 29, getText("CSpinosaurus6"), false, GUIEditor.window[1])    
		
		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
			triggerServerEvent("SpinosaurusClub.MoneyPickup",localPlayer)
		end,false)
    end
end