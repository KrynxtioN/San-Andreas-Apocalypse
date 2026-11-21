HalloweenEvent = false
ValentineEvent = false
EasterEvent = false
ChristmasEvent = false

addEventHandler("onClientRender",root,function() setPlayerHudComponentVisible("vehicle_name",false) end)

apocalypseSetElementData(localPlayer, "Character:Status",nil)

local screenWidth, screenHeight = guiGetScreenSize()
local x,y = guiGetScreenSize()
local TextTimerFade  = nil
local fadecameratext = nil
apocalypseSetElementData(localPlayer,"Lobby",nil)

local showText = false

local function drawText()
    if(showText)then
		local text = fadecameratext
        local font = "default-bold"
        local scale = 1
        local textWidth = dxGetTextWidth(text, scale, font)
        local textHeight = dxGetFontHeight(scale, font)

        local x = (screenWidth - textWidth) / 2
        local y = (screenHeight - textHeight) / 2

        dxDrawText(text, x, y, x + textWidth, y + textHeight, tocolor(255, 255, 255, 255), scale, font, "center", "center")
    end
end

local function toggleTextVisibility()
    showText = not showText
end

function formatTimeLeft(seconds)
	if seconds < 0 then seconds = 0 end
	local minutes = math.floor(seconds / 60)
	local secs = seconds % 60
	return string.format("%02d:%02d", minutes, secs)
end

function fadeCameraWithInformation(text)
	fadeCamera(false)
	TextTimerFade = setTimer(toggleTextVisibility, 1000, 0)
	fadecameratext = text

	addEventHandler("onClientRender", root, drawText)

	setTimer(function()
		if(localPlayer)then
			fadeCamera(true)
			if(isTimer(TextTimerFade))then killTimer(TextTimerFade)end
			removeEventHandler("onClientRender", root, drawText)
		end
	end,5000,1)
end
addEvent("fadeCameraWithInformation",true)
addEventHandler("fadeCameraWithInformation",root,fadeCameraWithInformation)

local OnlyNumbersTable = {"a","b","c","d","e","f","g","h","i","j","k","l","m","o","p","y","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","O","P","Q","R","S","T","U","V","W","X","Y","Z","ä","ü","ö","Ä","Ü","Ö"," ",",","#","'","+","*","~",":",";","=","}","?","\\","{","&","/","§","\"","!","°","@","|","`","´","-","+"}

function isOnlyNumbers(text)
	local counter = 0
	for k,v in ipairs(OnlyNumbersTable)do
		if(string.find(text,v))then
			counter = counter + 1
			break
		end
	end
	if(counter > 0)then
		return false
	else
		return true
	end
end

bindKey("m","down",function()
	if(isCharacterLoggedIn())then
		if(isWindowOpen())then
			showCursor(not isCursorShowing())
		end
	end
end)

addEvent("Collision.false",true)
addEventHandler("Collision.false",root,function()
	for _,v in pairs(getElementsByType("player"))do
		setElementCollidableWith(localPlayer,v,false)
	end
	for _,v in pairs(getElementsByType("vehicle"))do
		setElementCollidableWith(localPlayer,v,false)
	end
end)

addEvent("Collision.true",true)
addEventHandler("Collision.true",root,function()
	for _,v in pairs(getElementsByType("player"))do
		setElementCollidableWith(localPlayer,v,true)
	end
	for _,v in pairs(getElementsByType("vehicle"))do
		setElementCollidableWith(localPlayer,v,true)
	end
end)