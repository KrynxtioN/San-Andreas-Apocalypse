HalloweenTotem = {Marker = {}, Objects = {}}
apocalypseSetElementData(localPlayer,"HalloweenTotemBind",false)

addEvent("HalloweenTotem.destroyClient",true)
addEventHandler("HalloweenTotem.destroyClient",root,function()
	for _,v in pairs(HalloweenTotem.Marker)do
		destroyElement(v)
	end
	HalloweenTotem.Marker = {}
	
	for _,v in pairs(HalloweenTotem.Objects)do
		destroyElement(v)
	end
	HalloweenTotem.Objects = {}
end)

addEvent("HalloweenTotem.createMarker",true)
addEventHandler("HalloweenTotem.createMarker",root,function(x,y,z,id)
	HalloweenTotem.Marker[id] = createMarker(x,y,z,"cylinder",2,250,150,0,150)
	apocalypseSetElementData(HalloweenTotem.Marker[id],"HalloweenTotemID",id)
	
	addEventHandler("onClientMarkerHit",HalloweenTotem.Marker[id],function(player)
		if(player == localPlayer)then
			if(apocalypseGetElementData(localPlayer,"HalloweenTotemBind") == false)then
				bindKey("e","down",HalloweenTotem.bindKey)
			end
			createActivitiesInformationText(getText("CHalloweenTotem1"))
		end
	end)
end)

addEvent("HalloweenTotem.createTotem",true)
addEventHandler("HalloweenTotem.createTotem",root,function(x,y,z,id)
	HalloweenTotem.Objects[id] = createObject(3524,x,y,z,0,0,math.random(0,360))
	apocalypseSetElementData(HalloweenTotem.Objects[id],"HalloweenTotemID",id)
end)

function HalloweenTotem.bindKey()
	local markerID = nil
	for _,v in pairs(HalloweenTotem.Marker)do
		if(isElementWithinMarker(localPlayer,v))then
			markerID = apocalypseGetElementData(v,"HalloweenTotemID")
			break
		end
	end
	if(markerID ~= nil)then
		triggerServerEvent("HalloweenTotem.place",localPlayer,markerID)
	end
end