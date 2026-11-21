TreasureHunter = { treasures = nil }
TreasureHunter.ShellObject = createObject(953, 714.52087402344, -1706.6225585938, 1.7236000299454, 0, 0, 154)
TreasureHunter.Arrow = nil

local function getNearestTreasure()
    local px, py, pz = getElementPosition(localPlayer)
    local nearest, minDist = nil, math.huge
    if TreasureHunter.treasures then
        for _, t in ipairs(TreasureHunter.treasures) do
            if isElement(t) then
                local tx, ty, tz = getElementPosition(t)
                local dist = getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz)
                if dist < minDist then
                    minDist = dist
                    nearest = t
                end
            end
        end
    end
    return nearest, minDist
end

local function updateArrow()
    if not isElement(TreasureHunter.Arrow) then return end
    local nearest, _ = getNearestTreasure()
    if not TreasureHunter.treasures or #TreasureHunter.treasures == 0 then
        setElementAlpha(TreasureHunter.Arrow, 0)
        return
    end

    local px, py, pz
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if vehicle then
        px, py, pz = getElementPosition(vehicle)
        pz = pz + 5
        setElementPosition(TreasureHunter.Arrow, px, py+2, pz)
        setObjectScale(TreasureHunter.Arrow, 1.2)
    else
        px, py, pz = getElementPosition(localPlayer)
        pz = pz + 1
        setElementPosition(TreasureHunter.Arrow, px, py, pz)
        setObjectScale(TreasureHunter.Arrow, 1)
    end

    local tx, ty, tz = getElementPosition(nearest)
    local dx, dy = tx - px, ty - py
    local dz = tz - pz
    local dist3D = getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz)

    local horizontal = math.deg(math.atan2(dy, dx))
    local vertical = math.deg(math.asin(dz / dist3D))

    setElementRotation(TreasureHunter.Arrow, 0, 90 + vertical, horizontal + 180)
    setElementAlpha(TreasureHunter.Arrow, 255)
end

addEvent("TreasureHunter.updateShellObjectData", true)
addEventHandler("TreasureHunter.updateShellObjectData", root, function(data)
    TreasureHunter.ShellData = data
end)

addEventHandler("onClientRender", root, function()
    if not (isCharacterLoggedIn() and isWindowOpen()) then return end

    local x1, y1, z1 = getElementPosition(TreasureHunter.ShellObject)
    local x2, y2, z2 = 716.46697998047, -1706.4816894531, 2.4296875
    local screenX1, screenY1 = getScreenFromWorldPosition(x1, y1, z1)
    local screenX2, screenY2 = getScreenFromWorldPosition(x2, y2, z2)

    if screenX1 and screenY1 and getDistanceBetweenPoints3D(x1, y1, z1, getElementPosition(localPlayer)) <= 5 then
        dxDrawText(getText("CTreasureHunter3"):format(TreasureHunter.ShellData),
            screenX1 - 100, screenY1 - 20, screenX1 + 100, screenY1 + 20,
            tocolor(255,255,255), 1.2, "default-bold", "center", "center")
    end

    if screenX2 and screenY2 and getDistanceBetweenPoints3D(x2, y2, z2, getElementPosition(localPlayer)) <= 5 then
        dxDrawText(getText("CTreasureHunter1"),
            screenX2 - 100, screenY2 - 20, screenX2 + 100, screenY2 + 20,
            tocolor(255,255,255), 1.2, "default-bold", "center", "center")
    end

    local nearest, dist = getNearestTreasure()
    if nearest then
        local vehicle = getPedOccupiedVehicle(localPlayer)
        if vehicle then
            local vx, vy, vz = getElementPosition(vehicle)
            local screenX, screenY = getScreenFromWorldPosition(vx, vy, vz + 2)
            if screenX and screenY then
                dxDrawText(getText("CTreasureHunter2"):format(dist),
                    screenX - 100, screenY - 50, screenX + 100, screenY + 50,
                    tocolor(255,255,255), 1, "default-bold", "center", "center")
            end
        end
    end
end)

addEvent("TreasureHunter.updateTreasurePosition", true)
addEventHandler("TreasureHunter.updateTreasurePosition", root, function(positions)
    TreasureHunter.treasures = positions
    if not isElement(TreasureHunter.Arrow) then
        TreasureHunter.Arrow = createObject(1318, 0, 0, 0)
        setElementCollisionsEnabled(TreasureHunter.Arrow, false)
        addEventHandler("onClientPreRender", root, updateArrow)
    end
end)

addEvent("TreasureHunter.stopJob", true)
addEventHandler("TreasureHunter.stopJob", root, function()
    TreasureHunter.treasures = nil
    if isElement(TreasureHunter.Arrow) then
        destroyElement(TreasureHunter.Arrow)
        TreasureHunter.Arrow = nil
    end
    removeEventHandler("onClientPreRender", root, updateArrow)
end)