local itemData = {}

local isShowing = false
local yPos = -100
local targetY = 100
local barHeight = 70
local itemWidth = 55
local itemSpacing = 5
local stayTime = 2000
local animationDuration = 500
local animationStartTime = 0
local animationState = "slideDown"

local function getBarWidth()
    local totalItemWidth = math.min(10, #itemData) * itemWidth + (math.min(10, #itemData) - 1) * itemSpacing
    return totalItemWidth + 40
end

function drawItemBar()
    local screenWidth, screenHeight = guiGetScreenSize()
    local barWidth = getBarWidth()

    local now = getTickCount()
    if(animationState == "slideDown")then
        yPos = interpolateBetween(-100, 0, 0, targetY, 0, 0, (now - animationStartTime) / animationDuration, "OutQuad")
        if (now - animationStartTime) >= animationDuration then
            animationState = "stay"
            animationStartTime = getTickCount() + stayTime
        end
    elseif(animationState == "stay")then
        if now >= animationStartTime then
            animationState = "slideUp"
            animationStartTime = getTickCount()
        end
    elseif(animationState == "slideUp")then
        yPos = interpolateBetween(targetY, 0, 0, -100, 0, 0, (now - animationStartTime) / animationDuration, "InQuad")
        if (now - animationStartTime) >= animationDuration then
            yPos = -100
            isShowing = false
            removeEventHandler("onClientRender", root, drawItemBar)
            itemData = {}
            return
        end
    end

    dxDrawRectangle((screenWidth - barWidth) / 2, yPos, barWidth, barHeight, tocolor(0, 0, 0, 125))

    local xOffset = 20
    for i = 1, math.min(10, #itemData) do
        local imgX = (screenWidth - barWidth) / 2 + xOffset
        if i == 10 and #itemData > 10 then
            dxDrawRectangle(imgX, yPos + 10, itemWidth, itemWidth, tocolor(100, 100, 100, 200))
            dxDrawText("+" .. (#itemData - 10), imgX, yPos + 10, imgX + itemWidth, yPos + 10 + itemWidth, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center")
        else
            dxDrawImage(imgX, yPos + 10, itemWidth, itemWidth, "Files/Images/Inventory/" .. itemData[i][1] .. ".png")
        end
        xOffset = xOffset + itemWidth + itemSpacing
    end
end

function showItemBar(items)
    isShowing = true
    yPos = -100
    itemData = {}

    for _, v in pairs(items) do
		if(v[2] >= 1)then
			table.insert(itemData, { v[1], v[2] })
		end
    end

    animationState = "slideDown"
    animationStartTime = getTickCount()
    addEventHandler("onClientRender", root, drawItemBar)
end
addEvent("showItemBar", true)
addEventHandler("showItemBar", root, showItemBar)

addEventHandler("onClientPlayerWasted",root,function()
	if(source == localPlayer)then
        yPos = -100
        removeEventHandler("onClientRender", root, drawItemBar)
        itemData = {}
	end
end)