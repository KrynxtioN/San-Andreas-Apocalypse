Shelter = {PickupObject = {}, Blips = {}}

addCommandHandler("createShelter",function(player,cmd,price_money,price_brainmass)
	local x,y,z = getElementPosition(player)
	if(isAdminLevel(player) >= 3)then
		if(getElementDimension(player) == 0 and getElementInterior(player) == 0)then
			if(price_money)then
				local brainmass = 0
				local price_brainmass = tonumber(price_brainmass)
				if(price_brainmass)then
					brainmass = price_brainmass 
				else
					brainmass = price_money * 0.15
				end
				local price_money = tonumber(price_money)
				dbExec(handler, "INSERT INTO shelter (posx, posy, posz, owner, price_money, price_brainmass) VALUES (?, ?, ?, ?, ?, ?)", x, y, z, 0, price_money, brainmass)
				Shelter.load()
			end
		end
	end
end)

function Shelter.load()
	local result = dbPoll(dbQuery(handler,"SELECT * FROM shelter"),-1)

	if(#result >= 1)then
		for _,v in pairs(result)do
			if(not(isElement(Shelter.PickupObject[v["ID"]])))then
				local model = 1273
				if(tonumber(v["owner"]) ~= 0)then model = 1272 end
				Shelter.PickupObject[v["ID"]] = createPickup(v["posx"],v["posy"],v["posz"],3,model,50)
				apocalypseSetElementData(Shelter.PickupObject[v["ID"]],"ShelterID",v["ID"])
				apocalypseSetElementData(Shelter.PickupObject[v["ID"]],"Price_Money",v["price_money"])
				apocalypseSetElementData(Shelter.PickupObject[v["ID"]],"Price_Brainmass",v["price_brainmass"])
				apocalypseSetElementData(Shelter.PickupObject[v["ID"]],"Owner",v["owner"])
				apocalypseSetElementData(Shelter.PickupObject[v["ID"]],"Colony",v["colony"])
				
				addEventHandler("onPickupHit",Shelter.PickupObject[v["ID"]],function(player)
					if(not(isPedInVehicle(player)))then
						if(getElementDimension(player) == getElementDimension(source))then
							if(Money_Transporter.hasPlayerMoneyBag(player) == false)then
								apocalypseSetElementData(player,"ShelterID",apocalypseGetElementData(source,"ShelterID"))
								local owner = apocalypseGetElementData(source,"Owner")
								local Colony = apocalypseGetElementData(source,"Colony")
								local ownerName = getPlayerData("characters","ID",apocalypseGetElementData(source,"Owner"),"name") or 0
								if(ownerName == 0)then ownerName = "-" end
								if(ownerName == "-")then
									triggerClientEvent(player,"Shelter.window",player,apocalypseGetElementData(source,"Price_Money"),apocalypseGetElementData(source,"Price_Brainmass"),ownerName,Colony)
								else
									if(ownerName == getCharacterName(player) or apocalypseGetElementData(player,"colony") == tonumber(Colony))then
										triggerClientEvent(player,"Shelter.window",player,apocalypseGetElementData(source,"Price_Money"),apocalypseGetElementData(source,"Price_Brainmass"),ownerName,Colony)
									end
								end
							else
								Money_Transporter.deliverMoneyBag(player)
							end
							ColonyFlag.deliver(player,apocalypseGetElementData(source,"ShelterID"))
						end
					end
				end)
			end
		end
	end
end
Shelter.load()

function Shelter.createBlips(player)
	for _,v in pairs(Shelter.PickupObject)do
		local x,y,z = getElementPosition(v)
		local owner = apocalypseGetElementData(v,"Owner")

		if(tonumber(owner) ~= 0)then
			owner = getPlayerData("characters","ID",owner,"name")
		end
		triggerClientEvent(player,"Shelter.createBlips",player,x,y,z,owner)
	end
end

addEvent("Shelter.buyObject",true)
addEventHandler("Shelter.buyObject",root,function()
	local ID = tonumber(apocalypseGetElementData(client,"ShelterID"))
	local ShelterPickup = Shelter.PickupObject[ID]
	local Owner = apocalypseGetElementData(ShelterPickup,"Owner")
	local Price_Money = tonumber(apocalypseGetElementData(ShelterPickup,"Price_Money"))
	local Price_Brainmass = tonumber(apocalypseGetElementData(ShelterPickup,"Price_Brainmass"))
	
	if(tonumber(Owner) == 0)then
		if(tonumber(apocalypseGetElementData(client,"money")) >= Price_Money and hasPlayerItem(client,1) >= Price_Brainmass)then
			dbExec(handler,"UPDATE shelter SET owner = '"..getCharacterID(client).."' WHERE ID = '"..ID.."'")
			takeItem(client,1,Price_Brainmass)
			apocalypseSetElementData(client,"money",apocalypseGetElementData(client,"money")-Price_Money)
			destroyElement(ShelterPickup)
			Shelter.load()
			setAchievement(client,120)
			triggerClientEvent(client,"closeWindow",client)
		else
			createInfobox(client,getText(client,"SShelter2"))
		end
	else
		createInfobox(client,getText(client,"SShelter1"))
	end
end)

addEvent("Shelter.sellObject",true)
addEventHandler("Shelter.sellObject",root,function()
	local ID = tonumber(apocalypseGetElementData(client,"ShelterID"))
	local ShelterPickup = Shelter.PickupObject[ID]
	local Owner = apocalypseGetElementData(ShelterPickup,"Owner")
	local Price_Money = tonumber(apocalypseGetElementData(ShelterPickup,"Price_Money"))
	local Price_Brainmass = tonumber(apocalypseGetElementData(ShelterPickup,"Price_Brainmass"))
	if(tonumber(Owner) == getCharacterID(client))then
		givePlayerServerMoney(client,Price_Money/100*75)
		giveItem(client,1,Price_Brainmass/100*75)
		dbExec(handler,"UPDATE shelter SET owner = '0' WHERE ID = '"..ID.."'")
		destroyElement(ShelterPickup)
		Shelter.PickupObject[ID] = nil
		Shelter.load()
		triggerClientEvent(client,"closeWindow",client)
	end
end)

addEvent("Shelter.spawnHere",true)
addEventHandler("Shelter.spawnHere",root,function()
	local ID = tonumber(apocalypseGetElementData(client,"ShelterID"))
	local ShelterPickup = Shelter.PickupObject[ID]
	local Owner = apocalypseGetElementData(ShelterPickup,"Owner")
	local Colony = apocalypseGetElementData(ShelterPickup,"Colony")
	if(tonumber(Owner) == getCharacterID(client) or apocalypseGetElementData(client,"colony") == tonumber(Colony))then
		dbExec(handler,"UPDATE characters SET spawn_shelter_id = '"..ID.."' WHERE ID = '"..getCharacterID(client).."'")
		NPC.MeMessage(client,getText(client,"MeMessage13"))
	end
end)

function Shelter.spawnPlayer(player,spawn_shelter_id,playerModel)
	if(spawn_shelter_id and playerModel)then
		local ID = spawn_shelter_id
		if(isElement(Shelter.PickupObject[ID]))then
			local x,y,z = getElementPosition(Shelter.PickupObject[ID])
			spawnPlayer(player,x,y,z,math.random(0,360),playerModel)
		end
	end
end

addEvent("Shelter.switchColonyStatus",true)
addEventHandler("Shelter.switchColonyStatus",root,function(Type)
	if(Type)then
		local ID = tonumber(apocalypseGetElementData(client,"ShelterID"))
		local Owner = apocalypseGetElementData(Shelter.PickupObject[ID],"Owner")
		
		if(tonumber(Owner) == getCharacterID(client))then
			if(Type == "on")then	
				if(apocalypseGetElementData(client,"colony") >= 1)then
					local result = dbPoll(dbQuery(handler,"SELECT * FROM shelter WHERE colony = '"..apocalypseGetElementData(client,"colony").."'"),-1)
					if(#result == 0)then
						dbExec(handler,"UPDATE shelter SET colony = '"..apocalypseGetElementData(client,"colony").."' WHERE ID = '"..ID.."'")
						NPC.MeMessage(client,getText(client,"MeMessage14"))
					else
						createInfobox(client,getText(client,"SShelter6"))
					end
				else
					createInfobox(client,getText(client,"SShelter5"))
				end
			end
			if(Type == "off")then
				dbExec(handler,"UPDATE shelter SET colony = '0' WHERE ID = '"..ID.."'")
				NPC.MeMessage(client,getText(client,"MeMessage15"))
			end
		end
	end
end)

function Shelter.getColonyShelterPosition(colonyID)
    if not colonyID or tonumber(colonyID) == 0 then return false end
    
    local result = dbPoll(dbQuery(handler, "SELECT posx, posy, posz FROM shelter WHERE colony = ? LIMIT 1", colonyID), -1)
    
    if result and #result > 0 then
        return {result[1].posx, result[1].posy, result[1].posz}
    else
        return false
    end
end
