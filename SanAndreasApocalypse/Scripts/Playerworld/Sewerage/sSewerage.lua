Sewerage = {
	["TeleportMarker"] = { -- marker_x, marker_y, marker_z, marker_size, spawn_x, spawn_y, spawn_z, spawn_rot
		[1] = {2578.5122070312,2077.8820800781,10.012999534607,3,2575.4658203125,2077.9616699219,-0.62547624111176,90},
		[2] = {2577.9477539062,2077.8376464844,-1.5821000337601,1.5,2575.8552246094,2074.8640136719,10.820300102234,270},
		[3] = {2402.6284179688,2156.7746582031,9.9953002929688,3,2404.9736328125,2156.0883789062,-4.4534254074097,180},
		[4] = {2402.546875,2155.4274902344,-5.4787001609802,1.5,2403.1015625,2161.705078125,10.820300102234,180},
	},
}

for _,v in pairs(getElementsByType("player"))do
	apocalypseSetElementData(v,"sewerageCooldown",false)
end

for i,v in ipairs(Sewerage["TeleportMarker"])do
	local marker = createMarker(v[1],v[2],v[3],"cylinder",v[4],255,255,255,75)
	apocalypseSetElementData(marker,"sewerageID",i)
	
	addEventHandler("onMarkerHit",marker,function(player)
		if(getElementType(player) == "player")then
			if(not(isPedInVehicle(player)))then
				if(getElementDimension(player) == getElementDimension(source))then
					if(getElementInterior(player) == getElementInterior(source))then
						if(apocalypseGetElementData(player,"sewerageCooldown") ~= true)then
							apocalypseSetElementData(player,"sewerageCooldown",true)
							local ID = apocalypseGetElementData(source,"sewerageID")
							local tbl = Sewerage["TeleportMarker"][ID]
							local x,y,z,rot = tbl[5],tbl[6],tbl[7],tbl[8]
							setElementPosition(player,x,y,z)
							setElementRotation(player,0,0,rot)
							setAchievement(player,421)
							
							setTimer(function(player)
								apocalypseSetElementData(player,"sewerageCooldown",false)
							end,2500,1,player)
						else
							createInfobox(player,getText(player,"SSewerage1"))
						end
					end
				end
			end
		end
	end)
end