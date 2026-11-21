Graveyard = {Marker = {},
	["FlowerMarker"] = {
		{1,838.52770996094,-1096.4592285156,23.278999328613,2},
		{2,843.35571289062,-1097.1334228516,23.246900558472,2},
		
		{3,848.61499023438,-1096.720703125,23.329000473022,2},
		{4,857.67102050781,-1096.9196777344,23.329000473022,2},
		{5,866.13031005859,-1096.9284667969,23.371900558472,2},
		{6,870.94592285156,-1096.9617919922,23.396900177002,2},
		{7,874.77868652344,-1096.5234375,23.304000854492,2},
	},
}

local InformationPickup = createPickup(823.64001464844,-1108.4697265625,25.7890625,3,1239,50)

addEventHandler("onPickupHit",InformationPickup,function(player)
	if(getElementType(player) == "player")then
		if(getElementDimension(player) == getElementDimension(source))then
			if(getElementInterior(player) == getElementInterior(source))then
				if(not(isPedInVehicle(player)))then
					triggerClientEvent(player,"JobInformation.createWindow",player,7)
				end
			end
		end
	end
end)

for _,v in pairs(Graveyard["FlowerMarker"])do
    local ID = v[1]
    Graveyard.Marker[ID] = createMarker(v[2],v[3],v[4],"cylinder",2,0,0,0,0)
    setElementData(Graveyard.Marker[ID],"GraveyardFlowerID",ID)
	local Pickup = createPickup(v[2],v[3],v[4]+1,3,1318,50)
    
    addEventHandler("onMarkerHit", Graveyard.Marker[ID], function(player)
        if getElementType(player) ~= "player" then return end
        if isPedInVehicle(player) then return end
        if getElementDimension(player) ~= getElementDimension(source) then return end
		
		if(apocalypseGetElementData(player,"GraveyardWaterKey") ~= true)then
			bindKey(player, "e", "down", Graveyard.addWater)
			apocalypseSetElementData(player,"GraveyardWaterKey",true)
		end
    end)
end

function Graveyard.addWater(player)
	if(hasPlayerItem(player,191) >= 1)then
		if getElementData(player,"GraveyardWatering") then return end
		
		unbindKey(player, "e", "down", Graveyard.addWater)
		apocalypseSetElementData(player,"GraveyardWaterKey",false)

		local marker = nil
		for _,v in pairs(Graveyard.Marker) do
			if isElementWithinMarker(player,v) then
				marker = v
				break
			end
		end
		if not marker then return end

		local id = getElementData(marker,"GraveyardFlowerID")
		local watered = Graveyard.getFlowerStatus(player,id)
		if watered >= 100 then
			NPC.MeMessage(player,getText(player,"SGraveyard1"))
			return
		end

		setElementData(player,"GraveyardWatering",true)
		Graveyard.setFlowerStatus(getCharacterID(player),id,100)

		toggleAllControls(player,false)
		setElementFrozen(player,true)
		setPedAnimation(player,"bomber","BOM_Plant_Loop")

		setTimer(function(player,id,watered)
			if(isElement(player))then
				setPedAnimation(player)
				toggleAllControls(player,true)
				setElementFrozen(player,false)
				setElementData(player,"GraveyardWatering",false)

				if(DailyTasks.playerTasks[player][21])then
					DailyTasks.updateProgress(player,21,DailyTasks.playerTasks[player][21].progress+1)
				end
				if(WeeklyTasks.playerTasks[player][21])then
					WeeklyTasks.updateProgress(player,21,WeeklyTasks.playerTasks[player][21].progress+1)
				end

				NPC.MeMessage(player,getText(player,"SGraveyard2"))

				if(watered == 0)then
					triggerClientEvent(player,"Graveyard.moveFlower",player,id)
				end
				triggerClientEvent(player,"Graveyard.updateFlowerStatus",player,{[id]=100})
			end
		end,2500,1,player,id,watered)
	else
		NPC.MeMessage(player,getText(player,"SGraveyard3"))
	end
end

function Graveyard.initPlayerFlowersDB(player)
    local characterID = getCharacterID(player)
    local flowerString = getPlayerData("character_stats","character_id",characterID,"flowers") or ""
    local flowerTable = {}

    for pair in string.gmatch(flowerString,"[^|]+") do
        local id,state,decay = pair:match("(%d+),(%d+),?(%d*)")
        if id and state then
            flowerTable[tonumber(id)] = {tonumber(state),tonumber(decay) or 5}
        end
    end

    for _,v in ipairs(Graveyard["FlowerMarker"]) do
        local id = v[1]
        if not flowerTable[id] then
            flowerTable[id] = {0,5}
        end
    end

    local resultTable = {}
    for id,data in pairs(flowerTable) do
        table.insert(resultTable,id..","..data[1]..","..data[2])
    end
    local newFlowerString = table.concat(resultTable,"|")
    dbExec(handler,"UPDATE character_stats SET flowers=? WHERE character_id=?",newFlowerString,characterID)

    Graveyard.triggerWateredFlowers(player)
end

function Graveyard.getFlowerStatus(player,id)
    local flowerString = getPlayerData("character_stats","character_id",getCharacterID(player),"flowers") or ""
    for pair in string.gmatch(flowerString,"[^|]+") do
        local fid,state = pair:match("(%d+),(%d+)")
        if tonumber(fid)==tonumber(id) then return tonumber(state) end
    end
    return 0
end

function Graveyard.setFlowerStatus(characterID,id,newState,newDecay)
    if not characterID then return end
    local flowerString = getPlayerData("character_stats","character_id",characterID,"flowers") or ""
    local flowerTable,found = {},false

    for pair in string.gmatch(flowerString,"[^|]+") do
        local fid,state,decay = pair:match("(%d+),(%d+),?(%d*)")
        if fid and state then
            fid = tonumber(fid)
            state = tonumber(state)
            decay = tonumber(decay) or 5
            if fid == tonumber(id) then
                table.insert(flowerTable,fid..","..newState..","..(newDecay or decay))
                found = true
            else
                table.insert(flowerTable,fid..","..state..","..decay)
            end
        end
    end
    if not found then
        table.insert(flowerTable,tonumber(id)..","..newState..","..(newDecay or 5))
    end

    local newString = table.concat(flowerTable,"|")
    dbExec(handler,"UPDATE character_stats SET flowers=? WHERE character_id=?",newString,characterID)
end
addEvent("Graveyard.setFlowerStatus",true)
addEventHandler("Graveyard.setFlowerStatus",root,Graveyard.setFlowerStatus)

function Graveyard.triggerWateredFlowers(player)
    local characterID = getCharacterID(player)
    if not characterID then return end
    local flowerString = getPlayerData("character_stats","character_id",characterID,"flowers") or ""

    local statusTable = {}
    for pair in string.gmatch(flowerString,"[^|]+") do
        local id,state = pair:match("(%d+),(%d+)")
        if id and state and tonumber(state)>=1 then
            table.insert(statusTable,{tonumber(id),tonumber(state)})
        end
    end

    for _,v in ipairs(statusTable) do
        triggerClientEvent(player,"Graveyard.moveFlower",player,v[1])
    end

    local tbl = {}
    for _,v in ipairs(statusTable) do tbl[v[1]]=v[2] end
    triggerClientEvent(player,"Graveyard.updateFlowerStatus",player,tbl)
end

function Graveyard.tickWaterLevels()
    for _,player in ipairs(getElementsByType("player")) do
        local characterID = getCharacterID(player)
        if not characterID then return end

        local flowerString = getPlayerData("character_stats","character_id",characterID,"flowers") or ""
        local flowerTable,changed = {},false

        for pair in string.gmatch(flowerString,"[^|]+") do
            local id,state,decay = pair:match("(%d+),(%d+),?(%d*)")
            id = tonumber(id)
            state = tonumber(state)
            decay = tonumber(decay) or 5

            if state > 0 then
                local expGain = 5
                local old_flowerexp = getPlayerData("character_stats","character_id",characterID,"flower_exp")
				dbExec(handler,"UPDATE character_stats SET flower_exp = '"..old_flowerexp + expGain .."' WHERE character_id = '"..characterID.."'")

                state = math.max(0,state-decay)
                changed = true

                if state == 0 then
                    triggerClientEvent(player,"Graveyard.moveFlowerDown",player,id)
                    triggerClientEvent(player,"Graveyard.updateFlowerStatus",player,{[id]=0})
                else
                    triggerClientEvent(player,"Graveyard.updateFlowerStatus",player,{[id]=state})
                end
            end

            flowerTable[id] = {state,decay}
        end

        if changed then
            local resultTable = {}
            for fid,v in pairs(flowerTable) do
                table.insert(resultTable,fid..","..v[1]..","..v[2])
            end
            local newString = table.concat(resultTable,"|")
            dbExec(handler,"UPDATE character_stats SET flowers=? WHERE character_id=?",newString,characterID)
        end
    end
end
setTimer(Graveyard.tickWaterLevels,30000,0)