AreaCard = {Bind = false}

addEvent("AreaCard.createCard",true)
addEventHandler("AreaCard.createCard",root,function()
	if(not(isElement(AreaCard.Gate)))then
		AreaCard.Gate = createObject(2938,90.101303100586,-293.57620239258,3.1747000217438,0,0,88.75)
	end
	
	if(not(isElement(AreaCard.Pickup)))then
		AreaCard.Pickup = createPickup(89.323097229004,-310.24206542969,1.578125,3,1581,50)
		
		addEventHandler("onClientPickupHit",AreaCard.Pickup,function(player)
			if(player == localPlayer)then
				if(getElementDimension(localPlayer) == getElementDimension(source))then
					destroyElement(source)
					if(isElement(AreaCard.Gate))then destroyElement(AreaCard.Gate)end
					if(isElement(AreaCard.GateDynamiteMarker))then destroyElement(AreaCard.GateDynamiteMarker)end
					triggerServerEvent("AreaCard.giveCard",localPlayer)
				end
			end
		end)
	end
end)

addEvent("AreaCard.createMarker",true)
addEventHandler("AreaCard.createMarker",root,function()
	AreaCard.GateDynamiteMarker = createPickup(90.284553527832,-293.17077636719,1.578125,3,1239,50)
	
	addEventHandler("onClientPickupHit",AreaCard.GateDynamiteMarker,function(player)
		if(player == localPlayer)then
			if(getElementDimension(localPlayer) == getElementDimension(source))then
				if(AreaCard.Bind == false)then
					AreaCard.Bind = true
					bindKey("e","down",AreaCard.bindKey)
					createActivitiesInformationText(getText("SNests1"))
				end
			end
		end
	end)
end)

function AreaCard.bindKey()
	if(isElement(AreaCard.Gate))then
		local x,y,z = getElementPosition(AreaCard.GateDynamiteMarker)
		if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(localPlayer)) <= 5)then
			triggerServerEvent("AreaCard.placeDynamite",localPlayer)
		end
	end
end

addEvent("AreaCard.placeDynamite",true)
addEventHandler("AreaCard.placeDynamite",root,function()
	unbindKey("e","down",AreaCard.bindKey)
end)

addEvent("AreaCard.destroy",true)
addEventHandler("AreaCard.destroy",root,function()
	if(isElement(AreaCard.Gate))then destroyElement(AreaCard.Gate) end
	if(isElement(AreaCard.GateDynamiteMarker))then destroyElement(AreaCard.GateDynamiteMarker) end
end)

addEventHandler("onClientPlayerWasted",root,function()
	if(source == localPlayer)then
		unbindKey("e","down",AreaCard.bindKey)
	end
end)