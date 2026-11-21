Motel = {UpdateSpawnPickup = {},
	["Spawns"] = {
		{2247.0187988281,-1160.9353027344,1029.796875},
		{2236.30078125,-1158.5250244141,1029.796875},
		{2235.9370117188,-1169.8741455078,1029.796875},
		{2227.6247558594,-1182.9844970703,1029.796875},
		{2208.0212402344,-1193.9521484375,1029.796875},
		{2198.2751464844,-1174.2569580078,1029.8043212891},
		{2188.4274902344,-1155.9018554688,1029.796875},
		{2198.6037597656,-1158.1875,1029.796875},
	},
	["Pickups"] = {
		{2217.3647460938,-1146.4055175781,1025.796875,1},
	},
}

for i = 1,#Motel["Spawns"]do
	Motel.UpdateSpawnPickup[i] = createPickup(2218.400390625,-1154.5490722656,1025.796875,3,1318,50)
	setElementInterior(Motel.UpdateSpawnPickup[i],15)
	setElementDimension(Motel.UpdateSpawnPickup[i],i)
	
	addEventHandler("onPickupHit",Motel.UpdateSpawnPickup[i],function(player)
		if(getElementDimension(player) == getElementDimension(source))then
			if(apocalypseGetElementData(player,"MotelBindKey") ~= true)then
				apocalypseSetElementData(playe,"MotelBindKey",true)
				bindKey(player,"e","down",Motel.updateSpawnBind)
			end
			createInfobox(player,getText(player,"SMotel4"))
		end
	end)
end

function Motel.updateSpawnBind(player)
	if(getElementInterior(player) == 15)then
		if(getDistanceBetweenPoints3D(2218.400390625,-1154.5490722656,1025.796875,getElementPosition(player)) <= 5)then
			dbExec(handler,"UPDATE characters SET motel_dim = '"..getElementDimension(player).."' WHERE ID = '"..getCharacterID(player).."'")
			dbExec(handler,"UPDATE characters SET spawn_id = '8', spawn_shelter_id = '0' WHERE ID = '"..getCharacterID(player).."'")
			createInfobox(player,getText(player,"SSettings12"))
			unbindKey(player,"e","down",Motel.updateSpawnBind)
			apocalypseSetElementData(player,"MotelBindKey",false)
		end
	end
end

for _,v in pairs(Motel["Pickups"])do
	local pickup = createPickup(v[1],v[2],v[3],3,1239,50)
	setElementInterior(pickup,15)
	setElementDimension(pickup,v[4])
	
	addEventHandler("onPickupHit",pickup,function(player)
		if(getElementDimension(player) == getElementDimension(source))then
			local membership = tonumber(getPlayerData("characters","ID",getCharacterID(player),"motel"))
			triggerClientEvent(player,"Motel.openWindow",player,membership)
		end
	end)
end

function Motel.spawnPlayer(player)
	local motelDim = tonumber(getPlayerData("characters","ID",getCharacterID(player),"motel_dim"))
	local rnd = math.random(1,#Motel["Spawns"])
	local tbl = Motel["Spawns"][rnd]
	local x,y,z = tbl[1],tbl[2],tbl[3]
	local CharacterID = getCharacterID(player)
    local playerModel = getPlayerData("characters", "ID", CharacterID, "model")
	spawnPlayer(player,x,y,z,math.random(0,360),playerModel)
	setElementInterior(player,15)
	setElementDimension(player,motelDim)
end

addEvent("Motel.rentRoom",true)
addEventHandler("Motel.rentRoom",root,function()
	local motel = tonumber(getPlayerData("characters","ID",getCharacterID(client),"motel"))
	if(motel == 0)then
		dbExec(handler,"UPDATE characters SET motel = '1', motel_dim = '"..getElementDimension(client).."' WHERE ID = '"..getCharacterID(client).."'")
		createInfobox(client,getText(client,"SMotel1"))
		triggerClientEvent(client,"closeWindow",client)
		addPlayerSpawn(client,8)
	end
end)

addEvent("Motel.unrentRoom",true)
addEventHandler("Motel.unrentRoom",root,function()
	local motel = tonumber(getPlayerData("characters","ID",getCharacterID(client),"motel"))
	if(motel == 1)then
		dbExec(handler,"UPDATE characters SET motel = '0', motel_dim = '0' WHERE ID = '"..getCharacterID(client).."'")
		createInfobox(client,getText(client,"SMotel2"))
		triggerClientEvent(client,"closeWindow",client)
		removePlayerSpawn(client,8)
	end
end)

addEventHandler("onPlayerWasted",root,function()
	unbindKey(source,"e","down",Motel.updateSpawnBind)
	apocalypseSetElementData(source,"MotelBindKey",false)
end)