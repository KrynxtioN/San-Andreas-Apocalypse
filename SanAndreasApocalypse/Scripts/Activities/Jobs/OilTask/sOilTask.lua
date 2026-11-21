OilTask = {PlayerData = {}, playerVehicle = {},
	["PossibleDeliveryPositions"] = {
		[1] = {
			Costs = 725,
			DeliveryPoint = {-154.26930236816,1111.1391601562,18.792200088501},
		},
		[2] = {
			Costs = 725,
			DeliveryPoint = {2250.2631835938,-84.774597167969,25.537700653076},
		},
		[3] = {
			Costs = 725,
			DeliveryPoint = {-1837.1136474609,-171.93051147461,9.2011976242065},
		},
		[4] = {
			Costs = 725,
			DeliveryPoint = {-2167.2492675781,43.072452545166,35.171875},
		},
	},
}

local Achievements = {
	{1,359},
	{5,360},
	{10,361},
	{25,362},
	{50,363},
	{75,364},
	{125,365},
	{175,366},
	{250,367},
}

OilTask.vehiclePickup = createPickup(886.60601806641,-18.285762786865,63.352882385254,3,1239,50)

addEventHandler("onPickupHit",OilTask.vehiclePickup,function(player)
	if(getElementType(player) == "player")then
		if(not(isPedInVehicle(player)))then
			if(getElementDimension(player) == getElementDimension(source))then
				if(OilTask.PlayerData[player])then
					if(not(apocalypseGetElementData(player,"OilTaskBindKey")))then
						bindKey(player,"e","down",OilTask.bindKey)
						apocalypseSetElementData(player,"OilTaskBindKey",true)
					end
					createInfobox(player,getText(player,"SOilTask4"))
				else
					NPC.MeMessage(player,getText(player,"SOilTask5"))
				end
			end
		end
	end
end)

function OilTask.startDelivery(player)
	if(not(player))then player = client end
	if(not(OilTask.PlayerData[player]))then
		local DeliveryID = math.random(1,#Camps["DeliveryPoints"])
		local Costs = 725
		if(tonumber(apocalypseGetElementData(player,"money")) >= Costs)then
			OilTask.PlayerData[player] = {
				DeliveryID = DeliveryID,
				Phase = 0,
				Costs = Costs,
				DeliverySpawn = {Camps["DeliveryPoints"][DeliveryID][1],Camps["DeliveryPoints"][DeliveryID][2],Camps["DeliveryPoints"][DeliveryID][3]},
			}
			NPC.NormalMessage(player,getText(player,"SOilTask2"))
			apocalypseSetElementData(player,"money",apocalypseGetElementData(player,"money")-Costs)
			triggerClientEvent(player,"closeWindow",player)
		else
			NPC.NormalMessage(player,getText(player,"SOilTask3"):format(Costs))
		end
	else
		NPC.MeMessage(player,getText(player,"SOilTask1"))
	end
end
addEvent("OilTask.startDelivery",true)
addEventHandler("OilTask.startDelivery",root,OilTask.startDelivery)

function OilTask.bindKey(player)
	if(OilTask.PlayerData[player])then
		if(not(isElement(OilTask.playerVehicle[player])))then
			unbindKey(player,"e","down",OilTask.bindKey)
			apocalypseSetElementData(player,"OilTaskBindKey",nil)
		
			OilTask.playerVehicle[player] = createVehicle(478,888.71551513672,-24.882099151611,63.313201904297,0,0,155)
			warpPedIntoVehicle(player,OilTask.playerVehicle[player])
			apocalypseSetElementData(OilTask.playerVehicle[player],"Owner",getPlayerName(player))
			OilTask.PlayerData[player].Phase = 1
			
			addEventHandler("onVehicleStartEnter",OilTask.playerVehicle[player],function(player)
				if(getPedOccupiedVehicleSeat(player) == 0)then
					local owner = apocalypseGetElementData(source,"Owner")
					if(owner ~= getPlayerName(player))then
						NPC.MeMessage(player,getText(player,"SOilTask6"))
						cancelEvent()
					end
				end
			end)
			
			addEventHandler("onVehicleEnter",OilTask.playerVehicle[player],function(player)
				if(getPedOccupiedVehicleSeat(player) == 0)then
					if(OilTask.PlayerData[player].Phase == 1)then
						triggerClientEvent(player,"OilTask.createDeliveryStuff",player)
					end
					if(OilTask.PlayerData[player].Phase == 2)then
						triggerClientEvent(player,"OilTask.finishMarker",player)
					end
				end
			end)
			
			addEventHandler("onVehicleExit",OilTask.playerVehicle[player],function(player)
				if(getPedOccupiedVehicleSeat(player) == 0)then
					triggerClientEvent(player,"OilTask.destroyDeliveryStuff",player)
				end
			end)
			
			addEventHandler("onVehicleExplode",OilTask.playerVehicle[player],function()
				local Owner = apocalypseGetElementData(source,"Owner")
				local OwnerPlayer = getPlayerFromName(Owner)
				if(isElement(OwnerPlayer))then
					triggerClientEvent(OwnerPlayer,"OilTask.destroyDeliveryStuff",OwnerPlayer)
				end
				if(OilTask.PlayerData[OwnerPlayer])then OilTask.PlayerData[OwnerPlayer] = nil end
				if(isElement(OilTask.playerVehicle[OwnerPlayer]))then
					destroyElement(OilTask.playerVehicle[OwnerPlayer])
				end
				OilTask.PlayerData[OwnerPlayer] = nil
			end)
			
			triggerClientEvent(player,"OilTask.createDeliveryStuff",player,OilTask.PlayerData[player])
		else
			NPC.MeMessage(player,getText(player,"SOilTask1"))
		end
	end
end

addEvent("OilTask.deliveryServer",true)
addEventHandler("OilTask.deliveryServer",root,function()
	if(isPedInVehicle(client))then
		OilTask.PlayerData[client].Phase = 2
		triggerClientEvent(client,"OilTask.destroyDeliveryStuff",client)
		triggerClientEvent(client,"OilTask.finishMarker",client)
		NPC.MeMessage(client,getText(client,"SOilTask7"))
	end
end)

addEvent("OilTask.finishDelivery",true)
addEventHandler("OilTask.finishDelivery",root,function()
	if(OilTask.PlayerData[client])then
		local startX, startY, startZ = 878.47241210938, -27.737499237061, 62.170299530029
		local deliveryPos = OilTask.PlayerData[client].DeliverySpawn
		local distance = getDistanceBetweenPoints3D(startX, startY, startZ, deliveryPos[1], deliveryPos[2], deliveryPos[3])
		
		local DistanceMoney = math.floor(distance*0.5)
		local DepositMoney = OilTask.PlayerData[client].Costs
		
		local Level_Bonus_EXP = tonumber(apocalypseGetElementData(client,"level"))
		if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
				
		local xp = 500 + (Level_Bonus_EXP * 20)
		local skillpoint = 10
		if(SERVERBONUS.JOB_ACTIVITIES == true)then
			DistanceMoney = DistanceMoney * 2
			xp = xp * 2
			skillpoint = skillpoint * 2
		end

		local Money = DistanceMoney + DepositMoney
		
		OilTask.PlayerData[client] = nil
		if(isElement(OilTask.playerVehicle[client]))then
			destroyElement(OilTask.playerVehicle[client])
		end
		
		givePlayerServerMoney(client,Money)
		giveEXP(client,xp)
		givePlayerSkillpoint(client,skillpoint)
		NPC.MeMessage(client,getText(client,"SOilTask8"))
		triggerClientEvent(client,"OilTask.destroyDeliveryStuff",client)
		
		outputLog(getPlayerName(client).." hat eine Öl Lieferung abgeschlossen und $"..Money..", "..xp.." Erfahrungspunkte und "..skillpoint.." Skillpunkte erhalten","Oil Delivery",getCharacterID(client))
		
		if(DailyTasks.playerTasks[client][24])then
			DailyTasks.updateProgress(client,24,DailyTasks.playerTasks[client][24].progress + 1)
		end
		if(WeeklyTasks.playerTasks[client][24])then
			WeeklyTasks.updateProgress(client,24,WeeklyTasks.playerTasks[client][24].progress + 1)
		end
		
		local oil_delivery = getPlayerData("character_stats","character_id",getCharacterID(client),"oil_delivery")
		Characters.addStats(client,"oil_delivery",oil_delivery + 1)
		for _,v in pairs(Achievements)do
			if(oil_delivery + 1 >= v[1])then
				setAchievement(client,v[2])
			end
		end
	end
end)

addEventHandler("onPlayerWasted",root,function()
	if(OilTask.PlayerData[source])then OilTask.PlayerData[source] = nil end
	if(isElement(OilTask.playerVehicle[source]))then
		destroyElement(OilTask.playerVehicle[source])
	end
	OilTask.PlayerData[source] = nil
end)

addEventHandler("onPlayerQuit",root,function()
	if(OilTask.PlayerData[source])then OilTask.PlayerData[source] = nil end
	if(isElement(OilTask.playerVehicle[source]))then
		destroyElement(OilTask.playerVehicle[source])
	end
	OilTask.PlayerData[source] = nil
end)