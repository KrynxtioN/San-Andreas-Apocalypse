addEvent("ValentineQuest.startQuest",true)
addEventHandler("ValentineQuest.startQuest",root,function()
	local time = getRealTime()
	local currentTimestamp = time.timestamp

	local questTimer = tonumber(getPlayerData("character_stats", "character_id", getCharacterID(client), "valentine_quest_timer"))
	if (not questTimer) then
		questTimer = 0
	end

	if ((currentTimestamp - questTimer) >= 10800) then
		dbExec(handler, "UPDATE character_stats SET valentine_quest_timer = '" .. currentTimestamp .. "' WHERE character_id = '" .. getCharacterID(client) .. "'")
		triggerClientEvent(client,"ValentineQuest.loadQuest",client)
	else
		local timeLeft = 10800 - (currentTimestamp - questTimer)
		NPC.NormalMessage(client, getText(client, "SValentineDay16"):format(formatTimeLeft(timeLeft)))
	end
end)

addEvent("ValentineQuest.finished",true)
addEventHandler("ValentineQuest.finished",root,function()
	giveValentineItem(client,100)
	local stats = getPlayerData("character_stats","character_id",getCharacterID(client),"valentine_quest_finished")
	dbExec(handler,"UPDATE character_stats SET valentine_quest_finished = '"..stats + 1 .."' WHERE character_id = '"..getCharacterID(client).."'")
end)