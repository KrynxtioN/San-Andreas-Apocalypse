WeaponDealer = {Object = {},
	["ObjectIDs"] = {
		[36] = 360,
		[37] = 361,
		[38] = 362,
		[35] = 359,
		[39] = 363,
	},
}

addEventHandler("onClientRender",root,function()
	if(isCharacterLoggedIn())then
		for _,v in pairs(getElementsByType("ped"))do
			if(apocalypseGetElementData(v,"WeaponDealerID"))then
				if(apocalypseGetElementData(v,"WeaponDealerStatus") == true)then
					local x,y,z = getElementPosition(v)
					local WeaponID = apocalypseGetElementData(v,"WeaponDealerWeaponID")
					if(not(isElement(WeaponDealer.Object[v])))then
						WeaponDealer.Object[v] = createObject(WeaponDealer["ObjectIDs"][WeaponID],x,y,z + 1)
					end
					local rx,ry,rz = getElementRotation(WeaponDealer.Object[v])
					setElementRotation(WeaponDealer.Object[v],rx,ry,rz + 1)
				else
					if(isElement(WeaponDealer.Object[v]))then
						destroyElement(WeaponDealer.Object[v])
					end
				end
			end
		end
	end
end)

function WeaponDealer.Render()
	local screenWidth, screenHeight = guiGetScreenSize()
	local windowWidth, windowHeight = 300, 200
	local windowX, windowY = (screenWidth - windowWidth) / 2, (screenHeight - windowHeight) / 2

	dxDrawRectangle(windowX, windowY, windowWidth, windowHeight, tocolor(0, 0, 0, 180))

	local imageWidth, imageHeight = 80, 80
	dxDrawImage(windowX + 10, windowY + 10, imageWidth, imageHeight, "Files/Images/Weapons/"..WeaponDealer.SelectedWeapon..".png")

	dxDrawText(getText("CWeaponDealer5"), windowX + imageWidth + 10, windowY + 10, windowX + windowWidth, windowY + 30, tocolor(255, 255, 255), 1, "default-bold", "left", "top")
	dxDrawText(getText("CWeaponDealer1"):format(WeaponDealer.SelectedAmmo), windowX + imageWidth + 10, windowY + 30, windowX + windowWidth, windowY + 50, tocolor(255, 255, 255), 1, "default", "left", "top")

	dxDrawText(getText("CWeaponDealer2"), windowX + 10, windowY + imageHeight + 10, windowX + windowWidth - 10, windowY + windowHeight - 40, tocolor(255, 255, 255), 1, "default", "left", "top", true, true)

	local moneyPrice = WeaponDealer.Price or 0
	local weaponPartsPrice = WeaponDealer.WeaponPartsPrice or 0

	local priceText = getText("CWeaponDealer3"):format(moneyPrice, weaponPartsPrice)

	local buttonX, buttonY, buttonWidth, buttonHeight = windowX + windowWidth - 120, windowY + windowHeight - 40, 100, 30
	dxDrawRectangle(buttonX, buttonY, buttonWidth, buttonHeight, tocolor(0, 200, 0))
	dxDrawText(priceText, buttonX, buttonY, buttonX + buttonWidth, buttonY + buttonHeight, tocolor(255, 255, 255), 0.85, "default-bold", "center", "center")

	local closeButtonX, closeButtonY = windowX + 10, windowY + windowHeight - 40
	dxDrawRectangle(closeButtonX, closeButtonY, 100, 30, tocolor(200, 0, 0))
	dxDrawText(getText("CWeaponDealer4"), closeButtonX, closeButtonY, closeButtonX + 100, closeButtonY + 30, tocolor(255, 255, 255), 1, "default-bold", "center", "center")
end

function WeaponDealer.Click(button, state, x, y)
	local screenWidth, screenHeight = guiGetScreenSize()
    local windowWidth, windowHeight = 300, 200
    local windowX, windowY = (screenWidth - windowWidth) / 2, (screenHeight - windowHeight) / 2

    local buttonX, buttonY, buttonWidth, buttonHeight = windowX + windowWidth - 120, windowY + windowHeight - 40, 100, 30
    if(isMouseInPosition(buttonX, buttonY, buttonWidth, buttonHeight) and button == "left" and state == "up")then
        triggerServerEvent("WeaponDealer.buy",localPlayer)
    end

    local closeButtonX, closeButtonY = windowX + 10, windowY + windowHeight - 40
    if(isMouseInPosition(closeButtonX, closeButtonY, 100, 30) and button == "left" and state == "up")then
       WeaponDealer.Close()
    end
end

addEvent("WeaponDealer.createWindow",true)
addEventHandler("WeaponDealer.createWindow",root,function(weaponID, ammo, price, weapon_parts)
	if(isWindowOpen())then
		setWindowData("no")
		showCursor(true)
		WeaponDealer.SelectedWeapon = weaponID
		WeaponDealer.SelectedAmmo = ammo
		WeaponDealer.Price = price
		WeaponDealer.WeaponParts = weapon_parts
		addEventHandler("onClientRender",root,WeaponDealer.Render)
		addEventHandler("onClientClick", root,WeaponDealer.Click)
	end
end)

function WeaponDealer.Close()
	closeWindow()
	removeEventHandler("onClientRender",root,WeaponDealer.Render)
	removeEventHandler("onClientClick", root,WeaponDealer.Click)
end
addEvent("WeaponDealer.Close",true)
addEventHandler("WeaponDealer.Close",root,WeaponDealer.Close)

addEventHandler("onPlayerQuit",root,function()
	WeaponDealer.Close()
end)

bindKey("e","down",function()
	if(isCharacterLoggedIn())then
		triggerServerEvent("WeaponDealer.createWindow",localPlayer)
	end
end)

addEventHandler("onClientPedDamage",root,function()
	if(apocalypseGetElementData(source,"WeaponDealerID"))then
		cancelEvent()
	end
end)