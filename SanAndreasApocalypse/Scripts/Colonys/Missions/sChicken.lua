local CHICKEN_MISSION_ID = "find_chickens"
local MAX_CHICKEN_ID = 5

function getCollectedChickens(colony)
    local query = dbQuery(
        handler,
        "SELECT collect_id FROM colony_mission_collects WHERE colony = ? AND mission_id = ?",
        tostring(colony),
        CHICKEN_MISSION_ID
    )

    local result = dbPoll(query, -1)

    local collected = {}

    if result then
        for _, row in ipairs(result) do
            local collectId = tonumber(row.collect_id)

            if collectId then
                collected[collectId] = true
            end
        end
    end

    return collected
end


function loadChickenMissionForPlayer(player)
    if not isElement(player) then
        return false
    end

    local colony = apocalypseGetElementData(
        player,
        "colony"
    )

    if not colony then
        return false
    end

    if not isColonyMissionActive(
        colony,
        CHICKEN_MISSION_ID
    ) then
        triggerClientEvent(
            player,
            "colonyChickensClear",
            player
        )

        return false
    end

    local language = getPlayerLanguage(player)

    triggerClientEvent(
        player,
        "colonyChickensLoad",
        player,
        getCollectedChickens(colony),
        language
    )

    return true
end


function refreshChickenMissionForColony(colony)
    if not colony then
        return false
    end

    local collected = getCollectedChickens(colony)

    for _, player in ipairs(getElementsByType("player")) do
        local playerColony = apocalypseGetElementData(
            player,
            "colony"
        )

        if playerColony
        and tostring(playerColony) == tostring(colony) then
            local language = getPlayerLanguage(player)

            triggerClientEvent(
                player,
                "colonyChickensLoad",
                player,
                collected,
                language
            )
        end
    end

    return true
end


function clearChickenMissionForColony(colony)
    if not colony then
        return false
    end

    for _, player in ipairs(getElementsByType("player")) do
        local playerColony = apocalypseGetElementData(
            player,
            "colony"
        )

        if playerColony
        and tostring(playerColony) == tostring(colony) then
            triggerClientEvent(
                player,
                "colonyChickensClear",
                player
            )
        end
    end

    return true
end


addEvent("colonyChickenCollect", true)

addEventHandler("colonyChickenCollect", root, function(chickenId)
    local player = client

    if not player or not isElement(player) then
        return
    end

    local colony = apocalypseGetElementData(
        player,
        "colony"
    )

    if not colony then
        return
    end

    chickenId = tonumber(chickenId)

    if not chickenId then
        return
    end

    if chickenId < 1 or chickenId > MAX_CHICKEN_ID then
        return
    end

    if not isColonyMissionActive(
        colony,
        CHICKEN_MISSION_ID
    ) then
        return
    end

    local checkQuery = dbQuery(
        handler,
        [[
            SELECT collect_id
            FROM colony_mission_collects
            WHERE colony = ?
            AND mission_id = ?
            AND collect_id = ?
            LIMIT 1
        ]],
        tostring(colony),
        CHICKEN_MISSION_ID,
        chickenId
    )

    local checkResult = dbPoll(
        checkQuery,
        -1
    )

    if checkResult
    and checkResult[1] then
        return
    end

    dbExec(
        handler,
        [[
            INSERT IGNORE INTO colony_mission_collects
                (colony, mission_id, collect_id)
            VALUES
                (?, ?, ?)
        ]],
        tostring(colony),
        CHICKEN_MISSION_ID,
        chickenId
    )

    local query = dbQuery(
        handler,
        [[
            SELECT COUNT(*) AS amount
            FROM colony_mission_collects
            WHERE colony = ?
            AND mission_id = ?
        ]],
        tostring(colony),
        CHICKEN_MISSION_ID
    )

    local result = dbPoll(
        query,
        -1
    )

    local amount = 0

    if result
    and result[1] then
        amount = tonumber(
            result[1].amount
        ) or 0
    end

    setColonyMissionProgress(
        player,
        CHICKEN_MISSION_ID,
        amount,
        "set"
    )

    if amount < MAX_CHICKEN_ID then
        refreshChickenMissionForColony(
            colony
        )
    end
end)