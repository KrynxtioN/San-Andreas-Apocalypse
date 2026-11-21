NPC = {}

local HelloText = {
	["DE"] = {
		"Hallo, mein Name ist %s. Freut mich, dich kennenzulernen.",
		"Ich bin %s, einer der Überlebenden hier.",
		"Mein Name ist %s, und ich versuche, hier durchzukommen.",
		"Man nennt mich %s. Hoffentlich sind wir auf derselben Seite.",
		"%s ist mein Name. Ich kämpfe schon lange gegen die Untoten.",
		"Mein Name? %s. Vergiss ihn besser nicht.",
		"Ich heiße %s. Freut mich, einen neuen Verbündeten zu sehen.",
		"Nenn mich einfach %s. Das reicht völlig.",
		"Ich bin %s. Überleben ist alles, was zählt.",
		"Man spricht von mir als %s. Ob das gut oder schlecht ist, musst du entscheiden.",
		"Mein Name ist %s. Gemeinsam schaffen wir das vielleicht.",
		"Ich stelle mich vor: %s. Mehr brauchst du im Moment nicht zu wissen.",
		"Du kannst mich %s nennen. So schnell wirst du mich nicht los.",
		"Der Name ist %s. Ich habe schon einiges durchgemacht.",
		"%s. Das ist mein Name. Merke ihn dir gut.",
	},
	["EN"] = {
		"Hello, my name is %s. Nice to meet you.",
		"I am %s, one of the survivors here.",
		"My name is %s, and I’m trying to get through this.",
		"They call me %s. Hopefully, we’re on the same side.",
		"%s is my name. I’ve been fighting the undead for a long time.",
		"My name? %s. Better not forget it.",
		"I’m %s. Glad to see a new ally around.",
		"Just call me %s. That’s enough.",
		"I am %s. Survival is all that matters.",
		"People speak of me as %s. Whether that’s good or bad, you decide.",
		"My name is %s. Maybe together we’ll make it.",
		"Let me introduce myself: %s. That’s all you need to know for now.",
		"You can call me %s. You won’t get rid of me that easily.",
		"The name’s %s. I’ve been through a lot already.",
		"%s. That’s my name. Remember it well.",
	},
	["RU"] = {
		"Привет, меня зовут %s. Рад познакомиться.",
		"Я %s, один из выживших здесь.",
		"Меня зовут %s, и я стараюсь выжить.",
		"Меня называют %s. Надеюсь, мы на одной стороне.",
		"%s — моё имя. Я давно борюсь с мертвецами.",
		"Моё имя? %s. Лучше не забудь его.",
		"Я %s. Рад видеть нового союзника.",
		"Зови меня просто %s. Этого достаточно.",
		"Я %s. Выживание — это всё, что имеет значение.",
		"Обо мне говорят как о %s. Хорошо это или плохо — решать тебе.",
		"Меня зовут %s. Возможно, вместе мы справимся.",
		"Позволь представиться: %s. Больше тебе пока знать не нужно.",
		"Можешь звать меня %s. Так просто ты от меня не избавишься.",
		"Меня зовут %s. Я уже многое пережил.",
		"%s. Вот моё имя. Запомни его.",
	},
	["PT"] = {
		"Olá, meu nome é %s. Prazer em conhecê-lo.",
		"Eu sou %s, um dos sobreviventes aqui.",
		"Meu nome é %s, e estou tentando sobreviver.",
		"Me chamam de %s. Espero que estejamos do mesmo lado.",
		"%s é o meu nome. Luto contra os mortos-vivos há muito tempo.",
		"Meu nome? %s. Melhor não esquecer.",
		"Eu me chamo %s. Bom ver um novo aliado por aqui.",
		"Pode me chamar apenas de %s. Isso basta.",
		"Sou %s. Sobreviver é tudo o que importa.",
		"Falam de mim como %s. Se isso é bom ou ruim, você decide.",
		"Meu nome é %s. Talvez juntos a gente consiga.",
		"Deixe-me apresentar: %s. Por enquanto, isso é tudo o que precisa saber.",
		"Você pode me chamar de %s. Não vai se livrar de mim tão fácil.",
		"O nome é %s. Já passei por muita coisa.",
		"%s. Esse é o meu nome. Guarde bem.",
	},
}

function NPC.NormalMessage(player, text, status, imageModelID, name)
	if(not(status))then status = nil end
	if(not(imageModelID))then imageModelID = nil end
	if(not(name))then name = nil end
	triggerClientEvent(player, "NPC.NormalMessage", player, text, status, imageModelID, name)
end

function NPC.MeMessage(player, text)
	triggerClientEvent(player, "NPC.MeMessage", player, text)
end

local function getNPCRandomDialogues(player)
	return NPCRandomDialogues[apocalypseGetElementData(player, "language") or "EN"][math.random(1, #NPCRandomDialogues[apocalypseGetElementData(player, "language") or "EN"])]
end

function KnowNPC(player,ID)
	local NPCData = getPlayerData("characters", "ID", getCharacterID(player), "npcData")
	local values = split(tostring(NPCData), "|")
	local NPCKennengelernt = false
	for _, v in pairs(values)do
		if(tonumber(v) == ID)then
			NPCKennengelernt = true
			break
		end
	end
	return NPCKennengelernt
end

addEvent("NPC.ToGetToKnow", true)
addEventHandler("NPC.ToGetToKnow", root, function(ID, name)
	if(ID)then
		local ID = tonumber(ID)
		local NPCData = getPlayerData("characters", "ID", getCharacterID(client), "npcData")
		local NPCStats = getPlayerData("characters", "ID", getCharacterID(client), "npc_stats")
		
		if(not(NPCData))then
			dbExec(handler, "UPDATE characters SET npcData = '' WHERE ID = '"..getCharacterID(client).."'")
			NPCData = getPlayerData("characters", "ID", getCharacterID(client), "npcData")
		end
		
		if(not(NPCStats))then
			dbExec(handler, "UPDATE characters SET npc_stats = '' WHERE ID = '"..getCharacterID(client).."'")
			NPCStats = getPlayerData("characters", "ID", getCharacterID(client), "npc_stats")
		end
		
		local values = split(tostring(NPCData), "|")
		local valuesStats = split(tostring(NPCStats),"|")
		local NPCKennengelernt = false
		local NPCStatsStatus = false
		
		for _, v in pairs(values)do
			if(tonumber(v) == ID)then
				NPCKennengelernt = true
				break
			end
		end
		
		local statsInfoList = split(tostring(NPCStats), "|")
		for _, entry in ipairs(statsInfoList) do
			local statsInfo = split(entry, ",")
			if(tonumber(statsInfo[1]) == ID)then
				NPCStatsStatus = true
				break
			end
		end
		
		if(NPCStatsStatus == false)then
			local old_stats = getPlayerData("characters", "ID", getCharacterID(client), "npc_stats")
			local new_stats = old_stats.."|"..ID..",0,0"
			dbExec(handler,"UPDATE characters SET npc_stats = '"..new_stats.."' WHERE ID = '"..getCharacterID(client).."'")
		end
		
		local function generateKeypadCode()
			local code
			repeat
				code = math.random(1111,  9999)
			until not tostring(code):find("0")
			return code
		end
		
		if(tonumber(ID) == 4 and apocalypseGetElementData(client, "tutorialtask") == 6 or apocalypseGetElementData(client, "tutorialtask") == 7)then
			if(not(apocalypseGetElementData(client, "keypadCodeTutorial")))then
				local keypadCode = generateKeypadCode()
				apocalypseSetElementData(client, "keypadCodeTutorial", keypadCode)
				Tutorial.nextTask(client)
			end
			NPC.NormalMessage(client, getText(client, "SNPC1"):format(apocalypseGetElementData(client, "keypadCodeTutorial")))
		else
			if(NPCKennengelernt == false and ID ~= 4)then
				triggerClientEvent(client,"Achievements.reached",client,getText(client, "SNPC2"):format(name),{25,50},"Character")
				dbExec(handler, "UPDATE characters SET npcData = '"..NPCData..ID.."|' WHERE ID = '"..getCharacterID(client).."'")
				local dialogue = nil
				if(NPCDialogues[ID])then
					dialogue = NPCDialogues[ID][apocalypseGetElementData(client,"language") or "EN"][1]
				else
					dialogue = (HelloText[apocalypseGetElementData(client,"language") or "EN"])[math.random(1,#HelloText[apocalypseGetElementData(client,"language") or "EN"])]:format(name)
				end
				triggerClientEvent(client,"NPC.NormalMessage",client,dialogue)
				giveEXP(client,50)
				
				if(ID == 15)then
					local vehicle_slots = getPlayerData("characters","ID",getCharacterID(client),"vehicle_slots")
					dbExec(handler,"UPDATE characters SET vehicle_slots = '"..vehicle_slots + 1 .."' WHERE ID = '"..getCharacterID(client).."'")
					setAchievement(client,47)
				end
				
				if(ID == 1)then triggerClientEvent(client,"Tutorial.billy",client) end
				if(ID == 2)then triggerClientEvent(client,"Tutorial.jack",client) end
				if(ID == 3)then triggerClientEvent(client,"Tutorial.leeroy",client) end
				Tutorial.checkTask1(client)
				
				NPC.setAchievement(client)
			else
				if(ID == 19 or ID == 103 or ID == 104 and HalloweenEvent == true)then
					NPC.NormalMessage(client, getRandomHalloweenFact(client))
				elseif(ID == 5)then
					NPC.NormalMessage(client,getText(client,"SSafe6"))
				else
					NPC.NormalMessage(client, getNPCRandomDialogues(client))
					Quests.givePlayerRandomStandardQuest(client)
				end
			end
			if(ID == 74)then
				if(hasPlayerItem(client,102) < 1)then
					giveItem(client,102,1)
					triggerClientEvent(client, "showItemBar", client, {{102,1}})
				end
			end
		end
	end
end)

addEvent("NPC.getGiftItems",true)
addEventHandler("NPC.getGiftItems",root,function()
	local tbl = {}
	for _,v in pairs(TradeableItems)do
		if(hasPlayerItem(client,v) >= 1)then
			table.insert(tbl,{v,ItemInfos["items"][apocalypseGetElementData(client,"language") or "EN"][v]})
		end
	end
	triggerClientEvent(client,"NPC.updateGiftItems",client,tbl)
end)

function NPC.getStats(player,ID)
    local ID = tonumber(ID)
    if(ID)then
        local Stats = getPlayerData("characters", "ID", getCharacterID(player), "npc_stats")
        if(Stats)then
            local StatsPairs = split(Stats, "|")
            for _, v in pairs(StatsPairs) do
                local statsInfo = split(v, ",")
                if(tonumber(statsInfo[1]) == ID)then
                    local presents = tonumber(statsInfo[2]) or 0
                    local presenttimer = tonumber(statsInfo[3]) or 0
                    return {presents = presents, presenttimer = presenttimer}
                end
            end
        end
    end
    return {presents = 0, presenttimer = 0}
end

local Achievements = {
	{1,297},
	{5,298},
	{10,299},
	{25,300},
	{50,301},
	{75,302},
	{125,303},
	{175,304},
	{250,305},
}

addEvent("NPC.givePresent", true)
addEventHandler("NPC.givePresent", root, function(item, name, ID)
    if(isCharacterLoggedIn(client) and item)then
        local item = tonumber(item)
		local ID = tonumber(ID)
        if(hasPlayerItem(client, item) >= 1)then
            local NPCStats = NPC.getStats(client,ID)
            local time = getRealTime()
            local presentTimer = NPCStats.presenttimer
            local presents = NPCStats.presents
            local currentTimestamp = time.timestamp

            if(currentTimestamp - presentTimer) >= 14400 then
				local npc_gifted = getPlayerData("character_stats","character_id",getCharacterID(client),"npc_gifted")
				Characters.addStats(client,"npc_gifted",npc_gifted + 1)
				
				for _,v in pairs(Achievements)do
					if(npc_gifted + 1 >= v[1])then
						setAchievement(client,v[2])
					end
				end
			
                updateNpcStats(client, ID, presents + 1, currentTimestamp)
                takeItem(client, item, 1)
                NPC.NormalMessage(client, NPCGiftTexts[apocalypseGetElementData(client, "language") or "EN"][math.random(1, #NPCGiftTexts[apocalypseGetElementData(client, "language") or "EN"])])
                triggerClientEvent(client, "closeWindow", client)
				giveEXP(client,25)
            else
                NPC.NormalMessage(client, getText(client,"CNPC10"))
            end
        else
            NPC.NormalMessage(client, getText(client,"CNPC9"))
        end
    end
end)

function updateNpcStats(player, npcId, newPresents, newTimer)
    local Stats = getPlayerData("characters", "ID", getCharacterID(player), "npc_stats")
    local updatedStats = ""
    local found = false

    if(Stats)then
        local StatsPairs = split(Stats, "|")
        for i, v in ipairs(StatsPairs) do
            local statsInfo = split(v, ",")
            if(tonumber(statsInfo[1]) == npcId)then
                StatsPairs[i] = table.concat({npcId, newPresents, newTimer}, ",")
                found = true
                break
            end
        end
        if(not(found))then
            table.insert(StatsPairs, table.concat({npcId, newPresents, newTimer}, ","))
        end
        updatedStats = table.concat(StatsPairs, "|")
    else
        updatedStats = table.concat({npcId, newPresents, newTimer}, ",")
    end
   dbExec(handler,"UPDATE characters SET npc_stats = '"..updatedStats.."' WHERE ID = '"..getCharacterID(player).."'")
end

function NPC.setAchievement(player)
	local NPCData = getPlayerData("characters", "ID", getCharacterID(player), "npcData")
	local values = split(tostring(NPCData), "|")
	local amount = 0
	
	if(NPCData)then
		for _, v in pairs(values)do
			amount = amount + 1
		end
		
		if(amount == 1)then setAchievement(player, 40) end
		if(amount == 5)then setAchievement(player, 15) end
		if(amount == 10)then setAchievement(player, 16) end
	end
end

addEvent("updateTalkData",true)
addEventHandler("updateTalkData",root,function(ID)
	apocalypseSetElementData(client,"NPC.TalkData",ID)
end)

addEvent("NPC.getSomeHelp",true)
addEventHandler("NPC.getSomeHelp",root,function()
	local ID = tonumber(apocalypseGetElementData(client,"NPC.TalkData"))
	
	-- // Dr. Brain
	
	if(ID == 18)then
		--[[local RadioTowerBlips = {123,124,125,126,127,128,129,130,131,132,133,134,186,187,188,189,190,191,192,193,194,195,196,197}
		local result = {}
				
		for _,v in pairs(RadioTowerBlips)do
			if(hasPlayerBlip(client,v) == false)then
				table.insert(result,v)
			end
		end
		
		if(#result >= 1)then]]--
		if(hasRadioLocation(client,20) == false)then
			if(hasPlayerItem(client,5) >= 1)then
				giveRadioData(client,20)
				triggerClientEvent(client,"TutorialPickups.deletePickup",client,"DrBrain")
				NPC.NormalMessage(client,getText(client,"SDrBrain6"))
				return
			else
				NPC.NormalMessage(client,getText(client,"SDrBrain5"))
				return
			end
		else
			local text = NPCHelpTexts[apocalypseGetElementData(client,"language") or "EN"][math.random(1,#NPCHelpTexts[apocalypseGetElementData(client,"language") or "EN"])]
			NPC.NormalMessage(client,text)
		end
		return
	end
	
	-- // Ricky Jey (Survivor Pass)
	
	if(ID == 24)then
		--[[local QuestBlips = {180,181,182,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,219,220,222,223,224,225,226,227}
		local result = {}
		for _,v in pairs(QuestBlips)do
			if(hasPlayerBlip(client,v) == false)then
				table.insert(result,v)
			end
		end
			
		if(#result >= 1)then]]--
		if(hasRadioLocation(client,21) == false)then
			if(hasPlayerItem(client,24) >= 1)then	
				if(hasPlayerItem(client,5) >= 1)then
					giveRadioData(client,21)
					triggerClientEvent(client,"TutorialPickups.deletePickup",client,"RickyJey")
					NPC.NormalMessage(client,getText(client,"SRickyJey2"))
					return
				else
					NPC.NormalMessage(client,getText(client,"SRickyJey1"))
					return
				end
			else
				NPC.NormalMessage(client,getText(client,"SRickyJey3"))
				return
			end
		else
			local text = NPCHelpTexts[apocalypseGetElementData(client,"language") or "EN"][math.random(1,#NPCHelpTexts[apocalypseGetElementData(client,"language") or "EN"])]
			NPC.NormalMessage(client,text)
		end
		return
	end
	
	-- // Fisher Shops

	if(ID == 76 or ID == 77 or ID == 80)then
		if(hasRadioLocation(client,6) == false)then
			if(hasPlayerItem(client,5) >= 1)then
				giveRadioData(client,7)
				NPC.NormalMessage(client,getText(client,"SFishershop5"))
				return
			else
				NPC.NormalMessage(client,getText(client,"SRickyJey3"))
				return
			end
		else
			local text = NPCHelpTexts[apocalypseGetElementData(client,"language") or "EN"][math.random(1,#NPCHelpTexts[apocalypseGetElementData(client,"language") or "EN"])]
			NPC.NormalMessage(client,text)
			return
		end
	end
	
	local text = NPCHelpTexts[apocalypseGetElementData(client,"language") or "EN"][math.random(1,#NPCHelpTexts[apocalypseGetElementData(client,"language") or "EN"])]
	NPC.NormalMessage(client,text)
end)

addEvent("PlayerCharacters.getData", true)
addEventHandler("PlayerCharacters.getData", root, function()
    local characterID = getCharacterID(client)

    local NPCData = getPlayerData("characters", "ID", characterID, "npcData")
    local Data = {}
    local values = split(tostring(NPCData), "|")

    for _, v in ipairs(values) do
        local id = tonumber(v)
        if id and CharacterInfos[id] then
            local lang = apocalypseGetElementData(client, "language") or "EN"
            local Table = CharacterInfos[id][lang]
            local stats = NPC.getStats(client, id)

            if Table and stats then
                table.insert(Data, {
                    name = Table.name,
                    description = Table.description,
                    presents = stats[1],
                    presentTimer = stats[2],
                    model = Table.model,
                })
            end
        end
    end
    triggerClientEvent(client, "Collectibles.updateData", client, Data)
end)

addEventHandler("onPlayerWasted", root, function() triggerClientEvent(source, "NPC.Close", source) end)