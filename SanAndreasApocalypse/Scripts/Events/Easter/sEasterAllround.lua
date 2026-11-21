function giveEasterEgg(player,amount)
	if(ServerTime.GameDay == 6 or ServerTime.GameDay == 7)then amount = amount + 1 end
	triggerClientEvent(player,"EasterAmountChange",player,hasPlayerItem(player,204) + amount)
	giveItem(player,204,amount)
end