addEvent("buyPotion",true)
addEventHandler("buyPotion",root,function(potionID,price)
	local price = tonumber(price)
	local item = nil
	if(potionID == "speed")then item = 194 end
	if(potionID == "protection")then item = 195 end
	if(potionID == "health")then item = 196 end
	if(potionID == "stun")then item = 197 end
	if(tonumber(apocalypseGetElementData(client, "money")) >= tonumber(price))then
		apocalypseSetElementData(client, "money", apocalypseGetElementData(client, "money")-tonumber(price))
		NPC.NormalMessage(client, getText(client,"SImpalaEvent13"))
		giveItem(client,item,1)
		outputLog(getPlayerName(client).." hat sich folgenden Trank für $"..price.." gekauft: "..potionID,"Potionshop",getCharacterID(client))
	else NPC.NormalMessage(client, getText(client, "SNotepad1"):format(price))end
end)