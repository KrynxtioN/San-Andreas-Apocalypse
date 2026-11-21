PlayerSpawn = {
	["Spawns"] = {
		[0] = {687.23388671875, -445.61279296875, 16.335899353027, 0, 0, 0},
		[1] = {687.23388671875, -445.61279296875, 16.335899353027, 0, 0, 0},
		[2] = {413.54010009766,2536.7312011719,10,270,10,0},
		[3] = {194.06829833984,-228.41149902344,1.7785999774933,270,0,0},
		[4] = nil, -- Spawn here
		[5] = {-2820.1220703125,-1517.0810546875,140.84375,230,0,0},
		[6] = {419.87338256836,2541.1240234375,10,180,10,2},
		[7] = nil, -- Tent
		[8] = nil, -- Motel
	},
}

function addPlayerSpawn(player, ID)
	local ID = tonumber(ID)
	if(hasPlayerSpawn(player,ID) == false)then
		local playerSpawns = getPlayerData("characters","ID",getCharacterID(player),"spawns")
		dbExec(handler, "UPDATE characters SET spawns = '"..playerSpawns..ID.."|' WHERE ID = '"..getCharacterID(player).."'")
	end
end

function hasPlayerSpawn(player,ID)
	local ID = tonumber(ID)
	local playerSpawns = getPlayerData("characters","ID",getCharacterID(player),"spawns")
	
	if(not(playerSpawns))then
		dbExec(handler, "UPDATE characters SET spawns = '' WHERE ID = '"..getCharacterID(player).."'")
		playerSpawns = getPlayerData("characters", "ID", getCharacterID(player), "spawns")
	end
	
	local values = split(playerSpawns, "|")
	local hasSpawn = false
	
	if(playerSpawns and ID)then
		for _,v in pairs(values)do
			if(tonumber(v) == ID)then
				hasSpawn = true
				break
			end
		end
	end
	return hasSpawn
end

function removePlayerSpawn(player, ID)
    local ID = tonumber(ID)
    if(hasPlayerSpawn(player, ID)) then
        local playerSpawns = getPlayerData("characters", "ID", getCharacterID(player), "spawns")
        local values = split(playerSpawns, "|")
        local newSpawns = ""
        for _, v in pairs(values) do
            if tonumber(v) ~= ID then
                newSpawns = newSpawns .. v .. "|"
            end
        end
        dbExec(handler, "UPDATE characters SET spawns = '" .. newSpawns .. "' WHERE ID = '" .. getCharacterID(player) .. "'")
    end
end

function PlayerSpawn.spawnPlayer(player,x,y,z,int,dim)
	local CharacterID = getCharacterID(player)
    local playerModel = getPlayerData("characters", "ID", CharacterID, "model")
	if(not(playerModel))then playerModel = 0 end
    setCameraTarget(player)
    toggleAllControls(player, true)
	local spawn_id = getPlayerData("characters", "ID", CharacterID, "spawn_id")
	local spawn_shelter_id = getPlayerData("characters", "ID", CharacterID, "spawn_shelter_id")
	
	if(x and y and z and int and dim)then
		spawnPlayer(player,x,y,z,math.random(0,360),playerModel)
		setElementInterior(player,int)
		setElementDimension(player,dim)
	else
		if(spawn_shelter_id == 0)then
			if(tonumber(spawn_id) == 4 or tonumber(spawn_id) == 7)then
				local x = getPlayerData("characters","ID",CharacterID,"spawn_x")
				local y = getPlayerData("characters","ID",CharacterID,"spawn_y")
				local z = getPlayerData("characters","ID",CharacterID,"spawn_z")
				local spawn_rot = getPlayerData("characters","ID",CharacterID,"spawn_rot")
				local spawn_int = getPlayerData("characters","ID",CharacterID,"spawn_int")
				local spawn_dim = getPlayerData("characters","ID",CharacterID,"spawn_dim")
				spawnPlayer(player,x,y,z,spawn_rot,playerModel)
				setElementInterior(player,spawn_int)
				setElementDimension(player,spawn_dim)
			elseif(tonumber(spawn_id) == 8)then
				Motel.spawnPlayer(player)
			else
				spawnPlayer(player,PlayerSpawn["Spawns"][spawn_id][1],PlayerSpawn["Spawns"][spawn_id][2],PlayerSpawn["Spawns"][spawn_id][3],PlayerSpawn["Spawns"][spawn_id][4],playerModel)
				setElementInterior(player,PlayerSpawn["Spawns"][spawn_id][5])
				setElementDimension(player,PlayerSpawn["Spawns"][spawn_id][6])
			end
		else
			Shelter.spawnPlayer(player,spawn_shelter_id,playerModel)
		end
	end
	triggerClientEvent(player,"Weaponsystem.setBindKeys",player)
	triggerClientEvent(player,"bindKeyInventoryScroll",player)
	setPedStat(player,21,apocalypseGetElementData(player,"player_fat"))
	setPedStat(player,23,apocalypseGetElementData(player,"player_muscles"))
	if(apocalypseGetElementData(player,"AFK") == true)then
		setElementFrozen(player,true)
	end
end

function PlayerSpawn.giveHealth(player)
	setElementHealth(player, tonumber(getPlayerData("characters", "ID", getCharacterID(player), "health")))
	setPedArmor(player, tonumber(getPlayerData("characters", "ID", getCharacterID(player), "armor")))
end

addEvent("PlayerSpawn.getSpawns",true)
addEventHandler("PlayerSpawn.getSpawns",root,function()
	local spawns = {}
	local spawnsString = getPlayerData("characters", "ID", getCharacterID(client), "spawns")
	local values = split(spawnsString,  "|")
	
	if(spawnsString)then
		for i,  v in ipairs(values)do
			table.insert(spawns, v)
		end
		triggerClientEvent(client, "Settings.updatePlayerSpawnData", client, spawns)
	end
end)

addEvent("PlayerSpawn.set",true)
addEventHandler("PlayerSpawn.set",root,function(id)
	local id = tonumber(id)
	if(id == 8)then
		createInfobox(client,getText(client,"SMotel3"))
		return
	end
	dbExec(handler,"UPDATE characters SET spawn_id = '"..id.."', spawn_shelter_id = '0' WHERE ID = '"..getCharacterID(client).."'")
	if(id == 4 or id == 7)then
		local x,y,z = getElementPosition(client)
		local rx,ry,rz = getElementRotation(client)
		local int = getElementInterior(client)
		local dim = getElementDimension(client)
		dbExec(handler,"UPDATE characters SET spawn_x = '"..x.."', spawn_y = '"..y.."', spawn_z = '"..z.."', spawn_rot = '"..rz.."', spawn_int = '"..int.."', spawn_dim = '"..dim.."' WHERE ID = '"..getCharacterID(client).."'")
	end
	createInfobox(client,getText(client,"SSettings12"))
end)