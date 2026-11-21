local Data = {"hearse_delivered","skeletons_taxi","killed_pumpkin_zombies","collected_pumpkins"}

addEvent("HalloweenQuestUI.getData",true)
addEventHandler("HalloweenQuestUI.getData",root,function()
	local tbl = {}
	for _,v in pairs(Data)do
		local d = getPlayerData("character_stats","character_id",getCharacterID(client),v)
		tbl[v] = d
	end
	triggerClientEvent(client,"HalloweenQuestUI.setData",client,tbl)
end)

addEvent("HalloweenQuestUI.claimReward",true)
addEventHandler("HalloweenQuestUI.claimReward",root,function(page)
	local page = tonumber(page)
	if(page == 1)then
		if(hasPlayerItem(client,188) == 0)then
			giveItem(client,188,1)
			createInfobox(client,getText(client,"SHalloweenQuestUI1"))
			outputLog(getPlayerName(client).." hat 'Halloween Key 1' erhalten","Halloween Event",getCharacterID(client))
		else
			createInfobox(client,getText(client,"SHalloweenQuestUI2"))
		end
	elseif(page == 2)then
		if(hasPlayerItem(client,189) == 0)then
			giveItem(client,189)
			createInfobox(client,getText(client,"SHalloweenQuestUI1"))
			outputLog(getPlayerName(client).." hat 'Halloween Key 2' erhalten","Halloween Event",getCharacterID(client))
		else
			createInfobox(client,getText(client,"SHalloweenQuestUI2"))
		end
	elseif(page == 3)then
		if(hasPlayerItem(client,190) == 0)then
			giveItem(client,190)
			createInfobox(client,getText(client,"SHalloweenQuestUI1"))
			outputLog(getPlayerName(client).." hat 'Halloween Key 3' erhalten","Halloween Event",getCharacterID(client))
		else
			createInfobox(client,getText(client,"SHalloweenQuestUI2"))
		end
	end
end)