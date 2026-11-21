local InformationPickup = createPickup(198.38275146484,-234.88008117676,1.778618812561,3,1239,50)

addEventHandler("onPickupHit",InformationPickup,function(player)
	if(getElementType(player) == "player")then
		if(getElementDimension(player) == getElementDimension(source))then
			createInfobox(player,getText(player,"SSafeKey4"))
		end
	end
end)

function claimSafeKey(player)
	if(not(player))then player = client end
	local time = getRealTime()
	local safeKeyTime = tonumber(getPlayerData("characters","ID",getCharacterID(player),"safeKeyTime"))
	if(not(safeKeyTime))then safeKeyTime = 0 end
	
	local currentTimestamp = time.timestamp
	if((currentTimestamp - safeKeyTime) >= 43200)then
		local timestamp = time.timestamp
		dbExec(handler,"UPDATE characters SET safeKeyTime = '"..timestamp.."' WHERE ID = '"..getCharacterID(player).."'")
		createInfobox(client, getText(client, "SSafeKey1"))
		giveKey(client,13,1)
	else
		local timeLeft = 43200 - (currentTimestamp - safeKeyTime)
		createInfobox(client, getText(client, "SSafeKey2"):format(formatTimeLeft(timeLeft)))
	end
end
addEvent("claimSafeKey",true)
addEventHandler("claimSafeKey",root,claimSafeKey)

addEvent("SafeShop.buy",true)
addEventHandler("SafeShop.buy",root,function(requiredKeys)
	local requiredKeys = tonumber(requiredKeys)
	if(getPlayerKeys(client,13) >= requiredKeys)then
		takeKey(client,13,requiredKeys)
		triggerClientEvent(client,"SafeShop.startUnlocking",client)
		outputLog(getPlayerName(client).." hat einen Safe gekauft","Safeshop",getCharacterID(client))
	else
		NPC.NormalMessage(client,getText(client,"SSafeKey3"))
	end
end)

addEvent("SafeShop.giveWin",true)
addEventHandler("SafeShop.giveWin",root,function(item)
	local item = tonumber(item)
	giveItem(client,item,1)
end)