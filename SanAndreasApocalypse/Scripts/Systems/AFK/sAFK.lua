AFK = {}

setTimer(function()
	for _,v in pairs(getElementsByType("player"))do
		if(isCharacterLoggedIn(v))then
			if(getPlayerIdleTime(v) > 300000)then
				if(apocalypseGetElementData(v,"AFK") ~= true)then
					apocalypseSetElementData(v,"AFK",true)
					AFK[v] = math.random(1111,9999)
					apocalypseSetElementData(v,"AFKCode",AFK[v])
					if(apocalypseGetElementData(v, "Bar:UseBench") ~= true)then
						if(isPedInVehicle(v) and getPedOccupiedVehicleSeat(v) == 0)then
							local veh = getPedOccupiedVehicle(v)
							setElementFrozen(veh,true)
							setElementFrozen(v,true)
							
							addEventHandler("onVehicleStartExit",veh,function(player)
								if(apocalypseGetElementData(player,"AFK") == true)then
									NPC.MeMessage(player,getText(player,"SAFK3"))
									cancelEvent()
								end
							end)
						else
							setElementFrozen(v,true)
						end
					end
					triggerClientEvent(v,"AFK.render",v)
				end
			end
		end
	end
end,60000,0)

addCommandHandler("afk",function(player,cmd,code)
	if(isCharacterLoggedIn(player))then
		if(apocalypseGetElementData(player,"AFK") == true)then
			if(AFK[player])then
				if(code)then
					if(tonumber(code) == AFK[player])then
						triggerClientEvent(player,"AFK.render",player)
						apocalypseSetElementData(player,"AFK",false)
						setElementFrozen(player,false)
						if(isPedInVehicle(player) and getPedOccupiedVehicleSeat(player) == 0)then
							setElementFrozen(getPedOccupiedVehicle(player),false)
						end
						AFK[player] = nil
					else createInfobox(player,getText(player,"SAFK1"):format(AFK[player]))end
				else createInfobox(player,getText(player,"SAFK1"):format(AFK[player]))end
			end
		end
	end
end)