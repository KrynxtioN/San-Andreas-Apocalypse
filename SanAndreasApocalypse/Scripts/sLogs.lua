local LogPath = "Logs/"
local LogIndex = LogPath .. "log_index.txt"

function date_time()
    local t = getRealTime()
    return {
        string.format("%02d", t.monthday),
        string.format("%02d", t.month + 1),
        t.year + 1900,
        string.format("%02d", t.hour),
        string.format("%02d", t.minute),
        string.format("%02d", t.second)
    }
end

function getLog(path)
    if not fileExists(path) then
        local f = fileCreate(path)
        if f then fileClose(f) end
    end

    return fileOpen(path, false)
end

function getAllLogs()
    local result = {}

    if not fileExists(LogIndex) then
        return result
    end

    local f = fileOpen(LogIndex, true)
    if not f then return result end

    local content = fileRead(f, fileGetSize(f))
    fileClose(f)

    for line in string.gmatch(content, "[^\r\n]+") do
        table.insert(result, line)
    end

    return result
end

local function addLogToIndex(logname)
    local logs = getAllLogs()

    for _, name in ipairs(logs) do
        if name == logname then return end
    end

    local f

    if fileExists(LogIndex) then
        f = fileOpen(LogIndex, false)
        fileSetPos(f, fileGetSize(f))
    else
        f = fileCreate(LogIndex)
    end

    if not f then return end

    fileWrite(f, logname .. "\n")
    fileClose(f)
end

function outputLog(text, logname)
    local date = date_time()

    if not logname then
        logname = "allround"
    end

    logname = tostring(logname):gsub("[^%w_%-]", "")
    text = tostring(text)

    addLogToIndex(logname)

    local log = getLog(LogPath .. logname .. ".xml")
    if not log then return end

    fileSetPos(log, fileGetSize(log))
    fileWrite(
        log,
        date[1] .. "." .. date[2] .. "." .. date[3] ..
        " - " .. date[4] .. ":" .. date[5] .. ":" .. date[6] ..
        ": " .. text .. "\n"
    )

    fileClose(log)
end

local function parseLogTimestamp(line)
    local d, m, y, h, min, s = line:match("^(%d+)%.(%d+)%.(%d+) %- (%d+):(%d+):(%d+):")
    if not d then return false end

    return os.time({
        day = tonumber(d),
        month = tonumber(m),
        year = tonumber(y),
        hour = tonumber(h),
        min = tonumber(min),
        sec = tonumber(s)
    })
end

local function buildLogData(content, days)
    local lines = {}
    local stats = {
        today = 0,
        week = 0,
        month = 0,
        total = 0
    }

    local now = os.time()
    local minTime = false

    if days and tonumber(days) and tonumber(days) > 0 then
        minTime = now - tonumber(days) * 24 * 60 * 60
    end

    for line in string.gmatch(content, "[^\r\n]+") do
        local timestamp = parseLogTimestamp(line)

        if timestamp then
            stats.total = stats.total + 1

            if timestamp >= now - 1 * 24 * 60 * 60 then
                stats.today = stats.today + 1
            end

            if timestamp >= now - 7 * 24 * 60 * 60 then
                stats.week = stats.week + 1
            end

            if timestamp >= now - 30 * 24 * 60 * 60 then
                stats.month = stats.month + 1
            end
        end

        if not minTime or not timestamp or timestamp >= minTime then
            table.insert(lines, {
                text = line,
                timestamp = timestamp or 0
            })
        end
    end

    table.sort(lines, function(a, b)
        return a.timestamp > b.timestamp
    end)

    local result = {}

    for _, data in ipairs(lines) do
        table.insert(result, data.text)
    end

    local text = table.concat(result, "\n")

    if text == "" then
        text = "Keine Einträge für diesen Zeitraum."
    end

    return text, stats
end

addEvent("logs:requestList", true)
addEventHandler("logs:requestList", root, function()
    local list = getAllLogs()

    table.sort(list, function(a, b)
        return a > b
    end)

    triggerClientEvent(client, "logs:receiveList", resourceRoot, list)
end)

addEvent("logs:requestContent", true)
addEventHandler("logs:requestContent", root, function(logname, days)
    if type(logname) ~= "string" then return end

    logname = logname:gsub("[^%w_%-]", "")
    days = tonumber(days) or 0

    local path = LogPath .. logname .. ".xml"

    if not fileExists(path) then
        triggerClientEvent(client, "logs:receiveContent", resourceRoot, logname, "Log nicht gefunden.", {
            today = 0,
            week = 0,
            month = 0,
            total = 0
        })
        return
    end

    local f = fileOpen(path, true)
    if not f then return end

    local content = fileRead(f, fileGetSize(f))
    fileClose(f)

    local filteredContent, stats = buildLogData(content, days)

    triggerClientEvent(client, "logs:receiveContent", resourceRoot, logname, filteredContent, {
        today = stats.today or 0,
        week = stats.week or 0,
        month = stats.month or 0,
        total = stats.total or 0
    })
end)