addEventHandler("onClientRender",root,function()
	if(isCharacterLoggedIn() and isWindowOpen())then
		local x1,y1,z1 = -2072.5810546875,-2425.0812988281,29.877599716187
		local screenX1,screenY1 = getScreenFromWorldPosition(x1,y1,z1)
		
		if(screenX1 and screenY1)then
			if(getDistanceBetweenPoints3D(x1,y1,z1,getElementPosition(localPlayer)) <= 5)then
				dxDrawText(getText("COven1"), screenX1 - 100, screenY1 - 20, screenX1 + 100, screenY1 + 20, tocolor(255, 255, 255), 1.2, "default-bold", "center", "center")
			end
		end
	end
end)

local ovenData = {}
local showOvenUI = false
local uiAlpha = 0
local targetAlpha = 0
local selectedType = "Iron"
local smeltCount = 1
local serverTimeOffset = 0

function getSecTime(offset)
	return math.floor(getRealTime().timestamp + (offset or 0))
end

function drawOvenUI()
	uiAlpha = uiAlpha + (targetAlpha - uiAlpha) * 0.1
	
	local screenW, screenH = guiGetScreenSize()
	local windowW, windowH = 500, 600
	local posX, posY = (screenW - windowW) / 2, (screenH - windowH) / 2

	dxDrawRectangle(posX, posY, windowW, windowH, tocolor(30,30,30,220 * uiAlpha), true)
	dxDrawText(getText("COven2"), posX, posY + 10, posX + windowW, posY + 50, tocolor(255,255,255,255 * uiAlpha), 1.8, "default-bold", "center", "center", false, false, true)

	local startY = posY + 60
	dxDrawText(getText("COven3"), posX + 20, startY, posX + windowW - 20, startY + 25, tocolor(240,240,240,255 * uiAlpha), 1, "default-bold", "left", "center", false, false, true)
	local lineHeight = 35
	if #ovenData == 0 then
		dxDrawText(getText("COven4"), posX + 20, startY + 30, posX + windowW - 20, startY + 30 + lineHeight, tocolor(255,255,255,255 * uiAlpha), 1, "default", "left", "center", false, false, true)
	else
		for i, entry in ipairs(ovenData) do
			local id = entry[1]
			local finishTime = tonumber(entry[2])
			local barsType = entry[3] or "?"
			local amount = entry[4] or 0
			local currentTime = getSecTime(0) + serverTimeOffset
			local remainingTime = finishTime - currentTime
			if remainingTime < 0 then remainingTime = 0 end
			local formattedTime = formatTimeLeft(remainingTime)
			local entryText = getText("COven7"):format(id,barsType,amount,formattedTime)
			local currentY = startY + 30 + (i - 1) * lineHeight
			dxDrawText(entryText, posX + 20, currentY, posX + windowW - 150, currentY + lineHeight, tocolor(255,255,255,255 * uiAlpha), 1, "default", "left", "center", false, false, true)

			local btnW, btnH = 100, 30
			local btnX = posX + windowW - 120
			local btnY = currentY
			local btnText, btnColor
			if remainingTime > 0 then
				btnText = getText("COven5")
				btnColor = tocolor(200,0,0,255 * uiAlpha)
			else
				btnText = getText("COven6")
				btnColor = tocolor(0,200,0,255 * uiAlpha)
			end
			dxDrawRectangle(btnX, btnY, btnW, btnH, btnColor, true)
			dxDrawText(btnText, btnX, btnY, btnX + btnW, btnY + btnH, tocolor(255,255,255,255 * uiAlpha), 1, "default-bold", "center", "center", false, false, true)

			ovenData[i].btnArea = {x = btnX, y = btnY, w = btnW, h = btnH}
		end
	end

	local settingsY = posY + 320
	dxDrawText(getText("COven8"), posX + 20, settingsY, posX + windowW - 20, settingsY + 25, tocolor(240,240,240,255 * uiAlpha), 1, "default-bold", "left", "center", false, false, true)

	local buttonW, buttonH = 40, 40
	local btnY = settingsY + 35
	local minusX = posX + 30
	local countX = minusX + buttonW + 10
	local plusX = countX + 100 + 10

	dxDrawRectangle(minusX, btnY, buttonW, buttonH, tocolor(100,100,100,255 * uiAlpha), true)
	dxDrawText("-", minusX, btnY, minusX + buttonW, btnY + buttonH, tocolor(255,255,255,255 * uiAlpha), 2, "default-bold", "center", "center", false, false, true)

	dxDrawRectangle(countX, btnY, 100, buttonH, tocolor(80,80,80,255 * uiAlpha), true)
	dxDrawText(tostring(smeltCount), countX, btnY, countX + 100, btnY + buttonH, tocolor(255,255,255,255 * uiAlpha), 1.8, "default-bold", "center", "center", false, false, true)

	dxDrawRectangle(plusX, btnY, buttonW, buttonH, tocolor(100,100,100,255 * uiAlpha), true)
	dxDrawText("+", plusX, btnY, plusX + buttonW, btnY + buttonH, tocolor(255,255,255,255 * uiAlpha), 2, "default-bold", "center", "center", false, false, true)

	local typeY = btnY + buttonH + 30
	dxDrawText(getText("COven9"), posX + 30, typeY, posX + windowW - 20, typeY + 25, tocolor(240,240,240,255 * uiAlpha), 1, "default-bold", "left", "center", false, false, true)
	local ironX = posX + 100
	local goldX = posX + 220
	local typeBtnW, typeBtnH = 100, 40
	local ironColor = (selectedType == "Iron" and tocolor(0,200,0,255 * uiAlpha)) or tocolor(100,100,100,255 * uiAlpha)
	local goldColor = (selectedType == "Gold" and tocolor(0,200,0,255 * uiAlpha)) or tocolor(100,100,100,255 * uiAlpha)
	dxDrawRectangle(ironX, typeY, typeBtnW, typeBtnH, ironColor, true)
	dxDrawText(getText("COven10"), ironX, typeY, ironX + typeBtnW, typeY + typeBtnH, tocolor(255,255,255,255 * uiAlpha), 1.2, "default-bold", "center", "center", false, false, true)
	dxDrawRectangle(goldX, typeY, typeBtnW, typeBtnH, goldColor, true)
	dxDrawText(getText("COven11"), goldX, typeY, goldX + typeBtnW, typeY + typeBtnH, tocolor(255,255,255,255 * uiAlpha), 1.2, "default-bold", "center", "center", false, false, true)

	local startBtnW, startBtnH = 150, 50
	local startBtnX = posX + (windowW - startBtnW) / 2
	local startBtnY = typeY + typeBtnH + 40
	dxDrawRectangle(startBtnX, startBtnY, startBtnW, startBtnH, tocolor(50,150,250,255 * uiAlpha), true)
	dxDrawText(getText("COven12"), startBtnX, startBtnY, startBtnX + startBtnW, startBtnY + startBtnH, tocolor(255,255,255,255 * uiAlpha), 1.5, "default-bold", "center", "center", false, false, true)

	dxDrawText(getText("COven13"), posX, posY + windowH - 30, posX + windowW, posY + windowH, tocolor(200,200,200,255 * uiAlpha), 0.9, "default", "center", "center", false, false, true)
end

function toggleOvenUI()
	showCursor(true)
	showOvenUI = true
	targetAlpha = 1
	triggerServerEvent("Oven.open", localPlayer)
	addEventHandler("onClientRender", root, drawOvenUI)
	addEventHandler("onClientClick",root,ovenClick)
	setWindowData()
end

function closeOvenUI()
	showOvenUI = false
	targetAlpha = 0
	setTimer(function()
		if uiAlpha < 0.05 then
			removeEventHandler("onClientRender", root, drawOvenUI)
			removeEventHandler("onClientClick",root,ovenClick)
		end
	end, 100, 1)
	closeWindow()
end

bindKey("e","down",function()
	if(isCharacterLoggedIn())then
		if(isWindowOpen())then
			if(getDistanceBetweenPoints3D(-2072.5810546875,-2425.0812988281,29.877599716187,getElementPosition(localPlayer)) <= 5)then
				if(showOvenUI == false)then
					toggleOvenUI()
				end
			end
		end
	end
end)

bindKey("f","down",function()
	if(showOvenUI == true)then
		closeOvenUI()
	end
end)

addEvent("Oven.updateClientData", true)
addEventHandler("Oven.updateClientData", root, function(data, serverTime)
	ovenData = data
	serverTimeOffset = serverTime - getSecTime(0)
end)

function ovenClick(button, state, cursorX, cursorY)
	if(button == "left" and state == "down")then
		local screenW, screenH = guiGetScreenSize()
		local windowW, windowH = 500, 600
		local posX, posY = (screenW - windowW) / 2, (screenH - windowH) / 2

		for i, entry in ipairs(ovenData) do
			if entry.btnArea then
				local bx, by, bw, bh = entry.btnArea.x, entry.btnArea.y, entry.btnArea.w, entry.btnArea.h
				if cursorX >= bx and cursorX <= bx + bw and cursorY >= by and cursorY <= by + bh then
					local finishTime = tonumber(entry[2])
					local remainingTime = finishTime - getSecTime(0)
					if remainingTime > 0 then
						triggerServerEvent("Oven.cancel", localPlayer, entry[1])
					else
						triggerServerEvent("Oven.finished", localPlayer, entry[1])
					end
					triggerServerEvent("Oven.open", localPlayer)
					return
				end
			end
		end

		local settingsY = posY + 320
		local btnY = settingsY + 35
		local minusX = posX + 30
		local btnW, btnH = 40, 40
		if cursorX >= minusX and cursorX <= minusX + btnW and cursorY >= btnY and cursorY <= btnY + btnH then
			if smeltCount > 1 then
				smeltCount = smeltCount - 1
			end
			return
		end
		
		local countX = minusX + btnW + 10
		local plusX = countX + 100 + 10
		if cursorX >= plusX and cursorX <= plusX + btnW and cursorY >= btnY and cursorY <= btnY + btnH then
			smeltCount = smeltCount + 1
			return
		end
		
		local typeY = btnY + btnH + 30
		local ironX = posX + 100
		local goldX = posX + 220
		local typeBtnW, typeBtnH = 100, 40
		if cursorX >= ironX and cursorX <= ironX + typeBtnW and cursorY >= typeY and cursorY <= typeY + typeBtnH then
			selectedType = "Iron"
			return
		end
		if cursorX >= goldX and cursorX <= goldX + typeBtnW and cursorY >= typeY and cursorY <= typeY + typeBtnH then
			selectedType = "Gold"
			return
		end

		local startBtnW, startBtnH = 150, 50
		local startBtnX = posX + (windowW - startBtnW) / 2
		local startBtnY = typeY + typeBtnH + 40
		if cursorX >= startBtnX and cursorX <= startBtnX + startBtnW and cursorY >= startBtnY and cursorY <= startBtnY + startBtnH then
			triggerServerEvent("Oven.server", localPlayer, selectedType, smeltCount)
			toggleOvenUI(false)
			return
		end
	end
end