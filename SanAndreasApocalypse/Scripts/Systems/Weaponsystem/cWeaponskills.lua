local screenWidth, screenHeight = guiGetScreenSize()
local windowWidth, windowHeight = 600, 400
local windowX, windowY = (screenWidth - windowWidth) / 2, (screenHeight - windowHeight) / 2
local showWeaponWindow = false

local selectedWeaponIndex = 1
local animationProgress = 0
local animating = false

local weapons = {
    {id = 24, name = "CWeaponskills4"},
    {id = 25, name = "CWeaponskills5"},
    {id = 31, name = "CWeaponskills6"},
    {id = 29, name = "CWeaponskills7"},
}

function openWeaponskillsWindow()
    if(isWindowOpen())then
        showWeaponWindow = true
        animating = true
        animationProgress = 0
        setWindowData()
        showCursor(true)
        addEventHandler("onClientRender", root, renderWeaponskillsWindow)
        addEventHandler("onClientClick", root, onClientWeaponskillsClick)
    end
end

function closeWeaponskillsWindow()
    showWeaponWindow = false
    removeEventHandler("onClientRender", root, renderWeaponskillsWindow)
    removeEventHandler("onClientClick", root, onClientWeaponskillsClick)
    showCursor(false)
    closeWindow()
end

function renderWeaponskillsWindow()
    if(animating)then
        animationProgress = math.min(animationProgress + 0.05, 1)
        if(animationProgress == 1)then animating = false end
    end

    local currentWidth = windowWidth * animationProgress
    local currentHeight = windowHeight * animationProgress
    local currentX = windowX + (windowWidth - currentWidth) / 2
    local currentY = windowY + (windowHeight - currentHeight) / 2

    dxDrawRectangle(currentX, currentY, currentWidth, currentHeight, tocolor(0,0,0, 200))
    dxDrawRectangle(currentX, currentY, currentWidth, 50, tocolor(200,25,25, 175))
    dxDrawText(getText("CWeaponskills1"), currentX, currentY, currentX + currentWidth, currentY + 50, tocolor(255, 255, 255, 255), 1.5, "default-bold", "center", "center")

    if(animationProgress == 1)then
        for i, weapon in ipairs(weapons) do
            local listY = currentY + 60 + (i - 1) * 50
            local isSelected = (i == selectedWeaponIndex)
            local bgColor = isSelected and tocolor(200,25,25, 255) or tocolor(30, 30, 30, 255)
            local textColor = isSelected and tocolor(255, 255, 255, 255) or tocolor(180, 180, 180, 255)

            dxDrawRectangle(currentX + 20, listY, currentWidth - 40, 40, bgColor)
            dxDrawText(getText(weapon.name), currentX + 20, listY, currentX + currentWidth - 20, listY + 40, textColor, 1.2, "default-bold", "center", "center")
        end

        local infoText = getText("CWeaponskills_Info_" .. weapons[selectedWeaponIndex].id)
        dxDrawText(infoText, currentX + 20, currentY + 60 + #weapons * 50 + 10, currentX + currentWidth - 20, currentY + currentHeight - 80, tocolor(220, 220, 220, 255), 1.0, "default-bold", "center", "top", true, false, false)

        local buttonWidth, buttonHeight = 120, 40
        local buttonX = currentX + currentWidth / 2 - buttonWidth / 2
        local buttonY = currentY + currentHeight - 60
        dxDrawRectangle(buttonX, buttonY, buttonWidth, buttonHeight, tocolor(75, 200, 75, 220))
        dxDrawText(getText("CWeaponskills2"), buttonX, buttonY, buttonX + buttonWidth, buttonY + buttonHeight, tocolor(0, 0, 0, 255), 1.2, "default-bold", "center", "center")

        dxDrawText(getText("CWeaponskills3"), currentX + 20, buttonY - 30, currentX + currentWidth - 20, buttonY - 5, tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "center")

        local closeSize = 24
        local closeX = currentX + currentWidth - closeSize - 12
        local closeY = currentY + 12
        dxDrawRectangle(closeX, closeY, closeSize, closeSize, tocolor(200, 60, 60, 220))
        dxDrawText("×", closeX, closeY - 1, closeX + closeSize, closeY + closeSize, tocolor(0, 0, 0, 255), 1.3, "default-bold", "center", "center")
    end
end

function onClientWeaponskillsClick(button, state, mx, my)
    if not showWeaponWindow or animationProgress < 1 or button ~= "left" or state ~= "down" then return end

    local currentX, currentY = windowX, windowY
    local currentWidth, currentHeight = windowWidth, windowHeight

    for i, weapon in ipairs(weapons) do
        local listY = currentY + 60 + (i - 1) * 50
        if mx >= currentX + 20 and mx <= currentX + currentWidth - 20 and my >= listY and my <= listY + 40 then
            selectedWeaponIndex = i
            return
        end
    end

    local buttonWidth, buttonHeight = 120, 40
    local buttonX = currentX + currentWidth / 2 - buttonWidth / 2
    local buttonY = currentY + currentHeight - 60
    if(mx >= buttonX and mx <= buttonX + buttonWidth and my >= buttonY and my <= buttonY + buttonHeight)then
        closeWeaponskillsWindow()
        triggerServerEvent("shootingRange.start", localPlayer, localPlayer, weapons[selectedWeaponIndex].id)
        return
    end

    local closeSize = 24
    local closeX = currentX + currentWidth - closeSize - 12
    local closeY = currentY + 12
    if(mx >= closeX and mx <= closeX + closeSize and my >= closeY and my <= closeY + closeSize)then
        closeWeaponskillsWindow()
        return
    end
end

addEventHandler("onClientPlayerWasted",root,function()
	if(source == localPlayer)then
		closeWeaponskillsWindow()
	end
end)