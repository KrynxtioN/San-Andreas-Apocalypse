function loadCompass(player)
	if(not(player))then player = client end
	if(tonumber(hasPlayerItem(client,5)) >= 1)then
		triggerClientEvent(player,"renderCompass",player)
		triggerClientEvent(player,"BliplegendRender",player)
		triggerClientEvent(player,"ActivateF11",player)
		triggerClientEvent(player,"drawNearZombies",player)
	else
		triggerClientEvent(player,"DisableF11",player)
	end
end
addEvent("loadCompass",true)
addEventHandler("loadCompass",root,loadCompass)

addEvent("checkCompass",true)
addEventHandler("checkCompass",root,function()
	if(isCharacterLoggedIn(client))then
		if(hasPlayerItem(client,5) == 0)then
			triggerClientEvent(client,"DisableF11",client)
		else
			loadCompass(client)
		end
	end
end)