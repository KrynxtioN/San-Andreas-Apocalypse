CommunityTask = {}

function CommunityTask.addZombieKill(player)
    if isCharacterLoggedIn(player) then
        local charID = getCharacterID(player)
        local kills = tonumber(getPlayerData("characters", "ID", charID, "weekly_zombie_kills")) or 0
        kills = kills + 1
        dbExec(handler, "UPDATE characters SET weekly_zombie_kills = ? WHERE ID = ?", kills, charID)
    end
end

function CommunityTask.giveZombieRewards()
    local result = dbPoll(dbQuery(handler, "SELECT ID, name, weekly_zombie_kills FROM characters WHERE weekly_zombie_kills > 0 ORDER BY weekly_zombie_kills + 0 DESC, ID ASC LIMIT 10"), -1)
    if result and #result > 0 then
        for i, row in ipairs(result) do
            local charID = tonumber(row["ID"])
            local kills = tonumber(row["weekly_zombie_kills"])
            local player = getPlayerFromCharacterID(charID)

            local money, experience, skillpoints = 0, 0, 0

            if i == 1 then
                money, experience, skillpoints = 10000, 35000, 75
            elseif i >= 2 and i <= 4 then
                money, experience, skillpoints = 7500, 17500, 50
            elseif i >= 5 and i <= 9 then
                money, experience, skillpoints = 5000, 8750, 25
            elseif i == 10 then
                money, experience, skillpoints = 2500, 4375, 10
            end

            if player and isCharacterLoggedIn(player) then
				local Level_Bonus_EXP = tonumber(apocalypseGetElementData(player,"level"))
				if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
				local bonus = (experience/100*5) * Level_Bonus_EXP
				experience = experience + bonus
                givePlayerServerMoney(player, money)
                giveEXP(player, experience)
                givePlayerSkillpoint(player, skillpoints)
                outputChatBox(getText(player, "SCommunityTask1"):format(i), player, 0, 255, 0)
                if i == 1 then
                    outputChatBox(getText(player, "SCommunityTask2"):format(money, experience, skillpoints), player, 0, 255, 0)
                else
                    outputChatBox(getText(player, "SCommunityTask3"):format(money, experience, skillpoints), player, 0, 255, 0)
                end
			else
				local experiencePoints = tonumber(getPlayerData("characters", "ID", charID, "experiencepoints")) or 0
				local experiencePointsTotal = tonumber(getPlayerData("characters", "ID", charID, "experiencepointstotal")) or 0
				local player_Skillpoints = tonumber(getPlayerData("characters", "ID", charID, "skillpoints")) or 0
				local player_Money = tonumber(getPlayerData("characters", "ID", charID, "money")) or 0
				local player_Level = tonumber(getPlayerData("characters", "ID", charID, "level")) or 0
				local player_owner_account = tonumber(getPlayerData("characters", "ID", charID, "owner_account_id"))
				local player_language = getPlayerData("accounts","ID",player_owner_account,"language")
				
				local bonus = (experience/100*5) * player_Level
				local amount = experience + bonus
				while amount > 0 do
					local needExperience = 250 * (player_Level + 1) + ((player_Level + 1) * 25)
					if experiencePoints + amount >= needExperience then
						local needed = needExperience - experiencePoints
						amount = amount - needed
						experiencePoints = 0
						player_Level = player_Level + 1
						addOfflineMessage(charID, getTextOffline(player_language,"SOfflineMessage1"):format(player_Level))
					else
						experiencePoints = experiencePoints + amount
						amount = 0
					end
				end

				dbExec(handler,
					"UPDATE characters SET experiencepoints = ?, experiencepointstotal = ?, skillpoints = ?, money = ?, level = ? WHERE ID = ?",
					experiencePoints, experiencePointsTotal + experience, player_Skillpoints + skillpoints, player_Money + money, player_Level, charID
				)

				addOfflineMessage(charID, getTextOffline(player_language,"SOfflineMessage2"):format(i))
				if i == 1 then
					addOfflineMessage(charID, getTextOffline(player_language,"SOfflineMessage3"):format(money,experience,skillpoints))
				else
					addOfflineMessage(charID, getTextOffline(player_language,"SOfflineMessage4"):format(money,experience,skillpoints))
				end
			end
        end
    end

    CommunityTask.resetZombieKills()
end

function CommunityTask.resetZombieKills()
    dbExec(handler, "UPDATE characters SET weekly_zombie_kills = 0")
end

function CommunityTask.loadZombieKills()
    local tbl = {}
    local myRank = nil
    local playerCharID = getCharacterID(client)

    local result = dbPoll(dbQuery(handler, "SELECT name, weekly_zombie_kills, ID FROM characters WHERE weekly_zombie_kills > 0 ORDER BY weekly_zombie_kills + 0 DESC, ID ASC"), -1)
    if (result and #result >= 1) then
        local count = 0
        for i, v in ipairs(result) do
            if count < 10 then
                table.insert(tbl, {v["name"], tonumber(v["weekly_zombie_kills"])})
                count = count + 1
            end
            if tonumber(v["ID"]) == playerCharID then
                myRank = {
                    rank = i,
                    kills = tonumber(v["weekly_zombie_kills"])
                }
            end
        end
    end

    triggerClientEvent(client, "CommunityTask.loadClientZombieKills", client, tbl, myRank)
end
addEvent("CommunityTask.loadZombieKills", true)
addEventHandler("CommunityTask.loadZombieKills", root, CommunityTask.loadZombieKills)

function getPlayerFromCharacterID(charID)
    for _, player in ipairs(getElementsByType("player")) do
        if getCharacterID(player) == tonumber(charID) then
            return player
        end
    end
    return nil
end