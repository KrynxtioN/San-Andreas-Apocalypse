Holzfaeller = {}

local LumberjackPickup = createPickup(-2003.8640136719,-2362.8515625,30.625,3,1239,50)

function Holzfaeller.text()
    if not (isCharacterLoggedIn() and isWindowOpen()) then return end
	if(isElement(Holzfaeller.sawMarker))then
		local x1, y1, z1 = -2027.8552246094,-2335.2182617188,30.625
		local x2, y2, z2 = -2012.6279296875,-2350.1589355469,30.625 -- saw
		local screenX1, screenY1 = getScreenFromWorldPosition(x1, y1, z1)
		local screenX2, screenY2 = getScreenFromWorldPosition(x2, y2, z2)

		if screenX1 and screenY1 and getDistanceBetweenPoints3D(x1, y1, z1, getElementPosition(localPlayer)) <= 7.5 then
			dxDrawText(getText("CLumberjack3"),
				screenX1 - 100, screenY1 - 20, screenX1 + 100, screenY1 + 20,
				tocolor(255,255,255), 1.2, "default-bold", "center", "center")
		end

		if screenX2 and screenY2 and getDistanceBetweenPoints3D(x2, y2, z2, getElementPosition(localPlayer)) <= 10 then
			dxDrawText(getText("CLumberjack2"),
				screenX2 - 100, screenY2 - 20, screenX2 + 100, screenY2 + 20,
				tocolor(255,255,255), 1.2, "default-bold", "center", "center")
		end
	end
end

addEventHandler("onClientRender",root,function()
	if(isCharacterLoggedIn() and isWindowOpen())then
		local x1,y1,z1 = getElementPosition(LumberjackPickup)
		local screenX1,screenY1 = getScreenFromWorldPosition(x1,y1,z1)
		
		if(screenX1 and screenY1)then
			if(getDistanceBetweenPoints3D(x1,y1,z1,getElementPosition(localPlayer)) <= 5)then
				dxDrawText(getText("CLumberjack1"), screenX1 - 100, screenY1 - 20, screenX1 + 100, screenY1 + 20, tocolor(255, 255, 255), 1.2, "default-bold", "center", "center")
			end
		end
	end
end)

addEvent("Holzfaeller.level1",true)
addEventHandler("Holzfaeller.level1",root,function()
	triggerServerEvent("Holzfaeller.level1",localPlayer)
end)

addEvent("Holzfaeller.createMarker",true)
addEventHandler("Holzfaeller.createMarker",root,function(type)
	if(isElement(Holzfaeller.holzAbgabe))then destroyElement(Holzfaeller.holzAbgabe)end
	if(isElement(Holzfaeller.sawMarker))then destroyElement(Holzfaeller.sawMarker)end
	if(isElement(Holzfaeller.wald1))then destroyElement(Holzfaeller.wald1)end
	if(isElement(Holzfaeller.wald2))then destroyElement(Holzfaeller.wald2)end
	if(isElement(Holzfaeller.wald3))then destroyElement(Holzfaeller.wald3)end
	removeEventHandler("onClientRender",root,Holzfaeller.text)
	
	if(type)then
		addEventHandler("onClientRender",root,Holzfaeller.text)
		Holzfaeller.wald1 = createBlip(-654.68725585938,-662.52996826172,43.529571533203,53)
		Holzfaeller.wald2 = createBlip(-2590.8999023438,-2233.1999511719,24.299999237061,53)
		Holzfaeller.wald3 = createBlip(-1860.5,-2628.3999023438,54.799999237061,53)
		Holzfaeller.holzAbgabe = createMarker(-2027.8552246094,-2335.2182617188,30.625-1,"cylinder",4,0,255,0,125)
		Holzfaeller.sawMarker = createMarker(-2012.6279296875,-2350.1589355469,30.625-1,"cylinder",1,0,0,200,125)
		
		addEventHandler("onClientMarkerHit",Holzfaeller.holzAbgabe,function(player)
			if(player == localPlayer)then
				triggerServerEvent("Holzfaeller.holzAbgabe",localPlayer)
			end
		end)
		
		addEventHandler("onClientMarkerHit",Holzfaeller.sawMarker,function(player)
			if(player == localPlayer)then
				triggerServerEvent("Holzfaeller.cutWood",localPlayer)
			end
		end)
	end
end)

addEventHandler("onClientPedDamage",root,function(attacker,weapon)
	if(getElementData(source,"baum") == true)then
		cancelEvent()
		if(weapon == 9)then
			triggerServerEvent("Holzfaeller.baumDamage",localPlayer,source,attacker)
		end
	end
end)