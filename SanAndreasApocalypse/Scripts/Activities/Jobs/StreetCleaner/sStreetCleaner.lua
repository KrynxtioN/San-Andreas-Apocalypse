local TrashModels = {2670,2671,2672,2673,2674,2675,2676,2677}
StreetCleaner = {veh = {}, vehTimer = {},
	["Vehicles"] = {
		{574,2325.609375,67.4521484375,26.286100387573,0,0,90},
		{574,2323.9765625,59.9765625,26.278299331665,0,0,0},
		{574,2326.1005859375,59.9765625,26.278299331665,0,0,0},
	},
}

local Achievements = {
	{1,212},
	{5,213},
	{10,214},
	{25,215},
	{50,216},
	{75,217},
	{125,218},
	{175,219},
	{225,220},
	{300,221},
	{375,222},
	{500,223},
}

for i,v in pairs(StreetCleaner["Vehicles"])do
	StreetCleaner.veh[i] = createVehicle(v[1],v[2],v[3],v[4],v[5],v[6],v[7])
	apocalypseSetElementData(StreetCleaner.veh[i],"StreetCleanerID",i)
	
	addEventHandler("onVehicleEnter",StreetCleaner.veh[i],function(player)
		if(getPedOccupiedVehicleSeat(player) == 0)then
			local ID = apocalypseGetElementData(source,"StreetCleanerID")
			if(isTimer(StreetCleaner.vehTimer[ID]))then
				killTimer(StreetCleaner.vehTimer[ID])
			end
			triggerClientEvent(player,"JobInformation.createWindow",player,5)
		end
	end)
	
	addEventHandler("onVehicleExit",StreetCleaner.veh[i],function(player)
		if(getPedOccupiedVehicleSeat(player) == 0)then
			local ID = apocalypseGetElementData(source,"StreetCleanerID")
			if(isTimer(StreetCleaner.vehTimer[ID]))then
				killTimer(StreetCleaner.vehTimer[ID])
			end
			StreetCleaner.vehTimer[ID] = setTimer(function(ID)
				respawnVehicle(StreetCleaner.veh[ID])
			end,300000,1,ID)
		end
	end)
	
	addEventHandler("onVehicleExplode",StreetCleaner.veh[i],function()
		local ID = apocalypseGetElementData(source,"StreetCleanerID")
		if(isTimer(StreetCleaner.vehTimer[ID]))then
			killTimer(StreetCleaner.vehTimer[ID])
		end
		respawnVehicle(StreetCleaner.veh[ID])
	end)
end

local function createTrashObject(x,y,z)
	local Object = createObject(TrashModels[math.random(1,#TrashModels)],x,y,z,0,0,math.random(0,360))
	local Marker = createMarker(x,y,z,"cylinder",2,0,0,0,0)
	apocalypseSetElementData(Marker,"TrashObject",Object)
	
	addEventHandler("onMarkerHit",Marker,function(vehicle)
		if(getElementType(vehicle) == "vehicle")then
			local player = getVehicleOccupant(vehicle,0)
			if(getElementModel(vehicle) == 574)then
				if(player)then
					if(getElementDimension(player) == getElementDimension(source))then
						local Object = apocalypseGetElementData(source,"TrashObject")
						if(isElement(Object))then
							local x, y, z = getElementPosition(source)
							destroyElement(source)
							destroyElement(Object)
							
							setTimer(function(x,y,z)
								createTrashObject(x,y,z)
							end,300000,1,x,y,z)
							
							local Level_Bonus_EXP = tonumber(apocalypseGetElementData(player,"level"))
							if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
							
							local xp = 15 + (Level_Bonus_EXP * 1)
							local skillpoint = 10
							if(SERVERBONUS.JOB_ACTIVITIES == true)then
								xp = xp * 2
								skillpoint = skillpoint * 2
							end
	
							local trashItem = math.random(2,5)
							giveItem(player,119,trashItem)

							giveEXP(player,xp)
							givePlayerSkillpoint(player,skillpoint)
							triggerClientEvent(client, "showItemBar", client, {{119,trashItem}})
							
							local sweeper_trash = tonumber(getPlayerData("character_stats","character_id",getCharacterID(player),"sweeper_trash"))
							Characters.addStats(player,"sweeper_trash",sweeper_trash + trashItem)
							outputLog(getPlayerName(player).." hat "..trashItem.."x Müll eingesammelt und "..xp.." EXP und "..skillpoint.." Skillpunkte erhalten", "Street Cleaner", getCharacterID(player))
							
							for _,v in pairs(Achievements)do
								if(sweeper_trash + 1 >= v[1])then
									setAchievement(player,v[2])
								end
							end
							
							if(DailyTasks.playerTasks[player][15])then
								DailyTasks.updateProgress(player,15,DailyTasks.playerTasks[player][15].progress + trashItem)
							end
								
							if(WeeklyTasks.playerTasks[player][15])then
								WeeklyTasks.updateProgress(player,15,WeeklyTasks.playerTasks[player][15].progress + trashItem)
							end
							
							triggerClientEvent(player,"updateStreetCleanerData",player,sweeper_trash + trashItem)
						end
					end
				end
			end
		end
	end)
end

for _, v in pairs(getElementsByType("object"))do
	local Model = getElementModel(v)
	if(Model == 2670 or Model == 2671 or Model == 2672 or Model == 2673 or Model == 2674 or Model == 2675 or Model == 2676 or Model == 2677)then
		local x, y, z = getElementPosition(v)
		destroyElement(v)
		createTrashObject(x,y,z)
	end
end