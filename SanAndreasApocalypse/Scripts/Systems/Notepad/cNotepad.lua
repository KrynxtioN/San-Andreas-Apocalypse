local sx, sy = guiGetScreenSize()

local isOpen = false
local category = "notes"

local currentPage = 1
local maxPages = 1
local pageTexts = {}
local currentText = ""
local cursorPos = 0
local maxChars = 1000
local pagePrice = 500

local waypointSlots = 1
local waypoints = {}
local waypointPrice = 500
local selectedWaypointSlot = 1
local waypointNameText = ""
local waypointNameCursor = 0

local waypointBlips = {}
local buttons = {}

local w, h = 760, 620
local x, y = (sx - w) / 2, (sy - h) / 2

local anim = {
    openTick = 0,
    closeTick = 0,
    pageFlipTick = 0,
    pageFlipDir = 1,
    alpha = 0,
    scale = 0.96,
    closing = false
}

local COLORS = {
    bg = tocolor(16, 16, 20, 245),
    panel = tocolor(28, 28, 34, 245),
    panel2 = tocolor(38, 38, 46, 245),
    paper = tocolor(245, 230, 185, 255),
    paperDark = tocolor(225, 205, 155, 255),
    accent = tocolor(220, 25, 25, 255),
    accentHover = tocolor(245, 45, 45, 255),
    text = tocolor(245, 245, 245, 255),
    sub = tocolor(190, 190, 200, 255),
    darkText = tocolor(30, 24, 18, 255),
    danger = tocolor(150, 55, 55, 255),
    dangerHover = tocolor(190, 70, 70, 255)
}

local function clamp(v, a, b)
    return math.max(a, math.min(b, v))
end

local function easeOutQuad(t)
    return 1 - (1 - t) * (1 - t)
end

local function easeInOutQuad(t)
    if t < 0.5 then return 2 * t * t end
    return 1 - ((-2 * t + 2) ^ 2) / 2
end

local function strlen(str)
    return utf8.len(str or "") or 0
end

local function strsub(str, a, b)
    return utf8.sub(str or "", a, b)
end

local function alphaColor(color, alpha)
    local r, g, b, a = getColorFromString(string.format("#%08X", color))
    return tocolor(r or 255, g or 255, b or 255, math.floor((a or 255) * alpha))
end

local function isMouseInPosition(px, py, pw, ph)
    if not isCursorShowing() then return false end
    local mx, my = getCursorPosition()
    if not mx or not my then return false end
    mx, my = mx * sx, my * sy
    return mx >= px and mx <= px + pw and my >= py and my <= py + ph
end

local function drawShadow(px, py, pw, ph, alpha)
    dxDrawRectangle(px + 8, py + 10, pw, ph, tocolor(0, 0, 0, 70 * alpha))
    dxDrawRectangle(px + 4, py + 5, pw, ph, tocolor(0, 0, 0, 45 * alpha))
end

local function drawButton(id, px, py, pw, ph, text, style)
    style = style or "normal"
    buttons[id] = {x = px, y = py, w = pw, h = ph}

    local hover = isMouseInPosition(px, py, pw, ph)
    local bg = COLORS.panel2

    if style == "accent" then
        bg = hover and COLORS.accentHover or COLORS.accent
    elseif style == "danger" then
        bg = hover and COLORS.dangerHover or COLORS.danger
    else
        bg = hover and tocolor(58, 58, 68, 245) or COLORS.panel2
    end

    dxDrawRectangle(px, py, pw, ph, bg)
    dxDrawRectangle(px, py, pw, 2, hover and COLORS.accentHover or COLORS.accent)
    dxDrawText(text, px, py, px + pw, py + ph, COLORS.text, 1, "default-bold", "center", "center")
end

local function drawTab(id, px, py, pw, ph, text, active)
    buttons[id] = {x = px, y = py, w = pw, h = ph}

    local hover = isMouseInPosition(px, py, pw, ph)
    local bg = active and COLORS.accent or hover and tocolor(58, 58, 68, 245) or COLORS.panel2

    dxDrawRectangle(px, py, pw, ph, bg)
    dxDrawRectangle(px, py, pw, 2, active and COLORS.accentHover or COLORS.accent)
    dxDrawText(text, px, py, px + pw, py + ph, COLORS.text, 1, "default-bold", "center", "center")
end

local function normalizeIndexedTable(tbl)
    local result = {}
    if type(tbl) ~= "table" then return result end

    for k, v in pairs(tbl) do
        local index = tonumber(k)
        if index then
            result[index] = v
        end
    end

    return result
end

local function saveCurrentPage(showMessage)
    if not isOpen then return end
    if category ~= "notes" then return end

    pageTexts[currentPage] = currentText
    triggerServerEvent("notepad:savePage", localPlayer, currentPage, currentText, showMessage == true)
end

local function startPageFlip(dir)
    anim.pageFlipTick = getTickCount()
    anim.pageFlipDir = dir or 1
end

local function insertAtCursor(char)
    if category == "notes" then
        if strlen(currentText) >= maxChars then return end
        local before = strsub(currentText, 1, cursorPos)
        local after = strsub(currentText, cursorPos + 1)
        currentText = before .. char .. after
        cursorPos = cursorPos + strlen(char)
    elseif category == "waypoints" then
        if strlen(waypointNameText) >= 32 then return end
        local before = strsub(waypointNameText, 1, waypointNameCursor)
        local after = strsub(waypointNameText, waypointNameCursor + 1)
        waypointNameText = before .. char .. after
        waypointNameCursor = waypointNameCursor + strlen(char)
    end
end

local function deleteBeforeCursor()
    if category == "notes" then
        if cursorPos <= 0 then return end
        currentText = strsub(currentText, 1, cursorPos - 1) .. strsub(currentText, cursorPos + 1)
        cursorPos = cursorPos - 1
    elseif category == "waypoints" then
        if waypointNameCursor <= 0 then return end
        waypointNameText = strsub(waypointNameText, 1, waypointNameCursor - 1) .. strsub(waypointNameText, waypointNameCursor + 1)
        waypointNameCursor = waypointNameCursor - 1
    end
end

local function deleteAtCursor()
    if category == "notes" then
        if cursorPos >= strlen(currentText) then return end
        currentText = strsub(currentText, 1, cursorPos) .. strsub(currentText, cursorPos + 2)
    elseif category == "waypoints" then
        if waypointNameCursor >= strlen(waypointNameText) then return end
        waypointNameText = strsub(waypointNameText, 1, waypointNameCursor) .. strsub(waypointNameText, waypointNameCursor + 2)
    end
end

local function getTextWithCursor()
    return strsub(currentText, 1, cursorPos) .. "|" .. strsub(currentText, cursorPos + 1)
end

local function getWaypointNameWithCursor()
    return strsub(waypointNameText, 1, waypointNameCursor) .. "|" .. strsub(waypointNameText, waypointNameCursor + 1)
end

local function clearWaypointBlips()
    for _, blip in pairs(waypointBlips) do
        if isElement(blip) then destroyElement(blip) end
    end
    waypointBlips = {}
end

local function refreshWaypointBlips()
    clearWaypointBlips()

    for slot = 1, waypointSlots do
        local wp = waypoints[slot]
        if type(wp) == "table" and wp.x and wp.y and wp.z then
            waypointBlips[slot] = createBlip(tonumber(wp.x), tonumber(wp.y), tonumber(wp.z), 41, 2, 255, 120, 50, 255, 0, 99999)
        end
    end
end

local function selectWaypointSlot(slot)
    selectedWaypointSlot = tonumber(slot) or 1

    local wp = waypoints[selectedWaypointSlot]
    if type(wp) == "table" and wp.name then
        waypointNameText = tostring(wp.name)
    else
        waypointNameText = getText("CNotepad1"):format(selectedWaypointSlot)
    end

    waypointNameCursor = strlen(waypointNameText)
end

local function applyData(data, newPagePrice, newWaypointPrice)
    if not data then return end

    maxPages = tonumber(data.pages) or 1
    pageTexts = normalizeIndexedTable(data.texts)

    waypointSlots = tonumber(data.waypoint_slots) or 1
    waypoints = normalizeIndexedTable(data.waypoints)

    pagePrice = tonumber(newPagePrice) or pagePrice
    waypointPrice = tonumber(newWaypointPrice) or waypointPrice

    currentPage = clamp(currentPage, 1, maxPages)
    selectedWaypointSlot = clamp(selectedWaypointSlot, 1, waypointSlots)

    currentText = pageTexts[currentPage] or ""
    cursorPos = strlen(currentText)

    selectWaypointSlot(selectedWaypointSlot)
    refreshWaypointBlips()
end

local function drawPaper(px, py, pw, ph)
    dxDrawRectangle(px, py, pw, ph, COLORS.paper)

    for i = 1, 18 do
        local ly = py + 28 + i * 22
        dxDrawLine(px + 25, ly, px + pw - 25, ly, tocolor(120, 90, 55, 38), 1)
    end

    dxDrawLine(px + 50, py + 20, px + 50, py + ph - 20, tocolor(220, 25, 25, 75), 1)
    dxDrawRectangle(px, py, pw, 5, tocolor(255,255,255,35))
    dxDrawRectangle(px + pw - 8, py + 8, 4, ph - 16, tocolor(0,0,0,25))
end

local function drawPageFlipOverlay(px, py, pw, ph)
    if anim.pageFlipTick == 0 then return end

    local progress = clamp((getTickCount() - anim.pageFlipTick) / 360, 0, 1)
    local eased = easeInOutQuad(progress)

    local foldW = pw * (1 - math.abs(0.5 - eased) * 2)
    local sideX = anim.pageFlipDir > 0 and (px + pw - foldW) or px

    dxDrawRectangle(sideX, py, foldW, ph, tocolor(255, 245, 210, 145 * (1 - progress)))
    dxDrawRectangle(sideX, py, 6, ph, tocolor(0, 0, 0, 45 * (1 - progress)))

    if progress >= 1 then
        anim.pageFlipTick = 0
    end
end

local function drawNotes()
    local paperX, paperY = x + 34, y + 104
    local paperW, paperH = w - 68, h - 198

    dxDrawText(getText("CNotepad2"):format(currentPage, maxPages), x + 34, y + 78, x + 220, y + 100, COLORS.sub, 1, "default-bold", "left", "center")
    dxDrawText(getText("CNotepad3"):format(pagePrice), x + 220, y + 78, x + w - 34, y + 100, COLORS.sub, 1, "default-bold", "right", "center")

    drawPaper(paperX, paperY, paperW, paperH)

    dxDrawText(
        getTextWithCursor(),
        paperX + 70,
        paperY + 30,
        paperX + paperW - 35,
        paperY + paperH - 30,
        COLORS.darkText,
        1.08,
        "default",
        "left",
        "top",
        true,
        true
    )

    drawPageFlipOverlay(paperX, paperY, paperW, paperH)

    local by = y + h - 70
    drawButton("prev", x + 34, by, 80, 40, "←")
    drawButton("next", x + 124, by, 80, 40, "→")
    drawButton("save", x + 222, by, 130, 40, getText("CNotepad4"), "accent")
    drawButton("buy", x + 368, by, 135, 40, getText("CNotepad5"):format(pagePrice))
    drawButton("close", x + w - 144, by, 110, 40, getText("CNotepad6"), "danger")
end

local function drawWaypoints()
    local areaX, areaY = x + 34, y + 104
    local areaW, areaH = w - 68, h - 198

    dxDrawRectangle(areaX, areaY, areaW, areaH, tocolor(24, 24, 30, 245))
    dxDrawRectangle(areaX, areaY, areaW, 3, COLORS.accent)

    dxDrawText(getText("CNotepad7"), areaX + 18, areaY + 14, areaX + 300, areaY + 38, COLORS.text, 1.2, "default-bold", "left", "center")
    dxDrawText(getText("CNotepad8"):format(waypointSlots, waypointPrice), areaX + 300, areaY + 14, areaX + areaW - 18, areaY + 38, COLORS.sub, 1, "default-bold", "right", "center")

    local contentTop = areaY + 55
    local contentBottom = areaY + areaH - 18
    local contentH = contentBottom - contentTop

    local gap = 18
    local listX = areaX + 18
    local listY = contentTop
    local listW = 285
    local detailX = listX + listW + gap
    local detailY = contentTop
    local detailW = areaX + areaW - 18 - detailX
    local detailH = contentH

    local rowH = 42

    dxDrawRectangle(listX, listY, listW, detailH, tocolor(32, 32, 39, 245))
    dxDrawRectangle(listX, listY, listW, 2, COLORS.accent)

    for slot = 1, waypointSlots do
        local rowY = listY + 12 + ((slot - 1) * rowH)
        local wp = waypoints[slot]
        local selected = slot == selectedWaypointSlot
        local hover = isMouseInPosition(listX + 10, rowY, listW - 20, 34)

        local bg = selected and COLORS.accent or hover and tocolor(58, 58, 68, 245) or COLORS.panel2

        dxDrawRectangle(listX + 10, rowY, listW - 20, 34, bg)
        dxDrawRectangle(listX + 10, rowY, 3, 34, selected and COLORS.accentHover or COLORS.accent)

        local title = getText("CNotepad9"):format(slot)
        local small = getText("CNotepad10")

        if type(wp) == "table" and wp.x and wp.y and wp.z then
            title = tostring(wp.name or getText("CNotepad1"):format(slot))
            small = getText("CNotepad11"):format(math.floor(wp.x), math.floor(wp.y), math.floor(wp.z))
        end

        dxDrawText(title, listX + 24, rowY + 3, listX + listW - 18, rowY + 18, COLORS.text, 1, "default-bold", "left", "center", true)
        dxDrawText(small, listX + 24, rowY + 18, listX + listW - 18, rowY + 33, COLORS.sub, 0.85, "default", "left", "center", true)

        buttons["wp_slot_" .. slot] = {x = listX + 10, y = rowY, w = listW - 20, h = 34}
    end

    local wp = waypoints[selectedWaypointSlot]

    dxDrawRectangle(detailX, detailY, detailW, detailH, tocolor(38, 38, 46, 245))
    dxDrawRectangle(detailX, detailY, detailW, 2, COLORS.accent)

    dxDrawText(getText("CNotepad12"):format(selectedWaypointSlot), detailX + 18, detailY + 14, detailX + detailW - 18, detailY + 40, COLORS.text, 1.2, "default-bold", "left", "center")

    dxDrawText(getText("CNotepad13"), detailX + 18, detailY + 58, detailX + detailW - 18, detailY + 78, COLORS.sub, 1, "default-bold", "left", "center")
    dxDrawRectangle(detailX + 18, detailY + 83, detailW - 36, 36, COLORS.paper)
    dxDrawRectangle(detailX + 18, detailY + 83, detailW - 36, 2, tocolor(220, 25, 25, 90))
    dxDrawText(getWaypointNameWithCursor(), detailX + 28, detailY + 83, detailX + detailW - 28, detailY + 119, COLORS.darkText, 1, "default", "left", "center", true)

    local infoY = detailY + 140
    local infoH = detailH - 158

    dxDrawRectangle(detailX + 18, infoY, detailW - 36, infoH, tocolor(30, 30, 37, 245))
    dxDrawRectangle(detailX + 18, infoY, 3, infoH, COLORS.accent)

    if type(wp) == "table" and wp.x and wp.y and wp.z then
        dxDrawText(
            getText("CNotepad14"):format(math.floor(wp.x), math.floor(wp.y), math.floor(wp.z)),
            detailX + 32,
            infoY + 14,
            detailX + detailW - 32,
            infoY + infoH - 14,
            COLORS.sub,
            1,
            "default",
            "left",
            "top",
            true,
            true
        )
    else
        dxDrawText(
            getText("CNotepad15"),
            detailX + 32,
            infoY + 14,
            detailX + detailW - 32,
            infoY + infoH - 14,
            COLORS.sub,
            1,
            "default",
            "left",
            "top",
            true,
            true
        )
    end

    local by = y + h - 70
    drawButton("wp_save", x + 34, by, 190, 40, getText("CNotepad16"), "accent")
    drawButton("wp_delete", x + 238, by, 110, 40, getText("CNotepad17"), "danger")
    drawButton("wp_buy", x + 364, by, 155, 40, getText("CNotepad18"):format(waypointPrice))
    drawButton("close", x + w - 144, by, 110, 40, getText("CNotepad6"), "danger")
end

local function renderNotepad()
    buttons = {}

    local now = getTickCount()
    local progress

    if anim.closing then
        progress = 1 - clamp((now - anim.closeTick) / 220, 0, 1)
        if progress <= 0 then
            isOpen = false
            anim.closing = false
            showCursor(false)
            guiSetInputMode("allow_binds")
            removeEventHandler("onClientRender", root, renderNotepad)
            return
        end
    else
        progress = clamp((now - anim.openTick) / 260, 0, 1)
    end

    progress = easeOutQuad(progress)
    anim.alpha = progress
    anim.scale = 0.94 + (0.06 * progress)

    local sw, sh = w * anim.scale, h * anim.scale
    x, y = (sx - sw) / 2, (sy - sh) / 2

    dxDrawRectangle(0, 0, sx, sy, tocolor(0, 0, 0, 120 * anim.alpha))

    drawShadow(x, y, sw, sh, anim.alpha)
    dxDrawRectangle(x, y, sw, sh, COLORS.bg)
    dxDrawRectangle(x, y, sw, 4, COLORS.accent)

    dxDrawText(getText("CNotepad19"), x + 34, y + 16, x + 300, y + 46, COLORS.text, 1.55, "default-bold", "left", "center")
    dxDrawText(getText("CNotepad20"), x + 34, y + 46, x + 300, y + 66, COLORS.sub, 0.9, "default", "left", "center")

    drawTab("cat_notes", x + sw - 344, y + 24, 145, 34, getText("CNotepad21"), category == "notes")
    drawTab("cat_waypoints", x + sw - 189, y + 24, 155, 34, getText("CNotepad7"), category == "waypoints")

    if category == "notes" then
        drawNotes()
    else
        drawWaypoints()
    end
end

local function openNotepad(data, newPagePrice, newWaypointPrice)
    applyData(data, newPagePrice, newWaypointPrice)
    setWindowData()

    if isOpen then return end

    isOpen = true
    anim.openTick = getTickCount()
    anim.closing = false

    showCursor(true)
    guiSetInputMode("no_binds_when_editing")
    addEventHandler("onClientRender", root, renderNotepad)
end

local function closeNotepad()
    if not isOpen or anim.closing then return end

    if category == "notes" then
        saveCurrentPage(false)
    end

    anim.closeTick = getTickCount()
    anim.closing = true
    closeWindow()
end

local function toggleNotepad()
    if isOpen then
        closeNotepad()
    else
        triggerServerEvent("loadPlayerNotepad", localPlayer)
    end
end
bindKey("n", "down", toggleNotepad)

addEventHandler("onClientClick", root, function(button, state)
    if not isOpen or anim.closing then return end
    if button ~= "left" or state ~= "down" then return end

    cancelEvent()

    if buttons.cat_notes and isMouseInPosition(buttons.cat_notes.x, buttons.cat_notes.y, buttons.cat_notes.w, buttons.cat_notes.h) then
        category = "notes"
        currentText = pageTexts[currentPage] or ""
        cursorPos = strlen(currentText)
        return
    end

    if buttons.cat_waypoints and isMouseInPosition(buttons.cat_waypoints.x, buttons.cat_waypoints.y, buttons.cat_waypoints.w, buttons.cat_waypoints.h) then
        if category == "notes" then
            saveCurrentPage(false)
        end

        category = "waypoints"
        selectWaypointSlot(selectedWaypointSlot)
        return
    end

    if category == "notes" then
        if buttons.prev and isMouseInPosition(buttons.prev.x, buttons.prev.y, buttons.prev.w, buttons.prev.h) then
            if currentPage > 1 then
                saveCurrentPage(false)
                currentPage = currentPage - 1
                currentText = pageTexts[currentPage] or ""
                cursorPos = strlen(currentText)
                startPageFlip(-1)
            end
            return
        end

        if buttons.next and isMouseInPosition(buttons.next.x, buttons.next.y, buttons.next.w, buttons.next.h) then
            if currentPage < maxPages then
                saveCurrentPage(false)
                currentPage = currentPage + 1
                currentText = pageTexts[currentPage] or ""
                cursorPos = strlen(currentText)
                startPageFlip(1)
            end
            return
        end

        if buttons.save and isMouseInPosition(buttons.save.x, buttons.save.y, buttons.save.w, buttons.save.h) then
            saveCurrentPage(true)
            return
        end

        if buttons.buy and isMouseInPosition(buttons.buy.x, buttons.buy.y, buttons.buy.w, buttons.buy.h) then
            saveCurrentPage(false)
            triggerServerEvent("notepad:buyPage", localPlayer)
            return
        end
    else
        for slot = 1, waypointSlots do
            local id = "wp_slot_" .. slot
            if buttons[id] and isMouseInPosition(buttons[id].x, buttons[id].y, buttons[id].w, buttons[id].h) then
                selectWaypointSlot(slot)
                return
            end
        end

        if buttons.wp_save and isMouseInPosition(buttons.wp_save.x, buttons.wp_save.y, buttons.wp_save.w, buttons.wp_save.h) then
            triggerServerEvent("notepad:saveWaypoint", localPlayer, selectedWaypointSlot, waypointNameText)
            return
        end

        if buttons.wp_delete and isMouseInPosition(buttons.wp_delete.x, buttons.wp_delete.y, buttons.wp_delete.w, buttons.wp_delete.h) then
            triggerServerEvent("notepad:deleteWaypoint", localPlayer, selectedWaypointSlot)
            return
        end

        if buttons.wp_buy and isMouseInPosition(buttons.wp_buy.x, buttons.wp_buy.y, buttons.wp_buy.w, buttons.wp_buy.h) then
            triggerServerEvent("notepad:buyWaypointSlot", localPlayer)
            return
        end
    end

    if buttons.close and isMouseInPosition(buttons.close.x, buttons.close.y, buttons.close.w, buttons.close.h) then
        closeNotepad()
        return
    end
end)

addEventHandler("onClientCharacter", root, function(char)
    if not isOpen or anim.closing then return end
    insertAtCursor(char)
end)

addEventHandler("onClientKey", root, function(button, press)
    if not isOpen or anim.closing or not press then return end

    if button == "backspace" then
        deleteBeforeCursor()
        cancelEvent()

    elseif button == "delete" then
        deleteAtCursor()
        cancelEvent()

    elseif button == "arrow_l" then
        if category == "notes" then
            cursorPos = math.max(0, cursorPos - 1)
        else
            waypointNameCursor = math.max(0, waypointNameCursor - 1)
        end
        cancelEvent()

    elseif button == "arrow_r" then
        if category == "notes" then
            cursorPos = math.min(strlen(currentText), cursorPos + 1)
        else
            waypointNameCursor = math.min(strlen(waypointNameText), waypointNameCursor + 1)
        end
        cancelEvent()

    elseif button == "home" then
        if category == "notes" then
            cursorPos = 0
        else
            waypointNameCursor = 0
        end
        cancelEvent()

    elseif button == "end" then
        if category == "notes" then
            cursorPos = strlen(currentText)
        else
            waypointNameCursor = strlen(waypointNameText)
        end
        cancelEvent()

    elseif button == "enter" then
        if category == "notes" then
            insertAtCursor("\n")
        end
        cancelEvent()

    elseif button == "escape" then
        closeNotepad()
        cancelEvent()
    end
end)

addEvent("notepad:openClient", true)
addEventHandler("notepad:openClient", root, function(data, newPagePrice, newWaypointPrice)
    openNotepad(data, newPagePrice, newWaypointPrice)
end)

addEvent("notepad:receiveAllData", true)
addEventHandler("notepad:receiveAllData", root, function(data, newPagePrice, newWaypointPrice)
    applyData(data, newPagePrice, newWaypointPrice)
end)

addEvent("notepad:pageBought", true)
addEventHandler("notepad:pageBought", root, function(newPage)
    currentPage = tonumber(newPage) or currentPage
    currentText = pageTexts[currentPage] or ""
    cursorPos = strlen(currentText)
    startPageFlip(1)
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
    clearWaypointBlips()
end)

addEventHandler("onClientPlayerWasted", root, function(player)
    if player == localPlayer then
        closeNotepad()
    end
end)