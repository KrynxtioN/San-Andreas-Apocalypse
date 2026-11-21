local companionPed = nil
local sx, sy = guiGetScreenSize()

local lastServerSync = 0
local lastJump = 0
local lastStrafeSwitch = 0
local lastProgressPos = nil
local lastShotRequest = 0
local lastHealRequest = 0
local lastHealth = 100
local stuckTicks = 0
local strafeDirection = "left"
local uiAnim = 0
local hoverAnim = 0
local bloodPulse = 0
local aiTimer = nil
local activeRender = false
local lastTargetName = nil
local lastTargetSync = 0

local BUTTON_X = 20
local BUTTON_W = 190
local BUTTON_H = 46
local BUTTON_BOTTOM_OFFSET = 60

local FOLLOW_STOP_DISTANCE = 2.8
local RUN_DISTANCE = 5.0
local SPRINT_DISTANCE = 8.0
local BOOST_DISTANCE = 14.0
local TELEPORT_DISTANCE = 90
local ATTACK_RANGE = 48
local HEAL_RANGE = 7.5
local HEAL_REQUEST_INTERVAL = 600

local startCompanionSystems
local stopCompanionSystems

local COMMANDS = {
    { id = "follow",  nameKey = "COMPANION_COMMAND_FOLLOW", medicNameKey = "COMPANION_COMMAND_FOLLOW", key = "1" },
    { id = "stay",    nameKey = "COMPANION_COMMAND_STAY", medicNameKey = "COMPANION_COMMAND_WAIT", key = "2" },
    { id = "attack",  nameKey = "COMPANION_COMMAND_ATTACK", medicNameKey = "COMPANION_COMMAND_HEAL", key = "3" },
    { id = "guard",   nameKey = "COMPANION_COMMAND_GUARD", medicNameKey = "COMPANION_COMMAND_SECURE", key = "4" },
    { id = "dismiss", nameKey = "COMPANION_COMMAND_DISMISS", medicNameKey = "COMPANION_COMMAND_DISMISS", key = "5" }
}

function getRotationToPoint(x1, y1, x2, y2)
    local rot = -math.deg(math.atan2(x2 - x1, y2 - y1))
    return rot < 0 and rot + 360 or rot
end

addEvent("companion:onCreated", true)
addEventHandler("companion:onCreated", root, function(ped)
    if not isElement(ped) then return end
    companionPed = ped
    lastHealth = getElementHealth(ped) or 100
    uiAnim = 1
    hoverAnim = 0
    lastProgressPos = nil
    stuckTicks = 0
    lastTargetName = nil

    if startCompanionSystems then
        startCompanionSystems()
    end
end)

addEvent("companion:onRemoved", true)
addEventHandler("companion:onRemoved", root, function(ped)
    if ped == false or companionPed == ped or not isElement(companionPed) then
        companionPed = nil
    end

    uiAnim = 0
    hoverAnim = 0
    lastProgressPos = nil
    stuckTicks = 0
    lastTargetName = nil

    if stopCompanionSystems then
        stopCompanionSystems()
    end
end)

addEvent("companion:healFX", true)
addEventHandler("companion:healFX", resourceRoot, function(ped, owner, newHP)
    if not isElement(ped) or not isElement(owner) then return end
    setPedControlState(ped, "aim_weapon", false)
    setPedControlState(ped, "fire", false)
    setPedAnimation(ped, "MEDIC", "CPR", 650, false, false, false, false)
end)

addEvent("companion:clientGiveWeapon", true)
addEventHandler("companion:clientGiveWeapon", resourceRoot, function(ped, weaponID, ammo)
    if not isElement(ped) then return end

    weaponID = tonumber(weaponID) or 31
    ammo = tonumber(ammo) or 500

    if givePedWeapon then
        givePedWeapon(ped, weaponID, ammo, true)
    end

    if setPedWeaponSlot and getSlotFromWeapon then
        setPedWeaponSlot(ped, getSlotFromWeapon(weaponID))
    end
end)

addEvent("companion:syncShotFX", true)
addEventHandler("companion:syncShotFX", resourceRoot, function(ped, target)
    if not isElement(ped) or not isElement(target) then return end

    local tx, ty, tz = getElementPosition(target)
    local px, py, pz = getElementPosition(ped)

    setPedRotation(ped, getRotationToPoint(px, py, tx, ty))
    setPedAimTarget(ped, tx, ty, tz + 0.95)
    setPedControlState(ped, "aim_weapon", true)
    setPedControlState(ped, "fire", true)

    setTimer(function()
        if isElement(ped) then
            setPedControlState(ped, "fire", false)
        end
    end, 140, 1)
end)

local function say(ped, text, cooldown)
    if isElement(ped) then
        triggerServerEvent("companion:dialog", localPlayer, ped, text, cooldown or 1800)
    end
end

local function lerp(a, b, t)
    return a + (b - a) * t
end

local function isMedic(ped)
    return isElement(ped) and getElementData(ped, "companion:class") == "medic"
end

local function commandDisplayName(cmd, ped)
    if isMedic(ped) and cmd.medicNameKey then
        return getText(cmd.medicNameKey)
    end
    return getText(cmd.nameKey)
end

local function commandStatusName(command)
    local keys = {
        follow = "COMPANION_COMMAND_FOLLOW",
        stay = "COMPANION_COMMAND_STAY",
        attack = "COMPANION_COMMAND_ATTACK",
        guard = "COMPANION_COMMAND_GUARD",
        dismiss = "COMPANION_COMMAND_DISMISS"
    }
    return getText(keys[command] or "COMPANION_COMMAND_FOLLOW")
end

local function smoothRotation(current, target, speed)
    local diff = (target - current + 540) % 360 - 180
    return (current + diff * speed) % 360
end

local function isMouseIn(x, y, w, h)
    if not isCursorShowing() then return false end

    local cx, cy = getCursorPosition()
    if not cx or not cy then return false end

    cx, cy = cx * sx, cy * sy
    return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end

local function getMyCompanion()
    if isElement(companionPed) then
        return companionPed
    end

    companionPed = nil
    return nil
end

local function setTargetName(ped, value, force)
    if not isElement(ped) then return end

    local now = getTickCount()
    if not force and lastTargetName == value and now - lastTargetSync < 1000 then
        return
    end

    lastTargetName = value
    lastTargetSync = now
    setElementData(ped, "companion:targetName", value)
end

local function forwardPoint(x, y, rot, dist)
    local rad = math.rad(-rot)
    return x + math.sin(rad) * dist, y + math.cos(rad) * dist
end

local function resetPedControls(ped)
    for _, control in ipairs({
        "forwards", "backwards", "left", "right",
        "sprint", "walk", "jump", "aim_weapon", "fire"
    }) do
        setPedControlState(ped, control, false)
    end
end

local function syncTransform(ped)

end

local function jumpPed(ped)
    local now = getTickCount()
    if now - lastJump < 900 then return end

    lastJump = now
    setPedControlState(ped, "jump", true)
    say(ped, getText("COMPANION_DIALOG_JUMP"), 2600)

    setTimer(function()
        if isElement(ped) then
            setPedControlState(ped, "jump", false)
        end
    end, 230, 1)
end

local function hasObstacleAhead(ped)
    local x, y, z = getElementPosition(ped)
    local rz = getPedRotation(ped)

    local fx1, fy1 = forwardPoint(x, y, rz, 1.3)
    local fx2, fy2 = forwardPoint(x, y, rz, 2.8)

    local lowClear = isLineOfSightClear(x, y, z + 0.45, fx1, fy1, z + 0.45, true, true, false, true, true, false, false, ped)
    local highClear = isLineOfSightClear(x, y, z + 1.45, fx2, fy2, z + 1.45, true, true, false, true, true, false, false, ped)

    if not lowClear and highClear then return "jump" end
    if not lowClear then return "blocked" end

    return false
end

local function chooseStrafe()
    local now = getTickCount()

    if now - lastStrafeSwitch > 580 then
        strafeDirection = strafeDirection == "left" and "right" or "left"
        lastStrafeSwitch = now
    end

    return strafeDirection
end

local function checkStuck(ped, owner)
    local x, y, z = getElementPosition(ped)
    local px, py, pz = getElementPosition(owner)

    if not lastProgressPos then
        lastProgressPos = { x, y, z }
        return
    end

    local moved = getDistanceBetweenPoints3D(x, y, z, lastProgressPos[1], lastProgressPos[2], lastProgressPos[3])
    local dist = getDistanceBetweenPoints3D(x, y, z, px, py, pz)

    if dist > 5 and moved < 0.055 then
        stuckTicks = stuckTicks + 1
    else
        stuckTicks = 0
    end

    lastProgressPos = { x, y, z }

    if stuckTicks == 60 then
        say(ped, getText("COMPANION_DIALOG_BLOCKED"), 3200)
    end

    if stuckTicks > 145 then
        setElementPosition(ped, px + 2.0, py + 2.0, pz)
        say(ped, getText("COMPANION_DIALOG_CAUGHT_UP"), 3500)
        stuckTicks = 0
    end
end

local function targetName(target)
    if getElementType(target) == "player" then
        return getPlayerName(target)
    end

    if getElementData(target, "zombie:name") then
        return getElementData(target, "zombie:name")
    end

    if getElementData(target, "zombie") == true then
        return getText("COMPANION_TARGET_ZOMBIE")
    end

    if getElementData(target, "companion:testTarget") then
        return getText("COMPANION_TARGET_TEST_PED")
    end

    return getText("COMPANION_TARGET_INFECTED")
end

local function isEnemyTarget(target, owner, ped)
    if not isElement(target) then return false end
    if target == owner or target == ped then return false end
    if getElementHealth(target) <= 0 then return false end

    if getElementType(target) == "player" then
        return true
    end

    if getElementType(target) == "ped" then
        if getElementData(target, "companion:active") then return false end

        return getElementData(target, "zombie") == true
            or getElementData(target, "zombieTarget") == true
            or getElementData(target, "companion:testTarget") == true
    end

    return false
end

local function hasClearShot(ped, target)
    if not isElement(target) then return false end

    local px, py, pz = getElementPosition(ped)
    local tx, ty, tz = getElementPosition(target)

    return isLineOfSightClear(
        px, py, pz + 1.1,
        tx, ty, tz + 0.95,
        true, true, false, true, true, false, false, ped
    )
end

local function getNearestEnemy(ped, owner)
    local px, py, pz = getElementPosition(ped)
    local bestTarget = nil
    local bestDist = ATTACK_RANGE + 1

    for _, target in ipairs(getElementsByType("ped", root, true)) do
        if isEnemyTarget(target, owner, ped) then
            local x, y, z = getElementPosition(target)
            local dist = getDistanceBetweenPoints3D(px, py, pz, x, y, z)

            if dist < bestDist and hasClearShot(ped, target) then
                bestTarget = target
                bestDist = dist
            end
        end
    end

    for _, target in ipairs(getElementsByType("player", root, true)) do
        if isEnemyTarget(target, owner, ped) then
            local x, y, z = getElementPosition(target)
            local dist = getDistanceBetweenPoints3D(px, py, pz, x, y, z)

            if dist < bestDist and hasClearShot(ped, target) then
                bestTarget = target
                bestDist = dist
            end
        end
    end

    return bestTarget, bestDist
end

local function attackTarget(ped, target)
    local tx, ty, tz = getElementPosition(target)
    local px, py, pz = getElementPosition(ped)

    setPedRotation(ped, getRotationToPoint(px, py, tx, ty))
    setPedAimTarget(ped, tx, ty, tz + 0.95)
    setPedControlState(ped, "aim_weapon", true)
    setPedControlState(ped, "fire", true)

    setTargetName(ped, targetName(target))

    local now = getTickCount()

    if now - lastShotRequest > 330 then
        lastShotRequest = now
        triggerServerEvent("companion:requestShot", localPlayer, ped, target, true)
    end
end

local function healOwnerIfNeeded(ped, owner)
    if not isMedic(ped) or not isElement(owner) then return false end

    local hp = getElementHealth(owner) or 100
    if hp >= 100 then
        setTargetName(ped, getText("COMPANION_STATUS_NO_HEAL_NEEDED"))
        return false
    end

    local px, py, pz = getElementPosition(ped)
    local ox, oy, oz = getElementPosition(owner)
    local dist = getDistanceBetweenPoints3D(px, py, pz, ox, oy, oz)

    if dist > HEAL_RANGE then
        setTargetName(ped, getText("COMPANION_STATUS_TOO_FAR_TO_HEAL"))
        return false
    end

    local now = getTickCount()
    if now - lastHealRequest > HEAL_REQUEST_INTERVAL then
        lastHealRequest = now
        setPedRotation(ped, getRotationToPoint(px, py, ox, oy))
        setTargetName(ped, getText("COMPANION_STATUS_HEALING_OWNER"))
        triggerServerEvent("companion:requestHeal", localPlayer, ped)
    end

    return true
end

local function updateHealthDialog(ped)
    local hp = getElementHealth(ped) or 100

    if hp < lastHealth then
        say(ped, getText("COMPANION_DIALOG_HEALTH"):format(math.floor(hp)), 2600)
    end

    if hp <= 30 and lastHealth > 30 then
        say(ped, getText("COMPANION_DIALOG_CRITICAL"), 5000)
    end

    lastHealth = hp
end

local function updateCompanion()
    local ped = getMyCompanion()
    if not isElement(ped) then return end

    local owner = getElementData(ped, "companion:owner")
    if owner ~= localPlayer or not isElement(owner) then return end

    if getElementHealth(ped) <= 0 then
        resetPedControls(ped)
        return
    end

    updateHealthDialog(ped)
    resetPedControls(ped)

    local command = getElementData(ped, "companion:command") or "follow"
    local medic = isMedic(ped)

    if command == "stay" then
        if medic then
            healOwnerIfNeeded(ped, owner)
        else
            setTargetName(ped, getText("COMPANION_STATUS_NO_TARGET"))
        end
        syncTransform(ped)
        return
    end

    if medic then
        healOwnerIfNeeded(ped, owner)
    elseif command == "attack" or command == "guard" then
        local target = getNearestEnemy(ped, owner)

        if isElement(target) then
            attackTarget(ped, target)
            say(ped, getText("COMPANION_DIALOG_CONTACT"):format(targetName(target)), 3600)
            syncTransform(ped)
            return
        else
            setTargetName(ped, getText("COMPANION_STATUS_NO_TARGET"))
        end
    end

    local px, py, pz = getElementPosition(owner)
    local x, y, z = getElementPosition(ped)
    local dist = getDistanceBetweenPoints3D(x, y, z, px, py, pz)

    local wantedRot = getRotationToPoint(x, y, px, py)
    local currentRot = getPedRotation(ped)
    setPedRotation(ped, smoothRotation(currentRot, wantedRot, 0.18))

    if dist > TELEPORT_DISTANCE then
        setElementPosition(ped, px + 2.2, py + 2.2, pz)
        say(ped, getText("COMPANION_DIALOG_TOO_FAR"), 3500)
        syncTransform(ped)
        return
    end

    if dist > FOLLOW_STOP_DISTANCE then
        setPedControlState(ped, "forwards", true)

        if dist > SPRINT_DISTANCE then
            setPedControlState(ped, "sprint", true)
        elseif dist > RUN_DISTANCE then
            setPedControlState(ped, "sprint", true)
        else
            setPedControlState(ped, "walk", true)
        end

        if dist > BOOST_DISTANCE then
            setPedControlState(ped, "sprint", true)
            setPedAnimation(ped, false)
        end

        local obstacle = hasObstacleAhead(ped)

        if obstacle == "jump" then
            jumpPed(ped)
        elseif obstacle == "blocked" then
            setPedControlState(ped, chooseStrafe(), true)
            jumpPed(ped)
            say(ped, getText("COMPANION_DIALOG_DETOUR"), 2800)
        end
    end

    checkStuck(ped, owner)
    syncTransform(ped)
end


local function rect(x, y, w, h, c)
    dxDrawRectangle(x, y, w, h, c)
end

local function survivalPanel(x, y, w, h)
    rect(x + 5, y + 5, w, h, tocolor(0, 0, 0, 115))
    rect(x, y, w, h, tocolor(21, 18, 15, 228))
    rect(x, y, w, 4, tocolor(142, 111, 69, 245))
    rect(x, y + h - 4, w, 4, tocolor(80, 96, 59, 230))
    rect(x, y, 4, h, tocolor(93, 69, 45, 235))
    rect(x + w - 4, y, 4, h, tocolor(93, 69, 45, 235))
end

local function survivalBar(x, y, w, h, value, label, color)
    value = math.max(0, math.min(1, value))
    rect(x, y, w, h, tocolor(12, 10, 8, 235))
    rect(x + 2, y + 2, (w - 4) * value, h - 4, color)
    rect(x, y, w, 1, tocolor(220, 190, 130, 110))
    dxDrawText(label, x, y, x + w, y + h, tocolor(238, 224, 196, 245), 0.9, "default-bold", "center", "center")
end

local function drawNametag()
    local ped = getMyCompanion()
    if not isElement(ped) or not isElementStreamedIn(ped) then return end

    local x, y, z = getElementPosition(ped)
    local cx, cy, cz = getCameraMatrix()
    local dist = getDistanceBetweenPoints3D(cx, cy, cz, x, y, z)

    if dist > 55 then return end

    local sx2, sy2 = getScreenFromWorldPosition(x, y, z + 1.35)
    if not sx2 then return end

    local alpha = math.max(95, 255 - dist * 3)
    local hp = getElementHealth(ped) or 0
    local name = getElementData(ped, "companion:name") or "Raven"
    local command = getElementData(ped, "companion:command") or "follow"
    local commandLabel = commandStatusName(command)

    local w, h = 178, 46
    local bx, by = sx2 - w / 2, sy2 - h / 2

    rect(bx + 4, by + 4, w, h, tocolor(0, 0, 0, alpha * 0.35))
    rect(bx, by, w, h, tocolor(26, 22, 17, alpha * 0.86))
    rect(bx, by, w, 3, tocolor(157, 116, 62, alpha))
    rect(bx + 10, by + 35, w - 20, 5, tocolor(8, 8, 8, alpha))
    rect(bx + 10, by + 35, (w - 20) * math.max(0, math.min(1, hp / 100)), 5, tocolor(130, 42, 34, alpha))

    dxDrawText("✚ " .. name, bx, by + 4, bx + w, by + 22, tocolor(235, 212, 160, alpha), 1, "default-bold", "center", "center")
    dxDrawText(commandLabel:upper(), bx, by + 20, bx + w, by + 34, tocolor(174, 190, 130, alpha), 0.85, "default-bold", "center", "center")
end

local function drawUI()
    local ped = getMyCompanion()

    uiAnim = lerp(uiAnim, isElement(ped) and 1 or 0, 0.07)
    if uiAnim < 0.02 then return end

    local w = 360
    local collapsedH = 118
    local expandedH = 352

    local x = 28
    local expandedY = sy - expandedH - 100
    if expandedY < 20 then expandedY = 20 end

    local collapsedY = sy - collapsedH - 100
    if collapsedY < 20 then collapsedY = 20 end

    local visibleH = lerp(collapsedH, expandedH, hoverAnim)
    local visibleY = lerp(collapsedY, expandedY, hoverAnim)
    local hoveringCollapsed = isMouseIn(x, collapsedY, w, collapsedH)
    local hoveringVisible = hoverAnim > 0.02 and isMouseIn(x, visibleY, w, visibleH)
    local hovering = hoveringCollapsed or hoveringVisible

    hoverAnim = lerp(hoverAnim, hovering and 1 or 0, 0.12)

    bloodPulse = (math.sin(getTickCount() / 420) + 1) / 2

    local h = lerp(collapsedH, expandedH, hoverAnim)
    local y = lerp(collapsedY, expandedY, hoverAnim)

    local hp = getElementHealth(ped) or 0
    local ammo = tonumber(getElementData(ped, "companion:ammo")) or 0
    local weapon = tonumber(getElementData(ped, "companion:weapon")) or 0
    local range = tonumber(getElementData(ped, "companion:range")) or ATTACK_RANGE
    local command = getElementData(ped, "companion:command") or "follow"
    local target = getElementData(ped, "companion:targetName") or getText("COMPANION_STATUS_NO_TARGET")
    local name = getElementData(ped, "companion:name") or "Raven"
    local typeLabel = getElementData(ped, "companion:typeLabel") or getText("COMPANION_ROLE_SOLDIER")
    local medic = isMedic(ped)

    local px, py, pz = getElementPosition(localPlayer)
    local bx, by, bz = getElementPosition(ped)
    local distance = getDistanceBetweenPoints3D(px, py, pz, bx, by, bz)

    rect(x + 6, y + 6, w, h, tocolor(0, 0, 0, 120))
    rect(x, y, w, h, tocolor(13, 13, 13, 235))

    rect(x, y, w, 4, tocolor(170, 28 + bloodPulse * 35, 35, 255))
    rect(x, y + h - 4, w, 4, tocolor(120, 18, 24, 245))
    rect(x, y, 4, h, tocolor(140, 20, 28, 245))
    rect(x + w - 4, y, 4, h, tocolor(140, 20, 28, 245))

    local headerX = x + 18
    local headerY = y + 14
    local headerW = w - 36
    local headerH = 44

    rect(headerX, headerY, headerW, headerH, tocolor(24, 24, 24, 240))
    rect(headerX, headerY, 4, headerH, tocolor(190, 30 + bloodPulse * 45, 40, 255))

    dxDrawText(
        name:upper() .. "  |  " .. typeLabel:upper(),
        headerX + 14,
        headerY + 4,
        headerX + headerW - 12,
        headerY + 23,
        tocolor(245, 245, 245, 255),
        0.98,
        "default-bold",
        "left",
        "center",
        true
    )

    local statusLine = commandStatusName(command):upper() .. "  |  " .. math.floor(hp) .. "%"
    if medic then
        statusLine = statusLine .. getText("COMPANION_HUD_HEALER_SUFFIX")
    else
        statusLine = statusLine .. getText("COMPANION_HUD_AMMO_SUFFIX"):format(ammo)
    end

    dxDrawText(
        statusLine,
        headerX + 14,
        headerY + 23,
        headerX + headerW - 12,
        headerY + 41,
        tocolor(180, 180, 180, 235),
        0.76,
        "default-bold",
        "left",
        "center",
        true
    )

    local miniY = y + 66
    local keyGap = 5
    local compactW = (w - 36 - keyGap * 4) / 5
    local expandedW = 34
    local miniW = lerp(compactW, expandedW, hoverAnim)
    local miniH = 22
    local totalKeysW = miniW * #COMMANDS + keyGap * (#COMMANDS - 1)
    local miniX = x + (w - totalKeysW) / 2

    for _, cmd in ipairs(COMMANDS) do
        local active = command == cmd.id
        local boxColor = active and tocolor(160, 28, 36, 245) or tocolor(28, 28, 28, 220)
        local textColor = active and tocolor(255, 255, 255, 255) or tocolor(170, 170, 170, 230)
        local label = commandDisplayName(cmd, ped)

        rect(miniX, miniY, miniW, miniH, boxColor)

        if hoverAnim < 0.08 then
            dxDrawText(
                cmd.key .. " " .. label,
                miniX + 2,
                miniY,
                miniX + miniW - 2,
                miniY + miniH,
                textColor,
                0.56,
                "default-bold",
                "center",
                "center",
                true
            )
        else
            dxDrawText(
                cmd.key,
                miniX,
                miniY,
                miniX + miniW,
                miniY + miniH,
                textColor,
                0.78,
                "default-bold",
                "center",
                "center"
            )
        end

        miniX = miniX + miniW + keyGap
    end

    if hoverAnim < 0.08 then return end

    local a = math.floor(255 * hoverAnim)

    local function darkBar(bx, by, bw, bh, value, label, color)
        value = math.max(0, math.min(1, value))
        rect(bx, by, bw, bh, tocolor(5, 5, 5, 235 * hoverAnim))
        rect(bx + 2, by + 2, (bw - 4) * value, bh - 4, color)
        rect(bx, by, bw, 1, tocolor(210, 210, 210, 80 * hoverAnim))
        dxDrawText(label, bx, by, bx + bw, by + bh, tocolor(245, 245, 245, a), 0.9, "default-bold", "center", "center")
    end

    darkBar(x + 22, y + 96, w - 44, 24, hp / 100, getText("COMPANION_HUD_HEALTH"):format(math.floor(hp)), tocolor(145, 35, 40, 235 * hoverAnim))

    local clipX = x + 26
    local clipY = y + 100
    local clipW = w - 52
    local clipH = 16
    local midY = clipY + clipH / 2
    local phase = (getTickCount() / 8) % 64

    local points = {}
    local step = 8

    for i = 0, clipW, step do
        local waveX = (i + phase) % 64
        local offset = 0

        if waveX > 10 and waveX <= 16 then
            offset = -5
        elseif waveX > 16 and waveX <= 22 then
            offset = 6
        elseif waveX > 22 and waveX <= 28 then
            offset = -7
        elseif waveX > 28 and waveX <= 34 then
            offset = 0
        else
            offset = math.sin((i + phase) / 18) * 1.2
        end

        local py = math.max(clipY + 2, math.min(clipY + clipH - 2, midY + offset))
        table.insert(points, { clipX + i, py })
    end

    for i = 1, #points - 1 do
        local x1, y1 = points[i][1], points[i][2]
        local x2, y2 = points[i + 1][1], points[i + 1][2]

        if x1 >= clipX and x2 <= clipX + clipW then
            dxDrawLine(x1, y1, x2, y2, tocolor(255, 75, 85, 185 * hoverAnim), 1.4)
        end
    end

    if medic then
        darkBar(x + 22, y + 128, w - 44, 22, math.min((100 - hp) / 100, 1), getText("COMPANION_HUD_MEDIC_HEAL"), tocolor(105, 105, 105, 235 * hoverAnim))
    else
        darkBar(x + 22, y + 128, w - 44, 22, math.min(ammo / 500, 1), getText("COMPANION_HUD_AMMO_WEAPON"):format(ammo, weapon), tocolor(105, 105, 105, 235 * hoverAnim))
    end
    darkBar(x + 22, y + 156, w - 44, 22, math.min(distance / range, 1), getText("COMPANION_HUD_RANGE"):format(distance, range), tocolor(85, 105, 75, 235 * hoverAnim))

    rect(x + 22, y + 188, w - 44, 36, tocolor(8, 8, 8, 220 * hoverAnim))
    dxDrawText(getText("COMPANION_HUD_MODE"):format(commandStatusName(command):upper()), x + 32, y + 191, x + w - 32, y + 213, tocolor(245, 245, 245, a), 0.86, "default-bold", "left", "center")
    dxDrawText(getText("COMPANION_HUD_TARGET"):format(target), x + 32, y + 206, x + w - 32, y + 228, tocolor(180, 180, 180, a), 0.8, "default-bold", "left", "center", true)

    local cy = y + 234
    local rowH = 16
    local gap = 3

    for _, cmd in ipairs(COMMANDS) do
        local active = command == cmd.id
        local leftColor = active and tocolor(150, 28, 36, 235 * hoverAnim) or tocolor(28, 28, 28, 220 * hoverAnim)
        local rightColor = active and tocolor(55, 20, 24, 230 * hoverAnim) or tocolor(18, 18, 18, 220 * hoverAnim)

        rect(x + 22, cy, 44, rowH, leftColor)
        rect(x + 72, cy, w - 94, rowH, rightColor)

        dxDrawText(cmd.key, x + 22, cy, x + 66, cy + rowH, tocolor(245, 245, 245, a), 0.68, "default-bold", "center", "center")
        dxDrawText(commandDisplayName(cmd, ped), x + 82, cy, x + w - 30, cy + rowH, tocolor(220, 220, 220, a), 0.68, "default-bold", "left", "center")

        cy = cy + rowH + gap
    end
end

local function renderActiveCompanion()
    drawNametag()
    drawUI()
end

startCompanionSystems = function()
    if not isTimer(aiTimer) then
        aiTimer = setTimer(updateCompanion, 50, 0)
    end

    if not activeRender then
        addEventHandler("onClientRender", root, renderActiveCompanion)
        activeRender = true
    end
end

stopCompanionSystems = function()
    if isTimer(aiTimer) then
        killTimer(aiTimer)
    end
    aiTimer = nil

    if activeRender then
        removeEventHandler("onClientRender", root, renderActiveCompanion)
        activeRender = false
    end
end

local function setCommand(command)
    local ped = getMyCompanion()

    if not isElement(ped) then
        return
    end

    triggerServerEvent("companion:setCommand", localPlayer, command)

    if command == "dismiss" then
        companionPed = nil
        uiAnim = 0
        hoverAnim = 0
    end
end

bindKey("1", "down", function() setCommand("follow") end)
bindKey("2", "down", function() setCommand("stay") end)
bindKey("3", "down", function() setCommand("attack") end)
bindKey("4", "down", function() setCommand("guard") end)
bindKey("5", "down", function() setCommand("dismiss") end)

local terminalOpen = false
local selectedCompanionType = "soldat"
local cursorWasShowing = false

local TERMINAL_BUTTON_W = 226
local TERMINAL_BUTTON_H = 42
local TERMINAL_BUTTON_RIGHT_MARGIN = 24
local TERMINAL_BUTTON_BOTTOM_OFFSET = 110

local COMPANION_OPTIONS = {
    soldat = {
        name = "Raven",
        roleKey = "COMPANION_ROLE_SOLDIER",
        descriptionKey = "COMPANION_TERMINAL_SOLDIER_DESCRIPTION",
        statKeys = {
            "COMPANION_TERMINAL_SOLDIER_STAT_ATTACK",
            "COMPANION_TERMINAL_SOLDIER_STAT_AMMO",
            "COMPANION_TERMINAL_SOLDIER_STAT_TASK"
        }
    },
    arzt = {
        name = "Doc Raven",
        roleKey = "COMPANION_ROLE_MEDIC",
        descriptionKey = "COMPANION_TERMINAL_MEDIC_DESCRIPTION",
        statKeys = {
            "COMPANION_TERMINAL_MEDIC_STAT_HEAL",
            "COMPANION_TERMINAL_MEDIC_STAT_RANGE",
            "COMPANION_TERMINAL_MEDIC_STAT_TASK"
        }
    }
}

local function getCurrentCompanionType()
    if not isElement(companionPed) then return nil end
    return getElementData(companionPed, "companion:type")
end

local function getTerminalButtonRect()
    local x = math.max(24, sx - TERMINAL_BUTTON_W - TERMINAL_BUTTON_RIGHT_MARGIN)
    local y = math.max(24, sy - TERMINAL_BUTTON_H - TERMINAL_BUTTON_BOTTOM_OFFSET)
    return x, y, TERMINAL_BUTTON_W, TERMINAL_BUTTON_H
end

local function getTerminalRect()
    local w = math.min(780, sx - 50)
    local h = math.min(500, sy - 50)
    return (sx - w) / 2, (sy - h) / 2, w, h
end

local function setTerminalVisible(state)
    terminalOpen = state == true
    if terminalOpen then
        cursorWasShowing = isCursorShowing()
        showCursor(true)
		setWindowData("no")
        selectedCompanionType = getCurrentCompanionType() or selectedCompanionType or "soldat"
    elseif not cursorWasShowing then
        showCursor(false)
		closeWindow()
    end
end

local function drawButton(x, y, w, h, text, selected, danger)
    local hovered = isMouseIn(x, y, w, h)
    local bg
    if danger then
        bg = hovered and tocolor(155, 42, 48, 250) or tocolor(105, 30, 35, 245)
    elseif selected then
        bg = hovered and tocolor(181, 127, 62, 250) or tocolor(150, 103, 48, 245)
    else
        bg = hovered and tocolor(52, 52, 52, 248) or tocolor(31, 31, 31, 242)
    end
    dxDrawRectangle(x + 3, y + 3, w, h, tocolor(0, 0, 0, 100))
    dxDrawRectangle(x, y, w, h, bg)
    dxDrawText(text, x + 10, y, x + w - 10, y + h, tocolor(255, 255, 255, 255), 0.92, "default-bold", "center", "center", true)
end

local function drawTerminalLauncher()
	if(isCharacterLoggedIn())then
		if(tonumber(apocalypseGetElementData(localPlayer,"level")) and tonumber(apocalypseGetElementData(localPlayer,"level")) >= 100)then
			local x, y, w, h = getTerminalButtonRect()
			local currentType = getCurrentCompanionType()
			local label = currentType and getText("COMPANION_TERMINAL_MANAGE") or getText("COMPANION_TERMINAL_CALL")
			drawButton(x, y, w, h, label, false, false)
		end
	end
end

local function drawCompanionTerminal()
    if not terminalOpen then return end

    local x, y, w, h = getTerminalRect()
    local currentType = getCurrentCompanionType()
    local selected = COMPANION_OPTIONS[selectedCompanionType]

    dxDrawRectangle(0, 0, sx, sy, tocolor(0, 0, 0, 165))
    dxDrawRectangle(x + 7, y + 7, w, h, tocolor(0, 0, 0, 130))
    dxDrawRectangle(x, y, w, h, tocolor(16, 16, 16, 252))
    dxDrawRectangle(x, y, w, 5, tocolor(174, 121, 58, 255))

    dxDrawText(getText("COMPANION_TERMINAL_TITLE"), x + 24, y + 12, x + w - 70, y + 48, tocolor(248, 238, 218, 255), 1.2, "default-bold", "left", "center")
    dxDrawText(getText("COMPANION_TERMINAL_SUBTITLE"), x + 24, y + 45, x + w - 24, y + 72, tocolor(175, 175, 175, 245), 0.84, "default", "left", "center")

    local closeX, closeY, closeW, closeH = x + w - 50, y + 14, 30, 30
    drawButton(closeX, closeY, closeW, closeH, "X", false, true)

    local listX, listY, listW = x + 24, y + 88, 260
    dxDrawText(getText("COMPANION_TERMINAL_AVAILABLE"), listX, listY - 24, listX + listW, listY, tocolor(210, 190, 155, 255), 0.82, "default-bold", "left", "center")

    local soldatActive = currentType == "soldat"
    local arztActive = currentType == "arzt"
    drawButton(listX, listY, listW, 64, getText("COMPANION_TERMINAL_OPTION"):format("RAVEN", getText("COMPANION_ROLE_SOLDIER"):upper()) .. (soldatActive and getText("COMPANION_TERMINAL_ACTIVE_SUFFIX") or ""), selectedCompanionType == "soldat", false)
    drawButton(listX, listY + 76, listW, 64, getText("COMPANION_TERMINAL_OPTION"):format("DOC RAVEN", getText("COMPANION_ROLE_MEDIC"):upper()) .. (arztActive and getText("COMPANION_TERMINAL_ACTIVE_SUFFIX") or ""), selectedCompanionType == "arzt", false)

    local detailX = listX + listW + 24
    local detailY = listY
    local detailW = w - (detailX - x) - 24
    local detailH = h - 112

    dxDrawRectangle(detailX, detailY, detailW, detailH, tocolor(24, 24, 24, 245))
    dxDrawRectangle(detailX, detailY, 5, detailH, tocolor(174, 121, 58, 255))

    dxDrawText(selected.name:upper(), detailX + 22, detailY + 16, detailX + detailW - 22, detailY + 48, tocolor(250, 240, 220, 255), 1.18, "default-bold", "left", "center")
    dxDrawText(getText(selected.roleKey):upper(), detailX + 22, detailY + 48, detailX + detailW - 22, detailY + 74, tocolor(190, 150, 90, 255), 0.92, "default-bold", "left", "center")
    dxDrawText(getText(selected.descriptionKey), detailX + 22, detailY + 82, detailX + detailW - 22, detailY + 108, tocolor(205, 205, 205, 245), 0.88, "default", "left", "center")

    local translatedStats = {}
    for _, key in ipairs(selected.statKeys) do
        translatedStats[#translatedStats + 1] = getText(key)
    end
    local statsText = table.concat(translatedStats, "\n")
    dxDrawText(statsText, detailX + 22, detailY + 122, detailX + detailW - 22, detailY + 210, tocolor(220, 220, 220, 245), 0.88, "default", "left", "top", true, true)

    local actionY = detailY + detailH - 104
    local actionText
    if not currentType then
        actionText = getText("COMPANION_TERMINAL_CALL_ROLE"):format(getText(selected.roleKey):upper())
    elseif currentType == selectedCompanionType then
        actionText = getText("COMPANION_TERMINAL_CURRENT_ACTIVE")
    else
        actionText = getText("COMPANION_TERMINAL_SWITCH_TO"):format(getText(selected.roleKey):upper())
    end

    drawButton(detailX + 22, actionY, detailW - 44, 44, actionText, currentType ~= selectedCompanionType, false)

    if currentType then
        drawButton(detailX + 22, actionY + 54, detailW - 44, 38, getText("COMPANION_TERMINAL_DISMISS_ACTIVE"), false, true)
    else
        dxDrawText(getText("COMPANION_TERMINAL_NONE_ACTIVE"), detailX + 22, actionY + 54, detailX + detailW - 22, actionY + 92, tocolor(140, 140, 140, 240), 0.82, "default", "center", "center")
    end
end

addEventHandler("onClientRender", root, function()
    drawTerminalLauncher()
    drawCompanionTerminal()
end)

addEventHandler("onClientClick", root, function(button, state)
    if button ~= "left" or state ~= "up" then return end

    if not terminalOpen then
        local bx, by, bw, bh = getTerminalButtonRect()
        if isMouseIn(bx, by, bw, bh) then
			if(tonumber(apocalypseGetElementData(localPlayer,"level")) and tonumber(apocalypseGetElementData(localPlayer,"level")) >= 100)then
				setTerminalVisible(true)
			end
        end
        return
    end

    local x, y, w, h = getTerminalRect()
    local closeX, closeY, closeW, closeH = x + w - 50, y + 14, 30, 30
    if isMouseIn(closeX, closeY, closeW, closeH) then
        setTerminalVisible(false)
		closeWindow()
        return
    end

    local listX, listY, listW = x + 24, y + 88, 260
    if isMouseIn(listX, listY, listW, 64) then
        selectedCompanionType = "soldat"
        return
    end
    if isMouseIn(listX, listY + 76, listW, 64) then
        selectedCompanionType = "arzt"
        return
    end

    local detailX = listX + listW + 24
    local detailY = listY
    local detailW = w - (detailX - x) - 24
    local detailH = h - 112
    local actionY = detailY + detailH - 104
    local currentType = getCurrentCompanionType()

    if isMouseIn(detailX + 22, actionY, detailW - 44, 44) then
        if currentType ~= selectedCompanionType then
            triggerServerEvent("companion:spawnOrSwitch", localPlayer, selectedCompanionType)
        end
        return
    end

    if currentType and isMouseIn(detailX + 22, actionY + 54, detailW - 44, 38) then
        triggerServerEvent("companion:dismiss", localPlayer)
        return
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    triggerServerEvent("companion:requestState", localPlayer)
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
    setTerminalVisible(false)
    stopCompanionSystems()
	closeWindow()
end)