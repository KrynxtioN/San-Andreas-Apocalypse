apocalypseSetElementData(localPlayer,"FishingStartBind",false) 

Fishing = {}

local UI_X, UI_Y      = 400, 120
local UI_W, UI_H      = 80, 300
local BAR_W, BAR_H    = UI_W - 20, 60
local FISH_W, FISH_H  = 40, 20

local BAR_FALL_RATE   = 2
local BAR_LIFT_RATE   = 5

local PROG_UP_RATE    = 0.002
local PROG_DOWN_RATE  = 0.002

local fishTypes = {
    { speed = 1.0, weight = 10, id = 142, experience = 5 },
    { speed = 1.1, weight = 9, id = 141, experience = 5 },
    { speed = 1.2, weight = 8, id = 140, experience = 5 },
    { speed = 1.3, weight = 7, id = 139, experience = 10 },
    { speed = 1.4, weight = 6, id = 138, experience = 10 },
    { speed = 1.6, weight = 5, id = 137, experience = 10 },
    { speed = 1.8, weight = 4, id = 136, experience = 15 },
    { speed = 2.0, weight = 3, id = 135, experience = 15 },
    { speed = 2.2, weight = 2, id = 134, experience = 15 },
    { speed = 2.5, weight = 1, id = 133, experience = 25 },
}

local fishingText = ""
local fishingActive = false

local function drawText3D(x,y,z,text,r,g,b)
    local sx,sy = getScreenFromWorldPosition(x,y,z+1,0.06)
    if sx and sy then
        dxDrawText(text,sx,sy,sx,sy,tocolor(r,g,b,255),1,"default-bold","center","center")
    end
end

local function renderText()
    local x,y,z = getElementPosition(localPlayer)
    drawText3D(x,y,z,fishingText,255,255,255)
end

addEvent("Fishing.renderText",true)
addEventHandler("Fishing.renderText",root,function()
    removeEventHandler("onClientRender",root,renderText)
	addEventHandler("onClientRender",root,renderText)
end)

addEvent("Fishing.unrenderText",true)
addEventHandler("Fishing.unrenderText",root,function()
	removeEventHandler("onClientRender",root,renderText)
end)

local function updateFishingText(state)
    if state then
        fishingText = getText("CFishing2")
        fishingActive = true
    else
        fishingText = getText("CFishing1")
        fishingActive = false
    end
end

local function getFishPoolForBait(baitId)
    if baitId == 109 then
        return {1,2,3}
    elseif baitId == 110 then
        return {1,2,3,4,5,6,7}
    elseif baitId == 111 then
        return {1,2,3,4,5,6,7,8,9,10}
    elseif baitId == 209 then
        return {1,2,3,4,5,6,7,8,9,10}
    else
        return {}
    end
end

local function getTotalWeight(pool)
    local total = 0
    for _, i in ipairs(pool) do
        total = total + fishTypes[i].weight
    end
    return total
end

local function chooseRandomFish(pool)
    local totalWeight = getTotalWeight(pool)
    local r = math.random() * totalWeight
    local cum = 0
    for _, i in ipairs(pool) do
        cum = cum + fishTypes[i].weight
        if r <= cum then
            return fishTypes[i]
        end
    end
    return fishTypes[pool[#pool]]
end

local barY            = 0
local fishY           = 0
local fishDir         = 1
local catchProgress   = 0.2
local currentFish     = nil
local rendered        = false

local function actuallyStartFishing(pool)
    catchProgress = 0.2
    rendered = true

    currentFish = chooseRandomFish(pool)

    fishY = math.random(0, UI_H - FISH_H)
    fishDir = (math.random(0,1) == 1) and 1 or -1
    barY = UI_H - BAR_H

    removeEventHandler("onClientRender", root, renderFishingUI)
    addEventHandler("onClientRender", root, renderFishingUI)
end

function startFishingMiniGame(bait)
	local pool = getFishPoolForBait(tonumber(bait))
	updateFishingText(true)

    if rendered == false then
        Fishing.baitTimer = setTimer(function()
            if #pool > 0 then
                actuallyStartFishing(pool)
            else
                if math.random(100) <= 20 then
                    actuallyStartFishing({1})
                else
                    triggerServerEvent("Fishing.fail",localPlayer)
					stopFishingMiniGame()
					NPC.MeMessage(getText("CFishing4"))
                end
            end
        end, math.random(2000,5000), 1)
    end
end
addEvent("Fishing.start",true)
addEventHandler("Fishing.start",root,startFishingMiniGame)

function stopFishingMiniGame()
    rendered = false
	updateFishingText(false)
    removeEventHandler("onClientRender", root, renderFishingUI)
    removeEventHandler("onClientRender", root, Fishing.renderBaitDX)
	closeWindow()
	if(isTimer(Fishing.baitTimer))then killTimer(Fishing.baitTimer)end
    removeEventHandler("onClientRender",root,Fishing.renderBaitDX)
    removeEventHandler("onClientClick",root,clickBaitImage)
    showCursor(false)
end
addEvent("stopFishingMiniGame",true)
addEventHandler("stopFishingMiniGame",root,stopFishingMiniGame)

function renderFishingUI()
    barY = barY + BAR_FALL_RATE
    if getKeyState("mouse1") then
        barY = barY - BAR_LIFT_RATE
    end
    if barY < 0 then barY = 0 elseif barY > (UI_H - BAR_H) then barY = UI_H - BAR_H end

    local fishSpeed = currentFish.speed
    fishY = fishY + fishSpeed * fishDir
    if fishY <= 0 then fishY = 0 fishDir = 1
    elseif fishY >= (UI_H - FISH_H) then fishY = UI_H - FISH_H fishDir = -1 end

    local fishCenter = fishY + (FISH_H / 2)
    local barTop     = barY
    local barBottom  = barY + BAR_H

    if fishCenter >= barTop and fishCenter <= barBottom then
        catchProgress = catchProgress + PROG_UP_RATE
    else
        catchProgress = catchProgress - PROG_DOWN_RATE
    end

    if catchProgress > 1 then catchProgress = 1 elseif catchProgress < 0 then catchProgress = 0 end

    if catchProgress >= 1 then
        triggerServerEvent("Fishing.giveFish",localPlayer,currentFish.id,currentFish.experience)
        stopFishingMiniGame()
        return
    elseif catchProgress <= 0 then
        triggerServerEvent("Fishing.fail",localPlayer)
        stopFishingMiniGame()
		NPC.MeMessage(getText("CFishing5"))
        return
    end

    dxDrawRectangle(UI_X - 2, UI_Y - 2, UI_W + 4, UI_H + 4, tocolor(0, 0, 0, 200))
    dxDrawRectangle(UI_X, UI_Y, UI_W, UI_H, tocolor(30, 30, 30, 220))
    dxDrawRectangle(UI_X + ((UI_W - BAR_W) / 2), UI_Y + barY, BAR_W, BAR_H, tocolor(70, 200, 70, 220))
    dxDrawImage(UI_X + ((UI_W - FISH_W) / 2), UI_Y + fishY, FISH_W, FISH_H, "Files/Images/Inventory/"..currentFish.id..".png", 0, 0, 0, tocolor(255, 255, 255, 220))
    local progH = catchProgress * UI_H
    dxDrawRectangle(UI_X + UI_W + 4, UI_Y + (UI_H - progH), 8, progH, tocolor(255, 150, 0, 200))
end

local screenX, screenY = guiGetScreenSize()

local baitImages = {
    { id = 0, image = false },
    { id = 109, image = "Files/Images/Inventory/109.png" },
    { id = 110, image = "Files/Images/Inventory/110.png" },
    { id = 111, image = "Files/Images/Inventory/111.png" },
    { id = 209, image = "Files/Images/Inventory/209.png" },
}

local baitUI = {
    width = 80,
    height = 80,
    spacing = 30,
    y = screenY / 2 - 40,
}

local baitSelected = false

function Fishing.renderBaitDX()
    showCursor(true)
    local totalWidth = (#baitImages * baitUI.width) + ((#baitImages - 1) * baitUI.spacing)
    local startX = (screenX / 2) - (totalWidth / 2)

    for i, bait in ipairs(baitImages) do
        local x = startX + (i - 1) * (baitUI.width + baitUI.spacing)
        local y = baitUI.y

        if bait.image then
            dxDrawImage(x, y, baitUI.width, baitUI.height, bait.image)
        else
            dxDrawRectangle(x, y, baitUI.width, baitUI.height, tocolor(100,100,100,150))
            dxDrawText(getText("CFishing3"), x, y, x + baitUI.width, y + baitUI.height, tocolor(255,255,255,255), 1, "default-bold", "center", "center")
        end

        if bait.id ~= 0 then
            local count = hasPlayerItem(bait.id)
            local text = tostring(count)
            local fontSize = 1.0
            local textX = x + baitUI.width / 2
            local textY = y - 20
            dxDrawText(text,textX,textY,textX,textY,tocolor(255,255,255,255),fontSize,"default-bold","center","top")
        end

        if isMouseInPosition(x, y, baitUI.width, baitUI.height) then
            dxDrawRectangle(x, y, baitUI.width, baitUI.height, tocolor(255, 255, 255, 70))
        end
    end
end

function clickBaitImage(button, state)
    if baitSelected or button ~= "left" or state ~= "down" then return end

    local totalWidth = (#baitImages * baitUI.width) + ((#baitImages - 1) * baitUI.spacing)
    local startX = (screenX / 2) - (totalWidth / 2)

    for i, bait in ipairs(baitImages) do
        local x = startX + (i - 1) * (baitUI.width + baitUI.spacing)
        local y = baitUI.y

        if isMouseInPosition(x, y, baitUI.width, baitUI.height) then
            baitSelected = true
            showCursor(false)
            removeEventHandler("onClientRender",root,Fishing.renderBaitDX)
            removeEventHandler("onClientClick",root,clickBaitImage)
			triggerServerEvent("Fishing.playerFishing", localPlayer, localPlayer, bait.id)
            break
        end
    end
end

addEvent("Fishing.renderBait",true)
addEventHandler("Fishing.renderBait",root,function()
    baitSelected = false
    removeEventHandler("onClientRender",root,Fishing.renderBaitDX)
    removeEventHandler("onClientClick", root, clickBaitImage)
    addEventHandler("onClientRender",root,Fishing.renderBaitDX)
    addEventHandler("onClientClick", root, clickBaitImage)
end)

addEventHandler("onClientPlayerWasted",root,function()
    if(source == localPlayer)then
        stopFishingMiniGame()
    end
end)