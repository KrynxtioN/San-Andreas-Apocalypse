local Achievements = {
	{1,224},
	{10,225},
	{25,226},
	{50,227},
	{100,228},
	{150,229},
	{200,230},
	{250,231},
	{300,232},
	{350,233},
	{400,234},
	{500,235},
}

for i,v in ipairs(VehicleMissions["VehicleCoordinates"])do
	if(not(isElement(VehicleMissions.Vehicle[i])))then
		VehicleMissions.Vehicle[i] = createVehicle(v[1],v[2],v[3],v[4],v[5],v[5],v[7])
		
		addEventHandler("onVehicleEnter",VehicleMissions.Vehicle[i],function(player)
			if(getPedOccupiedVehicleSeat(player) == 0)then
				apocalypseSetElementData(source,"HurtSurvivor",0)
				local Generate_HurtSurvivor_Time = VehicleMissions.getSkillTime(player)
				killHurtSurvivorTimer(player)
				
				if(getElementModel(source) == 416)then
					triggerClientEvent(player,"createActivitiesInformationText",player,getText(player,"CVehicleMissions3"))
					triggerClientEvent(player,"createInformationMessage",player,getText(player,"CVehicleMissions1"))
					triggerClientEvent(player,"VehicleMissions.createHurtSurvivorDelivery",player,"HurtSurvivorsDelivery")
					triggerClientEvent(player,"createHurtSurvivorDxDraw",player,"CVehicleMissions2")
				elseif(getElementModel(source) == 599)then
					triggerClientEvent(player,"createActivitiesInformationText",player,getText(player,"CVehicleMissions6"))
					triggerClientEvent(player,"createInformationMessage",player,getText(player,"CVehicleMissions4"))
					triggerClientEvent(player,"VehicleMissions.createHurtSurvivorDelivery",player,"HurtSurvivorsDeliveryPolice")
					triggerClientEvent(player,"createHurtSurvivorDxDraw",player,"CVehicleMissions5")
				elseif(getElementModel(source) == 407)then
					triggerClientEvent(player,"createActivitiesInformationText",player,getText(player,"CVehicleMissions9"))
					triggerClientEvent(player,"createInformationMessage",player,getText(player,"CVehicleMissions7"))
					triggerClientEvent(player,"VehicleMissions.createHurtSurvivorDelivery",player,"HurtSurvivorsDeliveryFirefighter")
					triggerClientEvent(player,"createHurtSurvivorDxDraw",player,"CVehicleMissions8")
				end
				
				triggerClientEvent(player,"VehicleMissions.createHurtSurvivor",player)
				
				VehicleMissions.HurtSurvivorTimer[player] = setTimer(function(player)
					triggerClientEvent(player,"VehicleMissions.createHurtSurvivor",player)
				end,math.random(5000,Generate_HurtSurvivor_Time),0,player)
			end
		end)
		
		addEventHandler("onVehicleExit",VehicleMissions.Vehicle[i],function(player)
			local hurt_survivor = apocalypseGetElementData(source,"HurtSurvivor")
			local xp = (hurt_survivor * 25) + (tonumber(getSkillLevel(player,5)) * 2) or 0
			if(SERVERBONUS.VEHICLE_MISSIONS == true)then xp = xp * 2 end
			if(hurt_survivor and hurt_survivor >= 1)then
				giveEXP(player,xp)
			end
			triggerClientEvent(player,"VehicleMissions.destroyHurtSurvivor",player)
			apocalypseSetElementData(source,"HurtSurvivor",0)
			killHurtSurvivorTimer(player)
			outputLog(getPlayerName(player).." hat "..xp.." EXP durch gerettete Überlebende erhalten","Vehicle Missions",getCharacterID(player))
		end)
	end
end

addEvent("addHurtSurvivor",true)
addEventHandler("addHurtSurvivor",root,function()
	local veh = getPedOccupiedVehicle(client)
	if(veh)then
		local hurt_survivor = apocalypseGetElementData(veh,"HurtSurvivor") or 0
		apocalypseSetElementData(veh,"HurtSurvivor",hurt_survivor + 1)
		giveEXP(client,10)
	end
end)

addEvent("VehicleMissions.hurtSurvivorDelivery",true)
addEventHandler("VehicleMissions.hurtSurvivorDelivery",root,function()
	local veh = getPedOccupiedVehicle(client)
	if(veh)then
		local hurt_survivor = apocalypseGetElementData(veh,"HurtSurvivor") or 0
		if(hurt_survivor and hurt_survivor >= 1)then
			hurtSurvivorAchievements(client,hurt_survivor)
			local Level_Bonus_EXP = tonumber(apocalypseGetElementData(client,"level"))
			if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
			local experience, money = (hurt_survivor * 40) + (tonumber(getSkillLevel(client,5)) * 2), (hurt_survivor * 5) + (tonumber(getSkillLevel(client,5)) * 1)
			experience = experience + (Level_Bonus_EXP * 1)
			local skillpoints = hurt_survivor
			if(SERVERBONUS.VEHICLE_MISSIONS == true)then
				experience = experience * 2
				money = money * 2
				skillpoints = skillpoints * 2
			end
			apocalypseSetElementData(veh,"HurtSurvivor",0)
			giveEXP(client,experience)
			givePlayerServerMoney(client,money)
			givePlayerSkillpoint(client,skillpoints)
			outputLog(getPlayerName(client).." hat "..experience.." EXP und $"..money.." durch gerettete Überlebende erhalten","Vehicle Missions",getCharacterID(client))
		end
	end
end)

function hurtSurvivorAchievements(player,amount)
	local saved_survivors = tonumber(getPlayerData("character_stats","character_id",getCharacterID(player),"saved_survivors"))
	Characters.addStats(player,"saved_survivors",saved_survivors + amount)
							
	for _,v in pairs(Achievements)do
		if(saved_survivors + amount >= v[1])then
			setAchievement(player,v[2])
		end
	end

	if(DailyTasks.playerTasks[player][12])then
		DailyTasks.updateProgress(player,12,DailyTasks.playerTasks[player][12].progress + amount)
	end
	if(WeeklyTasks.playerTasks[player][12])then
		WeeklyTasks.updateProgress(player,12,WeeklyTasks.playerTasks[player][12].progress + amount)
	end
end

function killHurtSurvivorTimer(player)
	if(not(player))then player = client end
	if(isTimer(VehicleMissions.HurtSurvivorTimer[player]))then
		killTimer(VehicleMissions.HurtSurvivorTimer[player])
	end
end
addEvent("killHurtSurvivorTimer",true)
addEventHandler("killHurtSurvivorTimer",root,killHurtSurvivorTimer)

function VehicleMissions.getSkillTime(player)
	local lvl = tonumber(getSkillLevel(player,5))
	local timer = 30000
	if(lvl > 0)then
		if(lvl == 1)then timer = 25000 end
		if(lvl == 2)then timer = 20000 end
		if(lvl == 3)then timer = 15000 end
		if(lvl == 4)then timer = 10000 end
		if(lvl == 5)then timer = 5000 end
	end
	return timer
end

addEventHandler("onPlayerWasted",root,function()
	killHurtSurvivorTimer(source)
	triggerClientEvent(source,"VehicleMissions.destroyHurtSurvivor",source)
end)

addEventHandler("onPlayerQuit",root,function()
	killHurtSurvivorTimer(source)
end)