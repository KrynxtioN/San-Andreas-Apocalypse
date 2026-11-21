Armor = {Timer = {}, cameraActive = false,
	["Items"] = {
		["Names"] = {
			["EN"] = {"Bulletproof Vest (A)", "Bulletproof Vest (B)"},
			["DE"] = {"Schusssichere Weste (A)", "Schusssichere Weste (B)"},
			["RU"] = {"Бронированная жилетка (A)", "Бронированная жилетка (B)"},
			["PT"] = {"Colete à Prova de Balas (A)", "Colete à Prova de Balas (B)"},
		},
		["Data"] = {
			 -- Price, Needed Level, Armor
			{75, 5, 15, 653.16394042969, -440.38247680664, 16.721042633057, 578.88189697266, -386.43286132812, -22.922603607178},
			{150, 10, 35, 653.46105957031, -440.59829711914, 16.879615783691, 613.62591552734, -389.52505493164, -59.308856964111},
		},
	},
}

local x, y = guiGetScreenSize()
local savedCamera = {653.16394042969, -440.38247680664, 16.721042633057, 578.88189697266, -386.43286132812, -22.922603607178}

function Armor.openMenu()
	if(isWindowOpen())then
		if(not(isElement(Armor.object)))then
			showChat(false)
			setWindowData("no")
			HUD.Visible = false
			setElementFrozen(localPlayer, true)
			toggleAllControls(false)
			Armor.RenderAlpha = 0
			Armor.RenderState = false
			fadeCamera(false)
			showCursor(true)
			Armor.selectedItem = 1
			
			Armor.Timer["Zoom"] = setTimer(function()
				fadeCamera(true)
				bindKey("backspace", "down", Armor.close)
				bindKey("enter", "down", Armor.buy)
				bindKey("arrow_l", "down", Armor.switchLeft)
				bindKey("arrow_r", "down", Armor.switchRight)
						
				addEventHandler("onClientRender", root, Armor.RenderMenu)
				setCameraMatrix(655.23291015625, -443.14553833008, 17.618572235107, 614.27893066406, -357.45767211914, -13.692101478577, 0, 70)
				smoothMoveCamera(655.23291015625, -443.14553833008, 17.618572235107, 614.27893066406, -357.45767211914, -13.692101478577, 653.16394042969, -440.38247680664, 16.721042633057, 578.88189697266, -386.43286132812, -22.922603607178, 5000)
				Armor.Timer["Zoom"] = setTimer(function()
					Armor.RenderState = true
				end, 5000, 1)
			end, 1000, 1)
		end
	end
end

function Armor.RenderMenu()
	local screenWidth, screenHeight = guiGetScreenSize()
	local scale = math.min(screenWidth / 1920, screenHeight / 1080)

    if Armor.RenderState == true then
        local item = Armor["Items"]["Data"][Armor.selectedItem]
  
        if Armor.RenderAlpha < 255 then 
            Armor.RenderAlpha = math.min(Armor.RenderAlpha + 5, 255) 
        end

        local rectX, rectY, rectWidth, rectHeight = math.floor(1529 * scale), math.floor(94 * scale), math.floor(381 * scale), math.floor(144 * scale)
        dxDrawRectangle(rectX, rectY, rectWidth, rectHeight, tocolor(0, 0, 0, Armor.RenderAlpha), false)

        local text1 = getText("CArmor1"):format(Armor["Items"]["Names"][apocalypseGetElementData(localPlayer, "language") or "EN"][Armor.selectedItem], item[2], item[1], item[3])
        dxDrawText(
            text1, 
            rectX + math.floor(10 * scale),
            rectY + math.floor(10 * scale), 
            rectX + rectWidth - math.floor(10 * scale), 
            rectY + math.floor(54 * scale), 
            tocolor(255, 255, 255, Armor.RenderAlpha), 
            1.20 * scale, 
            "default", 
            "left", 
            "center", 
            false, 
            true, 
            false
        )

        local text2 = getText("CArmor2")
        dxDrawText(
            text2, 
            rectX + math.floor(10 * scale), 
            rectY + math.floor(110 * scale), 
            rectX + rectWidth - math.floor(10 * scale), 
            rectY + math.floor(140 * scale), 
            tocolor(255, 255, 255, Armor.RenderAlpha), 
            0.80 * scale, 
            "default", 
            "center", 
            "center", 
            false, 
            true, 
            false
        )

        local playerMoney = apocalypseGetElementData(localPlayer, "money")
        local text3 = getText("CArmor3"):format(playerMoney)
        dxDrawText(
            text3, 
            rectX + math.floor(10 * scale), 
            rectY + math.floor(85 * scale), 
            rectX + rectWidth - math.floor(10 * scale), 
            rectY + math.floor(110 * scale), 
            tocolor(255, 255, 255, Armor.RenderAlpha), 
            1.00 * scale, 
            "default", 
            "center", 
            "center", 
            false, 
            true, 
            false
        )
		
        local armor = getPedArmor(localPlayer) or 0
        local armorPct = math.max(0, math.min(armor, 100)) / 100

        local barW = rectWidth
        local barH = math.floor(14 * scale)
        local barX = rectX
        local barY = rectY + rectHeight + math.floor(8 * scale)

        dxDrawRectangle(barX, barY, barW, barH, tocolor(0, 0, 0, Armor.RenderAlpha), false)

        dxDrawRectangle(barX + math.floor(2 * scale), barY + math.floor(2 * scale),
            (barW - math.floor(4 * scale)) * armorPct, barH - math.floor(4 * scale),
            tocolor(0, 120, 255, Armor.RenderAlpha), false)

		local armorText = getText("CWeaponshop5"):format(armor)
        dxDrawText(
            armorText,
            barX, barY - math.floor(18 * scale),
            barX + barW, barY + barH,
            tocolor(255, 255, 255, Armor.RenderAlpha),
            0.85 * scale,
            "default",
            "center", "center",
            false, false, false
        )
    end

    local ArmorHeight = math.floor(100 * scale)
    dxDrawRectangle(0, 0, screenWidth, ArmorHeight, tocolor(0, 0, 0, 255))
    dxDrawRectangle(0, screenHeight - ArmorHeight, screenWidth, ArmorHeight, tocolor(0, 0, 0, 255))
	setPlayerHudComponentVisible("radar", false)
end

function Armor.switchLeft()
	if(Armor.selectedItem > 1)then
		if(Armor.cameraActive == false)then
			Armor.selectedItem = Armor.selectedItem - 1
			Armor.cameraActive = true
			Armor.Timer["Switch"] = setTimer(function() Armor.cameraActive = false end, 1000, 1)
			local camera = Armor["Items"]["Data"][Armor.selectedItem]
			smoothMoveCamera(savedCamera[1], savedCamera[2], savedCamera[3], savedCamera[4], savedCamera[5], savedCamera[6], camera[4], camera[5], camera[6], camera[7], camera[8], camera[9], 1000)
			savedCamera = {camera[4], camera[5], camera[6], camera[7], camera[8], camera[9]}
		end
	end
end

function Armor.switchRight()
	if(Armor.selectedItem < #Armor["Items"]["Names"][apocalypseGetElementData(localPlayer, "language") or "EN"])then
		if(Armor.cameraActive == false)then
			Armor.selectedItem = Armor.selectedItem + 1
			Armor.cameraActive = true
			Armor.Timer["Switch"] = setTimer(function() Armor.cameraActive = false end, 1000, 1)
			local camera = Armor["Items"]["Data"][Armor.selectedItem]
			smoothMoveCamera(savedCamera[1], savedCamera[2], savedCamera[3], savedCamera[4], savedCamera[5], savedCamera[6], camera[4], camera[5], camera[6], camera[7], camera[8], camera[9], 1000)
			savedCamera = {camera[4], camera[5], camera[6], camera[7], camera[8], camera[9]}
		end
	end
end

function Armor.buy()
	if(Armor.RenderState == true)then
		local item = Armor["Items"]["Data"][Armor.selectedItem]
		triggerServerEvent("Armor.buy", localPlayer, item[1], item[2], item[3])
	end
end

function Armor.close()
	setCameraTarget(localPlayer)
	toggleAllControls(true)
	HUD.Visible = true
	showChat(true)
	closeWindow()
		
	unbindKey("backspace", "down", Armor.close)
	unbindKey("enter", "down", Armor.buy)
	unbindKey("arrow_l", "down", Armor.switchLeft)
	unbindKey("arrow_r", "down", Armor.switchRight)
		
	removeEventHandler("onClientRender", root, Armor.RenderMenu)
	removeCamHandler()
	Armor.RenderAlpha = 0
	Armor.RenderState = false
	if(isTimer(Armor.Timer["Zoom"]))then killTimer(Armor.Timer["Zoom"]) end
	if(isTimer(Armor.Timer["Switch"]))then killTimer(Armor.Timer["Switch"]) end
	Armor.cameraActive = false
	
	NPC.Close()
	setElementFrozen(localPlayer, false)
	closeWindow()
end
addEvent("Armor.close", true)
addEventHandler("Armor.close", root, Armor.close)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	if(source == localPlayer)then
		Armor.close()
	end
end)