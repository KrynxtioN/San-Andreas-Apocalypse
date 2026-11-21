ColonyTrash = {}

function ColonyTrash.getData(player)
	if(not(player))then player = client end
	local Colony = tonumber(apocalypseGetElementData(player,"colony"))
	local cTrash = tonumber(getPlayerData("colonys","ID",Colony,"trash"))
	local cTrash_kilo = tonumber(getPlayerData("colonys","ID",Colony,"trash_kilo"))
	local cTrash_started = tonumber(getPlayerData("colonys","ID",Colony,"trash_started"))
	local cTrash_status = tonumber(getPlayerData("colonys","ID",Colony,"trash_status"))
	local cTrash_timer = tonumber(getPlayerData("colonys","ID",Colony,"trash_timer"))
	local level = tonumber(getPlayerData("colonys","ID",Colony,"level"))
	local cTrash_experience = tonumber(getPlayerData("colonys","ID",Colony,"trash_experience"))
	local cTrash_saved_experience = tonumber(getPlayerData("colonys","ID",Colony,"saved_experience_from_trash"))
	local cTrash_saved_money = tonumber(getPlayerData("colonys","ID",Colony,"saved_money_from_trash"))
	local time = getRealTime()
	local currentTimestamp = time.timestamp
	if(not(cTrash_timer))then cTrash_timer = 0 end
	local timeLeft = 7200 - (currentTimestamp - cTrash_timer)
	triggerClientEvent(player,"ColonyTrash.setData",player,cTrash,cTrash_kilo,cTrash_started,cTrash_status,level,timeLeft,formatTimeLeft(timeLeft),cTrash_saved_experience,cTrash_saved_money)
end
addEvent("ColonyTrash.getData",true)
addEventHandler("ColonyTrash.getData",root,ColonyTrash.getData)

function ColonyTrash.delivery(item,amount)
	local Colony = tonumber(apocalypseGetElementData(client,"colony"))
	local Colony = getPlayerData("characters","ID",getCharacterID(client),"colony")
	local cTrash = tonumber(getPlayerData("colonys","ID",Colony,"trash"))
	local level = tonumber(getPlayerData("colonys","ID",Colony,"level"))
	local item, amount = tonumber(item), tonumber(amount)
	local savedExperience = tonumber(getPlayerData("colonys","ID",Colony,"saved_experience_from_trash"))
	local savedMoney = tonumber(getPlayerData("colonys","ID",Colony,"saved_money_from_trash"))
	if(hasPlayerItem(client,item) >= amount)then
		if((cTrash + amount) <= (level * 500))then
			takeItem(client,item,amount)
			Colonys.getTrashItems(client)
			dbExec(handler,"UPDATE colonys SET trash = '"..cTrash + amount.."', saved_experience_from_trash = '"..savedExperience + (ItemBasicValue[item].experience * amount).."', saved_money_from_trash = '"..savedMoney + (ItemBasicValue[item].money * amount).."' WHERE ID = '"..Colony.."'")
			ColonyTrash.getData(client)
			outputLog(getPlayerName(client).." hat das Item "..item.." ("..amount.."x) in die Müllpresse seiner Kolonie ("..Colony..") gelegt","Trash Compactor",getCharacterID(client))
		else
			NPC.MeMessage(client,getText(client,"SColonyTrash1"))
		end
	else
		NPC.MeMessage(client,getText(client,"SColonyTrash2"))
	end
end
addEvent("ColonyTrash.delivery",true)
addEventHandler("ColonyTrash.delivery",root,ColonyTrash.delivery)

function ColonyTrash.start()
	local Colony = tonumber(apocalypseGetElementData(client,"colony"))
	local cTrash_status = tonumber(getPlayerData("colonys","ID",Colony,"trash_status"))
	local cTrash = tonumber(getPlayerData("colonys","ID",Colony,"trash"))
	local cTrash_timer = tonumber(getPlayerData("colonys","ID",Colony,"trash_timer"))
	local cTrash_kilo = tonumber(getPlayerData("colonys","ID",Colony,"trash_kilo"))
	local savedExperience = tonumber(getPlayerData("colonys","ID",Colony,"saved_experience_from_trash"))
	local savedMoney = tonumber(getPlayerData("colonys","ID",Colony,"saved_money_from_trash"))
	if(cTrash_status >= 25)then
		if(cTrash >= 1)then
			local time = getRealTime()
			local currentTimestamp = time.timestamp
			local cTrash_started = tonumber(getPlayerData("colonys","ID",Colony,"trash_started"))
			if(not(cTrash_timer))then cTrash_timer = 0 end
			if((currentTimestamp - cTrash_timer) >= 7200)then
				local newTrash = cTrash + cTrash_kilo
				giveColonyEXP(client, savedExperience)
				giveColonyMoney(client, savedMoney)
				dbExec(handler,"UPDATE colonys SET trash = '0', trash_status = '"..cTrash_status - 25 .."', trash_kilo = '"..newTrash.."', trash_started = '"..cTrash_started + 1 .."', saved_experience_from_trash = '0', saved_money_from_trash = '0' WHERE ID = '"..Colony.."'")
				ColonyTrash.getData(client)
				outputLog(getPlayerName(client).." hat die Müllpresse seiner Kolonie ("..Colony..") gestartet. Die Müllpresse hat "..savedExperience.." EXP und $"..savedMoney.." eingebracht","Trash Compactor",getCharacterID(client))
			else
				local timeLeft = 7200 - (currentTimestamp - cTrash_timer)
				NPC.MeMessage(client,getText(client,"SColonyTrash7"):format(formatTimeLeft(timeLeft)))
			end
		else
			NPC.MeMessage(client,getText(client,"SColonyTrash6"))
		end
	else
		NPC.MeMessage(client,getText(client,"SColonyTrash5"))
	end
end
addEvent("ColonyTrash.start",true)
addEventHandler("ColonyTrash.start",root,ColonyTrash.start)

function ColonyTrash.repair()
	local Colony = tonumber(apocalypseGetElementData(client,"colony"))
	local cTrash_status = tonumber(getPlayerData("colonys","ID",Colony,"trash_status"))
	if(cTrash_status < 25)then
		if(hasPlayerItem(client,8) >= 25)then
			local time = getRealTime()
			local currentTimestamp = time.timestamp
			dbExec(handler,"UPDATE colonys SET trash_timer = '"..currentTimestamp.."', trash_status = '100' WHERE ID = '"..Colony.."'")
			ColonyTrash.getData(client)
			takeItem(client,8,25)
			outputLog(getPlayerName(client).." hat die Müllpresse seiner Kolonie ("..Colony..") repariert","Trash Compactor",getCharacterID(client))
		else
			NPC.MeMessage(client,getText(client,"SColonyTrash2"))
		end
	else
		NPC.MeMessage(client,getText(client,"SColonyTrash4"))
	end
end
addEvent("ColonyTrash.repair",true)
addEventHandler("ColonyTrash.repair",root,ColonyTrash.repair)