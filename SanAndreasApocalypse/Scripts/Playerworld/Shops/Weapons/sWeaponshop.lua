addEvent("Weaponshop.buyGun", true)
addEventHandler("Weaponshop.buyGun", root, function(weaponID, weapon, ammo, price, level)
	local price = tonumber(price)
	if(hasPlayerFreeWeaponSlot(client) == true)then
		if(tonumber(apocalypseGetElementData(client, "level")) >= tonumber(level))then
			if(tonumber(apocalypseGetElementData(client,"tutorialtask")) == 5)then
				price = 0
			end
			if(tonumber(apocalypseGetElementData(client, "money")) >= tonumber(price))then
				apocalypseSetElementData(client, "money", apocalypseGetElementData(client, "money")-tonumber(price))
				PlayerWeapons.addNewWeapon(client, weaponID, ammo)
				NPC.NormalMessage(client, getText(client, "SWeaponshop3"))
				setAchievement(client, 3)
				outputLog(getPlayerName(client).." hat sich die Waffe mit der ID "..weaponID.." für $"..price.." gekauft","Weaponshop",getCharacterID(client))
				if(apocalypseGetElementData(client, "tutorialtask") == 5)then
					Tutorial.nextTask(client)
					triggerClientEvent(client,"createActivitiesInformationText",client,getText(client,"STutorial5"))
				end
			else NPC.NormalMessage(client, getText(client, "SWeaponshop2"):format(price))end
		else NPC.NormalMessage(client, getText(client, "SWeaponshop1"):format(level))end
	end
end)

addEventHandler("onPlayerWasted", root, function() triggerClientEvent(source, "Weaponshop.close", source) end)