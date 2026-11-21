DiscoverPlaces = {
	["CameraMatrix"] = {
		[10] = {-290.01406860352,-2216.4841308594,46.015972137451,-239.56181335449,-2136.6513671875,13.132895469666}
	},
}

addEvent("DiscoverPlaces.createZone",true)
addEventHandler("DiscoverPlaces.createZone",root,function(i,x,y,w,h)
	local colRectangle = createColRectangle(x,y,w,h)
	apocalypseSetElementData(colRectangle,"PlaceID",tonumber(i))
	
	addEventHandler("onClientColShapeHit", colRectangle, function(hitElement)
		if(hitElement == localPlayer)then
			triggerServerEvent("addDiscoveredPlace",localPlayer,localPlayer,apocalypseGetElementData(source,"PlaceID"))
			destroyElement(source)
		end
	end)
end)