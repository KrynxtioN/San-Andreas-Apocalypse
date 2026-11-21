VehicleEngineQuest.MechanicMarker = createMarker(1849.1129150391,-1856.3894042969,14.557800292969,"arrow",2,0,0,255,50)

local Achievements = {
	{1,152},
	{5,153},
	{10,154},
	{25,155},
	{50,156},
	{75,157},
	{125,158},
	{175,159},
	{250,160},
}

addEventHandler("onMarkerHit",VehicleEngineQuest.MechanicMarker,function(hitElement)
    if getElementType(hitElement) ~= "vehicle" then return end
    local player = getVehicleOccupant(hitElement,0)
    if not player then return end

    if getElementDimension(player) ~= getElementDimension(source) then return end

    if apocalypseGetElementData(hitElement,"VehicleEngineQuest") == true or apocalypseGetElementData(hitElement,"LootVehicle") == true then
        triggerClientEvent(player,"WrenchGame:start",player)
		setElementFrozen(hitElement,true)
    end
end)

addEvent("VehicleEngineQuest.giveEngine",true)
addEventHandler("VehicleEngineQuest.giveEngine",root,function()
	giveItem(client,70,1)
	giveItem(client,71,4)
	triggerClientEvent(client, "showItemBar", client, {{70,1},{71,4}})
	NPC.MeMessage(client,getText(client,"SWrenchGame1"))
	outputLog(getPlayerName(client).." hat ein Fahrzeug zerlegt", "Mechanic", getCharacterID(client))
	local vehicle = getPedOccupiedVehicle(client)
	if(vehicle and apocalypseGetElementData(vehicle,"VehicleEngineQuest") == true)then
		destroyElement(vehicle)
	end
	
	local destroyed_vehicles = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"destroyed_vehicles"))
	Characters.addStats(client,"destroyed_vehicles",destroyed_vehicles + 1)
	
	for _,v in pairs(Achievements)do
		if(destroyed_vehicles + 1 >= v[1])then
			setAchievement(client,v[2])
		end
	end
end)