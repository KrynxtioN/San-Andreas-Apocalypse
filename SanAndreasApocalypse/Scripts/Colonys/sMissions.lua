local supportedLanguages = {
    EN = true,
    DE = true,
    RU = true,
    PT = true
}

local missions = {
    ["find_chickens"] = {
        title = {
            EN = "Find 5 chickens",
            DE = "5 Hühner finden",
            RU = "Найти 5 кур",
            PT = "Encontrar 5 galinhas"
        },

        goal = 5,
        rewardMoney = 5000
    }
}

local serverTexts = {
    EN = {
        rewardMoney = "You received $%s for completing the mission."
    },

    DE = {
        rewardMoney = "Du hast $%s für den Missionsabschluss erhalten."
    },

    RU = {
        rewardMoney = "Вы получили $%s за выполнение миссии."
    },

    PT = {
        rewardMoney = "Você recebeu $%s por concluir a missão."
    }
}


function getPlayerColony(player)
    return apocalypseGetElementData(player, "colony")
end


function getPlayerLanguage(player)
    if not isElement(player) then
        return "EN"
    end

    local language = apocalypseGetElementData(player, "language") or "EN"

    language = tostring(language):upper()

    if not supportedLanguages[language] then
        language = "EN"
    end

    return language
end


function getMissionTitle(missionId, language)
    local missionInfo = missions[missionId]

    if not missionInfo then
        return tostring(missionId)
    end

    language = tostring(language or "EN"):upper()

    if not supportedLanguages[language] then
        language = "EN"
    end

    if type(missionInfo.title) == "table" then
        return missionInfo.title[language]
            or missionInfo.title.EN
            or tostring(missionId)
    end

    return tostring(missionInfo.title)
end


function getServerText(language, key, ...)
    language = tostring(language or "EN"):upper()

    if not supportedLanguages[language] then
        language = "EN"
    end

    local text = nil

    if serverTexts[language] then
        text = serverTexts[language][key]
    end

    if not text and serverTexts.EN then
        text = serverTexts.EN[key]
    end

    if not text then
        return key
    end

    if select("#", ...) > 0 then
        return string.format(text, ...)
    end

    return text
end


function isColonyMissionActive(colony, missionId)
    local query = dbQuery(
        handler,
        "SELECT id FROM colony_missions WHERE colony = ? AND mission_id = ? AND active = 1",
        tostring(colony),
        missionId
    )

    local result = dbPoll(query, -1)

    return result and result[1] ~= nil
end


function loadPlayerColonyMissions(player)
    if not isElement(player) then
        return false
    end

    local colony = getPlayerColony(player)

    if not colony then
        return false
    end

    local language = getPlayerLanguage(player)

    local query = dbQuery(
        handler,
        "SELECT mission_id, progress FROM colony_missions WHERE colony = ? AND active = 1",
        tostring(colony)
    )

    local result = dbPoll(query, -1)

    local sendMissions = {}

    if result then
        for _, row in ipairs(result) do
            local missionInfo = missions[row.mission_id]

            if missionInfo then
                table.insert(sendMissions, {
                    id = row.mission_id,
                    title = getMissionTitle(row.mission_id, language),
                    progress = tonumber(row.progress) or 0,
                    goal = missionInfo.goal
                })
            end
        end
    end

    triggerClientEvent(
        player,
        "colonyMissionsReceive",
        player,
        sendMissions,
        language
    )

    if type(loadChickenMissionForPlayer) == "function" then
        loadChickenMissionForPlayer(player)
    end

    return true
end


function giveColonyMission(colony, missionId)
    if not colony then
        return false
    end

    local missionInfo = missions[missionId]

    if not missionInfo then
        return false
    end

    if missionId == "find_chickens" then
        dbExec(
            handler,
            "DELETE FROM colony_mission_collects WHERE colony = ? AND mission_id = ?",
            tostring(colony),
            missionId
        )
    end

    dbExec(
        handler,
        [[
            INSERT INTO colony_missions
                (colony, mission_id, progress, active)
            VALUES
                (?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE
                active = 1,
                progress = 0
        ]],
        tostring(colony),
        missionId,
        0,
        1
    )

    refreshColonyPlayers(colony)

    if missionId == "find_chickens"
    and type(refreshChickenMissionForColony) == "function" then
        refreshChickenMissionForColony(colony)
    end

    return true
end


function removeColonyMission(colony, missionId)
    if not colony then
        return false
    end

    dbExec(
        handler,
        "UPDATE colony_missions SET active = 0 WHERE colony = ? AND mission_id = ?",
        tostring(colony),
        missionId
    )

    refreshColonyPlayers(colony)

    if missionId == "find_chickens"
    and type(clearChickenMissionForColony) == "function" then
        clearChickenMissionForColony(colony)
    end

    return true
end


function refreshColonyPlayers(colony)
    for _, player in ipairs(getElementsByType("player")) do
        local playerColony = getPlayerColony(player)

        if playerColony
        and tostring(playerColony) == tostring(colony) then
            loadPlayerColonyMissions(player)
        end
    end
end


function updateMissionForColony(colony, missionId, progress)
    local missionInfo = missions[missionId]

    if not missionInfo then
        return false
    end

    for _, player in ipairs(getElementsByType("player")) do
        local playerColony = getPlayerColony(player)

        if playerColony
        and tostring(playerColony) == tostring(colony) then
            local language = getPlayerLanguage(player)

            triggerClientEvent(
                player,
                "colonyMissionsUpdate",
                player,
                {
                    id = missionId,
                    title = getMissionTitle(missionId, language),
                    progress = progress,
                    goal = missionInfo.goal
                },
                language
            )
        end
    end

    return true
end


function setColonyMissionProgress(player, missionId, amount, mode)
    if not isElement(player) then
        return false
    end

    local colony = getPlayerColony(player)

    if not colony then
        return false
    end

    local missionInfo = missions[missionId]

    if not missionInfo then
        return false
    end

    amount = tonumber(amount) or 0
    mode = mode or "add"

    local query = dbQuery(
        handler,
        "SELECT progress FROM colony_missions WHERE colony = ? AND mission_id = ? AND active = 1",
        tostring(colony),
        missionId
    )

    local result = dbPoll(query, -1)

    if not result or not result[1] then
        return false
    end

    local oldProgress = tonumber(result[1].progress) or 0
    local newProgress = oldProgress

    if mode == "set" then
        newProgress = amount

    elseif mode == "remove" then
        newProgress = oldProgress - amount

    else
        newProgress = oldProgress + amount
    end

    if newProgress < 0 then
        newProgress = 0
    end

    if newProgress > missionInfo.goal then
        newProgress = missionInfo.goal
    end

    dbExec(
        handler,
        "UPDATE colony_missions SET progress = ? WHERE colony = ? AND mission_id = ?",
        newProgress,
        tostring(colony),
        missionId
    )

    updateMissionForColony(
        colony,
        missionId,
        newProgress
    )

    if newProgress >= missionInfo.goal then
        finishColonyMission(
            player,
            colony,
            missionId
        )
    end

    return true
end


function finishColonyMission(player, colony, missionId)
    local missionInfo = missions[missionId]

    if not missionInfo then
        return false
    end

    dbExec(
        handler,
        "UPDATE colony_missions SET active = 0 WHERE colony = ? AND mission_id = ?",
        tostring(colony),
        missionId
    )

    giveColonyMissionReward(
        player,
        colony,
        missionId
    )

    if missionId == "find_chickens"
    and type(clearChickenMissionForColony) == "function" then
        clearChickenMissionForColony(colony)
    end

    for _, target in ipairs(getElementsByType("player")) do
        local targetColony = getPlayerColony(target)

        if targetColony
        and tostring(targetColony) == tostring(colony) then
            local language = getPlayerLanguage(target)

            triggerClientEvent(
                target,
                "colonyMissionFinished",
                target,
                getMissionTitle(missionId, language),
                language
            )

            loadPlayerColonyMissions(target)
        end
    end

    return true
end


function giveColonyMissionReward(player, colony, missionId)
    local missionInfo = missions[missionId]

    if not missionInfo then
        return false
    end

    if isElement(player) and missionInfo.rewardMoney then
        local language = getPlayerLanguage(player)

        givePlayerServerMoney(
            player,
            missionInfo.rewardMoney
        )

        createInfobox(player,getServerText(language,"rewardMoney",missionInfo.rewardMoney))
    end

    return true
end


function unloadPlayerColonySystems(player)
    if not isElement(player) then
        return false
    end

    local language = getPlayerLanguage(player)

    triggerClientEvent(
        player,
        "colonyMissionsReceive",
        player,
        {},
        language
    )

    triggerClientEvent(
        player,
        "colonyChickensClear",
        player
    )

    return true
end


addEvent("colonyMissionsLoad", true)
addEventHandler("colonyMissionsLoad", root, function()
    if not client or not isElement(client) then
        return
    end

    loadPlayerColonyMissions(client)
end)