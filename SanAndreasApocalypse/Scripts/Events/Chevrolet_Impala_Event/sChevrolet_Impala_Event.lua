Chevrolet_Impala_Event = {
	["Shop_Data"] = {
		[1] = 2500,
		[2] = 7500,
		[3] = 1000,
		[4] = 1000,
	},
}

Chevrolet_Impala_Event.Daily_Player_Bonus = {}
Chevrolet_Impala_Event.Daily_Player_Bonus_Pickup = createPickup(1468.7407226562,-1689.8436279297,14.046875,3,1239,50)

addEventHandler("onPickupHit",Chevrolet_Impala_Event.Daily_Player_Bonus_Pickup,function(player)
	if(getElementType(player) == "player")then
		if(isCharacterLoggedIn(player))then
			if(getElementDimension(player) == getElementDimension(source))then
				if(getElementInterior(player) == getElementInterior(source))then
					if(not(isPedDead(player)))then
						if(not(isPedInVehicle(player)))then
							if(not(Chevrolet_Impala_Event.Daily_Player_Bonus[player]))then
								giveItem(player,203,100)
								triggerClientEvent(player, "showItemBar", player, {{203,100}})
								createInfobox(player,getText(player,"SImpalaEvent8"))
							else
								createInfobox(player,getText(player,"SImpalaEvent7"))
							end
						end
					end
				end
			end
		end
	end
end)

Chevrolet_Impala_Event.Information = createPickup(0,0,0,3,1239,50)

addEventHandler("onPickupHit",Chevrolet_Impala_Event.Information,function(player)
	if(getElementType(player) == "player")then
		if(isCharacterLoggedIn(player))then
			if(getElementDimension(player) == getElementDimension(source))then
				if(getElementInterior(player) == getElementInterior(source))then
					if(not(isPedDead(player)))then
						if(not(isPedInVehicle(player)))then
							triggerClientEvent(player,"Chevrolet_Impala_Event.openInformation",player)
						end
					end
				end
			end
		end
	end
end)

addEvent("Chevrolet_Impala_Event.buyVehicle",true)
addEventHandler("Chevrolet_Impala_Event.buyVehicle",root,function()
	if(hasPlayerItem(client,203) >= 2500)then
		takeItem(client,203,2500)
		NPC.NormalMessage(client,getText(client,"SImpalaEvent12"))
		addPlayerVehicle(client,562)
	else
		NPC.NormalMessage(client,getText(client,"SImpalaEvent9"))
	end
end)

addEvent("Chevrolet_Impala_Event.buyVehicleSlot",true)
addEventHandler("Chevrolet_Impala_Event.buyVehicleSlot",root,function()
	if(hasPlayerItem(client,203) >= 500)then
		takeItem(client,203,500)
		NPC.NormalMessage(client,getText(client,"SImpalaEvent13"))
		local vehicle_slots = getPlayerData("characters","ID",getCharacterID(client),"vehicle_slots")
		dbExec(handler,"UPDATE characters SET vehicle_slots = '"..vehicle_slots + 1 .."' WHERE ID = '"..getCharacterID(client).."'")
	else
		NPC.NormalMessage(client,getText(client,"SImpalaEvent10"))
	end
end)

addEvent("Chevrolet_Impala_Event.buyStatus",true)
addEventHandler("Chevrolet_Impala_Event.buyStatus",root,function()
	if(hasPlayerItem(client,203) >= 1000)then
		if(hasPlayerStatus(client,5) == false)then
			takeItem(client,203,1000)
			setStatus(client,5)
			triggerClientEvent(client,"closeWindow",client)
			NPC.NormalMessage(client,getText(client,"SImpalaEvent13"))
		else
			NPC.NormalMessage(client,getText(client,"SImpalaEvent14"))
		end
	else
		NPC.NormalMessage(client,getText(client,"SImpalaEvent11"))
	end
end)