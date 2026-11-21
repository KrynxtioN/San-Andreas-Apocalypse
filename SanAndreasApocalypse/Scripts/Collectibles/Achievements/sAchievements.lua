local P_Ach = {}

function Achievements.loadPlayerAchievements(player)
	if(not(P_Ach[player]))then P_Ach[player] = {} end
	for i = 1, #Achievements["Achievements"][apocalypseGetElementData(player,"language") or "EN"] do
		P_Ach[player][i] = false
	end
	
	local characterID = getCharacterID(player)
	local playerAchievements = getPlayerData("characters", "ID", characterID, "achievements") 
	
	if(not(playerAchievements))then
		dbExec(handler, "UPDATE characters SET achievements = '' WHERE ID = '"..characterID.."'")
		playerAchievements = getPlayerData("characters", "ID", characterID, "achievements")
	end
	
	local values = split(playerAchievements, "|")
	
	for _,v in pairs(values)do P_Ach[player][v] = true end
end

function Achievements.updatePlayerAchievement(player,ID)
	if(not(ID))then return end
	local ID = tonumber(ID)
	
	if(P_Ach[player] and P_Ach[player][ID])then
		P_Ach[player][ID] = true
	end
end

function hasAchievement(player, ID)
	if(not(ID))then return end
	local ID = tonumber(ID)
	
	if(P_Ach[player] and P_Ach[player][ID])then
		return P_Ach[player][ID]
	else
		return
	end
end

function setAchievement(player,  ID)
	local ID = tonumber(ID)
	if(hasAchievement(player,ID) == false)then
		local characterID = getCharacterID(player)
		local playerAchievements = getPlayerData("characters", "ID", characterID, "achievements")
		local Table = Achievements["Achievements"][apocalypseGetElementData(player, "language") or "EN"][tonumber(ID)]
		dbExec(handler, "UPDATE characters SET achievements = '"..playerAchievements..ID.."|' WHERE ID = '"..characterID.."'")
		triggerClientEvent(player, "Achievements.reached", player, Table[1], {Table[2][1], Table[2][2]})
		Achievements.updatePlayerAchievement(player,ID)
		
		givePlayerServerMoney(player,Table[2][2])
		giveEXP(player, Table[2][1])
		outputLog(getPlayerName(player).." hat Achievement "..ID.." erreicht", "Achievements", getCharacterID(player))
	end
end
addEvent("setAchievement", true)
addEventHandler("setAchievement", root, setAchievement)

addEvent("Achievements.getData", true)
addEventHandler("Achievements.getData", root, function()

    local Data = {}
    local language = apocalypseGetElementData(client, "language") or "EN"
    local achievementsTable = Achievements["Achievements"][language]

    local owned = {}
    local playerAchievements = getPlayerData("characters", "ID", getCharacterID(client), "achievements")

    if playerAchievements and playerAchievements ~= "" then
        local values = split(playerAchievements, "|")
        for _, v in ipairs(values) do
            local id = tonumber(v)
            if id then
                owned[id] = true
            end
        end
    end

    for achievementID, Table in pairs(achievementsTable) do
        table.insert(Data, {
            id = achievementID,
            name = Table[1],
            description = getText(client, "SAchievements1"):format(Table[3], Table[2][1], Table[2][2]),
            unlocked = owned[achievementID] or false
        })
    end

    triggerClientEvent(client, "Collectibles.updateData", client, Data)
end)