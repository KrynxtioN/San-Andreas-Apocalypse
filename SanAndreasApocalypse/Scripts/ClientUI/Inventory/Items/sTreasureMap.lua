TreasureMap = {}

function TreasureMap.loadMarker(player)
	if(hasPlayerKey(player,18) == 0 and hasPlayerItem(player,93) >= 1)then
		triggerClientEvent(player,"TreasureMap.loadMarker",player,1,18)
	end
	if(hasPlayerKey(player,19) == 0 and hasPlayerItem(player,103) >= 1)then
		triggerClientEvent(player,"TreasureMap.loadMarker",player,1,19)
	end
	if(hasPlayerKey(player,20) == 0 and hasPlayerItem(player,104) >= 1)then
		triggerClientEvent(player,"TreasureMap.loadMarker",player,1,20)
	end
end

addEvent("TreasureMap.giveKey",true)
addEventHandler("TreasureMap.giveKey",root,function(KeyID)
	local KeyID = tonumber(KeyID)
	giveKey(client,KeyID,1)
	NPC.MeMessage(client,getText(client,"STreasureMap1"))
end)