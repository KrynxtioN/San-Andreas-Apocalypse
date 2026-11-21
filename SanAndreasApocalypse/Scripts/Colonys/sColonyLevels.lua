function giveColonyEXP(player, amount)
	if(isCharacterLoggedIn(player))then
		if(player and amount)then
			local amount = tonumber(amount)
			if(amount >= 1)then
				local colony = tonumber(apocalypseGetElementData(player,"colony"))
				if(colony > 0)then
					local level = tonumber(getPlayerData("colonys","ID",colony,"level"))
					local experiencePoints = tonumber(getPlayerData("colonys","ID",colony,"experiencepoints"))
					local experiencePointsTotal = tonumber(getPlayerData("colonys","ID",colony,"experiencepointstotal"))
					local needExperience = 2500 * (level + 1) + ((level + 1) * 25)
					
					if(experiencePoints + amount >= needExperience)then
						local PlayersEXP = needExperience - experiencePoints
						dbExec(handler,"UPDATE colonys SET experiencepoints = '0', experiencepointstotal = '"..experiencePointsTotal + (amount-PlayersEXP).."', level = '"..level + 1 .."' WHERE ID = '"..colony.."'")
						level = level + 1
						
						for _,v in pairs(getElementsByType("player"))do
							if(isCharacterLoggedIn(v))then
								if(tonumber(apocalypseGetElementData(v,"colony")) == tonumber(colony))then
									outputChatBox("["..getText(v,"SColonys12").."] "..getText(v,"SColonys13"),v,255,255,255)
								end
							end
						end
						
						if(level % 5 == 0) then
							local player_slots = tonumber(getPlayerData("colonys","ID",colony,"player_slots"))
							local vehicle_slots = tonumber(getPlayerData("colonys","ID",colony,"vehicle_slots"))
							dbExec(handler,"UPDATE colonys SET player_slots = ?, vehicle_slots = ? WHERE ID = ?", player_slots + 1, vehicle_slots + 1, colony)
							
							for _,v in pairs(getElementsByType("player"))do
								if(isCharacterLoggedIn(v))then
									if(tonumber(apocalypseGetElementData(v,"colony")) == tonumber(colony))then
										outputChatBox("["..getText(v,"SColonys12").."] "..getText(v,"SColonys14"),v,255,255,255)
									end
								end
							end
						end
						
						if(amount - PlayersEXP > 0)then giveColonyEXP(player, amount-PlayersEXP) end
						outputLog("Kolonie "..colony.." ist auf Level "..level.." aufgestiegen","Kolonie")
						outputLog("Kolonie "..colony.." hat "..amount.." EXP bekommen","Kolonie")
					else
						dbExec(handler,"UPDATE colonys SET experiencepoints = '"..experiencePoints + amount.."', experiencepointstotal = '"..experiencePointsTotal + amount.."' WHERE ID = '"..colony.."'")
					end
				end
			end
		end
	end
end
addEvent("giveColonyEXP",true)
addEventHandler("giveColonyEXP", root, giveColonyEXP)

addEvent("getColonyLevelData",true)
addEventHandler("getColonyLevelData",root,function()
	local colony = apocalypseGetElementData(client,"colony")
	local level = getPlayerData("colonys","ID",colony,"level")
	local experiencepoints = getPlayerData("colonys","ID",colony,"experiencepoints")
	local experiencepointstotal = getPlayerData("colonys","ID",colony,"experiencepointstotal")
	local killed_zombies = getPlayerData("colonys","ID",colony,"killed_zombies")
	triggerClientEvent(client,"Colonys.updateLevelData",client,level,experiencepoints,experiencepointstotal,killed_zombies)
end)

function giveColonyMoney(player,amount)
	if(isCharacterLoggedIn(player))then
		if(player and amount)then
			local amount = tonumber(amount)
			if(amount >= 1)then
				local colony = apocalypseGetElementData(player,"colony")
				if(colony >= 1)then
					local money = tonumber(getPlayerData("colonys","ID",colony,"money"))
					dbExec(handler,"UPDATE colonys SET money = '"..money + amount.."' WHERE ID = '"..colony.."'")
					outputLog("Kolonie "..colony.." hat $"..amount.." bekommen","Kolonie")
				end
			end
		end
	end
end

function giveColonyEXPByID(colonyID, amount)
    if (not colonyID or not amount) then return false end

    colonyID = tonumber(colonyID)
    amount   = tonumber(amount)

    if (not colonyID or colonyID < 1) then return false end
    if (not amount or amount < 1) then return false end

    local level = tonumber(getPlayerData("colonys", "ID", colonyID, "level")) or 0
    local experiencePoints = tonumber(getPlayerData("colonys", "ID", colonyID, "experiencepoints")) or 0
    local experiencePointsTotal = tonumber(getPlayerData("colonys", "ID", colonyID, "experiencepointstotal")) or 0

    local needExperience = 2500 * (level + 1) + ((level + 1) * 25)

    if (experiencePoints + amount >= needExperience) then
        local playersEXP = needExperience - experiencePoints
        local rest = amount - playersEXP

        dbExec(handler,
            "UPDATE colonys SET experiencepoints = '0', experiencepointstotal = ?, level = ? WHERE ID = ?",
            experiencePointsTotal + amount, level + 1, colonyID
        )
        level = level + 1

        for _, v in pairs(getElementsByType("player")) do
            if (isCharacterLoggedIn(v)) then
                if (tonumber(apocalypseGetElementData(v, "colony")) == colonyID) then
                    outputChatBox(getText(v,"SColonys13"), v, 0,255,0)
                end
            end
        end

        if (level % 5 == 0) then
            local player_slots  = tonumber(getPlayerData("colonys", "ID", colonyID, "player_slots")) or 0
            local vehicle_slots = tonumber(getPlayerData("colonys", "ID", colonyID, "vehicle_slots")) or 0

            dbExec(handler,
                "UPDATE colonys SET player_slots = ?, vehicle_slots = ? WHERE ID = ?",
                player_slots + 1, vehicle_slots + 1, colonyID
            )

            for _, v in pairs(getElementsByType("player")) do
                if (isCharacterLoggedIn(v)) then
                    if (tonumber(apocalypseGetElementData(v, "colony")) == colonyID) then
                        outputChatBox(getText(v,"SColonys14"), v, 0,255,0)
                    end
                end
            end
        end
		
		outputLog("Kolonie "..colonyID.." ist auf Level "..level.." aufgestiegen","Kolonie")
		outputLog("Kolonie "..colonyID.." hat "..amount.." EXP bekommen","Kolonie")

        if (rest > 0) then
            return giveColonyEXPByID(colonyID, rest)
        end

        return true
    else
        dbExec(handler,
            "UPDATE colonys SET experiencepoints = ?, experiencepointstotal = ? WHERE ID = ?",
            experiencePoints + amount, experiencePointsTotal + amount, colonyID
        )
        return true
    end
end

function giveColonyMoneyByID(colonyID, amount)
    if (not colonyID or not amount) then return false end

    colonyID = tonumber(colonyID)
    amount   = tonumber(amount)

    if (not colonyID or colonyID < 1) then return false end
    if (not amount or amount < 1) then return false end

    local money = tonumber(getPlayerData("colonys","ID",colonyID,"money")) or 0
    dbExec(handler, "UPDATE colonys SET money = ? WHERE ID = ?", money + amount, colonyID)
	outputLog("Kolonie "..colonyID.." hat $"..amount.." bekommen","Kolonie")
	
    return true
end

function giveColonyBrainmassByID(colonyID, amount)
    if (not colonyID or not amount) then return false end

    colonyID = tonumber(colonyID)
    amount   = tonumber(amount)

    if (not colonyID or colonyID < 1) then return false end
    if (not amount or amount < 1) then return false end

    local brainmass = tonumber(getPlayerData("colonys","ID",colonyID,"brainmass")) or 0
    dbExec(handler, "UPDATE colonys SET brainmass = ? WHERE ID = ?", brainmass + amount, colonyID)
	outputLog("Kolonie "..colonyID.." hat "..amount.." Hirnmasse bekommen","Kolonie")
    return true
end

function giveColonyLevelUpByID(colonyID)
    if (not colonyID) then return false end

    colonyID = tonumber(colonyID)
    if (not colonyID or colonyID < 1) then return false end

    local level = tonumber(getPlayerData("colonys", "ID", colonyID, "level")) or 0
    local experiencePoints = tonumber(getPlayerData("colonys", "ID", colonyID, "experiencepoints")) or 0

    local needExperience = 2500 * (level + 1) + ((level + 1) * 25)
    local missingEXP = needExperience - experiencePoints

    if (missingEXP <= 0) then
        missingEXP = 1
    end

    return giveColonyEXPByID(colonyID, missingEXP)
end