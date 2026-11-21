Toplist = {
    ["Marker"] = {
        {218.36470031738, -270.0032043457, 0.52389997243881},
        {-2195.7495117188, 2412.0100097656, 3.9818000793457},
        {-1999.1169433594, 180.9759979248, 26.539100646973},
    },

    ["Allowed"] = {
        ["Data"] = {
            experiencepointstotal = true,
            zombiekills = true,
            playtime = true,
            money = true,
            level = true,
        },

        ["Stats"] = {
            finished_quest = true,
            looted_vehicles = true,
            looted_dumpsters = true,
            looted_houses = true,
            looted_places = true,
            killed_infected_survivors = true,
            planted = true,
            harvested = true,
            killed_animals = true,
            npc_gifted = true,
            destroyed_wood = true,
            looted_garages = true,
            airdrops_collected = true,
            destroyed_nest = true,
            saved_survivors = true,
            rhinos_destroyed = true,
            catched_fish = true,
            cooked_fish = true,
            found_treasures = true,
            sweeper_trash = true,
            oil_delivery = true,
            ocean_cleaned = true,
            casino_safe_destroyed = true,
            cut_trees = true,
            trees_to_wood = true,
            mining = true,
            metal_detector_looted = true,
            bonuspoints_collectibles = true,
            shooter_arena_killed_players = true,
            races_top3 = true,

            vehicle_loot_record = true,

            hearse_delivered = true,
            skeletons_taxi = true,
            killed_pumpkin_zombies = true,
            collected_pumpkins = true,
        }
    },

    ["Cache"] = {
        ["data"] = {},
        ["stats"] = {},
        ["lastUpdate"] = 0,
        ["isRefreshing"] = false,
    }
}

for _, v in pairs(Toplist["Marker"]) do
    local marker = createMarker(v[1], v[2], v[3], "cylinder", 1.5, 255, 255, 255, 50)

    addEventHandler("onMarkerHit", marker, function(player)
        if not isElement(player) then
            return
        end

        if not isPedInVehicle(player) then
            if getElementDimension(player) == getElementDimension(source) then
                triggerClientEvent(player, "Toplist.openWindow", player)
            end
        end
    end)
end

local function toNumber(value)
    return tonumber(value) or 0
end

local function buildRanking(entries)
    table.sort(entries, function(a, b)
        local av = toNumber(a.value)
        local bv = toNumber(b.value)

        if av == bv then
            return tostring(a.name or "") < tostring(b.name or "")
        end

        return av > bv
    end)

    local result = {
        top = {},
        valueById = {},
        rankById = {},
    }

    local lastValue = nil
    local lastRank = 0

    for i, entry in ipairs(entries) do
        local currentValue = toNumber(entry.value)

        if lastValue == nil or currentValue ~= lastValue then
            lastRank = i
            lastValue = currentValue
        end

        result.rankById[entry.id] = lastRank
        result.valueById[entry.id] = currentValue

        if i <= 10 then
            table.insert(result.top, {entry.name, currentValue})
        end
    end

    return result
end

local function finishRefresh(success, newDataCache, newStatsCache)
    if success then
        Toplist.Cache.data = newDataCache or Toplist.Cache.data
        Toplist.Cache.stats = newStatsCache or Toplist.Cache.stats
        Toplist.Cache.lastUpdate = getRealTime().timestamp
        outputDebugString("[Toplist] Cache erfolgreich aktualisiert.", 3)
    else
        outputDebugString("[Toplist] Cache-Aktualisierung fehlgeschlagen. Alter Cache bleibt erhalten.", 1)
    end

    Toplist.Cache.isRefreshing = false
end

local function refreshToplistCache()
    if Toplist.Cache.isRefreshing then
        outputDebugString("[Toplist] Refresh übersprungen, da bereits einer läuft.", 2)
        return
    end

    Toplist.Cache.isRefreshing = true

	local charQuery = [[
		SELECT
			ID,
			name,
			money,
			safemoney,
			experiencepointstotal,
			zombiekills,
			playtime,
			level
		FROM characters
		WHERE banned = 0 OR banned IS NULL
	]]

    dbQuery(
        function(charQueryHandle)
            if not charQueryHandle then
                finishRefresh(false)
                return
            end

            local charRows = dbPoll(charQueryHandle, 0)
            dbFree(charQueryHandle)

            if not charRows then
                outputDebugString("[Toplist] Fehler beim Laden von characters.", 1)
                finishRefresh(false)
                return
            end

            local charactersById = {}
            local newDataCache = {}

            for _, row in ipairs(charRows) do
                local charId = tonumber(row.ID)

                if charId then
                    charactersById[charId] = {
                        id = charId,
                        name = row.name or "Unbekannt",
                        money = toNumber(row.money) + toNumber(row.safemoney),
                        experiencepointstotal = toNumber(row.experiencepointstotal),
                        zombiekills = toNumber(row.zombiekills),
                        playtime = toNumber(row.playtime),
                        level = toNumber(row.level),
                    }
                end
            end

            for dataName, _ in pairs(Toplist.Allowed.Data) do
                local entries = {}

                for charId, row in pairs(charactersById) do
                    table.insert(entries, {
                        id = charId,
                        name = row.name,
                        value = row[dataName] or 0,
                    })
                end

                newDataCache[dataName] = buildRanking(entries)
            end

            local statColumns = {}
            for columnName, _ in pairs(Toplist.Allowed.Stats) do
                table.insert(statColumns, columnName)
            end

            table.sort(statColumns)

            local statsQuery = "SELECT character_id, " .. table.concat(statColumns, ", ") .. " FROM character_stats"

            dbQuery(
                function(statsQueryHandle)
                    if not statsQueryHandle then
                        finishRefresh(false)
                        return
                    end

                    local statRows = dbPoll(statsQueryHandle, 0)
                    dbFree(statsQueryHandle)

                    if not statRows then
                        outputDebugString("[Toplist] Fehler beim Laden von character_stats.", 1)
                        finishRefresh(false)
                        return
                    end

                    local newStatsCache = {}

                    for _, columnName in ipairs(statColumns) do
                        local entries = {}

                        for _, row in ipairs(statRows) do
                            local charId = tonumber(row.character_id)
                            local charData = charId and charactersById[charId]

                            if charId and charData then
                                table.insert(entries, {
                                    id = charId,
                                    name = charData.name,
                                    value = toNumber(row[columnName]),
                                })
                            end
                        end

                        newStatsCache[columnName] = buildRanking(entries)
                    end

                    finishRefresh(true, newDataCache, newStatsCache)
                end,
                handler,
                statsQuery
            )
        end,
        handler,
        charQuery
    )
end

local function getCachedRanking(cacheType, dataName)
    if cacheType == "data" then
        return Toplist.Cache.data[dataName]
    elseif cacheType == "stats" then
        return Toplist.Cache.stats[dataName]
    end

    return nil
end

local function firstToplistLoad()
    refreshToplistCache()

    setTimer(function()
        refreshToplistCache()
    end, 60 * 60 * 1000, 0)
end
firstToplistLoad()

addEvent("Toplist.getData", true)
addEventHandler("Toplist.getData", root, function(data)
    if not client or not isElement(client) then
        return
    end

    if not Toplist.Allowed.Data[data] then
        outputDebugString("[Toplist] Ungültige Data-Anfrage: " .. tostring(data), 2)
        return
    end

    local ranking = getCachedRanking("data", data)
    if not ranking then
        triggerClientEvent(client, "Toplist.setData", client, {}, data, 0, 0, getCharacterName(client))
        return
    end

    local charId = tonumber(getCharacterID(client))
    local playerName = getCharacterName(client)
    local playerValue = ranking.valueById[charId] or 0
    local playerRank = ranking.rankById[charId] or 0

    triggerClientEvent(client, "Toplist.setData", client, ranking.top, data, playerRank, playerValue, playerName)
end)

addEvent("Toplist.getStats", true)
addEventHandler("Toplist.getStats", root, function(data, label)
    if not client or not isElement(client) then
        return
    end

    if not Toplist.Allowed.Stats[data] then
        outputDebugString("[Toplist] Ungültige Stats-Anfrage: " .. tostring(data), 2)
        return
    end

    local ranking = getCachedRanking("stats", data)
    if not ranking then
        triggerClientEvent(client, "Toplist.setStats", client, {}, data, 0, 0, getCharacterName(client), label)
        return
    end

    local charId = tonumber(getCharacterID(client))
    local playerName = getCharacterName(client)
    local playerValue = ranking.valueById[charId] or 0
    local playerRank = ranking.rankById[charId] or 0

    triggerClientEvent(client, "Toplist.setStats", client, ranking.top, data, playerRank, playerValue, playerName, label)
end)

addEvent("Toplist.getRecords", true)
addEventHandler("Toplist.getRecords", root, function(data)
    if not client or not isElement(client) then
        return
    end

    if not Toplist.Allowed.Stats[data] then
        return
    end

    local ranking = getCachedRanking("stats", data)
    if not ranking then
        triggerClientEvent(client, "Toplist.setRecords", client, {}, data, 0, 0, getCharacterName(client))
        return
    end

    local charId = tonumber(getCharacterID(client))
    local playerName = getCharacterName(client)
    local playerValue = ranking.valueById[charId] or 0
    local playerRank = ranking.rankById[charId] or 0

    triggerClientEvent(client, "Toplist.setRecords", client, ranking.top, data, playerRank, playerValue, playerName)
end)