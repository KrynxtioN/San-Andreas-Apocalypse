WeaponFactory = {
	["Costs"] = {
		[1] = 1,
		[2] = 2,
		[3] = 2,
		[4] = 4,
	},
	["Ammo"] = {
		[1] = 44,
		[2] = 45,
		[3] = 46,
		[4] = 47,
	},
	["Name"] = {
		["EN"] = {
			[1] = "Ammo: Handguns",
			[2] = "Ammo: Submachine Guns",
			[3] = "Ammo: Assault Rifles",
			[4] = "Ammo: Rifles",
		},
		["DE"] = {
			[1] = "Munition: Pistolen",
			[2] = "Munition: Maschinenpistolen",
			[3] = "Munition: Sturmgewehre",
			[4] = "Munition: Gewehre",
		},
		["RU"] = {
			[1] = "Патроны: Пистолеты",
			[2] = "Патроны: ПП",
			[3] = "Патроны: Штурмовые винтовки",
			[4] = "Патроны: Винтовки",
		},
		["PT"] = {
			[1] = "Munição: Pistolas",
			[2] = "Munição: Submetralhadoras",
			[3] = "Munição: Rifles de Assalto",
			[4] = "Munição: Rifles",
		},
	},
}

addEvent("WeaponFactory.craft",true)
addEventHandler("WeaponFactory.craft",root,function(ammoType,amount,inv)
	local ammoType, amount = tonumber(ammoType), tonumber(amount)
	local costsWeaponparts = WeaponFactory["Costs"][ammoType] * amount
	if(inv)then costsWeaponparts = costsWeaponparts * 2 end
	if(hasPlayerItem(client,22) >= costsWeaponparts)then
		takeItem(client,22,costsWeaponparts)
		giveItem(client,WeaponFactory["Ammo"][ammoType],amount)
		NPC.MeMessage(client,getText(client,"SWeaponFactory2"):format(amount,WeaponFactory["Name"][apocalypseGetElementData(client,"language") or "EN"][ammoType]))
	else
		NPC.MeMessage(client,getText(client,"SWeaponFactory1"))
	end
end)

function PlayerWeapons.itemReload(player,item)
	local weapon = getPedWeapon(player)
	local item = tonumber(item)
	if(item == 44)then
		if(weapon == 22 or weapon == 23 or weapon == 24)then
			PlayerWeapons.addNewWeapon(player,weapon,1)
			takeItem(player,44,1)
		end
	end
	if(item == 45)then
		if(weapon == 28 or weapon == 29 or weapon == 32)then
			PlayerWeapons.addNewWeapon(player,weapon,1)
			takeItem(player,45,1)
		end
	end
	if(item == 46)then
		if(weapon == 30 or weapon == 31)then
			PlayerWeapons.addNewWeapon(player,weapon,1)
			takeItem(player,46,1)
		end
	end
	if(item == 47)then
		if(weapon == 33 or weapon == 34)then
			PlayerWeapons.addNewWeapon(player,weapon,1)
			takeItem(player,47,1)
		end
	end
end