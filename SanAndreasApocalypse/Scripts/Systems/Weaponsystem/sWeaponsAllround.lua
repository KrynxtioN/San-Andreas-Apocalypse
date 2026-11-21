PlayerWeapons = {}
PlayerSelectedWeapon = {}
PlayerWeaponsSwitchTimer = {}
PlayerWeaponsOnHand = {}

local function createSwitchTimer(player)
    if not PlayerWeaponsSwitchTimer[player] then
        PlayerWeaponsSwitchTimer[player] = setTimer(function()
            PlayerWeaponsSwitchTimer[player] = nil
        end, 50, 1)
    end
end

function PlayerWeapons.addNewWeapon(player, weaponID, ammo)
    if player and weaponID and ammo then
        local CharacterID = getCharacterID(player)
        local durability = 100

        local result = dbPoll(dbQuery(handler, "SELECT * FROM player_weapons WHERE character_id = ? AND weapon_id = ?", CharacterID, weaponID), -1)
        if result and #result > 0 then
            local query = dbExec(handler,
                "UPDATE player_weapons SET ammo = ammo + ? WHERE character_id = ? AND weapon_id = ?",
                ammo, CharacterID, weaponID)
            if query then
                PlayerWeapons.loadInventory(player)
            end
        else
            if hasPlayerFreeWeaponSlot(player) then
                local query = dbExec(handler,
                    "INSERT INTO player_weapons (character_id, weapon_id, ammo, durability, inHand) VALUES (?,?,?,?,?)",
                    CharacterID, weaponID, ammo, durability, 0)
                if query then
                    PlayerWeapons.loadInventory(player)
                end
            end
        end
    end
end

function PlayerWeapons.loadInventory(player)
    PlayerWeapons[player] = {}
    PlayerWeaponsOnHand[player] = {}
	local WeaponCounter = 0
    local result = dbPoll(dbQuery(handler, "SELECT * FROM player_weapons WHERE character_id = ?", getCharacterID(player)), -1)
    if result and #result > 0 then
        for _, v in ipairs(result) do
            PlayerWeapons[player][v["ID"]] = {
                v["weapon_id"],
                v["ammo"],
                v["durability"],
                v["ID"],
                v["inHand"],
            }
            if v["inHand"] == 1 then
				WeaponCounter = WeaponCounter + 1
                PlayerWeaponsOnHand[player][WeaponCounter] = {
                    v["weapon_id"],
                    v["ammo"],
                    v["durability"],
                    v["ID"],
                    v["inHand"],
                }
            end
        end
    end
	
    PlayerSelectedWeapon[player] = 0
    triggerClientEvent(player, "PlayerWeapons.update", player, PlayerWeapons[player],PlayerSelectedWeapon[player])
end

function PlayerWeapons.DeleteWeapon(player,ID)
    local ID = tonumber(ID)
    if(ID and ID > 0)then
        dbExec(handler, "DELETE FROM player_weapons WHERE ID = ?", ID)
        takeAllWeapons(player)
        PlayerWeapons.loadInventory(player)
    end
end

function PlayerWeapons.removeCurrentWeapon(player)
    if not player or not PlayerSelectedWeapon[player] or PlayerSelectedWeapon[player] == 0 then return end

    local selectedWeaponIndex = PlayerSelectedWeapon[player]
    local weaponData = PlayerWeaponsOnHand[player] and PlayerWeaponsOnHand[player][selectedWeaponIndex]
    if not weaponData then return end

    local dbID = weaponData[4]
    dbExec(handler, "DELETE FROM player_weapons WHERE ID = ?", dbID)
    takeAllWeapons(player)
    PlayerWeapons.loadInventory(player)
end

addEvent("PlayerWeapons.takeWeapon", true)
addEventHandler("PlayerWeapons.takeWeapon", root, function(id)
    takeAllWeapons(client)
    dbExec(handler, "UPDATE player_weapons SET inHand = '1' WHERE ID = ?", id)
    PlayerWeapons.loadInventory(client)
end)

addEvent("PlayerWeapons.storeWeapon", true)
addEventHandler("PlayerWeapons.storeWeapon", root, function(id)
	takeAllWeapons(client)
	dbExec(handler, "UPDATE player_weapons SET inHand = '0' WHERE ID = ?", id)
	PlayerWeapons.loadInventory(client)
end)

addEvent("PlayerWeapons.SwitchUp", true)
addEventHandler("PlayerWeapons.SwitchUp", root, function()
    if not PlayerWeaponsSwitchTimer[client] then
        if not PlayerSelectedWeapon[client] then PlayerSelectedWeapon[client] = 0 end

        local weapons = {}
        for _, weapon in pairs(PlayerWeaponsOnHand[client]) do
            table.insert(weapons, weapon)
        end

        if #weapons > 0 and PlayerSelectedWeapon[client] < #weapons then
            createSwitchTimer(client)
            PlayerSelectedWeapon[client] = PlayerSelectedWeapon[client] + 1

            local selectedWeapon = weapons[PlayerSelectedWeapon[client]]
            takeAllWeapons(client)
            if selectedWeapon[1] ~= 0 then
                giveWeapon(client, tonumber(selectedWeapon[1]), tonumber(selectedWeapon[2]), true)
            end

            triggerClientEvent(client, "PlayerWeapons.updateHand", client, weapons, PlayerSelectedWeapon[client])
            triggerClientEvent(client, "Inventory.showWeaponBar", client)
        end
    end
end)

addEvent("PlayerWeapons.SwitchDown", true)
addEventHandler("PlayerWeapons.SwitchDown", root, function()
    if not PlayerWeaponsSwitchTimer[client] then
        if not PlayerSelectedWeapon[client] then PlayerSelectedWeapon[client] = 0 end

        local weapons = {}
        for _, weapon in pairs(PlayerWeaponsOnHand[client]) do
            table.insert(weapons, weapon)
        end

        if #weapons > 0 and PlayerSelectedWeapon[client] > 0 then
            createSwitchTimer(client)
            PlayerSelectedWeapon[client] = PlayerSelectedWeapon[client] - 1
			takeAllWeapons(client)
			
			if(PlayerSelectedWeapon[client] > 0)then
				local selectedWeapon = weapons[PlayerSelectedWeapon[client]]
				if selectedWeapon[1] ~= 0 then
					giveWeapon(client, tonumber(selectedWeapon[1]), tonumber(selectedWeapon[2]), true)
				end
			end

            triggerClientEvent(client, "PlayerWeapons.updateHand", client, weapons, PlayerSelectedWeapon[client])
            triggerClientEvent(client, "Inventory.showWeaponBar", client)
        end
    end
end)

function PlayerWeapons.shoot(player)
    if (PlayerSelectedWeapon[player] and PlayerSelectedWeapon[player] > 0) then
        local selectedWeapon = tonumber(PlayerSelectedWeapon[player])
        local weaponData = PlayerWeaponsOnHand[player][selectedWeapon]
        if (weaponData) then
            local ammo = weaponData[2]
            if (ammo > 0) then
                ammo = ammo - 1
                PlayerWeaponsOnHand[player][selectedWeapon][2] = ammo

                if (ammo == 0) then
                    dbExec(handler, "DELETE FROM player_weapons WHERE ID = ?", weaponData[4])

                    PlayerWeapons.loadInventory(player)
                else
                    dbExec(handler, "UPDATE player_weapons SET ammo = ? WHERE ID = ?", ammo, weaponData[4])
                    
                    local weapons = {}
                    for _, weapon in pairs(PlayerWeaponsOnHand[player]) do
                        table.insert(weapons, weapon)
                    end
                    
                    triggerClientEvent(player, "PlayerWeapons.updateHand", player, weapons, PlayerSelectedWeapon[player])
                end
            end
        end
    end
end

function hasPlayerFreeWeaponSlot(player)
	if(#PlayerWeapons[player] + #PlayerWeaponsOnHand[player] < 40)then
		return true
	else
		return false
	end
end

addEventHandler("onPlayerWeaponFire", root, function(ammo, weaponID, ammoInClip)
    PlayerWeapons.shoot(source)
end)

addEvent("PlayerWeapons.updateMinigun", true)
addEventHandler("PlayerWeapons.updateMinigun", root, function(newAmmo)
    if not tonumber(newAmmo) then return end
    local weapons = PlayerWeaponsOnHand[client]
    if not weapons then return end

    for index, weaponData in pairs(weapons) do
        local weaponID = tonumber(weaponData[1])
        if weaponID == 38 then
            PlayerWeaponsOnHand[client][index][2] = newAmmo

            local dbID = weaponData[4]
            dbExec(handler, "UPDATE player_weapons SET ammo = ? WHERE ID = ?", newAmmo, dbID)

            local selected = PlayerSelectedWeapon[client] or 0
            triggerClientEvent(client, "PlayerWeapons.updateHand", client, weapons, selected)
            break
        end
    end
end)