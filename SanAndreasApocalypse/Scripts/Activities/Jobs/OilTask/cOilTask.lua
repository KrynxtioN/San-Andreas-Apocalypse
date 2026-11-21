OilTask = {}

function OilTask.openWindow()
	if(isWindowOpen())then
        GUIEditor.window[1] = guiCreateWindow(649, 331, 271, 167, getText("COilTask3"), false)
        setWindowData()
		guiCreateCloseButton()

        GUIEditor.button[1] = guiCreateButton(10, 132, 251, 25, getText("COilTask1"), false, GUIEditor.window[1])
        GUIEditor.label[1] = guiCreateLabel(10, 28, 251, 94, getText("COilTask2"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", true)
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center") 

		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
			triggerServerEvent("OilTask.startDelivery",localPlayer)
		end,false)
	end
end

addEvent("OilTask.createDeliveryStuff",true)
addEventHandler("OilTask.createDeliveryStuff",root,function(playerData)
	OilTask.clientPlayerData = playerData
	local x,y,z = OilTask.clientPlayerData.DeliverySpawn[1],OilTask.clientPlayerData.DeliverySpawn[2],OilTask.clientPlayerData.DeliverySpawn[3]
	OilTask.DeliveryBlip = createBlip(x,y,z,53)
	OilTask.DeliveryMarker = createMarker(x,y,z,"cylinder",3,255,255,255,125)
	
	addEventHandler("onClientMarkerHit",OilTask.DeliveryMarker,function(player)
		if(player == localPlayer)then
			triggerServerEvent("OilTask.deliveryServer",localPlayer)
		end
	end)
end)

addEvent("OilTask.finishMarker",true)
addEventHandler("OilTask.finishMarker",root,function()
	OilTask.finishMarker = createMarker(878.47241210938,-27.737499237061,62.170299530029,"cylinder",3,255,255,255,125)
	OilTask.finishBlip = createBlip(878.47241210938,-27.737499237061,62.170299530029,53)
	
	addEventHandler("onClientMarkerHit",OilTask.finishMarker,function(player)
		if(player == localPlayer)then
			triggerServerEvent("OilTask.finishDelivery",localPlayer)
			destroyElement(source)
		end
	end)
end)

addEvent("OilTask.destroyDeliveryStuff",true)
addEventHandler("OilTask.destroyDeliveryStuff",root,function()
	if(isElement(OilTask.DeliveryMarker))then
		destroyElement(OilTask.DeliveryMarker)
	end
	if(isElement(OilTask.DeliveryBlip))then
		destroyElement(OilTask.DeliveryBlip)
	end
	if(isElement(OilTask.finishMarker))then
		destroyElement(OilTask.finishMarker)
	end
	if(isElement(OilTask.finishBlip))then
		destroyElement(OilTask.finishBlip)
	end
end)