HotDog = {}

local screenW, screenH = guiGetScreenSize()

local hotdogOptions = {
    {name = "CHotDog1", description = "CHotDog2", price = 5, hunger = 10, id = 1},
    {name = "CHotDog10", description = "CHotDog7", price = 50, hunger = 15, id = 2},
    {name = "CHotDog11", description = "CHotDog8", price = 75, hunger = 20, id = 3},
    {name = "CHotDog12", description = "CHotDog9", price = 1000, hunger = 100, id = 4},
}

local windowW = 400
local windowH = 50 + #hotdogOptions * 60 + 70
local windowX, windowY = (screenW - windowW) / 2, (screenH - windowH) / 2

local selectedOption = nil

function handleHotdogClick(button, state, cx, cy)
    if (button == "left" or button == "right") and state == "down" then
        for i, option in ipairs(hotdogOptions) do
            local optionY = windowY + 50 + (i - 1) * 60
            if cx >= windowX + 10 and cx <= windowX + windowW - 10
            and cy >= optionY and cy <= optionY + 50 then
                selectedOption = i
                return
            end
        end

        if selectedOption
        and cx >= windowX + 50 and cx <= windowX + 350
        and cy >= windowY + windowH - 50 and cy <= windowY + windowH - 20 then
            local chosenHotdog = hotdogOptions[selectedOption]
            if button == "left" then
                triggerServerEvent("HotDog.buy", localPlayer, chosenHotdog.price, getText("CHotDog3"):format(getText(chosenHotdog.name)), chosenHotdog.hunger, chosenHotdog.id)
            elseif button == "right" then
                triggerServerEvent("HotDog.takeAway", localPlayer, chosenHotdog.price, getText("CHotDog3"):format(getText(chosenHotdog.name)),chosenHotdog.id)
            end
        end
    end
end

function HotDog.createWindow()
    if isWindowOpen() then
        setCameraMatrix(662.39184570312, -459.84939575195, 18.557825088501, 751.474609375, -493.55465698242, -11.908821105957, 0, 70)
        smoothMoveCamera(662.39184570312, -459.84939575195, 18.557825088501, 751.474609375, -493.55465698242, -11.908821105957, 666.12377929688, -462.45709228516, 17.317514419556, 761.26086425781, -440.75677490234, -4.5463089942932, 3500)
        addEventHandler("onClientRender", root, HotDog.Render)
        setElementFrozen(localPlayer, true)
        addEventHandler("onClientClick", root, handleHotdogClick)
        setWindowData()
        showCursor(true)
        bindKey("backspace", "down", HotDog.Close)
		triggerServerEvent("HotDog.checkBrainmassDog",localPlayer)
    end
end

function HotDog.Render()
    local screenWidth, screenHeight = guiGetScreenSize()
    local barHeight = 100
    dxDrawRectangle(0, 0, screenWidth, barHeight, tocolor(0, 0, 0, 255))
    dxDrawRectangle(0, screenHeight - barHeight, screenWidth, barHeight, tocolor(0, 0, 0, 255))
    setPlayerHudComponentVisible("radar", false)
    HUD.Visible = false

    dxDrawRectangle(windowX, windowY, windowW, windowH, tocolor(0, 0, 0, 200))
    dxDrawText("Hot Dogs", windowX, windowY + 10, windowX + windowW, windowY + 50, tocolor(255, 200, 0, 255), 1.5, "default-bold", "center", "top")

    for i, option in ipairs(hotdogOptions) do
        local optionY = windowY + 50 + (i - 1) * 60

        dxDrawRectangle(windowX + 10, optionY, windowW - 20, 50, tocolor(50, 50, 50, 200))

        dxDrawText(
            getText(option.name) .. " - $" .. option.price,
            windowX + 20, optionY + 5, windowX + windowW - 20, optionY + 25,
            tocolor(255, 255, 255, 255), 1.2, "default-bold", "left", "top"
        )

        dxDrawText(
            getText(option.description),
            windowX + 20, optionY + 25, windowX + windowW - 20, optionY + 45,
            tocolor(200, 200, 200, 255), 0.8, "default", "left", "top",false,true,false,false
        )
    end

    if selectedOption then
        dxDrawRectangle(windowX + 50, windowY + windowH - 50, 300, 30, tocolor(0, 128, 0, 200))
        dxDrawText(
            getText("CHotDog5") .. ": " .. getText(hotdogOptions[selectedOption].name),
            windowX + 50, windowY + windowH - 50, windowX + 350, windowY + windowH - 20,
            tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center"
        )
    end

    local labelY = windowY + windowH + 10
    dxDrawText(
        getText("CHotDog6"),
        windowX + windowW / 2 - 100, labelY, windowX + windowW / 2 + 100, labelY + 30,
        tocolor(255, 255, 255, 255), 1, "default-bold", "center", "top"
    )
end

function HotDog.Close()
    removeCamHandler()
    setCameraTarget(localPlayer)
    removeEventHandler("onClientRender", root, HotDog.Render)
    setElementFrozen(localPlayer, false)
    removeEventHandler("onClientClick", root, handleHotdogClick)
    closeWindow()
    HUD.Visible = true
    unbindKey("backspace", "down", HotDog.Close)
end
addEvent("HotDog.Close", true)
addEventHandler("HotDog.Close", root, HotDog.Close)