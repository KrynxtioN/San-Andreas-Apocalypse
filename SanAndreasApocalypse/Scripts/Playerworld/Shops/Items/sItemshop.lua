Itemshop = {
	["Items:Data"] = {
		[3027] = 2,
		[2966] = 5,
		[365] = 56,
	},
}

addEvent("Itemshop.buy", true)
addEventHandler("Itemshop.buy", root, function(item, price, level)
	if(tonumber(apocalypseGetElementData(client, "level")) >= tonumber(level))then
		if(tonumber(apocalypseGetElementData(client, "money")) >= tonumber(price))then
			if(item == 2966)then
				if(hasPlayerItem(client, 5) == 0)then
					giveItem(client, 5, 1)
					setQuest(client,32)
					loadCompass(client)
					triggerClientEvent(client,"BliplegendRender",client)
					triggerClientEvent(client,"TutorialPickups.deletePickup",client,"Compass")
					outputLog(getPlayerName(client).." hat sich das Item "..item.." für $"..price.." gekauft","Itemshop",getCharacterID(client))
				else
					NPC.NormalMessage(client,getText(client, ("SItemshop4")))
					return
				end
			else
				giveItem(client, tonumber(Itemshop["Items:Data"][item]), 1)
				outputLog(getPlayerName(client).." hat sich das Item "..item.." für $"..price.." gekauft","Itemshop",getCharacterID(client))
			end
			apocalypseSetElementData(client, "money", apocalypseGetElementData(client, "money")-tonumber(price))
			NPC.NormalMessage(client, getText(client, "SItemshop3"))
		else NPC.NormalMessage(client, getText(client, "SItemshop2"):format(price))end
	else NPC.NormalMessage(client, getText(client, "SItemshop1"):format(level))end
end)

addEventHandler("onPlayerWasted", root, function() triggerClientEvent(source, "Itemshop.close", source) end)