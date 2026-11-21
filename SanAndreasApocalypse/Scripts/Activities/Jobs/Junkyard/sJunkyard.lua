Junkyard = {Vehicle = {}, vehRespawnTimer = {},
	["Marker"] = {
		{2177.2607421875,-1981.6827392578,12.0015001297},
	},
	["Vehicles"] = {
		{2199.2739257812,-1987.5710449219,13.53689956665,0,0,90},
		{2199.2390136719,-1991.7711181641,13.53689956665,0,0,90},
		{2199.2026367188,-1996.0963134766,13.53689956665,0,0,90},
		{2199.1652832031,-2000.5715332031,13.53689956665,0,0,90},
	},
}

local Achievements = {
	{1,256},
	{5,257},
	{10,258},
	{25,259},
	{50,260},
	{75,261},
	{125,262},
	{175,263},
	{250,264},
}

for _,v in pairs(Junkyard["Marker"])do
	local marker = createMarker(v[1],v[2],v[3],"cylinder",7.5,200,0,0,125)
	
	addEventHandler("onMarkerHit",marker,function(hitElement)
		if(getElementType(hitElement) == "vehicle")then
			local player = getVehicleOccupant(hitElement,0)
			local veh = getPedOccupiedVehicle(player)
			local vehicleTowed = getVehicleTowedByVehicle(veh)
			
			if(player)then
				if(vehicleTowed ~= false)then
					if(apocalypseGetElementData(vehicleTowed,"LootVehicle") == true)then
						local junkyard_vehicles = tonumber(getPlayerData("character_stats","character_id",getCharacterID(player),"junkyard_vehicles"))
						dbExec(handler,"UPDATE character_stats SET junkyard_vehicles = '"..junkyard_vehicles + 1 .."' WHERE character_id = '"..getCharacterID(player).."'")
						local amount = math.random(35,50)
						local xp = 250
						local skillpoint = 5
						if(SERVERBONUS.JOB_ACTIVITIES == true)then
							xp = xp * 2
							skillpoint = skillpoint * 2
							amount = amount * 2
						end
						giveItem(player,21,amount)
						destroyElement(vehicleTowed)
						giveEXP(player,xp)
						givePlayerSkillpoint(player,skillpoint)
						triggerClientEvent(client, "showItemBar", client, {{21,amount}})
						outputLog(getPlayerName(player).." hat ein Fahrzeug abgeschleppt und "..xp.." EXÜ, "..skillpoint.." Skillpunkte und "..amount.." Fahrzeugteile erhalten", "Junkyard", getCharacterID(player))
						
						for _,v in pairs(Achievements)do
							if(junkyard_vehicles + 1 >= v[1])then
								setAchievement(player,v[2])
							end
						end
						
						if(DailyTasks.playerTasks[player][20])then
							DailyTasks.updateProgress(player,20,DailyTasks.playerTasks[player][20].progress + 1)
						end
						
						if(WeeklyTasks.playerTasks[player][20])then
							WeeklyTasks.updateProgress(player,20,WeeklyTasks.playerTasks[player][20].progress + 1)
						end
					end
				end
			end
		end
	end)
end

function Junkyard.createVehicle()
	for i,v in ipairs(Junkyard["Vehicles"])do
		Junkyard.Vehicle[i] = createVehicle(525,v[1],v[2],v[3],v[4],v[5],v[6])
		apocalypseSetElementData(Junkyard.Vehicle[i],"JunkyardVehID")
		
		addEventHandler("onVehicleEnter",Junkyard.Vehicle[i],function(player)
			if(getPedOccupiedVehicleSeat(player) == 0)then
				triggerClientEvent(player,"createActivitiesInformationText",player,getText(player,"SJunkyard2"))
				setTimer(function(player)
					triggerClientEvent(player,"createActivitiesInformationText",player,getText(player,"SJunkyard3"))
				end,7500,1,player)
			end
		end)
		
		addEventHandler("onVehicleLeave",Junkyard.Vehicle[i],function(player)
			if(getPedOccupiedVehicleSeat(player) == 0)then
				local ID = apocalypseGetElementData(source,"JunkyardVehID")
				if(isTimer(Junkyard.vehRespawnTimer[ID]))then killTimer(Junkyard.vehRespawnTimer[ID])end
				Junkyard.vehRespawnTimer[ID] = setTimer(function(ID)
					respawnVehicle(ID)
				end,180000,1,ID)
			end
		end)
		
		addEventHandler("onVehicleExplode",Junkyard.Vehicle[i],function(player)
			setTimer(function(veh)
				respawnVehicle(veh)
			end,300000,1,source)
		end)
	end
end
Junkyard.createVehicle()

addEventHandler("onTrailerAttach", root, function(truck)
    if getElementModel(truck) == 525 and apocalypseGetElementData(source,"LootVehicle") == true then
        local trailer = source
        setElementFrozen(trailer, false)
		local id = apocalypseGetElementData(trailer,"VehicleLootID")
		for _,v in pairs(getElementsByType("player"))do
			if(isCharacterLoggedIn(v))then
				triggerClientEvent(v,"VehicleLoot.markerAlpha",v,id,0)
			end
		end
    end
end)