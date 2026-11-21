addEvent("SeedsShop.buy",true)
addEventHandler("SeedsShop.buy",root,function(ItemID,price)
	local price = tonumber(price)
	local ItemID = tonumber(ItemID)

	if(tonumber(apocalypseGetElementData(client,"money")) >= price)then
		apocalypseSetElementData(client,"money",tonumber(apocalypseGetElementData(client,"money"))-price)
		giveItem(client,ItemID,1)
		triggerClientEvent(client, "showItemBar", client, {{ItemID,1}})
		outputLog(getPlayerName(client).." hat das das Item mit der ID "..ItemID.." für $"..price.." gekauft","Seedshop",getCharacterID(client))
		if(hasPlayerCraftingRecipe(client,8) == false)then
			addPlayerCraftingRecipe(client,8)
			triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SSeedshop3"))
		else
			triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SSeedshop2"))
		end
	else triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SSeedshop1"):format(price))end
end)