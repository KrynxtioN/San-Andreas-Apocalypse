Fabrikwar = Fabrikwar or {}
Fabrikwar.Data = Fabrikwar.Data or {}
Fabrikwar.ActiveColony = Fabrikwar.ActiveColony or {}
Fabrikwar.Current = nil

local WAIT_MS  = 300000
local PREP_MS  = 30000
local FIGHT_MS = 900000

local function fwMsg(player, key, r, g, b, ...)
    local text = getText(player, key)
    if select("#", ...) > 0 then
        text = text:format(...)
    end
    outputChatBox(text, player, r or 255, g or 180, b or 0)
end

local reasonKeys = {
    no_defenders = "SFabrikwar11",
    not_started = "SFabrikwar12",
    time_expired = "SFabrikwar13",
    attackers_dead = "SFabrikwar14",
    defenders_dead = "SFabrikwar15",
    test_stop = "SFabrikwar16",
}

local function getReasonText(player, reason)
    return getText(player, reasonKeys[reason] or "SFabrikwar17")
end

local function getColonyName(id)
    return getPlayerData("colonys", "ID", id, "name") or ("#" .. tostring(id))
end

function Fabrikwar.getColonyRGB(colony)
    if getColonyColor then
        local c = getColonyColor(colony)
        if c and c[1] and c[2] and c[3] then
            return c[1], c[2], c[3]
        end
    end
    return 255, 255, 255
end

local function isLogged(player)
    return apocalypseGetElementData(player, "loggedin") == 1 or (isCharacterLoggedIn and isCharacterLoggedIn(player))
end

local function isParticipant(player)
    local cur = Fabrikwar.Current
    if not cur then return false end
    local colony = tonumber(apocalypseGetElementData(player, "colony"))
    return colony == tonumber(cur.attacker) or colony == tonumber(cur.defender)
end

local function isInAttackPoint(player, ID)
    if not ID or not Fabrikwar.Data[ID] or not isElement(Fabrikwar.Data[ID].Marker) then return false end
    if getElementDimension(player) ~= getElementDimension(Fabrikwar.Data[ID].Marker) then return false end
    if getElementInterior(player) ~= getElementInterior(Fabrikwar.Data[ID].Marker) then return false end
    return isElementWithinMarker(player, Fabrikwar.Data[ID].Marker)
end

function Fabrikwar.countPlayers(ID)
    local cur = Fabrikwar.Current
    local attackers, defenders = 0, 0
    if not cur then return attackers, defenders end

    for _, p in ipairs(getElementsByType("player")) do
        if isLogged(p) and isInAttackPoint(p, ID) then
            local colony = tonumber(apocalypseGetElementData(p, "colony"))
            if colony == tonumber(cur.attacker) then
                attackers = attackers + 1
            elseif colony == tonumber(cur.defender) then
                defenders = defenders + 1
            end
        end
    end
    return attackers, defenders
end

local function sendHudToParticipant(player, phase, remainingMs, attackers, defenders)
    local cur = Fabrikwar.Current
    if not cur then return end

    local ar, ag, ab = Fabrikwar.getColonyRGB(cur.attacker)
    local dr, dg, db = Fabrikwar.getColonyRGB(cur.defender)

    triggerClientEvent(player, "Fabrikwar.hudStart", player,
        phase,
        remainingMs,
        attackers or cur.attackers or 0,
        defenders or cur.defenders or 0,
        getColonyName(cur.attacker),
        getColonyName(cur.defender),
        ar, ag, ab,
        dr, dg, db
    )
end

function Fabrikwar.broadcastHud(phase, remainingMs, attackers, defenders)
    for _, p in ipairs(getElementsByType("player")) do
        if isLogged(p) and isParticipant(p) then
            sendHudToParticipant(p, phase, remainingMs, attackers, defenders)
        end
    end
end

function Fabrikwar.updateHud()
    local cur = Fabrikwar.Current
    if not cur then return end

    local now = getTickCount()
    local remaining = math.max(0, (cur.phaseEnd or now) - now)
    Fabrikwar.broadcastHud(cur.phase, remaining, cur.attackers or 0, cur.defenders or 0)
end

function Fabrikwar.cleanup(ID, stopHud)
    local cur = Fabrikwar.Current
    if cur then
        if isTimer(cur.waitTimer) then killTimer(cur.waitTimer) end
        if isTimer(cur.prepTimer) then killTimer(cur.prepTimer) end
        if isTimer(cur.fightTimer) then killTimer(cur.fightTimer) end
        if isTimer(cur.checkTimer) then killTimer(cur.checkTimer) end
        if isTimer(cur.hudTimer) then killTimer(cur.hudTimer) end
    end

    if ID and Fabrikwar.Data[ID] then
        Fabrikwar.Data[ID].Blocked = false
        Fabrikwar.Data[ID].ActiveFabrikwar = false
    end

    if cur then
        Fabrikwar.ActiveColony[cur.attacker] = false
        Fabrikwar.ActiveColony[cur.defender] = false
    end

    if stopHud ~= false then
        for _, p in ipairs(getElementsByType("player")) do
            triggerClientEvent(p, "Fabrikwar.hudStop", p)
            apocalypseSetElementData(p, "InFabrikwar", false)
        end
    end

    Fabrikwar.Current = nil
    Fabrikwar.active = false
    Fabrikwar.ID = nil
    Fabrikwar.attackerID = nil
    Fabrikwar.defenderID = nil
end

function Fabrikwar.finish(winner, reason)
    local cur = Fabrikwar.Current
    if not cur then return end
    local ID = cur.ID
    local loser = tonumber(winner) == tonumber(cur.attacker) and cur.defender or cur.attacker

    dbExec(handler, "UPDATE fabrikwars SET Besitzer = ? WHERE ID = ?", winner, ID)
    if Fabrikwar.Data[ID] then
        Fabrikwar.Data[ID].Owner = winner
    end

    for _, p in ipairs(getElementsByType("player")) do
        if isLogged(p) then
            if tonumber(apocalypseGetElementData(p, "colony")) == tonumber(winner) then
                fwMsg(p, "SFabrikwar1", 0, 180, 0, getReasonText(p, reason))
            elseif tonumber(apocalypseGetElementData(p, "colony")) == tonumber(loser) then
                fwMsg(p, "SFabrikwar2", 180, 0, 0, getReasonText(p, reason))
            end
            Fabrikwar.loadBlips(p)
        end
    end

    Fabrikwar.cleanup(ID, true)
end

function Fabrikwar.startFight()
    local cur = Fabrikwar.Current
    if not cur then return end

    if isTimer(cur.prepTimer) then killTimer(cur.prepTimer) end
    cur.phase = "fight"
    cur.phaseEnd = getTickCount() + FIGHT_MS

    for _, p in ipairs(getElementsByType("player")) do
        if isLogged(p) and isParticipant(p) then
            apocalypseSetElementData(p, "InFabrikwar", isInAttackPoint(p, cur.ID))
            fwMsg(p, "SFabrikwar3", 255, 80, 80)
        end
    end

    Fabrikwar.broadcastHud("fight", FIGHT_MS, cur.attackers, cur.defenders)

    cur.fightTimer = setTimer(function()
        local c = Fabrikwar.Current
        if not c then return end
        Fabrikwar.finish(c.defender, "time_expired")
    end, FIGHT_MS, 1)
end

function Fabrikwar.startPrep()
    local cur = Fabrikwar.Current
    if not cur then return end

    if isTimer(cur.waitTimer) then killTimer(cur.waitTimer) end
    cur.phase = "prep"
    cur.phaseEnd = getTickCount() + PREP_MS

    for _, p in ipairs(getElementsByType("player")) do
        if isLogged(p) and isParticipant(p) then
            fwMsg(p, "SFabrikwar4", 255, 180, 0)
        end
    end

    Fabrikwar.broadcastHud("prep", PREP_MS, cur.attackers, cur.defenders)
    cur.prepTimer = setTimer(Fabrikwar.startFight, PREP_MS, 1)
end

function Fabrikwar.checkAttack()
    local cur = Fabrikwar.Current
    if not cur then return end

    local attackers, defenders = Fabrikwar.countPlayers(cur.ID)
    cur.attackers = attackers
    cur.defenders = defenders

    for _, p in ipairs(getElementsByType("player")) do
        if isLogged(p) and isParticipant(p) then
            apocalypseSetElementData(p, "InFabrikwar", isInAttackPoint(p, cur.ID))
        else
            apocalypseSetElementData(p, "InFabrikwar", false)
        end
    end

    if cur.phase == "wait" then
        if attackers >= 1 and defenders >= 1 and attackers == defenders then
            Fabrikwar.startPrep()
        end
    elseif cur.phase == "fight" then
        if attackers <= 0 and defenders > 0 then
            Fabrikwar.finish(cur.defender, "attackers_dead")
        elseif defenders <= 0 and attackers > 0 then
            Fabrikwar.finish(cur.attacker, "defenders_dead")
        end
    end
end

function Fabrikwar.load()
    local result = dbPoll(dbQuery(handler, "SELECT * FROM fabrikwars"), -1) or {}
    for _, v in ipairs(result) do
        local ID = tonumber(v.ID)
        local x, y, z = tonumber(v.Spawnx), tonumber(v.Spawny), tonumber(v.Spawnz)
        local owner = tonumber(v.Besitzer) or 0

        Fabrikwar.Data[ID] = {
            Pickup = createPickup(x, y, z, 3, 1313, 50),
            Owner = owner,
            Blocked = false,
            ActiveFabrikwar = false,
            Marker = createMarker(x, y, z - 0.9, "cylinder", 7.5, 255, 255, 255, 0),
        }

        setElementInterior(Fabrikwar.Data[ID].Pickup, tonumber(v.Interior) or 0)
        setElementDimension(Fabrikwar.Data[ID].Pickup, tonumber(v.Dimension) or 0)
        setElementInterior(Fabrikwar.Data[ID].Marker, tonumber(v.Interior) or 0)
        setElementDimension(Fabrikwar.Data[ID].Marker, tonumber(v.Dimension) or 0)
        apocalypseSetElementData(Fabrikwar.Data[ID].Pickup, "FabrikwarID", ID)

        addEventHandler("onPickupHit", Fabrikwar.Data[ID].Pickup, function(player)
            if getElementType(player) ~= "player" then return end
            local fid = apocalypseGetElementData(source, "FabrikwarID")
            if tonumber(apocalypseGetElementData(player, "colony")) and tonumber(apocalypseGetElementData(player, "colony")) >= 1 then
                apocalypseSetElementData(player, "FabrikwarID", fid)
                if Fabrikwar.Data[fid] and not Fabrikwar.Data[fid].ActiveFabrikwar then
                    triggerClientEvent(player, "Fabrikwar.openWindow", player)
                end
            end
        end)
    end
end
Fabrikwar.load()

function Fabrikwar.loadBlips(player)
    local result = dbPoll(dbQuery(handler, "SELECT * FROM fabrikwars"), -1) or {}
    local tbl = {}
    for _, v in ipairs(result) do
        table.insert(tbl, {tonumber(v.Blipx), tonumber(v.Blipy), tonumber(v.Besitzer) or 0})
    end
    triggerClientEvent(player, "Fabrikwar.loadBlips", player, tbl)
end

addEvent("Fabrikwar.attack", true)
addEventHandler("Fabrikwar.attack", root, function()
    local player = client
    local ID = tonumber(apocalypseGetElementData(player, "FabrikwarID"))
    if not ID or not Fabrikwar.Data[ID] then return end

    local attacker = tonumber(apocalypseGetElementData(player, "colony"))
    local defender = tonumber(Fabrikwar.Data[ID].Owner) or tonumber(getPlayerData("fabrikwars", "ID", ID, "Besitzer"))

    if not attacker or attacker < 1 then return end
    if defender == attacker then fwMsg(player, "SFabrikwar5", 180, 0, 0) return end
    if Fabrikwar.active then fwMsg(player, "SFabrikwar6", 180, 0, 0) return end
    if Fabrikwar.Data[ID].Blocked then fwMsg(player, "SFabrikwar7", 180, 0, 0) return end
    if Fabrikwar.ActiveColony[attacker] or Fabrikwar.ActiveColony[defender] then fwMsg(player, "SFabrikwar8", 180, 0, 0) return end

    Fabrikwar.active = true
    Fabrikwar.ID = ID
    Fabrikwar.attackerID = attacker
    Fabrikwar.defenderID = defender
    Fabrikwar.Data[ID].Blocked = true
    Fabrikwar.Data[ID].ActiveFabrikwar = true
    Fabrikwar.ActiveColony[attacker] = true
    Fabrikwar.ActiveColony[defender] = true

    dbExec(handler, "UPDATE fabrikwars SET Besitzer = ? WHERE ID = ?", 0, ID)

    Fabrikwar.Current = {
        ID = ID,
        attacker = attacker,
        defender = defender,
        phase = "wait",
        phaseEnd = getTickCount() + WAIT_MS,
        attackers = 0,
        defenders = 0,
    }

    for _, p in ipairs(getElementsByType("player")) do
        if isLogged(p) then
            if tonumber(apocalypseGetElementData(p, "colony")) == attacker then
                fwMsg(p, "SFabrikwar9", 255, 180, 0)
            elseif tonumber(apocalypseGetElementData(p, "colony")) == defender then
                fwMsg(p, "SFabrikwar10", 255, 80, 80)
            end
            Fabrikwar.loadBlips(p)
        end
    end

    Fabrikwar.Current.checkTimer = setTimer(Fabrikwar.checkAttack, 1000, 0)
    Fabrikwar.Current.hudTimer = setTimer(Fabrikwar.updateHud, 1000, 0)
    Fabrikwar.Current.waitTimer = setTimer(function()
        local cur = Fabrikwar.Current
        if not cur then return end
        local attackers, defenders = Fabrikwar.countPlayers(cur.ID)
        if attackers > 0 and defenders <= 0 then
            Fabrikwar.finish(cur.attacker, "no_defenders")
        else
            Fabrikwar.finish(cur.defender, "not_started")
        end
    end, WAIT_MS, 1)

    triggerClientEvent(player, "closeWindow", player)
end)

function Fabrikwar.broadcastKillMessage(deadPlayer)
    local cur = Fabrikwar.Current
    if not cur or cur.phase ~= "fight" then return end
    if not deadPlayer or not isElement(deadPlayer) then return end

    local deadColony = tonumber(apocalypseGetElementData(deadPlayer, "colony"))
    if deadColony ~= tonumber(cur.attacker) and deadColony ~= tonumber(cur.defender) then return end

    local name = getPlayerName(deadPlayer)
    name = string.gsub(name, "#%x%x%x%x%x%x", "")

    for _, p in ipairs(getElementsByType("player")) do
        if isLogged(p) and isParticipant(p) then
            triggerClientEvent(p, "Fabrikwar.killMessage", p, name)
        end
    end
end

function Fabrikwar.onPlayerOut(player)
    local cur = Fabrikwar.Current
    if not cur or cur.phase ~= "fight" then return end
    if apocalypseGetElementData(player, "InFabrikwar") == true then
        setTimer(Fabrikwar.checkAttack, 200, 1)
    end
end

addEventHandler("onPlayerQuit", root, function() Fabrikwar.onPlayerOut(source) end)
addEventHandler("onPlayerWasted", root, function()
    Fabrikwar.broadcastKillMessage(source)
    Fabrikwar.onPlayerOut(source)
end)

addEventHandler("onPlayerLogin", root, function()
    setTimer(function(player)
        local cur = Fabrikwar.Current
        if cur and isElement(player) and isParticipant(player) then
            local remaining = math.max(0, cur.phaseEnd - getTickCount())
            sendHudToParticipant(player, cur.phase, remaining, cur.attackers, cur.defenders)
        end
    end, 1000, 1, source)
end)