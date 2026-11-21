CollectibleChainsaw = {pickup = {}}

addEvent("CollectibleChainsaw.createPickup",true)
addEventHandler("CollectibleChainsaw.createPickup",root,function(id,x,y,z,int,dim)
	if(not(isElement(CollectibleChainsaw.pickup[id])))then
		CollectibleChainsaw.pickup[id] = createPickup(x,y,z,3,341,50)
		setElementInterior(CollectibleChainsaw.pickup[id],int)
		setElementDimension(CollectibleChainsaw.pickup[id],dim)
		apocalypseSetElementData(CollectibleChainsaw.pickup[id],"CollectibleChainsaw",id)
		
		addEventHandler("onClientPickupHit",CollectibleChainsaw.pickup[id],function(player)
			if(player == localPlayer)then
				if(getElementDimension(player) == getElementDimension(source))then
					if(getElementInterior(player) == getElementInterior(source))then
						if(not(isPedInVehicle(player)))then
							local id = apocalypseGetElementData(source,"CollectibleChainsaw")
							triggerServerEvent("giveCollectibleChainsaw",localPlayer,id)
							destroyElement(source)
						end
					end
				end
			end
		end)
	end
end)

addEvent("ChainsawPickup",true)
addEventHandler("ChainsawPickup",root,function()
	local pickup = createPickup(-2049.9318847656,-2445.6674804688,30.625,3,341,50)
	addEventHandler("onClientPickupHit",pickup,function(player)
		if(player == localPlayer)then
			if(getElementDimension(player) == getElementDimension(source))then
				triggerServerEvent("addChainsaw",localPlayer)
			end
		end
	end)
end)