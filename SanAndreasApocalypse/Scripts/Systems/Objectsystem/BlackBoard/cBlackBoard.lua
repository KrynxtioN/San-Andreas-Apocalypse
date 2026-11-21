BlackBoard = {text = "", owner = ""}

local boardVisible = false
local boardTextScroll = 0
local maxScroll = 0
local animationProgress = 0
local animating = false

local windowWidth, windowHeight = 600, 400
local screenW, screenH = guiGetScreenSize()
local windowX, windowY = (screenW - windowWidth) / 2, (screenH - windowHeight) / 2

local closeButton = {x = 0, y = 0, w = 24, h = 24}

function BlackBoard.render()
    if animating then
        animationProgress = math.min(animationProgress + 0.05, 1)
        if animationProgress == 1 then
            animating = false
        end
    end

    local currentWidth = windowWidth * animationProgress
    local currentHeight = windowHeight * animationProgress
    local currentX = windowX + (windowWidth - currentWidth) / 2
    local currentY = windowY + (windowHeight - currentHeight) / 2

    dxDrawRectangle(currentX, currentY, currentWidth, currentHeight, tocolor(0, 0, 0, 200))
    dxDrawRectangle(currentX, currentY, currentWidth, 50, tocolor(220, 25, 25, 175))
    dxDrawText(getText("CBlackBoard1"):format(BlackBoard.owner), currentX, currentY, currentX + currentWidth, currentY + 50, tocolor(255, 255, 255), 1.5, "default-bold", "center", "center")

    if animationProgress == 1 then
        local textYStart = currentY + 60
        local textHeight = currentHeight - 90
        local _, lines = string.gsub(BlackBoard.text, "\n", "")
        maxScroll = math.max(0, lines * 18 - textHeight)

        dxDrawText(BlackBoard.text, currentX + 20, textYStart - boardTextScroll, currentX + currentWidth - 20, currentY + currentHeight - 20, tocolor(240, 240, 240), 1.0, "default-bold", "left", "top", true, true, false, false)

        closeButton.x = currentX + currentWidth - closeButton.w - 12
        closeButton.y = currentY + 12
        dxDrawRectangle(closeButton.x, closeButton.y, closeButton.w, closeButton.h, tocolor(200, 60, 60, 220))
        dxDrawText("×", closeButton.x, closeButton.y - 1, closeButton.x + closeButton.w, closeButton.y + closeButton.h, tocolor(0, 0, 0), 1.3, "default-bold", "center", "center")
    end
end

local function onMouseWheel(_, _, up)
    if not boardVisible then return end
    if up then
        boardTextScroll = math.max(0, boardTextScroll - 30)
    else
        boardTextScroll = math.min(maxScroll, boardTextScroll + 30)
    end
end

local function clickCloseButton(btn, state)
    if not boardVisible or btn ~= "left" or state ~= "down" then return end
    local cx, cy = getCursorPosition()
    if not cx or not cy then return end
    local sx, sy = guiGetScreenSize()
    local mx, my = cx * sx, cy * sy
    if mx >= closeButton.x and mx <= closeButton.x + closeButton.w and my >= closeButton.y and my <= closeButton.y + closeButton.h then
        BlackBoard.toggle()
    end
end

function BlackBoard.toggle()
    boardVisible = not boardVisible

    if boardVisible then
        animationProgress = 0
        animating = true
        addEventHandler("onClientRender", root, BlackBoard.render)
        bindKey("mouse_wheel_up", "down", onMouseWheel)
        bindKey("mouse_wheel_down", "down", onMouseWheel)
        addEventHandler("onClientClick", root, clickCloseButton)
    else
        removeEventHandler("onClientRender", root, BlackBoard.render)
        unbindKey("mouse_wheel_up", "down", onMouseWheel)
        unbindKey("mouse_wheel_down", "down", onMouseWheel)
        removeEventHandler("onClientClick", root, clickCloseButton)
		closeWindow()
		guiSetInputEnabled(false)
    end
end

addEvent("BlackBoard.createText", true)
addEventHandler("BlackBoard.createText", root, function(text,ownerName,isOwner)
	if(isWindowOpen())then
		BlackBoard.text = text
		BlackBoard.owner = ownerName
		boardTextScroll = 0
		BlackBoard.toggle()
		setWindowData()
		if(isOwner and isOwner == true)then
			GUIEditor.window[1] = guiCreateWindow(10, 373, 454, 335, "", false)
			guiSetInputEnabled(true)

			GUIEditor.memo[1] = guiCreateMemo(10, 60, 434, 237, "", false, GUIEditor.window[1])
			GUIEditor.button[1] = guiCreateButton(10, 307, 434, 18, getText("CBlackBoard2"), false, GUIEditor.window[1])
			GUIEditor.label[1] = guiCreateLabel(10, 23, 434, 31, getText("CBlackBoard3"), false, GUIEditor.window[1])
			guiSetFont(GUIEditor.label[1], "default-bold-small")
			guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", false)
			guiLabelSetVerticalAlign(GUIEditor.label[1], "center")  

			addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
				local text = guiGetText(GUIEditor.memo[1])
				triggerServerEvent("BlackBoard.saveText",localPlayer,text)
				BlackBoard.text = text
			end,false)
		end
	end
end)

addEventHandler("onClientPlayerWasted",root,function()
	if(source == localPlayer)then
		if(boardVisible == true)then
			BlackBoard.toggle()
		end
	end
end)