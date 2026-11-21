Shelter = {}
local Table = {}

addEvent("Shelter.createBlips",true)
addEventHandler("Shelter.createBlips",root,function(x,y,z,owner)
	createBlip(x,y,z,38,1,0,0,0,255,0,50)
	table.insert(Table,{x,y,z,owner})
end)

addEventHandler("onClientRender",root,function()
	if(isWindowOpen())then
		for _,v in pairs(Table)do
			local screenX, screenY = getScreenFromWorldPosition(v[1], v[2], v[3] + 0.4, 0.07)
			if screenX and screenY then
				if(getDistanceBetweenPoints3D(v[1],v[2],v[3],getElementPosition(localPlayer)) <= 3.5)then
					
					if(tonumber(v[4]) == 0)then
						dxDrawText(getText("CShelter1"), screenX - 50, screenY - 10, screenX + 50, screenY + 10, tocolor(255, 255, 255, 255), 1.2, "default-bold", "center", "center", false, false, false, true)
					else
						dxDrawText(getText("CShelter6"):format(v[4]), screenX - 50, screenY - 10, screenX + 50, screenY + 10, tocolor(255, 255, 255, 255), 1.2, "default-bold", "center", "center", false, false, false, true)
					end
				end
			end
		end
	end
end)

addEvent("Shelter.window", true)
addEventHandler("Shelter.window", root, function(price_money, price_brainmass, owner,colony)
    if(isWindowOpen())then
        GUIEditor.window[1] = guiCreateWindow(684, 358, 377, 150, getText("CShelter1"), false)
        setWindowData()
        guiCreateCloseButton()
        GUIEditor.label[1] = guiCreateLabel(10, 28, 357, 35, getText("CShelter2"):format(owner, price_money, price_brainmass), false, GUIEditor.window[1])
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
        
        if (owner ~= "-") then
            GUIEditor.button[1] = guiCreateButton(10, 73, 175, 29, getText("CShelter4"), false, GUIEditor.window[1])
            GUIEditor.button[2] = guiCreateButton(192, 73, 175, 29, getText("CShelter5"), false, GUIEditor.window[1])
            
            addEventHandler("onClientGUIClick", GUIEditor.button[2], function()
                triggerServerEvent("Shelter.spawnHere", localPlayer)
            end, false)
        else
            GUIEditor.button[1] = guiCreateButton(10, 73, 357, 29, getText("CShelter3"), false, GUIEditor.window[1])
        end

        addEventHandler("onClientGUIClick", GUIEditor.button[1], function()
            if (guiGetText(GUIEditor.button[1]) == getText("CShelter3")) then
                triggerServerEvent("Shelter.buyObject", localPlayer)
            else
                triggerServerEvent("Shelter.sellObject", localPlayer)
            end
        end, false)

        GUIEditor.toggleButton = guiCreateButton(10, 110, 357, 29, getText("CShelter8"), false, GUIEditor.window[1])
        local colonyEnabled = false
		if(tonumber(colony) >= 1)then
			colonyEnabled = true
			guiSetText(GUIEditor.toggleButton, getText("CShelter7"))
		end
        addEventHandler("onClientGUIClick", GUIEditor.toggleButton, function()
            colonyEnabled = not colonyEnabled
            if(colonyEnabled)then
                guiSetText(GUIEditor.toggleButton, getText("CShelter7"))
				triggerServerEvent("Shelter.switchColonyStatus",localPlayer,"on")
            else
                guiSetText(GUIEditor.toggleButton, getText("CShelter8"))
				triggerServerEvent("Shelter.switchColonyStatus",localPlayer,"off")
            end
        end,false)
    end
end)