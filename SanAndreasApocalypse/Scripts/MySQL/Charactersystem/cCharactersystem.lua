Characters = {CharacterData = {},  WarningRendered = false}
local MaxCharacter,  SelectedCharacter = nil,  nil

local screenWidth,  screenHeight = guiGetScreenSize()
local textY = screenHeight + 50
local textSpeed = 2
local textAlpha = 255

function getCharacterName()
	return apocalypseGetElementData(localPlayer, "CharacterName")
end

function isCharacterLoggedIn()
	if(apocalypseGetElementData(localPlayer, "Character:Status") == "LoggedIn")then
		return true
	else
		return false
	end
end

function getCharacterID()
	return apocalypseGetElementData(localPlayer, "CharacterID")
end

local function drawAnimatedText()
    textY = textY - textSpeed
    if(textY < screenHeight - 50)then
        textY = screenHeight - 50
        textSpeed = 0
    end
    dxDrawText(getText("CCharacter1"),  screenWidth / 2, textY,  screenWidth / 2, textY + 30,  tocolor(255,  255,  255,  textAlpha),  1,  "default-bold",  "center", "top",true,true,true,true )
end

addEvent("Characters.Load", true)
addEventHandler("Characters.Load", root, function()
	fadeCameraWithInformation(getText("CCharacter2"))
	setTimer(function()
		if(isElement(localPlayer))then
			removeEventHandler("onClientRender", root, LoginRegistrationArea.Background)
			LoginRegistrationArea.StopCameraMovement()
			setCameraMatrix(693.17626953125, -456.10571289062, 21.527969360352, 605.42987060547, -414.77767944336, -2.8145506381989, 0, 70)
			setElementInterior(localPlayer, 0)
			setElementDimension(localPlayer, 0)
			Characters.CreatePed()
		end
	end, 1000, 1)
end)

function Characters.Infos()
	if(Characters.CharacterData[SelectedCharacter])then
		local text = getText("CCharacter11"):format(Characters.CharacterData[SelectedCharacter][1], formatMinutes(Characters.CharacterData[SelectedCharacter][4]), Characters.CharacterData[SelectedCharacter][5])

		local x,  y = guiGetScreenSize()
        dxDrawText(text,  538*(x/1920),  196*(y/1080),  671*(x/1920),  274*(y/1080),  tocolor(255,  255,  255,  255),  1.00*(x/1920),  "default-bold",  "center",  "center",  false,  false,  false,  false,  false)
	end
end

local function firstCharacterClick()
	local Name = guiGetText(GUIEditor.edit[1])
	if not Name:match("^[A-Za-z0-9_-]+$") then
		createInfobox(getText("SAccounts6"))
		return
	end
	if(Name ~= "")then
		if(#Name >= 3)then
			triggerServerEvent("Characters.Create", localPlayer, Name)
		else createInfobox(getText("CCharacter6"))end
	end
end

addEvent("destroyFirstCharacter", true)
addEventHandler("destroyFirstCharacter", root, function()
	closeWindow()
	fadeCameraWithInformation(getText("CCharacter5"))
	unbindKey("enter", "down", firstCharacterClick)
end)

addEvent("Characters.First", true)
addEventHandler("Characters.First", root, function()
    GUIEditor.window[1] = guiCreateWindow(662,  342,  274,  132,  "",  false)
	setWindowData("no")

    GUIEditor.label[1] = guiCreateLabel(10,  29,  254,  27,  getText("CCharacter3"),  false,  GUIEditor.window[1])
    guiSetFont(GUIEditor.label[1],  "default-bold-small")
    guiLabelSetHorizontalAlign(GUIEditor.label[1],  "center",  false)
    guiLabelSetVerticalAlign(GUIEditor.label[1],  "center")
    GUIEditor.edit[1] = guiCreateEdit(10,  66,  254,  25,  "",  false,  GUIEditor.window[1])
    GUIEditor.button[1] = guiCreateButton(9,  101,  255,  21,  getText("CCharacter4"),  false,  GUIEditor.window[1])    
		
	bindKey("enter", "down", firstCharacterClick)
		
	addEventHandler("onClientGUIClick", GUIEditor.button[1], function()
		firstCharacterClick()
	end, false)
end)

local Couch = createObject(1712, 690.33203125, -453.5595703125, 19.652900695801, 0, 0, 297.99865722656)
local TV = createObject(2595, 688.1083984375, -455.205078125, 21.62260055542, 0, 0, 43.994750976562)

addEvent("Characters.DestroyWindow", true)
addEventHandler("Characters.DestroyWindow", root, function()
	closeWindow()
	if(isElement(Couch))then destroyElement(Couch)end
	if(isElement(TV))then destroyElement(TV)end
	removeEventHandler("onClientRender", root, Characters.Infos)
	unbindKey("enter", "down", firstCharacterClick)
end)

function Characters.CreatePed()
	triggerServerEvent("Characters.LoadCharacters", localPlayer)
	Characters.Ped = createPed(0, 690.33203125, -453.5595703125, 19.652900695801, 115)
	attachElements(Characters.Ped, Couch, 0.6, -0.60, 1.15)
	setPedAnimation(Characters.Ped,  "PED",  "SEAT_idle",  -1,  true,  false,  false,  true)
	
	bindKey("arrow_l", "down", Characters.Left)
	bindKey("arrow_r", "down", Characters.Right)
	bindKey("enter", "down", Characters.LoginKeys)
	setTimer(function()
		if(isElement(localPlayer))then
			addEventHandler("onClientRender", root, drawAnimatedText)
			addEventHandler("onClientRender", root, Characters.Infos)
		end
	end, 4000, 1)
end

function Characters.Left()
	if(SelectedCharacter ~= nil and tonumber(SelectedCharacter) ~= 1)then
		SelectedCharacter = SelectedCharacter - 1
		setElementModel(Characters.Ped, Characters.CharacterData[SelectedCharacter][3])
	end
end

function Characters.Right()
	if(tonumber(SelectedCharacter) < MaxCharacter)then
		SelectedCharacter = SelectedCharacter + 1
		setElementModel(Characters.Ped, Characters.CharacterData[SelectedCharacter][3])
	end
end

addEvent("Characters.refreshList", true)
addEventHandler("Characters.refreshList", root, function(CharactersTable)
	if(CharactersTable and #CharactersTable >= 1)then
		Characters.CharacterData = CharactersTable
		MaxCharacter = #CharactersTable
		SelectedCharacter = 1
		setElementModel(Characters.Ped, CharactersTable[1][3])
	end
end)

function Characters.LoginKeys()
	unbindKey("enter", "down", Characters.LoginKeys)
	unbindKey("arrow_l", "down", Characters.Left)
	unbindKey("arrow_r", "down", Characters.Right)
	fadeCameraWithInformation(getText("CCharacter7"))
	setTimer(function()
		if(isElement(Characters.Ped))then destroyElement(Characters.Ped)end
		if(isElement(Couch))then destroyElement(Couch)end
		if(isElement(TV))then destroyElement(TV)end
		triggerServerEvent("Characters.ServerLogin", localPlayer, Characters.CharacterData[SelectedCharacter][2])
	end, 4000, 1)
	removeEventHandler("onClientRender", root, drawAnimatedText)
	removeEventHandler("onClientRender", root, Characters.Infos)
end
addEvent("Characters.LoginKeys", true)
addEventHandler("Characters.LoginKeys", root, Characters.LoginKeys)

local function onClientClick(button,  state)
    if(button == "left" and state == "down")then
        local screenWidth,  screenHeight = guiGetScreenSize()

        local windowWidth,  windowHeight = 400,  250
        local windowX,  windowY = (screenWidth - windowWidth) / 2,  (screenHeight - windowHeight) / 2
        local buttonWidth,  buttonHeight = 300,  40
        local buttonX,  buttonY = windowX + (windowWidth - buttonWidth) / 2,  windowY + 170

        if(isMouseInPosition(buttonX,  buttonY,  buttonWidth,  buttonHeight))then
			triggerServerEvent("Characters.UpdateSerial", localPlayer)
			showCursor(false)
			Characters.WarningRendered = false
			removeEventHandler("onClientRender", root, Characters.DxWarning)
			setElementFrozen(localPlayer, false)
			removeEventHandler("onClientClick",  root,  onClientClick)
        end
    end
end

addEvent("Characters.Warning", true)
addEventHandler("Characters.Warning", root, function()
	if(Characters.WarningRendered == false)then
		showCursor(true)
		Characters.WarningRendered = true
		addEventHandler("onClientRender", root, Characters.DxWarning)
		setElementFrozen(localPlayer, true)
		addEventHandler("onClientClick",  root,  onClientClick)
	end
end)

function Characters.DxWarning()
    local screenWidth,  screenHeight = guiGetScreenSize()

    local windowWidth,  windowHeight = 400,  250
    local windowX,  windowY = (screenWidth - windowWidth) / 2,  (screenHeight - windowHeight) / 2
    local buttonWidth,  buttonHeight = 300,  40
    local buttonX,  buttonY = windowX + (windowWidth - buttonWidth) / 2,  windowY + 170

    dxDrawRectangle(windowX,  windowY,  windowWidth,  windowHeight,  tocolor(255,  0,  0,  200))
    dxDrawRectangle(windowX,  windowY,  windowWidth,  30,  tocolor(139,  0,  0,  255))
    dxDrawText(getText("CCharacter8"),  windowX,  windowY,  windowX + windowWidth,  windowY + 30,  tocolor(255,  255,  255,  255),  1.5,  "default",  "center",  "center")

    dxDrawText(getText("CCharacter9"),  windowX + 10,  windowY + 50,  windowX + windowWidth - 10,  windowY + windowHeight - 60,  tocolor(255,  255,  255,  255),  1.2,  "default",  "center",  "top",  true,  true)

    dxDrawRectangle(buttonX,  buttonY,  buttonWidth,  buttonHeight,  tocolor(139,  0,  0,  255))
    dxDrawText(getText("CCharacter10"),  buttonX,  buttonY,  buttonX + buttonWidth,  buttonY + buttonHeight,  tocolor(255,  255,  255,  255),  1.5,  "default",  "center",  "center")
end