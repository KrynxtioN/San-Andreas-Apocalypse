Friends = {}

addEvent("addFriend",true)
addEventHandler("addFriend",root,function(name)
	local targetName
	if(not(name))then
		targetName = apocalypseGetElementData(client,"PlayerInteraction_Name")
	else
		targetName = name
	end
	if(not(targetName))then return end

	local result = dbPoll(dbQuery(handler,"SELECT * from characters WHERE name = '"..targetName.."'"),-1)
	if(#result >= 1)then
		local target_character_id = tonumber(getPlayerData("characters","name",targetName,"ID"))
		if(Friends.Status(client,target_character_id) == false)then
			local target = getPlayerFromName(targetName)
			local playerFriends = getPlayerData("characters","ID",getCharacterID(client),"friends")
			local newPlayerFriends = playerFriends..""..target_character_id..","
			dbExec(handler,"UPDATE characters SET friends = '"..newPlayerFriends.."' WHERE ID = '"..getCharacterID(client).."'")
			createInfobox(client,getText(client,"SFriends1"))
			Friends.getData(client)
			setAchievement(client,411)
			if(target and isElement(target) and isCharacterLoggedIn(target))then
				outputChatBox(getText(target,"SFriends7"):format(getPlayerName(client)),target,0,150,0)
			end
		else
			createInfobox(client,getText(client,"SFriends2"))
		end
	else
		createInfobox(client,getText(client,"SFriends3"))
	end
end)

addEvent("removeFriend",true)
addEventHandler("removeFriend",root,function(name)
	local result = dbPoll(dbQuery(handler,"SELECT * from characters WHERE name = '"..name.."'"),-1)
	if(#result >= 1)then
		local target_character_id = tonumber(getPlayerData("characters","name",name,"ID"))
		if(Friends.Status(client,target_character_id) == true)then
			local target = getPlayerFromName(name)
			local playerFriends = getPlayerData("characters","ID",getCharacterID(player),"friends")
			local values = split(playerFriends or "", ",")
			local updatedFriends = ""
			
			for _,v in pairs(values)do
				if(v ~= "" and tonumber(v) ~= target_character_id)then
					updatedFriends = updatedFriends..v..","
				end
			end
			dbExec(handler,"UPDATE characters SET friends = '"..updatedFriends.."' WHERE ID = '"..getCharacterID(client).."'")
			createInfobox(client,getText(client,"SFriends4"))
			Friends.getData(client)
			
			if(target and isElement(target) and isCharacterLoggedIn(target))then
				outputChatBox(getText(target,"SFriends8"):format(getPlayerName(client)),target,150,0,0)
			end
		end
	end
end)

function Friends.Status(player, characterID)
	local playerFriends = getPlayerData("characters","ID",getCharacterID(player),"friends")
	local values = split(playerFriends or "", ",")
	local status = false
	
	if(playerFriends)then
		for _,v in pairs(values)do
			if(characterID == tonumber(v))then
				status = true
				break
			end
		end
	end
	return status
end

function Friends.getData(player)
	if(not(player))then player = client end
	local playerFriends = getPlayerData("characters","ID",getCharacterID(player),"friends")
	local values = split(playerFriends or "", ",")
	local friends = {}
	for _,v in pairs(values)do
		local name = getPlayerData("characters","ID",tonumber(v),"name")
		table.insert(friends,name)
	end
	triggerClientEvent(player,"Self.updateFriends",player,friends)
end
addEvent("Friends.getData",true)
addEventHandler("Friends.getData",root,Friends.getData)

function Friends.checkOnline(player,state)
	if not isElement(player) then return end

	local characterID = getCharacterID(player)
	if not characterID then return end

	for _, otherPlayer in ipairs(getElementsByType("player")) do
		if otherPlayer ~= player then
			if(isCharacterLoggedIn(otherPlayer))then
				local otherFriends = getPlayerData("characters", "ID", getCharacterID(otherPlayer), "friends") or ""
				local values = split(otherFriends, ",")
				
				for _, id in pairs(values) do
					if tonumber(id) == characterID then
						if(state == "on")then
							outputChatBox(getText(otherPlayer,"SFriends5"):format(getPlayerName(player)),otherPlayer,0,150,0,true)
						elseif(state == "off")then
							outputChatBox(getText(otherPlayer,"SFriends6"):format(getPlayerName(player)),otherPlayer,150,0,0,true)
						end
						break
					end
				end
			end
		end
	end
end

addEventHandler("onPlayerQuit",root,function() Friends.checkOnline(source,"off") end)

function Friends.giveMutualExp()
    local players = getElementsByType("player")

    for _, p1 in ipairs(players) do
        if isElement(p1) and isCharacterLoggedIn(p1) then
            local p1ID = getCharacterID(p1)
            if p1ID then
                local onlineMutualCount = 0

                for _, p2 in ipairs(players) do
                    if p2 ~= p1 and isElement(p2) and isCharacterLoggedIn(p2) then
                        local p2ID = getCharacterID(p2)
                        if p2ID then
                            if Friends.Status(p1, p2ID) and Friends.Status(p2, p1ID) then
                                onlineMutualCount = onlineMutualCount + 1
                            end
                        end
                    end
                end

                if onlineMutualCount > 0 then
                    local baseExp = 5
                    giveEXP(p1, baseExp * onlineMutualCount)
                end
            end
        end
    end
end

setTimer(Friends.giveMutualExp, 60000, 0)