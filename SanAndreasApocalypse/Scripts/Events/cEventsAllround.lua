local isVisible = false
local lastChangeTime = 0
local alpha = 0
local targetAlpha = 0
local fadeSpeed = 5

-- [[ HALLOWEEN ]] --

local pumpkinAmount = 0

function drawHalloweenPumpkinAmountImage()
    local screenW, screenH = guiGetScreenSize()
    local imagePath = "Files/Images/Inventory/12.png"
    local imageWidth, imageHeight = 100, 100

    if(isVisible)then
        targetAlpha = 255
    else
        targetAlpha = 0
    end

    if(alpha < targetAlpha)then
        alpha = math.min(alpha + fadeSpeed, targetAlpha)
    elseif alpha > targetAlpha then
        alpha = math.max(alpha - fadeSpeed, targetAlpha)
    end

    if(alpha > 0)then
        dxDrawImage(screenW - imageWidth - 10, screenH - imageHeight - 10, imageWidth, imageHeight, imagePath, 0, 0, 0, tocolor(255, 255, 255, alpha))

        local textX = screenW - imageWidth - 10 + imageWidth / 2
        local textY = screenH - imageHeight - 10 + imageHeight / 2

        dxDrawText(tostring(pumpkinAmount), textX, textY, textX, textY, tocolor(255, 255, 255, alpha), 1.5, "default-bold", "center", "center")
    end
end

addEvent("onPumpkinAmountChange", true)
addEventHandler("onPumpkinAmountChange", root, function(amount)
    pumpkinAmount = amount
    isVisible = true
    lastChangeTime = getTickCount()

    setTimer(function()
        if(getTickCount() - lastChangeTime >= 5000)then
            isVisible = false
        end
    end, 1000, 5)
end)

if(HalloweenEvent == true)then
	addEventHandler("onClientRender",root,drawHalloweenPumpkinAmountImage)
end

local txd = engineLoadTXD("Files/Models/Events/Pumpkin.txd")
engineImportTXD(txd, 1935)
local dff = engineLoadDFF("Files/Models/Events/Pumpkin.dff", 1935)
engineReplaceModel(dff, 1935)
local col = engineLoadCOL("Files/Models/Events/Pumpkin.col")
engineReplaceCOL(col, 1935)

engineSetModelLODDistance(1935, 300)
	
local txd = engineLoadTXD("Files/Skins/skeleton.txd")
local dff = engineLoadDFF("Files/Skins/skeleton.dff")

if(txd and dff)then
    engineImportTXD(txd, 64)
    engineReplaceModel(dff, 64)
end

-- [[ CHRISTMAS ]] --

local PresentAmount = 0

function drawChristmasPresentImage()
	local screenW, screenH = guiGetScreenSize()
	local imagePath = "Files/Images/Inventory/38.png"
	local imageWidth, imageHeight = 100, 100
	
	if(isVisible)then
		targetAlpha = 255
	else
		targetAlpha = 0
	end
	
    if(alpha < targetAlpha)then
        alpha = math.min(alpha + fadeSpeed, targetAlpha)
    elseif alpha > targetAlpha then
        alpha = math.max(alpha - fadeSpeed, targetAlpha)
    end

    if(alpha > 0)then
        dxDrawImage(screenW - imageWidth - 10, screenH - imageHeight - 10, imageWidth, imageHeight, imagePath, 0, 0, 0, tocolor(255, 255, 255, alpha))

        local textX = screenW - imageWidth - 10 + imageWidth / 2
        local textY = screenH - imageHeight - 10 + imageHeight / 2

        dxDrawText(tostring(PresentAmount), textX, textY, textX, textY, tocolor(255, 255, 255, alpha), 1.5, "default-bold", "center", "center")
    end
end

addEvent("PresentAmountChange",true)
addEventHandler("PresentAmountChange",root,function(amount)
	PresentAmount = amount
	isVisible = true
	lastchangeTime = getTickCount()
	
	setTimer(function()
		if(getTickCount() - lastChangeTime >= 5000)then
			isVisible = false
		end
	end, 1000, 5)
end)

if(ChristmasEvent == true)then
	addEventHandler("onClientRender",root,drawChristmasPresentImage)
end

-- [[ VALENTINE ]] --

local ValentineAmount = 0

function drawValentineItemImage()
	local screenW, screenH = guiGetScreenSize()
	local imagePath = "Files/Images/Inventory/85.png"
	local imageWidth, imageHeight = 100, 100
	
	if(isVisible)then
		targetAlpha = 255
	else
		targetAlpha = 0
	end
	
    if(alpha < targetAlpha)then
        alpha = math.min(alpha + fadeSpeed, targetAlpha)
    elseif alpha > targetAlpha then
        alpha = math.max(alpha - fadeSpeed, targetAlpha)
    end

    if(alpha > 0)then
        dxDrawImage(screenW - imageWidth - 10, screenH - imageHeight - 10, imageWidth, imageHeight, imagePath, 0, 0, 0, tocolor(255, 255, 255, alpha))

        local textX = screenW - imageWidth - 10 + imageWidth / 2
        local textY = screenH - imageHeight - 10 + imageHeight / 2

        dxDrawText(tostring(ValentineAmount), textX, textY, textX, textY, tocolor(255, 255, 255, alpha), 1.5, "default-bold", "center", "center")
    end
end

addEvent("ValentineAmountChange",true)
addEventHandler("ValentineAmountChange",root,function(amount)
	ValentineAmount = amount
	isVisible = true
	lastchangeTime = getTickCount()
	
	setTimer(function()
		if(getTickCount() - lastChangeTime >= 5000)then
			isVisible = false
		end
	end, 1000, 5)
end)

if(ValentineEvent == true)then
	addEventHandler("onClientRender",root,drawValentineItemImage)
end

-- [[ EASTER ]] --

local EasterAmount = 0

function drawEasterItemImage()
	local screenW, screenH = guiGetScreenSize()
	local imagePath = "Files/Images/Inventory/204.png"
	local imageWidth, imageHeight = 100, 100
	
	if(isVisible)then
		targetAlpha = 255
	else
		targetAlpha = 0
	end
	
    if(alpha < targetAlpha)then
        alpha = math.min(alpha + fadeSpeed, targetAlpha)
    elseif alpha > targetAlpha then
        alpha = math.max(alpha - fadeSpeed, targetAlpha)
    end

    if(alpha > 0)then
        dxDrawImage(screenW - imageWidth - 10, screenH - imageHeight - 10, imageWidth, imageHeight, imagePath, 0, 0, 0, tocolor(255, 255, 255, alpha))

        local textX = screenW - imageWidth - 10 + imageWidth / 2
        local textY = screenH - imageHeight - 10 + imageHeight / 2

        dxDrawText(tostring(EasterAmount), textX, textY, textX, textY, tocolor(255, 255, 255, alpha), 1.5, "default-bold", "center", "center")
    end
end

addEvent("EasterAmountChange",true)
addEventHandler("EasterAmountChange",root,function(amount)
	EasterAmount = amount
	isVisible = true
	lastchangeTime = getTickCount()
	
	setTimer(function()
		if(getTickCount() - lastChangeTime >= 5000)then
			isVisible = false
		end
	end, 1000, 5)
end)

if(EasterEvent == true)then
	addEventHandler("onClientRender",root,drawEasterItemImage)
end

local txd = engineLoadTXD("Files/Models/Events/Easter/rabbit.txd")
engineImportTXD(txd, 11)
local dff = engineLoadDFF("Files/Models/Events/Easter/rabbit.dff", 11)
engineReplaceModel(dff, 11)

local txd = engineLoadTXD("Files/Models/Events/Easter/BunnyEars.txd")
engineImportTXD(txd, 1879)
local dff = engineLoadDFF("Files/Models/Events/Easter/BunnyEars.dff", 1879)
engineReplaceModel(dff, 1879)