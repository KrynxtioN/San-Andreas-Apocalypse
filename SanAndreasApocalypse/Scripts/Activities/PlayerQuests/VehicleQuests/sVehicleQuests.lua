VehicleQuests = {vehicle = {}, marker = {}, respawnTimer = {}, deliveredTimer = {},
    ["Coordinates"] = {
        [1] = {
            {463,544.79998779297,-573.70001220703,22.89999961853,0,0,0},
            {463,762.09997558594,-313.39999389648,11.199999809265,0,0,326},
            {463,1103.0999755859,-594.5,104.40000152588,0,0,326},
            {463,776.5,-648.79998779297,16.5,0,0,308},
            {463,423.79998779297,-727.79998779297,23.89999961853,0,0,308},
            {463,577.57189941406,-592.48675537109,18.683336257935,0,0,90},
        },
        [2] = {
            {468,271.74731445312,-263.64929199219,1.3380999565125,0,0,354},
            {468,135.42030334473,-55.8577003479,1.3380999565125,0,0,8},
            {468,287.40930175781,7.3572998046875,2.259299993515,0,0,42},
            {468,353.095703125,-104.06079864502,1.0551999807358,0,0,42},
            {468,87.923156738281,-165.66775512695,2.59375,0,0,60},
            {468,293.4895324707,-10.986472129822,2.4481472969055,0,0,70},
        },
    },
    ["Marker"] = {
        [1] = {1116.9000244141,-314.60000610352,72.599998474121},
        [2] = {198.45280456543,-252.5677947998,-0.12189999967813},
    },
    ["QuestID"] = {
        [1] = 5,
        [2] = 9,
    },
}

local playerBlip = {}

function VehicleQuests.spawnAllVehicles()
    for ID,tbls in pairs(VehicleQuests["Coordinates"]) do
        for i,tbl in ipairs(tbls) do
            local exists = false
            for _,v in ipairs(VehicleQuests.vehicle) do
                if isElement(v) and apocalypseGetElementData(v,"VehicleQuestID") == ID and apocalypseGetElementData(v,"SpawnIndex") == i then
                    exists = true
                    break
                end
            end
            if not exists then
                VehicleQuests.spawnVehicle(ID,i)
            end
        end
    end
end

function VehicleQuests.spawnVehicle(ID,index)
    local tbl = VehicleQuests["Coordinates"][ID][index]
    if not tbl then return end

    local veh = createVehicle(tbl[1],tbl[2],tbl[3],tbl[4],tbl[5],tbl[6],tbl[7])
    setVehicleColor(veh,150,100,100)
    apocalypseSetElementData(veh,"VehicleQuestID",ID)
    apocalypseSetElementData(veh,"SpawnIndex",index)
    table.insert(VehicleQuests.vehicle,veh)

    addEventHandler("onVehicleEnter",veh,function(player)
        if isElement(playerBlip[player]) then destroyElement(playerBlip[player]) end
        local vehID = apocalypseGetElementData(source,"VehicleQuestID")
        if getPedOccupiedVehicleSeat(player) == 0 then
            local markerTbl = VehicleQuests["Marker"][vehID]
            playerBlip[player] = createBlip(markerTbl[1],markerTbl[2],markerTbl[3],53)
            setElementVisibleTo(playerBlip[player],root,false)
            setElementVisibleTo(playerBlip[player],player,true)
        end
        if VehicleQuests.respawnTimer[source] then
            killTimer(VehicleQuests.respawnTimer[source])
            VehicleQuests.respawnTimer[source] = nil
        end
    end)

    addEventHandler("onVehicleExit",veh,function(player)
		if isElement(playerBlip[player]) then destroyElement(playerBlip[player]) end
        if isElement(source) then
            if VehicleQuests.respawnTimer[source] then killTimer(VehicleQuests.respawnTimer[source]) end
            VehicleQuests.respawnTimer[source] = setTimer(function(source)
                if isElement(source) then
                    local ID = apocalypseGetElementData(source,"VehicleQuestID")
                    local index = apocalypseGetElementData(source,"SpawnIndex")
                    destroyElement(source)
                    VehicleQuests.respawnTimer[source] = nil
                    VehicleQuests.spawnVehicle(ID,index)
                end
            end,10*60*1000,1,source)
        end
    end)
	
	addEventHandler("onVehicleExplode",veh,function()
		if isElement(source) then
            if VehicleQuests.respawnTimer[source] then killTimer(VehicleQuests.respawnTimer[source]) end
            VehicleQuests.respawnTimer[source] = setTimer(function(source)
                if isElement(source) then
                    local ID = apocalypseGetElementData(source,"VehicleQuestID")
                    local index = apocalypseGetElementData(source,"SpawnIndex")
                    destroyElement(source)
                    VehicleQuests.respawnTimer[source] = nil
                    VehicleQuests.spawnVehicle(ID,index)
                end
            end,15000,1,source)
        end
	end)
end

for i,v in ipairs(VehicleQuests["Marker"]) do
    VehicleQuests.marker[i] = createMarker(v[1],v[2],v[3],"cylinder",3.5,255,255,255,25)
    apocalypseSetElementData(VehicleQuests.marker[i],"VehicleQuestID",i)
    apocalypseSetElementData(VehicleQuests.marker[i],"QuestID",VehicleQuests["QuestID"][i])

    addEventHandler("onMarkerHit",VehicleQuests.marker[i],function(player)
        if getElementType(player) == "vehicle" then
            local driver = getVehicleOccupant(player,0)
            if driver then
                local vehicle = getPedOccupiedVehicle(driver)
                local vehicleQuestID = apocalypseGetElementData(vehicle,"VehicleQuestID")
                if vehicleQuestID and vehicleQuestID == apocalypseGetElementData(source,"VehicleQuestID") then
                    VehicleQuests.finishQuest(driver,vehicleQuestID,apocalypseGetElementData(source,"QuestID"),vehicle)
                end
            end
        end
    end)
end

function VehicleQuests.finishQuest(player,ID,QuestID,vehicle)
    if ID == 1 and not hasPlayerOutfit(player,2) then
        givePlayerOutfit(player,2)
        giveKey(player,7)
        addPlayerSpawn(player,2)
        giveKey(player,1)
        Quests.finishQuest(player,QuestID)
    elseif ID == 2 and not hasPlayerSpawn(player,3) then
        addPlayerSpawn(player,3)
        Quests.finishQuest(player,QuestID)
    end
    destroyElement(vehicle)

    VehicleQuests.deliveredTimer[ID] = setTimer(function()
        local coords = VehicleQuests["Coordinates"][ID]
        for i,_ in ipairs(coords) do
            VehicleQuests.spawnVehicle(ID,i)
        end
        VehicleQuests.deliveredTimer[ID] = nil
    end,30*60*1000,1)

	local Level_Bonus_EXP = tonumber(apocalypseGetElementData(player,"level"))
	if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
	local EXP = 500 + (25 * Level_Bonus_EXP)
	local Money = 125
	local Skillpoints = 10
	if(SERVERBONUS.VEHICLE_QUESTS == true)then
		EXP = EXP * 2
		Money = Money * 2
		Skillpoints = Skillpoints * 2
	end

    giveEXP(player,EXP)
    givePlayerServerMoney(player,Money)
    givePlayerSkillpoint(player,Skillpoints)
    outputLog(getPlayerName(player).." hat "..EXP.." EXP, $"..Money.." und "..Skillpoints.." Skillpunkte erhalten (Quest ID: "..QuestID..")", "Vehicle Quest", getCharacterID(player))

    if isElement(playerBlip[player]) then destroyElement(playerBlip[player]) end
end

addEventHandler("onPlayerWasted",root,function()
    if isElement(playerBlip[source]) then
        destroyElement(playerBlip[source])
    end
end)

VehicleQuests.spawnAllVehicles()