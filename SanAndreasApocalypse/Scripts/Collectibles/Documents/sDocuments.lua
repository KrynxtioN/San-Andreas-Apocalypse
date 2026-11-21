function setDocument(player, ID)
	local ID = tonumber(ID)
	if(not ID) then return end

	local playerDocuments = getPlayerData("characters", "ID", getCharacterID(player), "documents") or ""

	if(hasPlayerDocument(player, ID) == false)then
		local Table = Documents["Documents"][apocalypseGetElementData(player, "language") or "EN"][ID]
		dbExec(handler, "UPDATE characters SET documents = '"..playerDocuments..ID.."|' WHERE ID = '"..getCharacterID(player).."'")
		local name = Documents["Documents"][apocalypseGetElementData(player, "language") or "EN"][ID][1]
		triggerClientEvent(player,"Achievements.reached",player,name,{150,75},"Document")
		Documents.setAchievements(player)
		triggerClientEvent(player,"Documents.destroyHelpMarker",player,ID)

		if(ID == 5)then
			addPlayerCraftingRecipe(player, 6)
		end
		if(ID == 6)then
			addPlayerCraftingRecipe(player, 7)
		end
		if(ID == 9)then
			giveRadioData(player, 9)
		end
		giveEXP(player,500)
		givePlayerSkillpoint(player,5)
		outputLog(getPlayerName(player).." hat Dokument "..ID.." bekommen", "Dokumente", getCharacterID(player))

		if(hasPlayerDocument(player,4) == true and hasPlayerDocument(player,5) == true and hasPlayerDocument(player,6) == true)then
			giveRadioData(player,18)
		end
	end
end

function hasPlayerDocument(player, ID)
	local playerDocuments = getPlayerData("characters", "ID", getCharacterID(player), "documents")
	
	if(not(playerDocuments)) then
		dbExec(handler, "UPDATE characters SET documents = '' WHERE ID = '"..getCharacterID(player).."'")
		playerDocuments = getPlayerData("characters", "ID", getCharacterID(player), "documents")
	end
	
	local values = split(playerDocuments, "|")
	local hasDocument = false

	if(playerDocuments and ID) then
		ID = tonumber(ID)
		for _, v in pairs(values) do
			local documentID = tonumber(v)
			if(documentID == ID) then
				hasDocument = true
				break
			end
		end
	end
	return hasDocument
end

addEvent("Documents.getData", true)
addEventHandler("Documents.getData", root, function()
    local Data = {}
    local language = apocalypseGetElementData(client, "language") or "EN"
    local documentsTable = Documents["Documents"][language]

    local owned = {}
    local playerDocuments = getPlayerData("characters", "ID", getCharacterID(client), "documents")

    if playerDocuments and playerDocuments ~= "" then
        local values = split(playerDocuments, "|")
        for _, v in ipairs(values) do
            local id = tonumber(v)
            if id then
                owned[id] = true
            end
        end
    end

    for documentID, Table in pairs(documentsTable) do
        if Table then
            table.insert(Data, {
                id = documentID,
                name = Table[1],
                description = Table[2],
                unlocked = owned[documentID] or false
            })
        end
    end

    triggerClientEvent(client, "Collectibles.updateData", client, Data)
end)

function Documents.setAchievements(player)
	local playerDocuments = getPlayerData("characters", "ID", getCharacterID(player), "documents")
	local amount = 0
	
	if(playerDocuments)then
		local values = split(playerDocuments, "|")
		
		for _,v in pairs(values)do
			if(v ~= "")then
				amount = amount + 1
			end
		end
	end
	
	if(amount >= 1)then setAchievement(player, 2) end
	if(amount >= 5)then setAchievement(player, 38) end
	if(amount >= 10)then setAchievement(player, 39) end
end

function Documents.createObjects()
	for _, v in pairs(Documents["Objects"])do
		local object = createObject(v[1], v[2], v[3], v[4], v[5], v[6], v[7])
		setElementInterior(object, v[8])
		setElementDimension(object, v[9])
		if(v[1] == 3016 or v[1] == 1347)then
			setElementAlpha(object, 0)
		end
		apocalypseSetElementData(object, "DocumentID", tonumber(v[10]))
	end
end
Documents.createObjects()

function Documents.createHelpMarker(player)
	for _,v in pairs(Documents["Objects"])do
		if(v[1] == 2894)then
			local docID = tonumber(v[10])
			if(docID and hasPlayerDocument(player, docID) == false)then
				triggerClientEvent(player,"Documents.createHelpMarker",player,docID,v[2],v[3],v[4],v[8],v[9])
			end
		end
	end
end

addEventHandler("onPlayerClick", root, function(button, state, clickedElement)
	if(button == "left" and state == "down" and clickedElement)then
		local ID = tonumber(apocalypseGetElementData(clickedElement, "DocumentID"))
		if(ID)then
			if(apocalypseGetElementData(source, "tutorialtask") >= 2)then
				setDocument(source, ID)
				if(apocalypseGetElementData(source, "tutorialtask") == 2)then
					createInfobox(source, getText(source, "SDocuments2"))
					Tutorial.nextTask(source)
				end
			end
		end
	end
end)