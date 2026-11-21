HalloweenFacts = {
	["EN"] = {
		"Collect pumpkins by searching/looting vehicles, houses, and trash cans.",
		"Collect pumpkins by killing zombies.",
		"You receive 25 pumpkins with each payday.",
		"Trade pumpkins for great rewards in quest lines and in the shop.",
		"Find hearses. Bring them to Mr. Skeleton's Garage or chauffeur his relatives from A to B.",
		"Decorative pumpkins can be collected by clicking on them.",
		"You can find pumpkins all over San Andreas.",
		"A pumpkin appears on your screen? Click it in time.",
		"Place totems. Totems give you experience points and pumpkins at every payday.",
		"Complete quests and receive Halloween keys, which can be used to open bone chests.",
	},
	["DE"] = {
		"Sammel Kürbisse, indem du Fahrzeuge, Häuser und Mülltonnen durchsuchst/plünderst.",
		"Sammel Kürbisse, indem du Zombies tötest.",
		"Mit jedem Payday erhältst du 25 Kürbisse.",
		"Tausche Kürbisse gegen tolle Belohnungen bei Questreihen und im Shop.",
		"Finde Leichenwagen. Bringe sie zu Mr. Skeleton's Garage oder kutschiere seine Verwandschaft von A nach B.",
		"Dekorative Kürbisse können per Anklicken eingesammelt werden.",
		"Du findest Kürbisse in ganz San Andreas.",
		"Auf deinem Bildschirm taucht ein Kürbiss auf? Klicke ihn rechtzeitig an.",
		"Platziere Totems. Totems bringen dir Erfahrungspunkte und Kürbisse an jedem Payday.",
		"Erledige Quests und erhalte Halloween Schlüssel, mit denen Knochen-Kisten geöffnet werden können.",
	},
	["RU"] = {
		"Собирайте тыквы, обыскивая/грабя машины, дома и мусорные баки.",
		"Собирайте тыквы, убивая зомби.",
		"Вы получаете 25 тыкв при каждой выплате.",
		"Обменивайте тыквы на отличные награды в квестах и магазине.",
		"Найдите катафалки. Доставьте их в гараж мистера Скелета или отвезите его родственников из точки А в точку Б.",
		"Декоративные тыквы можно собрать, кликнув на них.",
		"Вы можете найти тыквы по всему Сан-Андреасу.",
		"Тыква появилась на экране? Кликните по ней вовремя.",
		"Размещайте тотемы. Тотемы дают очки опыта и тыквы при каждой выплате.",
		"Выполняйте квесты и получайте Хэллоуинские ключи, которыми можно открыть костяные сундуки.",
	},
	["PT"] = {
		"Colete abóboras procurando/saqueando veículos, casas e latas de lixo.",
		"Colete abóboras matando zumbis.",
		"Você recebe 25 abóboras a cada pagamento.",
		"Troque abóboras por ótimas recompensas em linhas de quest e na loja.",
		"Encontre carros funerários. Leve-os para a Garagem do Sr. Esqueleto ou transporte seus parentes de A a B.",
		"As abóboras decorativas podem ser coletadas clicando nelas.",
		"Você pode encontrar abóboras por todo San Andreas.",
		"Uma abóbora apareceu na sua tela? Clique a tempo.",
		"Coloque totens. Totens dão pontos de experiência e abóboras a cada pagamento.",
		"Complete quests e receba chaves de Halloween, que podem ser usadas para abrir baús de ossos.",
	},
}

local shownHalloweenFacts = {}

function getRandomHalloweenFact(player)
	local language = apocalypseGetElementData(player,"language") or "EN"
	local facts = HalloweenFacts[language]
	if not facts then return "No facts available." end

	if not shownHalloweenFacts[player] then
		shownHalloweenFacts[player] = {}
	end

	local availableFacts = {}
	for i, fact in ipairs(facts) do
		if not shownHalloweenFacts[player][i] then
			table.insert(availableFacts, i)
		end
	end

	if #availableFacts == 0 then
		shownHalloweenFacts[player] = {}
		for i = 1, #facts do
			table.insert(availableFacts, i)
		end
	end

	local randomIndex = availableFacts[math.random(1, #availableFacts)]
	shownHalloweenFacts[player][randomIndex] = true

	return facts[randomIndex]
end

function giveHalloweenPumpkin(player,amount)
	if(ServerTime.GameDay == 6 or ServerTime.GameDay == 7)then amount = amount + 1 end
	triggerClientEvent(player,"onPumpkinAmountChange",player,hasPlayerItem(player,12)+amount)
	giveItem(player,12,amount)
	local collected_pumpkins = tonumber(getPlayerData("character_stats","character_id",getCharacterID(player),"collected_pumpkins"))
	Characters.addStats(player,"collected_pumpkins",collected_pumpkins+amount)
	local collected = tonumber(getPlayerData("server_event_data","ID",2,"community_progress"))
	dbExec(handler,"UPDATE server_event_data SET community_progress = '"..collected + amount.."' WHERE ID = '2'")
	outputLog(getPlayerName(player).." hat "..amount.." Kürbisse erhalten","Halloween Event",getCharacterID(player))
end
addEvent("giveHalloweenPumpkin",true)
addEventHandler("giveHalloweenPumpkin",root,giveHalloweenPumpkin)

addCommandHandler("toggleHalloween",function(player)
	if(isCharacterLoggedIn(player))then
		if(apocalypseGetElementData(player,"halloween_effects") == "on")then
			apocalypseSetElementData(player,"halloween_effects","off")
			loadPlayerWeather(player)
			triggerClientEvent(player,"resetSky",player)
		else
			apocalypseSetElementData(player,"halloween_effects","on")
			triggerClientEvent(player,"setSky",player)
		end
	end
end)