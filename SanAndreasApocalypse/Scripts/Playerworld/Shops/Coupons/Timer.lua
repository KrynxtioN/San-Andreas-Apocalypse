local screenWidth, screenHeight = guiGetScreenSize()
local startX = screenWidth - 100
local startY = screenHeight / 2
local rectWidth = 100
local rectHeight = 40
local expandedWidth = 200
local timerList = {}

local function formatTimestamp(remainingSeconds)
    local hours = math.floor(remainingSeconds / 3600)
    local minutes = math.floor((remainingSeconds % 3600) / 60)
    return string.format("%02d:%02d", hours, minutes)
end

function addTimer(serverEndTime, title, image)
    for i, timerData in ipairs(timerList) do
        if(timerData.title == title)then
            timerData.endTime = serverEndTime
            return
        end
    end
    table.insert(timerList, {endTime = serverEndTime, title = title, isHovered = false, image = image})
end
addEvent("addTimer", true)
addEventHandler("addTimer", root, addTimer)

function renderTimers()
    if(isCharacterLoggedIn() and not(isPedDead(localPlayer)) and #timerList >= 1)then
        local mx, my = getCursorPosition()
        if(mx and my)then
            mx, my = mx * screenWidth, my * screenHeight
        end

        for i, timerData in ipairs(timerList) do
            local timerX = startX
            local timerY = startY + (i - 1) * (rectHeight + 10)
            local currentTime = getRealTime().timestamp
            local remainingTime = timerData.endTime - currentTime

            if(remainingTime <= 0)then
               table.remove(timerList, i)
            else
                timerData.isHovered = mx and my and mx >= timerX and mx <= timerX + rectWidth and my >= timerY and my <= timerY + rectHeight

                local currentWidth = timerData.isHovered and expandedWidth or rectWidth
                local bgColor = timerData.isHovered and tocolor(50, 50, 50, 200) or tocolor(30, 30, 30, 150)
                dxDrawRectangle(timerX - (currentWidth - rectWidth), timerY, currentWidth, rectHeight, bgColor, true)

                dxDrawImage(timerX - (currentWidth - rectWidth) + 5, timerY + 5, 30, 30, "Files/Images/Timer/"..timerData.image..".png", 0, 0, 0, tocolor(255, 255, 255), true)

                if(timerData.isHovered)then
                    dxDrawText(timerData.title, timerX - (expandedWidth - rectWidth) + 40, timerY + 5, timerX + expandedWidth, timerY + rectHeight, tocolor(255, 255, 255), 1, "default", "left", "top", false, false, true)
                    dxDrawText(formatTimestamp(remainingTime), timerX - (expandedWidth - rectWidth) + 40, timerY + 20, timerX + expandedWidth, timerY + rectHeight, tocolor(255, 255, 255), 1, "default", "left", "top", false, false, true)
                else
                    dxDrawText(formatTimestamp(remainingTime), timerX + 40, timerY + 10, timerX + rectWidth, timerY + rectHeight, tocolor(255, 255, 255), 1, "default", "left", "top", false, false, true)
                end
            end
        end
    end
end
addEventHandler("onClientRender", root, renderTimers)