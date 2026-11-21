Itemshop = {Timer = {},
	["Items"] = {3027, 2966,365},
	["Items:Data"] = {
		-- Name, Price, Needed Level
		["EN"] = {
			[3027] = {"Cigarette", 12, 5},
			[2966] = {"Radio", 5000, 15},
			[365] = {"Spray can", 150, 25},
		},
		["DE"] = {
			[3027] = {"Zigarette", 12, 5},
			[2966] = {"Radio", 5000, 15},
			[365] = {"Sprühdose", 150, 25},6
		},

		["RU"] = {
			[3027] = {"Сигарета", 12, 5},
			[2966] = {"Радио", 5000, 15},
			[365] = {"Аэрозольный баллончик", 150, 25},
		},

		["PT"] = {
			[3027] = {"Cigarro", 12, 5},
			[2966] = {"Rádio", 5000, 15},
			[365] = {"Lata de spray", 150, 25},
		},
	},
}

local objectRotating = false

function Itemshop.openMenu()
	if(isWindowOpen())then
		if(not(isElement(Itemshop.object)))then
			NPC.NormalMessage(getText("CItemshop4"))
			showChat(false)
			setWindowData("no")
			HUD.Visible = false
			setElementFrozen(localPlayer, true)
			toggleAllControls(false)
			Itemshop.RenderAlpha = 0
			Itemshop.RenderState = false
			fadeCamera(false)
			Itemshop.selectedItem = 1
			
			Itemshop.Timer["Zoom"] = setTimer(function()
				fadeCamera(true)
				bindKey("backspace", "down", Itemshop.close)
				bindKey("arrow_l", "down", Itemshop.switchLeft)
				bindKey("arrow_r", "down", Itemshop.switchRight)
				bindKey("enter", "down", Itemshop.buy)
				Itemshop.createObject()
						
				addEventHandler("onClientRender", root, Itemshop.RenderMenu)
				setCameraMatrix(658.65570068359,-441.71197509766,17.597417831421,631.32244873047,-358.80453491211,-31.180154800415,0,70)
				smoothMoveCamera(658.65570068359,-441.71197509766,17.597417831421,631.32244873047,-358.80453491211,-31.180154800415, 657.64984130859,-440.68902587891,16.889135360718,594.77667236328,-376.75701904297,-27.378929138184, 5000)
				Itemshop.Timer["Zoom"] = setTimer(function()
					Itemshop.RenderState = true
				end, 5000, 1)
			end, 1000, 1)
		end
	end
end

function Itemshop.RenderMenu()
	local screenWidth, screenHeight = guiGetScreenSize()
	local scale = math.min(screenWidth / 1920, screenHeight / 1080)

    if Itemshop.RenderState == true then
        local item = Itemshop["Items:Data"][apocalypseGetElementData(localPlayer,"language") or "EN"][Itemshop["Items"][Itemshop.selectedItem]]
  
        if Itemshop.RenderAlpha < 255 then 
            Itemshop.RenderAlpha = math.min(Itemshop.RenderAlpha + 5, 255) 
        end

        local rectX, rectY, rectWidth, rectHeight = math.floor(1529 * scale), math.floor(94 * scale), math.floor(381 * scale), math.floor(144 * scale)
        dxDrawRectangle(rectX, rectY, rectWidth, rectHeight, tocolor(0, 0, 0, Itemshop.RenderAlpha), false)

        local text1 = getText("CItemshop1"):format(item[1], item[3], item[2])
        dxDrawText(
            text1, 
            rectX + math.floor(10 * scale),
            rectY + math.floor(10 * scale), 
            rectX + rectWidth - math.floor(10 * scale), 
            rectY + math.floor(54 * scale), 
            tocolor(255, 255, 255, Itemshop.RenderAlpha), 
            1.20 * scale, 
            "default", 
            "left", 
            "center", 
            false, 
            true, 
            false
        )

        local text2 = getText("CItemshop2")
        dxDrawText(
            text2, 
            rectX + math.floor(10 * scale), 
            rectY + math.floor(110 * scale), 
            rectX + rectWidth - math.floor(10 * scale), 
            rectY + math.floor(140 * scale), 
            tocolor(255, 255, 255, Itemshop.RenderAlpha), 
            0.80 * scale, 
            "default", 
            "center", 
            "center", 
            false, 
            true, 
            false
        )

        local playerMoney = apocalypseGetElementData(localPlayer, "money")
        local text3 = getText("CItemshop3"):format(playerMoney)
        dxDrawText(
            text3, 
            rectX + math.floor(10 * scale), 
            rectY + math.floor(85 * scale), 
            rectX + rectWidth - math.floor(10 * scale), 
            rectY + math.floor(110 * scale), 
            tocolor(255, 255, 255, Itemshop.RenderAlpha), 
            1.00 * scale, 
            "default", 
            "center", 
            "center", 
            false, 
            true, 
            false
        )
    end

    local itemshopHeight = math.floor(100 * scale)
    dxDrawRectangle(0, 0, screenWidth, itemshopHeight, tocolor(0, 0, 0, 255))
    dxDrawRectangle(0, screenHeight - itemshopHeight, screenWidth, itemshopHeight, tocolor(0, 0, 0, 255))
	setPlayerHudComponentVisible("radar", false)
end

function Itemshop.createObject()
	if(isElement(Itemshop.object))then destroyElement(Itemshop.object) end
	Itemshop.object = createObject(Itemshop["Items"][Itemshop.selectedItem], 656.62341308594, -440.03179931641, 16.258600234985, 66, 0, 44)
	if(objectRotating == false)then
		objectRotating = true
		addEventHandler("onClientRender", root, Itemshop.rotateObject)
	end
end

function Itemshop.rotateObject()
	local rx, ry, rz = getElementRotation(Itemshop.object)
	setElementRotation(Itemshop.object, rx, ry, rz + 1)
end

function Itemshop.switchLeft()
	if(Itemshop.selectedItem > 1)then
		Itemshop.selectedItem = Itemshop.selectedItem - 1
		Itemshop.createObject()
	end
end

function Itemshop.switchRight()
	if(Itemshop.selectedItem < #Itemshop["Items"])then
		Itemshop.selectedItem = Itemshop.selectedItem + 1
		Itemshop.createObject()
	end
end

function Itemshop.buy()
	if(Itemshop.RenderState == true)then
		local item = Itemshop["Items:Data"][apocalypseGetElementData(localPlayer,"language") or "EN"][Itemshop["Items"][Itemshop.selectedItem]]
		triggerServerEvent("Itemshop.buy", localPlayer, Itemshop["Items"][Itemshop.selectedItem], item[2], item[3])
	end
end

function Itemshop.close()
	setCameraTarget(localPlayer)
	toggleAllControls(true)
	HUD.Visible = true
	showChat(true)
	closeWindow()
		
	unbindKey("backspace", "down", Itemshop.close)
	unbindKey("arrow_l", "down", Itemshop.switchLeft)
	unbindKey("arrow_r", "down", Itemshop.switchRight)
	unbindKey("enter", "down", Itemshop.buy)
		
	removeEventHandler("onClientRender", root, Itemshop.RenderMenu)
	removeEventHandler("onClientRender", root, Itemshop.rotateObject)
	removeCamHandler()
	Itemshop.RenderAlpha = 0
	Itemshop.RenderState = false
	if(isTimer(Itemshop.Timer["Zoom"]))then killTimer(Itemshop.Timer["WeaponZoom"]) end
	if(isElement(Itemshop.object))then destroyElement(Itemshop.object) end
	objectRotating = false
	
	NPC.Close()
	setElementFrozen(localPlayer, false)
	closeWindow()
end
addEvent("Itemshop.close", true)
addEventHandler("Itemshop.close", root, Itemshop.close)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	if(source == localPlayer)then
		Itemshop.close()
	end
end)
