setWeaponProperty(33,"poor","weapon_range",250)
setWeaponProperty(33,"std","weapon_range",250)
setWeaponProperty(33,"pro","weapon_range",200)
setWeaponProperty(31,"pro","weapon_range",100)
setWeaponProperty(31,"pro","accuracy",0.9)
setWeaponProperty(24,"pro","accuracy",1.6)

local weaponDamages = {
	[0] = { [3] = 5, [4] = 5, [5] = 5, [6] = 5, [7] = 5, [8] = 5, [9] = 5},
	[1] = { [3] = 6, [4] = 6, [5] = 6, [6] = 6, [7] = 6, [8] = 6, [9] = 6},
	[2] = { [3] = 6, [4] = 6, [5] = 6, [6] = 6, [7] = 6, [8] = 6, [9] = 6},
	[3] = { [3] = 6, [4] = 6, [5] = 6, [6] = 6, [7] = 6, [8] = 6, [9] = 6},
	[4] = { [3] = 6, [4] = 6, [5] = 6, [6] = 6, [7] = 6, [8] = 6, [9] = 6},
	[5] = { [3] = 6, [4] = 6, [5] = 6, [6] = 6, [7] = 6, [8] = 6, [9] = 6},
	[6] = { [3] = 6, [4] = 6, [5] = 6, [6] = 6, [7] = 6, [8] = 6, [9] = 6},
	[7] = { [3] = 6, [4] = 6, [5] = 6, [6] = 6, [7] = 6, [8] = 6, [9] = 6},
	[8] = { [3] = 6, [4] = 6, [5] = 6, [6] = 6, [7] = 6, [8] = 6, [9] = 6},
	[22] = { [3] = 10, [4] = 10, [5] = 8, [6] = 8, [7] = 8, [8] = 8, [9] = 15}, 
	[23] = { [3] = 10, [4] = 10, [5] = 8, [6] = 8, [7] = 8, [8] = 8, [9] = 15}, 
	[24] = { [3] = 49, [4] = 40, [5] = 29, [6] = 29, [7] = 35, [8] = 35, [9] = 75},
	[25] = { [3] = 25, [4] = 25, [5] = 20, [6] = 20, [7] = 20, [8] = 20, [9] = 35}, 
	[26] = { [3] = 30, [4] = 30, [5] = 20, [6] = 20, [7] = 20, [8] = 20, [9] = 40}, 
	[27] = { [3] = 30, [4] = 30, [5] = 20, [6] = 20, [7] = 20, [8] = 20, [9] = 40}, 
	[28] = { [3] = 8, [4] = 8, [5] = 5, [6] = 5, [7] = 5, [8] = 5, [9] = 10}, 
	[29] = { [3] = 9, [4] = 9, [5] = 8, [6] = 8, [7] = 8, [8] = 8, [9] = 12}, 
	[32] = { [3] = 8, [4] = 8, [5] = 5, [6] = 5, [7] = 5, [8] = 5, [9] = 10}, 
	[30] = { [3] = 10, [4] = 10, [5] = 8, [6] = 8, [7] = 8, [8] = 8, [9] = 14}, 
	[31] = { [3] = 9, [4] = 9, [5] = 7, [6] = 7, [7] = 7, [8] = 7, [9] = 12}, 
	[33] = { [3] = 15, [4] = 15, [5] = 12, [6] = 12, [7] = 12, [8] = 12, [9] = 20}, 
	[34] = { [3] = 15, [4] = 15, [5] = 12, [6] = 12, [7] = 12, [8] = 12, [9] = 200}, 
	[35] = { [3] = 80, [4] = 80, [5] = 50, [6] = 50, [7] = 50, [8] = 50, [9] = 130}, 
	[36] = { [3] = 80, [4] = 80, [5] = 50, [6] = 50, [7] = 50, [8] = 50, [9] = 130}, 
	[37] = { [3] = 8, [4] = 8, [5] = 5, [6] = 5, [7] = 5, [8] = 5, [9] = 12}, 
	[38] = { [3] = 8, [4] = 8, [5] = 6, [6] = 6, [7] = 6, [8] = 6, [9] = 12}, 
	[16] = { [3] = 80, [4] = 80, [5] = 50, [6] = 50, [7] = 50, [8] = 50, [9] = 130}, 
	[17] = { [3] = 5, [4] = 5, [5] = 5, [6] = 5, [7] = 5, [8] = 5, [9] = 5}, 
	[18] = { [3] = 5, [4] = 5, [5] = 5, [6] = 5, [7] = 5, [8] = 5, [9] = 5}, 
	[39] = { [3] = 100, [4] = 100, [5] = 100, [6] = 100, [7] = 100, [8] = 100, [9] = 100},
	[41] = { [3] = 5, [4] = 5, [5] = 5, [6] = 5, [7] = 5, [8] = 5, [9] = 5}, 
	[42] = { [3] = 5, [4] = 5, [5] = 5, [6] = 5, [7] = 5, [8] = 5, [9] = 5}, 
	[10] = { [3] = 5, [4] = 5, [5] = 5, [6] = 5, [7] = 5, [8] = 5, [9] = 5}, 
	[11] = { [3] = 5, [4] = 5, [5] = 5, [6] = 5, [7] = 5, [8] = 5, [9] = 5}, 
	[12] = { [3] = 5, [4] = 5, [5] = 5, [6] = 5, [7] = 5, [8] = 5, [9] = 5}, 
	[14] = { [3] = 5, [4] = 5, [5] = 5, [6] = 5, [7] = 5, [8] = 5, [9] = 5}, 
	[15] = { [3] = 5, [4] = 5, [5] = 5, [6] = 5, [7] = 5, [8] = 5, [9] = 5},
}

addEvent("damageCalcServer",true)
addEventHandler("damageCalcServer",root,function(ax,ay,az,weapon,bodypart,loss,player)
    triggerClientEvent(player,"showBloodFlash",player)

    local basicDMG = weaponDamages[weapon] and weaponDamages[weapon][bodypart]
    if not basicDMG then return end

    local x2,y2,z2 = getElementPosition(player)
    local dist = getDistanceBetweenPoints3D(ax,ay,az,x2,y2,z2)

    local multiply = 1
    if weapon == 24 and dist <= 1 then multiply = 0.5 end

    local ea = tonumber(apocalypseGetElementData(player,"extra_armor")) or 0
    local dmg = basicDMG * multiply

    if ea >= 1 then
        takePlayerExtraArmor(player, dmg)
    else
        damagePlayer(player, dmg)
    end
end)

function damagePlayer(player,amount)
	local armor = getPedArmor(player)
	local health = getElementHealth(player)
	if(armor > 0)then
		if(armor >= amount)then
			setPedArmor(player,armor - amount)
		else
			setPedArmor(player,0)
			local amount = math.abs(armor - amount)
			local newHealth = health - amount
			setElementHealth(player,newHealth)
			if(newHealth <= 0)then
				killPed(player)
				return
			end
		end
	else
		if(health - amount <= 0)then
			killPed(player)
			return
		end
		setElementHealth(player,health - amount)
	end
end