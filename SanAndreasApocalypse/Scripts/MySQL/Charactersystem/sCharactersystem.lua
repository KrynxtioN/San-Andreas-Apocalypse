Characters = {}
local CharacterData = {"money", "level", "experiencepoints", "experiencepointstotal", "playtime", "zombiekills", "tutorialtask", "freespins", "safemoney", "adminlevel","colony","activestatus", "hunger", "thirst","colonyrang","player_muscles","player_fat","equippedBadge"}

function getCharacterName(player)
	return apocalypseGetElementData(player, "CharacterName")
end

function isCharacterLoggedIn(player)
	if(apocalypseGetElementData(player, "Character:Status") == "LoggedIn")then
		return true
	else
		return false
	end
end

function getCharacterID(player)
	return apocalypseGetElementData(player, "CharacterID")
end

function Characters.addStats(player, stats, amount)
	local characterID = getCharacterID(player)
	dbExec(handler,"UPDATE character_stats SET "..stats.." = '"..amount.."' WHERE character_id = '"..characterID.."'")
	if(stats == "finished_quests")then
		local quests = getPlayerData("character_stats","ID",characterID,"finished_quests")
		if(quests == 5)then setAchievement(player,50) end
		if(quests == 10)then setAchievement(player,51) end
		if(quests == 25)then setAchievement(player,52) end
		if(quests == 50)then setAchievement(player,53) end
	end
end

local function setCharacterData(player)
	if(isPlayerBanned(player) == true)then kickPlayer(player,"Server","You are banned") end
	
	local CharacterID = getCharacterID(player)
	for _, v in pairs(CharacterData)do
		apocalypseSetElementData(player, v, getPlayerData("characters", "ID", CharacterID, v))
	end
	
	for i = 1,50 do outputChatBox(" ",player)end
	
	local result = dbPoll(dbQuery(handler,"SELECT * FROM character_stats WHERE character_id = '"..CharacterID.."'"),-1)
	if(#result == 0)then
		dbExec(handler,"INSERT INTO character_stats (character_id) VALUES ('"..CharacterID.."')")
	end
	
	setPlayerRank(player)
	setAchievement(player, 1)
	Payday.CreateTimer(player)
	
	apocalypseSetElementData(player, "CharacterName", getPlayerData("characters", "ID", CharacterID, "name"))
	Tutorial.start(player)
	loadPlayerItems(player)
	loadPlayerFurniture(player)
	loadPlayerKeys(player)
	Safezone.sendDataToClient(player)
	setPlayerName(player,getCharacterName(player))
	Colonys.setColonyName(player)
	loadPlayerClothes(player)
	setPlayerStatus(player)
	bindKey(player,"f6","down",Adminsystem.open)
	bindKey(player,"f7","down",Colonys.createMenu)
	PoliceBadges.createMarker(player)
	PoliceBatons.createPickup(player)
	loadPlayerOutfits(player)
	Vehiclesystem.bindKey(player)
	loadPlayerHeads(player)
	Coupons.loadPlayerCache(player)
	activateCouponTimer(player)
	loadPlayerBlips(player)
	CameraQuest.loadPlayerCollectibleCameras(player)
	Dumpster.createPlayerMarker(player)
	VehicleLoot.createPlayerMarker(player)
	TutorialPickups.create(player)
	PlayerWeapons.loadInventory(player)
	Shelter.createBlips(player)
	Nests.bindKey(player)
	Market.createPlayerPeds(player)
	DiscoverPlaces.playerLoad(player)
	bindKey(player,"h","down",Plantsystem.harvestWeed)
	RandomLootCrate.checkBlips(player)
	DoubleExperienceMessage(player)
	InfectedSurvivors.updateClientData(player)
	TreasureHunter.updateShellObjectData(player)
	bindKey(player,"e","down",TreasureHunter.startTreasureJob)
	bindKey(player,"e","down",VendingMachine.placeDynamite)
	CollectiblePickups.load(player,"HorseShoes")
	CollectiblePickups.load(player,"GTA3")
	CollectiblePickups.load(player,"Tiki")
	CollectiblePickups.load(player,"Package")
	setPlayerWeaponSkills(player)
	LaboratoryFights.CheckActiveFight(player)
	DailyTasks.loadTasks(player)
	WeeklyTasks.loadTasks(player)
	bindKey(player,"e","down",startLumberjackJob)
	showPlayerSafezones(player)
	bindKey(player,"e","down",OceanCleaner.start)
	BigfootClub.loadGate(player)
	activateNoFoodTimer(player)
	loadPlayerVehicles(player)
	triggerClientEvent(player,"updateStreetCleanerData",player,getPlayerData("character_stats","character_id",getCharacterID(player),"sweeper_trash"))
	CollectibleChainsaw.createPickup(player)
	CollectibleChainsaw.load(player)
	Graveyard.initPlayerFlowersDB(player)
	Sharks.loadPlayerData(player)
	BigfootClub.playerLoadData(player)
	MetalDetector.check(player)
	ExtraArmor.loadPlayerExtraArmor(player)
	AreaCard.loadData(player)
	Friends.checkOnline(player,"on")
	Moon.addTextures(player)
	loadPlayerWeather(player)
	TreasureMap.loadMarker(player)
	Achievements.loadPlayerAchievements(player)
	SpinosaurusClub.playerLoadData(player)
	BigfootCheckPhotoMarker(player)
	Status_playerBonusTimer(player)
	Fabrikwar.loadBlips(player)
	if(apocalypseGetElementData(player,"tutorialtask") >= 8)then
		addPlayerSpawn(player,1)
	end
	if(hasPlayerItem(player, 5) >= 1)then
		setQuest(player,32)
	end
	if(getQuest(player,34) ~= false)then
		if(getQuest(player,34) <= 1)then
			triggerClientEvent(player,"Alcohol_Quest.startQuest",player)
		end
	end
	
	local result = dbPoll(dbQuery(handler,"SELECT * FROM halloween_data WHERE character_id = '"..getCharacterID(player).."'"),-1)
	if(#result == 0)then
		dbExec(handler,"INSERT INTO halloween_data (character_id,deliveredPumpkins,shopLevel,chest1,chest2,chest3) VALUES ('"..getCharacterID(player).."','0','0','0','0','0')")
	end
	
	if(HalloweenEvent == true)then
		if(apocalypseGetElementData(player,"language") == "DE")then
			outputChatBox("#ffffff[#fa6400HALLOWEEN#ffffff] Tippe /#fa6400toggleHalloween#ffffff, um das Halloween Wetter aus- und anzuschalten.",player,255,255,255,true)
		else
			outputChatBox("#ffffff[#fa6400HALLOWEEN#ffffff] Type /#fa6400toggleHalloween#ffffff to turn the Halloween weather on or off.", player, 255, 255, 255, true)
		end
	end
	if(tonumber(getPlayerData("characters","ID",getCharacterID(player),"quest_wood_removed")) == 0)then
		triggerClientEvent(player,"MetalDetector.createClientWood",player)
	end
	
	local weekTime = tonumber(getPlayerData("characters","ID",getCharacterID(player),"WeekTime"))
	local weekTimeAFK = tonumber(getPlayerData("characters","ID",getCharacterID(player),"WeekTimeAFK"))
	local survivorPassLevel = tonumber(getPlayerData("characters","ID",getCharacterID(player),"survivorpass_level"))
	apocalypseSetElementData(player,"WeekTime",weekTime)
	apocalypseSetElementData(player,"WeekTimeAFK",weekTimeAFK)
	apocalypseSetElementData(player,"survivorpass_level",survivorPassLevel)
	DailyLogin.create(player)
	SpinosaurusClub.loadGate(player)
	SERVERBONUS.loadClient(player)
	RecruitedPlayersLoadData(player)
	Potions.playerBindKey(player)
	
	Sprintlevel.load(player)
	checkOfflineMessages(player)
	HalloweenTotem.load(player)
	loadPlayerColonyMissions(player)
	HungryThirstyPedMission.requestSync(player)
	UndergroundGarage.requestSync(player)
	
	if(isAdminLevel(player) >= 1)then
		addPlayerSpawn(player,4)
	else
		removePlayerSpawn(player,4)
	end
	
	local motelData = tonumber(getPlayerData("characters","ID",getCharacterID(player),"motel"))
	if(motelData == 1)then
		addPlayerSpawn(player,8)
	else
		removePlayerSpawn(player,8)
	end
	
	if(tonumber(apocalypseGetElementData(player,"level")) < 25)then
		triggerClientEvent(player,"Skillsystem.createGate",player)
	end
	triggerClientEvent(player,"updateCampfiresForAll",player)
	local Time = getRealTime()
	local Date = string.format("%02d.%02d.%04d", Time.monthday, Time.month + 1, Time.year + 1900)
	dbExec(handler,"UPDATE characters SET lastlogin = '"..Date.."' WHERE ID = '"..CharacterID.."'")
	
	if(ValentineEvent == true)then
		triggerClientEvent(player, "ValentinesDayCampfireUpdate", player)
		if(apocalypseGetElementData(player,"tutorialtask") >= 8)then
			triggerClientEvent(player, "openValentineEventInfo", player)
		end
	end
	
	applySpawnProtection(player,10)
	
	if(apocalypseGetElementData(player,"tutorialtask") >= 8)then
		Helpmenu.createHelpMarker(player)
		Documents.createHelpMarker(player)
	end
	
	if(HalloweenEvent == true)then
		triggerClientEvent(player,"addTimer",player,getCustomTimestamp(2026, 11, 5),"Halloween Event","halloween_event")
	end
	if(ValentineEvent == true)then
		triggerClientEvent(player,"addTimer",player,getCustomTimestamp(2026, 2, 24),"Valentine Event","valentine_event")
	end
	
	triggerClientEvent(player,"Killed_Bigfoot_Counter_Pickup_Update",player,getPlayerData("character_stats","character_id",getCharacterID(player),"killed_bigfoot"))
	
	-- // Update flag object if interior or dimension of the player is changed
	addEventHandler("onElementDimensionChange",player,function(oldDim,newDim)
		ColonyFlag.refreshFlagObject(player)
	end)

	addEventHandler("onElementInteriorChange",player,function(oldDim,newDim)
		ColonyFlag.refreshFlagObject(player)
	end)
	
	if(apocalypseGetElementData(player,"AFK") == true)then
		setElementFrozen(player,true)
	end
	
	SAALobby.addApocalypsePlayer()
	
	apocalypseSetElementData(player,"Lobby","Apocalypse")
	SAALobby.load(player)
end

function Characters.ServerLogin(player, CharacterID)
	local CharacterID = tonumber(CharacterID)
	local Serial = getPlayerSerial(player)
	local AccountSerial = getPlayerData("accounts", "name", apocalypseGetElementData(player, "AccountName"), "serial")

    triggerClientEvent(player,"LoginRegistrationArea.Destroy",player)
	setCameraTarget(player)

	apocalypseSetElementData(player, "CharacterID", CharacterID)
	apocalypseSetElementData(player, "Character:Status", "LoggedIn")
	triggerClientEvent(player, "HUD.load", player)
	triggerClientEvent(player, "Characters.DestroyWindow", player)
	triggerClientEvent(player, "Levelsystem.load", player)

	setCharacterData(player)
	
	PlayerSpawn.spawnPlayer(player)
	PlayerSpawn.giveHealth(player)
	
	setTimer(function(player)
		if(isElement(player))then
			createInfobox(player, getText(player, "SCharacter1"))
		end
	end, 1500, 1, player)
	
	if(Serial ~= AccountSerial)then
		triggerClientEvent(player, "Characters.Warning", player)
		apocalypseSetElementData(player, "Account:Status", "Blocked")
		toggleAllControls(player,  false)
	end
end

addEvent("Characters.ServerLogin", true)
addEventHandler("Characters.ServerLogin", root, function(CharacterID)
	Characters.ServerLogin(client, CharacterID)
end)

function Characters.Check(player)
	local result = dbPoll(dbQuery(handler, "SELECT * FROM characters WHERE owner_account_id = '"..apocalypseGetElementData(player, "AccountID").."'"), -1)
	if(#result == 0)then
		triggerClientEvent(player, "Characters.First", player)
	else
		triggerClientEvent(player, "Characters.Load", player)
	end
end

addEvent("Characters.Create", true)
addEventHandler("Characters.Create", root, function(name)
	if not name:match("^[A-Za-z0-9_-]+$") then
		createInfobox(getText(client,"SAccounts6"))
		return
	end

	local result = dbPoll(dbQuery(handler, "SELECT * FROM characters WHERE name = '"..name.."'"), -1)
	if(#result == 0)then
		local result = dbPoll(dbQuery(handler, "SELECT * FROM characters WHERE owner_account_id = '"..apocalypseGetElementData(client, "AccountID").."'"), -1)
		if(#result == 0)then
			triggerClientEvent(client, "destroyFirstCharacter", client)
		end
		dbExec(handler, "INSERT INTO characters (owner_account_id, name, status,furniture) VALUES ('"..apocalypseGetElementData(client, "AccountID").."', '"..name.."', '','')")
		triggerClientEvent(client, "LoginRegistrationArea.Destroy", client)
		triggerClientEvent(client, "Characters.DestroyWindow", client)
		setTimer(function(player)
			Characters.ServerLogin(player, getPlayerData("characters", "name", name, "ID"))
		end, 4000, 1, client)
	else
		createInfobox(client, getText(client, "SCharacter3"))
	end
end)

addEvent("Characters.LoadCharacters", true)
addEventHandler("Characters.LoadCharacters", root, function()
	local result = dbPoll(dbQuery(handler, "SELECT * FROM characters WHERE owner_account_id = '"..apocalypseGetElementData(client, "AccountID").."'"), -1)
	if(#result >= 1)then
		local tbl = {}
		for _, v in pairs(result)do
			table.insert(tbl, {v["name"], v["ID"], v["model"], v["playtime"], v["level"]})
		end
		triggerClientEvent(client, "Characters.refreshList", client, tbl)
	end
end)

addEvent("Characters.UpdateSerial", true)
addEventHandler("Characters.UpdateSerial", root, function()
	local Serial = getPlayerSerial(client)
	dbExec(handler, "UPDATE accounts SET serial = '"..Serial.."' WHERE ID = '"..apocalypseGetElementData(client, "AccountID").."'")
	local result = dbPoll(dbQuery(handler,"SELECT * FROM account_bans WHERE owner_account_id = '"..apocalypseGetElementData(client,"AccountID").."'"),-1)
	if(#result >= 1)then
		dbExec(handler,"UPDATE account_bans SET serial = '"..getPlayerSerial(client).."' WHERE owner_account_id = '"..apocalypseGetElementData(client,"AccountID").."')")
	end
	createInfobox(client, getText(client, "SCharacter2"))
	toggleAllControls(client,true)
	kickPlayer(client, "Server", "A reconnect is needed" )
end)

function Characters.SaveData(player)
	if(isCharacterLoggedIn(player))then
		local characterID = getCharacterID(player)
		for _, v in pairs(CharacterData)do
			dbExec(handler, "UPDATE characters SET "..v.." = '"..apocalypseGetElementData(player, v).."' WHERE ID = '"..characterID.."'")
		end
		dbExec(handler, "UPDATE characters SET health = '"..getElementHealth(player).."',  armor = '"..getPedArmor(player).."' WHERE ID = '"..characterID.."'")
		savePlayerClothes(player)
	end
end

addEventHandler("onPlayerQuit",root,function()
	if(isCharacterLoggedIn(source))then
		Characters.SaveData(source)
	end
	if(apocalypseGetElementData(source,"Lobby") == "Apocalypse")then
		SAALobby.removeApocalypsePlayer()
	end
end)