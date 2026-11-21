Halloween = {}
apocalypseSetElementData(localPlayer,"halloween_effects","off")

addEvent("resetSky",true)
addEventHandler("resetSky",root,function()
	resetSkyGradient()
end)

addEvent("setSky",true)
addEventHandler("setSky",root,function()
	setSkyGradient(0,0,0)
	setWeather(9)
end)

function Halloween.renderInfoText()
	if(isCharacterLoggedIn() and isWindowOpen())then
		local x1,y1,z1 = getElementPosition(Halloween.Quests)
		local screenX1,screenY1 = getScreenFromWorldPosition(x1,y1,z1 + 1)
			
		if(screenX1 and screenY1)then
			if(getDistanceBetweenPoints3D(x1,y1,z1,getElementPosition(localPlayer)) <= 7.5)then
				dxDrawText(getText("CHalloween7"), screenX1 - 100, screenY1 - 20, screenX1 + 100, screenY1 + 20, tocolor(255, 255, 255), 1.2, "default-bold", "center", "center")
			end
		end
		
		local x2,y2,z2 = getElementPosition(Halloween.InformationMarker)
		local screenX2,screenY2 = getScreenFromWorldPosition(x2,y2,z2)
			
		if(screenX2 and screenY2)then
			if(getDistanceBetweenPoints3D(x2,y2,z2,getElementPosition(localPlayer)) <= 7.5)then
				dxDrawText(getText("CHalloween8"), screenX2 - 100, screenY2 - 20, screenX2 + 100, screenY2 + 20, tocolor(255, 255, 255), 1.2, "default-bold", "center", "center")
			end
		end
	end
end

if(HalloweenEvent == true)then
	setSkyGradient(0,0,0)
	setWeather(9)
	apocalypseSetElementData(localPlayer,"halloween_effects","on")
	Halloween.Quests = createMarker(672.40948486328,-432.22491455078,15.552700042725,"cylinder",1.5,250,100,0,125)
	
	addEventHandler("onClientMarkerHit",Halloween.Quests,function(player)
		if(player == localPlayer)then
			if(getElementDimension(localPlayer) == getElementDimension(source))then
				HalloweenQuestUI.openWindow()
			end
		end
	end)
	
	Halloween.InformationMarker = createPickup(676.82867431641,-429.78231811523,16.708383560181,3,1239,50)
	
	addEventHandler("onClientPickupHit",Halloween.InformationMarker,function(player)
		if(player == localPlayer)then
			if(getElementDimension(localPlayer) == getElementDimension(source))then
				openHalloweenWindow()
			end
		end
	end)
	
	addEventHandler("onClientRender",root,Halloween.renderInfoText)
end