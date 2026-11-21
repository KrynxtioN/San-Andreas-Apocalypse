WeeklyRewards = {Marker = {}, Pickup = {},
	["MarkerPos"] = {
		{511.68212890625,-73.430999755859,998.7578125},
		{511.68212890625,-74.930999755859,998.7578125},
		{511.68212890625,-76.430999755859,998.7578125},
	},
}

addEventHandler("onClientRender", root, function()
    if not (isCharacterLoggedIn() and isWindowOpen()) then return end
	
	if(getElementInterior(localPlayer) == 11)then
		for i,v in ipairs(WeeklyRewards["MarkerPos"])do
			local x1,y1,z1 = v[1],v[2],v[3]
			local screenX1,screenY1 = getScreenFromWorldPosition(x1,y1,z1)
			
			if screenX1 and screenY1 and getDistanceBetweenPoints3D(x1, y1, z1, getElementPosition(localPlayer)) <= 5 then
				dxDrawText(getText("CWeeklyRewards"..i),
					screenX1 - 100, screenY1 - 20, screenX1 + 100, screenY1 + 20,
					tocolor(255,255,255), 1.2, "default-bold", "center", "center")
			end
		end
	end
end)

for i,v in pairs(WeeklyRewards["MarkerPos"])do
	WeeklyRewards.Marker[i] = createMarker(v[1],v[2],v[3]-1,"cylinder",1,255,255,255,125)
	WeeklyRewards.Pickup[i] = createPickup(v[1],v[2],v[3],3,1239,50)
	apocalypseSetElementData(WeeklyRewards.Pickup[i],"WeeklyRewardsID",i)
	setElementInterior(WeeklyRewards.Marker[i],11)
	
	addEventHandler("onClientPickupHit",WeeklyRewards.Pickup[i],function(player)
		if(player == localPlayer)then
			if(not(isPedInVehicle(localPlayer)))then
				if(getElementDimension(localPlayer) == getElementDimension(source))then
					triggerServerEvent("WeeklyRewards.collect",localPlayer,apocalypseGetElementData(source,"WeeklyRewardsID"))
				end
			end
		end
	end)
end

addEvent("WeeklyRewards.Load",true)
addEventHandler("WeeklyRewards.Load",root,function(Reward1,Reward2,Reward3)
	local Reward1, Reward2, Reward3 = tonumber(Reward1), tonumber(Reward2), tonumber(Reward3)
	if(Reward1 == 1)then setMarkerColor(WeeklyRewards.Marker[1],250,0,0,125) end
	if(Reward2 == 1)then setMarkerColor(WeeklyRewards.Marker[2],250,0,0,125) end
	if(Reward3 == 1)then setMarkerColor(WeeklyRewards.Marker[3],250,0,0,125) end
end)