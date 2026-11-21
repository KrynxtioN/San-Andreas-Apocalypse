Tutorial = {
	["Tasks"] = {
		["DE"] = {
			[1] = "Finde Jack, Leeroy und Billy Miller und spreche mit ihnen.",
			[2] = "Finde ein Dokument im Innenraum der Kolonie und klicke es an.",
			[3] = "Finde Großvaters Kopfbedeckung.",
			[4] = "Finde ein gelbes Infobjekt (i) und klicke es an.",
			[5] = "Kaufe eine Waffe bei Jack Miller.",
			[6] = "Sprich mit dem Soldaten am Tor.",
			[7] = "Klicke auf das Keypad, gib die PIN ein und öffne das Tor.",
		},
		["EN"] = {
			[1] = "Find Jack, Leeroy, and Billy Miller and talk to them.",
			[2] = "Find a document within the colony's inner area and click on it.",
			[3] = "Find Grandfather's headgear.",
			[4] = "Find a yellow info object (i) and click on it.",
			[5] = "Buy a weapon from Jack Miller.",
			[6] = "Talk to the soldier at the gate.",
			[7] = "Click on the keypad, enter the PIN, and open the gate.",
		},
		["RU"] = {
			[1] = "Найди Джека, Лиро и Билли Миллера и поговори с ними.",
			[2] = "Найди документ внутри колонии и кликни по нему.",
			[3] = "Найди головной убор дедушки.",
			[4] = "Найди жёлтый информационный объект (i) и кликни по нему.",
			[5] = "Купи оружие у Джека Миллера.",
			[6] = "Поговори с солдатом у ворот.",
			[7] = "Кликни на клавиатуру, введи ПИН и открой ворота.",
		},
		["PT"] = {
			[1] = "Encontre Jack, Leeroy e Billy Miller e fale com eles.",
			[2] = "Encontre um documento na área interna da colônia e clique nele.",
			[3] = "Encontre o chapéu do avô.",
			[4] = "Encontre um objeto de informação amarelo (i) e clique nele.",
			[5] = "Compre uma arma com Jack Miller.",
			[6] = "Fale com o soldado no portão.",
			[7] = "Clique no teclado, digite o PIN e abra o portão.",
		},
	},
	["Helpmarker"] = {
		[1] = {-220.26040649414, 1407.6348876953, 28.169799804688, 18, 0},
		[2] = {-220.59350585938, 1401.5965576172, 27.197199249268, 18, 0},
		[3] = {708.7001953125, -455.662109375, 16.283399581909, 0, 0},
		[4] = {708.7001953125, -459.662109375, 16.283399581909, 0, 0},
		[5] = {683.10028076172, -445.99520874023, 15.580400466919, 0, 0},
		[6] = {708.7001953125, -463.662109375, 16.283399581909, 0, 0},
		[7] = {708.13031005859, -442.25439453125, 15.879899978638, 0, 0},
		[8] = {663.12261962891, -440.78860473633, 16.283399581909, 0, 0},
		[9] = {715.56372070312, -446.5419921875, 15.280400276184, 0, 0},
		[10] = {696.1923828125, -478.513671875, 15.530400276184, 0, 0},
		[11] = {691.875, -447.4296875, 15.796799659729, 0, 0},
		[12] = {693.314453125, -453.9169921875, 15.530400276184, 0, 0},
		[13] = {-218.10319519043, 1405.0661621094, 27.028200149536, 18, 0},
		[14] = {680.7138671875, -472.9951171875, 15.784999847412, 0, 0, false},
		[15] = {694.134765625, -439.1064453125, 15.57320022583, 0, 0, false},
		[16] = {659.123046875, -440.7890625, 16.283399581909, 0, 0, false},
		[17] = {655.123046875, -440.7890625, 16.283399581909, 0, 0, false},
		[18] = {-224.3369140625, 1402.708984375, 27.104600906372, 18, 0, false},
		[19] = {656.92492675781, -468.61029052734, 16.080400466919, 0, 0, false},
		[20] = {-223.30827331543,1403.8946533203,27.7734375, 18, 0},
		[21] = {689.47601318359,-446.91900634766,16.343999862671, 0, 0},
		[22] = {693.0029296875,-453.3515625,16.335899353027, 0, 0},
	},
}

local Gate = nil
local screenW, screenH = guiGetScreenSize()

local displayedText = ""
local textSpeed = 75
local nextLetterTime = 0

local function drawBars()
	local screenWidth, screenHeight = guiGetScreenSize()
	local barHeight = 100
	dxDrawRectangle(0, 0, screenWidth, barHeight, tocolor(0, 0, 0, 255))
	dxDrawRectangle(0, screenHeight - barHeight, screenWidth, barHeight, tocolor(0, 0, 0, 255))

	local currentTime = getTickCount()

	if(currentTime > nextLetterTime and #displayedText < #Tutorial.endText)then
		displayedText = string.sub(Tutorial.endText, 1, #displayedText + 1)
		nextLetterTime = currentTime + textSpeed
	end

	local x = screenWidth / 2
	local y = screenHeight / 2

	dxDrawText(displayedText, x + 1, y + 1, x + 1, y + 1, tocolor(0, 0, 0, 255), 2.0, "default-bold", "center", "center", false, false, true)
	dxDrawText(displayedText, x, y, x, y, tocolor(255, 255, 255, 255), 2.0, "default-bold", "center", "center", false, false, true)
end

function Tutorial.openGate()
	setCameraMatrix(700.951171875, -444.18472290039, 25.098249435425, 699.89581298828, -542.74658203125, 8.2327728271484, 0, 70)
	moveObject(Gate, 7500, 701.158203125, -480.0712890625, 10.099700927734)
	smoothMoveCamera(700.951171875, -444.18472290039, 25.098249435425, 699.89581298828, -542.74658203125, 8.2327728271484, 700.94818115234, -468.82699584961, 20.881816864014, 701.14837646484, -567.39428710938, 4.0163407325745, 15000)
	triggerServerEvent("setAchievement", localPlayer, localPlayer, 11)
	Tutorial.endText = getText("CTutorial2")
	addEventHandler("onClientRender", root, drawBars)
	apocalypseSetElementData(localPlayer, "OpenWindow", true)
	setPlayerHudComponentVisible("radar", false)
	apocalypseSetElementData(localPlayer, "TutorialEndCamera", true)
	apocalypseSetElementData(localPlayer, "OpenWindow", true)
	HUD.DontShow = true

	setTimer(function(Gate)
		if(isElement(Gate))then destroyElement(Gate) end
		removeCamHandler()
		setCameraTarget(localPlayer)
		apocalypseSetElementData(localPlayer, "OpenWindow", false)
		removeEventHandler("onClientRender", root, drawBars)
		apocalypseSetElementData(localPlayer, "TutorialEndCamera", false)
		apocalypseSetElementData(localPlayer, "OpenWindow", false)
		HUD.DontShow = false
	end, 15000, 1, Gate)
end
addEvent("Tutorial.openGate", true)
addEventHandler("Tutorial.openGate", root, Tutorial.openGate)

local currentTask = nil
local alpha = 0
local fadeIn = true
local taskTimer

local marker = {}

addEvent("Tutorial.load", true)
addEventHandler("Tutorial.load", root, function()
	currentTask = Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"][apocalypseGetElementData(localPlayer, "tutorialtask")]
	Gate = createObject(980, 701.158203125, -480.0712890625, 18.099700927734, 0, 0, 180)
	addEventHandler("onClientRender", root, Tutorial.renderTask)
	Tutorial.loadInformationAfterLogin()

	for i, v in ipairs(Tutorial["Helpmarker"]) do
		if v[6] ~= false then
			marker[i] = createMarker(v[1], v[2], v[3], "corona", 0.4, 255,215,0, 0)
			setElementInterior(marker[i], v[4])
			setElementDimension(marker[i], v[5])
		end
	end

	Tutorial.updateHelpMarker()
end)

function Tutorial.renderTask()
	if(isWindowOpen())then
		if(currentTask)then
			local title = "Tutorial "..apocalypseGetElementData(localPlayer, "tutorialtask").."/7"

			local y = 0.8
			local titleScale = 2.5
			local taskScale = 2.0
			local smallTextScale = 1.5
			local font = "default-bold"

			local r, g, b = 255, 255, 255
			local shadowR, shadowG, shadowB = 0, 0, 0

			local imgW = screenW * 0.08

			local imgRatio = 512/512
			local imgH = imgW / imgRatio

			local imgY = (y * screenH) - imgH - 20
			local centerX = screenW / 2

			local task = apocalypseGetElementData(localPlayer, "tutorialtask")

			if task == 1 then
				dxDrawImage(centerX - imgW*1.8, imgY, imgW, imgH, "Files/Images/Characters/100.png")
				dxDrawImage(centerX - imgW*0.5, imgY, imgW, imgH, "Files/Images/Characters/181.png")
				dxDrawImage(centerX + imgW*0.8, imgY, imgW, imgH, "Files/Images/Characters/248.png")
			end
			
			if task == 2 then
				dxDrawImage(centerX - imgW*0.5, imgY, imgW, imgH, "Files/Images/Tutorial/Tutorial_1.png")
			end
			
			if task == 3 then
				dxDrawImage(centerX - imgW*0.5, imgY, imgW, imgH, "Files/Images/Tutorial/Tutorial_2.png")
			end
			
			if task == 4 then
				dxDrawImage(centerX - imgW*1.8, imgY, imgW, imgH, "Files/Images/Tutorial/Tutorial_3.png")
				dxDrawImage(centerX - imgW*0.5, imgY, imgW, imgH, "Files/Images/Tutorial/Tutorial_4.png")
				dxDrawImage(centerX + imgW*0.8, imgY, imgW, imgH, "Files/Images/Tutorial/Tutorial_6.png")
			end
			
			if task == 5 then
				dxDrawImage(centerX - imgW*0.5, imgY, imgW, imgH, "Files/Images/Tutorial/Tutorial_5.png")
			end
			
			if task == 6 then
				dxDrawImage(centerX - imgW*0.5, imgY, imgW, imgH, "Files/Images/Tutorial/Tutorial_7.png")
			end
			
			if task == 7 then
				dxDrawImage(centerX - imgW*0.5, imgY, imgW, imgH, "Files/Images/Tutorial/Tutorial_8.png")
			end
			

			dxDrawText(title, 1, y * screenH + 1, screenW + 1, screenH + 1, tocolor(shadowR, shadowG, shadowB, 255), titleScale, font, "center", "top", false, false, true)
			dxDrawText(title, 0, y * screenH, screenW, screenH, tocolor(r, g, b, 255), titleScale, font, "center", "top", false, false, true)

			local taskY = y + 0.08
			dxDrawText(currentTask, 1, taskY * screenH + 1, screenW + 1, screenH + 1, tocolor(shadowR, shadowG, shadowB, alpha), taskScale, font, "center", "top", false, false, true)
			dxDrawText(currentTask, 0, taskY * screenH, screenW, screenH, tocolor(r, g, b, alpha), taskScale, font, "center", "top", false, false, true)

			local smallTextY = taskY + 0.05
			if(apocalypseGetElementData(localPlayer, "tutorialtask") == 2 or apocalypseGetElementData(localPlayer, "tutorialtask") == 4 or apocalypseGetElementData(localPlayer, "tutorialtask") == 7)then
				dxDrawText(getText("CTutorial1"), 1, smallTextY * screenH + 1, screenW + 1, screenH + 1, tocolor(shadowR, shadowG, shadowB, 175), smallTextScale, font, "center", "top", false, false, true)
				dxDrawText(getText("CTutorial1"), 0, smallTextY * screenH, screenW, screenH, tocolor(r, g, b, 175), smallTextScale, font, "center", "top", false, false, true)
			elseif(apocalypseGetElementData(localPlayer, "tutorialtask") == 1 or apocalypseGetElementData(localPlayer, "tutorialtask") == 6)then
				dxDrawText(getText("CTutorial3"), 1, smallTextY * screenH + 1, screenW + 1, screenH + 1, tocolor(shadowR, shadowG, shadowB, 175), smallTextScale, font, "center", "top", false, false, true)
				dxDrawText(getText("CTutorial3"), 0, smallTextY * screenH, screenW, screenH, tocolor(r, g, b, 175), smallTextScale, font, "center", "top", false, false, true)
			elseif(apocalypseGetElementData(localPlayer, "tutorialtask") == 5)then
				dxDrawText(getText("CTutorial4"), 1, smallTextY * screenH + 1, screenW + 1, screenH + 1, tocolor(shadowR, shadowG, shadowB, 175), smallTextScale, font, "center", "top", false, false, true)
				dxDrawText(getText("CTutorial4"), 0, smallTextY * screenH, screenW, screenH, tocolor(r, g, b, 175), smallTextScale, font, "center", "top", false, false, true)
			end
			local x1,y1,z1 = -220.22805786133,1407.0545654297,27.765625
			local x2,y2,z2 = -220.59350585938,1401.5965576172,28.597199249268
			local screenX1,screenY1 = getScreenFromWorldPosition(x1,y1,z1)
			local screenX2,screenY2 = getScreenFromWorldPosition(x2,y2,z2)
			if(apocalypseGetElementData(localPlayer, "tutorialtask") == 2)then
				if(screenX1 and screenY1)then
					if(getDistanceBetweenPoints3D(x1,y1,z1,getElementPosition(localPlayer)) <= 5)then
						dxDrawText(getText("CTutorial7"), screenX1 - 100, screenY1 - 20, screenX1 + 100, screenY1 + 20, tocolor(255, 255, 255), 1.2, "default-bold", "center", "center")
					end
				end
			end
			if(apocalypseGetElementData(localPlayer, "tutorialtask") == 3)then
				if(screenX2 and screenY2)then
					if(getDistanceBetweenPoints3D(x1,y1,z1,getElementPosition(localPlayer)) <= 5)then
						dxDrawText(getText("CTutorial8"), screenX2 - 100, screenY2 - 20, screenX2 + 100, screenY2 + 20, tocolor(255, 255, 255), 1.2, "default-bold", "center", "center")
					end
				end
			end

			if(fadeIn)then
				alpha = alpha + 5
				if alpha >= 255 then
					fadeIn = false
				end
			else
				alpha = alpha - 5
				if alpha <= 0 then
					fadeIn = true
					if(isTimer(taskTimer))then
						killTimer(taskTimer)
						taskTimer = nil
					end
				end
			end
		end
	end
end

local Jack, Leeroy, Billy = false, false, false

addEvent("Tutorial.jack",true)
addEventHandler("Tutorial.jack",root,function()
	Jack = true
	setElementAlpha(marker[21],0)
end)

addEvent("Tutorial.leeroy",true)
addEventHandler("Tutorial.leeroy",root,function()
	Leeroy = true
	setElementAlpha(marker[22],0)
end)

addEvent("Tutorial.billy",true)
addEventHandler("Tutorial.billy",root,function()
	Billy = true
	setElementAlpha(marker[20],100)
end)

function updateTask(newTask)
	currentTask = Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"][apocalypseGetElementData(localPlayer, "tutorialtask")]
	alpha = 0
	fadeIn = true
	if(isTimer(taskTimer))then
		killTimer(taskTimer)
	end
	taskTimer = setTimer(function()
		fadeIn = false
	end, 5000, 1)
end
addEvent("updateTask", true)
addEventHandler("updateTask", root, updateTask)

local enteredCode = ""
local keypadVisible = false
local screenW, screenH = guiGetScreenSize()
local buttonSize = 80
local keypadWidth = buttonSize * 3
local keypadHeight = buttonSize * 5
local keypadX, keypadY = (screenW - keypadWidth) / 2, (screenH - keypadHeight) / 2

local closeBtnW, closeBtnH = 24, 24
local closeBtnX, closeBtnY = keypadX + keypadWidth - closeBtnW - 4, keypadY - closeBtnH - 6

local function isPointInRect(x, y, rx, ry, rw, rh)
	return x >= rx and x <= rx + rw and y >= ry and y <= ry + rh
end

local function closeKeypad()
	removeEventHandler("onClientClick", root, tutorialHandleClick)
	removeEventHandler("onClientRender", root, Tutorial.keyPad)
	showCursor(false)
	enteredCode = ""
	apocalypseSetElementData(localPlayer, "OpenWindow", false)
	keypadVisible = false
end

function Tutorial.keyPad()
	dxDrawRectangle(keypadX, keypadY, keypadWidth, keypadHeight, tocolor(0, 0, 0, 150))
	apocalypseSetElementData(localPlayer, "OpenWindow", true)

	dxDrawRectangle(closeBtnX, closeBtnY, closeBtnW, closeBtnH, tocolor(200, 0, 0, 200),true)
	dxDrawText("X", closeBtnX, closeBtnY, closeBtnX + closeBtnW, closeBtnY + closeBtnH, tocolor(255,255,255,255), 1.2, "default-bold", "center", "center", _, _, true)

	local infoY = keypadY - 45
	if(apocalypseGetElementData(localPlayer,"keypadCodeTutorial"))then
		dxDrawText(getText("CTutorial9"):format(apocalypseGetElementData(localPlayer,"keypadCodeTutorial")), keypadX, infoY, keypadX + keypadWidth, infoY + 35, tocolor(255, 255, 255, 255), 1.3, "default-bold", "center", "center")
	end

	local numbers = {"1", "2", "3", "4", "5", "6", "7", "8", "9"}
	for i = 1, 9 do
		local col = (i-1) % 3
		local row = math.floor((i-1) / 3)
		local x = keypadX + col * buttonSize
		local y = keypadY + row * buttonSize
		dxDrawRectangle(x, y, buttonSize, buttonSize, tocolor(50, 50, 50, 200))
		dxDrawText(numbers[i], x, y, x + buttonSize, y + buttonSize, tocolor(255, 255, 255), 2, "default-bold", "center", "center")
	end

	dxDrawRectangle(keypadX + buttonSize, keypadY + 3 * buttonSize, buttonSize, buttonSize, tocolor(50, 50, 50, 200))
	dxDrawText("0", keypadX + buttonSize, keypadY + 3 * buttonSize, keypadX + 2 * buttonSize, keypadY + 4 * buttonSize, tocolor(255, 255, 255), 2, "default-bold", "center", "center")

	dxDrawRectangle(keypadX, keypadY + 3 * buttonSize, buttonSize, buttonSize, tocolor(200, 0, 0, 200))
	dxDrawText("C", keypadX, keypadY + 3 * buttonSize, keypadX + buttonSize, keypadY + 4 * buttonSize, tocolor(255, 255, 255), 2, "default-bold", "center", "center")

	dxDrawRectangle(keypadX, keypadY + 4 * buttonSize, keypadWidth, buttonSize, tocolor(100, 100, 100, 200))
	dxDrawText(enteredCode, keypadX, keypadY + 4 * buttonSize, keypadX + keypadWidth, keypadY + 5 * buttonSize, tocolor(255, 255, 255), 2, "default-bold", "center", "center")
end

addEvent("Tutorial.createKeypad", true)
addEventHandler("Tutorial.createKeypad", root, function()
	if(isWindowOpen() and isCharacterLoggedIn() and apocalypseGetElementData(localPlayer, "tutorialtask") == 7 and not keypadVisible)then
		setWindowData("no")
		keypadVisible = true
		showCursor(true)
		addEventHandler("onClientClick", root, tutorialHandleClick)
		addEventHandler("onClientRender", root, Tutorial.keyPad)
	end
end)

function tutorialHandleClick(button, state)
	if(button == "left" and state == "down")then
		local cursorX, cursorY = getCursorPosition()
		cursorX, cursorY = cursorX * screenW, cursorY * screenH

		-- Close Button
		if(isPointInRect(cursorX, cursorY, closeBtnX, closeBtnY, closeBtnW, closeBtnH))then
			closeKeypad()
			return
		end

		for i = 1, 9 do
			local col = (i-1) % 3
			local row = math.floor((i-1) / 3)
			local x = keypadX + col * buttonSize
			local y = keypadY + row * buttonSize
			if(isPointInRect(cursorX, cursorY, x, y, buttonSize, buttonSize))then
				enteredCode = enteredCode .. i
			end
		end

		if(isPointInRect(cursorX, cursorY, keypadX + buttonSize, keypadY + 3 * buttonSize, buttonSize, buttonSize))then
			enteredCode = enteredCode .. "0"
		end

		if(isPointInRect(cursorX, cursorY, keypadX, keypadY + 3 * buttonSize, buttonSize, buttonSize))then
			enteredCode = ""
		end

		if(tonumber(enteredCode) == tonumber(apocalypseGetElementData(localPlayer, "keypadCodeTutorial")))then
			triggerServerEvent("Tutorial.nextTask", localPlayer, localPlayer)
			closeKeypad()
			NPC.Close()
			triggerServerEvent("tutorialStatus",localPlayer)
		end
	end
end

function Tutorial.updateHelpMarker()
	for _, v in pairs(marker)do
		if(isElement(v))then
			setElementAlpha(v, 0)
		end
	end
	if(apocalypseGetElementData(localPlayer, "tutorialtask") == 1)then
		setElementAlpha(marker[20],100)
		setElementAlpha(marker[21],100)
		setElementAlpha(marker[22],100)
	end
	if(apocalypseGetElementData(localPlayer, "tutorialtask") == 2)then
		setElementAlpha(marker[1], 100)
	end
	if(apocalypseGetElementData(localPlayer, "tutorialtask") == 3)then
		setElementAlpha(marker[2], 100)
	end
	if(apocalypseGetElementData(localPlayer, "tutorialtask") == 4)then
		for i = 3,19 do
			if(isElement(marker[i]))then
				setElementAlpha(marker[i],100)
			end
		end
	end
	if(apocalypseGetElementData(localPlayer, "tutorialtask") == 5)then
		setElementAlpha(marker[21], 100)
	end
end
addEvent("Tutorial.updateHelpMarker", true)
addEventHandler("Tutorial.updateHelpMarker", root, Tutorial.updateHelpMarker)

addEvent("Tutorial.destroy", true)
addEventHandler("Tutorial.destroy", root, function()
	removeEventHandler("onClientRender", root, Tutorial.renderTask)
	for _, v in pairs(marker)do
		destroyElement(v)
	end
end)

local drawAfterLoginClose = false
local drawAfterLoginSeconds = 10
local drawAfterLoginTimer = nil

function Tutorial.drawInformationAfterLogin()
	local screenW, screenH = guiGetScreenSize()
	local backgroundColor = tocolor(0, 0, 0, 150)
	dxDrawRectangle(0, 0, screenW, screenH, backgroundColor)
	local text = getText("CTutorial5"):format(drawAfterLoginSeconds)
	if(drawAfterLoginSeconds == 0)then
		text = getText("CTutorial6")
	end

	local textX = screenW / 2 - 300
	local textY = screenH / 2 - 100
	dxDrawText(text, textX, textY, textX + 600, textY + 200, tocolor(255, 255, 255, 255), 1.25, "default", "center", "center", true, true)
end

function Tutorial.loadInformationAfterLogin()
	drawAfterLoginTimer = setTimer(function()
		drawAfterLoginSeconds = drawAfterLoginSeconds - 1
		if(drawAfterLoginSeconds == 0)then
			killTimer(drawAfterLoginTimer)
			drawAfterLoginClose = true
		end
	end,1000,0)

	addEventHandler("onClientRender", root, Tutorial.drawInformationAfterLogin)
	apocalypseSetElementData(localPlayer,"WindowOpen",true)
	toggleAllControls(false)

	bindKey("space","down",Tutorial.closeInformationAfterLogin)
end

function Tutorial.closeInformationAfterLogin()
	if(drawAfterLoginClose == true)then
		removeEventHandler("onClientRender",root,Tutorial.drawInformationAfterLogin)
		apocalypseSetElementData(localPlayer,"WindowOpen",false)
		toggleAllControls(true)
		unbindKey("space","down",Tutorial.closeInformationAfterLogin)
	end
end