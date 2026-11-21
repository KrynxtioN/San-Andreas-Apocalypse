BigfootClub = {generatedEXP = 0}

addEventHandler("onClientRender",root,function()
	if(isWindowOpen())then
		if (getElementDimension(localPlayer) == 0 and getElementInterior(localPlayer) == 0) then
			local posx, posy, posz = -263.75231933594,-2178.7307128906,28.967338562012
			local sx, sy = getScreenFromWorldPosition(posx, posy, posz + 0.5)

			if (sx and sy) then
				if(BigfootClub.generatedEXP ~= nil)then
					local px, py, pz = getElementPosition(localPlayer)
					local distance = getDistanceBetweenPoints3D(px, py, pz, posx, posy, posz)
					if (distance <= 7.5) then
						dxDrawText(getText("CBigfoot12"):format(math.floor(BigfootClub.generatedEXP)), sx - 100, sy - 20, sx + 100, sy + 20, tocolor(255, 255, 255), 1.2, "default-bold", "center", "center")
					end
				end
			end
		end
	end
end)

addEvent("Bigfoot.updateGeneratedEXP",true)
addEventHandler("Bigfoot.updateGeneratedEXP",root,function(amount)
	BigfootClub.generatedEXP = tonumber(amount)
end)

addEvent("BigfootClub.createGate",true)
addEventHandler("BigfootClub.createGate",root,function()
	BigfootClub.Gate = createObject(980,-281.58020019531,-2195.4072265625,30.405000686646,0,0,114.75)
end)

addEvent("BigfootClub.destroyGate",true)
addEventHandler("BigfootClub.destroyGate",root,function()
	if(isElement(BigfootClub.Gate))then
		destroyElement(BigfootClub.Gate)
	end
end)

addEvent("BigfootClub.MoneyPickup",true)
addEventHandler("BigfootClub.MoneyPickup",root,function()
	if(isWindowOpen())then
        GUIEditor.window[1] = guiCreateWindow(632, 335, 270, 151, getText("CBigfoot9"), false)
		setWindowData()
		guiCreateCloseButton()

        GUIEditor.label[1] = guiCreateLabel(10, 30, 250, 72, getText("CBigfoot10"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "left", true)
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
        GUIEditor.button[1] = guiCreateButton(10, 112, 250, 29, getText("CBigfoot11"), false, GUIEditor.window[1])    
		
		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
			triggerServerEvent("BigfootClub.MoneyPickup",localPlayer)
		end,false)
    end
end)