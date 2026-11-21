Party = {}

function isPlayerInParty(player)
	if(apocalypseGetElementData(player,"IsInParty") == true)then
		return true
	end
	return false
end

function Party.create()
	if(isPlayerInParty(client) == false)then
		if(tonumber(apocalypseGetElementData(client,"colony")) == 0)then
			apocalypseSetElementData(client,"PartyID",getCharacterID(client))
			apocalypseSetElementData(client,"ActiveParty",true)
			apocalypseSetElementData(client,"IsInParty",true)
			NPC.NormalMessage(client,getText(client,"SParty1"))
			setAchievement(client,418)
			triggerClientEvent(client,"closeWindow",client)
		else
			createInfobox(client,getText(client,"SParty6"))
		end
	end
end
addEvent("Party.create",true)
addEventHandler("Party.create",root,Party.create)

function Party.delete(player)
	if(not(player))then player = client end
	if(apocalypseGetElementData(player,"ActiveParty") == true)then
		for _,v in pairs(getElementsByType("player"))do
			if(isCharacterLoggedIn(v))then
				if(isPlayerInParty(v) ~= false)then
					if(tonumber(apocalypseGetElementData(v,"PartyID")) == getCharacterID(player))then
						apocalypseSetElementData(v,"IsInParty",nil)
						apocalypseSetElementData(v,"PartyID",nil)
						triggerClientEvent(v,"Party.updateBlips",v)
					end
				end
			end
		end
		
		NPC.NormalMessage(player,getText(player,"SParty5"))
		apocalypseSetElementData(player,"ActiveParty",false)
		triggerClientEvent(player,"closeWindow",player)
	end
end
addEvent("Party.delete",true)
addEventHandler("Party.delete",root,Party.delete)

function Party.addPlayer(player, PartyPlayer)
	if(player and PartyPlayer)then
		local player = getPlayerFromName(player)
		if(isElement(player) and isCharacterLoggedIn(player))then
			if(isElement(PartyPlayer) and isCharacterLoggedIn(PartyPlayer))then
				if(apocalypseGetElementData(PartyPlayer,"ActiveParty") == false)then
					if(tonumber(apocalypseGetElementData(player,"colony")) == 0)then
						if(isPlayerInParty(player) == false)then
							apocalypseSetElementData(player,"IsInParty",true)
							apocalypseSetElementData(player,"PartyID",getCharacterID(PartyPlayer))
							createInfobox(player,getText(player,"SParty2"):format(getCharacterName(PartyPlayer)))
							createInfobox(PartyPlayer,getText(player,"SParty3"):format(getCharacterName(player)))
							
							for _,v in pairs(getElementsByType("player"))do
								if(isCharacterLoggedIn(v))then
									if(isPlayerInParty(player) == true)then
										if(tonumber(apocalypseGetElementData(v,"PartyID")) == getCharacterID(partyPlayer))then
											triggerClientEvent(v,"Party.updateBlips",v)
										end
									end
								end
							end
							
							triggerClientEvent(PartyPlayer,"Party.updateGridlist",PartyPlayer)
						else
							createInfobox(PartyPlayer,getText(PartyPlayer,"SParty4"))
						end
					else
						createInfobox(PartyPlayer,getText(PartyPlayer,"SParty7"))
					end
				end
			end
		end
	end
end
addEvent("Party.addPlayer",true)
addEventHandler("Party.addPlayer",root,Party.addPlayer)

function Party.removePlayer(player)
	if(player)then
		if(isPlayerInParty(player) == true)then
			if(apocalypseGetElementData(player,"ActiveParty") == true)then
				for _,v in pairs(getElementsByType("player"))do
					if(isCharacterLoggedIn(v))then
						if(isPlayerInParty(v))then
							if(tonumber(apocalypseGetElementData(v,"PartyID")) == apocalypseGetElementData(v,"PartyID",getCharacterID(player)))then
								apocalypseSetElementData(localPlayer,"IsInParty",nil)
								apocalypseSetElementData(localPlayer,"PartyID",nil)
							end
						end
					end
				end
			end
			apocalypseSetElementData(player,"IsInParty",nil)
			triggerClientEvent(client,"Party.updateGridlist",client)
		end
	end
end
addEvent("Party.removePlayer",true)
addEventHandler("Party.removePlayer",root,Party.removePlayer)

addEventHandler("onPlayerQuit",root,function() Party.delete(source) end)