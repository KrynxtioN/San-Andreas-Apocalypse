WeeklyTasks = {playerTasks = {},
	["Tasks"] = {
		[1] = {
			["EN"] = {text = "Kill 1000 zombies"},
			["DE"] = {text = "Töte 1000 Zombies"},
			["RU"] = {text = "Убей 1000 зомби"},
			["PT"] = {text = "Mate 1000 zumbis"},
			reward_exp = 7000,
			needed_progress = 1000,
		},
		[2] = {
			["EN"] = {text = "Break into 25 buildings"},
			["DE"] = {text = "Dringe in 25 Gebäude ein"},
			["RU"] = {text = "Взломай 25 зданий"},
			["PT"] = {text = "Arrombe 25 prédios"},
			reward_exp = 15000,
			needed_progress = 25,
		},
		[3] = {
			["EN"] = {text = "Break into 25 houses"},
			["DE"] = {text = "Dringe in 25 Häuser ein"},
			["RU"] = {text = "Взломай 25 домов"},
			["PT"] = {text = "Arrombe 25 casas"},
			reward_exp = 7500,
			needed_progress = 25,
		},
		[4] = {
			["EN"] = {text = "Blow up 25 garages"},
			["DE"] = {text = "Sprenge 25 Garagen"},
			["RU"] = {text = "Взбей 25 гаражей"},
			["PT"] = {text = "Exploda 25 garagens"},
			reward_exp = 25000,
			needed_progress = 25,
		},
		[5] = {
			["EN"] = {text = "Search 50 trash cans"},
			["DE"] = {text = "Durchsuche 50 Mülltonnen"},
			["RU"] = {text = "Обыщи 50 мусорных баков"},
			["PT"] = {text = "Revise 50 lixeiras"},
			reward_exp = 5000,
			needed_progress = 50,
		},
		[6] = {
			["EN"] = {text = "Search 25 vehicles"},
			["DE"] = {text = "Durchsuche 25 Fahrzeuge"},
			["RU"] = {text = "Обыщи 25 транспортов"},
			["PT"] = {text = "Revise 25 veículos"},
			reward_exp = 4500,
			needed_progress = 25,
		},
		[7] = {
			["EN"] = {text = "Kill 100 animals"},
			["DE"] = {text = "Töte 100 Tiere"},
			["RU"] = {text = "Убей 100 животных"},
			["PT"] = {text = "Mate 100 animais"},
			reward_exp = 22500,
			needed_progress = 100,
		},
		[8] = {
			["EN"] = {text = "Kill 10 Bigfoots"},
			["DE"] = {text = "Töte 10 Bigfoots"},
			["RU"] = {text = "Убей 10 Бигфутов"},
			["PT"] = {text = "Mate 10 Pés Grandes"},
			reward_exp = 37500,
			needed_progress = 10,
		},
		[9] = {
			["EN"] = {text = "Collect 10 supply crates"},
			["DE"] = {text = "Sammel 10 Vorratskisten ein"},
			["RU"] = {text = "Собери 10 ящиков с припасами"},
			["PT"] = {text = "Recolhe 10 caixas de suprimentos"},
			reward_exp = 5000,
			needed_progress = 10,
		},
		[10] = {
			["EN"] = {text = "Destroy 10 zombie nests"},
			["DE"] = {text = "Zerstöre 10 Zombie-Nester"},
			["RU"] = {text = "Уничтожь 10 зомби-гнезд"},
			["PT"] = {text = "Destrói 10 ninhos de zumbis"},
			reward_exp = 15000,
			needed_progress = 10,
		},
		[11] = {
			["EN"] = {text = "Destroy 15 tanks"},
			["DE"] = {text = "Zerstöre 15 Panzer"},
			["RU"] = {text = "Уничтожь 15 танков"},
			["PT"] = {text = "Destrói 15 tanques"},
			reward_exp = 25000,
			needed_progress = 15,
		},
		[12] = {
			["EN"] = {text = "Rescue 500 survivors in vehicle missions"},
			["DE"] = {text = "Rette 500 Überlebende in Fahrzeugmissionen"},
			["RU"] = {text = "Спаси 500 выживших в миссиях на транспорте"},
			["PT"] = {text = "Resgate 500 sobreviventes em missões com veículos"},
			reward_exp = 25000,
			needed_progress = 500,
		},
		[13] = {
			["EN"] = {text = "Catch 100 fish"},
			["DE"] = {text = "Fange 100 Fische"},
			["RU"] = {text = "Поймайте 100 рыб"},
			["PT"] = {text = "Pesque 100 peixes"},
			reward_exp = 10000,
			needed_progress = 100,
		},
		[14] = {
			["DE"] = {text = "Finde und verkaufe 50 Schätze als Schatzsucher"},
			["EN"] = {text = "Find and sell 50 treasures as a treasure hunter"},
			["RU"] = {text = "Найди и продай 50 сокровищ в роли кладоискателя"},
			["PT"] = {text = "Encontre e venda 50 tesouros como caçador de tesouros"},
			reward_exp = 12500,
			needed_progress = 50,
		},
		[15] = {
			["DE"] = {text = "Sammel 5 Kilo Müll mit einem Sweeper ein"},
			["EN"] = {text = "Collect 5 kilo of trash with a sweeper"},
			["RU"] = {text = "Собери 5 килограмм мусора с помощью уборочной машины"},
			["PT"] = {text = "Recolha 5 quilo de lixo com um varredor"},
			reward_exp = 13000,
			needed_progress = 5000,
		},
		[16] = {
			["DE"] = {text = "Sammel 5 Kilo Müll als Meeresreiniger ein"},
			["EN"] = {text = "Collect 5 kilo of trash as a sea cleaner"},
			["RU"] = {text = "Собери 5 килограмм мусора в роли очистителя моря"},
			["PT"] = {text = "Recolha 5 quilo de lixo como limpador marinho"},
			reward_exp = 10000,
			needed_progress = 5000,
		},
		[17] = {
			["DE"] = {text = "Suche an 50 Stellen in der Mine"},
			["EN"] = {text = "Search at 50 locations in the mine"},
			["RU"] = {text = "Обыщи 50 мест в шахте"},
			["PT"] = {text = "Procure em 50 locais na mina"},
			reward_exp = 12500,
			needed_progress = 50,
		},
		[18] = {
			["DE"] = {text = "Hebe 25 Gräber aus"},
			["EN"] = {text = "Dig 25 graves"},
			reward_exp = 12500,
			needed_progress = 25,
		},
		[19] = {
			["DE"] = {text = "Fälle 75 Bäume als Holzfäller"},
			["EN"] = {text = "Chop down 75 trees as a lumberjack"},
			["RU"] = {text = "Сруби 75 деревьев в роли лесоруба"},
			["PT"] = {text = "Derrube 75 árvores como lenhador"},
			reward_exp = 13500,
			needed_progress = 75,
		},
		[20] = {
			["DE"] = {text = "Gib 50 Fahrzeuge am Schrottplatz ab"},
			["EN"] = {text = "Deliver 50 vehicles to the junkyard"},
			["RU"] = {text = "Сдай 50 транспортных средств на свалку"},
			["PT"] = {text = "Entregue 50 veículos no ferro-velho"},
			reward_exp = 14000,
			needed_progress = 50,
		},
		[21] = {
			["DE"] = {text = "Pflege 50 Gräber als Grabpfleger"},
			["EN"] = {text = "Take care of 50 graves as a gravekeeper"},
			["RU"] = {text = "Ухаживай за 50 могилами в роли смотрителя кладбища"},
			["PT"] = {text = "Cuide de 50 túmulos como coveiro"},
			reward_exp = 7500,
			needed_progress = 50,
		},
		[22] = {
			["DE"] = {text = "Finde 50x etwas mit deinem Metalldetektor"},
			["EN"] = {text = "Make 50 finds with your metal detector"},
			["RU"] = {text = "Найди 50 предметов с помощью своего металлоискателя"},
			["PT"] = {text = "Faça 50 descobertas com seu detector de metais"},
			reward_exp = 10000,
			needed_progress = 50,
		},
		[23] = {
			["DE"] = {text = "Töte 5x einen Spinosaurus"},
			["EN"] = {text = "Kill a Spinosaurus 5 times"},
			["RU"] = {text = "Убей Спинозавра 5 раз"},
			["PT"] = {text = "Mate um Spinosaurus 5 vezes"},
			reward_exp = 35000,
			needed_progress = 5,
		},
		[24] = {
			["DE"] = {text = "Schließe 10 Öl Lieferungen ab"},
			["EN"] = {text = "Complete 10 oil deliveries"},
			["RU"] = {text = "Завершите 10 доставок нефти"},
			["PT"] = {text = "Complete 10 entregas de óleo"},
			reward_exp = 32500,
			needed_progress = 10,
		},
		[25] = {
			["DE"] = {text = "Sprenge 15 Casino Tresore"},
			["EN"] = {text = "Blow up 15 casino safes"},
			["RU"] = {text = "Взорви 15 казино-сейфов"},
			["PT"] = {text = "Exploda 15 cofres de cassino"},
			reward_exp = 14000,
			needed_progress = 15,
		},
		[26] = {
			["DE"] = {text = "Besiege 25 Spieler in der Shooter-Arena"},
			["EN"] = {text = "Defeat 25 players in the shooter arena"},
			["RU"] = {text = "Победите 25 игроков на арене стрелков"},
			["PT"] = {text = "Derrote 25 jogadores na arena de tiro"},
			reward_exp = 7500,
			needed_progress = 25,
		},
		[27] = {
			["DE"] = {text = "Erreiche die Top 3 in 5 Rennen"},
			["EN"] = {text = "Reach the top 3 in 5 races"},
			["RU"] = {text = "Попадите в топ-3 в 5 гонках"},
			["PT"] = {text = "Alcance o top 3 em 5 corridas"},
			reward_exp = 12500,
			needed_progress = 5,
		},
		[28] = {
			["DE"] = {text = "Überlebe 25 Zombie Wellen"},
			["EN"] = {text = "Survive 25 zombie waves"},
			["RU"] = {text = "Переживи 25 волн зомби"},
			["PT"] = {text = "Sobreviva a 25 ondas de zumbis"},

			reward_exp = 10000,
			needed_progress = 25,
		},
	},
}

function WeeklyTasks.loadTasks(player)
	local characterID = getCharacterID(player)
	local result = dbPoll(dbQuery(handler, "SELECT * FROM weeklytasks WHERE character_id = '"..characterID.."'"), -1)

	if (#result < 5) then
		local existingTaskIDs = {}
		for _, row in ipairs(result) do
			existingTaskIDs[tonumber(row.task)] = true
		end

		local availableTasks = {}
		for taskID, _ in pairs(WeeklyTasks["Tasks"]) do
			if not existingTaskIDs[taskID] then
				table.insert(availableTasks, taskID)
			end
		end

		local needed = 5 - #result
		for i = 1, needed do
			if #availableTasks == 0 then break end
			local randIndex = math.random(1, #availableTasks)
			local task = table.remove(availableTasks, randIndex)
			dbExec(handler, "INSERT INTO weeklytasks (character_id,task,status,progress_data) VALUES ('"..characterID.."','"..task.."','0','0')")
		end

		result = dbPoll(dbQuery(handler, "SELECT * FROM weeklytasks WHERE character_id = '"..characterID.."'"), -1)
	end

	if not WeeklyTasks.playerTasks[player] then
		WeeklyTasks.playerTasks[player] = {}
	end

	for i, v in ipairs(result) do
		local taskID = tonumber(v["task"])
		WeeklyTasks.playerTasks[player][taskID] = {
			id = taskID,
			text = WeeklyTasks["Tasks"][taskID][apocalypseGetElementData(player,"language") or "EN"].text,
			reward_exp = WeeklyTasks["Tasks"][taskID].reward_exp,
			progress = tonumber(v["progress_data"]),
			needed_progress = WeeklyTasks["Tasks"][taskID].needed_progress,
			status = tonumber(v["status"]),
		}
	end

	WeeklyTasks.updateClient(player)
end

function WeeklyTasks.updateClient(player)
	if(not(player))then player = client end
	triggerClientEvent(player,"DailyTasks.updateClientWeeklyTasks",player,WeeklyTasks.playerTasks[player])
end
addEvent("WeeklyTasks.updateClient",true)
addEventHandler("WeeklyTasks.updateClient",root,WeeklyTasks.updateClient)

function WeeklyTasks.updateProgress(player,task,new_data_progress)
	if(WeeklyTasks.playerTasks[player][task].status == 0)then
		dbExec(handler,"UPDATE weeklytasks SET progress_data = '"..new_data_progress.."' WHERE character_id = '"..getCharacterID(player).."' AND task = '"..task.."'")
		WeeklyTasks.playerTasks[player][task].progress = new_data_progress
		if(WeeklyTasks.playerTasks[player][task].progress >= WeeklyTasks.playerTasks[player][task].needed_progress)then
			WeeklyTasks.playerTasks[player][task].status = 1
			giveEXP(player,WeeklyTasks.playerTasks[player][task].reward_exp)
			dbExec(handler,"UPDATE weeklytasks SET status = '1' WHERE character_id = '"..getCharacterID(player).."' AND task = '"..task.."'")
			outputLog(getPlayerName(player).." hat "..WeeklyTasks.playerTasks[player][task].reward_exp.." EXP durch eine Wochenaufgabe erhalten", "Weekly Task", getCharacterID(player))
		end
		WeeklyTasks.updateClient(player)
	end
end

function WeeklyTasks.deleteAllTasks()
	dbExec(handler,"DELETE FROM weeklytasks")
end
		
addEventHandler("onPedWasted",root,function(ammo,attacker,weapon,bodypart)
	if(getElementData(source,"zombie") and getElementData(source,"zombie") == true)then
		if(attacker and getElementType(attacker) == "player")then
			if(WeeklyTasks.playerTasks[attacker][1])then
				WeeklyTasks.updateProgress(attacker,1,WeeklyTasks.playerTasks[attacker][1].progress + 1)
			end
		end
	end
end)

function WeeklyTasks.giveNewTask(player)
	if not player then player = client end
	local characterID = getCharacterID(player)
	if not characterID then return false end
	
	local money = tonumber(apocalypseGetElementData(player,"money"))
	if(money >= 750)then
		if not WeeklyTasks.playerTasks[player] then WeeklyTasks.playerTasks[player] = {} end

		local ownedTasks = {}
		for taskID, _ in pairs(WeeklyTasks.playerTasks[player]) do
			ownedTasks[taskID] = true
		end

		local availableTasks = {}
		for taskID, _ in pairs(WeeklyTasks["Tasks"]) do
			if not ownedTasks[taskID] then
				table.insert(availableTasks, taskID)
			end
		end

		if #availableTasks == 0 then
			createInfobox(player,getText(player,"SWeeklyTasks1"))
			return false
		end

		local randIndex = math.random(1, #availableTasks)
		local newTaskID = table.remove(availableTasks, randIndex)

		dbExec(handler, "INSERT INTO weeklytasks (character_id, task, status, progress_data) VALUES (?, ?, ?, ?)",
			characterID, newTaskID, 0, 0)

		WeeklyTasks.playerTasks[player][newTaskID] = {
			id = newTaskID,
			text = WeeklyTasks["Tasks"][newTaskID][apocalypseGetElementData(player,"language") or "EN"].text,
			reward_exp = WeeklyTasks["Tasks"][newTaskID].reward_exp,
			progress = 0,
			needed_progress = WeeklyTasks["Tasks"][newTaskID].needed_progress,
			status = 0,
		}

		WeeklyTasks.updateClient(player)
		apocalypseSetElementData(player,"money",money - 750)
		createInfobox(player,getText(player,"SWeeklyTasks2"):format(WeeklyTasks.playerTasks[player][newTaskID].text))
		return true
	else
		createInfobox(player,getText(player,"SWeeklyTasks3"))
	end
end
addEvent("WeeklyTasks.giveNewTask", true)
addEventHandler("WeeklyTasks.giveNewTask", root, WeeklyTasks.giveNewTask)

addEventHandler("onPlayerQuit", root, function()
    WeeklyTasks.playerTasks[source] = nil
end)