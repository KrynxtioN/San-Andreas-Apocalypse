local TABLE_NAME = "player_notepad"

local BASE_PAGE_PRICE = 500
local BASE_WAYPOINT_PRICE = 500

local START_PAGES = 1
local START_WAYPOINT_SLOTS = 1

local MAX_CHARS = 1000
local MAX_WAYPOINT_NAME = 32

local notepadCache = {}

local function getPagePrice(pages)
    return BASE_PAGE_PRICE * tonumber(pages or START_PAGES)
end

local function getWaypointPrice(slots)
    return BASE_WAYPOINT_PRICE * tonumber(slots or START_WAYPOINT_SLOTS)
end

local function encodeData(data)
    return toJSON(data or {})
end

local function decodeData(json)
    if not json or json == "" then return {} end
    local data = fromJSON(json)
    if type(data) ~= "table" then return {} end
    return data
end

local function normalizeIndexedTable(tbl)
    local result = {}

    if type(tbl) ~= "table" then
        return result
    end

    for k, v in pairs(tbl) do
        local index = tonumber(k)
        if index then
            result[index] = v
        end
    end

    return result
end

local function createDefaultNotepad()
    return {
        pages = START_PAGES,
        texts = {
            [1] = ""
        },
        waypoint_slots = START_WAYPOINT_SLOTS,
        waypoints = {}
    }
end

local function canUseNotepad(player)
    if not isElement(player) then return false end
    if not isCharacterLoggedIn(player) then return false end
    if tonumber(hasPlayerItem(player, 206)) < 1 then return false end

    return true
end

function loadPlayerNotepad(player)
    if not canUseNotepad(player) then
        return false
    end

    local charID = getCharacterID(player)
    if not charID then return false end

    dbQuery(function(qh, player, charID)
        local result = dbPoll(qh, 0)

        if not isElement(player) then return end

        if result and result[1] then
            notepadCache[player] = {
                character_id = charID,
                pages = tonumber(result[1].pages) or START_PAGES,
                texts = normalizeIndexedTable(decodeData(result[1].data)),
                waypoint_slots = tonumber(result[1].waypoint_slots) or START_WAYPOINT_SLOTS,
                waypoints = normalizeIndexedTable(decodeData(result[1].waypoint_data))
            }

            if not notepadCache[player].texts[1] then
                notepadCache[player].texts[1] = ""
            end
        else
            local default = createDefaultNotepad()

            dbExec(
                handler,
                "INSERT INTO " .. TABLE_NAME .. " (character_id, pages, data, waypoint_slots, waypoint_data) VALUES (?, ?, ?, ?, ?)",
                charID,
                default.pages,
                encodeData(default.texts),
                default.waypoint_slots,
                encodeData(default.waypoints)
            )

            notepadCache[player] = {
                character_id = charID,
                pages = default.pages,
                texts = default.texts,
                waypoint_slots = default.waypoint_slots,
                waypoints = default.waypoints
            }
        end

        local data = notepadCache[player]

        triggerClientEvent(
            player,
            "notepad:openClient",
            player,
            data,
            getPagePrice(data.pages),
            getWaypointPrice(data.waypoint_slots)
        )
    end, {player, charID}, handler,
        "SELECT pages, data, waypoint_slots, waypoint_data FROM " .. TABLE_NAME .. " WHERE character_id = ? LIMIT 1",
        charID
    )

    return true
end

addEvent("loadPlayerNotepad", true)
addEventHandler("loadPlayerNotepad", root, function()
    loadPlayerNotepad(client)
end)

function savePlayerNotepad(player)
    local data = notepadCache[player]
    if not data then return false end

    dbExec(
        handler,
        "UPDATE " .. TABLE_NAME .. " SET pages = ?, data = ?, waypoint_slots = ?, waypoint_data = ? WHERE character_id = ?",
        data.pages,
        encodeData(data.texts),
        data.waypoint_slots,
        encodeData(data.waypoints),
        data.character_id
    )

    return true
end

function setPlayerNotepadPage(player, page, text)
    local data = notepadCache[player]
    if not data then return false end

    page = tonumber(page)
    text = tostring(text or "")

    if utf8.len(text) and utf8.len(text) > MAX_CHARS then
        text = utf8.sub(text, 1, MAX_CHARS)
    end

    if not page or page < 1 or page > data.pages then
        return false
    end

    data.texts[page] = text
    savePlayerNotepad(player)

    return true
end

function addPlayerNotepadPage(player)
    local data = notepadCache[player]
    if not data then return false end

    local price = getPagePrice(data.pages)
    local money = tonumber(apocalypseGetElementData(player, "money")) or 0

    if money < price then
        createInfobox(player, getText("SNotepad1"):format(price))
        return false
    end

    apocalypseSetElementData(player, "money", money - price)

    data.pages = data.pages + 1
    data.texts[data.pages] = ""

    savePlayerNotepad(player)

    triggerClientEvent(player, "notepad:receiveAllData", player, data, getPagePrice(data.pages), getWaypointPrice(data.waypoint_slots))
    triggerClientEvent(player, "notepad:pageBought", player, data.pages)

    createInfobox(player, getText("SNotepad2"):format(price))

    return true
end

function setPlayerWaypoint(player, slot, name)
    local data = notepadCache[player]
    if not data then return false end

    slot = tonumber(slot)
    name = tostring(name or "")

    if not slot or slot < 1 or slot > data.waypoint_slots then
        return false
    end

    if name == "" then
        name = getText("SNotepad3"):format(slot)
    end

    if utf8.len(name) and utf8.len(name) > MAX_WAYPOINT_NAME then
        name = utf8.sub(name, 1, MAX_WAYPOINT_NAME)
    end

    local px, py, pz = getElementPosition(player)
    local interior = getElementInterior(player)
    local dimension = getElementDimension(player)

    data.waypoints[slot] = {
        name = name,
        x = px,
        y = py,
        z = pz,
        interior = interior,
        dimension = dimension
    }

    savePlayerNotepad(player)

    triggerClientEvent(player, "notepad:receiveAllData", player, data, getPagePrice(data.pages), getWaypointPrice(data.waypoint_slots))
    createInfobox(player, getText("SNotepad4"))

    return true
end

function deletePlayerWaypoint(player, slot)
    local data = notepadCache[player]
    if not data then return false end

    slot = tonumber(slot)

    if not slot or slot < 1 or slot > data.waypoint_slots then
        return false
    end

    data.waypoints[slot] = nil

    savePlayerNotepad(player)

    triggerClientEvent(player, "notepad:receiveAllData", player, data, getPagePrice(data.pages), getWaypointPrice(data.waypoint_slots))
    createInfobox(player, getText("SNotepad5"))

    return true
end

function addPlayerWaypointSlot(player)
    local data = notepadCache[player]
    if not data then return false end

    local price = getWaypointPrice(data.waypoint_slots)
    local money = tonumber(apocalypseGetElementData(player, "money")) or 0

    if money < price then
        createInfobox(player, getText("SNotepad1"):format(price))
        return false
    end

    apocalypseSetElementData(player, "money", money - price)

    data.waypoint_slots = data.waypoint_slots + 1

    savePlayerNotepad(player)

    triggerClientEvent(player, "notepad:receiveAllData", player, data, getPagePrice(data.pages), getWaypointPrice(data.waypoint_slots))
    createInfobox(player, getText("SNotepad6"):format(price))

    return true
end

addEvent("notepad:savePage", true)
addEventHandler("notepad:savePage", root, function(page, text, showMessage)
    if not canUseNotepad(client) then return end

    if not notepadCache[client] then
        loadPlayerNotepad(client)
        return
    end

    local success = setPlayerNotepadPage(client, page, text)

    if showMessage then
        if success then
            createInfobox(client, getText("SNotepad7"))
        else
            createInfobox(client, getText("SNotepad8"))
        end
    end
end)

addEvent("notepad:buyPage", true)
addEventHandler("notepad:buyPage", root, function()
    if not canUseNotepad(client) then return end

    if not notepadCache[client] then
        loadPlayerNotepad(client)
        return
    end

    addPlayerNotepadPage(client)
end)

addEvent("notepad:saveWaypoint", true)
addEventHandler("notepad:saveWaypoint", root, function(slot, name)
    if not canUseNotepad(client) then return end

    if not notepadCache[client] then
        loadPlayerNotepad(client)
        return
    end

    setPlayerWaypoint(client, slot, name)
end)

addEvent("notepad:deleteWaypoint", true)
addEventHandler("notepad:deleteWaypoint", root, function(slot)
    if not canUseNotepad(client) then return end

    if not notepadCache[client] then
        loadPlayerNotepad(client)
        return
    end

    deletePlayerWaypoint(client, slot)
end)

addEvent("notepad:buyWaypointSlot", true)
addEventHandler("notepad:buyWaypointSlot", root, function()
    if not canUseNotepad(client) then return end

    if not notepadCache[client] then
        loadPlayerNotepad(client)
        return
    end

    addPlayerWaypointSlot(client)
end)

addEventHandler("onPlayerQuit", root, function()
    savePlayerNotepad(source)
    notepadCache[source] = nil
end)