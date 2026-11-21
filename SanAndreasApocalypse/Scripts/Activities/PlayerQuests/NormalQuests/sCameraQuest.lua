CameraQuest = {SearchForCode = {}, Status = 0}

CameraQuest.Keypad1 = createObject(2886,1711.5329589844,-1642.712890625,20.53689956665,0,0,42.25)
setElementInterior(CameraQuest.Keypad1,18)
setObjectBreakable(CameraQuest.Keypad1,false)
CameraQuest.Keypad2 = createObject(2922,1714.2388916016,-1640.1507568359,20.516799926758,0,0,225)
setElementInterior(CameraQuest.Keypad2,18)
setObjectBreakable(CameraQuest.Keypad2,false)
CameraQuest.Keypad2ClickObject1 = createObject(2358,1714.087890625,-1639.9404296875,20.578100204468,0,0,134)
CameraQuest.Keypad2ClickObject2 = createObject(2358,1714.0880126953,-1639.9403076172,20.453100204468,0,0,134)
setElementInterior(CameraQuest.Keypad2ClickObject1,18)
setElementInterior(CameraQuest.Keypad2ClickObject2,18)
setElementAlpha(CameraQuest.Keypad2ClickObject1,0)
setElementAlpha(CameraQuest.Keypad2ClickObject2,0)
setObjectBreakable(CameraQuest.Keypad2ClickObject1,false)
setObjectBreakable(CameraQuest.Keypad2ClickObject2,false)

function CameraQuest.loadObjects()
	CameraQuest.Status = 0
	CameraQuest.Code = math.random(1111,9999)
	if(isElement(CameraQuest.Gate1))then destroyElement(CameraQuest.Gate1)end
	if(isElement(CameraQuest.Gate2))then destroyElement(CameraQuest.Gate2)end
	if(isElement(CameraQuest.CodeMarker))then destroyElement(CameraQuest.CodeMarker)end
	if(isElement(CameraQuest.Zombie1))then destroyElement(CameraQuest.Zombie1)end
	if(isElement(CameraQuest.Zombie2))then destroyElement(CameraQuest.Zombie2)end

	CameraQuest.Gate1 = createObject(2957,1710.6435546875,-1643.4814453125,20.843000411987,0,0,43.5)
	CameraQuest.Gate2 = createObject(2957,1713.5450439453,-1640.7095947266,20.843000411987,0,0,43.5)
	setElementInterior(CameraQuest.Gate1,18)
	setElementInterior(CameraQuest.Gate2,18)
	apocalypseSetElementData(CameraQuest.Gate2,"Dynamite",false)
	CameraQuest.CodeMarker = createMarker(1721.982421875,-1672.7941894531,19.148899078369,"cylinder",2,255,255,255,25)
	setElementInterior(CameraQuest.CodeMarker,18)
	
	addEventHandler("onMarkerHit",CameraQuest.CodeMarker,function(player)
		if(isCharacterLoggedIn(player))then
			if(getElementInterior(player) == getElementInterior(source))then
				if(getElementDimension(player) == getElementDimension(source))then
					if(not(isTimer(CameraQuest.SearchForCode[player])))then
						setElementFrozen(player,true)
						setPedAnimation(player,"BOMBER", "BOM_Plant_Loop",-1,true,false,false,true)
						CameraQuest.SearchForCode[player] = setTimer(function(player)
							if(isElement(player))then
								setPedAnimation(player)
								setElementFrozen(player,false)
								apocalypseSetElementData(player,"CameraQuest.ActiveCode",true)
								createInfobox(player,getText(player,"SQuests4"):format(CameraQuest.Code))
							end
						end,5000,1,player)
					end
				end
			end
		end
	end)
end
CameraQuest.loadObjects()

function CameraQuest.loadPlayerCollectibleCameras(player)
	if(not(player))then player = client end
	for i = 2, 7 do
		if(hasPlayerCamera(player,i) == false)then
			triggerClientEvent(player,"CameraQuest.createCamera",player,i)
		end
	end
end
addEvent("CameraQuest.loadPlayerCollectibleCameras",true)
addEventHandler("CameraQuest.loadPlayerCollectibleCameras",root,CameraQuest.loadPlayerCollectibleCameras)

addEventHandler("onPlayerClick", root, function(button, state, clickedElement)
	if(button == "left" and state == "down" and clickedElement)then
		local x, y, z = getElementPosition(source)
		if(not(isElement(clickedElement)))then return end
		if(getDistanceBetweenPoints3D(x, y, z, getElementPosition(clickedElement)) <= 5)then
			if(clickedElement == CameraQuest.Keypad1)then
				if(apocalypseGetElementData(source,"CameraQuest.ActiveCode") == true)then
					local x,y,z = getElementPosition(CameraQuest.Gate1)
					moveObject ( CameraQuest.Gate1, 3000, x, y, z - 15)
					CameraQuest.Zombie1 = createZombie(1709.4248046875,-1642.669921875,20.218799591064,28,0)
					setElementInterior(CameraQuest.Zombie1,18)
					apocalypseSetElementData(source,"CameraQuest.ActiveCode",false)
					
					CameraQuest.Status = CameraQuest.Status + 1
					if(CameraQuest.Status >= 2)then
						setTimer(function()
							CameraQuest.loadObjects()
						end,1800000,1)
					end
				end
			elseif(clickedElement == CameraQuest.Keypad2ClickObject1 or clickedElement == CameraQuest.Keypad2ClickObject2)then
				createInfobox(source,getText(source,"SQuests3"))
				triggerClientEvent(source,"createActivitiesInformationText",source,getText(source,"SQuests8"))
			elseif(clickedElement == CameraQuest.Gate2)then
				if(hasPlayerItem(source,26) >= 1)then
					if(apocalypseGetElementData(CameraQuest.Gate2,"Dynamite") == false)then
						takeItem(source,26,1)
						CameraQuest.dynamite = createObject(1654,1713.2347412109,-1641.1633300781,19.428699493408,0,0,42)
						CameraQuest.dynamiteMarker = createMarker(1713.2347412109,-1641.1633300781,19.428699493408,"corona",0.5,255,0,0,125)
						setElementInterior(CameraQuest.dynamite,18)
						setElementInterior(CameraQuest.dynamiteMarker,18)
						apocalypseSetElementData(CameraQuest.Gate2,"Dynamite",true)
						CameraQuest.Status = CameraQuest.Status + 1
						if(CameraQuest.Status >= 2)then
							setTimer(function()
								CameraQuest.loadObjects()
							end,1800000,1)
						end
						
						setTimer(function(source)
							createExplosion(1713.2347412109,-1641.1633300781,19.428699493408,9)
							destroyElement(CameraQuest.Gate2)
							destroyElement(CameraQuest.dynamite)
							destroyElement(CameraQuest.dynamiteMarker)
							if(isElement(source))then
								CameraQuest.Zombie2 = createZombie(1712.2415771484,-1640.0529785156,20.223899841309,28,0)
								setElementInterior(CameraQuest.Zombie2,18)
							end
							for _,v in pairs(getElementsByType("player"))do
								if(isCharacterLoggedIn(v))then
									CameraQuest.loadPlayerCollectibleCameras(v)
								end
							end
						end,7500,1,source)
					end
				else
					NPC.MeMessage(source,getText(source,"MeMessage7"))
				end
			end
		end
	end
end)