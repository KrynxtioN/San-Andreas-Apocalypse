SafeShop = {}

local screenW, screenH = guiGetScreenSize()
local safeAngle, unlockProgress, shakeIntensity, glowAlpha, glowDirection, progressAlpha = 0, 0, 0, 0, 1, 0
local isUnlocking, isUnlocked, isMenuOpen = false, false, false
local unlockSpeed, selectedSafe, hasKeys = 1, 1, 5

local safes = {
	["EN"] = {
		{name = "Safe", keysRequired = 1},
		{name = "Safe XL", keysRequired = 3},
		{name = "Safe XXL", keysRequired = 5},
	},
	["DE"] = {
		{name = "Tresor", keysRequired = 1},
		{name = "Tresor XL", keysRequired = 3},
		{name = "Tresor XXL", keysRequired = 5},
	},
	["RU"] = {
		{name = "Сейф", keysRequired = 1},
		{name = "Сейф XL", keysRequired = 3},
		{name = "Сейф XXL", keysRequired = 5},
	},
	["PT"] = {
		{name = "Cofre", keysRequired = 1},
		{name = "Cofre XL", keysRequired = 3},
		{name = "Cofre XXL", keysRequired = 5},
	},
	["prices"] = {
		[1] = {
			{72, 50},
			{75, 50},
		},
		[2] = {
			{73, 50},
			{76, 50},
		},
		[3] = {
			{74, 50},
			{77, 50},
		},
	},
}

local function getRandomItem(safe)
    local items = safes["prices"][safe]
    if not items then return nil end

    local totalWeight = 0
    for _, item in ipairs(items) do
        totalWeight = totalWeight + item[2]
    end

    local rand = math.random(1, totalWeight)
    local cumulativeWeight = 0

    for _, item in ipairs(items) do
        cumulativeWeight = cumulativeWeight + item[2]
        if rand <= cumulativeWeight then
            return item[1]
        end
    end
end

function SafeShop.createWindow()
	if(isWindowOpen())then
		setCameraMatrix(200.0080871582,-235.40519714355,2.1735279560089,163.80041503906,-142.74716186523,12.346697807312,0,70)
		smoothMoveCamera(200.0080871582,-235.40519714355,2.1735279560089,163.80041503906,-142.74716186523,12.346697807312,198.43031311035,-233.87643432617,2.8021302223206,157.39051818848,-142.828125,7.8953256607056,3500)
		addEventHandler("onClientRender",root,SafeShop.Render)
		setElementFrozen(localPlayer,true)
		setWindowData("no")
		showCursor(true)
		NPC.NormalMessage(getText("CSafeKey4"))
		bindKey("backspace","down",SafeShop.Close)
		openSafeDial()
	end
end

function SafeShop.Render()
    local screenWidth, screenHeight = guiGetScreenSize()
	local barHeight = 100
    dxDrawRectangle(0, 0, screenWidth, barHeight, tocolor(0, 0, 0, 255))
    dxDrawRectangle(0, screenHeight - barHeight, screenWidth, barHeight, tocolor(0, 0, 0, 255))
	setPlayerHudComponentVisible("radar",false)
	HUD.Visible = false
end

function SafeShop.Close()
	removeCamHandler()
	setCameraTarget(localPlayer)
	removeEventHandler("onClientRender",root,SafeShop.Render)
	setElementFrozen(localPlayer,false)
	closeWindow()
	HUD.Visible = true
	unbindKey("backspace","down",SafeShop.Close)
	closeSafeDial()
end
addEvent("SafeShop.Close",true)
addEventHandler("SafeShop.Close",root,SafeShop.Close)

local function drawTextCentered(text, x, y, width, height, color, scale)
    dxDrawText(text, x, y, x + width, y + height, color, scale, "default-bold", "center")
end

local function drawSafeUI()
    if(isMenuOpen)then
        dxDrawRectangle(screenW/2 - 170, screenH/2 - 170, 340, 340, tocolor(20, 20, 20, 230))
        drawTextCentered(getText("CSafeKey1"), screenW/2 - 160, screenH/2 - 150, 320, 30, tocolor(255, 200, 0, 255), 1.2)
		dxDrawText(getText("CSafeKey5"), screenW/2 - 170, screenH/2 + 180, screenW/2 + 170, screenH/2 + 200, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "top")

        
        for i, safe in ipairs(safes[apocalypseGetElementData(localPlayer,"language") or "EN"]) do
            local color = (i == selectedSafe) and tocolor(0, 255, 0, 255) or tocolor(180, 180, 180, 200)
            drawTextCentered(getText("CSafeKey2"):format(safe.name,safe.keysRequired), screenW/2 - 150, screenH/2 - 80 + (i - 1) * 50, 300, 20, color, (i == selectedSafe) and 1.3 or 1.0)
        end
        hasKeys = getPlayerKeys(13)
        drawTextCentered(getText("CSafeKey3"):format(hasKeys), screenW/2 - 150, screenH/2 + 90, 300, 20, tocolor(255, 255, 255, 255), 1)
    elseif(isUnlocking or isUnlocked)then
        local shakeOffset = math.sin(getTickCount() * 0.1) * shakeIntensity
        dxDrawRectangle(screenW/2 - 160, screenH/2 - 160, 320, 320, tocolor(30, 30, 30, 220))
        
        if(isUnlocked)then
            dxDrawImage(screenW/2 - 110, screenH/2 - 110, 220, 220, "Files/Images/Inventory/"..SafeShop.WinItem..".png")
        else
            glowAlpha = glowAlpha + (glowDirection * 5)
            if glowAlpha > 200 then glowDirection = -1 elseif glowAlpha < 0 then glowDirection = 1 end
            dxDrawImage(screenW/2 - 120, screenH/2 - 120, 240, 240, "Files/Images/SafeDial.png", 0, 0, 0, tocolor(255, 0, 0, glowAlpha))
            dxDrawImage(screenW/2 - 110 + shakeOffset, screenH/2 - 110 + shakeOffset, 220, 220, "Files/Images/SafeDial.png", safeAngle)
        end
        
        progressAlpha = math.min(255, progressAlpha + 5)
        dxDrawRectangle(screenW/2 - 110, screenH/2 + 130, 220, 25, tocolor(50, 50, 50, 200))
        dxDrawRectangle(screenW/2 - 110, screenH/2 + 130, 220 * (unlockProgress / 100), 25, tocolor(0, 255, 0, progressAlpha))
    end
end

local function progressUnlock()
    if(unlockProgress < 100)then
        unlockProgress = unlockProgress + unlockSpeed
        safeAngle = safeAngle + math.random(15, 25)
        shakeIntensity = (unlockProgress > 50 and unlockProgress < 90) and math.random(1, 3) or (unlockProgress >= 90) and math.random(3, 6) or 0
    else
		SafeShop.WinItem = getRandomItem(selectedSafe)
		triggerServerEvent("SafeShop.giveWin",localPlayer,SafeShop.WinItem)
	
        isUnlocking, isUnlocked = false, true
		
        killTimer(sourceTimer)
        setTimer(function() isUnlocked, isMenuOpen = false, true end, 3000, 1)
    end
end

local function startUnlocking()
    if(not(isUnlocking) and not(isUnlocked))then
        isUnlocking, unlockProgress, safeAngle = true, 0, 0
        setTimer(progressUnlock, 100, 0)
    end
end

local function safe_down()
	selectedSafe = math.min(selectedSafe + 1, #safes["EN"])
end

local function safe_up()
	selectedSafe = math.max(selectedSafe - 1, 1)
end

local function safe_buy()
	if(isMenuOpen)then
        triggerServerEvent("SafeShop.buy",localPlayer,safes["EN"][selectedSafe].keysRequired)
    end
end

addEvent("SafeShop.startUnlocking",true)
addEventHandler("SafeShop.startUnlocking",root,function()
	isMenuOpen = false
    startUnlocking()
end)

function openSafeDial()
	addEventHandler("onClientRender",root,drawSafeUI)
	isMenuOpen = true
	bindKey("arrow_d","down",safe_down)
	bindKey("arrow_u","down",safe_up)
	bindKey("enter","down",safe_buy)
end

function closeSafeDial()
	removeEventHandler("onClientRender",root,drawSafeUI)
	isMenuOpen = true
	unbindKey("arrow_d","down",safe_down)
	unbindKey("arrow_u","down",safe_up)
	unbindKey("enter","down",safe_buy)
end