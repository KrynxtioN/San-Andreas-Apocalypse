Shakes = {}

local screenW, screenH = guiGetScreenSize()

local ShakesOptions = {
    {name = "CShakes1", description = "CShakes2", price = 5, hunger = 10, id = 1},
    {name = "CShakes10", description = "CShakes7", price = 50, hunger = 15, id = 2},
    {name = "CShakes11", description = "CShakes8", price = 75, hunger = 20, id = 3},
    {name = "CShakes12", description = "CShakes9", price = 1000, hunger = 100, id = 4},
}

local windowW = 400
local windowH = 50 + #ShakesOptions * 60 + 70
local windowX, windowY = (screenW - windowW) / 2, (screenH - windowH) / 2

local selectedOption = nil

function handleShakesClick(button, state, cx, cy)
    if (button == "left" or button == "right") and state == "down" then
        for i, option in ipairs(ShakesOptions) do
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
            local chosenShakes = ShakesOptions[selectedOption]
            if button == "left" then
                triggerServerEvent("Shakes.buy", localPlayer, chosenShakes.price, getText("CShakes3"):format(getText(chosenShakes.name)), chosenShakes.hunger, chosenShakes.id)
            elseif button == "right" then
                triggerServerEvent("Shakes.takeAway", localPlayer, chosenShakes.price, getText("CShakes3"):format(getText(chosenShakes.name)),chosenShakes.id)
            end
        end
    end
end

function Shakes.createWindow(id)
    if isWindowOpen() then
		if(tonumber(id) == 1)then
			setCameraMatrix(-2218.7497558594,625.47125244141,56.705421447754,-2305.7875976562,662.11999511719,23.822345733643,0,70)
			smoothMoveCamera(-2218.7497558594,625.47125244141,56.705421447754,-2305.7875976562,662.11999511719,23.822345733643, -2220.9189453125,626.21337890625,56.001312255859,-2310.8745117188,654.96569824219,23.118236541748, 3500)
		elseif(tonumber(id) == 2)then
			setCameraMatrix(210.07954406738,-261.52923583984,4.9888343811035,126.34146881104,-219.77536010742,-30.289329528809,0,70)
			smoothMoveCamera(210.07954406738,-261.52923583984,4.9888343811035,126.34146881104,-219.77536010742,-30.289329528809,205.04566955566,-258.56478881836,2.9000332355499,114.73515319824,-235.88986206055,-33.567184448242, 3500)
		end
        addEventHandler("onClientRender", root, Shakes.Render)
        setElementFrozen(localPlayer, true)
        addEventHandler("onClientClick", root, handleShakesClick)
        setWindowData()
        showCursor(true)
        bindKey("backspace", "down", Shakes.Close)
		triggerServerEvent("Shakes.checkBrainmassShake",localPlayer)
    end
end

function Shakes.Render()
    local screenWidth, screenHeight = guiGetScreenSize()
    local barHeight = 100
    dxDrawRectangle(0, 0, screenWidth, barHeight, tocolor(0, 0, 0, 255))
    dxDrawRectangle(0, screenHeight - barHeight, screenWidth, barHeight, tocolor(0, 0, 0, 255))
    setPlayerHudComponentVisible("radar", false)
    HUD.Visible = false

    dxDrawRectangle(windowX, windowY, windowW, windowH, tocolor(0, 0, 0, 200))
    dxDrawText("Shakes", windowX, windowY + 10, windowX + windowW, windowY + 50, tocolor(255, 200, 0, 255), 1.5, "default-bold", "center", "top")

    for i, option in ipairs(ShakesOptions) do
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
            getText("CShakes5") .. ": " .. getText(ShakesOptions[selectedOption].name),
            windowX + 50, windowY + windowH - 50, windowX + 350, windowY + windowH - 20,
            tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center"
        )
    end

    local labelY = windowY + windowH + 10
    dxDrawText(
        getText("CShakes6"),
        windowX + windowW / 2 - 100, labelY, windowX + windowW / 2 + 100, labelY + 30,
        tocolor(255, 255, 255, 255), 1, "default-bold", "center", "top"
    )
end

function Shakes.Close()
    removeCamHandler()
    setCameraTarget(localPlayer)
    removeEventHandler("onClientRender", root, Shakes.Render)
    setElementFrozen(localPlayer, false)
    removeEventHandler("onClientClick", root, handleShakesClick)
    closeWindow()
    HUD.Visible = true
    unbindKey("backspace", "down", Shakes.Close)
end
addEvent("Shakes.Close", true)
addEventHandler("Shakes.Close", root, Shakes.Close)