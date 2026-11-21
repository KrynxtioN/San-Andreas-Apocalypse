Mushrooms = {}

addEventHandler("onPlayerClick",root,function(button,state,clickedElement)
	if(isElement(clickedElement))then
		if not isCharacterLoggedIn(source) then return end
		if button ~= "left" or state ~= "down" or not clickedElement then return end
		local model = getElementModel(clickedElement)
		if(model == 1877 or model == 1878)then
			if(apocalypseGetElementData(clickedElement,"PlantID"))then return end
			
			local x,y,z = getElementPosition(clickedElement)
			if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(source)) <= 3.5)then
				if(model == 1877)then
					giveItem(source,199,1)
					triggerClientEvent(source, "showItemBar", source, {{199,1}})
				end
				if(model == 1878)then
					giveItem(source,200,1)
					triggerClientEvent(source, "showItemBar", source, {{200,1}})
				end
				setTimer(function(model,x,y,z)
					createObject(model,x,y,z,0,0,math.random(0,360))
				end,300000,1,model,x,y,z)
				destroyElement(clickedElement)
			end
		end
	end
end)