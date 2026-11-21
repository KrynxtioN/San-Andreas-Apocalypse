local Ped = createPed(possibleSkinsDecorationPeds[math.random(1,#possibleSkinsDecorationPeds)],363.01416015625,-2071.0380859375,10.6953125,180)
local Marker = createMarker(363.01416015625,-2071.0380859375,10.6953125,"cylinder",3,255,255,255,0)
setPedAnimation(Ped,"shop", "smoke_ryd")
setElementFrozen(Ped,true)

addEventHandler("onClientMarkerHit",Marker,function(player)
	if(player == localPlayer)then
		if(getElementType(player) == "player")then
			NPC.NormalMessage(getText("SFishing5"),"no",getElementModel(Ped),"Sawyer Finch")
		end
	end
end)

addEventHandler("onClientPedDamage",root,function()
	if(source == Ped)then
		cancelEvent()
	end
end)