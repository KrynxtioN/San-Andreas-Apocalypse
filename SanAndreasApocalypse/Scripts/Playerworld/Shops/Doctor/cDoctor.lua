Doctor = {}
apocalypseSetElementData(localPlayer,"Doctor.bindKey",false)

Doctor.NPC = createPed(275,668.42071533203,-455.48950195312,16.335899353027,72)
Doctor.Pickup = createPickup(668.42071533203,-455.48950195312,16.335899353027+1.5,3,1240,50)
Doctor.Marker = createMarker(668.42071533203,-455.48950195312,16.335899353027,"cylinder",1,5,0,0,0)

addEventHandler("onClientPedDamage",Doctor.NPC,function()
	cancelEvent()
end)

addEventHandler("onClientMarkerHit",Doctor.Marker,function(player)
	if(player == localPlayer)then
		if(not(isPedDead(localPlayer)))then
			if(not(isPedInVehicle(localPlayer)))then
				if(apocalypseGetElementData(localPlayer,"Doctor.bindKey") ~= true)then
					bindKey("e","down",Doctor.triggerServer)
					apocalypseSetElementData(localPlayer,"Doctor.bindKey",true)
				end
				createActivitiesInformationText(getText("CDoctor1"))
			end
		end
	end
end)

function Doctor.triggerServer()
	local x,y,z = getElementPosition(Doctor.Marker)
	if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(localPlayer)) <= 5)then
		unbindKey("e","down",Doctor.triggerServer)
		apocalypseSetElementData(localPlayer,"Doctor.bindKey",false)
		triggerServerEvent("Doctor.server",localPlayer,getElementModel(Doctor.NPC))
	end
end