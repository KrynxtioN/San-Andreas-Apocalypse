addEventHandler("onClientRender", root, function()
    if not (isCharacterLoggedIn() and isWindowOpen()) then return end
	
	if(getElementInterior(localPlayer) == 18)then
		local x1,y1,z1 = -228.58184814453,1397.9376220703,28.359519958496
		local screenX1,screenY1 = getScreenFromWorldPosition(x1,y1,z1)
			
		if screenX1 and screenY1 and getDistanceBetweenPoints3D(x1, y1, z1, getElementPosition(localPlayer)) <= 5 then
			dxDrawText(getText("CDailyWeaponBonus1"),
					screenX1 - 100, screenY1 - 20, screenX1 + 100, screenY1 + 20,
				tocolor(255,255,255), 1.2, "default-bold", "center", "center")
		end
	end
end)