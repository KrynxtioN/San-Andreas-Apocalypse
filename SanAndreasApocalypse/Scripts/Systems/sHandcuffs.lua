Handcuffs = {playerStatus = {}, isCuffed = {}}

function Handcuffs.activateHandcuffs(player)
	if(not(Handcuffs.playerStatus[player]))then Handcuffs.playerStatus[player] = false end
	if(Handcuffs.playerStatus[player] == false)then
		if(hasPlayerItem(player,155) >= 1)then
			takeItem(player,155,1)
			Handcuffs.playerStatus[player] = true
		end
	else
		giveItem(player,155,1)
		Handcuffs.playerStatus[player] = false
	end
end

function hasPlayerHandcuffsInHand(player)
	if(not(Handcuffs.playerStatus[player]))then Handcuffs.playerStatus[player] = false end
	return Handcuffs.playerStatus[player]
end

addEventHandler("onPlayerClick", root, function(button, state, clickedElement)
    if(isCharacterLoggedIn(source))then
        if(button == "left" and state == "down")then
            if(clickedElement and isElement(clickedElement) and getElementType(clickedElement) == "player")then
				if(clickedElement ~= source)then
					local target = clickedElement
					if(isCharacterLoggedIn(target))then
						local x, y, z = getElementPosition(target)
						if(getDistanceBetweenPoints3D(x, y, z, getElementPosition(source)) <= 5)then
							if(Handcuffs.playerStatus[source] == true)then
								if(Handcuffs.isCuffed[target] == false)then
									Handcuffs.isCuffed[target] = true
									Handcuffs.playerStatus[source] = false
								else
									NPC.MeMessage(source,getText(source,"SHandcuffs1"))
								end
							end
						end
					end
				end
            end
        end
    end
end)

addEventHandler("onPlayerQuit",root,function()
	if(Handcuffs.playerStatus[source] and Handcuffs.playerStatus[source] == true)then
		giveItem(player,155,1)
		Handcuffs.playerStatus[source] = nil
	end
end)