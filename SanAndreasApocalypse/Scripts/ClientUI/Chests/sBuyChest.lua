addEvent("BuyPizzaboyChest",true)
addEventHandler("BuyPizzaboyChest",root,function()
	if(hasPlayerItem(client,29) >= 75)then
		takeItem(client,29,75)
		giveItem(client,69,1)
		createInfobox(client,getText(client,"SBuyChest2"))
		outputLog(getPlayerName(client).." hat eine Fahrzeugkiste (Pizzaboy) gekauft", "Vehicle Crates", getCharacterID(client))
		triggerClientEvent(client, "showItemBar", client, {{69,1}})
	else
		createInfobox(client,getText(client,"SBuyChest1"))
	end
end)