addEvent("Vehicleshop.buy",true)
addEventHandler("Vehicleshop.buy",root,function(model,level,price_money,price_brain)
	local price_race_token = 0
	local model, level, price_money, price_brain = tonumber(model),tonumber(level),tonumber(price_money),tonumber(price_brain)
	if(tonumber(apocalypseGetElementData(client,"level")) >= level)then
		if(tonumber(apocalypseGetElementData(client,"money")) >= price_money)then
			if(hasPlayerItem(client,1) >= price_brain)then
				if(model == 502 or model == 503 or model == 494)then price_race_token = 250 end
				if(hasPlayerItem(client,62) >= price_race_token)then
					if(checkPlayerVehicleFreeSlot(client) == true)then
						apocalypseSetElementData(client,"money",tonumber(apocalypseGetElementData(client,"money"))-price_money)
						takeItem(client,1,price_brain)
						addPlayerVehicle(client,model)
						triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SVehicles5"))
						setAchievement(client,56)
						outputLog(getPlayerName(client).." hat sich das Fahrzeug mit der Model ID "..model.." für $"..price.." und "..price_brain.." Hirnmasse gekauft","Vehicleshop",getCharacterID(client))
						
						if(apocalypseGetElementData(client,"VehicleDealerID"))then
							VehicleDealer.destroyPed(apocalypseGetElementData(client,"VehicleDealerID"))
							apocalypseSetElementData(client,"VehicleDealerID",nil)
						end
					else triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SVehicles4"))end
				else triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SVehicles10"))end
			else triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SVehicles3"):format(price_brain))end
		else triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SVehicles2"):format(price_money))end
	else triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SVehicles1"):format(level))end
end)