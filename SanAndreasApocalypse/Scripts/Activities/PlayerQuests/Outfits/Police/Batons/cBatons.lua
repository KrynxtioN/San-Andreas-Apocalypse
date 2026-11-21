PoliceBatons = {pickup = {}}

addEvent("PoliceBatons.createPickup",true)
addEventHandler("PoliceBatons.createPickup",root,function(id,x,y,z,int,dim)
	if(not(isElement(PoliceBatons.pickup[id])))then
		PoliceBatons.pickup[id] = createPickup(x,y,z,3,334,50)
		setElementInterior(PoliceBatons.pickup[id],int)
		setElementDimension(PoliceBatons.pickup[id],dim)
		setElementData(PoliceBatons.pickup[id],"PoliceBaton",id)
		
		addEventHandler("onClientPickupHit",PoliceBatons.pickup[id],function(player)
			if(player == localPlayer)then
				if(getElementDimension(player) == getElementDimension(source))then
					if(getElementInterior(player) == getElementInterior(source))then
						if(not(isPedInVehicle(player)))then
							local id = getElementData(source,"PoliceBaton")
							triggerServerEvent("givePoliceBaton",localPlayer,id)
							destroyElement(source)
						end
					end
				end
			end
		end)
	end
end)