function QuestSeries.giveQuest(player, ID)
    if(player and ID)then
        local ID = tonumber(ID)
        if(QuestSeries["QuestData"][ID])then
            local oldQuests = getPlayerData("player_questseries", "character_id", getCharacterID(player), "questseries_id")
			if(oldQuests)then
				if(string.find(oldQuests, "^" .. ID .. "|") or string.find(oldQuests, "|" .. ID .. "|")) then
					return
				end
			else
				dbExec(handler,"INSERT INTO player_questseries (character_id) VALUES ('"..getCharacterID(player).."')")
				oldQuests = ""
			end
            local newQuests = oldQuests .. ID .. "|"
            dbExec(handler, "UPDATE player_questseries SET questseries_id = ? WHERE character_id = ?", newQuests, getCharacterID(player))

            for i = 1, #QuestSeries["QuestData"][ID]["Stages"] do
                dbExec(handler, "INSERT INTO questseries (character_id, questseries_id, stage, stage_progress) VALUES (?, ?, ?, ?)", getCharacterID(player), ID, i, 0)
            end
        end
    end
end

function QuestSeries.updateProgress(player, ID, Stage, NewProgress)
	if(player and ID and Stage and NewProgress)then
		local ID = tonumber(ID)
		if(QuestSeries["QuestData"][ID])then
			dbExec(handler,"UPDATE questseries SET stage_progress = '"..NewProgress.."' WHERE character_id = '"..getCharacterID(player).."' AND stage = '"..Stage.."' AND questseries_id = '"..ID.."'")
		end
	end
end

local function splitString(input, separator)
    local result = {}
    for match in (input .. separator):gmatch("(.-)" .. separator) do
        table.insert(result, match)
    end
    return result
end

function QuestSeries.getData()
	local result = dbPoll(dbQuery(handler, "SELECT * FROM player_questseries WHERE character_id = '"..getCharacterID(client).."'" ), -1)
	local tbl = {}
	if (#result >= 1) then
		for _, v in pairs(result) do
			local questIDs = splitString(v["questseries_id"], "|")
			for _, questID in ipairs(questIDs) do
				local questTitle = QuestSeries["QuestData"][tonumber(questID)] and QuestSeries["QuestData"][tonumber(questID)].Title[apocalypseGetElementData(client, "language") or "EN"]
				if(questTitle)then
					table.insert(tbl, {tonumber(questID), questTitle})
				end
			end
		end
	end
    triggerClientEvent(client, "QuestSeries.updateData", client, tbl)
end
addEvent("QuestSeries.getData",true)
addEventHandler("QuestSeries.getData",root,QuestSeries.getData)

function QuestSeries.getStageProgress(player,questid,stage)
	if(not(player))then player = client end
	local questid,stage = tonumber(questid),tonumber(stage)
	local result = dbPoll(dbQuery(handler,"SELECT * FROM questseries WHERE character_id = '"..getCharacterID(client).."' AND questseries_id = '"..questid.."' AND stage = '"..stage.."'"),-1)
	if(result and #result > 0)then
		local progress = result[1].stage_progress
		local item = QuestSeries["QuestData"][questid]["Stages"][stage].item
		local itemRequired = QuestSeries["QuestData"][questid]["Stages"][stage].required
		triggerClientEvent(client,"QuestSeries.updateQuestProgress",client,progress,ItemInfos["items"][apocalypseGetElementData(client,"language") or "EN"][tonumber(item)],itemRequired)
	end
end
addEvent("QuestSeries.getStageProgress",true)
addEventHandler("QuestSeries.getStageProgress",root,QuestSeries.getStageProgress)

addEvent("QuestSeries.updateStageProgress",true)
addEventHandler("QuestSeries.updateStageProgress",root,function(questid,stage,item_amount)
	local amount = nil
	local questid,stage = tonumber(questid),tonumber(stage)
	local result = dbPoll(dbQuery(handler,"SELECT * FROM questseries WHERE character_id = '"..getCharacterID(client).."' AND questseries_id = '"..questid.."' AND stage = '"..stage.."'"),-1)
	if(result and #result > 0)then
		local progress = tonumber(result[1].stage_progress)
		if(progress < tonumber(QuestSeries["QuestData"][questid]["Stages"][stage].required))then
			if(not(item_amount))then
				amount = tonumber(QuestSeries["QuestData"][questid]["Stages"][stage].required) - progress
			else
				amount = tonumber(item_amount)
			end
			local newProgress = nil
			newProgress = progress + amount
			local itemID = QuestSeries["QuestData"][questid]["Stages"][stage].item
			if(hasPlayerItem(client,itemID) >= amount)then
				if(newProgress <= tonumber(QuestSeries["QuestData"][questid]["Stages"][stage].required))then
					takeItem(client,itemID,amount)
					dbExec(handler,"UPDATE questseries SET stage_progress = '"..newProgress.."' WHERE character_id = '"..getCharacterID(client).."' AND stage = '"..stage.."' AND questseries_id = '"..questid.."'")
					if(newProgress >= tonumber(QuestSeries["QuestData"][questid]["Stages"][stage].required))then
						local experience = QuestSeries["QuestRewards"][questid]["Stages"][stage].experience
						local money = QuestSeries["QuestRewards"][questid]["Stages"][stage].money
						local skillpoints = QuestSeries["QuestRewards"][questid]["Stages"][stage].skillpoints
						if(#QuestSeries["QuestRewards"][questid]["Stages"][stage].items >= 1)then
							for _,v in pairs(QuestSeries["QuestRewards"][questid]["Stages"][stage].items)do
								giveItem(client,v[1],v[2])
							end
						end
						giveEXP(client,experience)
						givePlayerServerMoney(client,money)
						givePlayerSkillpoint(client,skillpoints)
						createInfobox(client,getText(client,"SQuestSeries3"))
						outputLog(getPlayerName(client).." hat "..experience.." EXP, $"..money.." und "..skillpoints.." Skillpunkte durch eine Quest Serie erhalten (ID: "..questid..")", "Quest Series", getCharacterID(client))
					end
					QuestSeries.getStageProgress(client,questid,stage)
				else
					createInfobox(client,getText(client,"SQuestSeries4"))
				end
			else
				createInfobox(client,getText(client,"SQuestSeries2"))
			end
		else
			createInfobox(client,getText(client,"SQuestSeries1"))
		end
	end
end)

function getQuestSeriesProgress(player,ID,stage)
	local ID = tonumber(ID)
	local stage = tonumber(stage)
	if(QuestSeries["QuestData"][ID])then
		local result = dbPoll(dbQuery(handler,"SELECT * FROM questseries WHERE character_id = '"..getCharacterID(player).."' AND questseries_id = '"..ID.."' AND stage = '"..stage.."'"),-1)
		if(result and #result >= 1)then
			return tonumber(result[1].stage_progress)
		end
	end
end

addEvent("QuestSeries.openWindow",true)
addEventHandler("QuestSeries.openWindow",root,function()
	if(tonumber(apocalypseGetElementData(client,"level")) >= 10)then
		local result = dbPoll(dbQuery(handler, "SELECT * FROM player_questseries WHERE character_id = '"..getCharacterID(client).."'" ), -1)
		if(result and #result >= 1)then
			triggerClientEvent(client,"QuestSeries.createWindow",client)
		end
	end
end)