local Achievements = {
    {5,326},
    {10,327},
    {25,328},
    {50,329},
    {75,330},
    {125,331},
    {175,332},
    {250,333},
}

local COOLDOWN_SECONDS = 300

function Dumpster.create()
    for i,v in ipairs(Dumpster["Coordinates"]) do
        Dumpster.objects[i] = createObject(v[7], v[1], v[2], v[3], v[4], v[5], v[6])
        Dumpster.timers[i] = {}
        apocalypseSetElementData(Dumpster.objects[i],"DumpsterID",i)
    end
end
Dumpster.create()

function Dumpster.createPlayerMarker(player)
    local Coordinates = Dumpster["Coordinates"]
    triggerClientEvent(player,"Dumpster.createPlayerMarker",player,Coordinates)
end

function Dumpster.cancel(player)
    if apocalypseGetElementData(player,"SearchingTrash") == true then
        unbindKey(player,"e","down",Dumpster.cancel)
		triggerClientEvent(player,"ProgressBar.close",player)
		toggleAllControls(player,true)
		setPedAnimation(player)
        apocalypseSetElementData(player,"SearchingTrash",false)
    end
end

addEventHandler("onPlayerClick", root, function(button, state, clickedElement)
    if not isCharacterLoggedIn(source) then return end
    if button ~= "left" or state ~= "down" or not clickedElement then return end

    local dumpsterID = apocalypseGetElementData(clickedElement,"DumpsterID")
    if not dumpsterID then return end

    local player = source
    local x, y, z = getElementPosition(player)
    local dx, dy, dz = getElementPosition(clickedElement)
    if getDistanceBetweenPoints3D(x, y, z, dx, dy, dz) > 2.5 then return end

    local currentTime = getRealTime().timestamp
    if not Dumpster.timers[dumpsterID][player] then
        Dumpster.timers[dumpsterID][player] = 0
    end

    local lastLootTime = Dumpster.timers[dumpsterID][player]
    if lastLootTime == 0 or currentTime - lastLootTime >= COOLDOWN_SECONDS then
        if apocalypseGetElementData(player,"SearchingTrash") == nil then
            apocalypseSetElementData(player,"SearchingTrash",false)
        end
        if apocalypseGetElementData(player,"SearchingTrash") == false then
            triggerClientEvent(player,"createActivitiesInformationText",player,getText(player,"SRandomLootCrate2"))
            bindKey(player,"e","down",Dumpster.cancel)
            setPedAnimation(player,"ped","ATM")
            toggleAllControls(player,true)
            apocalypseSetElementData(player,"SearchingTrash",true)

            for _,v in pairs(getElementsByType("player")) do
                if isCharacterLoggedIn(v) then
                    triggerClientEvent(v,"Dumpster.updateMarkerColor",v,dumpsterID,255,0,0)
                end
            end

            triggerClientEvent(player,"createProgressBar",player,2)

            setTimer(function(p)
                if isElement(p) then
                    toggleAllControls(p,true)
                    setPedAnimation(p)
                    apocalypseSetElementData(p,"SearchingTrash",false)

                    if math.random(1, 3) ~= 2 then
                        giveLootItems(p, math.random(1, 2))
                    else
                        NPC.MeMessage(p, getText(p, "SHouseLoot9"))
                    end
					local Level_Bonus_EXP = tonumber(apocalypseGetElementData(p,"level"))
					if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
					local EXP = 15 + (Level_Bonus_EXP * 1)
					if(SERVERBONUS.LOOTING == true)then EXP = EXP * 2 end

                    setAchievement(p, 45)
                    giveEXP(p,EXP)

                    if DailyTasks.playerTasks[p] and DailyTasks.playerTasks[p][5] then
                        DailyTasks.updateProgress(p,5,DailyTasks.playerTasks[p][5].progress + 1)
                    end
					if(WeeklyTasks.playerTasks[p][5])then
						WeeklyTasks.updateProgress(p,5,WeeklyTasks.playerTasks[p][5].progress + 1)
					end

                    SkillpointStreak.Dumpsters(p)
                    givePlayerSkillpoint(p,1)

                    Dumpster.timers[dumpsterID][p] = getRealTime().timestamp

                    local looted_dumpsters = getPlayerData("character_stats","character_id",getCharacterID(p),"looted_dumpsters")
                    Characters.addStats(p,"looted_dumpsters",looted_dumpsters + 1)

                    for _,v in pairs(Achievements) do
                        if looted_dumpsters + 1 >= v[1] then
                            setAchievement(p,v[2])
                        end
                    end

                    triggerClientEvent(p,"TutorialPickups.deletePickup",p,"LootDumpster")
                end
            end, 2000, 1, player)

            setTimer(function(id)
                for _,v in pairs(getElementsByType("player")) do
                    if isCharacterLoggedIn(v) then
                        triggerClientEvent(v,"Dumpster.updateMarkerColor",v,id,255,255,255)
                    end
                end
            end, COOLDOWN_SECONDS * 1000, 1, dumpsterID)
        end
    else
        NPC.MeMessage(player, getText(player, "SVehicleLoot1"))
    end
end)

addEventHandler("onPlayerWasted",root,function()
    Dumpster.cancel(source)
end)
