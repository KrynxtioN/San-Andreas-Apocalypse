Helpmenu = {
	["Entries"] = {
		["DE"] = {
			[1] = "Accounts und Charaktere",
			[2] = "Spielerwelt",
			[3] = "Zombies",
			[4] = "Aktivitäten",
			[5] = "Bosskämpfe",
			[6] = "Fahrzeuge",
			[7] = "Systeme",
			[8] = "Kolonien",
			[9] = "NPCs",
			[10] = "Sammelobjekte",
			[11] = "Changelogs",
		}, 
		["EN"] = {
			[1] = "Accounts and Characters",
			[2] = "Player World",
			[3] = "Zombies",
			[4] = "Activities",
			[5] = "Boss Fights",
			[6] = "Vehicles",
			[7] = "Systems",
			[8] = "Colonies",
			[9] = "NPCs",
			[10] = "Collectibles",
			[11] = "Changelogs",
		}, 
		["RU"] = {
			[1] = "Аккаунты и персонажи",
			[2] = "Мир игроков",
			[3] = "Зомби",
			[4] = "Деятельность",
			[5] = "Битвы с боссами",
			[6] = "Транспорт",
			[7] = "Системы",
			[8] = "Колонии",
			[9] = "NPC",
			[10] = "Коллекционные предметы",
			[11] = "Изменения",
		}, 
		["PT"] = {
			[1] = "Contas e Personagens",
			[2] = "Mundo dos Jogadores",
			[3] = "Zumbis",
			[4] = "Atividades",
			[5] = "Batalhas contra Chefes",
			[6] = "Veículos",
			[7] = "Sistemas",
			[8] = "Colônias",
			[9] = "NPCs",
			[10] = "Colecionáveis",
			[11] = "Registros de Alterações",
		},
	}, 
	["Objects"] = {
		{1239, 708.7001953125, -455.662109375, 16.283399581909, 0, 0, 82, 1},
		{1239, 708.7001953125, -459.662109375, 16.283399581909, 0, 0, 82, 2},
		{1239, 683.10028076172, -445.99520874023, 15.580400466919, 0, 0, 0, 3},
		{1239, 708.7001953125, -463.662109375, 16.283399581909, 0, 0, 82, 4},
		{1239, 708.13031005859, -442.25439453125, 15.879899978638, 0, 0, 324, 5},
		{1239, 663.12261962891, -440.78860473633, 16.283399581909, 0, 0, 338, 6},
		{1239, 715.56372070312, -446.5419921875, 15.280400276184, 0, 0, 0, 7},
		{1239, 696.1923828125, -478.513671875, 15.530400276184, 0, 0, 0, 8},
		{1239, 691.875, -447.4296875, 15.796799659729, 0, 0, 0, 9},
		{1239, 693.314453125, -453.9169921875, 15.530400276184, 0, 0, 90, 10},
		{1239, -218.10319519043, 1405.0661621094, 27.028200149536, 0, 0, 90, 11, 18, 0},
		--{1239, 680.7138671875, -472.9951171875, 15.784999847412, 0, 0, 0, 8},
		--{1239, 694.134765625, -439.1064453125, 15.57320022583, 0, 0, 0, 9},
		--{1239, 659.123046875, -440.7890625, 16.283399581909, 0, 0, 338, 10},
		--{1239, 655.123046875, -440.7890625, 16.283399581909, 0, 0, 338, 11},
		--{1239, -224.3369140625, 1402.708984375, 27.104600906372, 0, 0, 90, 11, 18, 0},
		--{1239, 656.92492675781, -468.61029052734, 16.080400466919, 0, 0, 92, 12},
	},
	["DeleteMarker"] = {
		[1] = {1},
		[2] = {2},
		[3] = {3},
		[4] = {4},
		[5] = {5},
		[6] = {6},
		[7] = {7},
		[8] = {8},
		[9] = {9},
		[10] = {10},
		[11] = {11},
	},
}

function Helpmenu.createObjects()
	for _, v in pairs(Helpmenu["Objects"])do
		local object = createObject(v[1], v[2], v[3], v[4], v[5], v[6], v[7])
		apocalypseSetElementData(object, "HelpmenuID", v[8])
		
		if(v[9])then
			setElementInterior(object, v[9])
		end
		if(v[10])then
			setElementDimension(object, v[10])
		end
	end
end
Helpmenu.createObjects()

addEventHandler("onPlayerClick", root, function(button, state, clickedElement)
	if(button == "left" and state == "down" and clickedElement)then
		local ID = tonumber(apocalypseGetElementData(clickedElement, "HelpmenuID"))
		if(ID)then
			local x,y,z = getElementPosition(source)
			if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(clickedElement)) <= 5)then
				if(apocalypseGetElementData(source, "tutorialtask") >= 4)then
					addHelpMenuEntrie(source, ID)
				end
			end
		end
	end
end)

function addHelpMenuEntrie(player, entrie)
	if(player and entrie)then
		local entrie = tonumber(entrie)
		if(hasPlayerHelpmenuEntrie(player, entrie) == false)then
			local oldEntries = getPlayerData("characters", "ID", getCharacterID(player), "helpmenu")
		
			if(apocalypseGetElementData(player, "tutorialtask") == 4)then
				Tutorial.nextTask(player)
			end
		
			Helpmenu.setAchievement(player)
			triggerClientEvent(player,"Achievements.reached",player,getText(player, "SHelpmenu1"):format(Helpmenu["Entries"][apocalypseGetElementData(player, "language") or "EN"][entrie]),{25,50},"Helpmenu")
			giveEXP(player,25)
			givePlayerServerMoney(player,50)

			if(Helpmenu["DeleteMarker"][entrie])then
				for _,v in pairs(Helpmenu["DeleteMarker"][entrie])do
					triggerClientEvent(player,"Helpmenu.destroyHelpMarker",player,v)
				end
			end
			
			dbExec(handler, "UPDATE characters SET helpmenu = '"..oldEntries..entrie.."|' WHERE ID = '"..getCharacterID(player).."'")
		end
	end
end

function hasPlayerHelpmenuEntrie(player, entrie)
	if(player and entrie)then
		local oldEntries = getPlayerData("characters", "ID", getCharacterID(player), "helpmenu")
		if(not(oldEntries))then oldEntries = "" end
			
		if(not(oldEntries) or oldEntries == 0)then
			dbExec(handler, "UPDATE characters SET helpmenu = '' WHERE ID = '"..getCharacterID(player).."'")
			oldEntries = getPlayerData("characters", "ID", getCharacterID(player), "Helpmenu")
		end
		
		local values = split(oldEntries, "|")
		local hasHelpmenutext = false
		
		if(oldEntries and entrie)then
			for _, v in pairs(values)do
				if(tonumber(v) == entrie)then
					hasHelpmenutext = true
					break
				end
			end
		end
		return hasHelpmenutext
	end
end

function Helpmenu.setAchievement(player)
	local entriesString = getPlayerData("characters", "ID", getCharacterID(player), "helpmenu")
	local values = split(entriesString,  "|")
	local amount = 0

	if(entriesString)then
		for i,  v in ipairs(values)do
			amount = amount + 1
		end
		
		if(amount >= 1)then setAchievement(player, 9) end
		if(amount >= 5)then setAchievement(player, 32) end
		if(amount >= 10)then setAchievement(player, 33) end
	end
end

function Helpmenu.createHelpMarker(player)
	for i,v in ipairs(Helpmenu["Objects"])do
		if(hasPlayerHelpmenuEntrie(player,v[8]) == false)then
			triggerClientEvent(player,"Helpmenu.createHelpMarker",player,i,v[2],v[3],v[4],v[9] or 0,v[10] or 0)
		end
	end
end

addEvent("Helpmenu.getDatas", true)
addEventHandler("Helpmenu.getDatas", root, function()
	local entries = {}
	local entriesString = getPlayerData("characters", "ID", getCharacterID(client), "helpmenu")
	local values = split(entriesString,  "|")
	
	if(entriesString)then
		for i,  v in ipairs(values)do
			table.insert(entries,  Helpmenu["Entries"][apocalypseGetElementData(client, "language") or "EN"][tonumber(v)])
		end
		triggerClientEvent(client, "Helpmenu.updateDatas", client, entries)
	end
end)