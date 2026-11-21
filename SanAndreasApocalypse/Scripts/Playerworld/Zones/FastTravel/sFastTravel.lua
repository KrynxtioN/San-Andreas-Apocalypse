FastTravel = {VehicleElements = {},
	["Vehicles"] = {
		{497,684.6396484375,-465.73046875,22.86549949646,0,0,90},
		{497,212.67939758301,-230.64169311523,8.3436002731323,0,0,114},
		{497,-2226.5549316406,2329.5646972656,7.811900138855,0,0,90},
		{497,-1966.1455078125,158.640625,37.227298736572,0,0,325},
		{497,-2025.4560546875,-7663.0043945312,14.519300460815,0,0,234},
		{497,-2092.66015625,-2430.0915527344,35.186901092529,0,0,0},
		{497,2329.3891601562,30.374799728394,31.748399734497,0,0,338},
		{497,366.34039306641,-2057.83203125,15.666799545288,0,0,0},
		{497,1631.583984375,766.21887207031,19.087200164795,0,0,330},
		--{497,-2377.8732910156,-3068.8361816406,4.8329000473022,0,0,0},
	},
}

for i,v in pairs(FastTravel["Vehicles"])do
	FastTravel.VehicleElements[i] = createVehicle(v[1],v[2],v[3],v[4],v[5],v[6],v[7])
	setElementFrozen(FastTravel.VehicleElements[i],true)
	setVehicleDamageProof(FastTravel.VehicleElements[i],true)
	apocalypseSetElementData(FastTravel.VehicleElements[i],"FastTravelID",i)
	
	addEventHandler("onVehicleStartEnter",FastTravel.VehicleElements[i],function(player)
		if(tonumber(apocalypseGetElementData(player,"level")) < 25)then
			createInfobox(player,getText(player,"SFastTravel2"))
			--cancelEvent()
		end
	end)
	
	addEventHandler("onVehicleEnter",FastTravel.VehicleElements[i],function(player)
		toggleAllControls(player,false)
		triggerClientEvent(player,"FastTravel.createWindow",player,apocalypseGetElementData(source,"FastTravelID"))
	end)
end

addEvent("FastTravel.Server",true)
addEventHandler("FastTravel.Server",root,function(ID,Level,Price)
	local ID = tonumber(ID)
	local Price = tonumber(Price)
	if(apocalypseGetElementData(client,"FastTravelID") ~= ID)then
		if(tonumber(apocalypseGetElementData(client,"level")) >= tonumber(Level))then
			if(hasPlayerItem(client,1) >= Price)then
				local vehicle = FastTravel.VehicleElements[ID]
				local maxPassengers = getVehicleMaxPassengers(vehicle)
				local availableSeat = false
				
				for seat = 0, maxPassengers do
					if not getVehicleOccupant(vehicle, seat) then
						availableSeat = seat
						break
					end
				end
				
				if(availableSeat ~= false)then
					removePedFromVehicle(client,getPedOccupiedVehicle(client))
					warpPedIntoVehicle(client,vehicle,availableSeat)
					triggerClientEvent(client,"FastTravel.Close",client)
					toggleAllControls(client,true)
					takeItem(client,1,Price)
					setAchievement(client,420)
					setTimer(function(player)
						setControlState(player,"enter_exit",true)
					end,500,1,client)
				else
					createInfobox(client,getText(client,"SFastTravel1"))
				end
			else
				createInfobox(client,getText(client,"SFastTravel3"))
			end
		end
	end
end)

addEvent("FastTravel.Close",true)
addEventHandler("FastTravel.Close",root,function()
	toggleAllControls(client,true)
	setTimer(function(client)
		setControlState(client,"enter_exit",true)
	end,500,1,client)
end)

addEventHandler("onPlayerWasted",root,function()
	triggerClientEvent(source,"FastTravel.Close",source)
	toggleAllControls(source,true)
end)