for _,v in pairs(PrestigeObjects["Coordinations"])do
	local Pickup = createPickup(v[1],v[2],v[3],3,1239,50)
	apocalypseSetElementData(Pickup,"PrestigeID",v[4])
	
	addEventHandler("onPickupHit",Pickup,function(player)
		if(not(isPedInVehicle(player)))then
			local owner = tonumber(getPlayerData("prestige","ID",apocalypseGetElementData(source,"PrestigeID"),"owner_character_id"))
			local money = tonumber(getPlayerData("prestige","ID",apocalypseGetElementData(source,"PrestigeID"),"money"))
			local experience = tonumber(getPlayerData("prestige","ID",apocalypseGetElementData(source,"PrestigeID"),"experience"))
			if(owner == 0)then ownerName = "/" else ownerName = getPlayerData("characters","ID",owner,"name") or "/" end
			triggerClientEvent(player,"PrestigeObjects.createWindow",player,apocalypseGetElementData(source,"PrestigeID"),ownerName,money,experience)
		end
	end)
end

addEvent("PrestigeObjects.buy",true)
addEventHandler("PrestigeObjects.buy",root,function(ID)
	local ID = tonumber(ID)
	local costs_money, costs_brain = PrestigeObjects["Infos"][ID]["Costs"].money,PrestigeObjects["Infos"][ID]["Costs"].brain
	local ownerID = getPlayerData("prestige","ID",ID,"owner_character_id")
	if(ownerID == 0)then
		if(tonumber(apocalypseGetElementData(client,"money")) >= costs_money)then
			if(hasPlayerItem(client,1) >= costs_brain)then
				dbExec(handler,"UPDATE prestige SET owner_character_id = '"..getCharacterID(client).."' WHERE ID = '"..ID.."'")
				triggerClientEvent(client,"closeWindow",client)
				apocalypseSetElementData(client, "money", tonumber(apocalypseGetElementData(client, "money"))-costs_money)
				takeItem(client,1,costs_brain)
				outputLog(getPlayerName(client).." hat ein Prestige Objekt gekauft (ID: "..ID..")", "Prestige Objekte", getCharacterID(client))
			else createInfobox(client,getText(client,"SPrestige2"))end
		else createInfobox(client,getText(client,"SPrestige1"))end
	end
end)

addEvent("PrestigeObjects.takeStuff",true)
addEventHandler("PrestigeObjects.takeStuff",root,function(ID)
	local ID = tonumber(ID)
	local money = getPlayerData("prestige","ID",ID,"money")
	local experience = getPlayerData("prestige","ID",ID,"experience")
	giveEXP(client,experience)
	givePlayerServerMoney(client,money)
	triggerClientEvent(client,"closeWindow",client)
	dbExec(handler,"UPDATE prestige SET money = '0', experience = '0' WHERE ID = '"..ID.."'")
	outputLog(getPlayerName(client).." hat $"..money.." und "..experience.." EXP eingesammelt", "Prestige Objekte", getCharacterID(client))
end)

addEvent("PrestigeObjects.sell",true)
addEventHandler("prestigeObjects.sell",root,function(ID)
	local ID = tonumber(ID)
	if(ownerID ~= 0)then
		local costs_money, costs_brain = PrestigeObjects["Infos"][ID]["Costs"].money,PrestigeObjects["Infos"][ID]["Costs"].brain
		local ownerID = tonumber(getPlayerData("prestige","ID",ID,"owner_character_id"))
		if(ownerID == getCharacterID(client))then
			givePlayerServerMoney(client,math.floor(costs_money/100*75))
			giveItem(client,1,math.floor(costs_brain/100*75))
			createInfobox(client,getText(client,"SPrestige3"))
			dbExec(handler,"UPDATE prestige SET owner_character_id = '0' WHERE ID = '"..ID.."'")
			outputLog(getPlayerName(client).." hat ein Prestige Objekt verkauft (ID: "..ID..")", "Prestige Objekte", getCharacterID(client))
		end
	end
end)

setTimer(function()
	local result = dbPoll(dbQuery(handler,"SELECT * FROM prestige"),-1)
	for _,v in pairs(result)do
		if(v["owner_character_id"] >= 1)then
			local ownerID = v["owner_character_id"]
			local ownerLevel = getPlayerData("characters","ID",ownerID,"level")
			local money = v["money"] + PrestigeObjects["Infos"][v["ID"]].generate_money
			local experience = v["experience"] + (PrestigeObjects["Infos"][v["ID"]].generate_exp * ownerLevel)
			if(money <= PrestigeObjects["Infos"][v["ID"]].max_money)then
				dbExec(handler,"UPDATE prestige SET money = '"..money.."' WHERE ID = '"..v["ID"].."'")
			else
				dbExec(handler,"UPDATE prestige SET money = '"..PrestigeObjects["Infos"][v["ID"]].max_money.."' WHERE ID = '"..v["ID"].."'")
			end
			if(experience <= PrestigeObjects["Infos"][v["ID"]].max_exp)then
				dbExec(handler,"UPDATE prestige SET experience = '"..experience.."' WHERE ID = '"..v["ID"].."'")
			else
				dbExec(handler,"UPDATE prestige SET experience = '"..PrestigeObjects["Infos"][v["ID"]].max_exp.."' WHERE ID = '"..v["ID"].."'")
			end
		end
	end
end,3600000,0)