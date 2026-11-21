local rendered = false
local x, y = guiGetScreenSize()

local rectangles = {}
local currentRectangle = nil
local gameStarted = false
local startTime = 0
local timeLimit = 15 * 1000
local screenWidth, screenHeight = guiGetScreenSize()
local score = 0
local nextPosition = {}

function VehicleLoot.InfoRender()
    if (VehicleLoot.text) then
        dxDrawText(VehicleLoot.text, 643 * (x / 1920), 1032 * (y / 1080), 1277 * (x / 1920), 1075 * (y / 1080), tocolor(255, 255, 255, 255), 1.20, "default", "center", "center", false, false, false, true)
    end
end

addEvent("VehicleLoot.Info", true)
addEventHandler("VehicleLoot.Info", root, function(text)
    if (text) then
        VehicleLoot.text = text
        if (rendered == false) then
            rendered = true
            addEventHandler("onClientRender", root, VehicleLoot.InfoRender)
        end
    else
        rendered = false
        removeEventHandler("onClientRender", root, VehicleLoot.InfoRender)
    end
end)

addEvent("VehicleLoot.createPlayerMarker", true)
addEventHandler("VehicleLoot.createPlayerMarker", root, function(Coordinates)
    for i, v in ipairs(Coordinates) do
        if (not(isElement(VehicleLoot.marker[i]))) then
            VehicleLoot.marker[i] = createMarker(v[1], v[2], v[3], "corona", 1, 255, 255, 255, 100)
        end
    end
end)

addEvent("VehicleLoot.updateMarkerColor", true)
addEventHandler("VehicleLoot.updateMarkerColor", root, function(ID, r, g, b)
    local ID = tonumber(ID)
    if (isElement(VehicleLoot.marker[ID])) then
        setMarkerColor(VehicleLoot.marker[ID], r, g, b, 100)
    end
end)

addEvent("VehicleLoot.markerAlpha",true)
addEventHandler("VehicleLoot.markerAlpha",root,function(ID, alpha)
    local ID = tonumber(ID)
    if (isElement(VehicleLoot.marker[ID])) then
        setElementAlpha(VehicleLoot.marker[ID], alpha)
    end
end)

function VehicleLoot.startMiniGame()
    if gameStarted then return end
    
    gameStarted = true
    score = 0
    startTime = getTickCount()
    
    VehicleLoot.createRandomRectangle()
end

function VehicleLoot.createRandomRectangle()
    local rectWidth, rectHeight = 50, 50
    local x = math.random(0, screenWidth - rectWidth)
    local y = math.random(0, screenHeight - rectHeight)
    if (nextPosition[1] and nextPosition[2]) then
        x = nextPosition[1]
        y = nextPosition[2]
    end
    nextPosition = {math.random(0, screenWidth - rectWidth), math.random(0, screenHeight - rectHeight)}
    local color = tocolor(math.random(255), math.random(255), math.random(255), 200)
        
    if (x + rectWidth > screenWidth) then
        x = screenWidth - rectWidth
    end
    if (y + rectHeight > screenHeight) then
        y = screenHeight - rectHeight
    end
        
    if (x < 0) then x = 0 end
    if (y < 0) then y = 0 end
        
    currentRectangle = {
        x = x,
        y = y,
        color = color,
        image = "Files/Images/Inventory/" .. possibleLootItems[math.random(1, #possibleLootItems)] .. ".png"
    }
end

local function onClientClick(button, state, absoluteX, absoluteY)
    if (not(gameStarted)) then return end

    if (button == "left" and state == "down") then
        if (currentRectangle) then
            local rectX, rectY = currentRectangle.x, currentRectangle.y
            if (absoluteX >= rectX and absoluteX <= rectX + 50 and absoluteY >= rectY and absoluteY <= rectY + 50) then
                score = score + 1
                VehicleLoot.createRandomRectangle()
                return
            end
        end
    end
end

local function onClientRender()
    if (not(gameStarted)) then return end

    local currentTime = getTickCount()
    local elapsedTime = currentTime - startTime

    if (elapsedTime > timeLimit) then
        gameStarted = false
        VehicleLoot.stopGame()
        triggerServerEvent("VehicleLoot.giveItem", localPlayer, score)
        return
    end
    setPlayerHudComponentVisible("radar", false)
    if (currentRectangle) then
        local glowThickness = 5
        local pulse = math.abs(math.sin(getTickCount() / 500))
        local baseAlpha = 50 + pulse * 150

        for i = glowThickness, 1, -1 do
            local layerAlpha = baseAlpha * (i / glowThickness)
            dxDrawRectangle(currentRectangle.x - i, currentRectangle.y - i, 50 + i * 2, 50 + i * 2, tocolor(255, 255, 0, layerAlpha))
        end

        dxDrawRectangle(currentRectangle.x, currentRectangle.y, 50, 50, tocolor(0, 0, 0, 150))
        dxDrawImage(currentRectangle.x, currentRectangle.y, 50, 50, currentRectangle.image)
        dxDrawRectangle(nextPosition[1], nextPosition[2], 50, 50, tocolor(0, 0, 0, 100))
        dxDrawImage(nextPosition[1], nextPosition[2], 50, 50, "Files/Images/MarkQuestion.png", 0, 0, 0, tocolor(255, 255, 255, 100), false)
    end
end

addEvent("VehicleLoot.startGame", true)
addEventHandler("VehicleLoot.startGame", root, function()
    setWindowData("no")
    showCursor(true)
    VehicleLoot.startMiniGame()
    addEventHandler("onClientClick", root, onClientClick)
    addEventHandler("onClientRender", root, onClientRender)
end)

function VehicleLoot.stopGame()
    closeWindow()
    removeEventHandler("onClientClick", root, onClientClick)
    removeEventHandler("onClientRender", root, onClientRender)
    nextPosition = {}
    triggerServerEvent("checkCompass",localPlayer)
	startTime = 0
end
addEvent("VehicleLoot.stopGame", true)
addEventHandler("VehicleLoot.stopGame", root, VehicleLoot.stopGame)

addEventHandler("onClientPlayerWasted", localPlayer, function()
    if (source == localPlayer) then
        removeEventHandler("onClientRender", root, VehicleLoot.InfoRender)
    end
end)
