HungryThirstyPedMissionClient = {
	ActivePeds = {},
	DrawDistance = 25,
	TextScale = 1,
	Font = "default-bold"
}

addEvent("HungryThirstyPedMission:fullSync",true)
addEventHandler("HungryThirstyPedMission:fullSync",resourceRoot,function(peds)
	HungryThirstyPedMissionClient.ActivePeds = peds or {}
end)

addEvent("HungryThirstyPedMission:syncPed",true)
addEventHandler("HungryThirstyPedMission:syncPed",resourceRoot,function(ID,ped)
	if(ID and isElement(ped))then
		HungryThirstyPedMissionClient.ActivePeds[ID] = ped
	end
end)

addEvent("HungryThirstyPedMission:unsyncPed",true)
addEventHandler("HungryThirstyPedMission:unsyncPed",resourceRoot,function(ID)
	if(ID)then
		HungryThirstyPedMissionClient.ActivePeds[ID] = nil
	end
end)

addEventHandler("onClientElementDestroy",root,function()
	for ID,ped in pairs(HungryThirstyPedMissionClient.ActivePeds) do
		if(ped == source)then
			HungryThirstyPedMissionClient.ActivePeds[ID] = nil
			break
		end
	end
end)

addEventHandler("onClientRender",root,function()
	local px,py,pz = getElementPosition(localPlayer)
	local playerDimension = getElementDimension(localPlayer)
	local playerInterior = getElementInterior(localPlayer)

	for ID,ped in pairs(HungryThirstyPedMissionClient.ActivePeds) do
		if(isElement(ped))then
			if(getElementDimension(ped) == playerDimension and getElementInterior(ped) == playerInterior)then
				local x,y,z = getElementPosition(ped)
				local distance = getDistanceBetweenPoints3D(px,py,pz,x,y,z)

				if(distance <= HungryThirstyPedMissionClient.DrawDistance)then
					local sx,sy = getScreenFromWorldPosition(x,y,z + 1.2)

					if(sx and sy)then
						local alpha = math.max(0,255 - ((distance / HungryThirstyPedMissionClient.DrawDistance) * 155))

						local title = getText("CHungryThirstyPed1")
						local subtitle = getText("CHungryThirstyPed2")

						dxDrawText(
							title,
							sx + 1,sy - 20,sx + 1,sy - 20,
							tocolor(0,0,0,alpha),
							1,
							"default-bold",
							"center",
							"center"
						)

						dxDrawText(
							title,
							sx,sy - 20,sx,sy - 20,
							tocolor(255,180,80,alpha),
							1,
							"default-bold",
							"center",
							"center"
						)

						dxDrawText(
							subtitle,
							sx + 1,sy,sx + 1,sy,
							tocolor(0,0,0,alpha),
							0.9,
							"default-bold",
							"center",
							"center"
						)

						dxDrawText(
							subtitle,
							sx,sy,sx,sy,
							tocolor(255,255,255,alpha),
							0.9,
							"default-bold",
							"center",
							"center"
						)
					end
				end
			end
		else
			HungryThirstyPedMissionClient.ActivePeds[ID] = nil
		end
	end
end)