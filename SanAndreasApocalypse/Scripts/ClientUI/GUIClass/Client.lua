GUIEditor = {window = {}, label = {}, edit = {}, button = {}, staticimage = {}, gridlist = {}, scrollbar = {}, scrollpane = {}, tabpanel = {}, tab = {}, progressbar = {}, memo = {}, checkbox = {}}
apocalypseSetElementData(localPlayer, "WindowOpen", false)

local x,y = guiGetScreenSize()
local ScreenSource = dxCreateScreenSource(x,y)
BlurShader = dxCreateShader("Files/Shader/Blur.fx")

local screenWidth, screenHeight = guiGetScreenSize()
local barHeight = 120
local barYTop = -barHeight
local barYBottom = screenHeight
local targetYTop = 0
local targetYBottom = screenHeight - barHeight
local speed = 5
local isActive = false

function isWindowOpen()
	if(isCharacterLoggedIn() and apocalypseGetElementData(localPlayer,"WindowOpen") == true or DialogSystem.active == true or isElement(GUIEditor.window[1]) or isPedDead(localPlayer) or apocalypseGetElementData(localPlayer, "TutorialEndCamera") == true and not(isTimer(CloseWindowTimer)))then
		return false
	else
		return true
	end
end

function drawMovingBlackBars()
    dxDrawRectangle(0, barYTop, screenWidth, barHeight, tocolor(0, 0, 0, 255), true)
    dxDrawRectangle(0, barYBottom, screenWidth, barHeight, tocolor(0, 0, 0, 255), true)
end

function updateBars()
    if(isActive == true)then
        barYTop = math.min(barYTop + speed, targetYTop)
        barYBottom = math.max(barYBottom - speed, targetYBottom)
    else
        barYTop = math.max(barYTop - speed, -barHeight)
        barYBottom = math.min(barYBottom + speed, screenHeight)
    end
    if(barYTop == -barHeight and barYBottom == screenHeight)then
        removeEventHandler("onClientRender", root, drawMovingBlackBars)
        removeEventHandler("onClientRender", root, updateBars)
    end
end

function toggleMovingBlackBars()
	isActive = true
    addEventHandler("onClientRender", root, drawMovingBlackBars)
    addEventHandler("onClientRender", root, updateBars)
end

function renderBlur()
    if (BlurShader) then
        dxUpdateScreenSource(ScreenSource)
        dxSetShaderValue(BlurShader, "ScreenSource", ScreenSource)
        dxSetShaderValue(BlurShader, "BlurStrength", 7)
        dxSetShaderValue(BlurShader, "UVSize", x, y)
        dxDrawImage(0, 0, x, y, BlurShader, 0, 0, 0, tocolor(255,255,255,255), false)
    end
end

function guiCreateNewWindow(x, y, w, h, text, relative)
	local window = guiCreateStaticImage(x, y, w, h, "Files/Images/Window1.png", relative)
	local bar = guiCreateStaticImage(0, -40, w, 300, "Files/Images/Window2.png", relative, window)
	guiSetEnabled(bar, false)
	local label = guiCreateLabel(0, 0, w, 20, text, relative, window)
	
	guiSetFont(label, "default-bold-small")
	guiLabelSetHorizontalAlign(label, "center", true)
	guiLabelSetVerticalAlign(label, "center")

	return window
end

function guiCreateNewButton(x,y,w,h,text,relative,parent)
	local button = guiCreateStaticImage(x, y, w, h, "Files/Images/Button_Normal.png", relative, parent)
	local label = guiCreateLabel(x, y, w, h, text, relative, parent)
	
	guiSetFont(label, "default-bold-small")
	guiLabelSetHorizontalAlign(label, "center", true)
	guiLabelSetVerticalAlign(label, "center")
	
	addEventHandler("onClientMouseEnter", label,function()
		guiStaticImageLoadImage(button, "Files/Images/Button_Hover.png")
	end,false)
	
	addEventHandler("onClientMouseLeave", label,function()
		guiStaticImageLoadImage(button, "Files/Images/Button_Normal.png")
	end,false)
	
	return label
end

guiCreateWindow = guiCreateNewWindow
guiCreateButton = guiCreateNewButton

function guiCreateCloseButton()
	if(isElement(GUIEditor.window[1]))then
		GUIEditor.button["close"] = guiCreateStaticImage(3,3,15,15,"Files/Images/Cross.png",false,GUIEditor.window[1])
		
		addEventHandler("onClientGUIClick",GUIEditor.button["close"],function()
			closeWindow()
			if(apocalypseGetElementData(localPlayer,"InTuninggarage") == true)then
				triggerServerEvent("Tuningsystem.spawnGarage",localPlayer)
			end
		end,false)
	end
end

function setWindowData(status)
	if(isElement(GUIEditor.window[1]))then
		if(not(apocalypseGetElementData(localPlayer,"InTuninggarage") == true))then
			centerWindow(GUIEditor.window[1])
		end
		showCursor(true)
	end
	if(not(status))then
		toggleMovingBlackBars()
		setWindowBlur()
		HUD.Visible = false
		setPlayerHudComponentVisible("radar",false)
	end
	showChat(false)
	apocalypseSetElementData(localPlayer, "WindowOpen", true)
end

function setWindowBlur()
	addEventHandler("onClientPreRender",root,renderBlur)
end

function closeWindow(status)
	showChat(true)
	CloseWindowTimer = setTimer(function() 
		apocalypseSetElementData(localPlayer, "WindowOpen", false)
	end,100,1)
	if(isElement(GUIEditor.window[1]))then
		destroyElement(GUIEditor.window[1])
	end
	showCursor(false)
	apocalypseSetElementData(localPlayer, "generatorWindowOpen", false)
	removeEventHandler("onClientPreRender",root,renderBlur)
	triggerServerEvent("checkCompass",localPlayer)
	isActive = false
	HUD.Visible = true
	SellFish.WindowOpen = false
end
addEvent("closeWindow",true)
addEventHandler("closeWindow",root,closeWindow)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	if(source == localPlayer)then
		closeWindow()
	end
end)