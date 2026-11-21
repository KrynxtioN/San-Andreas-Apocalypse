function Skillsystem.sendManagerData(player)
    if not isElement(player) then return end

    local playerID = getCharacterID(player)
    local skillpoints = tonumber(getPlayerData("characters", "ID", playerID, "skillpoints")) or 0
    local data = {}

    for id, costs in pairs(Skillsystem["Data"]) do
        local level = tonumber(getSkillLevel(player, id)) or 0
        local maxLevel = #costs
        local cost = costs[level + 1] or 0

        data[id] = {
            level = level,
            maxLevel = maxLevel,
            cost = cost
        }
    end

    triggerClientEvent(player, "Skillsystem.receiveManagerData", player, data, skillpoints)
end

addEvent("Skillsystem.requestManagerData", true)
addEventHandler("Skillsystem.requestManagerData", root, function()
    Skillsystem.sendManagerData(client)
end)

addEvent("Skillsystem.managerBuyUpgrade", true)
addEventHandler("Skillsystem.managerBuyUpgrade", root, function(ID)
    ID = tonumber(ID)
    if not ID or not Skillsystem["Data"][ID] then return end

    local playerID = getCharacterID(client)
    local skillLevel = tonumber(getSkillLevel(client, ID)) or 0
    local maxLevel = #Skillsystem["Data"][ID]
    local cost = Skillsystem["Data"][ID][skillLevel + 1] or 0
    local skillpoints = tonumber(getPlayerData("characters", "ID", playerID, "skillpoints")) or 0

    if skillLevel >= maxLevel then
        createInfobox(client, getText(client, "SSkillsystem3"))
        Skillsystem.sendManagerData(client)
        return
    end

    if skillpoints < cost then
        createInfobox(client, getText(client, "SSkillsystem1"))
        Skillsystem.sendManagerData(client)
        return
    end

    increaseSkillLevel(client, ID)

    dbExec(handler, "UPDATE characters SET skillpoints = ? WHERE ID = ?", skillpoints - cost, playerID)

    if ID == 4 then
        local vehicle_slots = tonumber(getPlayerData("characters", "ID", playerID, "vehicle_slots")) or 0
        dbExec(handler, "UPDATE characters SET vehicle_slots = ? WHERE ID = ?", vehicle_slots + 1, playerID)
    end

    createInfobox(client, getText(client, "SSkillsystem2"))

    outputLog(
        "[SKILL] " .. getPlayerName(client) .. " hat über die Skillverwaltung ein neues Skillevel erreicht (Skill ID: " .. ID .. ", Level: " .. skillLevel + 1 .. ", Kosten: " .. cost .. " Skillpunkte)",
        "Skillsystem",
        playerID
    )

    Skillsystem.sendManagerData(client)
    Skillsystem.getWindowData(client, ID)
end)