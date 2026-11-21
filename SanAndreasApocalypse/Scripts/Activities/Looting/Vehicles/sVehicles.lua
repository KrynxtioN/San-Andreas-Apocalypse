local function getModel()
	local rnd = math.random(1,10)
	local tbl
	if(rnd <= 5)then tbl = "VeryCommon" end
	if(rnd >= 6 and rnd <= 8)then tbl = "Common" end
	if(rnd >= 9)then tbl = "Rare" end
	return {possibleLootVehicles[tbl][math.random(1,#possibleLootVehicles[tbl])],tbl}
end

local Achievements = {
	{1,173},
	{5,174},
	{10,175},
	{25,176},
	{50,177},
	{75,178},
	{125,179},
	{200,180},
}

local V_TIMER = {}

function VehicleLoot.createVehicle()
	for i, v in pairs(VehicleLoot["SpawnPosition"]) do
		if(not(isElement(VehicleLoot.vehicles[i])))then
			local model = getModel()
			VehicleLoot.vehicles[i] = createVehicle(model[1], v[1], v[2], v[3] + 0.5, 0, 0, math.random(0, 360))
			setElementHealth(VehicleLoot.vehicles[i], math.random(250, 650))
			apocalypseSetElementData(VehicleLoot.vehicles[i], "LootVehicle", true)
			apocalypseSetElementData(VehicleLoot.vehicles[i], "VehicleLootID", i)
			apocalypseSetElementData(VehicleLoot.vehicles[i], "VehicleLootType",model[2])
			local marker = createMarker(v[1],v[2],v[3],"cylinder",5,255,0,0,0)
			apocalypseSetElementData(marker,"freezeVehicleID",i)
			
			addEventHandler("onMarkerHit",marker,function(player)
				if(getElementType(player) == "player")then
					local id = apocalypseGetElementData(source,"freezeVehicleID")
					setElementFrozen(VehicleLoot.vehicles[id],true)
					destroyElement(source)
				end
			end)

			setVehiclePanelState(VehicleLoot.vehicles[i], 4, math.random(0, 2))
			setVehiclePanelState(VehicleLoot.vehicles[i], 5, math.random(0, 3))
			setVehiclePanelState(VehicleLoot.vehicles[i], 6, math.random(0, 3))
			setVehicleDamageProof(VehicleLoot.vehicles[i], true)
			
			addEventHandler("onVehicleEnter", VehicleLoot.vehicles[i], function(player)
				setElementFrozen(source,true)
				local currentTime = getRealTime().timestamp
				if(not(VehicleLoot.timers[player]))then VehicleLoot.timers[player] = {} end
				local timer = VehicleLoot.timers[player][source] or 0
				local ID = apocalypseGetElementData(source,"VehicleLootID")
				apocalypseSetElementData(player,"VehicleLootType",apocalypseGetElementData(source,"VehicleLootType"))
				triggerClientEvent(player,"createActivitiesInformationText",player,getText(player,"SRandomLootCrate2"))
				
				if(not(V_TIMER[player]))then V_TIMER[player] = {} end
				
				if(timer == 0 or currentTime - timer >= 900)then
					V_TIMER[player][ID] = setTimer(function(player,id)
						if(isElement(player))then
							triggerClientEvent(player,"VehicleLoot.updateMarkerColor",player,id,255,255,255)
						end
					end,900000,1,player,ID)
				
					triggerClientEvent(player,"VehicleLoot.updateMarkerColor",player,ID,255,0,0)
					triggerClientEvent(player,"createProgressBar",player,15)
					triggerClientEvent(player, "VehicleLoot.Info", player, getText(player, "SVehicleLoot3"))
					triggerClientEvent(player, "VehicleLoot.startGame", player)
					bindKey(player,"e","down",VehicleLoot.stopGameKey)
					VehicleLoot.timers[player][source] = currentTime
					looted_vehicles = getPlayerData("character_stats","character_id",getCharacterID(player),"looted_vehicles")
					Characters.addStats(player,"looted_vehicles",looted_vehicles + 1)
					
					for _,v in pairs(Achievements)do
						if(looted_vehicles + 1 >= v[1])then
							setAchievement(player,v[2])
						end
					end
				else
					NPC.MeMessage(player, getText(player, "SVehicleLoot1"))
				end
			end)
			
			addEventHandler("onVehicleExit", VehicleLoot.vehicles[i], function(player)
				triggerClientEvent(player, "VehicleLoot.Info", player)
				triggerClientEvent(player, "VehicleLoot.stopGame", player)
				triggerClientEvent(player, "ProgressBar.close", player)
				unbindKey(player,"e","down",VehicleLoot.stopGameKey)
			end)
		end
	end
end
VehicleLoot.createVehicle()

function VehicleLoot.createPlayerMarker(player)
	local Coordinates = VehicleLoot["SpawnPosition"]
	triggerClientEvent(player,"VehicleLoot.createPlayerMarker",player,Coordinates)
end

addEvent("VehicleLoot.giveItem", true)
addEventHandler("VehicleLoot.giveItem", root, function(score)
	local amount = 0
	local score = tonumber(score)
	if(score == 0)then
		NPC.MeMessage(client,getText(client,"SVehicleLoot4"))
	else
		if(score >= 1)then
			if(score >= 1 and score <= 10)then amount = math.random(1, 2) end
			if(score >= 11 and score <= 15)then amount = math.random(3, 4) end
			if(score >= 16)then amount = math.random(5, 6) end
			
			local vehicleLootType = apocalypseGetElementData(client,"VehicleLootType")
			if(vehicleLootType == "Common")then amount = amount + 1 end
			if(vehicleLootType == "Rare")then amount = amount + 2 end
			
			giveLootItems(client, amount)
		else
			NPC.MeMessage(client,getText(client,"SVehicleLoot4"))
		end
		setAchievement(client, 41)
		local Level_Bonus_EXP = tonumber(apocalypseGetElementData(client,"level"))
		if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
		local EXP = 25 + (Level_Bonus_EXP * 1)
		if(SERVERBONUS.LOOTING == true)then EXP = EXP * 2 end
		giveEXP(client,EXP)
		givePlayerSkillpoint(client,2)
		SkillpointStreak.Vehicles(client)
	end
	triggerClientEvent(client,"TutorialPickups.deletePickup",client,"LootVehicle")
	if(DailyTasks.playerTasks[client][6])then
		DailyTasks.updateProgress(client,6,DailyTasks.playerTasks[client][6].progress + 1)
	end
	if(WeeklyTasks.playerTasks[client][6])then
		WeeklyTasks.updateProgress(client,6,WeeklyTasks.playerTasks[client][6].progress + 1)
	end
	
	local oldRecord = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"vehicle_loot_record"))
	if(score > oldRecord)then
		dbExec(handler,"UPDATE character_stats SET vehicle_loot_record = '"..score.."' WHERE character_id = '"..getCharacterID(client).."'")
		NPC.MeMessage(client,getText(client,"SVehicles6"):format(score))
	end
end)

function VehicleLoot.stopGameKey(player)
	triggerClientEvent(player, "VehicleLoot.Info", player)
	triggerClientEvent(player, "VehicleLoot.stopGame", player)
	triggerClientEvent(player, "ProgressBar.close", player)
	unbindKey(player,"e","down",VehicleLoot.stopGameKey)
	V_TIMER[player] = nil
end

addEventHandler("onPlayerWasted",root,function()
	VehicleLoot.stopGameKey(source)
end)

addEventHandler("onPlayerQuit",root,function()
	VehicleLoot.stopGameKey(source)
	VehicleLoot.timers[source] = nil
	if(V_TIMER[source])then
		for _,v in pairs(V_TIMER[source])do
			if(isTimer(v))then
				killTimer(v)
			end
		end
	end
end)