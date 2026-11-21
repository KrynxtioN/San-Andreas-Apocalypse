addEvent("Armor.buy", true)
addEventHandler("Armor.buy", root, function(price, level, armor)
	local price,level,armor = tonumber(price),tonumber(level),tonumber(armor)
	if(tonumber(apocalypseGetElementData(client, "level")) >= level)then
		if(tonumber(apocalypseGetElementData(client, "money")) >= price)then
			if(getPedArmor(client) < 100)then
				local newArmor = getPedArmor(client) + armor
				if(newArmor > 100)then newArmor = 100 end
				apocalypseSetElementData(client, "money", apocalypseGetElementData(client, "money")-price)
				NPC.NormalMessage(client, getText(client, "SArmor3"))
				setPedArmor(client, newArmor)
				outputLog(getPlayerName(client).." hat "..armor.."% Weste für $"..price.." gekauft","Armorshop",getCharacterID(client))
			else NPC.NormalMessage(client, getText(client, "SArmor4"))end
		else NPC.NormalMessage(client, getText(client, "SArmor2"):format(price))end
	else NPC.NormalMessage(client, getText(client, "SArmor1"):format(level))end
end)