Fabrikwar = Fabrikwar or {text = nil, blips = {}}
Fabrikwar.blips = Fabrikwar.blips or {}

local sx, sy = guiGetScreenSize()
local hud = {
    visible = false,
    phase = "wait",
    phaseEnd = 0,
    attackers = 0,
    defenders = 0,
    attackerName = getText("CFabrikwar3"),
    defenderName = getText("CFabrikwar4"),
    attackerColor = {255, 120, 120},
    defenderColor = {120, 120, 255},
    startTick = 0,
    killText = nil,
    killUntil = 0,
}

local function msToClock(ms)
    ms = math.max(0, ms or 0)
    local total = math.ceil(ms / 1000)
    local m = math.floor(total / 60)
    local s = total % 60
    return string.format("%02d:%02d", m, s)
end

local function phaseText(phase)
    if phase == "wait" then return getText("CFabrikwar6") end
    if phase == "prep" then return getText("CFabrikwar7") end
    if phase == "fight" then return getText("CFabrikwar8") end
    return getText("CFabrikwar1")
end

addEvent("Fabrikwar.openWindow", true)
addEventHandler("Fabrikwar.openWindow", root, function()
    if isWindowOpen() then
        GUIEditor.window[1] = guiCreateWindow(547, 366, 280, 90, getText("CFabrikwar1"), false)
        GUIEditor.button[1] = guiCreateButton(10, 35, 260, 34, getText("CFabrikwar2"), false, GUIEditor.window[1])
        setWindowData()
        guiCreateCloseButton()

        addEventHandler("onClientGUIClick", GUIEditor.button[1], function()
            triggerServerEvent("Fabrikwar.attack", localPlayer)
        end, false)
    end
end)

addEvent("Fabrikwar.loadBlips", true)
addEventHandler("Fabrikwar.loadBlips", root, function(datas)
    for i = 1, #Fabrikwar.blips do
        if Fabrikwar.blips[i] then
            exports.customblips:destroyCustomBlip(Fabrikwar.blips[i])
        end
    end
    Fabrikwar.blips = {}

    for i, v in pairs(datas or {}) do
        Fabrikwar.blips[i] = exports.customblips:createCustomBlip(v[1], v[2], 22, 22, "Files/Images/Fabrik.png", 100)
    end
end)

function Fabrikwar.renderHud()
    if not hud.visible then return end
    if isPlayerMapVisible() or isPedDead(localPlayer) then return end

    local now = getTickCount()
    local remaining = math.max(0, hud.phaseEnd - now)
    local alpha = 230
    local bgAlpha = 135

    local w, h = 650, 190
    local x, y = (sx - w) / 2, sy - h - 35

    dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, bgAlpha), false)
    dxDrawRectangle(x, y, w, 4, tocolor(220, 25, 25, alpha), false)

    dxDrawText(getText("CFabrikwar1"), x, y + 10, x + w, y + 35, tocolor(255, 255, 255, alpha), 1.25, "default-bold", "center", "center")
    dxDrawText(phaseText(hud.phase) .. "  •  " .. msToClock(remaining), x, y + 35, x + w, y + 60, tocolor(255, 220, 120, alpha), 1.05, "default-bold", "center", "center")

    local boxW, boxH = 230, 52
    local leftX, rightX = x + 55, x + w - 55 - boxW
    local boxY = y + 75

    dxDrawRectangle(leftX, boxY, boxW, boxH, tocolor(25, 25, 25, alpha), false)
    dxDrawRectangle(rightX, boxY, boxW, boxH, tocolor(25, 25, 25, alpha), false)

    dxDrawText(hud.attackerName, leftX, boxY + 4, leftX + boxW, boxY + 25, tocolor(hud.attackerColor[1], hud.attackerColor[2], hud.attackerColor[3], alpha), 1.0, "default-bold", "center", "center")
    dxDrawText(getText("CFabrikwar9"):format(tostring(hud.attackers)), leftX, boxY + 25, leftX + boxW, boxY + boxH, tocolor(255, 255, 255, alpha), 1.15, "default-bold", "center", "center")

    dxDrawText(hud.defenderName, rightX, boxY + 4, rightX + boxW, boxY + 25, tocolor(hud.defenderColor[1], hud.defenderColor[2], hud.defenderColor[3], alpha), 1.0, "default-bold", "center", "center")
    dxDrawText(getText("CFabrikwar9"):format(tostring(hud.defenders)), rightX, boxY + 25, rightX + boxW, boxY + boxH, tocolor(255, 255, 255, alpha), 1.15, "default-bold", "center", "center")

    local status = ""
    if hud.phase == "wait" then
        if hud.attackers >= 1 and hud.defenders >= 1 and hud.attackers == hud.defenders then
            status = getText("CFabrikwar10")
        else
            status = getText("CFabrikwar11")
        end
    elseif hud.phase == "prep" then
        status = getText("CFabrikwar12")
    else
        status = getText("CFabrikwar13")
    end

    dxDrawText(status, x + 20, y + 145, x + w - 20, y + 172, tocolor(235, 235, 235, alpha), 1.0, "default-bold", "center", "center", false, true)

    if hud.killText and now < hud.killUntil then
        local left = hud.killUntil - now
        local killAlpha = 255
        if left < 600 then
            killAlpha = math.floor(255 * (left / 600))
        end

        local kW, kH = 760, 70
        local kX, kY = (sx - kW) / 2, (sy / 2) - 120
        dxDrawRectangle(kX, kY, kW, kH, tocolor(0, 0, 0, math.floor(150 * (killAlpha / 255))), false)
        dxDrawRectangle(kX, kY, kW, 4, tocolor(220, 25, 25, killAlpha), false)
        dxDrawText(hud.killText, kX, kY, kX + kW, kY + kH, tocolor(255, 255, 255, killAlpha), 1.65, "default-bold", "center", "center", false, false, false, false)
    end
end

addEvent("Fabrikwar.hudStart", true)
addEventHandler("Fabrikwar.hudStart", root, function(phase, remainingMs, attackers, defenders, attackerName, defenderName, ar, ag, ab, dr, dg, db)
    local wasVisible = hud.visible
    hud.visible = true
    hud.phase = phase or "wait"
    hud.phaseEnd = getTickCount() + (remainingMs or 0)
    hud.attackers = attackers or 0
    hud.defenders = defenders or 0
    hud.attackerName = attackerName or getText("CFabrikwar3")
    hud.defenderName = defenderName or getText("CFabrikwar4")
    hud.attackerColor = {ar or 255, ag or 120, ab or 120}
    hud.defenderColor = {dr or 120, dg or 120, db or 255}
    if not wasVisible then
        hud.startTick = getTickCount()
    end

    if not Fabrikwar.hudRendered then
        addEventHandler("onClientRender", root, Fabrikwar.renderHud)
        Fabrikwar.hudRendered = true
    end
end)

addEvent("Fabrikwar.hudStop", true)
addEventHandler("Fabrikwar.hudStop", root, function()
    hud.visible = false
    if Fabrikwar.hudRendered then
        removeEventHandler("onClientRender", root, Fabrikwar.renderHud)
        Fabrikwar.hudRendered = false
    end
end)

addEvent("Fabrikwar.killMessage", true)
addEventHandler("Fabrikwar.killMessage", root, function(playerName)
    hud.killText = getText("CFabrikwar14"):format(tostring(playerName or getText("CFabrikwar5")))
    hud.killUntil = getTickCount() + 3000

    if not Fabrikwar.hudRendered then
        addEventHandler("onClientRender", root, Fabrikwar.renderHud)
        Fabrikwar.hudRendered = true
    end
end)