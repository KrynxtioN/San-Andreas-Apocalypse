function setPlayerCustomSpeed(player,speed)
	if isElement(player) and getElementType(player) == 'player' then 
		if speed and type(speed) == 'number' and speed >= 0 and speed <= 10 then
			triggerClientEvent(player,'onClientSetSpeed',player,speed)
			if speed > 0 then
				if getPlayerSpeed(player) ~= speed then
					return setElementData(player,'player.speed',speed,false)
				end
			else
				if getPlayerSpeed(player) > 0 then 
					return removeElementData(player,'player.speed')
				end
			end
		end
	end
	return false
end

function getPlayerSpeed(player)
	if isElement(player) and getElementType(player) == 'player' then 
		if hasElementData(player,'player.speed') then 
			return getElementData(player,'player.speed')
		end
		return 0
	end
	return false
end

addEventHandler('onResourceStop',resourceRoot,
	function()
		for id,player in ipairs(getElementsByType('player')) do
			if hasElementData(player,'player.speed') then
				removeElementData(player,'player.speed')
			end
		end
end)