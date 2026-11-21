NewbieBMX = {playerBMX = {}, playerTimer = {}, Pickup = {},
	["Spawnpoints"] = {
		[1] = {
			pickup = {669.35748291016,-473.47674560547,16.3359375},
			vehicleSpawn = {668.70300292969,-470.74868774414,16.3359375,90},
		},
	},
}

for _,v in pairs(getElementsByType("player"))do
	apocalypseSetElementData(v,"NewbieBMX_PickupID",nil)
end

for i,v in pairs(NewbieBMX["Spawnpoints"])do
	NewbieBMX.Pickup[i] = createPickup(v.pickup[1],v.pickup[2],v.pickup[3],3,1239,50)
	apocalypseSetElementData(NewbieBMX.Pickup[i],"NewbieBMXID",i)
	
	addEventHandler("onPickupHit",NewbieBMX.Pickup[i],function(player)
		if(not(isPedInVehicle(player)))then
			if(getElementDimension(player) == getElementDimension(source))then
				if(getElementInterior(player) == getElementInterior(source))then
					apocalypseSetElementData(player,"BMXID",apocalypseGetElementData(source,"NewbieBMXID"))
					if(apocalypseGetElementData(player,"NewbieBMX_PickupID") ~= true)then
						bindKey(player,"e","down",NewbieBMX.rent)
					end
				end
			end
		end
	end)
end

function NewbieBMX.rent(player)
	local ID = apocalypseGetElementData(player,"BMXID")
	local Pickup = NewbieBMX.Pickup[ID]
	local x,y,z = getElementPosition(Pickup)
	if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(player)) <= 5)then
		NewbieBMX.createVehicle(player)
	end
end

function NewbieBMX.createVehicle(player)
	if(isElement(NewbieBMX.playerBMX[player]))then destroyElement(NewbieBMX.playerBMX[player])end
	if(isTimer(NewbieBMX.playerTimer[player]))then killTimer(NewbieBMX.playerTimer[player])end
	local ID = apocalypseGetElementData(player,"BMXID")
	if(ID)then
		local spawn = NewbieBMX["Spawnpoints"][ID]
		local x,y,z,rz = spawn.vehicleSpawn[1], spawn.vehicleSpawn[2], spawn.vehicleSpawn[3], spawn.vehicleSpawn[4]
		NewbieBMX.playerBMX[player] = createVehicle(481,x,y,z,0,0,rz,"BMX")
		apocalypseSetElementData(NewbieBMX.playerBMX[player],"BMXOwner",getCharacterID(player))
		warpPedIntoVehicle(player,NewbieBMX.playerBMX[player])
		setAchievement(player,412)
		
		addEventHandler("onVehicleStartEnter",NewbieBMX.playerBMX[player],function(player)
			local BMXOwner = apocalypseGetElementData(source,"BMXOwner")
			if(getCharacterID(player) == BMXOwner)then
				if(isTimer(NewbieBMX.playerTimer[player]))then
					killTimer(NewbieBMX.playerTimer[player])
				end
			else
				cancelEvent()
			end
		end)
		
		addEventHandler("onVehicleExit",NewbieBMX.playerBMX[player],function(player)
			local BMXOwner = apocalypseGetElementData(source,"BMXOwner")
			if(getCharacterID(player) == BMXOwner)then
				NewbieBMX.playerTimer[player] = setTimer(function(player)
					if(isElement(NewbieBMX.playerBMX[player]))then
						destroyElement(NewbieBMX.playerBMX[player])
					end
					if(isTimer(NewbieBMX.playerTimer[player]))then
						killTimer(NewbieBMX.playerTimer[player])
					end
				end,1800000,1,player)
			end
		end)
	end
end
addEvent("NewbieBMX.createVehicle",true)
addEventHandler("NewbieBMX.createVehicle",root,NewbieBMX.createVehicle)

addEventHandler("onPlayerWasted",root,function()
	if(isElement(NewbieBMX.playerBMX[source]))then
		destroyElement(NewbieBMX.playerBMX[source])
	end
	if(isTimer(NewbieBMX.playerTimer[source]))then
		killTimer(NewbieBMX.playerTimer[source])
	end
end)

addEventHandler("onPlayerQuit",root,function()
	if(isElement(NewbieBMX.playerBMX[source]))then
		destroyElement(NewbieBMX.playerBMX[source])
	end
	if(isTimer(NewbieBMX.playerTimer[source]))then
		killTimer(NewbieBMX.playerTimer[source])
	end
end)