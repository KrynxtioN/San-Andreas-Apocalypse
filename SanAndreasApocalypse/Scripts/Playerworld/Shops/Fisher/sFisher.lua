addEvent("FishersShop.buy",true)
addEventHandler("FishersShop.buy",root,function(ItemID,price_shells,amount)
	local price_shells = tonumber(price_shells)
	local itemID = tonumber(ItemID)
	local amount = tonumber(amount)
	
	if(hasPlayerItem(client,67) >= price_shells)then
		local sold_out = false
		if(itemID == 64)then
			if(hasPlayerItem(client,64) >= 1 or hasPlayerItem(client,106) >= 1)then
				sold_out = true
			end
		end
		if(itemID == 65)then
			if(hasPlayerItem(client,64) >= 1 or hasPlayerItem(client,106) >= 1)then
				sold_out = true
			end
		end
		if(itemID == 66)then
			if(hasPlayerItem(client,64) >= 1 or hasPlayerItem(client,106) >= 1)then
				sold_out = true
			end
		end
		if(itemID == 93)then
			if(hasPlayerItem(client,93) >= 1)then
				sold_out = true
			end
		end
		if(itemID == 103)then
			if(hasPlayerItem(client,103) >= 1)then
				sold_out = true
			end
		end
		if(itemID == 104)then
			if(hasPlayerItem(client,104) >= 1)then
				sold_out = true
			end
		end
		
		if(sold_out == false)then
			takeItem(client,67,price_shells)
			giveItem(client,ItemID,1)
			setAchievement(client,82)
			
			outputLog(getPlayerName(client).." hat sich das Item "..itemID.." für "..price_shells.." Muscheln gekauft","Fishershop",getCharacterID(client))
		
			if(itemID == 65 or itemID == 64 or itemID == 66)then
				if(hasPlayerCraftingRecipe(client,9) == false)then
					addPlayerCraftingRecipe(client,9)
					triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SFishershop3"))
					return
				end
			end
			if(itemID == 93 or itemID == 103 or itemID == 104)then
				TreasureMap.loadMarker(client)
			end
			triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SFishershop2"))
		else
			triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SFishershop4"))
		end
	else
		triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SFishershop1"):format(price_shells))
	end
end)