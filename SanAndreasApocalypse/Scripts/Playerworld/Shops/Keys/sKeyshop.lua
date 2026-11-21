addEvent("KeysShop.buy",true)
addEventHandler("KeysShop.buy",root,function(keyID,key_level,price_money,price_brain)
	local key_level, price_money, price_brain = tonumber(key_level), tonumber(price_money), tonumber(price_brain)

	if(tonumber(apocalypseGetElementData(client,"level")) >= key_level)then
		if(hasPlayerKey(client,keyID) < 1)then
			if(tonumber(apocalypseGetElementData(client,"money")) >= price_money)then
				if(hasPlayerItem(client,1) >= price_brain)then
				
					apocalypseSetElementData(client,"money",tonumber(apocalypseGetElementData(client,"money"))-price_money)
					takeItem(client,1,price_brain)
					triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SKeyshop4"))
					giveKey(client,keyID,1)
					setAchievement(client,55)
					outputLog(getPlayerName(client).." hat sich den Schlüssel mit der ID "..keyID.." für $"..price.." und "..price_brain.." Hirnmasse gekauft","Itemshop",getCharacterID(client))
				else triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SKeyshop3"):format(price_brain))end
			else triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SKeyshop2"):format(price_money))end
		else triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SKeyshop5"))end
	else triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SKeyshop1"):format(key_level))end
end)