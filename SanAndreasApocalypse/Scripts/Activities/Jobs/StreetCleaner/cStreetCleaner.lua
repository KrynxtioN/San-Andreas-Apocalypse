local StreetCleanerPickup = createPickup(2318.4938964844,72.250419616699,26.484375,3,1239,50)
local StreetCleanerData = 0

addEventHandler("onClientRender",root,function()
	if(isCharacterLoggedIn() and isWindowOpen())then
		local x1,y1,z1 = getElementPosition(StreetCleanerPickup)
		local screenX1,screenY1 = getScreenFromWorldPosition(x1,y1,z1)
		
		if(screenX1 and screenY1)then
			if(getDistanceBetweenPoints3D(x1,y1,z1,getElementPosition(localPlayer)) <= 5)then
				dxDrawText(getText("CStreetCleaner1"):format(StreetCleanerData), screenX1 - 100, screenY1 - 20, screenX1 + 100, screenY1 + 20, tocolor(255, 255, 255), 1.2, "default-bold", "center", "center")
			end
		end
	end
end)

addEvent("updateStreetCleanerData",true)
addEventHandler("updateStreetCleanerData",root,function(data)
	StreetCleanerData = tonumber(data)
	if(StreetCleanerData and StreetCleanerData > 1000)then
		StreetCleanerData = 1000
	end
end)