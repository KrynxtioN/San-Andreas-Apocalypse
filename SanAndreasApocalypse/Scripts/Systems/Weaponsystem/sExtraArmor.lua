ExtraArmor = {
	["Data"] = {
		[146] = 10,
		[147] = 25,
	},
}

function ExtraArmor.loadPlayerExtraArmor(player)
	local extra_armor = tonumber(getPlayerData("characters","id",getCharacterID(player),"extra_armor")) or 0
	apocalypseSetElementData(player,"extra_armor",extra_armor)
end

function takePlayerExtraArmor(player, amount)
    amount = tonumber(amount) or 0

    local extra_armor = tonumber(apocalypseGetElementData(player,"extra_armor")) or 0
    if extra_armor <= 0 or amount <= 0 then
        damagePlayer(player, amount)
        return
    end

    if extra_armor >= amount then
        local newEA = extra_armor - amount
        apocalypseSetElementData(player,"extra_armor", newEA)
        dbExec(handler, "UPDATE characters SET extra_armor = ? WHERE ID = ?", newEA, getCharacterID(player))
        return
    else
        apocalypseSetElementData(player,"extra_armor", 0)
        dbExec(handler, "UPDATE characters SET extra_armor = ? WHERE ID = ?", 0, getCharacterID(player))
        damagePlayer(player, amount - extra_armor)
    end
end

function addPlayerExtraArmor(player,item)
	if(getPedArmor(player) >= 95)then
		if(apocalypseGetElementData(player,"extra_armor") < 100)then
			local amount = ExtraArmor["Data"][tonumber(item)]
			takeItem(player,item,1)
			local extra_armor = apocalypseGetElementData(player,"extra_armor")
			apocalypseSetElementData(player,"extra_armor",extra_armor + amount)
			dbExec(handler, "UPDATE characters SET extra_armor = ? WHERE ID = ?", extra_armor + amount, getCharacterID(player))
			if((extra_armor + amount) > 100)then
				apocalypseSetElementData(player,"extra_armor",100)
				dbExec(handler, "UPDATE characters SET extra_armor = ? WHERE ID = ?", 100, getCharacterID(player))
			end
		end
	end
end