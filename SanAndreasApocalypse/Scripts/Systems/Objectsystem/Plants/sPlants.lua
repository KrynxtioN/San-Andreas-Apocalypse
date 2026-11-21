Plantsystem = {Objects = {},
	["Model"] = {
		[82] = 738,
		[83] = 858,
		[84] = 3409,
		[121] = 650,
		[184] = 1935,
		[210] = 1877,
	},
}

local ID = 0

function Plantsystem.create()
	local result = dbPoll(dbQuery(handler,"SELECT * FROM plants"),-1)
	if(#result >= 1)then
		for _,v in pairs(result)do
			Plantsystem.createObject(v["model"],v["spawnx"],v["spawny"],v["spawnz"],v["rotz"],v["ID"])
			ID = v["ID"]
		end
	end
end

function Plantsystem.plant(player, ItemID)
    if(not(isPedDead(player))) then
        if(getElementInterior(player) == 0 and getElementDimension(player) == 0) then
            if(not(isPedInVehicle(player)) and isPedOnGround(player) and not(isElementInWater(player))) then
				if(isPlayerInSafeZone(player) == false)then
					if(apocalypseGetElementData(player, "isPlanting") ~= true) then
						local playerPlants = dbPoll(dbQuery(handler,"SELECT * FROM plants WHERE owner_character_id = '"..getCharacterID(player).."'"),-1)
						if(#playerPlants < 10)then
							local model = Plantsystem["Model"][tonumber(ItemID)]
							if(ItemID == 210)then
								if(math.random(1,2) == 2)then
									model = 1878
								end
							end
							local x, y, z = getElementPosition(player)
							local rx, ry, rz = getElementRotation(player)
							takeItem(player, ItemID, 1)
							apocalypseSetElementData(player, "isPlanting", true)
							setElementFrozen(player, true)
							setPedAnimation(player, "BOMBER", "BOM_Plant_Loop")
							
							local time = getRealTime()
							local currentTimestamp = time.timestamp
							if(model == 1935)then z = z + 0.2 end
							dbExec(handler, "INSERT INTO plants (model, spawnx, spawny, spawnz, rotz, owner_character_id, stime) VALUES (?,?,?,?,?,?,?)", model, x, y, z, rz, getCharacterID(player), currentTimestamp)

							setTimer(function(player, model, x, y, z, rz)
								if(isElement(player)) then
									apocalypseSetElementData(player, "isPlanting", false)
									setPedAnimation(player)
									Plantsystem.create()
									setElementFrozen(player, false)
									Characters.addStats(player, "planted", getPlayerData("character_stats", "character_id", getCharacterID(player), "planted") + 1)
									Plantsystem.checkAchievement(player)
								end
							end, 7500, 1, player, model, x, y, z, rz)
						else
							createInfobox(player,getText(player,"SPlants3"))
						end
					end
                end
            end
        end
    end
end

function Plantsystem.createObject(model,x,y,z,rz,id)
	if(not(isElement(Plantsystem.Objects[id])))then
		Plantsystem.Objects[id] = createObject(model,x,y,z-1,0,0,rz)
		apocalypseSetElementData(Plantsystem.Objects[id],"PlantID",id)
	end
end

function Plantsystem.harvestWeed(player)
    for _, v in pairs(Plantsystem.Objects) do
        if(getElementModel(v) == 3409) then
            local x, y, z = getElementPosition(v)
            if(getDistanceBetweenPoints3D(x, y, z, getElementPosition(player)) <= 2.5) then
                local plantID = apocalypseGetElementData(v, "PlantID")
                local plantTime = getPlayerData("plants", "ID", plantID, "stime")

                if(plantTime ~= 0) then
                    local time = getRealTime()
                    local currentTimestamp = time.timestamp

                    if((currentTimestamp - plantTime) >= 14400) then
                        dbExec(handler, "DELETE FROM plants WHERE ID = '"..plantID.."'")
                        destroyElement(v)
                        local weedamount = math.random(50, 75)
                        giveItem(player, 92, weedamount)
						triggerClientEvent(player, "showItemBar", player, {{92,amount}})

						local Level_Bonus_EXP = tonumber(apocalypseGetElementData(player,"level"))
						if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
						
						local EXP = 25 + (Level_Bonus_EXP * 5)
                        giveEXP(player, EXP)
                        NPC.MeMessage(player, getText(player, "MeMessage4"):format(weedamount))
                        Characters.addStats(player, "harvested", getPlayerData("character_stats", "character_id", getCharacterID(player), "harvested") + 1)
                        Plantsystem.checkAchievement(player)
						outputLog("[WEED] "..getPlayerName(player).." ("..getCharacterID(player).." hat Weed geerntet und "..EXP.." EXP bekommen","Weed",getCharacterID(player))
                    else
                        local remainingTimeInSec = 14400 - (currentTimestamp - plantTime)
                        createInfobox(player, getText(player, "SPlants1"):format(formatTimeLeft(remainingTimeInSec)))
                    end
                end
            end
        end
    end
end

addEventHandler("onPlayerClick", root, function(button, state, clickedElement)
    if(button == "left" and state == "down" and clickedElement) then
        if(apocalypseGetElementData(clickedElement, "PlantID")) then
            local x, y, z = getElementPosition(source)
            if(getDistanceBetweenPoints3D(x, y, z, getElementPosition(clickedElement)) <= 2.5) then
                local plantID = apocalypseGetElementData(clickedElement, "PlantID")
                local plantTime = getPlayerData("plants", "ID", plantID, "stime")
                local currentTimestamp = getRealTime().timestamp

                if(not(plantTime) or plantTime ~= 0 and (currentTimestamp - plantTime) >= 14400) then
                    local model = getElementModel(clickedElement)
                    dbExec(handler, "DELETE FROM plants WHERE ID = '"..plantID.."'")
                    local amount = math.random(9, 12)
                    if(model == 738) then
                        giveItem(source, 60, amount)
						triggerClientEvent(source, "showItemBar", source, {{60,amount}})
                        NPC.MeMessage(source, getText(source, "MeMessage2"):format(amount))
                    end
                    if(model == 858) then
                        giveItem(source, 61, amount)
						triggerClientEvent(source, "showItemBar", source, {{61,amount}})
                        NPC.MeMessage(source, getText(source, "MeMessage3"):format(amount))
                    end
					if(model == 650)then
						giveItem(source, 122, amount)
						triggerClientEvent(source, "showItemBar", source, {{122,amount}})
						NPC.MeMessage(source, getText(source, "SPlants2"):format(amount))
					elseif(model == 1935)then
						giveHalloweenPumpkin(source,10)
						NPC.MeMessage(source, getText(source, "SPlants4"):format(10))
					end
					local EXP = 25 + (apocalypseGetElementData(source,"level") * 5)
                    giveEXP(source, 25)
                    destroyElement(clickedElement)
                    Characters.addStats(source, "harvested", getPlayerData("character_stats", "character_id", getCharacterID(source), "harvested") + 1)
                    Plantsystem.checkAchievement(source)
					outputLog("[WEED] "..getPlayerName(source).." ("..getCharacterID(source).." hat eine Pflanze geerntet und "..EXP.." EXP bekommen","Weed",getCharacterID(source))
                else
                    local timeLeft = 14400 - (currentTimestamp - plantTime)
					createInfobox(source, getText(source, "SPlants1"):format(formatTimeLeft(timeLeft)))
                end
            end
        end
    end
end)

Plantsystem.create()

function Plantsystem.checkAchievement(player)
	local planted = tonumber(getPlayerData("character_stats","character_id",getCharacterID(player),"planted"))
	local harvested = tonumber(getPlayerData("character_stats","character_id",getCharacterID(player),"harvested"))
	if(planted >= 1)then setAchievement(player,76) end
	if(harvested >= 1)then setAchievement(player,77) end
	if(harvested >= 10)then setAchievement(player,78) end
	if(harvested >= 25)then setAchievement(player,79) end
	if(harvested >= 50)then setAchievement(player,80) end
	if(harvested >= 100)then setAchievement(player,81) end
end