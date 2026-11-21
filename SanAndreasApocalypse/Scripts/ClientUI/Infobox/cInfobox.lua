Infobox = {
    Active = false,
    State = "hidden", -- hidden | enter | show | exit
    Data = {
        alpha = 255,
        message = "",
        timerEnd = 0,
    },
    Time = 4000,
    Timer = nil,
    ExitTimer = nil,
    Animation = {
        StartTick = nil,
        Duration = 1000,
    }
}

local screenWidth, screenHeight = guiGetScreenSize()

function createInfobox(message)
    if not isPedDead(localPlayer) and message then
        if Infobox.Active then
            Infobox.Data.message = message
            Infobox.Data.timerEnd = getTickCount() + Infobox.Time

            if isTimer(Infobox.Timer) then killTimer(Infobox.Timer) end
            if isTimer(Infobox.ExitTimer) then killTimer(Infobox.ExitTimer) end

            Infobox.State = "show"
            Infobox.Animation.StartTick = getTickCount()
        else
            playSound("Files/Sounds/Infobox.wav")

            Infobox.Active = true
            Infobox.State = "enter"
            Infobox.Data.message = message
            Infobox.Data.timerEnd = getTickCount() + Infobox.Time
            Infobox.Animation.StartTick = getTickCount()

            addEventHandler("onClientRender", root, Infobox.renderBox)
        end

        Infobox.Timer = setTimer(function()
            Infobox.State = "exit"
            Infobox.Animation.StartTick = getTickCount()

            Infobox.ExitTimer = setTimer(function()
                Infobox.Active = false
                Infobox.State = "hidden"
                Infobox.Data.alpha = 255
                removeEventHandler("onClientRender", root, Infobox.renderBox)
            end, Infobox.Animation.Duration, 1)
        end, Infobox.Time, 1)
    end
end
addEvent("createInfobox", true)
addEventHandler("createInfobox", root, createInfobox)

function Infobox.renderBox()
    if not Infobox.Active then return end

    local animProgress = math.min(
        (getTickCount() - Infobox.Animation.StartTick) / Infobox.Animation.Duration,
        1
    )

    local boxWidth  = 324 * (screenWidth / 1920)
    local boxHeight =  84 * (screenHeight / 1080)
    local baseX     = (screenWidth - boxWidth) / 2

    local baseY

    if Infobox.State == "enter" then
        baseY = interpolateBetween(-100,0,0, 10,0,0, animProgress, "OutQuad")
    elseif Infobox.State == "exit" then
        baseY = interpolateBetween(10,0,0, -100,0,0, animProgress, "InQuad")
    else
        baseY = 10
    end

    dxDrawRectangle(baseX, baseY, boxWidth, boxHeight, tocolor(0, 0, 0, 175), true)

    dxDrawText(
        Infobox.Data.message,
        baseX,
        baseY,
        baseX + boxWidth,
        baseY + boxHeight,
        tocolor(255, 255, 255, 255),
        1.20 * (screenHeight / 1080),
        "default",
        "center",
        "center",
        true,
        true,
        true
    )

    local elapsed = getTickCount() - (Infobox.Data.timerEnd - Infobox.Time)
    local remaining = math.max(Infobox.Time - elapsed, 0)
    local progressW = (remaining / Infobox.Time) * boxWidth

    dxDrawRectangle(
        baseX,
        baseY + boxHeight - 5,
        progressW,
        5,
        tocolor(200, 10, 0, 200),
        true
    )
end

addEventHandler("onClientPlayerWasted", localPlayer, function()
    if source == localPlayer then
        Infobox.Active = false
        Infobox.State = "hidden"

        if isTimer(Infobox.Timer) then killTimer(Infobox.Timer) end
        if isTimer(Infobox.ExitTimer) then killTimer(Infobox.ExitTimer) end

        removeEventHandler("onClientRender", root, Infobox.renderBox)
    end
end)