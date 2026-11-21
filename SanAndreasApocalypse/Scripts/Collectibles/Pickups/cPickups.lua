addEvent("CollectiblePickups.create",true)
addEventHandler("CollectiblePickups.create",root,function(model, x, y, z, id, Type, int)
    local model, x, y, z, id = tonumber(model),tonumber(x),tonumber(y),tonumber(z),tonumber(id)
    local pickup = createPickup(x, y, z, 3, model, 50)
	if(int)then setElementInterior(pickup,int)end
    apocalypseSetElementData(pickup, "CollectiblePickupID", id)
    apocalypseSetElementData(pickup, "CollectiblePickupType", Type)
    
    addEventHandler("onClientPickupHit", pickup, function(player)
        if(player == localPlayer)then
            if(not(isPedInVehicle(player)))then
                if(getElementDimension(player) == getElementDimension(source))then
                    local ID = apocalypseGetElementData(source, "CollectiblePickupID")
                    local Type = apocalypseGetElementData(source, "CollectiblePickupType")
                    destroyElement(source)
                    triggerServerEvent("CollectiblePickups.add", localPlayer, ID, Type)
                end
            end
        end
    end)
end)