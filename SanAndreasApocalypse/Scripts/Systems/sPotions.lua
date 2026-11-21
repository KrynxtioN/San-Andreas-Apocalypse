Potions = {
	HealthPotionTimer = {},
	safezonePotionTimer = {},
	speedboostPotionTimer = {},
	zombiestunningPotionTimer = {},

	safezoneMarker = {},
	safeZoneGreenMarker = {},

	ItemIDs = {
		[1] = 196,
		[2] = 195,
		[3] = 194,
		[4] = 197,
	}
}

local function startHUDCooldown(player, idx, seconds)
	if isElement(player) then
		triggerClientEvent(player, "HUD.startSkillCooldown", player, idx, seconds)
	end
end

function Potions.hasPotionItem(player, idx)
	local itemID = Potions.ItemIDs[idx]
	if not itemID then return false end

	return hasPlayerItem(player, itemID) >= 1
end

function Potions.takePotionItem(player, idx)
	local itemID = Potions.ItemIDs[idx]
	if not itemID then return false end

	if hasPlayerItem(player, itemID) >= 1 then
		takeItem(player, itemID, 1)
		return true
	end

	return false
end

function Potions.playerBindKey(player)
	bindKey(player, "1", "down", function(player)
		Potions.usePotionByIndex(player, 1)
	end)

	bindKey(player, "2", "down", function(player)
		Potions.usePotionByIndex(player, 2)
	end)

	bindKey(player, "3", "down", function(player)
		Potions.usePotionByIndex(player, 3)
	end)

	bindKey(player, "4", "down", function(player)
		Potions.usePotionByIndex(player, 4)
	end)
end

function Potions.isPotionOnCooldown(player, idx)
	if idx == 1 then
		return isTimer(Potions.HealthPotionTimer[player])
	elseif idx == 2 then
		return isTimer(Potions.safezonePotionTimer[player])
	elseif idx == 3 then
		return isTimer(Potions.speedboostPotionTimer[player])
	elseif idx == 4 then
		return isTimer(Potions.zombiestunningPotionTimer[player])
	end

	return true
end

function Potions.usePotionByIndex(player, idx)
	idx = tonumber(idx)
	if not idx then return end
	if not isElement(player) then return end

	if Potions.isPotionOnCooldown(player, idx) then
		return
	end

	if not Potions.hasPotionItem(player, idx) then
		return
	end

	if not Potions.takePotionItem(player, idx) then
		return
	end

	if idx == 1 then
		Potions.useHealthPotion(player)
	elseif idx == 2 then
		Potions.safezonePotion(player)
	elseif idx == 3 then
		Potions.speedboostPotion(player)
	elseif idx == 4 then
		Potions.zombiestunningPotion(player)
	end
end

addEvent("Potions.clientUsePotion", true)
addEventHandler("Potions.clientUsePotion", root, function(idx)
	if client ~= source then return end
	Potions.usePotionByIndex(client, idx)
end)

function Potions.useHealthPotion(player)
	if not isTimer(Potions.HealthPotionTimer[player]) then
		startHUDCooldown(player, 1, 30)

		local health = getElementHealth(player)
		setElementHealth(player, math.min(100, health + 25))

		Potions.HealthPotionTimer[player] = setTimer(function(player)
			if isElement(player) then
				local health = getElementHealth(player)
				setElementHealth(player, math.min(100, health + 5))
			end
		end, 1500, 10, player)
	end
end

function Potions.safezonePotion(player)
	if not isTimer(Potions.safezonePotionTimer[player]) then
		startHUDCooldown(player, 2, 90)

		if isElement(Potions.safezoneMarker[player]) then
			destroyElement(Potions.safezoneMarker[player])
		end

		if isElement(Potions.safeZoneGreenMarker[player]) then
			destroyElement(Potions.safeZoneGreenMarker[player])
		end

		local x, y, z = getElementPosition(player)

		Potions.safezoneMarker[player] = createColSphere(x, y, z, 5)
		attachElements(Potions.safezoneMarker[player], player, 0, 0, 1)

		Potions.safeZoneGreenMarker[player] = createMarker(x, y, z, "cylinder", 5, 0, 255, 0, 75)
		attachElements(Potions.safeZoneGreenMarker[player], player, 0, 0, -5)

		addEventHandler("onColShapeHit", Potions.safezoneMarker[player], function(hitElement)
			if getElementType(hitElement) == "ped" then
				if getElementData(hitElement, "zombie") == true then
					killPed(hitElement)
				end
			end
		end)

		Potions.safezonePotionTimer[player] = setTimer(function(player)
			if isElement(Potions.safezoneMarker[player]) then
				destroyElement(Potions.safezoneMarker[player])
			end

			if isElement(Potions.safeZoneGreenMarker[player]) then
				destroyElement(Potions.safeZoneGreenMarker[player])
			end

			Potions.safezoneMarker[player] = nil
			Potions.safeZoneGreenMarker[player] = nil
		end, 60000, 1, player)
	end
end

function Potions.speedboostPotion(player)
	if not isTimer(Potions.speedboostPotionTimer[player]) then
		startHUDCooldown(player, 3, 60)

		setPlayerCustomSpeed(player, 5)

		Potions.speedboostPotionTimer[player] = setTimer(function(player)
			if isElement(player) then
				setPlayerCustomSpeed(player, 0)
			end
		end, 10000, 1, player)
	end
end

function Potions.zombiestunningPotion(player)
	if not isTimer(Potions.zombiestunningPotionTimer[player]) then
		startHUDCooldown(player, 4, 30)

		local x, y, z = getElementPosition(player)

		if zombies and zombies.everyZombie then
			for _, v in pairs(zombies.everyZombie) do
				if isElement(v) then
					local px, py, pz = getElementPosition(v)

					if getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 25 then
						setElementFrozen(v, true)

						setTimer(function(zombie)
							if isElement(zombie) then
								setElementFrozen(zombie, false)
							end
						end, 5000, 1, v)
					end
				end
			end
		end

		Potions.zombiestunningPotionTimer[player] = setTimer(function() end, 10000, 1)
	end
end

function Potions.clearData(player)
	if isTimer(Potions.HealthPotionTimer[player]) then
		killTimer(Potions.HealthPotionTimer[player])
	end

	if isTimer(Potions.safezonePotionTimer[player]) then
		killTimer(Potions.safezonePotionTimer[player])
	end

	if isTimer(Potions.speedboostPotionTimer[player]) then
		killTimer(Potions.speedboostPotionTimer[player])
	end

	if isTimer(Potions.zombiestunningPotionTimer[player]) then
		killTimer(Potions.zombiestunningPotionTimer[player])
	end

	if isElement(Potions.safezoneMarker[player]) then
		destroyElement(Potions.safezoneMarker[player])
	end

	if isElement(Potions.safeZoneGreenMarker[player]) then
		destroyElement(Potions.safeZoneGreenMarker[player])
	end

	Potions.HealthPotionTimer[player] = nil
	Potions.safezonePotionTimer[player] = nil
	Potions.speedboostPotionTimer[player] = nil
	Potions.zombiestunningPotionTimer[player] = nil

	Potions.safezoneMarker[player] = nil
	Potions.safeZoneGreenMarker[player] = nil
end

addEventHandler("onPlayerWasted", root, function()
	Potions.clearData(source)
end)

addEventHandler("onPlayerQuit", root, function()
	Potions.clearData(source)
end)