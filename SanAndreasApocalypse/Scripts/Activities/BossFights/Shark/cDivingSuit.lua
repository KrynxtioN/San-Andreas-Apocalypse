DivingAreaZone = {}
apocalypseSetElementData(localPlayer,"rentedDivingSuit",false)
apocalypseSetElementData(localPlayer,"DivingSuitUse",false)

addEventHandler("onClientRender", root, function()
    if not (isCharacterLoggedIn() and isWindowOpen()) then return end

    local x1, y1, z1 = 358.39147949219,-2072.0600585938,10.6953125
    local screenX1, screenY1 = getScreenFromWorldPosition(x1, y1, z1)
    local x2, y2, z2 = 353.70391845703,-2068.8413085938,10.6953125
    local screenX2, screenY2 = getScreenFromWorldPosition(x2, y2, z2)

    if screenX1 and screenY1 and getDistanceBetweenPoints3D(x1, y1, z1, getElementPosition(localPlayer)) <= 5 then
        dxDrawText(getText("CDivingSuit1"):format(TreasureHunter.ShellData),
            screenX1 - 100, screenY1 - 20, screenX1 + 100, screenY1 + 20,
            tocolor(255,255,255), 1.2, "default-bold", "center", "center")
    end
	
    if screenX2 and screenY2 and getDistanceBetweenPoints3D(x2, y2, z2, getElementPosition(localPlayer)) <= 5 then
        dxDrawText(getText("CDailyOxygenBonus1"),
            screenX2 - 100, screenY2 - 20, screenX2 + 100, screenY2 + 20,
            tocolor(255,255,255), 1.2, "default-bold", "center", "center")
    end
end)

addEvent("createDivingArea",true)
addEventHandler("createDivingArea",root,function()
	DivingAreaZone.zone = createColRectangle(273.3571472168,-2289.0969238281,250,350)
	DivingAreaZone.area = createRadarArea(273.3571472168,-2289.0969238281,250,350,250,150,0,125)
	
	addEventHandler("onClientColShapeLeave",DivingAreaZone.zone,function(player)
		if(player == localPlayer)then
			destroyElement(DivingAreaZone.zone)
			destroyElement(DivingAreaZone.area)
			apocalypseSetElementData(localPlayer,"rentedDivingSuit",false)
			if(apocalypseGetElementData(localPlayer,"DivingSuitUse") == true)then
				useDivingSuit()
			end
		end
	end)
end)

addEvent("delDivingArea",true)
addEventHandler("delDivingArea",root,function()
	if(isElement(DivingAreaZone.zone))then
		destroyElement(DivingAreaZone.zone)
	end
	if(isElement(DivingAreaZone.area))then
		destroyElement(DivingAreaZone.area)
	end
end)