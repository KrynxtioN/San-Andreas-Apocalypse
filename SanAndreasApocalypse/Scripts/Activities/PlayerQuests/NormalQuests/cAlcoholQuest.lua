Alcohol_Quest = { Crates = {}, Crate_Carry_ID = nil,
	["Crate_Objects"] = {
		{2912,-100.93560028076,1368.4875488281,9.2734003067017,0,0,326},
		{2912,-100.68759918213,1367.8920898438,9.9983997344971,0,0,325},
		{2912,-101.44170379639,1367.3902587891,9.9983997344971,0,0,311},
		{2912,-101.85579681396,1367.5288085938,9.2734003067017,0,0,325},
		{2912,-100.79630279541,1367.5758056641,9.2734003067017,0,0,0},
	},
}

apocalypseSetElementData(localPlayer,"Alcohol_Quest_Player_Has_Crate",false)

local function hasPlayerCrate() return apocalypseGetElementData(localPlayer,"Alcohol_Quest_Player_Has_Crate") end

function Alcohol_Quest.startQuest()
	Alcohol_Quest.resetQuest()

	for i,v in pairs(Alcohol_Quest["Crate_Objects"])do
		Alcohol_Quest.Crates[i] = createObject(v[1],v[2],v[3],v[4],v[5],v[6],v[7])
		apocalypseSetElementData(Alcohol_Quest.Crates[i],"Alcohol_Quest_CrateID",i)
	end
	
	Alcohol_Quest.CollectInformationMarker = createPickup(-101.44789123535,1373.3073730469,10.2734375,3,1239,50)
	
	addEventHandler("onClientPickupHit",Alcohol_Quest.CollectInformationMarker,function(player)
		if(player == localPlayer)then
			if(getElementDimension(localPlayer) == getElementDimension(source))then
				if(getElementInterior(localPlayer) == getElementInterior(source))then
					createInfobox(getText("CAlcoholQuest1"))
					triggerServerEvent("Alcohol_Quest.startQuest",localPlayer)
				end
			end
		end
	end)
	
	Alcohol_Quest.DeadPed = createPed(0,-103.31610107422,1375.0545654297,10.273400306702,math.random(0,360))
	killPed(Alcohol_Quest.DeadPed)
	Alcohol_Quest.IDCard = createPickup(-103.31610107422,1375.0545654297,10.273400306702,3,1581,50)
	
	addEventHandler("onClientPickupHit",Alcohol_Quest.IDCard,function(player)
		if(player == localPlayer)then
			if(getElementDimension(localPlayer) == getElementDimension(source))then
				if(getElementInterior(localPlayer) == getElementInterior(source))then
					NPC.MeMessage(getText("CAlcoholQuest4"))
					destroyElement(source)
				end
			end
		end
	end)
end
addEvent("Alcohol_Quest.startQuest",true)
addEventHandler("Alcohol_Quest.startQuest",root,Alcohol_Quest.startQuest)

addEvent("Alcohol_Quest.createBlip",true)
addEventHandler("Alcohol_Quest.createBlip",root,function()
	if(isElement(Alcohol_Quest.Blip))then destroyElement(Alcohol_Quest.Blip)end
	if(isElement(Alcohol_Quest.DeliveryMarker))then destroyElement(Alcohol_Quest.DeliveryMarker)end
	Alcohol_Quest.Blip = createBlip(700.04937744141,-467.84146118164,16.3359375,41)
	Alcohol_Quest.DeliveryMarker = createMarker(700.04937744141,-467.84146118164,16.1359375,"cylinder",3,255,255,255,75)
	
	addEventHandler("onClientMarkerHit",Alcohol_Quest.DeliveryMarker,function(player)
		if(player == localPlayer)then
			triggerServerEvent("Alcohol_Quest.Delivery",localPlayer)
		end
	end)
end)

addEvent("Alcohol_Quest.removeBlip",true)
addEventHandler("Alcohol_Quest.removeBlip",root,function()
	if(isElement(Alcohol_Quest.Blip))then destroyElement(Alcohol_Quest.Blip)end
	if(isElement(Alcohol_Quest.DeliveryMarker))then destroyElement(Alcohol_Quest.DeliveryMarker)end
end)

function Alcohol_Quest.takeCrate(ID)
	if(isElement(Alcohol_Quest.Crates[ID]))then
		createInfobox(getText("CAlcoholQuest3"))
		bindKey("backspace","down",Alcohol_Quest.dropCrate)
		attachElements(Alcohol_Quest.Crates[ID],localPlayer,0,0.4,0.3)
		setElementCollisionsEnabled(Alcohol_Quest.Crates[ID],false)
		setPedAnimation(localPlayer,"CARRY","crry_prtial",50)
		apocalypseSetElementData(localPlayer,"Alcohol_Quest_Crate",true)
	end
end

function Alcohol_Quest.dropCrate()
	if(Alcohol_Quest.Crate_Carry_ID ~= nil)then
		unbindKey("backspace","down",Alcohol_Quest.dropCrate)
		detachElements(Alcohol_Quest.Crates[Alcohol_Quest.Crate_Carry_ID],localPlayer)
		setElementCollisionsEnabled(Alcohol_Quest.Crates[Alcohol_Quest.Crate_Carry_ID],true)
		setPedAnimation(localPlayer, "ped", "WOMAN_walknorm")
		setTimer(function()
			setPedAnimation(localPlayer)
		end,50,1)
		Alcohol_Quest.Crate_Carry_ID = nil
		apocalypseSetElementData(localPlayer,"Alcohol_Quest_Crate",false)
	end
end

addEvent("Alcohol_Quest.destroyCrate",true)
addEventHandler("Alcohol_Quest.destroyCrate",root,function()
	if(Alcohol_Quest.Crate_Carry_ID ~= nil)then
		if(isElement(Alcohol_Quest.Crates[Alcohol_Quest.Crate_Carry_ID]))then
			destroyElement(Alcohol_Quest.Crates[Alcohol_Quest.Crate_Carry_ID])
			apocalypseSetElementData(localPlayer,"Alcohol_Quest_Crate",false)
			setPedAnimation(localPlayer, "ped", "WOMAN_walknorm")
			setTimer(function()
				setPedAnimation(localPlayer)
			end,50,1)
		end
	end
end)

addEventHandler("onClientClick",root,function(button,state,_,_,_,_,_,clickedElement)
	if(isCharacterLoggedIn() and isWindowOpen())then
		if(clickedElement and isElement(clickedElement))then
			if(button == "left" and state == "down" and getElementType(clickedElement) == "object")then
				local x,y,z = getElementPosition(clickedElement)
				if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(localPlayer)) <= 2.5)then
					if(apocalypseGetElementData(clickedElement,"Alcohol_Quest_CrateID"))then
						if(hasPlayerCrate() == false)then
							Alcohol_Quest.Crate_Carry_ID = apocalypseGetElementData(clickedElement,"Alcohol_Quest_CrateID")
							Alcohol_Quest.takeCrate(Alcohol_Quest.Crate_Carry_ID)
						else
							NPC.MeMessage(getText("CAlcoholQuest2"))
						end
					end
				end
			end
		end
	end
end)

function Alcohol_Quest.resetQuest()
	for _,v in pairs(Alcohol_Quest.Crates)do
		if(isElement(v))then
			destroyElement(v)
		end
	end
	Alcohol_Quest.Crates = {}
	Alcohol_Quest.Crate_Carry_ID = nil
	
	if(isElement(Alcohol_Quest.CollectInformationMarker))then
		destroyElement(Alcohol_Quest.CollectInformationMarker)
	end
	if(isElement(Alcohol_Quest.DeadPed))then
		destroyElement(Alcohol_Quest.DeadPed)
	end
	if(isElement(Alcohol_Quest.IDCard))then
		destroyElement(Alcohol_Quest.IDCard)
	end
	if(isElement(Alcohol_Quest.Blip))then destroyElement(Alcohol_Quest.Blip)end
	if(isElement(Alcohol_Quest.DeliveryMarker))then destroyElement(Alcohol_Quest.DeliveryMarker)end
end
addEvent("Alcohol_Quest.resetQuest",true)
addEventHandler("Alcohol_Quest.resetQuest",root,Alcohol_Quest.resetQuest)

addEventHandler("onClientPlayerWasted",root,function()
	Alcohol_Quest.dropCrate()
end)