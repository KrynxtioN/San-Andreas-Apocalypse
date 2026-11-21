addEvent("ItemForItem.tradeServer",true)
addEventHandler("ItemForItem.tradeServer",root,function(costItem,costItem_amount,rewardItem,rewardItem_amount)
	local costItem = tonumber(costItem)
	local costItem_amount = tonumber(costItem_amount)
	local rewardItem = tonumber(rewardItem)
	local rewardItem_amount = tonumber(rewardItem_amount)
	
	if(hasPlayerItem(client,costItem) >= costItem_amount)then
		takeItem(client,costItem,costItem_amount)
		giveItem(client,rewardItem,rewardItem_amount)
		triggerClientEvent(client, "showItemBar", client, {{rewardItem,rewardItem_amount}})
		NPC.NormalMessage(client,getText(client,"STrading2"))
		triggerClientEvent(client,"ItemForItem.closeWindow",client)
	else NPC.NormalMessage(client,getText(client,"STrading1"))end
end)