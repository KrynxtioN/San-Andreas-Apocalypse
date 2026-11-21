local screenWidth, screenHeight = guiGetScreenSize()
local barWidth = 800
local barHeight = 50
local barY = (screenHeight - barHeight) / 2
local InformationText = nil
local animationDuration = 5
local midPauseDuration = 1
local animationStartTime
local isAnimating = false

local easingType = "InOutQuad"
local textFont = "default-bold"
local textScale = 2
local barColor = tocolor(0, 0, 0, 200)
local textColor = tocolor(255, 255, 255, 255)

local function drawAnimatedBar()
    if not animationStartTime then return end

    local elapsedTime = getTickCount() - animationStartTime
    local totalAnimationTime = animationDuration * 1000
    local progress = elapsedTime / totalAnimationTime

    if progress > 1 then
        progress = 1
        removeEventHandler("onClientRender", root, drawAnimatedBar)
        isAnimating = false
    end

    local barX, scaleFactor
    if progress <= 0.5 then
        local phaseProgress = progress / 0.5
        barX = interpolateBetween(screenWidth, 0, 0, (screenWidth - barWidth) / 2, 0, 0, phaseProgress, easingType)
        scaleFactor = interpolateBetween(1, 0, 0, 1.2, 0, 0, phaseProgress, easingType)
    elseif progress <= 0.5 + (midPauseDuration / animationDuration) then
        local phaseProgress = (progress - 0.5) / (midPauseDuration / animationDuration)
        barX = (screenWidth - barWidth) / 2
        scaleFactor = interpolateBetween(1.2, 0, 0, 1.3, 0, 0, phaseProgress, easingType)
    else
        local phaseProgress = (progress - 0.5 - (midPauseDuration / animationDuration)) / (1 - 0.5 - (midPauseDuration / animationDuration))
        barX = interpolateBetween((screenWidth - barWidth) / 2, 0, 0, -barWidth, 0, 0, phaseProgress, easingType)
        scaleFactor = interpolateBetween(1.3, 0, 0, 1, 0, 0, phaseProgress, easingType)
    end

    local adjustedBarWidth = barWidth * scaleFactor
    local adjustedBarHeight = barHeight * scaleFactor
    local adjustedBarX = barX - (adjustedBarWidth - barWidth) / 2
    local adjustedBarY = barY - (adjustedBarHeight - barHeight) / 2

    dxDrawText(InformationText, adjustedBarX, adjustedBarY, adjustedBarX + adjustedBarWidth, adjustedBarY + adjustedBarHeight, textColor, textScale * scaleFactor, textFont, "center", "center", true)
end

local function startBarAnimation()
    if isAnimating then return end
    animationStartTime = getTickCount()
    isAnimating = true
    addEventHandler("onClientRender", root, drawAnimatedBar)
end

function createInformationMessage(text)
	if(text)then
		InformationText = text
		startBarAnimation()
	end
end
addEvent("createInformationMessage",true)
addEventHandler("createInformationMessage",root,createInformationMessage)