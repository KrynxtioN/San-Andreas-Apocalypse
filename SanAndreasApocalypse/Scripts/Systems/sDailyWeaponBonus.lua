DailyWeaponBonus = {}
DailyWeaponBonus.pickup = createPickup(-228.58184814453,1397.9376220703,28.359519958496,3,1239,50)
setElementInterior(DailyWeaponBonus.pickup,18)

addEventHandler("onPickupHit",DailyWeaponBonus.pickup,function(player)
	if(getElementType(player) == "player")then
		if(getElementDimension(player) == getElementDimension(source))then
			local result = tonumber(getPlayerData("characters","ID",getCharacterID(player),"daily_weapon_bonus"))
			if(result == 0)then
				createInfobox(player,getText(player,"SDailyWeaponBonus2"))
				dbExec(handler,"UPDATE characters SET daily_weapon_bonus = '1' WHERE ID = '"..getCharacterID(player).."'")
				PlayerWeapons.addNewWeapon(player,22,250)
			else
				createInfobox(player,getText(player,"SDailyWeaponBonus1"))
			end
		end
	end
end)