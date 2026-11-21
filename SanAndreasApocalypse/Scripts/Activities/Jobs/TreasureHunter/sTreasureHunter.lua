local vehicleData = {}

TreasureHunter = { vehicles = {}, treasures = {},
	["TreasureTypes"] = {
		["DE"] = {
			[1208] = {name = "Waschmaschine", minimum = 125,  maximum = 175},
			[2912] = {name = "Holzkiste", minimum = 125,  maximum = 175},
			[1291] = {name = "Briefkasten", minimum = 125,  maximum = 175},
			[2040] = {name = "wertvolle Kiste", minimum = 200, maximum = 250, scale = 5.5},
			[2972] = {name = "Fracht-Container", minimum = 200,  maximum = 250},
			[3015] = {name = "Waffen Kiste", minimum = 150,  maximum = 200, scale = 2},
		},
		["EN"] = {
			[1208] = {name = "Washing Machine", minimum = 125, maximum = 175},
			[2912] = {name = "Wooden Crate", minimum = 125, maximum = 175},
			[1291] = {name = "Mailbox", minimum = 125, maximum = 175},
			[2040] = {name = "Valuable Crate", minimum = 200, maximum = 250, scale = 5.5},
			[2972] = {name = "Freight Container", minimum = 200, maximum = 250},
			[3015] = {name = "Weapon Crate", minimum = 150, maximum = 200, scale = 2},
		},
		["RU"] = {
			[1208] = {name = "Стиральная машина", minimum = 125, maximum = 175},
			[2912] = {name = "Деревянный ящик", minimum = 125, maximum = 175},
			[1291] = {name = "Почтовый ящик", minimum = 125, maximum = 175},
			[2040] = {name = "Ценный ящик", minimum = 200, maximum = 250, scale = 5.5},
			[2972] = {name = "Грузовой контейнер", minimum = 200, maximum = 250},
			[3015] = {name = "Ящик с оружием", minimum = 150, maximum = 200, scale = 2},
		},
		["PT"] = {
			[1208] = {name = "Máquina de Lavar", minimum = 125, maximum = 175},
			[2912] = {name = "Caixote de Madeira", minimum = 125, maximum = 175},
			[1291] = {name = "Caixa de Correio", minimum = 125, maximum = 175},
			[2040] = {name = "Caixote Valioso", minimum = 200, maximum = 250, scale = 5.5},
			[2972] = {name = "Contentor de Carga", minimum = 200, maximum = 250},
			[3015] = {name = "Caixote de Armas", minimum = 150, maximum = 200, scale = 2},
		},
	},

	positions = {{450,-2552},{877,-2111},},
	
	Pickup = createPickup(716.46697998047,-1706.4816894531,2.4296875,3,1239,50),
	deliveryMarker = createMarker(736.6328125,-1718.9857177734,-1,"cylinder",7,255,255,255,75),
}

local achievements = {
	{1,84},
	{10,85},
	{25,86},
	{50,87},
	{100,88},
}

setElementVisibleTo(TreasureHunter.deliveryMarker,root,false)

local function setTreasureHunterAchievements(player)
	for _,v in pairs(achievements)do
		local found_treasures = tonumber(getPlayerData("character_stats","character_id",getCharacterID(player),"found_treasures"))
		if(found_treasures >= v[1])then
			setAchievement(player,v[2])
		end
	end
end

local function generateRandomTreasures(player)
    TreasureHunter.treasures[player] = {}
    for i = 1, 5 do
        TreasureHunter.loadTreasure(player)
    end
end

local function getRandomTreasureModel(player)
    local models = {}
    for model,_ in pairs(TreasureHunter["TreasureTypes"][apocalypseGetElementData(player,"language") or "EN"])do
        table.insert(models, model)
    end
    return models[math.random(#models)]
end

function TreasureHunter.createJobVehicle(player)
    local vehicle = createVehicle(453, 721.77478027344,-1705.6623535156,0,0,0,180)
    if(not(vehicle))then return end
	warpPedIntoVehicle(player, vehicle)
    setVehicleHandling(vehicle, "steeringLock", 70)

    local engine = createObject(3013,0,0,0)
    setObjectScale(engine,1.5)
    attachElements(engine, vehicle,0,-6.2,3.5)

    local magnet = createObject(1301,0,0,0)
    setObjectScale(magnet,0.5)
    attachElements(magnet,vehicle,0,-6.2,2)

    vehicleData[vehicle] = {
		engine = engine,
		magnet = magnet,
		treasureObject = nil
	}

    TreasureHunter.vehicles[player] = vehicle
	
	addEventHandler("onVehicleStartEnter",TreasureHunter.vehicles[player],function(player)
		cancelEvent()
	end)
	
	addEventHandler("onVehicleExit",TreasureHunter.vehicles[player],function(player)
		TreasureHunter.stopTreasureJob(player)
	end)
	
	triggerClientEvent(player,"JobInformation.createWindow",player,3)
end

function TreasureHunter.loadTreasure(player)
    local pos1 = TreasureHunter.positions[1]
    local pos2 = TreasureHunter.positions[2]
    local x = math.random(pos1[1],pos2[1])
    local y = math.random(pos1[2],pos2[2])
    local col = createColCircle(x,y,25)
    local dummy = createObject(1337,x,y,-20)
    apocalypseSetElementData(dummy,"Treasure",player)
    apocalypseSetElementData(col,"dummy",dummy)
    apocalypseSetElementData(col,"jobOwner",player)
    table.insert(TreasureHunter.treasures[player],col)
    
    addEventHandler("onColShapeHit", col, function(hit, matchingDimension)
        TreasureHunter.onTreasureHit(hit,matchingDimension)
    end)
	
	triggerClientEvent(player,"TreasureHunter.updateTreasurePosition",player,TreasureHunter.treasures[player])
end

function TreasureHunter.onTreasureHit(hitElement, matchingDimension)
    local jobOwner = apocalypseGetElementData(source, "jobOwner")
    if(matchingDimension and hitElement == jobOwner)then
        if(getPedOccupiedVehicle(hitElement) == TreasureHunter.vehicles[hitElement])then
			NPC.MeMessage(hitElement,getText(hitElement,"STreasureHunter1"))
			triggerClientEvent(hitElement,"createActivitiesInformationText",hitElement,getText(hitElement,"STreasureHunter2"))
        end
    end
end

function TreasureHunter.takeUp(player)
    local veh = getPedOccupiedVehicle(player)
    if(veh and veh == TreasureHunter.vehicles[player])then
        local vData = vehicleData[veh]
        if(not vData or not vData.magnet) then return end
        local magnet = vData.magnet
        if(vData.treasureObject and isElement(vData.treasureObject))then
			NPC.MeMessage(player,getText(player,"STreasureHunter9"))
			return
		end
		
        local found = false
        for index, col in ipairs(TreasureHunter.treasures[player] or {}) do
            if(col and isElement(col) and isElementWithinColShape(player, col))then
                found = true
                local objectModel = getRandomTreasureModel(player)
                setElementFrozen(veh,true)
                detachElements(magnet,veh)
				
				local matrix = getElementMatrix(veh)
				local offsetX, offsetY, offsetZ = 0, -6.2, 2

				local newPosX = matrix[4][1] + offsetX * matrix[1][1] + offsetY * matrix[2][1] + offsetZ * matrix[3][1]
				local newPosY = matrix[4][2] + offsetX * matrix[1][2] + offsetY * matrix[2][2] + offsetZ * matrix[3][2]
				local newPosZ = matrix[4][3] + offsetX * matrix[1][3] + offsetY * matrix[2][3] + offsetZ * matrix[3][3]

				setElementPosition(magnet, newPosX, newPosY, newPosZ)
				moveObject(magnet, 7500, newPosX, newPosY, newPosZ - 15)

                local treasureObject = createObject(objectModel,newPosX,newPosY,newPosZ - 100)
                if(TreasureHunter["TreasureTypes"][apocalypseGetElementData(player,"language") or "EN"][objectModel].scale)then
                    setObjectScale(treasureObject, TreasureHunter["TreasureTypes"][apocalypseGetElementData(player,"language") or "EN"][objectModel].scale)
                end
                vehicleData[veh].treasureObject = treasureObject
				
                setTimer(function(magnet)
					if(isElement(magnet))then
						local mx, my, mz = getElementPosition(magnet)
						attachElements(treasureObject, magnet, 0, 0, -0.9)
						moveObject(magnet, 7500, mx, my, mz + 15)
					end
                end,7500,1,magnet)
				
                setTimer(function(magnet,veh,player)
					if(isElement(magnet))then
						attachElements(magnet,veh,0,-6.2,2)
					end
                    if(isElement(veh))then
						setElementFrozen(veh,false)
					end
					NPC.MeMessage(player,getText(player,"STreasureHunter5"))
					triggerClientEvent(player,"createActivitiesInformationText",player,getText(player,"STreasureHunter6"))
                end,15000,1,magnet,veh,player)
				
				triggerClientEvent(player,"createProgressBar",player,15)
				
                local dummy = apocalypseGetElementData(col, "dummy")
                if(dummy and isElement(dummy))then 
                    destroyElement(dummy)
                end
				
                destroyElement(col)
                table.remove(TreasureHunter.treasures[player],index)
				triggerClientEvent(player,"TreasureHunter.updateTreasurePosition",player,TreasureHunter.treasures[player])
                break
            end
        end
    end
end

function TreasureHunter.onDeliveryHit(hitElement, matchingDimension)
    if(matchingDimension and getElementType(hitElement) == "player")then
        local veh = getPedOccupiedVehicle(hitElement)
        if(veh and veh == TreasureHunter.vehicles[hitElement])then
            local vData = vehicleData[veh]
            if(vData and vData.treasureObject and isElement(vData.treasureObject))then
                local model = getElementModel(vData.treasureObject)
                if(not(TreasureHunter["TreasureTypes"][apocalypseGetElementData(hitElement,"language") or "EN"][model]))then return end
				
				local money = math.random(TreasureHunter["TreasureTypes"][apocalypseGetElementData(hitElement,"language") or "EN"][model].minimum, TreasureHunter["TreasureTypes"][apocalypseGetElementData(hitElement,"language") or "EN"][model].maximum)
				createInfobox(hitElement,getText(hitElement,"STreasureHunter3"):format(TreasureHunter["TreasureTypes"][apocalypseGetElementData(hitElement,"language") or "EN"][model].name,money))
                destroyElement(vData.treasureObject)
                vData.treasureObject = nil
				
				local Level_Bonus_EXP = tonumber(apocalypseGetElementData(hitElement,"level"))
				if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
					
				local xp = 125 + (Level_Bonus_EXP * 25)
				local skillpoint = 10
				if(SERVERBONUS.JOB_ACTIVITIES == true)then
					money = money * 2
					xp = xp * 2
					skillpoint = skillpoint * 2
				end
                TreasureHunter.loadTreasure(hitElement)
				givePlayerServerMoney(hitElement,money)
				local shells = math.random(3,7)
				if(SERVERBONUS.JOB_ACTIVITIES == true)then
					shells = shells + 5
				end
				giveItem(hitElement,67,shells)
				triggerClientEvent(client, "showItemBar", client, {{67,shells}})
				givePlayerSkillpoint(hitElement,skillpoint)
				
				local found_treasures = tonumber(getPlayerData("character_stats","character_id",getCharacterID(hitElement),"found_treasures"))
				Characters.addStats(hitElement,"found_treasures",found_treasures + 1)
				TreasureHunter.updateShellObjectData(hitElement)
				setTreasureHunterAchievements(hitElement)
				giveEXP(hitElement,xp)
				
				outputLog(getPlayerName(hitElement).." hat "..shells.." Muscheln, $"..money.." und "..xp.." EXP bekommen", "Treasure Hunter", getCharacterID(hitElement))
				
				if(DailyTasks.playerTasks[hitElement][14])then
					DailyTasks.updateProgress(hitElement,14,DailyTasks.playerTasks[hitElement][14].progress + 1)
				end
				
				if(WeeklyTasks.playerTasks[hitElement][14])then
					WeeklyTasks.updateProgress(hitElement,14,WeeklyTasks.playerTasks[hitElement][14].progress + 1)
				end
            end
        end
    end
end

addEventHandler("onMarkerHit",TreasureHunter.deliveryMarker,function(hitElement,matchingDimension)
	TreasureHunter.onDeliveryHit(hitElement,matchingDimension)
end)

function TreasureHunter.startTreasureJob(player)
	if(not(isPedInVehicle(player)))then
		if(getDistanceBetweenPoints3D(716.46697998047,-1706.4816894531,2.4296875,getElementPosition(player)) <= 5)then
			if(tonumber(apocalypseGetElementData(player,"level")) >= 15)then
				if(not(TreasureHunter.vehicles[player]))then
					NPC.MeMessage(player,getText(player,"STreasureHunter4"))
					generateRandomTreasures(player)
					TreasureHunter.createJobVehicle(player)
					bindKey(player,"space","down",TreasureHunter.takeUp)
					setElementVisibleTo(TreasureHunter.deliveryMarker,player,true)
					triggerClientEvent(player,"createActivitiesInformationText",player,getText(player,"STreasureHunter7"))
				end
			else
				NPC.MeMessage(player,getText(player,"STreasureHunter8"))
			end
		end
	end
end

function TreasureHunter.stopTreasureJob(player)
    if(TreasureHunter.vehicles[player])then
        local veh = TreasureHunter.vehicles[player]
        if(isElement(veh))then
			local vData = vehicleData[veh]
			destroyElement(vData.engine)
			destroyElement(vData.magnet)
			destroyElement(veh)
			vData[veh] = nil
		end
        TreasureHunter.vehicles[player] = nil
		
        if(TreasureHunter.treasures[player])then
            for _, col in ipairs(TreasureHunter.treasures[player])do
                if(col and isElement(col))then
                    local dummy = apocalypseGetElementData(col, "dummy")
                    if(dummy and isElement(dummy))then
                        destroyElement(dummy)
                    end
                    destroyElement(col)
                end
            end
            TreasureHunter.treasures[player] = nil
        end
        unbindKey(player,"space","down",TreasureHunter.takeUp)
        setElementVisibleTo(TreasureHunter.deliveryMarker,player,false)
		triggerClientEvent(player,"TreasureHunter.stopJob",player)
		
		if(not(isPedDead(player)))then
			setTimer(function(player)
				setElementPosition(player,714.480,-1692.521,2.430)
			end,50,1,player)
		end
    end
end

function TreasureHunter.updateShellObjectData(player)
	local shells = getPlayerData("character_stats","character_id",getCharacterID(player),"found_treasures")
	triggerClientEvent(player,"TreasureHunter.updateShellObjectData",player,shells)
end

addEventHandler("onPlayerWasted",root,function() TreasureHunter.stopTreasureJob(source) end)
addEventHandler("onPlayerQuit",root,function() TreasureHunter.stopTreasureJob(source) end)