MissionTerminal = {}

MissionTerminal.Config = {
	standardQuestPrice = 250,
	standardQuestMinLevel = 5,
}

MissionTerminal.ColonyMissions = {
	["find_chickens"] = {
		minLevel = 1,
		name = {
			EN = "Find 5 chickens",
			DE = "5 Hühner finden",
			RU = "Найти 5 кур",
			PT = "Encontrar 5 galinhas",
		},
		description = {
			EN = "Find and collect 5 escaped chickens for your colony. Progress is shared by all members of the colony.",
			DE = "Finde und sammle 5 entkommene Hühner für deine Kolonie. Der Fortschritt wird mit allen Mitgliedern der Kolonie geteilt.",
			RU = "Найдите и соберите 5 сбежавших кур для своей колонии. Прогресс общий для всех участников колонии.",
			PT = "Encontre e colete 5 galinhas fugitivas para sua colônia. O progresso é compartilhado por todos os membros da colônia.",
		},
		rewards = {
			EN = "Money: $5000",
			DE = "Geld: $5000",
			RU = "Деньги: $5000",
			PT = "Dinheiro: $5000",
		},
		info = {
			EN = "This mission is accepted for the entire colony.",
			DE = "Diese Mission wird für die gesamte Kolonie angenommen.",
			RU = "Эта миссия принимается для всей колонии.",
			PT = "Esta missão é aceita para toda a colônia.",
		},
	},
}

MissionTerminal.ColonyTexts = {
	EN = { noColony = "You are not in a colony.", alreadyActive = "This colony mission is already active.", accepted = "Colony mission accepted.", error = "The colony mission could not be started." },
	DE = { noColony = "Du bist in keiner Kolonie.", alreadyActive = "Diese Kolonie-Mission ist bereits aktiv.", accepted = "Kolonie-Mission angenommen.", error = "Die Kolonie-Mission konnte nicht gestartet werden." },
	RU = { noColony = "Вы не состоите в колонии.", alreadyActive = "Эта миссия колонии уже активна.", accepted = "Миссия колонии принята.", error = "Не удалось запустить миссию колонии." },
	PT = { noColony = "Você não está em uma colônia.", alreadyActive = "Esta missão da colônia já está ativa.", accepted = "Missão da colônia aceita.", error = "Não foi possível iniciar a missão da colônia." },
}

MissionTerminal.StandardQuestFallback = {1,2,3,33,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178}

MissionTerminal.QuestSeriesLevels = {
	[1] = 10, [2] = 15, [3] = 20, [4] = 25, [5] = 30,
	[6] = 35, [7] = 40, [8] = 45, [9] = 50, [10] = 55,
	[11] = 60, [12] = 65, [13] = 70, [14] = 75, [15] = 80,
	[16] = 85, [17] = 90, [18] = 95, [19] = 100, [20] = 105,
	[21] = 110, [22] = 115, [23] = 120, [24] = 125, [25] = 130,
	[26] = 135, [27] = 140, [28] = 145, [29] = 150, [30] = 155,
	[31] = 160, [32] = 165, [33] = 170, [34] = 175, [35] = 180,
	[36] = 185, [37] = 190,
}

local function getLang(player)
	local lang = tostring(apocalypseGetElementData(player, "language") or "EN"):upper()
	if lang ~= "EN" and lang ~= "DE" and lang ~= "RU" and lang ~= "PT" then
		lang = "EN"
	end
	return lang
end

local function colonyLocalized(player, data)
	local lang = getLang(player)
	if type(data) ~= "table" then return tostring(data or "") end
	return data[lang] or data.EN or data.DE or ""
end

local function colonyMessage(player, key)
	local lang = getLang(player)
	local texts = MissionTerminal.ColonyTexts[lang] or MissionTerminal.ColonyTexts.EN
	return texts[key] or MissionTerminal.ColonyTexts.EN[key] or key
end

local function getStandardQuestList()
	if StandardQuests and type(StandardQuests) == "table" then
		local list = {}

		for _, id in pairs(StandardQuests) do
			if tonumber(id) then
				table.insert(list, tonumber(id))
			end
		end

		if #list > 0 then
			table.sort(list)
			return list
		end
	end

	return MissionTerminal.StandardQuestFallback
end

local function tableHasValue(tbl, id)
	id = tonumber(id)

	for _, v in pairs(tbl or {}) do
		if tonumber(v) == id then
			return true
		end
	end

	return false
end

local function getMoney(player)
	return tonumber(apocalypseGetElementData(player, "money")) or 0
end

local function takeMoney(player, amount)
	amount = tonumber(amount) or 0

	if getMoney(player) < amount then
		return false
	end

	apocalypseSetElementData(player, "money", apocalypseGetElementData(player, "money") - amount)

	return true
end

local function hasNormalQuest(player, id)
	if getQuest then
		return getQuest(player, id) ~= false
	end

	return false
end

local function hasQuestSeries(player, id)
	id = tonumber(id)

	local oldQuests = getPlayerData("player_questseries", "character_id", getCharacterID(player), "questseries_id")

	if not oldQuests or oldQuests == "" then
		return false
	end

	if string.find(oldQuests, "^" .. id .. "|") or string.find(oldQuests, "|" .. id .. "|") then
		return true
	end

	return false
end

local function getNormalQuestData(player, id)
	local lang = getLang(player)

	if not Quests or not Quests["QuestData"] then
		return nil
	end

	if Quests["QuestData"][lang] and Quests["QuestData"][lang][id] then
		return Quests["QuestData"][lang][id]
	end

	if Quests["QuestData"]["EN"] and Quests["QuestData"]["EN"][id] then
		return Quests["QuestData"]["EN"][id]
	end

	if Quests["QuestData"]["DE"] and Quests["QuestData"]["DE"][id] then
		return Quests["QuestData"]["DE"][id]
	end

	return nil
end

local function getItemName(player, itemID)
	local lang = getLang(player)
	itemID = tonumber(itemID)

	if ItemInfos and ItemInfos["items"] then
		if ItemInfos["items"][lang] and ItemInfos["items"][lang][itemID] then
			return ItemInfos["items"][lang][itemID]
		end

		if ItemInfos["items"]["EN"] and ItemInfos["items"]["EN"][itemID] then
			return ItemInfos["items"]["EN"][itemID]
		end

		if ItemInfos["items"]["DE"] and ItemInfos["items"]["DE"][itemID] then
			return ItemInfos["items"]["DE"][itemID]
		end
	end

	return getText(player, "MT_ITEM_FALLBACK"):format(tostring(itemID))
end

local function addRewardTextFromQuestData(player, id)
	local lang = getLang(player)
	local quest = QuestSeries and QuestSeries["QuestData"] and QuestSeries["QuestData"][id]

	if not quest or not quest.Rewards then
		return nil
	end

	local rewards = quest.Rewards[lang] or quest.Rewards["EN"] or quest.Rewards["DE"]

	if type(rewards) ~= "table" then
		return nil
	end

	local stages = {}

	for stage in pairs(rewards) do
		if tonumber(stage) then
			table.insert(stages, tonumber(stage))
		end
	end

	table.sort(stages)

	local text = ""

	for _, stage in ipairs(stages) do
		if rewards[stage] then
			text = text .. getText(player, "MT_STAGE"):format(stage) .. "\n"
			text = text .. tostring(rewards[stage]) .. "\n\n"
		end
	end

	if text ~= "" then
		return text
	end

	return nil
end

local function addRewardTextFromQuestRewards(player, id)
	if not QuestSeries or not QuestSeries["QuestRewards"] or not QuestSeries["QuestRewards"][id] or not QuestSeries["QuestRewards"][id]["Stages"] then
		return nil
	end

	local stagesData = QuestSeries["QuestRewards"][id]["Stages"]
	local stages = {}

	for stage in pairs(stagesData) do
		if tonumber(stage) then
			table.insert(stages, tonumber(stage))
		end
	end

	table.sort(stages)

	local text = ""

	for _, stage in ipairs(stages) do
		local reward = stagesData[stage]

		if reward then
			text = text .. getText(player, "MT_STAGE"):format(stage) .. "\n"

			if tonumber(reward.experience or 0) > 0 then
				text = text .. getText(player, "MT_REWARD_EXP"):format(reward.experience) .. "\n"
			end

			if tonumber(reward.money or 0) > 0 then
				text = text .. getText(player, "MT_REWARD_MONEY"):format(reward.money) .. "\n"
			end

			if tonumber(reward.skillpoints or 0) > 0 then
				text = text .. getText(player, "MT_REWARD_SKILLPOINTS"):format(reward.skillpoints) .. "\n"
			end

			if reward.items and type(reward.items) == "table" then
				for _, itemData in pairs(reward.items) do
					if itemData and itemData[1] then
						text = text .. getText(player, "MT_REWARD_ITEM"):format(itemData[2] or 1, getItemName(player, itemData[1])) .. "\n"
					end
				end
			end

			text = text .. "\n"
		end
	end

	if text ~= "" then
		return text
	end

	return nil
end

local function buildQuestSeriesRewardText(player, id)
	id = tonumber(id)

	local fromQuestData = addRewardTextFromQuestData(player, id)
	if fromQuestData and fromQuestData ~= "" then
		return fromQuestData
	end

	local fromQuestRewards = addRewardTextFromQuestRewards(player, id)
	if fromQuestRewards and fromQuestRewards ~= "" then
		return fromQuestRewards
	end

	return getText(player, "MT_NO_REWARDS")
end

local function buildStandardQuests(player)
	local tbl = {}
	local standardList = getStandardQuestList()

	for _, id in pairs(standardList) do
		id = tonumber(id)

		local quest = getNormalQuestData(player, id)

		if quest then
			table.insert(tbl, {
				id = id,
				name = quest.questName or getText(player, "MT_STANDARD_FALLBACK_NAME"):format(id),
				description = quest.questDescription or "",
				rewards = quest.questRewards or "",
				price = MissionTerminal.Config.standardQuestPrice,
				minLevel = MissionTerminal.Config.standardQuestMinLevel,
				hasQuest = hasNormalQuest(player, id),
			})
		end
	end

	table.sort(tbl, function(a, b)
		return tonumber(a.id) < tonumber(b.id)
	end)

	return tbl
end

local function buildQuestSeries(player)
	local lang = getLang(player)
	local tbl = {}

	if not QuestSeries or not QuestSeries["QuestData"] then
		return tbl
	end

	for id, quest in pairs(QuestSeries["QuestData"]) do
		id = tonumber(id)

		local title = getText(player, "MT_SERIES_FALLBACK_NAME"):format(id)
		local description = ""

		if quest.Title then
			title = quest.Title[lang] or quest.Title["EN"] or quest.Title["DE"] or title
		elseif quest.title then
			title = quest.title[lang] or quest.title["EN"] or quest.title["DE"] or title
		elseif quest.questName then
			title = quest.questName
		end

		if quest.Description then
			description = quest.Description[lang] or quest.Description["EN"] or quest.Description["DE"] or ""
		elseif quest.description then
			description = quest.description[lang] or quest.description["EN"] or quest.description["DE"] or ""
		elseif quest.questDescription then
			description = quest.questDescription
		end

		table.insert(tbl, {
			id = id,
			name = title,
			description = description,
			rewards = buildQuestSeriesRewardText(player, id),
			price = 0,
			minLevel = MissionTerminal.QuestSeriesLevels[id] or 1,
			hasQuest = hasQuestSeries(player, id),
		})
	end

	table.sort(tbl, function(a, b)
		return tonumber(a.id) < tonumber(b.id)
	end)

	return tbl
end

local function buildColonyMissions(player)
	local tbl = {}
	local colony = apocalypseGetElementData(player, "colony")

	if not colony then
		return tbl
	end

	for id, mission in pairs(MissionTerminal.ColonyMissions) do
		local active = false
		if type(isColonyMissionActive) == "function" then
			active = isColonyMissionActive(colony, id) == true
		end

		table.insert(tbl, {
			id = id,
			name = colonyLocalized(player, mission.name),
			description = colonyLocalized(player, mission.description),
			rewards = colonyLocalized(player, mission.rewards),
			info = colonyLocalized(player, mission.info),
			price = 0,
			minLevel = tonumber(mission.minLevel) or 1,
			hasQuest = active,
		})
	end

	table.sort(tbl, function(a, b)
		return tostring(a.id) < tostring(b.id)
	end)

	return tbl
end

function MissionTerminal.sendData(player)
	if not player then
		player = client
	end

	if not isElement(player) then
		return
	end

	triggerClientEvent(player, "MissionTerminal.receiveData", player, {
		level = tonumber(apocalypseGetElementData(player, "level")) or 0,
		standard = buildStandardQuests(player),
		series = buildQuestSeries(player),
		colony = buildColonyMissions(player),
	})
end

addEvent("MissionTerminal.requestData", true)
addEventHandler("MissionTerminal.requestData", root, function()
	MissionTerminal.sendData(client)
end)

addEvent("MissionTerminal.buyStandardQuest", true)
addEventHandler("MissionTerminal.buyStandardQuest", root, function(id)
	local player = client
	id = tonumber(id)

	if not id then return end

	local standardList = getStandardQuestList()

	if not tableHasValue(standardList, id) then
		return
	end

	if hasNormalQuest(player, id) then
		createInfobox(player, getText(player, "MT_ALREADY_HAS_QUEST"))
		return
	end

	if tonumber(apocalypseGetElementData(player, "level")) < MissionTerminal.Config.standardQuestMinLevel then
		createInfobox(player, getText(player, "MT_NEED_LEVEL"):format(MissionTerminal.Config.standardQuestMinLevel))
		return
	end

	if not takeMoney(player, MissionTerminal.Config.standardQuestPrice) then
		createInfobox(player, getText(player, "MT_NOT_ENOUGH_MONEY"))
		return
	end

	setQuest(player, id)
	MissionTerminal.sendData(player)
end)

addEvent("MissionTerminal.claimQuestSeries", true)
addEventHandler("MissionTerminal.claimQuestSeries", root, function(id)
	local player = client
	id = tonumber(id)

	if not id or not QuestSeries or not QuestSeries["QuestData"] or not QuestSeries["QuestData"][id] then
		return
	end

	local needLevel = MissionTerminal.QuestSeriesLevels[id] or 1

	if hasQuestSeries(player, id) then
		createInfobox(player, getText(player, "MT_ALREADY_HAS_SERIES"))
		return
	end

	if tonumber(apocalypseGetElementData(player, "level")) < needLevel then
		createInfobox(player, getText(player, "MT_NEED_LEVEL"):format(needLevel))
		return
	end

	QuestSeries.giveQuest(player, id)
	createInfobox(player, getText(player, "MT_SERIES_ACCEPTED"))
	MissionTerminal.sendData(player)
end)

addEvent("MissionTerminal.claimColonyMission", true)
addEventHandler("MissionTerminal.claimColonyMission", root, function(id)
	local player = client
	if not isElement(player) then return end

	id = tostring(id or "")
	local mission = MissionTerminal.ColonyMissions[id]
	if not mission then return end

	local colony = apocalypseGetElementData(player, "colony")
	if not colony then
		createInfobox(player, colonyMessage(player, "noColony"))
		return
	end

	local needLevel = tonumber(mission.minLevel) or 1
	if (tonumber(apocalypseGetElementData(player, "level")) or 0) < needLevel then
		createInfobox(player, getText(player, "MT_NEED_LEVEL"):format(needLevel))
		return
	end

	if type(isColonyMissionActive) == "function" and isColonyMissionActive(colony, id) then
		createInfobox(player, colonyMessage(player, "alreadyActive"))
		MissionTerminal.sendData(player)
		return
	end

	if type(giveColonyMission) ~= "function" then
		createInfobox(player, colonyMessage(player, "error"))
		return
	end

	if not giveColonyMission(colony, id) then
		createInfobox(player, colonyMessage(player, "error"))
		return
	end

	createInfobox(player, colonyMessage(player, "accepted"))
	MissionTerminal.sendData(player)
end)

addEvent("MissionTerminal.openWindow",true)
addEventHandler("MissionTerminal.openWindow",root,function()
	MissionTerminal.sendData(client)
	triggerClientEvent(client, "MissionTerminal.open", client)
end)