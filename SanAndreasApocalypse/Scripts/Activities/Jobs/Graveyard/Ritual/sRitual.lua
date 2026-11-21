Ritual = {}
Ritual.Marker = createMarker(816.59631347656,-1102.9230957031,24.843099594116,"cylinder",2,255,0,0,75)
Ritual.inMarker = createPickup(815.50354003906,-1091.4907226562,25.789979934692,3,1318,50)

addEventHandler("onMarkerHit",Ritual.Marker,function(player)
	if(not(isPedInVehicle(player)))then
		if(getElementDimension(player) == getElementDimension(source))then
			if(getElementInterior(player) == getElementInterior(source))then
				if(hasPlayerKey(player,16) == 0)then
					triggerClientEvent(player,"Ritual.openWindow",player)
				else
					NPC.MeMessage(player,getText(player,"SRitual3"))
				end
			end
		end
	end
end)

addEventHandler("onPickupHit",Ritual.inMarker,function(player)
	if(not(isPedInVehicle(player)))then
		if(getElementDimension(player) == getElementDimension(source))then
			if(getElementInterior(player) == getElementInterior(source))then
				if(hasPlayerKey(player,16) >= 1)then
					createInfobox(player,"WORK IN PROGRESS")
				else
					createInfobox(player,"WORK IN PROGRESS")
				end
			end
		end
	end
end)

function Ritual.start(player)
	if(not(player))then player = client end
	if(hasPlayerKey(player,16) == 0)then
		if(hasPlayerItem(player,174) >= 50)then
			takeItem(player,174,50)
			NPC.MeMessage(player,getText(player,"SRitual2"))
			triggerClientEvent(player,"Ritual.start",player)
		else
			NPC.MeMessage(player,getText(player,"SRitual1"))
		end
	else
		NPC.MeMessage(player,getText(player,"SRitual3"))
	end
end
addEvent("Ritual.start",true)
addEventHandler("Ritual.start",root,Ritual.start)

addEvent("Ritual.finished",true)
addEventHandler("Ritual.finished",root,function()
	giveKey(client,16,1)
	NPC.MeMessage(client,getText(client,"SRitual4"))
	setAchievement(client,307)
	outputLog(getPlayerName(client).." hat ein Ritual abgeschlossen", "Ritual", getCharacterID(client))
end)

addEventHandler("onPlayerWasted",root,function()
	triggerClientEvent(source,"Ritual.stop",source)
end)