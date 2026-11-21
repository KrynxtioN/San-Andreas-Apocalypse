local sx, sy = guiGetScreenSize()

local visible = false
local logs = {}
local selectedLog = nil
local logText = "Select a log on the left"
local statsText = "Stats: -"
local scroll = 0
local filterDays = 0

local filters = {
    { label = "All", days = 0 },
    { label = "Today", days = 1 },
    { label = "3D", days = 3 },
    { label = "5D", days = 5 },
    { label = "7D", days = 7 },
    { label = "14D", days = 14 },
    { label = "30D", days = 30 }
}

local ui = {
    w = 820,
    h = 500,
    leftW = 190
}

ui.x = (sx - ui.w) / 2
ui.y = (sy - ui.h) / 2

local function isMouseInPosition(x, y, w, h)
    if not isCursorShowing() then return false end
    local cx, cy = getCursorPosition()
    cx, cy = cx * sx, cy * sy
    return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end

function requestLogs()
    triggerServerEvent("logs:requestList", localPlayer)
end

function requestSelectedLog()
    if selectedLog then
        triggerServerEvent("logs:requestContent", localPlayer, selectedLog, filterDays)
    end
end

function openLogUI()
    if visible then return end

    visible = true
    showCursor(true)

    addEventHandler("onClientRender", root, renderLogUI)
    addEventHandler("onClientClick", root, clickLogUI)
    addEventHandler("onClientKey", root, keyLogUI)
	destroyElement(GUIEditor.window[1])
    requestLogs()
end

function closeLogUI()
    if not visible then return end

    visible = false
    showCursor(false)
	closeWindow()
    removeEventHandler("onClientRender", root, renderLogUI)
    removeEventHandler("onClientClick", root, clickLogUI)
    removeEventHandler("onClientKey", root, keyLogUI)
end

addEvent("logs:receiveList", true)
addEventHandler("logs:receiveList", resourceRoot, function(serverLogs)
    logs = serverLogs or {}
end)

addEvent("logs:receiveContent", true)
addEventHandler("logs:receiveContent", resourceRoot, function(logname, content, stats)
    selectedLog = logname
    logText = content or ""
    scroll = 0

    stats = stats or { today = 0, week = 0, month = 0, total = 0 }

    statsText = "Stats: Today - " .. tostring(stats.today or 0) ..
        " | 7D - " .. tostring(stats.week or 0) ..
        " | 30D - " .. tostring(stats.month or 0) ..
        " | Total - " .. tostring(stats.total or 0)
end)

function renderLogUI()
    local x, y, w, h = ui.x, ui.y, ui.w, ui.h
    local leftW = ui.leftW

    dxDrawRectangle(x, y, w, h, tocolor(18, 18, 18, 235))
    dxDrawRectangle(x, y, w, 34, tocolor(35, 35, 35, 245))

    dxDrawText("SAA Log Viewer", x + 10, y, x + w, y + 34, tocolor(255,255,255), 1, "default-bold", "left", "center")

    local refreshX, refreshY, refreshW, refreshH = x + w - 100, y + 6, 60, 22
    dxDrawRectangle(refreshX, refreshY, refreshW, refreshH, tocolor(55, 95, 150, 230))
    dxDrawText("Refresh", refreshX, refreshY, refreshX + refreshW, refreshY + refreshH, tocolor(255,255,255), 1, "default-bold", "center", "center")

    local closeX, closeY, closeW, closeH = x + w - 32, y + 6, 22, 22
    dxDrawRectangle(closeX, closeY, closeW, closeH, tocolor(160, 45, 45, 230))
    dxDrawText("X", closeX, closeY, closeX + closeW, closeY + closeH, tocolor(255,255,255), 1, "default-bold", "center", "center")

    dxDrawRectangle(x, y + 34, leftW, h - 34, tocolor(25, 25, 25, 235))
    dxDrawText("Logs", x + 10, y + 43, x + leftW, y + 65, tocolor(255,255,255), 1, "default-bold")

    local itemStartY = y + 70
    local maxItems = math.floor((h - 85) / 27)

    for i = 1, math.min(#logs, maxItems) do
        local logname = logs[i]
        local rowY = itemStartY + (i - 1) * 27
        local color = selectedLog == logname and tocolor(65, 110, 175, 235) or tocolor(45, 45, 45, 230)

        dxDrawRectangle(x + 8, rowY, leftW - 16, 23, color)
        dxDrawText(logname, x + 13, rowY, x + leftW - 10, rowY + 23, tocolor(255,255,255), 1, "default", "left", "center", true)
    end

    local contentX = x + leftW + 12
    local contentW = w - leftW - 24

    dxDrawText(
        selectedLog and ("Log: " .. selectedLog) or "No log selected",
        contentX,
        y + 42,
        contentX + contentW,
        y + 60,
        tocolor(235,235,235),
        1,
        "default-bold",
        "left",
        "center",
        true
    )

    dxDrawText(
        statsText,
        contentX,
        y + 42,
        contentX + contentW,
        y + 60,
        tocolor(190,190,190),
        1,
        "default",
        "right",
        "center",
        true
    )

    local filterY = y + 66
    local btnX = contentX

    for _, filter in ipairs(filters) do
        local bw = 42
        if filter.label == "All" then bw = 48 end
        if filter.label == "Today" then bw = 56 end
        if filter.label == "14D" or filter.label == "30D" then bw = 46 end

        local active = filterDays == filter.days
        dxDrawRectangle(btnX, filterY, bw, 23, active and tocolor(65, 110, 175, 235) or tocolor(45, 45, 45, 230))
        dxDrawText(filter.label, btnX, filterY, btnX + bw, filterY + 23, tocolor(255,255,255), 1, "default-bold", "center", "center")
        btnX = btnX + bw + 5
    end

    local textX = contentX
    local textY = y + 102
    local textW = contentW
    local textH = h - 114

    dxDrawRectangle(textX - 4, textY - 4, textW + 8, textH + 8, tocolor(10, 10, 10, 220))

    local lines = {}
    for line in string.gmatch(logText, "[^\r\n]+") do
        table.insert(lines, line)
    end

    local maxLines = math.floor(textH / 16)

    for i = 1, maxLines do
        local line = lines[i + scroll]
        if line then
            dxDrawText(line, textX, textY + (i - 1) * 16, textX + textW, textY + i * 16, tocolor(230,230,230), 1, "default", "left", "top", true)
        end
    end
end

function clickLogUI(button, state)
    if button ~= "left" or state ~= "down" then return end

    local x, y, w, h = ui.x, ui.y, ui.w, ui.h
    local leftW = ui.leftW

    if isMouseInPosition(x + w - 32, y + 6, 22, 22) then
        closeLogUI()
        return
    end

    if isMouseInPosition(x + w - 100, y + 6, 60, 22) then
        requestLogs()
        requestSelectedLog()
        return
    end

    local contentX = x + leftW + 12
    local filterY = y + 66
    local btnX = contentX

    for _, filter in ipairs(filters) do
        local bw = 42
        if filter.label == "All" then bw = 48 end
        if filter.label == "Today" then bw = 56 end
        if filter.label == "14D" or filter.label == "30D" then bw = 46 end

        if isMouseInPosition(btnX, filterY, bw, 23) then
            filterDays = filter.days
            scroll = 0
            requestSelectedLog()
            return
        end

        btnX = btnX + bw + 5
    end

    local itemStartY = y + 70
    local maxItems = math.floor((h - 85) / 27)

    for i = 1, math.min(#logs, maxItems) do
        local rowY = itemStartY + (i - 1) * 27

        if isMouseInPosition(x + 8, rowY, leftW - 16, 23) then
            triggerServerEvent("logs:requestContent", localPlayer, logs[i], filterDays)
            return
        end
    end
end

function keyLogUI(button, press)
    if not press then return end

    if button == "mouse_wheel_down" then
        scroll = scroll + 3
    elseif button == "mouse_wheel_up" then
        scroll = math.max(scroll - 3, 0)
    elseif button == "escape" then
        closeLogUI()
        cancelEvent()
    end
end

addEventHandler("onClientPlayerWasted",root,function(player)
	if(player == localPlayer)then
		closeLogUI()
	end
end)