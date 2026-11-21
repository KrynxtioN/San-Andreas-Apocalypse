DailyLogin = {}

local function getTodayString()
    return os.date("%Y-%m-%d")
end

local function dateToTime(dateStr)
    if not dateStr or dateStr == "1970-01-01" then return 0 end

    local y, m, d = dateStr:match("(%d+)-(%d+)-(%d+)")
    if not y then return 0 end

    return os.time({
        year = tonumber(y),
        month = tonumber(m),
        day = tonumber(d),
        hour = 12
    })
end

local function timeToDateString(timeValue)
    return os.date("%Y-%m-%d", timeValue)
end

local function getWeekStartTime()
    local now = os.date("*t")
    local todayTime = os.time({
        year = now.year,
        month = now.month,
        day = now.day,
        hour = 12
    })

    local weekDay = tonumber(os.date("%w", todayTime))
    if weekDay == 0 then weekDay = 7 end

    return todayTime - ((weekDay - 1) * 86400)
end

local function getCurrentWeekStartString()
    return timeToDateString(getWeekStartTime())
end

local function getDayDiff(lastClaimDate)
    local lastTime = dateToTime(lastClaimDate)
    if lastTime == 0 then return 9999 end

    local now = os.date("*t")
    local todayTime = os.time({
        year = now.year,
        month = now.month,
        day = now.day,
        hour = 12
    })

    return math.floor((todayTime - lastTime) / 86400)
end

local function isNewDay(lastClaimDate)
    return getDayDiff(lastClaimDate) >= 1
end

local function emptyClaimed()
    return {false,false,false,false,false,false,false}
end

local function claimedToString(claimed)
    local str = {}

    for i = 1,7 do
        str[#str + 1] = claimed[i] and "1" or "0"
    end

    return table.concat(str, ",")
end

local function stringToClaimed(claimedStr)
    local claimed = emptyClaimed()
    local parts = split(claimedStr or "0,0,0,0,0,0,0", ",")

    for i = 1,7 do
        claimed[i] = tonumber(parts[i]) == 1
    end

    return claimed
end

local function hasWeekChanged(weekStartDate)
    local currentWeekStart = getCurrentWeekStartString()
    return weekStartDate ~= currentWeekStart
end

function DailyLogin.getDailyData(player)
    local CharacterID = getCharacterID(player)
    if not CharacterID then return nil end

    local qh = dbQuery(
        handler,
        "SELECT claimed, canclaim, lastClaimDate, weeklyStreak, weekStartDate FROM dailylogin WHERE character_id=?",
        CharacterID
    )

    local result = dbPoll(qh, -1)

    if result and #result > 0 then
        local claimed = stringToClaimed(result[1].claimed)
        local canClaim = tonumber(result[1].canclaim) or 1
        local lastClaimDate = result[1].lastClaimDate or "1970-01-01"
        local weeklyStreak = tonumber(result[1].weeklyStreak) or 0
        local weekStartDate = result[1].weekStartDate or "1970-01-01"

        local currentWeekStart = getCurrentWeekStartString()

        if weekStartDate == "1970-01-01" then
            weekStartDate = currentWeekStart

            dbExec(
                handler,
                "UPDATE dailylogin SET weekStartDate=? WHERE character_id=?",
                weekStartDate,
                CharacterID
            )
        end

        if hasWeekChanged(weekStartDate) then
            if canClaim ~= 8 then
                weeklyStreak = 0
            end

            claimed = emptyClaimed()
            canClaim = 1
            lastClaimDate = "1970-01-01"
            weekStartDate = currentWeekStart

            dbExec(
                handler,
                "UPDATE dailylogin SET claimed=?, canclaim=?, lastClaimDate=?, weeklyStreak=?, weekStartDate=? WHERE character_id=?",
                claimedToString(claimed),
                canClaim,
                lastClaimDate,
                weeklyStreak,
                weekStartDate,
                CharacterID
            )
        end

        return claimed, canClaim, lastClaimDate, weeklyStreak, weekStartDate
    else
        local claimed = emptyClaimed()
        local weekStartDate = getCurrentWeekStartString()

        dbExec(
            handler,
            "INSERT INTO dailylogin (character_id, claimed, canclaim, lastClaimDate, weeklyStreak, weekStartDate) VALUES (?,?,?,?,?,?)",
            CharacterID,
            claimedToString(claimed),
            1,
            "1970-01-01",
            0,
            weekStartDate
        )

        return claimed, 1, "1970-01-01", 0, weekStartDate
    end
end

function DailyLogin.saveDailyData(player, claimed, canClaim, lastClaimDate, weeklyStreak, weekStartDate)
    local CharacterID = getCharacterID(player)
    if not CharacterID then return nil end

    dbExec(
        handler,
        "UPDATE dailylogin SET claimed=?, canclaim=?, lastClaimDate=?, weeklyStreak=?, weekStartDate=? WHERE character_id=?",
        claimedToString(claimed),
        canClaim,
        lastClaimDate,
        weeklyStreak or 0,
        weekStartDate or getCurrentWeekStartString(),
        CharacterID
    )
end

local function sendDailyState(player)
    local claimed, canClaim, lastClaimDate, weeklyStreak = DailyLogin.getDailyData(player)

    if claimed then
        local canClaimNow = canClaim <= 7 and isNewDay(lastClaimDate)
        triggerClientEvent(
            player,
            "DailyLogin.onDailyStateReceive",
            player,
            claimed,
            canClaim,
            weeklyStreak,
            canClaimNow
        )
    end
end

addEvent("DailyLogin.onDailyStateReceiveRequest", true)
addEventHandler("DailyLogin.onDailyStateReceiveRequest", root, function()
    sendDailyState(client)
end)

addEvent("DailyLogin.onPlayerClaimDaily", true)
addEventHandler("DailyLogin.onPlayerClaimDaily", root, function(dayIndex)
    local claimed, canClaim, lastClaimDate, weeklyStreak, weekStartDate = DailyLogin.getDailyData(client)
    if not claimed then return end

    dayIndex = tonumber(dayIndex)
    if not dayIndex or dayIndex < 1 or dayIndex > 7 then return end

    if canClaim == 8 then
        createInfobox(client, getText(client, "SDailyLogin1"))
        return
    end

    if dayIndex ~= canClaim then
        createInfobox(client, getText(client, "SDailyLogin1"))
        return
    end

    if not isNewDay(lastClaimDate) then
        createInfobox(client, getText(client, "SDailyLogin1"))
        return
    end

    claimed[dayIndex] = true

    local Level_Bonus_EXP = tonumber(apocalypseGetElementData(client, "level")) or 1
    if Level_Bonus_EXP > 100 then Level_Bonus_EXP = 100 end
    if Level_Bonus_EXP < 1 then Level_Bonus_EXP = 1 end

    if dayIndex == 1 then giveEXP(client, 250 * Level_Bonus_EXP) end
    if dayIndex == 2 then giveItem(client, 14, 5) end
    if dayIndex == 3 then giveItem(client, 72, 5); giveItem(client, 73, 3); giveItem(client, 74, 1) end
    if dayIndex == 4 then giveEXP(client, 500 * Level_Bonus_EXP) end
    if dayIndex == 5 then giveItem(client, 14, 10) end
    if dayIndex == 6 then giveItem(client, 1, 1000) end
	giveItem(client,205,dayIndex)

    if dayIndex == 7 then
        local EXP = 750 * Level_Bonus_EXP

        giveEXP(client, EXP)
        giveItem(client, 1, 1000)
        givePlayerServerMoney(client, 7500)
        giveItem(client, 14, 5)
        giveItem(client, 74, 2)

        weeklyStreak = weeklyStreak + 1
		giveEXP(client,10000 * weeklyStreak)
        canClaim = 8
    else
        canClaim = canClaim + 1
    end

    DailyLogin.saveDailyData(
        client,
        claimed,
        canClaim,
        getTodayString(),
        weeklyStreak,
        weekStartDate
    )

    sendDailyState(client)
end)

function DailyLogin.create(player)
    sendDailyState(player)
end

function DailyLogin.resetAllPlayers()
    local qh = dbQuery(handler, "SELECT character_id FROM dailylogin")
    local result = dbPoll(qh, -1)
    if not result then return end

    local weekStartDate = getCurrentWeekStartString()

    for _, row in ipairs(result) do
        dbExec(
            handler,
            "UPDATE dailylogin SET claimed=?, canclaim=?, lastClaimDate=?, weeklyStreak=?, weekStartDate=? WHERE character_id=?",
            "0,0,0,0,0,0,0",
            1,
            "1970-01-01",
            0,
            weekStartDate,
            row.character_id
        )
    end

    for _, player in ipairs(getElementsByType("player")) do
        DailyLogin.create(player)
    end
end