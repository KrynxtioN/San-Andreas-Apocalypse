HalloweenShop = {}

function HalloweenShop.buy(item,costs,model)
	local costs = tonumber(costs)
	if(item == "totemBlips")then
		if(hasPlayerItem(client,5) >= 1)then
			if(hasRadioLocation(client,17) == false)then
				if(hasPlayerItem(client,12) >= costs)then
					takeItem(client,12,costs)
					giveRadioData(client,17)
					createInfobox(client,getText(client,"SHalloweenShop3"))
					outputLog(getPlayerName(client).." hat sich die Totem Koordinaten für "..costs.." Kürbisse gekauft","Halloween Event",getCharacterID(client))
				else
					createInfobox(client,getText(client,"SHalloweenShop2"))
				end
			else
				createInfobox(client,getText(client,"SHalloweenShop1"))
			end
		else
			createInfobox(client,getText(client,"SHalloweenShop4"))
		end
	elseif(item == "totem")then
		if(hasPlayerItem(client,12) >= costs)then
			giveItem(client,183,1)
			takeItem(client,12,costs)
			createInfobox(client,getText(client,"SHalloweenShop5"))
			outputLog(getPlayerName(client).." hat einen Totem für "..costs.." Kürbisse gekauft","Halloween Event",getCharacterID(client))
		else
			createInfobox(client,getText(client,"SHalloweenShop2"))
		end
	elseif(item == "pumpkinSeed")then
		if(hasPlayerItem(client,12) >= costs)then
			giveItem(client,184,1)
			takeItem(client,12,costs)
			createInfobox(client,getText(client,"SHalloweenShop6"))
			outputLog(getPlayerName(client).." hat einen Kürbissamen für "..costs.." Kürbisse gekauft","Halloween Event",getCharacterID(client))
		else
			createInfobox(client,getText(client,"SHalloweenShop2"))
		end
	elseif(item == "vehicleSlot")then
		if(hasPlayerItem(client,12) >= costs)then
			takeItem(client,12,costs)
			local vehicle_slots = getPlayerData("characters","ID",getCharacterID(client),"vehicle_slots")
			dbExec(handler,"UPDATE characters SET vehicle_slots = '"..vehicle_slots + 1 .."' WHERE ID = '"..getCharacterID(client).."'")
			createInfobox(client,getText(client,"SHalloweenShop7"))
			outputLog(getPlayerName(client).." hat einen Fahrzeugslot für "..costs.." Kürbisse gekauft","Halloween Event",getCharacterID(client))
		else
			createInfobox(client,getText(client,"SHalloweenShop2"))
		end
	elseif(item == "vehicle")then
		if(hasPlayerItem(client,12) >= costs)then
			if(checkPlayerVehicleFreeSlot(client) == true)then
				takeItem(client,12,costs)
				addPlayerVehicle(client,model)
				createInfobox(client,getText(client,"SHalloweenShop9"))
				outputLog(getPlayerName(client).." hat  ein Fahrzeug (Model: "..model..") für "..costs.." Kürbisse gekauft","Halloween Event",getCharacterID(client))
			else
				createInfobox(client,getText(client,"SHalloweenShop8"))
			end
		else
			createInfobox(client,getText(client,"SHalloweenShop2"))
		end
	end
end
addEvent("HalloweenShop.buy",true)
addEventHandler("HalloweenShop.buy",root,HalloweenShop.buy)