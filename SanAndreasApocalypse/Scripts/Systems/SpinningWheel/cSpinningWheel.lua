local screenWidth, screenHeight = guiGetScreenSize()

local centerX, centerY = screenWidth / 2, screenHeight / 2
local wheelRadius = 200
local fieldCount = 16
local fieldAngle = 360 / fieldCount
local prizes = {}

local spinning = false
local spinStartTime = 0
local spinDuration = 5
local startAngle = 0
local endAngle = 0
local currentAngle = 0
local winningPrize = nil
local showWinningText = false
local winningTextAlpha = 0
local winningTextStartTime = 0

local prizeTypes = {
    {type = "EXP", color = tocolor(176, 195, 217, 255), chance = 25.0},
    {type = "Money", color = tocolor(94, 152, 217, 255), chance = 25.0},
    {type = "Brainmass", color = tocolor(94, 152, 217, 255), chance = 25.0},
    {type = "Freespin", color = tocolor(75, 105, 255, 255), chance = 10.0},
    {type = "Coupon", color = tocolor(136, 71, 255, 255), chance = 7.0},
    {type = "SpecialItem", color = tocolor(211, 44, 230, 255), chance = 4.0},
    {type = "SACoinChest", color = tocolor(235, 75, 75, 255), chance = 2.5},
    {type = "VehicleChest", color = tocolor(228, 174, 51, 255), chance = 1.5}
}

local prizeImages = {
    ["EXP"] = "Files/Images/SpinningWheel/EXP.png", 
    ["Money"] = "Files/Images/SpinningWheel/Money.png", 
    ["Brainmass"] = "Files/Images/SpinningWheel/Brainmass.png", 
    ["Freespin"] = "Files/Images/SpinningWheel/Freespin.png", 
    ["Coupon"] = "Files/Images/SpinningWheel/BonusCoupon.png", 
    ["SpecialItem"] = "Files/Images/SpinningWheel/SpecialItem.png", 
    ["SACoinChest"] = "Files/Images/SpinningWheel/SACoinChest.png",
    ["VehicleChest"] = "Files/Images/SpinningWheel/VehicleChest.png",
}

local function dxDrawTriangle(x1, y1, x2, y2, x3, y3, color)
    dxDrawLine(x1, y1, x2, y2, color)
    dxDrawLine(x2, y2, x3, y3, color)
    dxDrawLine(x3, y3, x1, y1, color)
end

local function dxDrawPie(cx, cy, radius, startAngle, endAngle, color)
    local segments = 50
    local angleStep = (endAngle - startAngle) / segments

    for i = 0, segments - 1 do
        local x1 = cx + math.cos(startAngle + i * angleStep) * radius
        local y1 = cy + math.sin(startAngle + i * angleStep) * radius
        local x2 = cx + math.cos(startAngle + (i + 1) * angleStep) * radius
        local y2 = cy + math.sin(startAngle + (i + 1) * angleStep) * radius

        dxDrawTriangle(cx, cy, x1, y1, x2, y2, color)
    end
end

local easingFunctions = {}
function easingFunctions.InOutQuad(progress)
    return progress < 0.5 and 2 * progress * progress or -1 + (4 - 2 * progress) * progress
end

function easingFunctions.OutBounce(t)
    if(t < 1 / 2.75)then
        return 7.5625 * t * t
    elseif(t < 2 / 2.75)then
        t = t - 1.5 / 2.75
        return 7.5625 * t * t + 0.75
    elseif(t < 2.5 / 2.75)then
        t = t - 2.25 / 2.75
        return 7.5625 * t * t + 0.9375
    else
        t = t - 2.625 / 2.75
        return 7.5625 * t * t + 0.984375
    end
end

local function generatePrizes()
    prizes = {}
    for i = 1, fieldCount do
        local rand = math.random() * 100
        local accumulatedChance = 0

        for _, prizeType in ipairs(prizeTypes) do
            accumulatedChance = accumulatedChance + prizeType.chance
            if(rand <= accumulatedChance)then
                table.insert(prizes, prizeType)
                break
            end
        end
    end
end

function startSpin()
    if(not(spinning))then
        spinning = true
        spinStartTime = getTickCount()
        startAngle = currentAngle % 360
        endAngle = startAngle + 360 * 3 + math.random(360)
        winningPrize = nil
        showWinningText = false
    end
end
addEvent("startSpin", true)
addEventHandler("startSpin", root, startSpin)

function confirmPrize()
    triggerServerEvent("giveSpinPrice", localPlayer, winningPrize.type)
    generatePrizes()
    showWinningText = false
    unbindKey("space", "down", confirmPrize)
end

local function isPointInSegment(px, py, cx, cy, radius, startAngleRad, endAngleRad)
    local dx = px - cx
    local dy = py - cy
    local angle = math.atan2(dy, dx)
    if(angle < 0)then angle = angle + 2 * math.pi end

    local segmentStart = startAngleRad
    local segmentEnd = endAngleRad

    if(segmentStart <= segmentEnd)then
        return angle >= segmentStart and angle <= segmentEnd
    else
        return angle >= segmentStart or angle <= segmentEnd
    end
end

function renderWheel()
    local currentX = centerX

    if(spinning)then
        local elapsedTime = (getTickCount() - spinStartTime) / 1000
        if(elapsedTime < spinDuration)then
            local progress = elapsedTime / spinDuration
            currentAngle = startAngle + (endAngle - startAngle) * easingFunctions.InOutQuad(progress)
        else
            spinning = false
            currentAngle = endAngle % 360

            local normalizedAngle = (currentAngle % 360)
            local anglePerField = 360 / fieldCount
            local winningIndex = math.floor((normalizedAngle / anglePerField) % fieldCount) + 1

            if(winningIndex > fieldCount)then
                winningIndex = fieldCount
            end

            local redLineX = currentX
            local redLineY = centerY - wheelRadius - 20

            local foundIndex = nil
            for i = 1, fieldCount do
                local startAngleRad = math.rad(currentAngle + (i - 1) * fieldAngle)
                local endAngleRad = math.rad(currentAngle + i * fieldAngle)
                
                if(isPointInSegment(redLineX, redLineY, currentX, centerY, wheelRadius, startAngleRad, endAngleRad))then
                    foundIndex = i
                    break
                end
            end
            
            if foundIndex then
                winningPrize = prizes[foundIndex]
            else
                winningPrize = prizes[winningIndex]
            end

            showWinningText = true
            winningTextStartTime = getTickCount()
            bindKey("space", "down", confirmPrize)
        end
    end

    for i = 1, fieldCount do
        local prize = prizes[i]
        local startAngleRad = math.rad(currentAngle + (i - 1) * fieldAngle)
        local endAngleRad = math.rad(currentAngle + i * fieldAngle)

        dxDrawPie(currentX, centerY, wheelRadius, startAngleRad, endAngleRad, prize.color)

        local midAngleRad = (startAngleRad + endAngleRad) / 2
        local imageX = currentX + math.cos(midAngleRad) * (wheelRadius / 2) - 16
        local imageY = centerY + math.sin(midAngleRad) * (wheelRadius / 2) - 16

        local imagePath = prizeImages[prize.type]
        if(imagePath)then
            dxDrawImage(imageX, imageY, 32, 32, imagePath)
        end
    end

    dxDrawLine(currentX, centerY - wheelRadius - 20, currentX, centerY - wheelRadius - 40, tocolor(255, 0, 0, 255), 3)
    
    local screenWidth, screenHeight = guiGetScreenSize()
    local boxWidth, boxHeight = 500, 50
    local boxX = (screenWidth - boxWidth) / 2
    local boxY = screenHeight - boxHeight - 20

    dxDrawRectangle(boxX, boxY, boxWidth, boxHeight, tocolor(0, 0, 0, 150))
    dxDrawText(getText("CSpinningWheel1"):format(apocalypseGetElementData(localPlayer, "freespins")), boxX, boxY, boxX + boxWidth, boxY + boxHeight, tocolor(255, 255, 255, 255), 1.2, "default-bold", "center", "center")

    if(showWinningText and winningPrize)then
        local winBoxWidth, winBoxHeight = 400, 100
        local winBoxX = (screenWidth - winBoxWidth) / 2
        local winBoxY = (screenHeight - winBoxHeight) / 2
        dxDrawRectangle(winBoxX, winBoxY, winBoxWidth, winBoxHeight, tocolor(0, 0, 0, 200))
        dxDrawText(getText("CSpinningWheel3"):format(winningPrize.type), winBoxX, winBoxY, winBoxX + winBoxWidth, winBoxY + winBoxHeight, tocolor(255, 255, 255, 255), 1.2, "default-bold", "center", "center")
    end
end

function checkStartSpin()
    if(not(spinning) and showWinningText ~= true)then
        triggerServerEvent("checkStartSpin", localPlayer, "freespin")
    end
end

function openSpinningWheel()
    if(isCharacterLoggedIn() and isWindowOpen())then
        NPC.NormalMessage(getText("CSpinningWheel2"))
        bindKey("enter", "down", checkStartSpin)
        if #prizes == 0 then
            generatePrizes()
        end
        addEventHandler("onClientRender", root, renderWheel)
        bindKey("backspace", "down", closeSpinningWheel)
        toggleAllControls(false)
    end
end

function closeSpinningWheel()
    if(not(spinning))then
        unbindKey("enter", "down", checkStartSpin)
        removeEventHandler("onClientRender", root, renderWheel)
        unbindKey("backspace", "down", closeSpinningWheel)
        unbindKey("space", "down", confirmPrize)
        toggleAllControls(true)
    end
end

addEventHandler("onClientPlayerWasted", root, function()
    if(source == localPlayer)then
        unbindKey("enter", "down", checkStartSpin)
        removeEventHandler("onClientRender", root, renderWheel)
        unbindKey("backspace", "down", closeSpinningWheel)
        unbindKey("space", "down", confirmPrize)
    end
end)
