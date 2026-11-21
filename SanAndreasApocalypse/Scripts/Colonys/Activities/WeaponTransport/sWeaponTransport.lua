WeaponTransport = {
	Cooldown = false,
	vehicle = {},
	vehicleTimer = {},
	missions = {},
	nextMissionID = 1,
	DeliveryTime = 15 * 60,
	["BoatSpawns"] = {
		[1] = {2129.7939453125,-134.8837890625,0,0,0,130},
		[2] = {2127.0454101562,-131.68200683594,0,0,0,132},
		[3] = {2124.0041503906,-128.69850158691,0,0,0,130},
		[4] = {2121.5004882812,-125.50180053711,0,0,0,130},
		[5] = {2118.701171875,-122.10150146484,0,0,0,130},
	},
	["Delivery"] = {
		[1] = {1627.9813232422,566.20782470703,-0.55000001192093},
	},
}

local Achievements = {
	{5,449},
	{10,550},
	{25,551},
	{50,552},
	{75,553},
	{125,554},
	{175,555},
	{250,556},
}

local Info_Marker = createMarker(2161.970703125,-102.49774169922,2.75,"cylinder",10,0,0,0,0)

addEventHandler("onMarkerHit",Info_Marker,function(player)
	if(getElementType(player) == "player")then
		if(getElementDimension(player) == getElementDimension(source))then
			triggerClientEvent(player, "showInformationHelpBar", player, getText(player, "SWeaponTransport10"), getText(player, "SWeaponTransport11"))
		end
	end
end)

WeaponTransport.PlayerMarker = createMarker(2162.1118164062,-102.27681732178,2.75, "cylinder", 6.5, 255, 0, 0, 0)

function WeaponTransport.destroyPlayerVehicle(player, deleteClient)
	local veh = WeaponTransport.vehicle[player]
	if veh and isElement(veh) then
		triggerClientEvent(root, "WeaponTransport.removeTimedVehicle", root, veh)

		local timer = WeaponTransport.vehicleTimer[player]
		if isTimer(timer) then
			killTimer(timer)
		end
		WeaponTransport.vehicleTimer[player] = nil

		destroyElement(veh)
	end

	WeaponTransport.vehicle[player] = nil

	if deleteClient then
		triggerClientEvent(player, "WeaponTransport.deleteClient", player)
	end
end

function WeaponTransport.checkMissionFailed(missionID)
	local m = WeaponTransport.missions[missionID]
	if not m then return end

	local hasBoatLeft = false

	for _, mem in ipairs(m.players) do
		local veh = WeaponTransport.vehicle[mem]
		if veh and isElement(veh) then
			hasBoatLeft = true
			break
		end
	end

	if not hasBoatLeft then
		for _, mem in ipairs(m.players) do
			if isElement(mem) then
				triggerClientEvent(mem, "WeaponTransport.deleteClient", mem)
				NPC.MeMessage(mem, getText(mem,"SWeaponTransport12"))
			end
		end

		WeaponTransport.missions[missionID] = nil
	end
end

addEvent("WeaponTransport.loadGUI", true)
addEventHandler("WeaponTransport.loadGUI", root, function()
	if(WeaponTransport.Cooldown == false)then
		local t = WeaponTransport.getPlayerInMarker()
		triggerClientEvent(client, "WeaponTransport.loadGUI", client, t)
		NPC.NormalMessage(client,getText(client,"SWeaponTransport1"))
	else
		NPC.NormalMessage(client,getText(client,"SWeaponTransport9"))
	end
end)

addEvent("WeaponTransport.refreshGUI", true)
addEventHandler("WeaponTransport.refreshGUI", root, function()
    local t = WeaponTransport.getPlayerInMarker()
    triggerClientEvent(client, "WeaponTransport.refreshGUI", client, t)
end)

function WeaponTransport.getPlayerInMarker()
    local t = {}
    for _, pl in pairs(getElementsByType("player")) do
        if isElementWithinMarker(pl, WeaponTransport.PlayerMarker) then
            table.insert(t, getPlayerName(pl))
        end
    end
    return t
end

addEvent("WeaponTransport.start", true)
addEventHandler("WeaponTransport.start", root, function(playerNames)
    if not playerNames or #playerNames < 1 then
        return NPC.NormalMessage(client,getText(client,"SWeaponTransport2"))
    elseif #playerNames > 3 then
        return NPC.NormalMessage(client,getText(client,"SWeaponTransport3"))
    end

    local valid = {}
    for _, name in ipairs(playerNames) do
        local pl = getPlayerFromName(name)
        if pl and isElement(pl) and isCharacterLoggedIn(pl) and isElementWithinMarker(pl, WeaponTransport.PlayerMarker) then
            local inM = false
            for _, m in pairs(WeaponTransport.missions) do
                for _, mem in ipairs(m.players) do
                    if mem == pl then inM = true; break end
                end
                if inM then break end
            end
            if not inM then
                table.insert(valid, pl)
            else
                NPC.NormalMessage(client, getText(client,"SWeaponTransport4"):format(getPlayerName(pl)))
            end
        end
    end
    if #valid < 1 then
        return NPC.NormalMessage(client,getText(client,"SWeaponTransport5"):format(#valid))
    end

    local id = WeaponTransport.nextMissionID
    WeaponTransport.nextMissionID = id + 1

    local dp = math.random(1, #WeaponTransport["Delivery"])
    WeaponTransport.missions[id] = { players = valid, delivered = {}, delivery = dp }
	local randomSellerID = math.random(1,1)

    for idx, pl in ipairs(valid) do
        local veh = WeaponTransport.createBoat(pl, idx, dp, randomSellerID)
        apocalypseSetElementData(veh, "WPMissionID", id)
    end

    for _, pl in ipairs(valid) do
        NPC.NormalMessage(pl, getText(pl,"SWeaponTransport6"))
    end
	
	WeaponTransport.Cooldown = true
	setTimer(function() WeaponTransport.Cooldown = false end,300000,1)
end)

function WeaponTransport.createBoat(player, spawnPoint, deliveryPoint, randomSellerID)
    local s = WeaponTransport["BoatSpawns"][spawnPoint]
    local veh = createVehicle(473, s[1],s[2],s[3],s[4],s[5],s[6])
    WeaponTransport.vehicle[player] = veh
    warpPedIntoVehicle(player, veh)
	setAchievement(player,402)
    apocalypseSetElementData(veh, "WPOwner", player)
    apocalypseSetElementData(veh, "WPDelivery", deliveryPoint)
	triggerClientEvent(player,"closeWindow",player)

	local expireAt = getRealTime().timestamp + WeaponTransport.DeliveryTime
	setElementData(veh, "WeaponTransport.expireAt", expireAt)
	triggerClientEvent(root, "WeaponTransport.addTimedVehicle", root, veh, expireAt)

	local dp = apocalypseGetElementData(veh, "WPDelivery")
    local t = WeaponTransport["Delivery"][dp]
	apocalypseSetElementData(veh,"WeaponTransportSellerID",randomSellerID)
	
    if tonumber(apocalypseGetElementData(player, "colony")) >= 1 and ColonyWarehouse.hasColonyWarehouse(player) then
		triggerClientEvent(player, "WeaponTransport.createDeliveryWarehouse", player, t[1],t[2],t[3])
    else
        triggerClientEvent(player, "WeaponTransport.createSeller", player, randomSellerID)
    end

	WeaponTransport.vehicleTimer[player] = setTimer(function(plr)
		local boat = WeaponTransport.vehicle[plr]
		if boat and isElement(boat) then
			setElementHealth(boat, 0)
		end
	end, WeaponTransport.DeliveryTime * 1000, 1, player)

    addEventHandler("onVehicleExit", veh, function(pl)
        triggerClientEvent(pl, "WeaponTransport.deleteClient", pl)
    end)

    addEventHandler("onVehicleEnter", veh, function(pl)
        local dp = apocalypseGetElementData(source, "WPDelivery")
        local t = WeaponTransport["Delivery"][dp]

        if tonumber(apocalypseGetElementData(pl, "colony")) >= 1 and ColonyWarehouse.hasColonyWarehouse(pl) then
            triggerClientEvent(pl, "WeaponTransport.createDeliveryWarehouse", pl, t[1],t[2],t[3])
        else
			local randomSellerID = apocalypseGetElementData(source,"WeaponTransportSellerID")
            triggerClientEvent(pl, "WeaponTransport.createSeller", pl, randomSellerID)
        end
    end)

    addEventHandler("onVehicleExplode", veh, function()
        local boat = source
        local mid = apocalypseGetElementData(boat, "WPMissionID")
        local owner = apocalypseGetElementData(boat, "WPOwner")

        if owner then
			triggerClientEvent(root, "WeaponTransport.removeTimedVehicle", root, boat)

			local timer = WeaponTransport.vehicleTimer[owner]
			if isTimer(timer) then
				killTimer(timer)
			end
			WeaponTransport.vehicleTimer[owner] = nil
			WeaponTransport.vehicle[owner] = nil

			if isElement(owner) then
				triggerClientEvent(owner, "WeaponTransport.deleteClient", owner)
				NPC.MeMessage(owner,getText(owner,"SWeaponTransport13"))
			end
        end

		WeaponTransport.checkMissionFailed(mid)
    end)

    return veh
end

addEvent("WeaponTransport.Delivery", true)
addEventHandler("WeaponTransport.Delivery", root, function()
    local pl = client
    local veh = WeaponTransport.vehicle[pl]
    if not veh or not isElement(veh) then return end

    local owner = apocalypseGetElementData(veh, "WPOwner")
    if pl ~= owner then
        WeaponTransport.destroyPlayerVehicle(pl, true)
        return
    end

    WeaponTransport.destroyPlayerVehicle(pl, true)
	setAchievement(pl,403)

    local mid = apocalypseGetElementData(veh, "WPMissionID")
    local m = WeaponTransport.missions[mid]
    if not m then return end

    m.delivered[pl] = true

    local all = true
    for _, mem in ipairs(m.players) do
        if not m.delivered[mem] then
            all = false
            break
        end
    end

    if all then
        for _, mem in ipairs(m.players) do
            NPC.MeMessage(mem, getText(mem,"SWeaponTransport7"))
        end
        WeaponTransport.missions[mid] = nil
    end
	
	local delivered_weapon_transporter = tonumber(getPlayerData("character_stats", "character_id", getCharacterID(pl), "delivered_weapon_transporter"))
	Characters.addStats(pl, "delivered_weapon_transporter", delivered_weapon_transporter + 1)
			
	for _,v in pairs(Achievements)do
		if(delivered_weapon_transporter + 1 >= v[1])then
			setAchievement(pl,v[2])
		end
	end
end)

addEvent("WeaponTransport.DeliveryWarehouse",true)
addEventHandler("WeaponTransport.DeliveryWarehouse",root,function()
	local level = tonumber(apocalypseGetElementData(client,"level"))
	local level_bonus = level * 5
	if(level > 100)then level_bonus = 100 * 5 end

	giveEXP(client,750 + level_bonus)
	givePlayerServerMoney(client,250)
	giveLootItems(client,math.random(10,15))
	Colonys.giveMoney(apocalypseGetElementData(client,"colony"),250)
	giveColonyEXP(client,375)
	
	PlayerWeapons.addNewWeapon(client, 24, 28)
	PlayerWeapons.addNewWeapon(client, 29, 60)
	PlayerWeapons.addNewWeapon(client, 31, 100)
	PlayerWeapons.addNewWeapon(client, 34, 5)
	
	outputLog(getPlayerName(client).." hat eine Lieferung abgegeben und "..(750 + level_bonus).." EXP und $250 bekommen (+ Colonie EXP: 375, Colonie Geld: $250)", "Weapon Transport", getCharacterID(client))
	
	NPC.MeMessage(client, getText(client,"SWeaponTransport8"))
end)

addEvent("WeaponTransport.DeliverySeller",true)
addEventHandler("WeaponTransport.DeliverySeller",root,function()
	local level = tonumber(apocalypseGetElementData(client,"level"))
	local level_bonus = level * 5
	if(level > 100)then level_bonus = 100 * 5 end

	giveEXP(client,1250 + level_bonus)
	givePlayerServerMoney(client,200)
	giveLootItems(client,math.random(5,10))
	PlayerWeapons.addNewWeapon(client, 24, 21)
	PlayerWeapons.addNewWeapon(client, 29, 30)
	PlayerWeapons.addNewWeapon(client, 31, 50)
	PlayerWeapons.addNewWeapon(client, 34, 2)
	
	outputLog(getPlayerName(client).." hat eine Lieferung abgegeben und "..(750 + level_bonus).." EXP und $250 bekommen", "Weapon Transport", getCharacterID(client))
	
	NPC.MeMessage(client, getText(client,"SWeaponTransport8"))
end)

addEventHandler("onPlayerWasted",root,function()
	triggerClientEvent(source,"WeaponTransport.deleteClient",source)
end)