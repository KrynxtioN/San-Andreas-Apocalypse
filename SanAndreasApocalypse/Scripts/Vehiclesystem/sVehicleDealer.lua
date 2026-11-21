VehicleDealer = {Peds = {}, peds_amount = 0, Marker = {}, Pickup = {},
	["PossibleVehicles"] = {415,418,419,422,424,429,434,457,474,478,482},
	["Spawns"] = {
		{1732.9458007812,-1378.4842529297,13.578100204468,132.00375366211},
		{2442.2043457031,-1694.3319091797,13.804699897766,0},
		{2522.5849609375,-1475.3173828125,23.988399505615,44.003662109375},
		{2209.3276367188,-1144.6988525391,25.795700073242,0},
		{1403.8342285156,-1301.8874511719,13.553700447083,0},
		{1083.1640625,-1188.5327148438,18.314399719238,0},
		{955.39562988281,-1586.7165527344,13.546899795532,36.002746582031,180},
		{1643.0975341797,-1848.6488037109,13.54109954834,0},
		{1989.5687255859,-2013.5302734375,13.546899795532,0},
		{2353.3039550781,-1481.3145751953,24,40.004577636719},
		{2396.2006835938,-1208.7486572266,28.138700485229,0.00274658203125},
		{2051.8173828125,-1054.1092529297,25.836500167847,0},
		{1449.5849609375,-917.84228515625,37.343601226807,0},
		{1104.3768310547,-992.41772460938,42.765598297119,168.00256347656},
		{900.705078125,-898.1455078125,45.765598297119,0},
		{831.01690673828,-1069.0612792969,25.121900558472,0},
		{582.89093017578,-1428.6636962891,13.984100341797,0},
		{763.0537109375,-1663.7960205078,4.1985998153687,0.00274658203125},
		{670.75628662109,-1861.2098388672,5.4608998298645,0},
		{901.46887207031,-1821.1744384766,12.359600067139,272.00088500977},
		{-1891.8341064453,-962.06909179688,31.968799591064,0.00274658203125},
		{-2007.0767822266,-398.61370849609,35.531200408936,0.00274658203125},
		{-2155.7141113281,-109.58080291748,35.320301055908,316.00183105469},
		{-2450.9362792969,-101.67369842529,31.1875,0},
		{-2690.0473632812,-86.988998413086,4.3358998298645,0.00274658203125},
		{-2657.4306640625,228.40480041504,4.3358998298645,0},
		{-2793.5632324219,430.60949707031,4.5053000450134,344.00091552734},
		{-2514.8156738281,758.83758544922,35.171901702881,0},
		{-1863.625,1047.6402587891,46.085899353027,87.998626708984},
		{-2442.966796875,1027.9354248047,50.390598297119,0},
		{-1739.8193359375,1232.625,7.5468997955322,0.00274658203125},
		{-1633.4545898438,1392.8546142578,7.1875,0},
		{-2662.9816894531,1458.1185302734,7.1105999946594,0},
		{-2915.2724609375,1003.1142578125,36.695301055908,0},
		{-2768.5107421875,770.83129882812,52.74340057373,0},
		{-2540.5979003906,204.55290222168,11.093799591064,0},
		{-1960.0620117188,-866.79382324219,32.226600646973,0},
		{-1546.1202392578,-444.67199707031,6.0223999023438,90.004119873047},
		{-1702.5373535156,-32.530700683594,3.5546998977661,0},
		{-1535.4647216797,571.07800292969,7.1796998977661,36.002746582031},
		{1351.0710449219,932.03747558594,10.556799888611,0},
		{1527.0610351562,767.26989746094,11.031000137329,0},
		{2242.1962890625,593.3916015625,7.7811999320984,272.00143432617},
		{2526.1318359375,723.9951171875,11.023400306702,0.00274658203125},
		{2716.6806640625,874.02734375,10.898400306702,87.998626708984},
		{2555.1518554688,1182.5379638672,10.822199821472,0},
		{2237.80859375,1275.3916015625,10.820300102234,0},
		{2121.2126464844,1612.3488769531,11.046899795532,0},
		{2085.0524902344,2096.3820800781,11.054699897766,0},
		{1705.9501953125,2235.6467285156,11.0625,0},
		{1395.9052734375,2222.4853515625,11.023400306702,0},
		{1029.7275390625,2095.5617675781,10.820300102234,0},
		{700.36920166016,1979.0526123047,4.9375,0},
		{265.31399536133,1468.1215820312,10.585900306702,0},
		{2539.8134765625,1797.5330810547,11.023400306702,0},
		{2614.3835449219,2076.0153808594,10.812999725342,0},
		{2796.6767578125,2529.58203125,11.0625,94.002716064453},
		{2289.5095214844,2783.8901367188,10.820300102234,0},
		{1938.1004638672,2725.2849121094,10.820300102234,0},
		{1429.7447509766,2739.7153320312,10.820300102234,0},
	},
}

local function getSpawn()
	local rnd = math.random(1,#VehicleDealer["Spawns"])
	local tbl = VehicleDealer["Spawns"][rnd]
	return {rnd,tbl[1],tbl[2],tbl[3],tbl[4]}
end

function VehicleDealer.createDealer()
	if(VehicleDealer.peds_amount < #VehicleDealer["Spawns"])then
		local spawn = getSpawn()
		local ID = spawn[1]
		local ModelID = VehicleDealer["PossibleVehicles"][math.random(1,#VehicleDealer["PossibleVehicles"])]

		local tries = 0
		repeat
		  tries = tries + 1
		  local spawn = getSpawn()
		  ID = spawn[1]
		until (not isElement(VehicleDealer.Peds[ID])) or tries >= 50
		if tries >= 50 then return end
		
		VehicleDealer.Peds[ID] = createPed(0,spawn[2],spawn[3],spawn[4],spawn[5])
		apocalypseSetElementData(VehicleDealer.Peds[ID],"ModelID",ModelID)
		VehicleDealer.peds_amount = VehicleDealer.peds_amount + 1
		VehicleDealer.Pickup[ID] = createPickup(spawn[2],spawn[3],spawn[4] + 1.5,3,2481,50)
			
		VehicleDealer.Marker[ID] = createMarker(spawn[2],spawn[3],spawn[4], "cylinder", 2.5, 0, 0, 0, 0)
		apocalypseSetElementData(VehicleDealer.Marker[ID],"VehicleDealerID",ID)
		apocalypseSetElementData(VehicleDealer.Marker[ID],"ModelID",ModelID)
		setElementFrozen(VehicleDealer.Peds[ID],true)
			
		addEventHandler("onMarkerHit",VehicleDealer.Marker[ID],function(player)
			if(getElementType(player) == "player")then
				if(not(isPedInVehicle(player)))then
					if(getElementInterior(player) == getElementInterior(source))then
						if(getElementDimension(player) == getElementDimension(source))then
							triggerClientEvent(player,"createActivitiesInformationText",player,getText(player,"SWeaponDealer1"))
							bindKey(player,"e","down",VehicleDealer.createWindow)
						end
					end
				end
			end
		end)
		
		addEventHandler("onMarkerLeave",VehicleDealer.Marker[ID],function(player)
			if(getElementType(player) == "player")then
				unbindKey(player,"e","down",VehicleDealer.createWindow)
			end
		end)
	end
end
VehicleDealer.createDealer()

setTimer(VehicleDealer.createDealer,1800000,0)

function VehicleDealer.createWindow(player)
	local marker = false
	for _,v in pairs(VehicleDealer.Marker)do
		if(apocalypseGetElementData(v,"VehicleDealerID"))then
			if(isElementWithinMarker(player,v))then
				apocalypseSetElementData(player,"VehicleDealerID",apocalypseGetElementData(v,"VehicleDealerID"))
				marker = v
				break
			end
		end
	end
	if(marker ~= false)then
		local ModelID = apocalypseGetElementData(marker,"ModelID")
		local VehicleDealerID = apocalypseGetElementData(marker,"VehicleDealerID")
		triggerClientEvent(player,"Vehicleshop.openSpecialWindow",player,ModelID)
		unbindKey(player,"e","down",VehicleDealer.createWindow)
	end
end

function VehicleDealer.destroyPed(ID)
	if(isElement(VehicleDealer.Peds[ID]))then
		destroyElement(VehicleDealer.Peds[ID])
		destroyElement(VehicleDealer.Marker[ID])
		destroyElement(VehicleDealer.Pickup[ID])
		VehicleDealer.Peds[ID] = nil
		VehicleDealer.Marker[ID] = nil
		VehicleDealer.Pickup[ID] = nil
		VehicleDealer.peds_amount = VehicleDealer.peds_amount - 1
	end
end

addEvent("VehicleDealer.showPositions",true)
addEventHandler("VehicleDealer.showPositions",root,function()
	if(tonumber(apocalypseGetElementData(client,"money")) >= 5000)then
		if(VehicleDealer.peds_amount >= 1)then
			apocalypseSetElementData(client,"money",tonumber(apocalypseGetElementData(client,"money")) - 5000)
			for _,v in pairs(VehicleDealer.Peds)do
				if(isElement(v))then
					local x,y,z = getElementPosition(v)
					triggerClientEvent(client,"VehicleDealer.createBlip",client,x,y,z)
				end
			end
			NPC.NormalMessage(client,getText(client,"SVehicleDealer3"))
		else
			NPC.NormalMessage(client,getText(client,"SVehicleDealer2"))
		end
	else
		NPC.NormalMessage(client,getText(client,"SVehicleDealer1"))
	end
end)

addEventHandler("onPlayerWasted",root,function()
	unbindKey(source,"e","down",VehicleDealer.createWindow)
end)