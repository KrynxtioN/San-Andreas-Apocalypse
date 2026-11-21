Racegame = {Data = {}, Vehicle = {},
	["MapData"] = {
		[1] = {
			Vehicle = 522,
			Spawnpoint = {-974.81408691406,-386.10659790039,35.936698913574,346},
			["Marker"] = {
				{-955.98974609375,-295.86514282227,36.436683654785},
				{-826.92156982422,-120.76141357422,62.735740661621},
				{-669.14251708984,2.3755431175232,71.33683013916},
				{-828.28344726562,-37.070705413818,44.117340087891},
				{-823.97930908203,8.2059545516968,33.279346466064},
				{-666.74078369141,49.294254302979,32.129417419434},
				{-762.50506591797,120.98970794678,12.449666023254},
				{-714.21936035156,226.34446716309,2.2533495426178},
				{-632.82690429688,196.54908752441,13.006705284119},
				{-530.08636474609,84.666496276855,30.863405227661},
				{-506.68209838867,-42.67264175415,59.917205810547},
				{-513.07659912109,-167.72570800781,75.859024047852},
				{-446.59127807617,-184.5807800293,76.22834777832},
				{-351.49465942383,-112.33277893066,49.088054656982},
				{-395.74203491211,6.7752752304077,35.641075134277},
				{-289.59368896484,133.79556274414,2.8412940502167},
				{-400.31546020508,176.20024108887,4.9215950965881},
				{-472.63018798828,205.39953613281,7.3594913482666},
				{-608.00006103516,234.52166748047,19.86926651001},
				{-680.76318359375,181.99864196777,23.381092071533},
				{-626.05187988281,117.6589050293,35.865081787109},
				{-605.43402099609,41.377506256104,51.761268615723},
				{-623.00311279297,-48.651184082031,63.397598266602},
				{-518.49145507812,-86.800666809082,62.312931060791},
				{-509.67776489258,-177.2318572998,76.840454101562},
				{-645.66558837891,-171.10400390625,62.679851531982},
				{-791.48779296875,-182.71272277832,66.634635925293},
				{-863.02215576172,-130.37069702148,59.691856384277},
				{-978.56329345703,-379.55883789062,36.461803436279},
			},
		},
		[2] = {
			Vehicle = 522,
			Spawnpoint = {-2392.3591308594,-2203.9714355469,32.949401855469,294},
			["Marker"] = {
				{-2313.9633789062,-2168.8654785156,39.838687896729},
				{-2202.1755371094,-2084.0288085938,79.359580993652},
				{-2116.5131835938,-1944.0828857422,100.53614044189},
				{-2137.9838867188,-1936.1043701172,117.23428344727},
				{-2247.5966796875,-2068.4384765625,120.24514007568},
				{-2414.4614257812,-2094.0383300781,120.98569488525},
				{-2504.2392578125,-2008.6802978516,161.759765625},
				{-2646.7814941406,-1798.7135009766,231.84205627441},
				{-2604.4196777344,-1791.7846679688,262.32278442383},
				{-2524.2700195312,-1889.8435058594,294.71115112305},
				{-2558.7351074219,-1825.6918945312,314.44775390625},
				{-2600.6345214844,-1648.1478271484,340.77786254883},
				{-2585.1772460938,-1674.3665771484,352.32122802734},
				{-2535.4848632812,-1803.1010742188,375.71578979492},
				{-2560.3762207031,-1687.5618896484,394.85647583008},
				{-2527.3332519531,-1712.2996826172,402.28469848633},
				{-2460.4353027344,-1807.3615722656,407.76455688477},
				{-2457.978515625,-1725.4886474609,429.38558959961},
				{-2351.8522949219,-1816.5556640625,432.98678588867},
				{-2285.3483886719,-1706.4432373047,477.1477355957},
				{-2317.8879394531,-1638.7626953125,483.74499511719},
			},
		}
	},
	["Arena"] = {
		{-2109.8232421875,-445.77099609375,37.794401702881},
	},
}
local Count = 0

local Achievements = {
	{1,392},
	{5,393},
	{10,394},
	{25,395},
	{50,396},
	{100,397},
}

for i,v in pairs(Racegame["Arena"])do
	local marker = createMarker(v[1],v[2],v[3],"cylinder",1,255,0,0,125)
	apocalypseSetElementData(marker,"RacegameArena",i)
	
	addEventHandler("onMarkerHit",marker,function(player)
		if(apocalypseGetElementData(player,"RacegameArenaHitProtection") ~= true)then
			apocalypseSetElementData(player,"RacegameArena",apocalypseGetElementData(source,"RacegameArena"))
			triggerClientEvent(player,"Racegame.createWindow",player)
			apocalypseSetElementData(player,"RacegameArenaWindow",true)
		end
	end)
end

function Racegame.createGame()
	Count = Count + 1
	if(not(Racegame.Data[Count]))then
		Racegame.Data[Count] = {}
		Racegame.setData(Count)
	else
		Racegame.createGame()
	end
end

function Racegame.setData(ID)
	if(Racegame.Data[ID])then
		local Map = math.random(1,#Racegame["MapData"])
		Racegame.Data[Count] = {
			player = {},
			ID = Count,
			map = Map,
			money = 0,
			place = 0,
			join = true,
			started = false,
		}
	end
end
for i = 1,5 do Racegame.createGame() end

function Racegame.stopGame(ID)
	Racegame.Data[ID] = nil
	for _,v in pairs(getElementsByType("player"))do
		if(apocalypseGetElementData(v,"RacegameID") ~= nil)then
			if(apocalypseGetElementData(v,"RacegameID") == ID)then
				Racegame.removePlayer(v)
			end
		end
	end
	Racegame.updateForAll()
	Racegame.createGame()
end

function Racegame.addPlayer(player,ID)
	if(player and isElement(player) and ID)then
		if(Racegame.Data[ID])then
			if(Racegame.Data[ID].join == true)then
				local Vehicle = Racegame["MapData"][Racegame.Data[ID].map].Vehicle
				local Spawn = Racegame["MapData"][Racegame.Data[ID].map].Spawnpoint
				if(isElement(Racegame.Vehicle[player]))then
					destroyElement(Racegame.Vehicle[player])
				end
				Racegame.Vehicle[player] = createVehicle(Vehicle,Spawn[1],Spawn[2],Spawn[3],0,0,Spawn[4])
				setElementDimension(Racegame.Vehicle[player],ID)
				setElementInterior(player,0)
				setElementDimension(player,ID)
				warpPedIntoVehicle(player,Racegame.Vehicle[player])
				setElementFrozen(Racegame.Vehicle[player],true)
				table.insert(Racegame.Data[ID].player,player)
				triggerClientEvent(player,"Racegame.dxDrawInfo",player,#Racegame.Data[ID].player)
				for _,v in pairs(getElementsByType("player"))do
					if(isCharacterLoggedIn(v))then
						if(apocalypseGetElementData(v,"RacegameID") == ID)then
							triggerClientEvent(v,"Racegame.updatePlayerInLobby",v,#Racegame.Data[ID].player)
						end
					end
				end
				apocalypseSetElementData(player,"RacegameID",ID)
				apocalypseSetElementData(player,"RacegameMarkerID",0)
				Racegame.createMarker(player)
				apocalypseSetElementData(player,"RacegameArenaWindow",true)
				
				if(#Racegame.Data[ID].player >= 5)then
					for _,v in pairs(getElementsByType("player"))do
						if(isCharacterLoggedIn(v))then
							if(apocalypseGetElementData(v,"RacegameID") == ID)then
								triggerClientEvent(v,"Racegame.updateDxDrawInfo",v,getText(v,"SRaceArena4"))
							end
						end
					end
					Racegame.Data[ID].Timer = setTimer(function(ID)
						Racegame.Data[ID].join = false

						for _,v in pairs(getElementsByType("player"))do
							if(isCharacterLoggedIn(v))then
								if(apocalypseGetElementData(v,"RacegameID") == ID)then
									triggerClientEvent(v,"Racegame.updateDxDrawInfo",v,getText(v,"SRaceArena5"))
								end
							end
						end
						
						Racegame.Data[ID].Timer = setTimer(function(ID)
							Racegame.Data[ID].started = true
							for _,v in pairs(getElementsByType("player"))do
								if(apocalypseGetElementData(v,"RacegameID") ~= nil)then
									if(apocalypseGetElementData(v,"RacegameID") == ID)then
										if(isPedInVehicle(v))then
											local veh = getPedOccupiedVehicle(v)
											setElementFrozen(veh,false)
											setAchievement(v,285)
											triggerClientEvent(v,"Racegame.hideDxDrawInfo",v)
										end
									end
								end
							end
						end,5000,1,ID)
					end,30000,1,ID)
				end
				
				addEventHandler("onVehicleExit",Racegame.Vehicle[player],function(player)
					Racegame.removePlayer(player)
				end)
				Racegame.updateForAll()
			end
		end
	end
end
addEvent("Racegame.addPlayer",true)
addEventHandler("Racegame.addPlayer",root,Racegame.addPlayer)

function Racegame.createMarker(player)
	if(not(player))then player = client end
	if(apocalypseGetElementData(player,"RacegameID") ~= nil)then
		local ID = apocalypseGetElementData(player,"RacegameID")
		local MarkerID = apocalypseGetElementData(player,"RacegameMarkerID")
		MarkerID = MarkerID + 1
		apocalypseSetElementData(player,"RacegameMarkerID",MarkerID)
		if(MarkerID > #Racegame["MapData"][Racegame.Data[ID].map]["Marker"])then
			Racegame.Data[ID].place = Racegame.Data[ID].place + 1
			local tickets = 0
			if(Racegame.Data[ID].place == 1)then
				tickets = 10
				if(SERVERBONUS.RACE_ARENA == true)then
					tickets = 20
				end
			end
			if(Racegame.Data[ID].place == 2)then
				tickets = 5
				if(SERVERBONUS.RACE_ARENA == true)then
					tickets = 10
				end
			end
			if(Racegame.Data[ID].place == 3)then
				tickets = 3
				if(SERVERBONUS.RACE_ARENA == true)then
					tickets = 5
				end
			end
			createInfobox(player,(getText(player,"SRaceArena6"):format(Racegame.Data[ID].place)))
			giveItem(player,62,tickets)
			triggerClientEvent(client, "showItemBar", client, {{62,tickets}})
			giveEXP(player,tickets * 125)
			setAchievement(player,286)
			Racegame.removePlayer(player)
			local races_top3 = tonumber(getPlayerData("character_stats","character_id",getCharacterID(player),"races_top3"))
			Characters.addStats(player,"races_top3",races_top3 + 1)
			
			if(DailyTasks.playerTasks[player][27])then
				DailyTasks.updateProgress(player,27,DailyTasks.playerTasks[player][27].progress + 1)
			end
			if(WeeklyTasks.playerTasks[player][27])then
				WeeklyTasks.updateProgress(player,27,WeeklyTasks.playerTasks[player][27].progress + 1)
			end
			
			for _,v in pairs(Achievements)do
				if(races_top3 + 1 >= v[1])then
					setAchievement(player,v[2])
				end
			end
			outputLog(getPlayerName(player).." hat "..tickets.." Rennmarken bekommen", "Race Arena", getCharacterID(player))
		else
			local Spawn1 = Racegame["MapData"][Racegame.Data[ID].map]["Marker"][MarkerID]
			local Spawn2 = Racegame["MapData"][Racegame.Data[ID].map]["Marker"][MarkerID + 1]
			if(Spawn1 and Spawn2)then
				triggerClientEvent(player,"Racegame.createMarker",player,Spawn1[1],Spawn1[2],Spawn1[3],Spawn2[1],Spawn2[2],Spawn2[3])
			else
				triggerClientEvent(player,"Racegame.createMarker",player,Spawn1[1],Spawn1[2],Spawn1[3])
			end
		end
	end
end
addEvent("Racegame.createMarker",true)
addEventHandler("Racegame.createMarker",root,Racegame.createMarker)

function Racegame.removePlayer(player)
	if(apocalypseGetElementData(player,"RacegameID") ~= nil)then
		local ID = apocalypseGetElementData(player,"RacegameID")
		if(Racegame.Data[ID])then
			local GamePlayer = {}
			for _, v in pairs(Racegame.Data[ID].player)do
				if(v ~= player)then
					table.insert(GamePlayer,v)
				end
			end
			Racegame.Data[ID].player = GamePlayer
			apocalypseSetElementData(player,"RacegameID",nil)
			apocalypseSetElementData(player,"RacegameMarkerID",nil)
			if(isElement(Racegame.Vehicle[player]))then
				destroyElement(Racegame.Vehicle[player])
			end
			apocalypseSetElementData(player,"RacegameArenaHitProtection",true)
			triggerClientEvent(player,"Racegame.hideDxDrawInfo",player)
			
			for _,v in pairs(getElementsByType("player"))do
				if(isCharacterLoggedIn(v))then
					if(apocalypseGetElementData(v,"RacegameID") ==  ID)then
						triggerClientEvent(v,"Racegame.updatePlayerInLobby",v,#Racegame.Data[ID].player)
					end
				end
			end
			
			setTimer(function(player)
				if(isElement(player))then
					apocalypseSetElementData(player,"RacegameArenaHitProtection",false)
				end
			end,1000,1,player)
			
			if(not(isPedDead(player)))then
				setTimer(function(player)
					local RacegameArena = apocalypseGetElementData(player,"RacegameArena")
					local Spawn = Racegame["Arena"][RacegameArena]
					setElementPosition(player,Spawn[1],Spawn[2],Spawn[3]+1)
					setElementInterior(player,0)
					setElementDimension(player,0)
				end,100,1,player)
			end
			
			if(#Racegame.Data[ID].player < 2 and Racegame.Data[ID].started == true)then
				Racegame.stopGame(ID)
			end
			Racegame.updateForAll()
		end
	end
end

function Racegame.updateForAll()
	for _,v in pairs(getElementsByType("player"))do
		if(apocalypseGetElementData(v,"RacegameArenaWindow") ~= nil)then
			Racegame.updateRaces(v)
		end
	end
end

function Racegame.updateRaces(player)
	if(not(player))then player = client end
	triggerClientEvent(player,"Racegame.updateRaces",player,Racegame.Data)
end
addEvent("Racegame.updateRaces",true)
addEventHandler("Racegame.updateRaces",root,Racegame.updateRaces)

addEventHandler("onPlayerWasted",root,function()
	Racegame.removePlayer(source)
end)

addEventHandler("onPlayerQuit",root,function()
	Racegame.removePlayer(source)
end)