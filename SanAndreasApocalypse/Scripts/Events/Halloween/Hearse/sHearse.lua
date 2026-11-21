HalloweenHearse = {Vehicles = {}, RespawnTimer = {},
	["VehicleSpawnPositions"] = {
		{1337.4295654297,-1293.9632568359,13.496700286865,0},
		{2076.9970703125,-1206.970703125,23.895000457764,0},
		{1559.8125,-1028.9638671875,23.856100082397,343.24584960938},
		{1487.037109375,-1056.0576171875,23.775699615479,0},
		{1048.8675537109,-1346.1008300781,13.332699775696,0},
		{1826.3768310547,-1855.0974121094,13.363900184631,0},
		{912.501953125,-1432.2861328125,13.249799728394,0},
		{1066.7451171875,-1872.509765625,13.496700286865,0},
		{1438.083984375,-2348.1953125,13.496700286865,0},
		{1638.314453125,-1454.3458251953,13.496700286865,0},
		{1662.982421875,-1577.28515625,13.496700286865,0},
		{1709.3955078125,-1321.0147705078,13.496700286865,0},
		{1861.8533935547,-1157.5241699219,23.811800003052,0},
		{1813.947265625,-1275.5068359375,13.630800247192,0},
		{2265.9899902344,-1334.9409179688,23.77799987793,180},
		{2012.8623046875,-1048.5712890625,24.615999221802,180},
		{2349.9091796875,-1219.189453125,22.449899673462,180},
		{2076.5402832031,-1824.2922363281,13.496700286865,180},
		{2180.0947265625,-1765.6455078125,13.497500419617,180},
		{2065.6838378906,-1905.1021728516,13.496700286865,180},
		{1776.3978271484,-1888.0875244141,13.336500167847,180},
		{1947.9609375,-1869.4892578125,13.511799812317,180},
		{1694.6171875,-1778.48828125,13.496700286865,180},
		{1144.7124023438,-1694.1551513672,13.90299987793,180},
		{1245.0166015625,-2011.1064453125,59.798000335693,180},
		{1190.3883056641,-1315.8679199219,13.348299980164,180},
		{524.65002441406,-1546.8162841797,15.324299812317,180},
		{1337.7705078125,-1256.142578125,13.332699775696,180},
		{1721.802734375,-1126.224609375,24.035800933838,180},
		{495.115234375,-1267.4462890625,15.913200378418,180},
		{644.28948974609,-1650.0565185547,14.859600067139,180},
		{882.86981201172,-1589.6153564453,13.496700286865,0},
		{922.35778808594,-1743.107421875,13.331199645996,0},
		{893.466796875,-1669.125,13.496700286865,0},
		{321.30551147461,-1808.4560546875,4.4467000961304,0},
		{356.90219116211,-1808.8967285156,4.4946999549866,0},
		{1279.2492675781,190.93460083008,19.729999542236,182},
		{-109.3603515625,-1175.912109375,2.8405001163483,0},
		{673.34765625,-710.4482421875,16.212799072266,343.99841308594},
		{611.9248046875,-596.814453125,17.182899475098,270},
		{1012.1563110352,-335.1904296875,73.942100524902,213.99719238281},
		{1254.22265625,-402.7548828125,2.5327000617981,181.99951171875},
		{1372.7447509766,474.76080322266,20.032600402832,155.99945068359},
		{1350.345703125,373.6572265625,19.504600524902,155.99487304688},
		{1001.446105957,451.09451293945,19.951099395752,153.99487304688},
		{41.19921875,-232.52734375,1.7194000482559,289.98986816406},
		{818.53125,347.9130859375,19.905599594116,153.98986816406},
		{40.34375,-225.6513671875,1.7534999847412,203.98864746094},
		{-85.890296936035,-390.49359130859,1.3796000480652,0},
		{5.3134765625,-702.5927734375,5.5106000900269,338},
	},
}

function HalloweenHearse.loadVehicles()
	for i,v in ipairs(HalloweenHearse["VehicleSpawnPositions"])do
		if(not(isElement(HalloweenHearse.Vehicles[i])))then
			HalloweenHearse.Vehicles[i] = createVehicle(442,v[1],v[2],v[3],0,0,v[4])
			apocalypseSetElementData(HalloweenHearse.Vehicles[i],"HalloweenHearseID",i)
			setVehicleColor(HalloweenHearse.Vehicles[i],0,0,0)
			
			addEventHandler("onVehicleEnter",HalloweenHearse.Vehicles[i],function(player)
				if(getPedOccupiedVehicleSeat(player) == 0)then
					triggerClientEvent(player,"HalloweenHearse.createDelivery",player)
					createInfobox(player,getText(player,"SHalloweenHearse2"))
					triggerClientEvent(player,"SkeletonTaxiDriver.start",player)
				end
				
				if(isTimer(HalloweenHearse.RespawnTimer[source]))then
					killTimer(HalloweenHearse.RespawnTimer[source])
				end
			end)
			
			addEventHandler("onVehicleExit",HalloweenHearse.Vehicles[i],function(player)
				triggerClientEvent(player,"HalloweenHearse.destroyDelivery",player)
				triggerClientEvent(player,"SkeletonTaxiDriver.reset",player)
				
				if(#getVehicleOccupants(source) < 1)then
					if(isTimer(HalloweenHearse.RespawnTimer[source]))then
						killTimer(HalloweenHearse.RespawnTimer[source])
					end
					
					HalloweenHearse.RespawnTimer[source] = setTimer(function(vehicle)
						respawnVehicle(source)
					end,180000,1,source)
				end
			end)
			
			addEventHandler("onVehicleExplode",HalloweenHearse.Vehicles[i],function()
				if(isTimer(HalloweenHearse.RespawnTimer[source]))then
					killTimer(HalloweenHearse.RespawnTimer[source])
				end
			end)
		end
	end
end

if(HalloweenEvent == true)then 
	HalloweenHearse.loadVehicles()
	setTimer(HalloweenHearse.loadVehicles,3600000,0)
end

addEvent("HalloweenHearse.ServerDelivery",true)
addEventHandler("HalloweenHearse.ServerDelivery",root,function()
	if(isPedInVehicle(client))then
		local Vehicle = getPedOccupiedVehicle(client)
		if(getPedOccupiedVehicleSeat(client) == 0)then
			if(apocalypseGetElementData(Vehicle,"HalloweenHearseID"))then
				local ID = tonumber(apocalypseGetElementData(Vehicle,"HalloweenHearseID"))
				destroyElement(HalloweenHearse.Vehicles[ID])
				HalloweenHearse.Vehicles[ID] = nil
				triggerClientEvent(client,"HalloweenHearse.destroyDelivery",client)
				giveHalloweenPumpkin(client,25)
				giveEXP(client,500)
				createInfobox(client,getText(client,"SHalloweenHearse1"))
				local hearse_delivered = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"hearse_delivered"))
				Characters.addStats(client,"hearse_delivered",hearse_delivered+1)
				
				outputLog(getPlayerName(client).." hat einen Leichenwagen abgegeben und 500 EXP und 25 Kürbisse erhalten","Halloween Event",getCharacterID(client))
			end
		end
	end
end)

addEventHandler("onPlayerWasted",root,function()
	triggerClientEvent(source,"HalloweenHearse.destroyDelivery",source)
end)