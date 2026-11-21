local Garages = {8,11,12,19,27,40,41,47}
for _,v in pairs(Garages)do setGarageOpen(v,true) end

PayNSpray = {
	["Marker"] = {
		[1] = {2063.349609375, -1831.2890625, 11.252596855164, 8},
		[2] = {1025.044921875, -1020.9736328125, 32.098804473877, 11},
		[3] = {487.388671875, -1741.552734375, 8.837544441223, 12},
		[4] = {-1904.517578125, 285.4404296875, 41.046875, 19},
		[5] = {-1420.5849609375, 2584.3154296875, 55.84326171875, 40},
		[6] = {-100.0478515625, 1117.5234375, 19.74169921875, 41},
		[7] = {-2425.642578125, 1021.76953125, 50.397659301758, 27},
	},
	["Matrix"] = {
		[8] = {2071.2033691406,-1830.3795166016,15.900392532349,1974.3961181641,-1842.0838623047,-6.266294002533},
		[11] = {1024.9809570312,-1029.0266113281,34.345943450928,1025.2425537109,-935.12091064453,-0.029167814180255},
		[12] = {488.1647644043,-1735.1821289062,14.186583518982,475.36749267578,-1829.4091796875,-16.756866455078},
		[19] = {-1904.3665771484,278.17932128906,45.227458953857,-1905.2716064453,369.10284423828,3.6090376377106},
		[40] = {-1420.8383789062,2591.1076660156,59.993991851807,-1417.318359375,2503.6938476562,11.554116249084},
		[41] = {-100.36842346191,1111.8001708984,22.98045539856,-98.786849975586,1196.689453125,-29.852319717407},
		[27] = {-2425.625,1027.4545898438,53.391185760498,-2426.8159179688,941.24041748047,2.7384226322174},
	},
}

for _,v in ipairs(PayNSpray["Marker"])do
	local marker = createMarker(v[1],v[2],v[3],"cylinder",4,0,0,0,25)
	apocalypseSetElementData(marker,"garageID",v[4])
	
	addEventHandler("onMarkerHit",marker,function(player)
		if(getElementType(player) == "vehicle")then
			local player = getVehicleOccupant(player,0)
			if(player)then
				if(getElementDimension(player) == getElementDimension(source))then
					local garageID = apocalypseGetElementData(source,"garageID")
					local veh = getPedOccupiedVehicle(player)
					local tbl = PayNSpray["Matrix"][garageID]
					local pos1,pos2,pos3,pos4,pos5,pos6 = tbl[1],tbl[2],tbl[3],tbl[4],tbl[5],tbl[6]
					
					setElementFrozen(veh,true)
					setGarageOpen(garageID,false)
					apocalypseSetElementData(player,"inPaynSpray",true)
					apocalypseSetElementData(player,"inPaynSprayGarageID",garageID)
					triggerClientEvent(player,"PayNSpray.createWindow",player)
					triggerClientEvent(player,"PayNSpray.setCameraMatrix",player,pos1,pos2,pos3,pos4,pos5,pos6)
				end
			end
		end
	end)
end

addEvent("PayNSpray.changeColor",true)
addEventHandler("PayNSpray.changeColor",root,function(r,g,b)
	if(r and g and b)then
		local veh = getPedOccupiedVehicle(client)
		if(veh)then
			if(hasPlayerItem(client,56) >= 25)then
				local ID = apocalypseGetElementData(veh,"VehicleID_Database")
				local color = r.."|"..g.."|"..b
				createInfobox(client,getText(client,"SPayNSpray1"))
				setVehicleColor(veh,r,g,b)
				takeItem(client,56,25)
				setAchievement(client,267)
				if(ID)then
					dbExec(handler,"UPDATE vehicles SET color = '"..color.."' WHERE ID = '"..ID.."'")
				end
			else
				createInfobox(client,getText(client,"SPayNSpray2"))
			end
		end
	end
end)

addEvent("PayNSpray.Finished",true)
addEventHandler("PayNSpray.Finished",root,function()
	if(apocalypseGetElementData(client,"inPaynSpray") == true)then
		local veh = getPedOccupiedVehicle(client)
		if(veh)then
			setElementFrozen(veh,false)
		end
		local ID = apocalypseGetElementData(client,"inPaynSprayGarageID")
		setGarageOpen(ID,true)
		apocalypseSetElementData(client,"inPaynSpray",false)
		apocalypseSetElementData(client,"inPaynSprayGarageID",nil)
		setCameraTarget(client)
	end
end)

addEventHandler("onPlayerWasted",root,function()
	if(getElementData(source,"inPaynSpray") == true)then
		local ID = apocalypseGetElementData(source,"inPaynSprayGarageID")
		setGarageOpen(ID,true)
		apocalypseSetElementData(source,"inPaynSpray",false)
		apocalypseSetElementData(source,"inPaynSprayGarageID",nil)
	end
end)

addEventHandler("onPlayerQuit",root,function()
	if(apocalypseSetElementData(source,"inPaynSpray") == true)then
		local ID = apocalypseGetElementData(source,"inPaynSprayGarageID")
		setGarageOpen(ID,true)
		apocalypseSetElementData(source,"inPaynSpray",false)
		apocalypseSetElementData(source,"inPaynSprayGarageID",nil)
	end
end)