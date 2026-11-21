function givePlayerPhoto(player, ID)
	local ID = tonumber(ID)
	if(hasPlayerPhoto(player, ID) == false)then
		local playerPhotos = getPlayerData("characters", "ID", getCharacterID(player), "photos")
		dbExec(handler, "UPDATE characters SET photos = '"..playerPhotos..ID.."|' WHERE ID = '"..getCharacterID(player).."'")
		triggerClientEvent(player,"Photos.showPhoto",player,ID)
		setAchievement(player,71)
		outputLog(getPlayerName(player).." hat ein Foto bekommen (ID: "..ID..")", "Photo", getCharacterID(player))
	end
end
addEvent("givePlayerPhoto",true)
addEventHandler("givePlayerPhoto",root,givePlayerPhoto)

function hasPlayerPhoto(player, ID)
	local playerPhotos = getPlayerData("characters", "ID", getCharacterID(player), "photos")
	
	if(not(playerPhotos))then
		dbExec(handler, "UPDATE characters SET photos = '' WHERE ID = '"..getCharacterID(player).."'")
		playerPhotos = getPlayerData("characters", "ID", getCharacterID(player), "photos")
	end
	
	local values = split(playerPhotos, "|")
	local hasPhoto = false

	if(playerPhotos and ID) then
		local ID = tonumber(ID)
		for _, v in pairs(values) do
			local cameraID = tonumber(v)
			if(cameraID == ID) then
				hasPhoto = true
				break
			end
		end
	end
	return hasPhoto
end

addEvent("Photos.getData", true)
addEventHandler("Photos.getData", root, function()
    local Data = {}
    local language = apocalypseGetElementData(client, "language") or "EN"
    local photosTable = Photos["Data"][language]

    local owned = {}
    local playerPhotos = getPlayerData("characters", "ID", getCharacterID(client), "photos")

    if playerPhotos and playerPhotos ~= "" then
        local values = split(playerPhotos, "|")
        for _, v in ipairs(values) do
            local id = tonumber(v)
            if id then
                owned[id] = true
            end
        end
    end

    for photoID, Table in pairs(photosTable) do
        if Table then
            table.insert(Data, {
                id = photoID,
                name = Table[1],
                description = Table[2],
                image = Table[3],
                unlocked = owned[photoID] or false
            })
        end
    end

    triggerClientEvent(client, "Collectibles.updateData", client, Data)
end)