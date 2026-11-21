Warehouse = {
    runs = {},
    CratePositions = {
        {0.7,0,2.3},
        {-0.7,0,2.3},
        {0.7,-1.3,2.3},
        {-0.7,-1.3,2.3},
        {-0.7,-2.6,2.3},
        {0.7,-2.6,2.3},
        {-0.7,-3.9,2.3},
        {0.7,-3.9,2.3},
    },
    nextID = 0,
    DeliveryTime = 15 * 60
}

local Achievements = {
	{5,441},
	{10,442},
	{25,443},
	{50,444},
	{75,445},
	{125,446},
	{175,447},
	{250,448},
}

local Info_Marker = createMarker(1425.3953857422,-1345.7414550781,13.577986717224,"cylinder",10,0,0,0,0)

addEventHandler("onMarkerHit",Info_Marker,function(player)
	if(getElementType(player) == "player")then
		if(getElementDimension(player) == getElementDimension(source))then
			triggerClientEvent(player, "showInformationHelpBar", player, getText(player, "CWarehouse5"), getText(player, "CWarehouse6"))
		end
	end
end)

function Warehouse:getNewID()
    self.nextID = self.nextID + 1
    return self.nextID
end

function Warehouse.dropCrate(runID, crateIndex)
    local run = Warehouse.runs[runID]
    if not run then return end

    local crate = run.crates[crateIndex]
    if isElement(crate) and isElement(run.vehicle) then
        local vx, vy, vz = getElementVelocity(run.vehicle)

        detachElements(crate)
        setElementVelocity(crate, vx, vy, vz + 0.2)
        run.crates[crateIndex] = nil

        local driver = getVehicleOccupant(run.vehicle, 0)
        if driver then
            local left = run.kisten - 1
            if left > 0 then
                NPC.MeMessage(driver, getText(driver, "SWarehouse2"))
            else
                NPC.MeMessage(driver, getText(driver, "SWarehouse3"))
            end
        end

        setTimer(function()
            if isElement(crate) then
                destroyElement(crate)
            end
        end, 7500, 1)
    end
end

function Warehouse.cleanupRun(runID)
    local run = Warehouse.runs[runID]
    if not run then return end

    if isElement(run.vehicle) then
        triggerClientEvent(root, "Warehouse.removeVehicle", root, run.vehicle) -- ✅ NEU

        if run.handlers.onEnter then removeEventHandler("onVehicleEnter", run.vehicle, run.handlers.onEnter) end
        if run.handlers.onExit then removeEventHandler("onVehicleExit", run.vehicle, run.handlers.onExit) end
        if run.handlers.onExplode then removeEventHandler("onVehicleExplode", run.vehicle, run.handlers.onExplode) end
        if run.handlers.onDamage then removeEventHandler("onVehicleDamage", run.vehicle, run.handlers.onDamage) end
    end

    for _, crate in pairs(run.crates) do
        if isElement(crate) then
            destroyElement(crate)
        end
    end

    if isTimer(run.refreshTimer) then
        killTimer(run.refreshTimer)
    end

    if isElement(run.vehicle) then
        destroyElement(run.vehicle)
    end

    Warehouse.runs[runID] = nil
end

addEvent("Warehouse.start", true)
addEventHandler("Warehouse.start", root, function(amount, selectedCrates)
    local player = client
    amount = tonumber(amount)
    selectedCrates = tonumber(selectedCrates) or 1

    selectedCrates = math.floor(selectedCrates)
    if selectedCrates < 1 then selectedCrates = 1 end
    if selectedCrates > #Warehouse.CratePositions then selectedCrates = #Warehouse.CratePositions end

    local expectedPrice = selectedCrates * 150
    if amount ~= expectedPrice then
        amount = expectedPrice
    end

    if tonumber(apocalypseGetElementData(player, "money")) >= amount then
        apocalypseSetElementData(player, "money", apocalypseGetElementData(player, "money") - amount)

        local runID = Warehouse:getNewID()
        local run = {
            vehicle = createVehicle(456, 1435.9228515625, -1328.7927246094, 13.811599731445, 0, 0, 90),
            crates = {},
            kisten = selectedCrates,
            startKisten = selectedCrates,
            handlers = {},
            explodedByCrates = false,
			deliveryPoint = math.random(1,1),
        }
        Warehouse.runs[runID] = run

        local expireAt = getRealTime().timestamp + Warehouse.DeliveryTime
        setElementData(run.vehicle, "Warehouse.expireAt", expireAt)
        triggerClientEvent(root, "Warehouse.addVehicle", root, run.vehicle, expireAt)

		apocalypseSetElementData(run.vehicle,"Warehouse.deliveryPoint",run.deliveryPoint)

        setVehicleVariant(run.vehicle, 1, 1)
        warpPedIntoVehicle(player, run.vehicle)
		NPC.MeMessage(player,getText(player,"SWarehouse4"))

        for i = 1, selectedCrates do
            local pos = Warehouse.CratePositions[i]
            local crate = createObject(2912, 0, 0, 0)
            attachElements(crate, run.vehicle, pos[1], pos[2], pos[3])
            setObjectScale(crate, 1.6)
            run.crates[i] = crate
        end

        triggerClientEvent(player, "Warehouse.createMarker", player, run.deliveryPoint)

        run.refreshTimer = setTimer(function(runID)
            local run = Warehouse.runs[runID]
            if run and isElement(run.vehicle) then
                setElementHealth(run.vehicle, 0)
            end
        end, Warehouse.DeliveryTime * 1000, 1, runID)

        run.handlers.onEnter = function(plr)
            if getPedOccupiedVehicleSeat(plr) == 0 then
				local id = apocalypseGetElementData(source,"Warehouse.deliveryPoint")
                triggerClientEvent(plr, "Warehouse.createMarker", plr, id)
            end
        end
        addEventHandler("onVehicleEnter", run.vehicle, run.handlers.onEnter)

        run.handlers.onExit = function(plr)
            triggerClientEvent(plr, "Warehouse.destroy", plr)
        end
        addEventHandler("onVehicleExit", run.vehicle, run.handlers.onExit)

        run.handlers.onExplode = function()
            Warehouse.cleanupRun(runID)
        end
        addEventHandler("onVehicleExplode", run.vehicle, run.handlers.onExplode)

        run.handlers.onDamage = function(loss)
            local health = getElementHealth(source)

            if not run.lastHealth or health < run.lastHealth then
                run.lastHealth = health

                if run.kisten >= 1 then
                    Warehouse.dropCrate(runID, run.kisten)
                    run.kisten = run.kisten - 1

                    if run.kisten <= 0 and isElement(run.vehicle) and not run.explodedByCrates then
                        run.explodedByCrates = true
                        setElementHealth(run.vehicle, 0)
                    end
                end
            end
        end
        addEventHandler("onVehicleDamage", run.vehicle, run.handlers.onDamage)

        triggerClientEvent(player, "closeWindow", player)
        setAchievement(player, 400)
    else
        NPC.MeMessage(player, getText(player, "SWarehouse1"))
    end
end)

addEvent("Warehouse.delivery", true)
addEventHandler("Warehouse.delivery", root, function()
    local player = client

    for runID, run in pairs(Warehouse.runs) do
        if run.vehicle and getVehicleOccupant(run.vehicle, 0) == player then
            local level = tonumber(apocalypseGetElementData(player, "level"))
            local level_bonus = level * 0.5
            if level > 100 then
                level_bonus = 100 * 0.5
            end

            local money = (750 + (run.kisten * 250))
            local player_exp = math.floor((run.kisten * 125) + level_bonus)

            givePlayerServerMoney(player, money)
            giveEXP(player, player_exp)

            if run.kisten >= run.startKisten then
                PlayerWeapons.addNewWeapon(player, 35, 1)
            end

            Warehouse.cleanupRun(runID)
            triggerClientEvent(player, "Warehouse.destroy", player)
            triggerClientEvent(player, "Warehouse.reset", player)
            setAchievement(player, 401)
			NPC.MeMessage(player,getText(player,"SWarehouse5"))
			
			local delivered_warehouse_transporter = tonumber(getPlayerData("character_stats", "character_id", getCharacterID(player), "delivered_warehouse_transporter"))
			Characters.addStats(player, "delivered_warehouse_transporter", delivered_warehouse_transporter + 1)
			
			for _,v in pairs(Achievements)do
				if(delivered_warehouse_transporter + 1 >= v[1])then
					setAchievement(player,v[2])
				end
			end

			outputLog(getPlayerName(player).." hat eine Lieferung erledigt und $"..money..", "..math.floor((run.kisten * 125) + level_bonus).." EXP und einen Raketenwerfer mit einem Schuss erhalten","Warehouse Delivery",getCharacterID(player))
            return
        end
    end
end)

addEventHandler("onPlayerWasted", root, function()
    local player = source
    for _, run in pairs(Warehouse.runs) do
        if run.vehicle and getVehicleOccupant(run.vehicle, 0) == player then
            triggerClientEvent(player, "Warehouse.destroy", player)
            triggerClientEvent(player, "Warehouse.reset", player)
            return
        end
    end
end)