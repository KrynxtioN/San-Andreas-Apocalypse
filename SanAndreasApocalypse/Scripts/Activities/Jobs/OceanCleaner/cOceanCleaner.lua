OceanCleaner = {}
local Max_Trash = 5000

local OceanCleanerPickup = createPickup(2721.7790527344,-2322.0744628906,3,3,1239,50)

addEventHandler("onClientRender",root,function()
	if(isCharacterLoggedIn() and isWindowOpen())then
		local x1,y1,z1 = getElementPosition(OceanCleanerPickup)
		local screenX1,screenY1 = getScreenFromWorldPosition(x1,y1,z1)
		
		if(screenX1 and screenY1)then
			if(tonumber(apocalypseGetElementData(localPlayer,"level")))then
				local text
				if(tonumber(apocalypseGetElementData(localPlayer,"level")) < 50)then text = "COceanCleaner3" else text = "COceanCleaner1" end
				if(getDistanceBetweenPoints3D(x1,y1,z1,getElementPosition(localPlayer)) <= 5)then
					dxDrawText(getText(text), screenX1 - 100, screenY1 - 20, screenX1 + 100, screenY1 + 20, tocolor(255, 255, 255), 1.2, "default-bold", "center", "center")
				end
			end
		end
	end
end)

addEvent("OceanCleaner.sync", true)
addEventHandler("OceanCleaner.sync", root, function(cleaned)
	OceanCleaner.clean = tonumber(cleaned) or 0
end)

addEvent("OceanCleaner.start",true)
addEventHandler("OceanCleaner.start",root,function()
	OceanCleaner.marker = createMarker(2671.7863769531,-2320.2060546875,-0.125,"cylinder",5,0,0,255,125)
	OceanCleaner.blip = createBlip(2671.7863769531,-2320.2060546875,-0.125,0,1,255,0,0)
	
	addEventHandler("onClientMarkerHit",OceanCleaner.marker,function(player)
		if(player == localPlayer)then
			triggerServerEvent("OceanCleaner.finish",localPlayer)
		end
	end)
	
	addEventHandler("onClientRender",root,OceanCleaner.dxDraw)
end)

function OceanCleaner.destroy()
	if(isElement(OceanCleaner.marker))then
		destroyElement(OceanCleaner.marker)
	end
	if(isElement(OceanCleaner.blip))then
		destroyElement(OceanCleaner.blip)
	end
	if(isTimer(OceanCleaner.timer))then
		killTimer(OceanCleaner.timer)
	end
	removeEventHandler("onClientRender",root,OceanCleaner.dxDraw)
end
addEvent("OceanCleaner.destroy",true)
addEventHandler("OceanCleaner.destroy",root,OceanCleaner.destroy)

addEvent("OceanCleaner.ocean_max",true)
addEventHandler("OceanCleaner.ocean_max",root,function(ocean_max)
	Max_Trash = ocean_max
end)

function OceanCleaner.dxDraw()
	if(isElement(OceanCleaner.marker) and isWindowOpen())then
		local vehicle = getPedOccupiedVehicle(localPlayer)
			
		if(vehicle)then
			local vx, vy, vz = getElementPosition(vehicle)
			local distanceText = getText("COceanCleaner2"):format(OceanCleaner.clean or 0,Max_Trash)
				
			local screenX, screenY = getScreenFromWorldPosition(vx, vy, vz + 2)
			if(screenX and screenY)then
				dxDrawText(distanceText, screenX - 100, screenY - 50, screenX + 100, screenY + 50, tocolor(255, 255, 255), 1, "default-bold", "center", "center")
			end
		end
	end
end

addEventHandler("onClientPlayerWasted",root,function()
	if(source == localPlayer)then
		OceanCleaner.destroy()
	end
end)