AreaCard = {bombObject = {}}
AreaCard.Vehicle = createVehicle(428,87.689697265625,-307.39001464844,1.8279000520706,0,0,30)
setElementFrozen(AreaCard.Vehicle,true)
setVehicleLocked(AreaCard.Vehicle,true)
setVehicleDamageProof(AreaCard.Vehicle,true)

function AreaCard.loadData(player)
	if(hasPlayerItem(player,150) < 1)then
		triggerClientEvent(player,"AreaCard.createCard",player)
		if(hasRadioLocation(player,8) == true)then
			triggerClientEvent(player,"AreaCard.createMarker",player)
		end
	end
end

addEvent("AreaCard.giveCard",true)
addEventHandler("AreaCard.giveCard",root,function()
	if(hasPlayerItem(client,150) < 1)then
		giveItem(client,150,1)
		triggerClientEvent(client, "showItemBar", client, {{150,1}})
		NPC.MeMessage(client,getText(client,"SAreaCard1"))
		outputLog(getPlayerName(client).." hat die Area Card eingesammelt","Area Card",getCharacterID(client))
	end
end)

addEvent("AreaCard.placeDynamite",true)
addEventHandler("AreaCard.placeDynamite",root,function()
	if(not(isElement(AreaCard.bombObject[client])))then
		if(hasPlayerItem(client,26) >= 1)then
			takeItem(client,26,1)
			local x,y,z = getElementPosition(client)
			local dynamite = createObject(1654,x-0.5,y,z-0.85,-90,0,0)
			AreaCard.bombObject[client] = dynamite
			setElementFrozen(client,true)
			setPedAnimation(client,"BOMBER", "BOM_Plant_Loop",-1,true,false,false,true)
										
			setTimer(function(client)
				setElementFrozen(client,false)
				setPedAnimation(client)
				NPC.MeMessage(client,getText(client,"MeMessage8"))
			end,3500,1,client)
										
			setTimer(function(dynamite, player)
				local x,y,z = getElementPosition(dynamite)
				createExplosion(x,y,z,5)
				destroyElement(dynamite)
				giveEXP(player,2500)
				givePlayerSkillpoint(player,25)
				triggerClientEvent(player,"AreaCard.destroy",player)
			end,7500,1,dynamite, client)
			triggerClientEvent(client,"AreaCard.placeDynamite",client)
		else
			NPC.MeMessage(client,getText(client,"MeMessage7"))
		end
	end
end)