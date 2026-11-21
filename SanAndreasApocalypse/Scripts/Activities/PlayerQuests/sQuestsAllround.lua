local function isMainQuest(ID)
	local ID = tonumber(ID)
	local status = false
	for _,v in pairs(MainQuests)do
		if(tonumber(v) == ID)then
			status = true
			break
		end
	end
	return status
end

function setQuest(player, ID)
	if(apocalypseGetElementData(player,"tutorialtask") >= 8)then
		local playerID = getCharacterID(player)
		local playerQuests = getPlayerData("characters", "ID", playerID, "playerquests")

		if(not(playerQuests))then
			dbExec(handler, "UPDATE characters SET playerquests = '' WHERE ID = ?", playerID)
			playerQuests = getPlayerData("characters", "ID", playerID, "playerquests")
		end
		
		local values = split(playerQuests, "|")
		local hasQuest = false
		
		if playerQuests and ID then
			for _, v in pairs(values) do
				local questData = split(v, ",")
				local questID = tonumber(questData[1])
				if(questID == tonumber(ID))then
					hasQuest = true
					break
				end
			end
		end

		if(hasQuest == false)then
			local newQuestData = ID .. ",1"
			local updatedQuests = (playerQuests == "" and newQuestData or playerQuests .. "|" .. newQuestData)
			
			local currentTime = getRealTime().timestamp
			dbExec(handler,"UPDATE characters SET standardquest_timer = '"..currentTime + 600 .."' WHERE ID = '"..getCharacterID(player).."'")

			dbExec(handler, "UPDATE characters SET playerquests = ? WHERE ID = ?", updatedQuests, playerID)
			triggerClientEvent(player, "showQuestAccepted", player, getText(player,"SQuests7"), ID)
			setAchievement(player,48)
			
			if(ID == 34)then triggerClientEvent(player,"Alcohol_Quest.startQuest",player) end
		end
	end
end

function getQuest(player, ID)
    local playerID = getCharacterID(player)
    local playerQuests = getPlayerData("characters", "ID", playerID, "playerquests")

    if not playerQuests or playerQuests == "" then
        return false
    end

    local values = split(playerQuests, "|")
    
    for _, v in pairs(values) do
        local questData = split(v, ",")
        local questID = tonumber(questData[1])
        local questLevel = tonumber(questData[2])

        if questID == tonumber(ID) then
            return questLevel
        end
    end

    return false
end

function Quests.getPlayerQuests(player)
    if(not(player))then player = client end
    local playerQuests = {}
    local characterID = getCharacterID(player)
    local playerQuestsDatabase = getPlayerData("characters", "ID", characterID, "playerquests")
    
    if(not(playerQuestsDatabase))then
        dbExec(handler, "UPDATE characters SET playerquests = '' WHERE ID = '" .. characterID .. "'")
        playerQuestsDatabase = getPlayerData("characters", "ID", characterID, "playerquests")
    end

    if(playerQuestsDatabase and playerQuestsDatabase ~= "")then
        local values = split(playerQuestsDatabase, "|")
        for _, v in pairs(values) do
            if(v and v ~= "")then
                local questPlayerData = split(v, ",")
                if(questPlayerData[1] and questPlayerData[2])then
                    local questID = tonumber(questPlayerData[1])
                    local questLevel = tonumber(questPlayerData[2])
                    
                    if(questID and questLevel)then
                        local reward = Quests["Rewards"][questID]
                        if(reward)then
                            table.insert(playerQuests, {id = questID, level = questLevel, maxLevel = reward.maxLevel})
                        end
                    end
                end
            end
        end
    end

    if(#playerQuests >= 1)then
        triggerClientEvent(player, "Quests.updateClientData", player, playerQuests)
    end
end
addEvent("Quests.getPlayerQuests", true)
addEventHandler("Quests.getPlayerQuests", root, Quests.getPlayerQuests)

addEvent("Quests.checkRequirements",true)
addEventHandler("Quests.checkRequirements",root,function(id)
	local id = tonumber(id)
	if(isMainQuest(id) == true)then
		createInfobox(client,getText(client,"SQuests6"))
	else
		if(isCharacterLoggedIn(client))then
			local hasRequirements = false
			if(id == 1)then
				if(hasPlayerItem(client, 2) >= 25)then
					takeItem(client,2,25)
					giveItem(client,19,1)
					triggerClientEvent(client, "showItemBar", client, {{19,1}})
					hasRequirements = true
				else createInfobox(client,getText(client,"SQuests1"))end
			elseif(id == 2)then
				if(hasPlayerItem(client,6) >= 5 and hasPlayerItem(client,7) >= 5)then
					takeItem(client,6,5)
					takeItem(client,7,5)
					giveItem(client,8,1)
					triggerClientEvent(client, "showItemBar", client, {{8,1}})
					hasRequirements = true
				else createInfobox(client,getText(client,"SQuests2"))end
			elseif(id == 3)then
				if(hasPlayerItem(client,27) >= 25)then
					takeItem(client,27,25)
					giveItem(client,1,10)
					triggerClientEvent(client, "showItemBar", client, {{27,1}})
					hasRequirements = true
				else createInfobox(client,getText(client,"SQuests5"))end
			elseif(id == 32)then
				local allTower = false
				local amount = 0
				for i = 1,24 do
					if(RadioTower.hasTower(client,i) == true)then
						amount = amount + 1
					end
				end
				if(amount >= 24)then allTower = true end
				if(allTower == true)then
					hasRequirements = true
				else createInfobox(client,getText(client,"SQuests10"))end
			elseif(id == 33)then
				if(hasPlayerItem(client,26) >= 4)then
					takeItem(client,26,4)
					hasRequirements = true
				else createInfobox(client,getText(client,"SQuests11"))end
			elseif(id >= 38 and id <= 178)then
				if(hasPlayerItem(client,Quests["Rewards"][id].itemID) >= Quests["Rewards"][id].itemAmount)then
					takeItem(client,Quests["Rewards"][id].itemID,Quests["Rewards"][id].itemAmount)
					hasRequirements = true
				else createInfobox(client,getText(client,"SQuests12"))end
			end
			if(hasRequirements == true)then
				Quests.finishQuest(client,id)
			end
		end
	end
end)

function Quests.finishQuest(player,id)
    local id = tonumber(id)
	if(Quests["Rewards"][id])then
		local playerQuestsDatabase = getPlayerData("characters", "ID", getCharacterID(player), "playerquests")
		if(not(playerQuestsDatabase))then return end

		local values = split(playerQuestsDatabase, "|")
		local updatedQuests = {}

		for _, v in pairs(values) do
			local questData = split(v, ",")
			local questID = tonumber(questData[1])
			local questLevel = tonumber(questData[2])

			if(questID == id)then
				questLevel = questLevel + 1
			end
			table.insert(updatedQuests, questID..","..questLevel)
		end

		local newQuestsData = table.concat(updatedQuests, "|")
		dbExec(handler, "UPDATE characters SET playerquests = ? WHERE ID = ?", newQuestsData, getCharacterID(player))
		givePlayerServerMoney(player,Quests["Rewards"][id].questMoney)
		giveEXP(player,Quests["Rewards"][id].questEXP)
		Quests.getPlayerQuests(player)
		giveItem(player,1,Quests["Rewards"][id].brainmass)
		setAchievement(player,49)
		triggerClientEvent(player,"showQuestAccepted",player,getText(player,"SQuests9"),id)
		outputLog(getPlayerName(player).." hat eine Quest abgeschlossen (Quest ID: "..id..")", "Quests", getCharacterID(player))
		
		Characters.addStats(player,"finished_quest",getPlayerData("character_stats","character_id",getCharacterID(player),"finished_quest")+1)
		
		if(StandardQuests[id])then
			removeQuest(player,id)
		end
	end
end

function removeQuest(player, ID)
    local playerID = getCharacterID(player)
    local playerQuests = getPlayerData("characters", "ID", playerID, "playerquests")

    if not playerQuests or playerQuests == "" then
        return false
    end

    local values = split(playerQuests, "|")
    local updatedQuests = {}

    for _, v in pairs(values) do
        local questData = split(v, ",")
        local questID = tonumber(questData[1])

        if questID ~= tonumber(ID) then
            table.insert(updatedQuests, table.concat(questData, ","))
        end
    end

    local newQuestsData = table.concat(updatedQuests, "|")
    dbExec(handler, "UPDATE characters SET playerquests = ? WHERE ID = ?", newQuestsData, playerID)

    Quests.getPlayerQuests(player)
    return true
end

function Quests.givePlayerRandomStandardQuest(player)
	if(not(player))then player = client end
	
	if(tonumber(apocalypseGetElementData(player,"level")) >= 5)then
		local questID = StandardQuestsList[math.random(1, #StandardQuestsList)]
		local standardquest_timer = tonumber(getPlayerData("characters","ID",getCharacterID(player),"standardquest_timer"))
		if(standardquest_timer == 0 or getRealTime().timestamp > standardquest_timer)then
			setQuest(player,questID)
		end
	end
end
addEvent("Quests.givePlayerRandomStandardQuest",true)
addEventHandler("Quests.givePlayerRandomStandardQuest",root,Quests.givePlayerRandomStandardQuest)