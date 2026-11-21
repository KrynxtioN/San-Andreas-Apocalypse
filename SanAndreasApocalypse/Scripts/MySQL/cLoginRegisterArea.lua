fadeCamera(false)
apocalypseSetElementData(localPlayer, "Account:Status", "LoggedOut")
apocalypseSetElementData(localPlayer, "Character:Status", "LoggedOut")
setElementInterior(localPlayer, 0) setElementDimension(localPlayer, 0)
apocalypseSetElementData(localPlayer, "OpenWindow", false)

triggerServerEvent("LoginRegistrationArea.setLanguage", localPlayer)

local x,  y = guiGetScreenSize()
local ImageWidth,  ImageHeight = 800,  200
local ImageX,  ImageY = (x - ImageWidth) / 2,  (y - ImageHeight) / 2

local BarHeight,  BarY = y / 2,  x / 2

local ImageAlpha = 0
local Image,  ImageVisible = nil,  true
local BarsStopPosition = 100

local StartTime = getTickCount()
local FadeInTime,  FadeOutTime = 3500,  3500
local DelayBeforeBars,  BarsDuration = 1000,  5000

LoginRegistrationArea = {CameraMovementTime = 15000, 
	["CameraPositions"] = {
		{661.68115234375, -451.33245849609, 24.764688491821, 732.47534179688, -490.52191162109, -33.992168426514, 0, 70}, 
		{659.46270751953, -479.07574462891, 24.764688491821, 754.30383300781, -460.33990478516, -0.81135529279709, 0, 70}, 
		{687.10528564453, -478.9856262207, 22.682273864746, 757.92639160156, -412.27331542969, -0.42277237772942, 0, 70}, 
		{698.92236328125, -465.72747802734, 20.151573181152, 627.13555908203, -401.47702026367, -6.6538443565369, 0, 70}, 
		{701.75732421875, -442.17901611328, 21.473743438721, 613.94720458984, -474.50286865234, -13.804421424866, 0, 70}, 
		{708.74230957031, -465.24749755859, 24.952304840088, 779.72418212891, -508.46463012695, -30.670104980469, 0, 70}, 
		{728.13500976562, -475.35589599609, 22.13987159729, 686.32604980469, -392.68508911133, -15.51048374176, 0, 70}, 
		{703.32843017578, -440.12902832031, 24.554996490479, 610.23333740234, -406.04058837891, 11.46772480011, 0, 70}, 
		{681.56164550781, -432.810546875, 21.518749237061, 583.89593505859, -415.77737426758, 8.4314775466919, 0, 70}, 
		{669.91888427734, -437.16006469727, 23.033224105835, 618.10632324219, -522.42370605469, 29.783758163452, 0, 70}, 
	}, 
}

local function removeEverything()
	showChat(false)
	setPlayerHudComponentVisible("all", false)
	if(apocalypseGetElementData(localPlayer, "Character:Status") == "LoggedIn")then
		removeEventHandler("onClientRender", root, removeEverything)
		setPlayerHudComponentVisible("all", true)
		showChat(true)
	end
end
addEventHandler("onClientRender", root, removeEverything)

function LoginRegistrationArea.Load()
	fadeCamera(true)
	if(HalloweenEvent == true)then
		Image = guiCreateStaticImage(ImageX,  ImageY,  ImageWidth,  ImageHeight,  "Files/Images/SAApocalypse_Halloween.png",  false)
	else
		Image = guiCreateStaticImage(ImageX,  ImageY,  ImageWidth,  ImageHeight,  "Files/Images/SAApocalypse.png",  false)
	end
	guiSetAlpha(Image,  0)
	
	LoginRegistrationArea.CameraMovement()
	addEventHandler("onClientRender", root, LoginRegistrationArea.Animations)
	addEventHandler("onClientRender", root, LoginRegistrationArea.Background)
end
addEvent("LoginRegistrationArea.Load", true)
addEventHandler("LoginRegistrationArea.Load", root, LoginRegistrationArea.Load)

function LoginRegistrationArea.Background() dxDrawRectangle(0,  0,  x,  y,  tocolor(0,  0,  0,  125)) end

function drawBlackBars()
    local screenWidth,  screenHeight = guiGetScreenSize()
	local barHeight = 100
    dxDrawRectangle(0,  0,  screenWidth,  barHeight,  tocolor(0,  0,  0,  255),true)
    dxDrawRectangle(0,  screenHeight - barHeight,  screenWidth,  barHeight,  tocolor(0,  0,  0,  255),true)
end

addEvent("LoginRegistrationArea.LoadIntroSkipped", true)
addEventHandler("LoginRegistrationArea.LoadIntroSkipped", root, function()
	fadeCamera(true)
	addEventHandler("onClientRender", root, LoginRegistrationArea.Background)
	LoginRegistrationArea.CameraMovement()
	addEventHandler("onClientRender", root, drawBlackBars)
end)

function LoginRegistrationArea.Animations()
	local CurrentTime = getTickCount()
	local ElapsedTime = CurrentTime - StartTime

	if(ElapsedTime < FadeInTime)then
		ImageAlpha = (ElapsedTime / FadeInTime)
	elseif(ElapsedTime < FadeInTime + DelayBeforeBars)then
		ImageAlpha = 1
	elseif(ElapsedTime < FadeInTime + DelayBeforeBars + FadeOutTime)then
		ImageAlpha = 1 - ((ElapsedTime - FadeInTime - DelayBeforeBars) / FadeOutTime)
	else
		ImageAlpha = 0
	end
	if(isElement(Image))then guiSetAlpha(Image,  ImageAlpha)end
	
	local BarAnimationStart = FadeInTime + DelayBeforeBars + FadeOutTime
    if(ElapsedTime > BarAnimationStart)then
        local BarElapsedTime = ElapsedTime - BarAnimationStart
        if(BarElapsedTime < BarsDuration)then
            if(BarY > BarsStopPosition)then
                local Progress = BarElapsedTime / BarsDuration
                BarY = y / 2 - ((y / 2 - BarsStopPosition) * Progress)
            end
        end
    end
	
	dxDrawRectangle(0,  0,  x,  BarY,  tocolor(0,  0,  0,  255))
	dxDrawRectangle(0,  y - BarY,  x,  BarY,  tocolor(0,  0,  0,  255))
	
	if(ElapsedTime >= FadeInTime + DelayBeforeBars + BarsDuration + FadeOutTime and ImageVisible == true)then
		if(isElement(Image))then destroyElement(Image)end
		ImageVisible = false

		addEventHandler("onClientRender", root, LoginRegistrationArea.DrawText)
		LoginRegistrationArea.LoadText()
	end
end

function LoginRegistrationArea.CameraMovement()
	LoginRegistrationArea.CameraPositionsID = 1
	setCameraMatrix(LoginRegistrationArea["CameraPositions"][1][1], LoginRegistrationArea["CameraPositions"][1][2], LoginRegistrationArea["CameraPositions"][1][3], LoginRegistrationArea["CameraPositions"][1][4], LoginRegistrationArea["CameraPositions"][1][5], LoginRegistrationArea["CameraPositions"][1][6], 0, 70)
	LoginRegistrationArea.CameraMovementMoveCamera()
end
addEvent("LoginRegistrationArea.CameraMovement", true)
addEventHandler("LoginRegistrationArea.CameraMovement", root, LoginRegistrationArea.CameraMovement)

function LoginRegistrationArea.CameraMovementMoveCamera()
	if(LoginRegistrationArea["CameraPositions"][LoginRegistrationArea.CameraPositionsID])then
		 smoothMoveCamera(
            LoginRegistrationArea["CameraPositions"][LoginRegistrationArea.CameraPositionsID][1],  
            LoginRegistrationArea["CameraPositions"][LoginRegistrationArea.CameraPositionsID][2],  
            LoginRegistrationArea["CameraPositions"][LoginRegistrationArea.CameraPositionsID][3],  
            LoginRegistrationArea["CameraPositions"][LoginRegistrationArea.CameraPositionsID][4],  
            LoginRegistrationArea["CameraPositions"][LoginRegistrationArea.CameraPositionsID][5],  
            LoginRegistrationArea["CameraPositions"][LoginRegistrationArea.CameraPositionsID][6],  
            LoginRegistrationArea["CameraPositions"][LoginRegistrationArea.CameraPositionsID+1][1],  
            LoginRegistrationArea["CameraPositions"][LoginRegistrationArea.CameraPositionsID+1][2],  
            LoginRegistrationArea["CameraPositions"][LoginRegistrationArea.CameraPositionsID+1][3],  
            LoginRegistrationArea["CameraPositions"][LoginRegistrationArea.CameraPositionsID+1][4],  
            LoginRegistrationArea["CameraPositions"][LoginRegistrationArea.CameraPositionsID+1][5],  
            LoginRegistrationArea["CameraPositions"][LoginRegistrationArea.CameraPositionsID+1][6],  
            LoginRegistrationArea.CameraMovementTime
        )
		
		LoginRegistrationArea.CameraMovementTimer1 = setTimer(function()
			if(localPlayer)then
				LoginRegistrationArea.CameraPositionsID = LoginRegistrationArea.CameraPositionsID + 1
				if(LoginRegistrationArea.CameraPositionsID >= #LoginRegistrationArea["CameraPositions"])then
					smoothMoveCamera(669.91888427734,  -437.16006469727, 23.033224105835,  618.10632324219,  -522.42370605469,  29.783758163452,  661.68115234375,  -451.33245849609,  24.764688491821,  732.47534179688,  -490.52191162109,  -33.992168426514,  1500)
					LoginRegistrationArea.CameraPositionsID = 1
					LoginRegistrationArea.CameraMovementTimer2 = setTimer(function()
						LoginRegistrationArea.CameraMovementMoveCamera()
					end,  LoginRegistrationArea.CameraMovementTime,  1)
				else
					LoginRegistrationArea.CameraMovementMoveCamera()
				end
			end
		end,  LoginRegistrationArea.CameraMovementTime,  1)
	end
end

function LoginRegistrationArea.StopCameraMovement()
	removeCamHandler()
	if(isTimer(LoginRegistrationArea.CameraMovementTimer1))then killTimer(LoginRegistrationArea.CameraMovementTimer1)end
	if(isTimer(LoginRegistrationArea.CameraMovementTimer2))then killTimer(LoginRegistrationArea.CameraMovementTimer2)end
end

local Texts = {getText("CLoginRegistrationArea1")}
local CurrentTextIndex,  DisplayText,  FullText = 1,  "",  ""
local TextSpeed,  IsTextComplete = 50,  false
local TextTimer = nil

function LoginRegistrationArea.DrawText()
	local Font,  Scale = "default-bold",  2
	local SmallFont,  SmallScale = "default-bold",  1
	local TextWidth,  TextHeight = dxGetTextWidth(DisplayText,  Scale,  Font),  dxGetFontHeight(Scale,  Font)
	local TextX,  TextY = (x - TextWidth) / 2,  (y - TextHeight) / 2
	
	dxDrawText(DisplayText,  TextX,  TextY,  TextX + TextWidth,  TextY + TextHeight,  tocolor(255, 255, 255),  Scale,  Font,  "center",  "center")
	if(IsTextComplete == true)then
		local SmallText = getText("CLoginRegistrationArea2")
		local SmallTextWidth,  SmallTextHeight = dxGetTextWidth(SmallText,  SmallScale,  SmallFont),  dxGetFontHeight(SmallScale,  SmallFont)
		local SmallTextX,  SmallTextY = (x - SmallTextWidth) / 2,  TextY + TextHeight + 10
		dxDrawText(SmallText,  SmallTextX,  SmallTextY,  SmallTextX + SmallTextWidth,  SmallTextY + SmallTextHeight,  tocolor(255,  255,  255),  SmallScale,  SmallFont,  "center",  "center")
	end
end

function LoginRegistrationArea.NextText()
	if(CurrentTextIndex > #Texts)then
		unbindKey("enter", "down", PressKey)
		removeEventHandler("onClientRender", root, LoginRegistrationArea.DrawText)
		triggerServerEvent("MySQL.CheckAutologin", localPlayer)
		return
	end
	
	DisplayText = ""
	IsTextComplete = false
	FullText = Texts[CurrentTextIndex]
	local CharIndex = 1
	
	local function AddChar()
		if(CharIndex <= #FullText)then
			DisplayText = DisplayText .. FullText:sub(CharIndex,  CharIndex)
			CharIndex = CharIndex + 1
		else
			IsTextComplete = true
			if(TextTimer)then
				killTimer(TextTimer)
				TextTimer = nil
			end
		end
	end
	
	if(TextTimer)then killTimer(TextTimer)  end
	TextTimer = setTimer(AddChar,  TextSpeed,  0)
end

local function PressKey()
	if(IsTextComplete == true)then
		CurrentTextIndex = CurrentTextIndex + 1
		LoginRegistrationArea.NextText()
	end
end

function LoginRegistrationArea.LoadText()
	CurrentTextIndex = 1
	LoginRegistrationArea.NextText()
	bindKey("enter", "down", PressKey)
end

function LoginRegistrationArea.Destroy()
	removeCamHandler()
	removeEventHandler("onClientRender", root, drawBlackBars)
	removeEventHandler("onClientRender", root, LoginRegistrationArea.Animations)
	if(isElement(Image))then destroyElement(Image)end
	unbindKey("enter", "down", PressKey)
	removeEventHandler("onClientRender", root, LoginRegistrationArea.DrawText)
	removeEventHandler("onClientRender", root, LoginRegistrationArea.Background)
	if(isTimer(LoginRegistrationArea.CameraMovementTimer1))then killTimer(LoginRegistrationArea.CameraMovementTimer1)end
	if(isTimer(LoginRegistrationArea.CameraMovementTimer2))then killTimer(LoginRegistrationArea.CameraMovementTimer2)end
end
addEvent("LoginRegistrationArea.Destroy", true)
addEventHandler("LoginRegistrationArea.Destroy", root, LoginRegistrationArea.Destroy)

triggerServerEvent("LoginRegistrationArea.Load", localPlayer)