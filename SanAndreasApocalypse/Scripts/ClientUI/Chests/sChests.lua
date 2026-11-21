addEvent("giveTheRaffleItem", true)
addEventHandler("giveTheRaffleItem", getRootElement(),function (case, item)
	if(case and item)then
		if(case == "SAACoinCrate")then
			giveItem(client,14,item[4])
			triggerClientEvent(client, "showItemBar", client, {{14,item[4]}})
			outputLog(getPlayerName(client).." hat "..item[4].." SAA Coins erhalten", "Crates", getCharacterID(client))
		elseif(case == "VehicleCrate")then
			dbExec(handler,"INSERT INTO chest_vehicles (character_id_owner,model) VALUES ('"..getCharacterID(client).."','"..item[4].."')")
			outputLog(getPlayerName(client).." hat ein Fahrzeug erhalten (Model: "..item[4]..")", "Vehicle Crates", getCharacterID(client))
		end
	end
end)