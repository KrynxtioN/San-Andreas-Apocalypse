UndergroundGarageClient = {
	ActivePickups = {},
	Title = getText("CUndergroundGarage1"),
	Subtitle = getText("CUndergroundGarage2"),
	DrawDistance = 25
}

addEvent("UndergroundGarage:fullSync",true)
addEventHandler("UndergroundGarage:fullSync",resourceRoot,function(pickups)
	UndergroundGarageClient.ActivePickups = pickups or {}
end)

addEvent("UndergroundGarage:syncPickup",true)
addEventHandler("UndergroundGarage:syncPickup",resourceRoot,function(ID,pickup)
	if(ID and isElement(pickup))then
		UndergroundGarageClient.ActivePickups[ID] = pickup
	end
end)

addEventHandler("onClientElementDestroy",root,function()
	for ID,pickup in pairs(UndergroundGarageClient.ActivePickups) do
		if(pickup == source)then
			UndergroundGarageClient.ActivePickups[ID] = nil
			break
		end
	end
end)

addEventHandler("onClientRender",root,function()
	local px,py,pz = getElementPosition(localPlayer)
	local playerDimension = getElementDimension(localPlayer)
	local playerInterior = getElementInterior(localPlayer)

	for ID,pickup in pairs(UndergroundGarageClient.ActivePickups) do
		if(isElement(pickup))then
			if(getElementDimension(pickup) == playerDimension and getElementInterior(pickup) == playerInterior)then
				local x,y,z = getElementPosition(pickup)
				local distance = getDistanceBetweenPoints3D(px,py,pz,x,y,z)

				if(distance <= UndergroundGarageClient.DrawDistance)then
					local sx,sy = getScreenFromWorldPosition(x,y,z + 1.1)

					if(sx and sy)then
						local alpha = math.max(0,255 - ((distance / UndergroundGarageClient.DrawDistance) * 155))

						dxDrawText(UndergroundGarageClient.Title,sx + 1,sy - 18,sx + 1,sy - 18,tocolor(0,0,0,alpha),1,"default-bold","center","center")
						dxDrawText(UndergroundGarageClient.Title,sx,sy - 18,sx,sy - 18,tocolor(255,180,80,alpha),1,"default-bold","center","center")

						dxDrawText(UndergroundGarageClient.Subtitle,sx + 1,sy,sx + 1,sy,tocolor(0,0,0,alpha),0.9,"default-bold","center","center")
						dxDrawText(UndergroundGarageClient.Subtitle,sx,sy,sx,sy,tocolor(255,255,255,alpha),0.9,"default-bold","center","center")
					end
				end
			end
		else
			UndergroundGarageClient.ActivePickups[ID] = nil
		end
	end
end)