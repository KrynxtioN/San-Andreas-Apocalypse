local companions = {}
local testPeds = {}
local lastDamage = {}
local lastHeal = {}
local lastDialog = {}

local COMPANION_TYPES = {
    soldat = {
        model = 287,
        name = "Raven",
        class = "soldier",
        labelKey = "COMPANION_ROLE_SOLDIER",
        weapon = 31,
        ammo = 500,
        introKey = "COMPANION_INTRO_SOLDIER"
    },
    arzt = {
        model = 274,
        name = "Doc Raven",
        class = "medic",
        labelKey = "COMPANION_ROLE_MEDIC",
        weapon = 0,
        ammo = 0,
        introKey = "COMPANION_INTRO_MEDIC"
    }
}

local DEFAULT_TYPE = "soldat"
local DEFAULT_WEAPON = COMPANION_TYPES.soldat.weapon
local DEFAULT_AMMO = COMPANION_TYPES.soldat.ammo

local ATTACK_RANGE = 48
local DAMAGE = 14
local DAMAGE_INTERVAL = 360

local HEAL_AMOUNT = 10
local HEAL_INTERVAL = 2600
local HEAL_RANGE = 7.5
local HEAL_MAX_HEALTH = 100

local validCommands = {
    follow = true,
    stay = true,
    attack = true,
    guard = true,
    dismiss = true
}

local function getCompanionName(ped)
    return getElementData(ped, "companion:name") or "Raven"
end

local function guardianSay(player, ped, text, cooldown)
    if not isElement(player) or not isElement(ped) then return end

    local now = getTickCount()
    cooldown = cooldown or 1800
    lastDialog[ped] = lastDialog[ped] or {}

    if lastDialog[ped][text] and now - lastDialog[ped][text] < cooldown then
        return
    end

    lastDialog[ped][text] = now
    outputChatBox("#9C7B4B[" .. getCompanionName(ped) .. "] #E8D8B8" .. text, player, 255, 255, 255, true)
end

local function destroyCompanion(player)
    local ped = companions[player]
    if isElement(ped) then
        triggerClientEvent(player, "companion:onRemoved", player, ped)
        lastDamage[ped] = nil
        lastHeal[ped] = nil
        lastDialog[ped] = nil
        destroyElement(ped)
    end
    companions[player] = nil
end

local function getTargetName(owner, target)
    if getElementType(target) == "player" then
        return getPlayerName(target)
    end

    if getElementData(target, "zombie:name") then
        return getElementData(target, "zombie:name")
    end

    if getElementData(target, "zombie") == true then
        return getText(owner, "COMPANION_TARGET_ZOMBIE")
    end

    if getElementData(target, "companion:testTarget") then
        return getText(owner, "COMPANION_TARGET_TEST_PED")
    end

    return getText(owner, "COMPANION_TARGET_INFECTED")
end

local function isServerValidTarget(owner, ped, target)
    if not isElement(owner) or not isElement(ped) or not isElement(target) then return false end
    if target == owner or target == ped then return false end
    if getElementHealth(target) <= 0 then return false end
    if getElementData(ped, "companion:class") == "medic" then return false end

    local targetType = getElementType(target)

    if targetType == "ped" then
        if getElementData(target, "companion:active") then return false end

        local isZombie = getElementData(target, "zombie") == true
        local isOldZombieTarget = getElementData(target, "zombieTarget") == true
        local isTestTarget = getElementData(target, "companion:testTarget") == true

        if not isZombie and not isOldZombieTarget and not isTestTarget then
            return false
        end
    elseif targetType ~= "player" then
        return false
    end

    local px, py, pz = getElementPosition(ped)
    local tx, ty, tz = getElementPosition(target)
    local dist = getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz)

    return dist <= ATTACK_RANGE
end

local function normalizeCompanionType(typeName)
    typeName = tostring(typeName or DEFAULT_TYPE):lower()

    if typeName == "medic" or typeName == "arzt" or typeName == "doctor" then
        return "arzt"
    end

    if typeName == "soldier" or typeName == "soldat" or typeName == "raven" then
        return "soldat"
    end

    return nil
end

local function createCompanion(player, typeName)
    local config = COMPANION_TYPES[typeName] or COMPANION_TYPES[DEFAULT_TYPE]
    local x, y, z = getElementPosition(player)
    local ped = createPed(config.model, x + 1.8, y + 1.8, z, 0, true)

    if not ped then
        outputChatBox(getText(player, "COMPANION_CREATE_FAILED"), player, 255, 80, 80)
        return
    end

    companions[player] = ped

    setElementInterior(ped, getElementInterior(player))
    setElementDimension(ped, getElementDimension(player))

    setElementData(ped, "companion:active", true)
    setElementData(ped, "companion:owner", player)
    setElementData(ped, "companion:type", typeName)
    setElementData(ped, "companion:class", config.class)
    setElementData(ped, "companion:typeLabel", getText(player, config.labelKey))
    setElementData(ped, "companion:name", config.name)
    setElementData(ped, "companion:command", "follow")
    setElementData(ped, "companion:weapon", config.weapon)
    setElementData(ped, "companion:ammo", config.ammo)
    setElementData(ped, "companion:maxHealth", 100)
    setElementData(ped, "companion:range", ATTACK_RANGE)
    setElementData(ped, "companion:healAmount", HEAL_AMOUNT)
    setElementData(ped, "companion:healRange", HEAL_RANGE)
    setElementData(ped, "companion:targetName", config.class == "medic" and getText(player, "COMPANION_STATUS_READY_TO_HEAL") or getText(player, "COMPANION_STATUS_NO_TARGET"))

    setElementSyncer(ped, player)

    if config.class == "soldier" then
        triggerClientEvent(root, "companion:clientGiveWeapon", resourceRoot, ped, config.weapon, config.ammo)
    end

    triggerClientEvent(player, "companion:onCreated", player, ped)
    guardianSay(player, ped, getText(player, config.introKey))
end

local function toggleCompanion(player, typeName)
    if not isElement(player) then return end

    if isElement(companions[player]) then
        local oldPed = companions[player]
        guardianSay(player, oldPed, getText(player, "COMPANION_DIALOG_DISMISS"), 700)
        destroyCompanion(player)
        outputChatBox(getText(player, "COMPANION_REMOVED"), player, 255, 255, 255, true)
        return
    end

    local normalizedType = normalizeCompanionType(typeName)
    if not normalizedType then
        outputChatBox(getText(player, "COMPANION_UNKNOWN_TYPE_HELP"), player, 255, 255, 255, true)
        return
    end

    createCompanion(player, normalizedType)
end

addEvent("companion:toggle", true)
addEventHandler("companion:toggle", root, function(typeName)
    if client ~= source then return end
    toggleCompanion(client, typeName)
end)


local function spawnOrSwitchCompanion(player, typeName)
    if not isElement(player) then return end

    local normalizedType = normalizeCompanionType(typeName)
    if not normalizedType then
        outputChatBox(getText(player, "COMPANION_UNKNOWN_TYPE"), player, 255, 255, 255, true)
        return
    end

    local currentPed = companions[player]
    if isElement(currentPed) then
        local currentType = getElementData(currentPed, "companion:type")
        if currentType == normalizedType then
            outputChatBox(getText(player, "COMPANION_ALREADY_ACTIVE"), player, 255, 255, 255, true)
            return
        end
        destroyCompanion(player)
    end

    createCompanion(player, normalizedType)
end

addEvent("companion:spawnOrSwitch", true)
addEventHandler("companion:spawnOrSwitch", root, function(typeName)
    if client ~= source then return end
    spawnOrSwitchCompanion(client, typeName)
end)

addEvent("companion:dismiss", true)
addEventHandler("companion:dismiss", root, function()
    if client ~= source then return end
    local ped = companions[client]
    if not isElement(ped) then return end
    guardianSay(client, ped, getText(client, "COMPANION_DIALOG_DISMISS"), 700)
    destroyCompanion(client)
    outputChatBox(getText(client, "COMPANION_DISMISSED"), client, 255, 255, 255, true)
end)

addEvent("companion:requestState", true)
addEventHandler("companion:requestState", root, function()
    if client ~= source then return end

    local ped = companions[client]
    if isElement(ped) then
        triggerClientEvent(client, "companion:onCreated", client, ped)
    else
        triggerClientEvent(client, "companion:onRemoved", client, false)
    end
end)


--[[addCommandHandler("begleiterwaffe", function(player, _, weaponID, ammo)
    local ped = companions[player]

    if not isElement(ped) then
        outputChatBox(getText(player, "COMPANION_NONE"), player, 255, 80, 80)
        return
    end

    if getElementData(ped, "companion:class") == "medic" then
        guardianSay(player, ped, getText(player, "COMPANION_DIALOG_MEDIC_NO_WEAPON"))
        return
    end

    weaponID = tonumber(weaponID) or DEFAULT_WEAPON
    ammo = tonumber(ammo) or DEFAULT_AMMO

    if weaponID < 0 or weaponID > 46 then
        outputChatBox(getText(player, "COMPANION_INVALID_WEAPON"), player, 255, 80, 80)
        return
    end

    setElementData(ped, "companion:weapon", weaponID)
    setElementData(ped, "companion:ammo", ammo)

    triggerClientEvent(root, "companion:clientGiveWeapon", resourceRoot, ped, weaponID, ammo)
    guardianSay(player, ped, getText(player, "COMPANION_DIALOG_WEAPON_LOADED"))
end)]]--

addEvent("companion:setCommand", true)
addEventHandler("companion:setCommand", root, function(command)
    local ped = companions[client]
    if not isElement(ped) then return end
    if not validCommands[command] then return end

    if command == "dismiss" then
        guardianSay(client, ped, getText(client, "COMPANION_DIALOG_DISMISS"), 700)
        destroyCompanion(client)
        return
    end

    setElementData(ped, "companion:command", command)

    local isMedic = getElementData(ped, "companion:class") == "medic"
    local lines = {
        follow = isMedic and getText(client, "COMPANION_DIALOG_FOLLOW_MEDIC") or getText(client, "COMPANION_DIALOG_FOLLOW_SOLDIER"),
        stay = getText(client, "COMPANION_DIALOG_STAY"),
        attack = isMedic and getText(client, "COMPANION_DIALOG_ATTACK_MEDIC") or getText(client, "COMPANION_DIALOG_ATTACK_SOLDIER"),
        guard = isMedic and getText(client, "COMPANION_DIALOG_GUARD_MEDIC") or getText(client, "COMPANION_DIALOG_GUARD_SOLDIER")
    }

    guardianSay(client, ped, lines[command] or getText(client, "COMPANION_DIALOG_COMMAND_RECEIVED"), 700)
end)

addEvent("companion:dialog", true)
addEventHandler("companion:dialog", root, function(ped, text, cooldown)
    if companions[client] ~= ped then return end
    guardianSay(client, ped, tostring(text), tonumber(cooldown) or 1800)
end)

addEvent("companion:requestHeal", true)
addEventHandler("companion:requestHeal", root, function(ped)
    if companions[client] ~= ped then return end
    if not isElement(ped) then return end
    if getElementData(ped, "companion:class") ~= "medic" then return end

    local owner = client
    if not isElement(owner) or getElementHealth(owner) <= 0 then return end

    local px, py, pz = getElementPosition(ped)
    local ox, oy, oz = getElementPosition(owner)
    local dist = getDistanceBetweenPoints3D(px, py, pz, ox, oy, oz)
    if dist > HEAL_RANGE then return end

    local now = getTickCount()
    lastHeal[ped] = lastHeal[ped] or 0
    if now - lastHeal[ped] < HEAL_INTERVAL then return end

    local hp = getElementHealth(owner) or HEAL_MAX_HEALTH
    if hp >= HEAL_MAX_HEALTH then
        setElementData(ped, "companion:targetName", getText(owner, "COMPANION_STATUS_NO_HEAL_NEEDED"))
        return
    end

    lastHeal[ped] = now
    local newHP = math.min(HEAL_MAX_HEALTH, hp + HEAL_AMOUNT)
    setElementHealth(owner, newHP)
    setElementData(ped, "companion:targetName", getText(owner, "COMPANION_STATUS_HEALING"):format(math.floor(newHP)))
    triggerClientEvent(client, "companion:healFX", resourceRoot, ped, owner, newHP)

    if newHP >= HEAL_MAX_HEALTH then
        guardianSay(owner, ped, getText(owner, "COMPANION_DIALOG_STABLE"), 2600)
    else
        guardianSay(owner, ped, getText(owner, "COMPANION_DIALOG_HEALING"):format(math.floor(newHP)), 2600)
    end
end)

addEvent("companion:requestShot", true)
addEventHandler("companion:requestShot", root, function(ped, target, clientSawTarget)
    if companions[client] ~= ped then return end
    if not clientSawTarget then return end
    if not isServerValidTarget(client, ped, target) then return end

    local now = getTickCount()
    lastDamage[ped] = lastDamage[ped] or 0

    if now - lastDamage[ped] < DAMAGE_INTERVAL then return end
    lastDamage[ped] = now

    local ammo = tonumber(getElementData(ped, "companion:ammo")) or 0
    local weapon = tonumber(getElementData(ped, "companion:weapon")) or DEFAULT_WEAPON

    if ammo <= 0 then
        guardianSay(client, ped, getText(client, "COMPANION_DIALOG_NO_AMMO"), 2500)
        return
    end

    setElementData(ped, "companion:ammo", ammo - 1)
    setElementData(ped, "companion:targetName", getTargetName(client, target))

    triggerClientEvent(root, "companion:syncShotFX", resourceRoot, ped, target)

    local hp = getElementHealth(target)
    local newHP = hp - DAMAGE

    if newHP <= 0 then
        killPed(target, client, weapon, 3)
        guardianSay(client, ped, getText(client, "COMPANION_DIALOG_TARGET_DOWN"), 1200)
    else
        setElementHealth(target, newHP)
    end
end)

addEventHandler("onPedDamage", root, function()
    if not getElementData(source, "companion:active") then return end

    local owner = getElementData(source, "companion:owner")
    if isElement(owner) then
        guardianSay(owner, source, getText(owner, "COMPANION_DIALOG_HIT"), 2300)
    end
end)


local function syncCompanionWorld(player, moveToOwner)
    if not isElement(player) then return end

    local ped = companions[player]
    if not isElement(ped) then return end

    local interior = getElementInterior(player)
    local dimension = getElementDimension(player)

    if getElementInterior(ped) ~= interior then
        setElementInterior(ped, interior)
    end

    if getElementDimension(ped) ~= dimension then
        setElementDimension(ped, dimension)
    end

    if moveToOwner then
        local x, y, z = getElementPosition(player)
        local _, _, rz = getElementRotation(player)
        local rad = math.rad(rz)
        local spawnX = x + math.sin(-rad) * 1.8
        local spawnY = y + math.cos(-rad) * 1.8
        setElementPosition(ped, spawnX, spawnY, z)
        setPedRotation(ped, rz)
    end
end

addEventHandler("onElementDimensionChange", root, function()
    if getElementType(source) == "player" and isElement(companions[source]) then
        syncCompanionWorld(source, true)
    end
end)

addEventHandler("onElementInteriorChange", root, function()
    if getElementType(source) == "player" and isElement(companions[source]) then
        syncCompanionWorld(source, true)
    end
end)

addEventHandler("onPlayerSpawn", root, function()
    if isElement(companions[source]) then
        syncCompanionWorld(source, true)
    end
end)

addEventHandler("onPlayerQuit", root, function()
    destroyCompanion(source)
end)

addEventHandler("onResourceStop", resourceRoot, function()
    for player in pairs(companions) do
        destroyCompanion(player)
    end

    for _, ped in ipairs(testPeds) do
        if isElement(ped) then destroyElement(ped) end
    end
end)