Chatsystem = {messages = {}, spamTimer = {}, killSpamTimer = {}}

local NormalDistance = 10
local ScreamDistance = 25
local MegaphoneDistance = 50

function convertText(...) local tbl = {...} return table.concat(tbl, " ") end

addEventHandler("onPlayerChat", root, function(message, messageTyp)
	if(isCharacterLoggedIn(source))then
		if(not(isPedDead(source)))then
			if(messageTyp == 0)then
				if(not(Chatsystem.messages[source]))then Chatsystem.messages[source] = 0 end
				if(Chatsystem.messages[source] < 3)then
					if(isTimer(Chatsystem.killSpamTimer[source]))then
						killTimer(Chatsystem.killSpamTimer[source])
					end
					
					if(not(isTimer(Chatsystem.spamTimer[source])))then
						Chatsystem.spamTimer[source] = setTimer(function(player)
							Chatsystem.messages[player] = 0
						end, 1000, 0, source)
					end
					
					Chatsystem.killSpamTimer[source] = setTimer(function(player)
						if(isTimer(Chatsystem.spamTimer[player]))then
							killTimer(Chatsystem.spamTimer[player])
							Chatsystem.messages[player] = 0
						end
					end, 10000, 1, source)
				
					local x, y, z = getElementPosition(source)
					for _, v in pairs(getElementsByType("player"))do
						if(isCharacterLoggedIn(v))then
							if(getElementInterior(source) == getElementInterior(v))then
								if(getElementDimension(source) == getElementDimension(v))then
									if(getDistanceBetweenPoints3D(x, y, z, getElementPosition(v)) <= NormalDistance)then
										outputChatBox(getCharacterName(source)..": "..message, v, 255, 255, 255)
									end
								end
							end
						end
					end
				end
				Chatsystem.messages[source] = Chatsystem.messages[source] + 1
			end
		end
	end
	cancelEvent()
end)

addCommandHandler("t",function(player, cmd, ...)
	if(isAdminLevel(player) >= 1)then
		local Text = convertText( ... )
		if(Text ~= nil)then
			if(Text ~= "" and #Text >= 1)then
				sendAdminMessage(getCharacterName(player), Text)
			end
		end
	end
end)

addCommandHandler("g",function(player, cmd, ...)
	if(isAdminLevel(player) >= 2)then
		local Text = convertText( ... )
		if(Text ~= nil)then
			if(Text ~= "" and #Text >= 1)then
				for _, v in pairs(getElementsByType("player"))do
					if(isCharacterLoggedIn(v))then
						outputChatBox("#ffffff[#ffff00!#ffffff] "..getCharacterName(player)..": "..Text, v, 255, 255, 255, true)
					end
				end
			end
		end
	end
end)

addCommandHandler("s",function(player, cmd, ...)
	local Text = convertText( ... )
	if(Text ~= nil)then
		if(Text ~= "" and #Text >= 1)then
			local x, y, z = getElementPosition(player)
			for _, v in pairs(getElementsByType("player"))do
				if(isCharacterLoggedIn(v))then
					if(getElementInterior(player) == getElementInterior(v))then
						if(getElementDimension(player) == getElementDimension(v))then
							if(getDistanceBetweenPoints3D(x, y, z, getElementPosition(v)) <= ScreamDistance)then
								outputChatBox("[!] "..getCharacterName(player)..": "..Text, v, 255, 255, 255)
							end
						end
					end
				end
			end
		end
	end
end)

addCommandHandler("m",function(player, cmd, ...)
	local Text = convertText( ... )
	if(Text ~= nil)then
		if(Text ~= "" and #Text >= 1)then
			if(hasPlayerItem(player,4) >= 1)then
				local x, y, z = getElementPosition(player)
				takeItem(player,4,1)
				for _, v in pairs(getElementsByType("player"))do
					if(isCharacterLoggedIn(v))then
						if(getElementInterior(player) == getElementInterior(v))then
							if(getElementDimension(player) == getElementDimension(v))then
								if(getDistanceBetweenPoints3D(x, y, z, getElementPosition(v)) <= MegaphoneDistance)then
									outputChatBox("#ffffff[#ff0000!#ffffff] "..getCharacterName(player)..": "..Text, v, 255, 255, 255, true)
								end
							end
						end
					end
				end
			end
		end
	end
end)

function addOfflineMessage(CharacterID, Text)
	if(CharacterID and Text)then
		local result = dbPoll(dbQuery(handler,"SELECT * FROM characters WHERE ID = '"..CharacterID.."'"), -1)
		if(#result >= 1)then

			dbExec(handler, "INSERT INTO offlinemessages (character_id, text) VALUES (?, ?)", CharacterID, Text)
		end
	end
end

function checkOfflineMessages(player)
	local result = dbPoll(dbQuery(handler,"SELECT * FROM offlinemessages WHERE character_id = '"..getCharacterID(player).."'"), -1)
	if(#result >= 1)then
		for _, v in pairs(result)do
			outputChatBox("[OFFLINE-MSG]: "..v["text"], player)
			dbExec(handler,"DELETE FROM offlinemessages WHERE ID = '"..v["ID"].."'")
		end
	end
end