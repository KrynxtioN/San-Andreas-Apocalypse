WaterDispenser = {
	["Spawn"] = {
		{200.71640014648,-229.61430358887,0.77859997749329,0,0,180},
		{-2191.75390625,2413.4521484375,4.1561999320984,0,0,134},
		{-1978.9285888672,131.73989868164,26.6875,0,0,90},
		{668.46099853516,-438.11099243164,15.335900306702,0,0,0},
		{-279.15640258789,-2176.1281738281,27.688600540161,0,0,24.5},
		{-2479.8479003906,-135.5699005127,24.61720085144,0,0,180},
	},
}

local drinkTimer = {}

function WaterDispenser.load()
	for _,v in pairs(WaterDispenser["Spawn"])do
		local object = createObject(1808,v[1],v[2],v[3],v[4],v[5],v[6])
		apocalypseSetElementData(object,"WaterDispenser",true)
	end
end
WaterDispenser.load()

addEventHandler("onPlayerClick", root, function(button, state, clickedElement)
	if(button == "left" and state == "down" and clickedElement and isElement(clickedElement))then
		if(getElementType(clickedElement) == "object")then
			if(apocalypseGetElementData(clickedElement,"WaterDispenser"))then
				local x, y, z = getElementPosition(source)
				if(getDistanceBetweenPoints3D(x, y, z, getElementPosition(clickedElement)) <= 2.5)then
					if(not(isTimer(drinkTimer[source])))then
						giveThirst(source,10)
						toggleAllControls(source,false)
						setElementFrozen(source,true)
						setPedAnimation(source,"vending","vend_drink_p")
						setAchievement(source,72)
						NPC.MeMessage(source,getText(source,"SWaterDispenser1"))
						triggerClientEvent(source,"TutorialPickups.deletePickup",source,"WaterDispenser")
						drinkTimer[source] = setTimer(function(source)
							setPedAnimation(source)
							setElementFrozen(source,false)
							toggleAllControls(source,true)
						end,1250,1,source)
					end
				end
			end
		end
	end
end)