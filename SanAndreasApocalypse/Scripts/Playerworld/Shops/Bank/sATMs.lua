ATMs = {
	["Objects"] = {
		{2942,378.52731323242,177.67790222168,1008.0256958008,0,0,0,3,0},
		{2942,379.52734375,177.677734375,1008.0256958008,0,0,0,3,0},
		{2942,380.52734375,177.677734375,1008.0256958008,0,0,0,3,0},
		{2942,381.52734375,177.677734375,1008.0256958008,0,0,0,3,0},
		{2942,382.52734375,177.677734375,1008.0256958008,0,0,0,3,0},
	},
}

for _,v in pairs(ATMs["Objects"])do
	local atm_object = createObject(v[1],v[2],v[3],v[4],v[6],v[7])
	if(v[8])then setElementInterior(atm_object,v[8])end
	if(v[9])then setElementDimension(atm_object,v[9])end
	apocalypseSetElementData(atm_object,"ATM",true)
end

addEventHandler("onPlayerClick",root,function(button,state,clickedElement)
	if(isCharacterLoggedIn(source))then
		if(button == "left" and state == "down")then
			if(clickedElement and isElement(clickedElement))then
				if(getElementType(clickedElement) == "object")then
					if(apocalypseGetElementData(clickedElement,"ATM") == true)then
						local x,y,z = getElementPosition(clickedElement)
						if(getElementDimension(source) == getElementDimension(clickedElement))then
							if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(source)) <= 7.5)then
								local Model = getElementModel(clickedElement)
								local Level = tonumber(apocalypseGetElementData(source,"level")) or 0
								if(Model == 2942)then
									triggerClientEvent(source,"Bank.openWindow",source)
								end
							end
						end
					end
				end
			end
		end
	end
end)