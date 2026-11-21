local Status = {
	["Status"] = {
		["EN"] = {
			[1] = {"Newbie", {50, 5}, "A world full of zombies.\n\nDouble-click the desired status to use it as your status.\nThis status generates 100 EXP, $10 and 1 loot item every 5 minutes."},
			[2] = {"San Andreas Apocalypse", {50, 5}, "A new world order.\n\nDouble-click the desired status to use it as your status.\nThis status generates 100 EXP, $10 and 1 loot item every 5 minutes."},
			[3] = {"Romantiker", {50, 5}, "Valentine's Day Event.\n\nDouble-click the desired status to use it as your status.\nThis status generates 250 EXP, $25 and 2 loot items every 5 minutes."},
			[4] = {"Happy Valentine's Day 2026", {50, 5}, "Valentine's Day Event 2026.\n\nDouble-click the desired status to use it as your status.\nThis status generates 300 EXP, $30 and 3 loot items every 5 minutes."},
			[5] = {"Impala 67", {3750, 500}, "Chevrolet Impala Event.\n\nDouble-click the desired status to use it as your status.\nThis status generates 500 EXP, $50 and 5 loot items every 5 minutes."},
		},
		["DE"] = {
			[1] = {"Neuling",{50,5},"Eine Welt voller Zombies.\n\nMache einen Doppelklick auf den gewünschten Status, um ihn als Status zu verwenden.\nDieser Status generiert alle 5 Minuten 100 EXP, $10 und 1 Loot Item."},
			[2] = {"San Andreas Apocalypse",{50,5},"Eine neue Weltordnung.\n\nMache einen Doppelklick auf den gewünschten Status, um ihn als Status zu verwenden.\nDieser Status generiert alle 5 Minuten 100 EXP, $10 und 1 Loot Item."},
			[3] = {"Romantic", {50, 5}, "Valentinstag Event.\n\nMache einen Doppelklick auf den gewünschten Status, um ihn als Status zu verwenden.\nDieser Status generiert alle 5 Minuten 250 EXP, $25 und 2 Loot Items."},
			[4] = {"Frohen Valentinstag 2026",{50, 5}, "Valentinstag Event 2026.\n\nMache einen Doppelklick auf den gewünschten Status, um ihn als Status zu verwenden.\nDieser Status generiert alle 5 Minuten 300 EXP, $30 und 3 Loot Items."},
			[5] = {"Impala 67", {3750, 500}, "Chevrolet Impala Event.\n\nMache einen Doppelklick auf den gewünschten Status, um ihn als Status zu verwenden.\nDieser Status generiert alle 5 Minuten 500 EXP, $50 und 5 Loot Items."},
		},
		["RU"] = {
			[1] = {"Новичок", {50, 5}, "Мир, полный зомби.\n\nДважды щёлкните по нужному статусу, чтобы использовать его как статус.\nЭтот статус приносит 100 EXP, $10 и 1 предмет лута каждые 5 минут."},
			[2] = {"Апокалипсис в Сан-Андреасе", {50, 5}, "Новый мировой порядок.\n\nДважды щёлкните по нужному статусу, чтобы использовать его как статус.\nЭтот статус приносит 100 EXP, $10 и 1 предмет лута каждые 5 минут."},
			[3] = {"Романтик", {50, 5}, "Событие ко Дню святого Валентина.\n\nДважды щёлкните по нужному статусу, чтобы использовать его как статус.\nЭтот статус приносит 250 EXP, $25 и 2 предмета лута каждые 5 минут."},
			[4] = {"Счастливого Дня святого Валентина 2026", {50, 5}, "Событие ко Дню святого Валентина 2026.\n\nДважды щёлкните по нужному статусу, чтобы использовать его как статус.\nЭтот статус приносит 300 EXP, $30 и 3 предмета лута каждые 5 минут."},
			[5] = {"Impala 67", {3750, 500}, "Событие Chevrolet Impala.\n\nДважды щёлкните по нужному статусу, чтобы использовать его как статус.\nЭтот статус приносит 500 EXP, $50 и 5 предметов лута каждые 5 минут."},
		},
		["PT"] = {
			[1] = {"Novato", {50, 5}, "Um mundo cheio de zumbis.\n\nClique duas vezes no status desejado para usá-lo como status.\nEste status gera 100 EXP, $10 e 1 item de loot a cada 5 minutos."},
			[2] = {"Apocalipse em San Andreas", {50, 5}, "Uma nova ordem mundial.\n\nClique duas vezes no status desejado para usá-lo como status.\nEste status gera 100 EXP, $10 e 1 item de loot a cada 5 minutos."},
			[3] = {"Romântico", {50, 5}, "Evento do Dia dos Namorados.\n\nClique duas vezes no status desejado para usá-lo como status.\nEste status gera 250 EXP, $25 e 2 itens de loot a cada 5 minutos."},
			[4] = {"Feliz Dia dos Namorados 2026", {50, 5}, "Evento do Dia dos Namorados 2026.\n\nClique duas vezes no status desejado para usá-lo como status.\nEste status gera 300 EXP, $30 e 3 itens de loot a cada 5 minutos."},
			[5] = {"Impala 67", {3750, 500}, "Evento Chevrolet Impala.\n\nClique duas vezes no status desejado para usá-lo como status.\nEste status gera 500 EXP, $50 e 5 itens de loot a cada 5 minutos."},
		},
	},
	["Bonus"] = {
		[1] = {100,10,1},
		[2] = {100,10,1},
		[3] = {250,25,2},
		[4] = {300,30,3},
		[5] = {500,50,5},
	},
}
local Status_Bonus_Timer = {}

function Status_playerBonusTimer(player)
	if(not(isTimer(Status_Bonus_Timer[player])))then
		Status_Bonus_Timer[player] = setTimer(function(player)
			if(isElement(player))then
				local statusID = tonumber(apocalypseGetElementData(player,"activestatus"))
				local language = apocalypseGetElementData(player,"language") or "EN"
				if(statusID >= 1 and Status["Status"][language][statusID])then
					local EXP = Status["Bonus"][statusID][1]
					local Money = Status["Bonus"][statusID][2]
					local Items = Status["Bonus"][statusID][3]
					giveEXP(player,EXP)
					givePlayerServerMoney(player,Money)
					giveLootItems(player,Items)
				end
			end
		end,300000,0,player)
	end
end

addEvent("Status.changeStatus",true)
addEventHandler("Status.changeStatus",root,function(ID)
	local ID = tonumber(ID)
	apocalypseSetElementData(client,"activestatus",ID)
	setPlayerStatus(client)
	createInfobox(client,getText(client,"SStatus2"):format(Status["Status"][apocalypseGetElementData(client,"language") or "EN"][ID][1]))
end)

function hasPlayerStatus(player,ID)
	local ID = tonumber(ID)
	local playerStatus = getPlayerData("characters","ID",getCharacterID(player),"status")
	
	if(not(playerStatus) or playerStatus == 0)then
		dbExec(handler, "UPDATE characters SET status = '' WHERE ID = '"..getCharacterID(player).."'")
		playerStatus = getPlayerData("characters","ID",getCharacterID(player),"status")
	end
	
	local values = split(playerStatus, "|")
	local hasStatus = false
	
	if(playerStatus and ID)then
		for _, v in pairs(values)do
			if(tonumber(v) == ID)then
				hasStatus = true
				break
			end
		end
	end
	return hasStatus
end

function setStatus(player,ID)
	local ID = tonumber(ID)
	if(hasPlayerStatus(player,ID) == false)then
		if(ID == 1)then
			apocalypseSetElementData(player,"activestatus",1)
			apocalypseSetElementData(player,"statusName",Status["Status"][apocalypseGetElementData(player,"language") or "EN"][1][1])
			Status_playerBonusTimer(player)
		end
		local playerStatus = getPlayerData("characters","ID",getCharacterID(player),"status")
	
		local Table = Status["Status"][apocalypseGetElementData(player, "language") or "EN"][ID]
		dbExec(handler, "UPDATE characters SET status = '"..playerStatus..ID.."|' WHERE ID = '"..getCharacterID(player).."'")
		triggerClientEvent(player, "Achievements.reached", player, Table[1], {Table[2][1], Table[2][2]}, "Status")
		
		givePlayerServerMoney(player,Table[2][2])
		giveEXP(player, Table[2][1])
		outputLog(getPlayerName(player).." hat einen Status bekommen (ID: "..ID..")", "Status", getCharacterID(player))
	end
end

function setPlayerStatus(player)
	local status = tonumber(apocalypseGetElementData(player,"activestatus"))
	if(status >= 1)then
		Status_playerBonusTimer(player)
		apocalypseSetElementData(player,"statusName",Status["Status"][apocalypseGetElementData(player,"language") or "EN"][status][1])
	end
end

addEvent("Status.getData", true)
addEventHandler("Status.getData", root, function()
    local Data = {}
    local language = apocalypseGetElementData(client, "language") or "EN"
    local statusTable = Status["Status"][language]

    local owned = {}
    local playerStatus = getPlayerData("characters", "ID", getCharacterID(client), "status")

    if playerStatus and playerStatus ~= "" then
        local values = split(playerStatus, "|")
        for _, v in ipairs(values) do
            local id = tonumber(v)
            if id then
                owned[id] = true
            end
        end
    end

    for statusID, Table in pairs(statusTable) do
        if Table then
            table.insert(Data, {
                id = statusID,
                name = Table[1],
                description = getText(client, "SStatus1"):format(Table[3], Table[2][1], Table[2][2]),
                unlocked = owned[statusID] or false
            })
        end
    end

    triggerClientEvent(client, "Collectibles.updateData", client, Data)
end)

addEventHandler("onPlayerQuit",root,function()
	if(isTimer(Status_Bonus_Timer[source]))then
		killTimer(Status_Bonus_Timer[source])
	end
	Status_Bonus_Timer[source] = nil
end)