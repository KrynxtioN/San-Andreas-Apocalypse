PlayerKeys = {}

addEvent("updatePlayerKeys",true)
addEventHandler("updatePlayerKeys", root, function(keys)
	PlayerKeys = keys
	UpdatePlayerKeysForInventory()
end)

function getPlayerKeys(keyID)
	local amount = 0
	if(#PlayerKeys >= 1)then
		for i, v in ipairs(PlayerKeys) do
			if(v.key == keyID)then
				amount = v.amount
			end
		end
	end
	return amount
end