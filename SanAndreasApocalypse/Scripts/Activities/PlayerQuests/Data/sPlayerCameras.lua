function givePlayerCamera(player, ID)
	local ID = tonumber(ID)
	if(hasPlayerCamera(player, ID) == false)then
		local playerCameras = getPlayerData("characters", "ID", getCharacterID(player), "player_cameras")
		dbExec(handler, "UPDATE characters SET player_cameras = '"..playerCameras..ID.."|' WHERE ID = '"..getCharacterID(player).."'")
		giveItem(player,25,1)
		triggerClientEvent(player, "showItemBar", player, {{25,1}})
		giveEXP(player,25)
		outputLog(getPlayerName(player).." hat eine Kamera eingesammelt", "Camera", getCharacterID(player))
	end
end
addEvent("givePlayerCamera",true)
addEventHandler("givePlayerCamera",root,givePlayerCamera)

function hasPlayerCamera(player, ID)
	local playerCameras = getPlayerData("characters", "ID", getCharacterID(player), "player_cameras")
	
	if(not(playerCameras))then
		dbExec(handler, "UPDATE characters SET player_cameras = '' WHERE ID = '"..getCharacterID(player).."'")
		playerCameras = getPlayerData("characters", "ID", getCharacterID(player), "player_cameras")
	end
	
	local values = split(playerCameras, "|")
	local hasCamera = false

	if(playerCameras and ID) then
		ID = tonumber(ID)
		for _, v in pairs(values) do
			local cameraID = tonumber(v)
			if(cameraID == ID) then
				hasCamera = true
				break
			end
		end
	end
	return hasCamera
end