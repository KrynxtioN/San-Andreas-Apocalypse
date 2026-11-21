local pumpkin = {}
local pumpkinOnMap = 75
local pumpkin_colshapedata = {}
local pumpkin_pickupcolshapedata = {}

function pumpkin_spawnSingle()
    local x = math.random(0, 5600) - 2800
    local y = math.random(0, 5600) - 2800
    local hit, nx, ny, hitZ = processLineOfSight(x, y, 700, x, y, -10)

    local pickup
    if (hit) then
        pickup = createPickup(x, y, hitZ, 3, 1935, 50)
    else
        pickup = createPickup(x, y, 0, 3, 1935, 50)
    end

    local circle = createColCircle(x, y, 70)
    pumpkin_colshapedata[circle] = pickup
    addEventHandler("onClientColShapeHit", circle, pumpkin_setHigher)

    table.insert(pumpkin, pickup)
    pumpkin_pickupcolshapedata[pickup] = circle
    addEventHandler("onClientPickupHit", pickup, pumpkin_found)
end

function pumpkin_spawner_load()
    for _,v in pairs(pumpkin) do
        if (isElement(v)) then
            removeEventHandler("onClientPickupHit", v, pumpkin_found)
            destroyElement(v)
        end
    end
    for colshape,pickup in pairs(pumpkin_colshapedata) do
        if (isElement(colshape)) then
            removeEventHandler("onClientColShapeHit", colshape, pumpkin_setHigher)
            destroyElement(colshape)
        end
    end
    
    pumpkin = {}
    pumpkin_pickupcolshapedata = {}
    pumpkin_colshapedata = {}

    if (isCharacterLoggedIn(localPlayer)) then
        for n = 1, pumpkinOnMap do
            pumpkin_spawnSingle()
        end
    else
        setTimer(pumpkin_spawner_load, 5000, 1)
    end
end

function pumpkin_setHigher()
    local pickup = pumpkin_colshapedata[source]
    if (isElement(pickup)) then
        local x, y, z = getElementPosition(pickup)
        local hit, nx, ny, groundZ = processLineOfSight(x, y, 700, x, y, -10, true, false, false)
        if (hit) then
            setElementPosition(pickup, x, y, groundZ + 1)
        else
            setElementPosition(pickup, x, y, 0)
        end
        if (isElementWithinColShape(localPlayer, source)) then
            syncPumpkin(source)
        end
    end
end

function syncPumpkin(thecolshape)
    if (isElement(thecolshape) and isElement(pumpkin_colshapedata[thecolshape])) then
        local pickup = pumpkin_colshapedata[thecolshape]
        local x, y, z = getElementPosition(pickup)
        local hit, nx, ny, groundZ = processLineOfSight(x, y, 700, x, y, -10, true, false, false)
        if (hit) then
            setElementPosition(pickup, x, y, groundZ + 1)
        else
            setElementPosition(pickup, x, y, 0)
        end
    end
end

function pumpkin_found(thePlayer)
    if (thePlayer == localPlayer) then
		triggerServerEvent("giveHalloweenPumpkin",localPlayer,localPlayer,5)
        if (isElement(source)) then
            removeEventHandler("onClientPickupHit", source, pumpkin_found)
            destroyElement(source)
        end
		
        if (isElement(pumpkin_pickupcolshapedata[source])) then
            removeEventHandler("onClientColShapeHit", pumpkin_pickupcolshapedata[source], pumpkin_setHigher)
            destroyElement(pumpkin_pickupcolshapedata[source])
        end

        if (pumpkin_pickupcolshapedata[source]) then
            pumpkin_colshapedata[pumpkin_pickupcolshapedata[source]] = nil
            pumpkin_pickupcolshapedata[source] = nil
        end

        pumpkin_spawnSingle()
    end
end


if(HalloweenEvent == true)then pumpkin_spawner_load() end