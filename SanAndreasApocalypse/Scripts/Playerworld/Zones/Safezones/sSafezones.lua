Safezone = {
	zone = {}, radarArea = {}, generator = {}, speaker = {}, Data = {},
	["ZoneCoordinate"] = {
		[1] = {646.20043945312, -481.20523071289, 90, 70,8},
		[2] = {1007.7327880859,-368.62664794922, 117, 85,9},
		[3] = {188.42663574219,-275.25430297852, 45, 65,19},
		[4] = {-2284.7866210938,2238.9458007812, 115, 250,15},
		[5] = {-2006.0650634766,77.402793884277,75,150,23},
		[6] = {-1388.3565673828,2024.9641113281,60,60,4},
		[7] = {-595.15661621094,-1505.8288574219,40,40,5},
		[8] = {703.51580810547,-1713.5173339844,50,50,6},
		[9] = {348.43841552734,-2090.1086425781,65,80,7},
		[10] = {-2139.5864257812,-2477.2946777344,100,100,3},
		[11] = {-293.07922363281,-2234.7380371094,50,105,10},
		[12] = {388.4365234375,2523.6677246094,60,60,11},
		[13] = {2129.5471191406,-2032.8095703125,80,90,12},
		[14] = {1831.3149414062,-1881.7351074219,50,60,13},
		[15] = {2298.5280761719,-23.157707214355,40,115,14},
		[16] = {1576.9068603516,660.28759765625,190,130,16},
		[17] = {-1649.6413574219,-2268.9990234375,50,50,17},
		[18] = {14.680819511414,-2671.0021972656,50,50,18},
		[19] = {1142.5756835938,112.82544708252, 150, 110,2},
		[20] = {-2129.6506347656,-477.60668945312, 50, 50, 20},
		[21] = {806.30700683594,-1134.6845703125, 150, 75, 21},
		[22] = {-2492.7136230469,-168.36926269531, 85, 85, 22},
		[23] = {-396.86309814453,943.56146240234, 600, 325,24},
		[24] = {326.93392944336,2519.0671386719, 120, 100,1},
		[25] = {462.107421875,-1573.3182373047,50,140},
	},
	["ZoneGenerator"] = {
		[1] = {718.73120117188, -446.16320800781, 15.871999740601, 0, 0, 90, 929},
		[2] = {1050.5, -316.20001220703, 74, 0, 0, 90, 929},
		[3] = {208.3950958252, -236.66540527344, 1.0628999471664, 0, 0, 0, 920},
		[4] = {-2192.1083984375, 2412.7763671875, 4.4670000076294, 0, 0, 314.24194335938, 920},
		[5] = {-1980.8287353516,110.15209960938,27.640899658203,0,0,0,929},
		[6] = {-1364.2758789062,2044.6982421875,52.000999450684,0,0,0,920},
		[7] = {-573.20092773438,-1483.52734375,9.9006004333496,0,0,36,920},
		[8] = {715.43798828125,-1690.8441162109,2.1954998970032,0,0,90,943},
		[9] = {394.00360107422,-2070.3754882812,7.7969999313354,0,0,0,929},
		[10] = {-2067.7326660156,-2446.5991210938,30.390800476074,0,0,51.25,943},
		[11] = {-253.44160461426,-2182.3786621094,28.856399536133,0,0,23.5,943},
		[12] = {431.42630004883,2539.0229492188,15.953499794006,0,0,90,943},
		[13] = {2199.2014160156,-1972.8697509766,13.323800086975,0,0,90,943},
		[14] = {1854.3117675781,-1860.5900878906,13.343899726868,0,0,90,943},
		[15] = {2314.5163574219,62.623401641846,26.246799468994,0,0,0,943},
		[16] = {1590.7054443359,693.86157226562,10.586099624634,0,0,0,943},
		[17] = {-1639.3225097656,-2234.1743164062,30.961399078369,0,0,270,920},
		[18] = {38.389301300049,-2634.2778320312,40.17259979248,0,0,1.25,943},
		[19] = {1256.9754638672,183.62249755859,19.149099349976,0,0,14,920},
		[20] = {-2119.6437988281,-437.99841308594,35.016101837158,0,0,0,920},
		[21] = {823.27667236328,-1115.0622558594,23.766399383545,0,0,0,943},
		[22] = {-2455.3837890625,-114.64669799805,26.037900924683,0,0,0,929},
		[23] = {-212.58410644531,1214.8082275391,19.851699829102,0,0,0,929},
		[24] = {337.09979248047,2535.3354492188,16.763000488281,0,0,0,929},
		[25] = {495.00531005859,-1525.2890625,19.820999145508,3.33544921875,360,14.024108886719,929},
	},
}

function isPointInRectangle(px, py, zonex, zoney, zonewidth, zoneheight)
	return px >= zonex and px <= zonex + zonewidth and py >= zoney and py <= zoney + zoneheight
end

function isPlayerInSafeZone(player)
	local x,y,z = getElementPosition(player)
	local status = false
	for _,v in pairs(Safezone["ZoneCoordinate"])do
		if(isPointInRectangle(x,y,v[1],v[2],v[3],v[4]))then
			status = true
		end
	end
	return status
end

function getWorkingGenerators()
	local generator_working = 0
	for _,v in pairs(Safezone.Data)do
		if(v.status >= 1 and v.fuel >= 1 and v.oil >= 1)then
			generator_working = generator_working + 1
		end
	end
	return generator_working
end

function showPlayerSafezones(player)
	for i,v in pairs(Safezone["ZoneCoordinate"])do
		if(v[5])then
			if(hasPlayerDiscoveredPlace(player,v[5]) == true)then
				setElementVisibleTo(Safezone.radarArea[i],player,true)
			end
		else
			setElementVisibleTo(Safezone.radarArea[i],player,true)
		end
	end
end

function Safezone.createEverything()
	for i, v in ipairs(Safezone["ZoneCoordinate"])do
		if(not(v[6]))then
			Safezone.zone[i] = createColRectangle(v[1], v[2], v[3], v[4])
			Safezone.radarArea[i] = createRadarArea(v[1], v[2], v[3], v[4], 0, 255, 0 , 150, root)
			apocalypseSetElementData(Safezone.zone[i], "SafezoneID", i)
			apocalypseSetElementData(Safezone.zone[i], "Generator", "notBroke")
			setElementVisibleTo(Safezone.radarArea[i],root,false)
			
			addEventHandler("onColShapeHit", Safezone.zone[i], function(hitElement)
				apocalypseSetElementData(hitElement, "inSafezone",true)
				if(apocalypseGetElementData(hitElement, "zombie") == true)then
					if(apocalypseGetElementData(source, "Generator") == "notBroke")then
						killPed(hitElement)
					end
				end
			end)
			
			addEventHandler("onColShapeLeave", Safezone.zone[i], function(hitElement)
				if(getElementType(hitElement) == "player")then
					apocalypseSetElementData(hitElement,"inSafezone",false)
					if(tonumber(apocalypseGetElementData(hitElement,"level")) <= 10)then
						NPC.MeMessage(hitElement,getText(hitElement,"MeMessage5"))
					end
				end
			end)
		end
	end
	
	for i, v in ipairs(Safezone["ZoneGenerator"])do
		if(not(v[6]))then
			Safezone.generator[i] = createObject(v[7], v[1], v[2], v[3], v[4], v[5], v[6])
			apocalypseSetElementData(Safezone.generator[i], "SafezoneID", i)
			
			Safezone.Data[i] = {
				id = i,
				status = getPlayerData("generators", "generatorID", i, "status"),
				fuel = getPlayerData("generators", "generatorID", i, "fuel"),
				oil = getPlayerData("generators", "generatorID", i, "oil"),
				generator = {v[1], v[2], v[3]},
			}
			
			if(Safezone.Data[i].status == 0 or Safezone.Data[i].fuel == 0 or Safezone.Data[i].oil == 0)then
				if(Safezone.radarArea[i])then
					setRadarAreaFlashing(Safezone.radarArea[i], true)
					setRadarAreaColor(Safezone.radarArea[i], 255, 0, 0, 150)
				end
			end
		end
	end
end
Safezone.createEverything()

setTimer(function()
	if(loggedInPlayers() >= 1)then
		for _, v in pairs(Safezone.Data)do
			if(v.id ~= 1)then
				if(apocalypseGetElementData(Safezone.zone[v.id], "Generator") == "notBroke")then
					if(math.random(1, 3) == 1)then
						if(v.fuel > 0)then
							v.fuel = v.fuel - 1
						end
					end
					
					if(math.random(1, 3) == 2)then
						if(v.oil > 0)then
							v.oil = v.oil - 1
						end
					end
					
					if(math.random(1, 5) == 3)then
						if(v.status > 0)then
							v.status = v.status - 1
						end
					end
				end
			end
			if(v.status == 0 or v.fuel == 0 or v.oil == 0)then
				apocalypseSetElementData(Safezone.zone[v.id], "Generator", "broke")
				if(isElement(Safezone.radarArea[v.id]))then
					setRadarAreaFlashing(Safezone.radarArea[v.id], true)
					setRadarAreaColor(Safezone.radarArea[v.id], 255, 0, 0, 150)
				end
			end
			dbExec(handler, "UPDATE generators SET status = '"..v.status.."', fuel = '"..v.fuel.."', oil = '"..v.oil.."' WHERE generatorID = '"..v.id.."'")
		end
		
		for _, v in pairs(getElementsByType("player"))do
			if(isCharacterLoggedIn(v))then
				Safezone.sendDataToClient(v)
			end
		end
	end
end, 60000, 0)

addEventHandler("onPlayerClick", root, function(button, state, clickedElement)
	if(button == "left" and state == "down" and clickedElement)then
		if(isElement(clickedElement))then
			local ID = tonumber(apocalypseGetElementData(clickedElement, "SafezoneID"))
			local x, y, z = getElementPosition(clickedElement)
			if(ID)then
				if(getDistanceBetweenPoints3D(x, y, z, getElementPosition(source)) <= 5)then
					apocalypseSetElementData(source, "GeneratorID", ID)
					triggerClientEvent(source, "Safezone.openGeneratorWindow", source, ID)
				end
			end
		end
	end
end)

addEvent("generatorAdd", true)
addEventHandler("generatorAdd", root, function (paramType)
	local generatorID = apocalypseGetElementData(client, "GeneratorID")
	if(generatorID)then
		local Level_Bonus_EXP = tonumber(apocalypseGetElementData(client,"level"))
		if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
		local EXP = 75 + (Level_Bonus_EXP * 15)
		if(paramType == "fuel")then
			if(Safezone.Data[generatorID].fuel < 100)then
				if(hasPlayerItem(client, 6) >= 1)then
					Safezone.Data[generatorID].fuel = Safezone.Data[generatorID].fuel + 5
					if(Safezone.Data[generatorID].fuel > 100)then
						Safezone.Data[generatorID].fuel = 100
					end
					takeItem(client, 6, 1)
					createInfobox(client,getText(client,"SSafezone4"))
					giveEXP(client,EXP)
				else createInfobox(client,getText(client,"SSafezone6"))end
			else createInfobox(client,getText(client, "SSafezone1"))end
		elseif(paramType == "oil")then
			if(Safezone.Data[generatorID].oil < 100)then
				if(hasPlayerItem(client, 7) >= 1)then
					Safezone.Data[generatorID].oil = Safezone.Data[generatorID].oil + 5
					if(Safezone.Data[generatorID].oil > 100)then
						Safezone.Data[generatorID].oil = 100
					end
					takeItem(client, 7, 1)
					createInfobox(client,getText(client,"SSafezone4"))
					giveEXP(client,EXP)
				else createInfobox(client,getText(client,"SSafezone7"))end
			else createInfobox(client,getText(client, "SSafezone1"))end
		elseif(paramType == "repair")then
			if(Safezone.Data[generatorID].status < 100)then
				if(hasPlayerItem(client, 8) >= 1)then
					Safezone.Data[generatorID].status = Safezone.Data[generatorID].status + 25
					if(Safezone.Data[generatorID].status > 100)then
						Safezone.Data[generatorID].status = 100
					end
					takeItem(client, 8, 1)
					createInfobox(client,getText(client,"SSafezone5"))
					giveEXP(client,EXP)
				else createInfobox(client,getText(client,"SSafezone8"))end
			else createInfobox(client,getText(client, "SSafezone1"))end
		end
		if(Safezone.Data[generatorID].fuel > 0 and Safezone.Data[generatorID].oil > 0 and Safezone.Data[generatorID].status > 0)then
			apocalypseSetElementData(Safezone.zone[generatorID], "Generator", "notBroke")
			setRadarAreaFlashing(Safezone.radarArea[generatorID], false)
			setRadarAreaColor(Safezone.radarArea[generatorID], 0, 255, 0, 150)
		end
		Safezone.sendDataToClient(client)
	end
end)

function Safezone.resetArea(id)
	setRadarAreaFlashing(Safezone.radarArea[id], false)
	setRadarAreaColor(Safezone.radarArea[id], 0, 255, 0, 150)
	Safezone.Data[id].percent = 100
	Safezone.Data[id].status = true
end

function Safezone.sendDataToClient(player)
	if(not(player))then player = client end
	local data = {}
	if(#Safezone.Data >= 1)then
		for _, v in pairs(Safezone.Data)do
			table.insert(data, {v.id, v.status, v.fuel, v.oil, v.generator})
		end
		triggerClientEvent(player, "Safezone.updateClient", player, data)
		triggerClientEvent(player, "updateGeneratorInfos", player)
	end
end
addEvent("Safezone.sendDataToClient",true)
addEventHandler("Safezone.sendDataToClient",root,Safezone.sendDataToClient)