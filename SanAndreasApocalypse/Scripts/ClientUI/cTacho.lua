local Open = false

function dxDrawTacho()
	if(isCharacterLoggedIn())then
        if(isPedInVehicle(localPlayer))then
			if(InformationHelpBarOpen == false)then
				local veh = getPedOccupiedVehicle(localPlayer)
				if(veh and not(apocalypseGetElementData(veh,"LootVehicle")))then
					local model = getElementModel(veh)
					if(model ~= 509 and model ~= 510 and model ~= 481)then
						local sx, sy, sz = getElementVelocity(veh)
						local speed = math.floor(math.sqrt(sx^2 + sy^2 + sz^2) * 180)
						local benzin = apocalypseGetElementData(veh, "fuel") or 0
						local kilometre = apocalypseGetElementData(veh,"kilometre") or 0

						local screenWidth, screenHeight = guiGetScreenSize()
						local x = screenWidth / 2
						local y = screenHeight - 30

						dxDrawText(getText("CTacho1"):format(speed,benzin,math.floor(kilometre)), x - 200, y - 20, x + 200, y + 10, tocolor(255, 255, 255, 255), 1.2, "default-bold", "center", "center", false, false, false, false, false)
					end
				end
			end
        end
	end
end

addEventHandler("onClientVehicleEnter", root, function(player)
    if(player == localPlayer and getPedOccupiedVehicleSeat(player) == 0)then
        if(Open == false)then
            addEventHandler("onClientRender", root, dxDrawTacho)
            Open = true
        end
    end
end)

addEventHandler("onClientVehicleExit", root, function(player)
    if(player == localPlayer)then
        Open = false
        removeEventHandler("onClientRender", root, dxDrawTacho)
    end
end)

addEventHandler("onClientPlayerWasted", root, function(player)
    if(player == localPlayer)then
        removeEventHandler("onClientRender", root, dxDrawTacho)
        Open = false
    end
end)
