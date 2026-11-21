UndergroundGarage = {
	["Marker"] = {
		{1515.9132080078,-1477.0419921875,9.5,1523.9571533203,-1464.0750732422,9.5,180},
		{-2434.072265625,2313.8410644531,4.984375,-2430.7919921875,2321.1003417969,4.9893999099731,0},
		{1477.0548095703,2363.7768554688,10.8203125,1476.6755371094,2372.6652832031,10.820300102234,0},
		{1067.7470703125,1911.2902832031,10.8203125,1067.7944335938,1920.5872802734,10.820300102234,0},
		{-693.92938232422,965.82287597656,12.243006706238,-704.13397216797,965.85717773438,12.417300224304,90},
		{-2437.4418945312,1028.6865234375,50.390625,-2437.0764160156,1037.1041259766,50.390598297119,270},
		{-1890.8206787109,-201.25761413574,14.306200027466,-1870.0277099609,-201.41319274902,18.398399353027,270},
		{2536.9904785156,-1492.4350585938,24.0390625,2534.0102539062,-1502.9304199219,23.828100204468,112},
		{1751.5814208984,-2053.9841308594,14.123248100281,1751.5617675781,-2063.9296875,13.624300003052,180},
		{254.50273132324,29.754568099976,2.4503126144409,242.29130554199,29.607099533081,2.5780999660492,80},
		{1655.2290039062,-1862.1872558594,13.550939559937,1653.712890625,-1871.2712402344,13.382800102234,100},
	},

	["Pickup"] = {},
	["TeleportIn"] = {},
	["TeleportOut"] = {},
	["ActiveClientPickups"] = {}
}

function UndergroundGarage.syncPickup(ID)
	if(isElement(UndergroundGarage["Pickup"][ID]))then
		UndergroundGarage["ActiveClientPickups"][ID] = UndergroundGarage["Pickup"][ID]
		triggerClientEvent(root,"UndergroundGarage:syncPickup",resourceRoot,ID,UndergroundGarage["Pickup"][ID])
	end
end

function UndergroundGarage.requestSync(player)
	triggerClientEvent(player,"UndergroundGarage:fullSync",player,UndergroundGarage["ActiveClientPickups"])
end

if(#UndergroundGarage["Marker"] >= 1)then
	for i,v in ipairs(UndergroundGarage["Marker"])do
		local Object = createObject(7245,-2267.6166992188,1833.9609375,154.76930236816,0,0,0)
		local Gate = createObject(980,-2293.9865722656,1836.1103515625,157.74969482422,0,0,270)
		setElementDimension(Object,i)
		setElementDimension(Gate,i)

		UndergroundGarage["Pickup"][i] = createPickup(v[1],v[2],v[3],3,1318,50)
		apocalypseSetElementData(UndergroundGarage["Pickup"][i],"UndergroundGarageID",i)

		UndergroundGarage["TeleportIn"][i] = createMarker(v[1],v[2],v[3],"cylinder",3,255,255,255,0)
		apocalypseSetElementData(UndergroundGarage["TeleportIn"][i],"UndergroundGarageID",i)

		UndergroundGarage["TeleportOut"][i] = createMarker(-2286.7983398438,1837.2941894531,152.45449829102,"cylinder",5,255,255,255,125)
		setElementDimension(UndergroundGarage["TeleportOut"][i],i)
		apocalypseSetElementData(UndergroundGarage["TeleportOut"][i],"UndergroundGarageID",i)

		UndergroundGarage.syncPickup(i)

		addEventHandler("onMarkerHit",UndergroundGarage["TeleportIn"][i],function(element)
			local ID = apocalypseGetElementData(source,"UndergroundGarageID")

			if(getElementType(element) == "player")then
				if(getElementDimension(element) == getElementDimension(source))then
					setElementPosition(element,-2278.2673339844,1831.9000244141,152.27709960938)
					setPedRotation(element,270)
					setElementDimension(element,ID)
				end
			elseif(getElementType(element) == "vehicle")then
				local driver = getVehicleOccupant(element,0)
				if not driver then return end

				if(getElementDimension(element) == getElementDimension(source))then
					setElementPosition(element,-2271.7355957031,1837.2740478516,152.28410339355)
					setElementRotation(element,0,0,270)
					setElementDimension(element,ID)
				end
			end
		end)

		addEventHandler("onMarkerHit",UndergroundGarage["TeleportOut"][i],function(element)
			local ID = apocalypseGetElementData(source,"UndergroundGarageID")
			local x,y,z,rz = UndergroundGarage["Marker"][ID][4],UndergroundGarage["Marker"][ID][5],UndergroundGarage["Marker"][ID][6],UndergroundGarage["Marker"][ID][7]

			if(getElementType(element) == "player")then
				if(getElementDimension(element) == getElementDimension(source))then
					setElementPosition(element,x,y,z)
					setPedRotation(element,rz)
					setElementDimension(element,0)
				end
			elseif(getElementType(element) == "vehicle")then
				local driver = getVehicleOccupant(element,0)
				if not driver then return end

				if(getElementDimension(element) == getElementDimension(source))then
					setElementPosition(element,x,y,z)
					setElementRotation(element,0,0,rz)
					setElementDimension(element,0)
				end
			end
		end)
	end
end