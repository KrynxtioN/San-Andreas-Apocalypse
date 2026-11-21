HalloweenHearse = {}

addEvent("HalloweenHearse.createDelivery",true)
addEventHandler("HalloweenHearse.createDelivery",root,function()
	HalloweenHearse.DeliveryMarker = createMarker(775.05261230469,-1126.3198242188,22.928100585938,"cylinder",3,250,100,0,125)
	HalloweenHearse.Blip = createBlip(775.05261230469,-1126.3198242188,22.928100585938,53)
	
	addEventHandler("onClientMarkerHit",HalloweenHearse.DeliveryMarker,function(player)
		if(player == localPlayer)then
			triggerServerEvent("HalloweenHearse.ServerDelivery",localPlayer)
		end
	end)
end)

addEvent("HalloweenHearse.destroyDelivery",true)
addEventHandler("HalloweenHearse.destroyDelivery",root,function()
	if(isElement(HalloweenHearse.DeliveryMarker))then
		destroyElement(HalloweenHearse.DeliveryMarker)
	end
	if(isElement(HalloweenHearse.Blip))then
		destroyElement(HalloweenHearse.Blip)
	end
end)