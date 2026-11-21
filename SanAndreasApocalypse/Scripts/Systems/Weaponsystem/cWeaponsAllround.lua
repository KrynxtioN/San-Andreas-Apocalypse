Weaponsystem = {}
PlayerWeapons = {}
PlayerWeaponsOnHand = {}
PlayerSelectedWeapon = 0

addEvent("PlayerWeapons.update",true)
addEventHandler("PlayerWeapons.update",root,function(weapons,selectedWeapon)
	PlayerWeapons = weapons
	PlayerSelectedWeapon = selectedWeapon
	UpdatePlayerWeaponsForInventory(PlayerWeapons)
end)

addEvent("PlayerWeapons.updateHand",true)
addEventHandler("PlayerWeapons.updateHand",root,function(weapons,selectedWeapon)
	PlayerWeaponsOnHand = weapons
	PlayerSelectedWeapon = selectedWeapon
end)

function Weaponsystem.Settings()
	toggleControl("next_weapon",false)
	toggleControl("previous_weapon",false)
end
addEventHandler("onClientRender",root,Weaponsystem.Settings)

function Weaponsystem.mouseWheelUp()
	if(isCharacterLoggedIn() and isWindowOpen())then
		triggerServerEvent("PlayerWeapons.SwitchUp",localPlayer)
	end
end

function Weaponsystem.mouseWheelDown()
	if(isCharacterLoggedIn() and isWindowOpen())then
		triggerServerEvent("PlayerWeapons.SwitchDown",localPlayer)
	end
end

addEvent("Weaponsystem.setBindKeys",true)
addEventHandler("Weaponsystem.setBindKeys",root,function()
	bindKey("mouse_wheel_up","down",Weaponsystem.mouseWheelUp)
	bindKey("mouse_wheel_down","down",Weaponsystem.mouseWheelDown)
end)

local lastMinigunUpdate = 0
addEventHandler("onClientRender", root, function()
	if(isCharacterLoggedIn())then
		if(getPedWeapon(localPlayer) == 38 and getPedControlState("fire"))then
			local now = getTickCount()
			if(now - lastMinigunUpdate >= 250)then
				lastMinigunUpdate = now
				local ammo = getPedTotalAmmo(localPlayer)
				triggerServerEvent("PlayerWeapons.updateMinigun", localPlayer, ammo)
			end
		end
	end
end)