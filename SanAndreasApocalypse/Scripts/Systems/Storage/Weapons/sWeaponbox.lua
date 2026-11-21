Weaponbox = {}

function Weaponbox.getData(player)
	if(not(player))then player = client end
	PlayerWeapons.loadInventory(player)
	
	local weaponsOnHand = {}
	local weaponsInStorage = {}
	local weaponsString = getPlayerData("characters",  "ID",  getCharacterID(player),  "weaponbox")
    
    if(weaponsString)then
        local weaponPairs = split(weaponsString,  " | ")

        for _,  weaponPair in ipairs(weaponPairs) do
            local weaponInfo = split(weaponPair,  ",")
            local weaponID = tonumber(weaponInfo[1])
            local ammo = tonumber(weaponInfo[2])
            
            table.insert(weaponsInStorage,  {weapon = weaponID,  ammo = ammo})
        end
    end
	
	for _,v in pairs(PlayerWeaponsOnHand[player])do
		table.insert(weaponsOnHand,{weapon = v[1], ammo = v[2], id = v[4]})
	end
	triggerClientEvent(player, "Weaponbox.updateData", player, weaponsOnHand, weaponsInStorage)
end
addEvent("Weaponbox.getData", true)
addEventHandler("Weaponbox.getData", root, Weaponbox.getData)

addEvent("Weaponbox.open",true)
addEventHandler("Weaponbox.open",root,function()
	if(tonumber(apocalypseGetElementData(client, "level")) >= 10)then
		triggerClientEvent(client, "Weaponbox.open", client)
	else NPC.NormalMessage(client,getText(client,"SWeaponbox1"))end
end)

addEvent("Weaponbox.storeWeapon", true)
addEventHandler("Weaponbox.storeWeapon", root, function(weaponName, ammo, ID)
    local weaponID = getWeaponIDFromName(weaponName)
    PlayerWeapons.DeleteWeapon(client,ID)

    local weaponsString = getPlayerData("characters", "ID", getCharacterID(client), "weaponbox")
    local weaponPairs = {}
    if(weaponsString ~= "")then
        weaponPairs = split(weaponsString, " | ")
    end

	local max_weapons = 5
    if(#weaponPairs < max_weapons)then
        table.insert(weaponPairs, weaponID .. "," .. ammo)

        local newWeaponsString = table.concat(weaponPairs, " | ")
        dbExec(handler, "UPDATE characters SET weaponbox = '" .. newWeaponsString .. "' WHERE ID = '" .. getCharacterID(client) .. "'")

        Weaponbox.getData(client)
    else
        createInfobox(client,getText(client,"SWeaponbox2"):format(max_weapons))
    end
end)

addEvent("Weaponbox.withdrawWeapon",  true)
addEventHandler("Weaponbox.withdrawWeapon", root, function(weaponName, ammo)
    local weaponID = getWeaponIDFromName(weaponName)

    local weaponsString = getPlayerData("characters",  "ID",  getCharacterID(client),  "weaponbox")
    local weaponPairs = {}

    if(weaponsString ~= "")then
        weaponPairs = split(weaponsString,  " | ")
    end

    local ammo = 0
    for i,  v in ipairs(weaponPairs) do
        local weaponInfo = split(v,  ",")
        if(tonumber(weaponInfo[1]) == weaponID)then
            ammo = tonumber(weaponInfo[2])
            table.remove(weaponPairs,  i)
            break
        end
    end
	PlayerWeapons.addNewWeapon(client,  weaponID,  ammo)
    local newWeaponsString = table.concat(weaponPairs,  " | ")

	dbExec(handler, "UPDATE characters SET weaponbox = '"..newWeaponsString.."' WHERE ID = '"..getCharacterID(client).."'")
	Weaponbox.getData(client)
end)