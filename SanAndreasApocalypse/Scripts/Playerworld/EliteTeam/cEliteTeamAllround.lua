addEventHandler("onClientRender",root,function()
	if(isCharacterLoggedIn() and isWindowOpen())then
		local x1,y1,z1 = -1756.1450195312,789.64477539062,162.25535583496
		local screenX1,screenY1 = getScreenFromWorldPosition(x1,y1,z1)
		
		if(screenX1 and screenY1)then
			if(tonumber(apocalypseGetElementData(localPlayer,"level")))then
				if(getDistanceBetweenPoints3D(x1,y1,z1,getElementPosition(localPlayer)) <= 5)then
					dxDrawText(getText("cEliteTeamAllround1"), screenX1 - 100, screenY1 - 20, screenX1 + 100, screenY1 + 20, tocolor(255, 255, 255), 1.2, "default-bold", "center", "center")
				end
			end
		end
	end
end)