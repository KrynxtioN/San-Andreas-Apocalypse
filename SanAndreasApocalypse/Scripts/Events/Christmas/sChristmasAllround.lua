function giveChristmasPresent(player,amount)
	if(ServerTime.GameDay == 6 or ServerTime.GameDay == 7)then amount = amount + 1 end
	triggerClientEvent(player,"PresentAmountChange",player,hasPlayerItem(player,38) + amount)
	giveItem(player,38,amount)
end