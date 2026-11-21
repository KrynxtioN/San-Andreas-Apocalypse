addEventHandler("onClientVehicleDamage",root,function(attacker,weapon)
    if(attacker == localPlayer)then
		if(getElementModel(source) == 432 and apocalypseGetElementData(source,"RhinoMissionID"))then
			if(weapon and weapon == 18 or weapon == 37)then
				if(not(apocalypseGetElementData(localPlayer,"RhinosTempMsg")))then
					NPC.MeMessage(getText("SRhinoMission2"))
					apocalypseSetElementData(localPlayer,"RhinosTempMsg",true)
					setTimer(function()
						apocalypseSetElementData(localPlayer,"RhinosTempMsg",false)
					end,30000,1)
				end
				apocalypseSetElementData(source,"LastHit",getPlayerName(localPlayer))
			end
		end
    end
end)

addEventHandler("onClientPlayerVehicleEnter", localPlayer, function(vehicle, seat)
	if getElementModel(vehicle) == 432 and apocalypseGetElementData(vehicle,"RhinoMissionID") then
		toggleControl("vehicle_fire", false)
		toggleControl("vehicle_secondary_fire", false)
	end
end)

addEventHandler("onClientPlayerVehicleExit", localPlayer,function(vehicle, seat)
	if getElementModel(vehicle) == 432 then
		toggleControl("vehicle_fire", true)
		toggleControl("vehicle_secondary_fire", true)
	end
end)