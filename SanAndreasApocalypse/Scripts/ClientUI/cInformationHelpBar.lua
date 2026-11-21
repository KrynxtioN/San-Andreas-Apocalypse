local screenW, screenH = guiGetScreenSize()
InformationHelpBarOpen = false

local barHeight = 100
local titleBarHeight = 5
local animDuration = 800
local visible = false

local title = ""
local message = ""

local state = "hidden" -- hidden, showing, visible, hiding
local animStartTick   = 0
local visibleUntil    = 0

local messageCooldowns = {}
local cooldownTime = 5 * 60 * 1000

local function dxDrawInformationHelpBar()
    if not visible then return end

    local now = getTickCount()
    local y = screenH

    if state == "showing" then
        local progress = (now - animStartTick) / animDuration
        if progress >= 1 then
            progress = 1
            state = "visible"
        end

        y = interpolateBetween(
            screenH, 0, 0,
            screenH - barHeight, 0, 0,
            progress,
            "OutQuad"
        )

    elseif state == "visible" then
        y = screenH - barHeight

        if now >= visibleUntil then
            state = "hiding"
            animStartTick = now
        end

    elseif state == "hiding" then
        local progress = (now - animStartTick) / animDuration
        if progress >= 1 then
            progress = 1
            state = "hidden"
            visible = false
			InformationHelpBarOpen = false
            removeEventHandler("onClientHUDRender", root, dxDrawInformationHelpBar)
			triggerServerEvent("loadCompass",localPlayer)
            return
        end

        y = interpolateBetween(
            screenH - barHeight, 0, 0,
            screenH, 0, 0,
            progress,
            "InQuad"
        )
    end

    dxDrawRectangle(0, y, screenW, barHeight, tocolor(0, 0, 0, 255))
    dxDrawRectangle(0, y, screenW, titleBarHeight, tocolor(180, 0, 0, 255))

    dxDrawText(
        title,
        25, y,
        screenW - 15, (y + titleBarHeight) - 25,
        tocolor(255, 255, 255, 255),
        1.2,
        "sans",
        "left",
        "center",
        false,
        false,
        false
    )

    dxDrawText(
        message,
        15, y + titleBarHeight,
        screenW - 15, y + barHeight - 10,
        tocolor(255, 255, 255, 255),
        1.2,
        "sans",
        "left",
        "center",
        true,
        true,
        false
    )
end

function showInformationHelpBar(t, m)
    local newTitle = t or ""
    local newMessage = m or ""

    local uniqueKey = newTitle .. "||" .. newMessage
    local now = getTickCount()

    if messageCooldowns[uniqueKey] and now < messageCooldowns[uniqueKey] then
        return
    end

    messageCooldowns[uniqueKey] = now + cooldownTime

    title = newTitle
    message = newMessage

    local charCount = utf8.len(message) or string.len(message)
    local displayTime = math.max(1500, charCount * 50)

    state = "showing"
    animStartTick = now
    visibleUntil = animStartTick + animDuration + displayTime
    visible = true
	InformationHelpBarOpen = true

    removeEventHandler("onClientHUDRender", root, dxDrawInformationHelpBar)
    addEventHandler("onClientHUDRender", root, dxDrawInformationHelpBar, true, "high+10")
	setPlayerHudComponentVisible("radar",false)
end
addEvent("showInformationHelpBar", true)
addEventHandler("showInformationHelpBar", root, showInformationHelpBar)