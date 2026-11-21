for i,v in ipairs(VendingMachine["Coordinates"])do
	if(not(isElement(VendingMachine.object[i])))then
		VendingMachine.object[i] = createObject(v[1],v[2],v[3],v[4],v[5],v[6],v[7])
		apocalypseSetElementData(VendingMachine.object[i],"VendingMachineID",i)
		apocalypseSetElementData(VendingMachine.object[i],"VendingMachineAmount",15)
		
		VendingMachine.Marker[i] = createMarker(v[2],v[3],v[4],"cylinder",2.5,255,0,0,0)
		apocalypseSetElementData(VendingMachine.Marker[i],"VendingMachineID",i)
		apocalypseSetElementData(VendingMachine.Marker[i],"Destroyable",true)
		
		addEventHandler("onMarkerHit",VendingMachine.Marker[i],function(player)
			if(getElementType(player) == "player")then
				if(getElementDimension(player) == getElementDimension(source))then
					if(not(isPedInVehicle(player)))then
						local ID = apocalypseGetElementData(source,"VendingMachineID")
						if(apocalypseGetElementData(source,"Destroyable") == true)then
							triggerClientEvent(player,"createActivitiesInformationText",player,getText(player,"SVendingMachine1"))
						end
					end
				end
			end
		end)
	end
end

function VendingMachine.placeDynamite(player)
	local marker = nil
	for _,v in pairs(VendingMachine.Marker)do
		if(isElementWithinMarker(player,v))then
			marker = v
			break
		end
	end
	if(marker ~= nil)then
		if(apocalypseGetElementData(marker,"Destroyable") == true)then
			if(hasPlayerItem(player,26) >= 1)then
				takeItem(player,26,1)
				local ID = apocalypseGetElementData(marker,"VendingMachineID")
				local x,y,z = getElementPosition(player)
				VendingMachine.dynamiteObject[ID] = createObject(1654,x-0.5,y,z-0.85,-90,0,0)
				local model = getElementModel(VendingMachine.object[ID])
				setElementFrozen(player,true)
				setPedAnimation(player,"BOMBER", "BOM_Plant_Loop",-1,true,false,false,true)
				setTimer(function(player)
					setElementFrozen(player,false)
					setPedAnimation(player)
					NPC.MeMessage(player,getText(player,"MeMessage20"))
				end,3500,1,player)
				
				setTimer(function(ID)
					local x,y,z = getElementPosition(VendingMachine.dynamiteObject[ID])
					createExplosion(x,y,z,0.5)
					destroyElement(VendingMachine.dynamiteObject[ID])
					apocalypseSetElementData(VendingMachine.Marker[ID],"Destroyable",false)
					
					local pickup = createPickup(x,y,z+0.85,3,1212,50)
					
					addEventHandler("onPickupHit",pickup,function(player)
						if(not(isPedInVehicle(player)))then
							if(getElementDimension(player) == getElementDimension(source))then
								local money = math.random(20,35)
								giveEXP(player,150)
								givePlayerServerMoney(player,money)
								destroyElement(source)
							end
						end
					end)
					
					setTimer(function(ID,pickup)
						if(isElement(pickup))then destroyElement(pickup)end
						apocalypseSetElementData(VendingMachine.Marker[ID],"Destroyable",true)
					end,900000,1,ID,pickup)
				end,7500,1,ID)
			else
				NPC.MeMessage(player,getText(player,"MeMessage7"))
			end
		end
	end
end

addEventHandler("onPlayerClick", root, function(button, state, clickedElement)
	if(button == "left" or button == "right" and state == "down" and clickedElement)then
		if(isElement(clickedElement) and getElementType(clickedElement) == "object")then
			local ID = tonumber(apocalypseGetElementData(clickedElement, "VendingMachineID"))
			local x,y,z = getElementPosition(source)
			if(ID)then
				if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(clickedElement)) <= 2.0)then
					if(apocalypseGetElementData(VendingMachine.Marker[ID],"Destroyable") == true)then
						local model = getElementModel(clickedElement)
						local price = 0
						local amount = tonumber(apocalypseGetElementData(clickedElement,"VendingMachineAmount"))
						if(amount >= 1)then
							if(model == 1302)then price = 1 end
							if(model == 1775)then price = 1 end
							if(tonumber(apocalypseGetElementData(source,"money")) >= price)then
								apocalypseSetElementData(clickedElement,"VendingMachineAmount",amount - 1)
								if(button == "left" and state == "down")then
									if(model == 1302)then
										giveHunger(source, math.random(1,3))
										setAchievement(source,73)
										triggerClientEvent(source,"TutorialPickups.deletePickup",source,"SnackVendingMachine")
									elseif(model == 1775)then
										giveThirst(source, math.random(1,3))
									end
								elseif(button == "right" and state == "down")then
									if(model == 1775)then
										giveItem(source,41,1)
									elseif(model == 1302)then
										giveItem(source,43,1)
									end
								end
								VendingMachine.Animation(source)
								apocalypseSetElementData(source,"money",apocalypseGetElementData(source,"money")-price)
							end
						else
							NPC.MeMessage(source,getText(player,"MeMessage21"))
						end
					else
						NPC.MeMessage(source,getText(player,"MeMessage19"))
					end
				end
			end
		end
	end
end)

function VendingMachine.Animation(player)
	if(isTimer(VendingMachine.animationTimer[player]))then killTimer(VendingMachine.animationTimer[player])end
	setPedAnimation(player,"vending","vend_use",-1,true,false,false,true)
	VendingMachine.animationTimer[player] = setTimer(function(player)
		setPedAnimation(player)
	end,2500,1,player)
end