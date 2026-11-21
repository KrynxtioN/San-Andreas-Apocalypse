Colonys = {inviteData = {}, inviteTimer = {}}
local Status

local BONUS_DURATIONS = {
    [1] = 6 * 60 * 60,    -- 6h
    [2] = 6 * 60 * 60,    -- 6h
    [3] = 12 * 60 * 60,   -- 12h
    [4] = 12 * 60 * 60,   -- 12h
    [5] = 168 * 60 * 60,  -- 168h
    [6] = 168 * 60 * 60   -- 168h
}

local NeededLabors = {
	[1] = 2,
	[2] = 4,
	[3] = 6,
	[4] = 8,
	[5] = 10,
	[6] = 15,
}

function Colonys.updatePlayerBlips()
	for _,v in pairs(getElementsByType("player")) do
		if isCharacterLoggedIn(v) then
			triggerClientEvent(v,"Colonys.createPlayerBlips",v)
		end
	end
end

function Colonys.setColonyName(player)
	if tonumber(apocalypseGetElementData(player,"colony")) == 0 or not apocalypseGetElementData(player,"colony") then
		apocalypseSetElementData(player,"ColonyName","Dillimore's Hope")
	end
	if tonumber(apocalypseGetElementData(player,"colony")) >= 1 then
		local colonyName = getPlayerData("colonys","ID",apocalypseGetElementData(player,"colony"),"name")
		apocalypseSetElementData(player,"ColonyName",colonyName)
	end
	Colonys.updatePlayerBlips()
end

function getColonyColor(ID)
	ID = tonumber(ID)
	if ID and ID >= 1 then
		local color_r = getPlayerData("colonys","ID",ID,"color_r")
		local color_g = getPlayerData("colonys","ID",ID,"color_g")
		local color_b = getPlayerData("colonys","ID",ID,"color_b")
		return {color_r,color_g,color_b}
	end
end

addEvent("Colonys.create",true)
addEventHandler("Colonys.create",root,function(name)
	if tonumber(apocalypseGetElementData(client,"colony")) == 0 then
		if isPlayerInParty(client) == false then
			if tonumber(apocalypseGetElementData(client,"money")) >= 2500 and hasPlayerItem(client,1) >= 1000 then
				local result = dbPoll(dbQuery(handler,"SELECT * FROM colonys WHERE name = ?", name),-1)
				if #result == 0 then
					apocalypseSetElementData(client,"money",apocalypseGetElementData(client,"money")-2500)
					takeItem(client,1,1000)
					dbExec(handler,"INSERT INTO colonys (name,level,experiencepoints,player_slots,vehicle_slots,experiencepointstotal,exp_distance,killed_zombies,tasks,trash_kilo,trash,trash_started,trash_status,trash_timer,money,saved_experience_from_trash,saved_money_from_trash) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
						name,0,0,5,1,0,20,0,"",0,0,0,100,"",0,0,0
					)
					local ID = getPlayerData("colonys","name",name,"ID")
					apocalypseSetElementData(client,"colony",ID)
					Colonys.setColonyName(client)
					dbExec(handler,"UPDATE characters SET colony = ? WHERE ID = ?", ID, getCharacterID(client))
					createInfobox(client,getText(client,"SColonys11"))
					setAchievement(client,57)
					apocalypseSetElementData(client,"colonyrang",5)
					triggerClientEvent(client,"closeWindow",client)
					local joinDate = os.date("%Y-%m-%d %H:%M:%S")
					dbExec(handler,"UPDATE characters SET colony_join_date = ?, colonyrang = ? WHERE ID = ?", joinDate, 5, getCharacterID(client))
				else
					createInfobox(client,getText(client,"SColonys10"))
				end
			else
				NPC.NormalMessage(client,getText(client,"SColonys15"))
			end
		else
			NPC.NormalMessage(client,getText(client,"SColonys17"))
		end
	else
		NPC.NormalMessage(client,getText(client,"SColonys16"))
	end
end)

function Colonys.createMenu(player)
	if tonumber(apocalypseGetElementData(player,"colony")) >= 1 then
		triggerClientEvent(player,"Colonys.createMenu",player,Colonys.getMenuPlayerData(player))
	end
end

function Colonys.getMenuPlayerData(player)
	local colonyID = apocalypseGetElementData(player,"colony")
	local result = dbPoll(dbQuery(handler,"SELECT * FROM characters WHERE colony = ?", colonyID),-1)
	local member = {}

	if #result >= 1 then
		for _,v in pairs(result) do
			local status = "Offline"
			if isElement(getPlayerFromName(v["name"])) then
				if isCharacterLoggedIn(getPlayerFromName(v["name"])) then
					status = "Online"
				end
			end
			table.insert(member,{v["name"],v["colony_warns"],v["colonyrang"],v["colony_join_date"],v["lastlogin"],status})
		end
	end
	return member
end

addCommandHandler("acceptInvite",function(player)
	if Colonys.inviteData[player] and Colonys.inviteData[player].colony then
		if apocalypseGetElementData(player,"colony") == 0 then
			apocalypseSetElementData(player,"colony",Colonys.inviteData[player].colony)
			apocalypseSetElementData(player,"ColonyName",Colonys.inviteData[player].colonyName)
			createInfobox(player,getText(player,"SColonys5"):format(Colonys.inviteData[player].colonyName))
			for _,v in pairs(getElementsByType("player")) do
				if isCharacterLoggedIn(v) then
					if apocalypseGetElementData(v,"colony") == Colonys.inviteData[player].colony then
						outputChatBox(getText(v,"SColonys6"):format(getPlayerName(player)),v,0,255,0)
					end
				end
			end
			Colonys.updatePlayerBlips()
			local joinDate = os.date("%Y-%m-%d %H:%M:%S")
			dbExec(handler,"UPDATE characters SET colony = ?, colonyrang = ?, colony_join_date = ? WHERE ID = ?", Colonys.inviteData[player].colony, 0, joinDate, getCharacterID(player))
			Colonys.inviteData[player] = nil
			loadPlayerColonyMissions(player)
		else
			createInfobox(player,getText(player,"SColonys7"))
		end
	else
		createInfobox(player,getText(player,"SColonys28"))
	end
end)

addEvent("Colonys.invite",true)
addEventHandler("Colonys.invite",root,function(character_name)
	local invitePlayer = getPlayerFromName(character_name)
	if isElement(invitePlayer) and isCharacterLoggedIn(invitePlayer) then
		if apocalypseGetElementData(client,"colonyrang") >= 5 then
			if apocalypseGetElementData(invitePlayer,"colony") == 0 then
				if(not(Colonys.inviteData[invitePlayer]))then
					Colonys.inviteData[invitePlayer] = {
						colony = apocalypseGetElementData(client,"colony"),
						colonyName = apocalypseGetElementData(client,"ColonyName")
					}
					outputChatBox(getText(invitePlayer,"SColonys3"):format(getPlayerName(client),apocalypseGetElementData(client,"ColonyName")), invitePlayer)
					createInfobox(client,getText(client,"SColonys4"):format(getPlayerName(invitePlayer)))
					
					Colonys.inviteTimer[invitePlayer] = setTimer(function(invitePlayer)
						if(isElement(invitePlayer))then
							Colonys.inviteData[invitePlayer] = nil
						end
					end,60000,1,invitePlayer)
				else
					createInfobox(client,getText(client,"SColonys27"))
				end
			else
				createInfobox(client,getText(client,"SColonys2"))
			end
		else
			createInfobox(client,getText(client,"SColonys19"))
		end
	else
		createInfobox(client,getText(client,"SColonys1"))
	end
end)

addEvent("Colonys.uninvite",true)
addEventHandler("Colonys.uninvite",root,function(character_name)
	local kickPlayer = getPlayerFromName(character_name)
	if isElement(kickPlayer) and isCharacterLoggedIn(kickPlayer) then
		if apocalypseGetElementData(client,"colonyrang") >= 5 then
			if apocalypseGetElementData(kickPlayer,"colony") == apocalypseGetElementData(client,"colony") then
				apocalypseSetElementData(kickPlayer,"colony",0)
				apocalypseSetElementData(kickPlayer,"colonyrang",0)
				apocalypseSetElementData(kickPlayer,"ColonyName","Dillimore's Hope")

				outputChatBox(getText(kickPlayer,"SColonys8"),kickPlayer)
				for _,v in pairs(getElementsByType("player")) do
					if isCharacterLoggedIn(v) then
						if apocalypseGetElementData(v,"colony") == apocalypseGetElementData(client,"colony") then
							if v ~= client then
								outputChatBox(getText(v,"SColonys9"):format(getPlayerName(kickPlayer)),v)
							end
						end
					end
				end
				createInfobox(client,getText(client,"SColonys9"):format(getPlayerName(kickPlayer)))
				Colonys.setColonyName(kickPlayer)
				unloadPlayerColonySystems(kickPlayer)
				dbExec(handler,"UPDATE characters SET colony = ?, colonyrang = ?, colony_warns = ?, colony_join_date = ? WHERE ID = ?", 0, 0, 0, "", getCharacterID(kickPlayer))
			end
		else
			createInfobox(client,getText(client,"SColonys19"))
		end
	else
		createInfobox(client,getText(client,"SColonys20"))
	end
end)

addEvent("Colonys.giveWarn",true)
addEventHandler("Colonys.giveWarn",root,function(target)
	local targetColony = getPlayerData("characters","name",target,"colony")
	if tonumber(targetColony) == apocalypseGetElementData(client,"colony") then
		if apocalypseGetElementData(client,"colonyrang") >= 4 then
			local targetWarns = tonumber(getPlayerData("characters","name",target,"colony_warns")) or 0
			dbExec(handler,"UPDATE characters SET colony_warns = ? WHERE name = ?", targetWarns + 1, target)
			triggerClientEvent(client,"Colonys.updateClientData",client,Colonys.getMenuPlayerData(client))
		else
			createInfobox(client,getText(client,"SColonys18"))
		end
	end
end)

addEvent("Colonys.removeWarn",true)
addEventHandler("Colonys.removeWarn",root,function(target)
	local targetColony = getPlayerData("characters","name",target,"colony")
	if tonumber(targetColony) == apocalypseGetElementData(client,"colony") then
		if apocalypseGetElementData(client,"colonyrang") >= 4 then
			local targetWarns = tonumber(getPlayerData("characters","name",target,"colony_warns")) or 0
			if targetWarns >= 1 then
				dbExec(handler,"UPDATE characters SET colony_warns = ? WHERE name = ?", targetWarns - 1, target)
				triggerClientEvent(client,"Colonys.updateClientData",client,Colonys.getMenuPlayerData(client))
			end
		else
			createInfobox(client,getText(client,"SColonys18"))
		end
	end
end)

addEvent("Colonys.rangUp",true)
addEventHandler("Colonys.rangUp",root,function(target)
	local targetColony = getPlayerData("characters","name",target,"colony")
	local targetPlayer = getPlayerFromName(target)
	if tonumber(targetColony) == apocalypseGetElementData(client,"colony") then
		if apocalypseGetElementData(client,"colonyrang") >= 5 then
			local targetRang = tonumber(getPlayerData("characters","name",target,"colonyrang")) or 0
			if targetRang < 5 then
				if isElement(targetPlayer) then
					apocalypseSetElementData(targetPlayer,"colonyrang",targetRang + 1)
					createInfobox(targetPlayer,getText(targetPlayer,"SColonys21"))
				end
				dbExec(handler,"UPDATE characters SET colonyrang = ? WHERE name = ?", targetRang + 1, target)
				triggerClientEvent(client,"Colonys.updateClientData",client,Colonys.getMenuPlayerData(client))
				createInfobox(client,getText(client,"SColonys23"))
			else
				createInfobox(client,getText(client,"SColonys25"))
			end
		else
			createInfobox(client,getText(client,"SColonys19"))
		end
	end
end)

addEvent("Colonys.rangDown",true)
addEventHandler("Colonys.rangDown",root,function(target)
	local targetColony = getPlayerData("characters","name",target,"colony")
	local targetPlayer = getPlayerFromName(target)
	if tonumber(targetColony) == apocalypseGetElementData(client,"colony") then
		if apocalypseGetElementData(client,"colonyrang") >= 5 then
			local targetRang = tonumber(getPlayerData("characters","name",target,"colonyrang")) or 0
			if targetRang > 0 then
				if isElement(targetPlayer) then
					apocalypseSetElementData(targetPlayer,"colonyrang",targetRang - 1)
					createInfobox(targetPlayer,getText(targetPlayer,"SColonys22"))
				end
				dbExec(handler,"UPDATE characters SET colonyrang = ? WHERE name = ?", targetRang - 1, target)
				triggerClientEvent(client,"Colonys.updateClientData",client,Colonys.getMenuPlayerData(client))
				createInfobox(client,getText(client,"SColonys24"))
			else
				createInfobox(client,getText(client,"SColonys26"))
			end
		else
			createInfobox(client,getText(client,"SColonys19"))
		end
	end
end)

function Colonys.getMemberOnline(ColonyID)
	local amount = 0
	for _,v in pairs(getElementsByType("player")) do
		if apocalypseGetElementData(v,"colony") == ColonyID then
			amount = amount + 1
		end
	end
	return amount
end

function Colonys.getTrashItems(player)
	if not player then player = client end
	local tbl = {}
	for _,v in pairs(TradeableItems) do
		if hasPlayerItem(player,v) >= 1 then
			table.insert(tbl,{
				v,
				ItemInfos["items"][apocalypseGetElementData(player,"language") or "EN"][v],
				hasPlayerItem(player,v),
				ItemBasicValue[v].experience,
				ItemBasicValue[v].money
			})
		end
	end
	triggerClientEvent(player,"Colonys.updateTrashItems",player,tbl)
end
addEvent("Colonys.getTrashItems",true)
addEventHandler("Colonys.getTrashItems",root,Colonys.getTrashItems)

function Colonys.giveMoney(colony,money)
	if colony and money then
		local oldMoney = tonumber(getPlayerData("colonys","ID",colony,"money")) or 0
		local newMoney = oldMoney + money
		dbExec(handler,"UPDATE colonys SET money = ? WHERE ID = ?", newMoney, colony)
		outputLog("Kolonie "..colony.." hat $"..money.." bekommen","Kolonie")
	end
end

function Colonys.takeMoney(colony,money)
	if colony and money then
		local oldMoney = tonumber(getPlayerData("colonys","ID",colony,"money")) or 0
		local newMoney = oldMoney - money
		dbExec(handler,"UPDATE colonys SET money = ? WHERE ID = ?", newMoney, colony)
	end
end

function getColonyMoney(colony)
	local oldMoney = tonumber(getPlayerData("colonys","ID",colony,"money")) or 0
	return oldMoney
end

function Colonys.getWarehouseData(player)
	if not player then player = client end
	local warehouseStates = {}

	for i = 1, #ColonyWarehouse["Costs"] do
		local result = dbPoll(dbQuery(handler, "SELECT * FROM colony_warehouse WHERE warehouse_id = ? AND colony = ? LIMIT 1", i, apocalypseGetElementData(player,"colony")), -1)

		if result and result[1] then
			table.insert(warehouseStates, {id = i, owned = true})
		else
			table.insert(warehouseStates, {id = i, owned = false})
		end
	end
	triggerClientEvent(player, "Colonys.updateWarehouse", player, warehouseStates)
end
addEvent("Colonys.getWarehouseData", true)
addEventHandler("Colonys.getWarehouseData", root, Colonys.getWarehouseData)

function Colonys.Payday()
    local result = dbPoll(dbQuery(handler, "SELECT ID FROM colonys"), -1)
    if not result then return end

    for _, v in ipairs(result) do
        local colonyID = tonumber(v.ID)
		local Area_Money,Area_Experience,Area_Brain_Mass = 0,0,0
		local Shelter_EXP, Shelter_Money, Shelter_Brain_Mass = 0,0,0

        if colonyID and colonyID >= 1 then
            local ownedAreas = LaboratoryFights.getAreaPaydayMoney(colonyID)
			Area_Money,Area_Experience,Area_Brain_Mass = ownedAreas[1],ownedAreas[2],ownedAreas[3]

			local shelterColony = tonumber(getPlayerData("shelter","ID",ColonyFlag.ownerShelter,"colony"))
			local shelterLevel = tonumber(getPlayerData("shelter","ID",ColonyFlag.ownerShelter,"level")) or 0
			if colonyID == shelterColony then
				Shelter_EXP = 350 + (shelterLevel * 10)
				Shelter_Money = 1250
				Shelter_Brain_Mass = 25 + (shelterLevel * 2)
			end

			for _,plr in pairs(getElementsByType("player")) do
				if isCharacterLoggedIn(plr) then
					if tonumber(apocalypseGetElementData(plr,"colony")) == colonyID then
						outputChatBox(getText(plr,"SColonyPayday1"),plr,0,175,0)
						outputChatBox(getText(plr,"SColonyPayday2"):format(ownedAreas[4],Area_Money,Area_Experience,Area_Brain_Mass),plr,0,150,0)
						if Shelter_EXP > 0 then
							outputChatBox(getText(plr,"SColonyPayday3"):format(Shelter_Money, Shelter_EXP, Shelter_Brain_Mass),plr,0,150,0)
						else
							outputChatBox(getText(plr,"SColonyPayday4"):format(1250, 350 + (shelterLevel * 10), 25 + (shelterLevel * 2)),plr,150,0,0)
						end
					end
				end
			end

			local All_EXP = Area_Experience + Shelter_EXP
			local All_Money = Area_Money + Shelter_Money
			local All_Brain_Mass = Area_Brain_Mass + Shelter_Brain_Mass

			giveColonyEXPByID(colonyID, All_EXP)
			giveColonyMoneyByID(colonyID, All_Money)
			giveColonyBrainmassByID(colonyID, All_Brain_Mass)
        end
    end
end
setTimer(Colonys.Payday,3600000,0)

local function getUnixTime()
    return os.time()
end

local function formatTime(seconds)
    seconds = math.max(0, tonumber(seconds) or 0)

    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = seconds % 60

    return string.format("%02d:%02d:%02d", h, m, s)
end

local function cleanupExpiredColonyBonus(colonyId, bonusId)
	dbExec(handler, [[
		DELETE FROM colony_bonus_timer
		WHERE colony_id = ? AND bonus_id = ? AND active_until <= ?
	]], colonyId, bonusId, getUnixTime())
end

function createOrUpdateColonyBonus(colonyId, bonusId, duration)
    if not colonyId or not bonusId or not duration then
        return false
    end

    local activeUntil = getUnixTime() + duration

	dbExec(handler, [[
		DELETE FROM colony_bonus_timer
		WHERE colony_id = ? AND bonus_id = ?
	]], colonyId, bonusId)

    dbExec(handler, [[
        INSERT INTO colony_bonus_timer (colony_id, bonus_id, active_until)
        VALUES (?, ?, ?)
    ]], colonyId, bonusId, activeUntil)

    return activeUntil
end

function isColonyBonusActive(colonyId, bonusId)
	cleanupExpiredColonyBonus(colonyId, bonusId)

    local result = dbPoll(dbQuery(handler, [[
        SELECT active_until
        FROM colony_bonus_timer
        WHERE colony_id = ? AND bonus_id = ?
        ORDER BY active_until DESC
        LIMIT 1
    ]], colonyId, bonusId), -1)

    if result and result[1] then
        local activeUntil = tonumber(result[1].active_until) or 0
        return activeUntil > getUnixTime(), activeUntil
    end

    return false, 0
end

function getColonyBonusRemaining(colonyId, bonusId)
    local active, activeUntil = isColonyBonusActive(colonyId, bonusId)
    if not active then
        return 0
    end

    return math.max(0, activeUntil - getUnixTime())
end

function removeExpiredColonyBonus(colonyId, bonusId)
    dbExec(handler, [[
        DELETE FROM colony_bonus_timer
        WHERE colony_id = ? AND bonus_id = ? AND active_until <= ?
    ]], colonyId, bonusId, getUnixTime())
end

addEvent("Colonys.activateBonus", true)
addEventHandler("Colonys.activateBonus", root, function(BonusID)
    local player = client or source
    local bonusId = tonumber(BonusID)

    if not bonusId or bonusId < 1 or bonusId > 6 then
        return
    end

    local colonyId = tonumber(getElementData(player, "colony")) or tonumber(apocalypseGetElementData(player, "colony"))
    if not colonyId or colonyId <= 0 then
		createInfobox(player,getText(player,"SColonyBonus1"))
        return
    end

    local active, activeUntil = isColonyBonusActive(colonyId, bonusId)
    if active then
		local remaining = activeUntil - os.time()
		NPC.MeMessage(player,getText(player,"SColonyBonus2"):format(formatTime(remaining)))
        return
    end

    local duration = BONUS_DURATIONS[bonusId]
    if not duration then
        return
    end
	
	local requiredLabors = NeededLabors[bonusId] or 0
	local colonyAreas = LaboratoryFights.getColonyAreas(colonyId)
	local ownedLabors = #colonyAreas

	if ownedLabors < requiredLabors then
		createInfobox(player,getText(player,"SColonys29"):format(requiredLabors,ownedLabors,requiredLabors))
		return
	end

    local newUntil = createOrUpdateColonyBonus(colonyId, bonusId, duration)
    if not newUntil then
        return
    end

	local colony_online = 0
	for _,v in pairs(getElementsByType("player")) do
		if isCharacterLoggedIn(v) then
			if tonumber(apocalypseGetElementData(v,"colony")) == colonyId then
				colony_online = colony_online + 1
			end
		end
	end

	local colony_level = tonumber(getPlayerData("colonys","ID",colonyId,"level")) or 0

    if bonusId == 1 then
		local EXP = (500 * colony_level) + (750 * colony_online)
		giveColonyEXPByID(colonyId,EXP)
        createInfobox(player,getText(player,"SColonyBonus3"))

		for _,v in pairs(getElementsByType("player")) do
			if isCharacterLoggedIn(v) then
				if apocalypseGetElementData(v,"colony") == colonyId then
					outputChatBox(getText(v,"SColonyBonus4"):format(EXP),v,0,255,0)
				end
			end
		end
    end

    if bonusId == 2 then
		local Bonusmoney = (125 * colony_level) + (125 * colony_online)
		Colonys.giveMoney(colonyId,Bonusmoney)
        createInfobox(player,getText(player,"SColonyBonus3"))

		for _,v in pairs(getElementsByType("player")) do
			if isCharacterLoggedIn(v) then
				if apocalypseGetElementData(v,"colony") == colonyId then
					outputChatBox(getText(v,"SColonyBonus5"):format(Bonusmoney),v,0,255,0)
				end
			end
		end
    end

    if bonusId == 3 then
		local brain_mass = (10 * colony_level) + (10 * colony_online)

		createInfobox(player,getText(player,"SColonyBonus3"))

		for _,v in pairs(getElementsByType("player")) do
			if isCharacterLoggedIn(v) then
				if apocalypseGetElementData(v,"colony") == colonyId then
					outputChatBox(getText(v,"SColonyBonus6"):format(brain_mass),v,0,255,0)
				end
			end
		end
    end

    if bonusId == 4 then
		local loot_items = 250 + (10 * colony_online)
		createInfobox(player,getText(player,"SColonyBonus3"))

		for _,v in pairs(getElementsByType("player")) do
			if isCharacterLoggedIn(v) then
				if apocalypseGetElementData(v,"colony") == colonyId then
					outputChatBox(getText(v,"SColonyBonus7"):format(loot_items),v,0,255,0)
				end
			end
		end
    end

    if bonusId == 5 then
        createInfobox(player,getText(player,"SColonyBonus3"))
		local player_slots  = tonumber(getPlayerData("colonys", "ID", colonyId, "player_slots")) or 0
        local vehicle_slots = tonumber(getPlayerData("colonys", "ID", colonyId, "vehicle_slots")) or 0

		dbExec(handler,
            "UPDATE colonys SET player_slots = ?, vehicle_slots = ? WHERE ID = ?",
            player_slots + 1, vehicle_slots + 1, colonyId
        )

		for _,v in pairs(getElementsByType("player")) do
			if isCharacterLoggedIn(v) then
				if apocalypseGetElementData(v,"colony") == colonyId then
					outputChatBox(getText(v,"SColonyBonus8"),v,0,255,0)
				end
			end
		end
    end

    if bonusId == 6 then
        createInfobox(player,getText(player,"SColonyBonus3"))
		giveColonyLevelUpByID(colonyId)
		for _,v in pairs(getElementsByType("player")) do
			if isCharacterLoggedIn(v) then
				if apocalypseGetElementData(v,"colony") == colonyId then
					outputChatBox(getText(v,"SColonyBonus9"),v,0,255,0)
				end
			end
		end
    end
	
	if(bonusId >= 1 and bonusId <= 6)then
		outputLog(getPlayerName(client).." (Kolonie: "..apocalypseGetElementData(client,"colony")..") hat Bonus "..bonusId.." aktiviert","Kolonie",getCharacterID(client))
	end
end)

addEvent("Colonys.getBonusTimer",true)
addEventHandler("Colonys.getBonusTimer",root,function(bonus_timer)
	local bonus_timer = tonumber(bonus_timer)
	local colonyId = tonumber(apocalypseGetElementData(client,"colony")) or 0
	local timer = getColonyBonusRemaining(colonyId, bonus_timer)
	triggerClientEvent(client,"Colonys.updateBonusTimer",client,timer)
end)

addEvent("Colonys.checkLevel",true)
addEventHandler("Colonys.checkLevel",root,function()
	local colony = tonumber(apocalypseGetElementData(client,"colony"))
	if(colony >= 1)then
		local colony_level = getPlayerData("colonys","ID",colony,"level")
		triggerClientEvent(client,"Colonys.deactivateTabs",client,colony_level)
	end
end)

addEventHandler("onPlayerQuit",root,function()
	if isCharacterLoggedIn(source) then
		Colonys.updatePlayerBlips()
	end
end)