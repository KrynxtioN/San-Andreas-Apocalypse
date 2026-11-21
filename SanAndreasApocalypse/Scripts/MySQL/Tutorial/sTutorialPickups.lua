TutorialPickups = {}

function TutorialPickups.create(player)
	local CharacterID = getCharacterID(player)
	local looted_vehicles = getPlayerData("character_stats","character_id",CharacterID,"looted_vehicles") or 0
	local looted_dumpsters = getPlayerData("character_stats","character_id",CharacterID,"looted_dumpsters") or 0
	if(tonumber(looted_vehicles) < 1)then
		local x,y,z = 704.77856445312,-486.79425048828,17.98694229126
		triggerClientEvent(player,"TutorialPickups.createPickup",player,"LootVehicle",x,y,z,getText(player,"STutorial1"))
	end
	if(tonumber(looted_dumpsters) < 1)then
		local x,y,z = 659.228515625,-474.14987182617,17.878156661987
		triggerClientEvent(player,"TutorialPickups.createPickup",player,"LootDumpster",x,y,z+0.05,getText(player,"STutorial2"))
	end
	if(hasAchievement(player,72) == false)then
		local x,y,z = 668.51916503906,-438.17279052734,18.125726699829
		triggerClientEvent(player,"TutorialPickups.createPickup",player,"WaterDispenser",x,y,z+0.05,getText(player,"STutorial3"))
	end
	if(hasAchievement(player,73) == false)then
		local x,y,z = 678.30389404297,-445.64099121094,18.535900115967
		triggerClientEvent(player,"TutorialPickups.createPickup",player,"SnackVendingMachine",x,y,z+0.05,getText(player,"STutorial4"))
	end
	if(hasRadioLocation(player,20) == false)then
		local x,y,z = 693.68774414062,-438.9176940918,18.467823028564
		triggerClientEvent(player,"TutorialPickups.createPickup",player,"DrBrain",x,y,z+0.05,getText(player,"STutorial6"))
	end
	if(hasRadioLocation(player,21) == false)then
		local x,y,z = 695.01654052734,-500.00527954102,16.3359375
		triggerClientEvent(player,"TutorialPickups.createPickup",player,"RickyJey",x,y,z+0.05,getText(player,"STutorial7"))
	end
	if(hasPlayerItem(player,5) < 1)then
		local x,y,z = 657.76000976562,-440.07821655273,18.690988540649
		triggerClientEvent(player,"TutorialPickups.createPickup",player,"Compass",x,y,z+0.05,getText(player,"STutorial8"))
	end
end