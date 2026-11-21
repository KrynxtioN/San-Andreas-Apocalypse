function giveLootItems(player, amount)
	local Level_Bonus_EXP = tonumber(apocalypseGetElementData(player,"level"))
	if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
	local EXP = 5 * amount + (Level_Bonus_EXP * 1)
	if(SERVERBONUS.LOOTING == true)then EXP = EXP * 2 end
    giveEXP(player, EXP)

    local tbl = {}

    for i = 1, amount do
        local rarityRoll = math.random(1, 100)
        local commonItems = veryCommonLootItems
        if (getSkillLevel(player, 1) >= 5) then
            table.insert(commonItems, 28)
        end

        local item
        if (rarityRoll <= 70) then
            item = commonItems[math.random(1, #commonItems)]
        elseif (rarityRoll <= 90) then
            item = commonLootItems[math.random(1, #commonLootItems)]
        elseif (rarityRoll <= 98) then
            item = rareLootItems[math.random(1, #rareLootItems)]
        else
            item = extremelyRareItems[math.random(1, #extremelyRareItems)]
        end

        giveItem(player, item, 1)
        table.insert(tbl, {item, 1})
    end

    triggerClientEvent(player, "showItemBar", player, tbl)

    if (HalloweenEvent == true) then giveHalloweenPumpkin(player, 1) end
    if (ChristmasEvent == true) then giveChristmasPresent(player, 1) end
    if (ValentineEvent == true) then giveValentineItem(player, 1) end
	if (EasterEvent == true)then giveEasterEgg(player,1) end
end

addEventHandler("onPlayerClick", root, function(button, state, clickedElement)
	if(isCharacterLoggedIn(source))then
		if(button == "left" and state == "down" and clickedElement and isElement(clickedElement))then
			local model = getElementModel(clickedElement)
			if(model == 2912 or model == 3016 or model == 3015 or model == 3052)then
				if(not(apocalypseGetElementData(clickedElement,"DocumentID")))then
					if(not(apocalypseGetElementData(clickedElement,"LootPlace")))then
						if(not(apocalypseGetElementData(clickedElement,"ObjectLooted")))then
							apocalypseSetElementData(clickedElement,"ObjectLooted",false)
						end
						
						local px, py, pz = getElementPosition(source)
						local ox, oy, oz = getElementPosition(clickedElement)

						local maxDistance = 2.5
						local groundTolerance = 0.5

						if(getDistanceBetweenPoints3D(px, py, pz, ox, oy, oz) <= maxDistance)then
							local player = source
							if(apocalypseGetElementData(player,"ObjectLooting") ~= true)then
								if(apocalypseGetElementData(clickedElement, "ObjectLooted") == false)then
									apocalypseSetElementData(clickedElement,"ObjectLooted",true)
									if((pz - oz)  >= groundTolerance) then
										setPedAnimation(player,"bomber","bom_plant_loop",-1,true,false,false,true)
									else
										setPedAnimation(player, "ped", "ATM")
									end
									toggleAllControls(player, false)
									apocalypseSetElementData(player, "ObjectLooting", true)
									
									setTimer(function(clickedElement)
										apocalypseSetElementData(clickedElement,"ObjectLooted",false)
									end,1800000,1,clickedElement)
									
									setTimer(function(player)
										if(isElement(player))then
											setPedAnimation(player)
											toggleAllControls(player,true)
											apocalypseSetElementData(player, "ObjectLooting", false)
											giveLootItems(player,math.random(1,2))
										end
									end,7500,1,player)
								end
							end
						end
					end
				end
			end
		end
	end
end)

SkillpointStreak = {HouseTimer = {}, BuildingTimer = {}, DumpsterTimer = {}, VehicleTimer = {}, HousePoints = {}, BuildingPoints = {}, DumpsterPoints = {}, VehiclePoints = {}}

function SkillpointStreak.Houses(player)
	if(not(SkillpointStreak.HousePoints[player]))then SkillpointStreak.HousePoints[player] = 0 end
	if(isTimer(SkillpointStreak.HouseTimer[player]))then killTimer(SkillpointStreak.HouseTimer[player])end
	SkillpointStreak.HousePoints[player] = SkillpointStreak.HousePoints[player] + 1
	
	SkillpointStreak.HouseTimer[player] = setTimer(function(player)
		if(isElement(player))then
			SkillpointStreak.HousePoints[player] = 0
		end
	end,300000,1,player)
	
	if(SkillpointStreak.HousePoints[player] >= 3)then
		givePlayerSkillpoint(player,5)
	end
end

function SkillpointStreak.Buildings(player)
	if(not(SkillpointStreak.BuildingPoints[player]))then SkillpointStreak.BuildingPoints[player] = 0 end
	if(isTimer(SkillpointStreak.BuildingTimer[player]))then killTimer(SkillpointStreak.BuildingTimer[player])end
	SkillpointStreak.BuildingPoints[player] = SkillpointStreak.BuildingPoints[player] + 1
	
	SkillpointStreak.BuildingTimer[player] = setTimer(function(player)
		if(isElement(player))then
			SkillpointStreak.BuildingPoints[player] = 0
		end
	end,900000,1,player)
	
	if(SkillpointStreak.BuildingPoints[player] >= 3)then
		givePlayerSkillpoint(player,10)
	end
end

function SkillpointStreak.Dumpsters(player)
	if(not(SkillpointStreak.DumpsterPoints[player]))then SkillpointStreak.DumpsterPoints[player] = 0 end
	if(isTimer(SkillpointStreak.DumpsterTimer[player]))then killTimer(SkillpointStreak.DumpsterTimer[player])end
	SkillpointStreak.DumpsterPoints[player] = SkillpointStreak.DumpsterPoints[player] + 1
	
	SkillpointStreak.DumpsterTimer[player] = setTimer(function(player)
		if(isElement(player))then
			SkillpointStreak.DumpsterPoints[player] = 0
		end
	end,60000,1,player)
	
	if(SkillpointStreak.DumpsterPoints[player] >= 3)then
		givePlayerSkillpoint(player,1)
	end
end

function SkillpointStreak.Vehicles(player)
	if(not(SkillpointStreak.VehiclePoints[player]))then SkillpointStreak.VehiclePoints[player] = 0 end
	if(isTimer(SkillpointStreak.VehicleTimer[player]))then killTimer(SkillpointStreak.VehicleTimer[player])end
	SkillpointStreak.VehiclePoints[player] = SkillpointStreak.VehiclePoints[player] + 1
	
	SkillpointStreak.VehicleTimer[player] = setTimer(function(player)
		if(isElement(player))then
			SkillpointStreak.VehiclePoints[player] = 0
		end
	end,120000,1,player)
	
	if(SkillpointStreak.VehiclePoints[player] >= 3)then
		givePlayerSkillpoint(player,2)
	end
end

function SkillpointStreak.resetData(player)
	if(SkillpointStreak.HousePoints[player])then SkillpointStreak.HousePoints[player] = 0 end
	if(isTimer(SkillpointStreak.HouseTimer[player]))then killTimer(SkillpointStreak.House[player])end
	
	if(SkillpointStreak.BuildingPoints[player])then SkillpointStreak.BuildingPoints[player] = 0 end
	if(isTimer(SkillpointStreak.BuildingTimer[player]))then killTimer(SkillpointStreak.BuildingTimer[player])end
	
	if(SkillpointStreak.DumpsterPoints[player])then SkillpointStreak.DumpsterPoints[player] = 0 end
	if(isTimer(SkillpointStreak.DumpsterTimer[player]))then killTimer(SkillpointStreak.DumpsterTimer[player])end
	
	if(SkillpointStreak.VehiclePoints[player])then SkillpointStreak.VehiclePoints[player] = 0 end
	if(isTimer(SkillpointStreak.VehicleTimer[player]))then killTimer(SkillpointStreak.VehicleTimer[player])end
end

local woodAchievements = {
	{1,161},
	{5,162},
	{10,163},
	{25,164},
	{50,165},
	{75,166},
	{125,167},
	{175,168},
	{250,169},
	{375,170},
	{500,171},
	{999,172},
}

addEvent("sWoodPlanks",true)
addEventHandler("sWoodPlanks",root,function()
	local destroyed_wood = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"destroyed_wood"))
	Characters.addStats(client,"destroyed_wood",destroyed_wood + 1)
	
	for _,v in pairs(woodAchievements)do
		if(destroyed_wood + 1 >= v[1])then
			setAchievement(client,v[2])
		end
	end
end)

addEventHandler("onPlayerWasted",root,function()
	SkillpointStreak.resetData(player)
end)

addEventHandler("onPlayerQuit",root,function()
	SkillpointStreak.resetData(player)
end)