ActivitiesInformation = {}

local panelX, targetX = -300, 50
local panelY, panelWidth, panelHeight = 200, 200, 100
local iconPath = "Files/Images/Activities/Info.png"
local displayTime = 6500
local animationDuration = 1000

local startTick = nil
local showing = false

function ActivitiesInformation.Render()
    if not startTick then return end

    local now = getTickCount()
    local elapsedTime = now - startTick
    local progress = math.min(elapsedTime / animationDuration, 1)
    local moveX

    if showing then
        moveX = interpolateBetween(panelX, 0, 0, targetX, 0, 0, progress, "OutQuad")
    else
        moveX = interpolateBetween(targetX, 0, 0, panelX, 0, 0, progress, "InQuad")
    end

    if ActivitiesInformation.Text then
        dxDrawRectangle(moveX, panelY, panelWidth, panelHeight, tocolor(0, 0, 0, 200), true)

        local iconSize = 50

        dxDrawText(
            ActivitiesInformation.Text,
            moveX + iconSize + 20,
            panelY,
            moveX + panelWidth - 10,
            panelY + panelHeight,
            tocolor(255, 255, 255, 255),
            1,
            "default-bold",
            "left",
            "center",
            false,
            true,
            true
        )

        local remainingTime = math.ceil((startTick + displayTime - now) / 1000)
        dxDrawText(
            tostring(remainingTime) .. "s",
            moveX + panelWidth - 40,
            panelY + panelHeight - 30,
            moveX + panelWidth,
            panelY + panelHeight,
            tocolor(255, 255, 255, 255),
            0.8,
            "default-bold",
            "center",
            "center",
            false,
            true,
            true
        )

        dxDrawImage(moveX + 10, panelY + (panelHeight - iconSize) / 2, iconSize, iconSize, iconPath, 0, 0, 0, tocolor(255, 255, 255, 255), true)
    end

    if not showing and progress >= 1 then
        removeEventHandler("onClientRender", root, ActivitiesInformation.Render)
        ActivitiesInformation.Text = nil
        startTick = nil
    end
end

function createActivitiesInformationText(Text)
    if not showing then
        ActivitiesInformation.Text = Text
        startTick = getTickCount()
        showing = true
		
		removeEventHandler("onClientRender",root,ActivitiesInformation.Render)
        addEventHandler("onClientRender", root, ActivitiesInformation.Render)

        setTimer(function()
            showing = false
            startTick = getTickCount()
        end, displayTime, 1)
    end
end
addEvent("createActivitiesInformationText", true)
addEventHandler("createActivitiesInformationText", root, createActivitiesInformationText)

addEventHandler("onClientPlayerWasted", root, function()
    if source == localPlayer then
        removeEventHandler("onClientRender", root, ActivitiesInformation.Render)
        ActivitiesInformation.Text = nil
        startTick = nil
        showing = false
    end
end)