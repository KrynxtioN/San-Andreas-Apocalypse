ColonyFlag = {flag = {}, ownerShelter = nil, pickupBlockedUntil = {}}
local FlagCooldown = false

local q = dbQuery(handler,"SELECT ID FROM shelter")
local result = dbPoll(q, 5000)

if result and #result > 0 then
    ColonyFlag.ownerShelter = tonumber(result[math.random(#result)].ID)
else
    ColonyFlag.ownerShelter = 0
end

function ColonyFlag.sendRenderState(target, object, state, respawnEnd)
    if not isElement(target) then return end
    triggerClientEvent(target, "ColonyFlag.setRenderObject", target, object, state, respawnEnd or false)
end

function ColonyFlag.broadcastRenderState(object, state, respawnEnd)
    triggerClientEvent(root, "ColonyFlag.setRenderObject", root, object, state, respawnEnd or false)
end

function ColonyFlag.clearRenderState(target)
    if not isElement(target) then return end
    triggerClientEvent(target, "ColonyFlag.clearRenderObject", target)
end

function ColonyFlag.broadcastClearRenderState()
    triggerClientEvent(root, "ColonyFlag.clearRenderObject", root)
end

function ColonyFlag.canPickupDroppedFlag(player)
    local blockedUntil = ColonyFlag.pickupBlockedUntil[player]
    if not blockedUntil then return true end
    return getTickCount() >= blockedUntil
end

function ColonyFlag.placeFlag(owner_shelter_id)
    ColonyFlag.ownerShelter = tonumber(owner_shelter_id)

    if isElement(ColonyFlag.flagPositionBlip) then destroyElement(ColonyFlag.flagPositionBlip) end
    if isElement(ColonyFlag.shelterFlagPickup) then destroyElement(ColonyFlag.shelterFlagPickup) end
    if isElement(ColonyFlag.objectMarker) then destroyElement(ColonyFlag.objectMarker) end
    if isElement(ColonyFlag.object) then destroyElement(ColonyFlag.object) end
    if isElement(ColonyFlag.InfoMarker) then destroyElement(ColonyFlag.InfoMarker) end

    local x = tonumber(getPlayerData("shelter","ID",ColonyFlag.ownerShelter,"posx"))
    local y = tonumber(getPlayerData("shelter","ID",ColonyFlag.ownerShelter,"posy"))
    local z = tonumber(getPlayerData("shelter","ID",ColonyFlag.ownerShelter,"posz"))

    ColonyFlag.shelterFlagPickup = createObject(11245,x,y,z + 1.3,0,290,90)
    setObjectScale(ColonyFlag.shelterFlagPickup,0.2)

    ColonyFlag.broadcastRenderState(ColonyFlag.shelterFlagPickup, "pickup", false)

    ColonyFlag.flagPositionBlip = createBlip(x,y,z, 19, 0, 0, 0, 255, 255,0, 50)
    ColonyFlag.objectMarker = createMarker(x,y,z-0.7,"cylinder",2.5,0,0,0,0)
    ColonyFlag.InfoMarker = createMarker(x,y,z,"cylinder",10,255,0,0,0)

    addEventHandler("onMarkerHit",ColonyFlag.objectMarker,function(player)
        if getElementType(player) ~= "player" then return end
        if not isPedInVehicle(player) then
            if getElementDimension(player) == getElementDimension(source) then
                ColonyFlag.takeFlag(player)
            end
        end
    end)

    addEventHandler("onMarkerHit",ColonyFlag.InfoMarker,function(player)
        if getElementType(player) ~= "player" then return end
        if getElementDimension(player) == getElementDimension(source) then
            triggerClientEvent(player, "showInformationHelpBar", player, getText(player, "SFlag4"), getText(player, "SFlag5"))
        end
    end)
end
ColonyFlag.placeFlag(ColonyFlag.ownerShelter)

function ColonyFlag.deliver(player,shelter_id)
    if ColonyFlag.flag[player] == true then
        local ShelterColony = tonumber(getPlayerData("shelter","ID",shelter_id,"colony"))

        if apocalypseGetElementData(player,"colony") == ShelterColony then
            if isElement(ColonyFlag.object) then
                destroyElement(ColonyFlag.object)
            end

            ColonyFlag.clearRenderState(player)
            ColonyFlag.flag[player] = false
            ColonyFlag.placeFlag(tonumber(shelter_id))
            FlagCooldown = true
            setAchievement(player,399)
        end
    end
end

function ColonyFlag.takeFlag(player)
    if apocalypseGetElementData(player,"colony") >= 1 then
        if not isPedDead(player) then
            if not isPedInVehicle(player) then
                local ShelterColony = tonumber(getPlayerData("shelter","ID",ColonyFlag.ownerShelter,"colony"))
                if tonumber(apocalypseGetElementData(player,"colony")) ~= ShelterColony then
                    if not ColonyFlag.flag[player] then
                        ColonyFlag.flag[player] = false
                    end

                    if isElement(ColonyFlag.shelterFlagPickup) then destroyElement(ColonyFlag.shelterFlagPickup) end
                    if isElement(ColonyFlag.flagPositionBlip) then destroyElement(ColonyFlag.flagPositionBlip) end
                    if isElement(ColonyFlag.objectMarker) then destroyElement(ColonyFlag.objectMarker) end
                    if isElement(ColonyFlag.object) then destroyElement(ColonyFlag.object) end
                    if isElement(ColonyFlag.InfoMarker) then destroyElement(ColonyFlag.InfoMarker) end

                    ColonyFlag.broadcastClearRenderState()

                    local x,y,z = getElementPosition(player)
                    ColonyFlag.object = createObject(11245,x,y,z,0,290,180)
                    setObjectScale(ColonyFlag.object,0.2)
                    attachElements(ColonyFlag.object,player,0.1,-0.2,0.4,0,290,0)

                    ColonyFlag.createBlip(player)
                    ColonyFlag.flag[player] = true
                    setAchievement(player,398)
                    bindKey(player,"e","down",ColonyFlag.dropFlag)
                    triggerClientEvent(player,"createActivitiesInformationText",player,getText(player,"SFlag1"))

                    local pos = Shelter.getColonyShelterPosition(apocalypseGetElementData(player, "colony"))
                    if pos ~= false then
                        local x, y, z = pos[1], pos[2], pos[3]
                        triggerClientEvent(player,"ColonyFlag.createBlip",player,x,y,z)
                    else
                        NPC.MeMessage(player,getText(player,"SFlag3"))
                    end
                end
            end
        end
    else
        NPC.MeMessage(player,getText(player,"SFlag2"))
    end
end

function ColonyFlag.refreshFlagObject(player)
    if ColonyFlag.flag[player] and ColonyFlag.flag[player] == true then
        setElementInterior(ColonyFlag.object,getElementInterior(player))
        setElementDimension(ColonyFlag.object,getElementDimension(player))
    end
end

function ColonyFlag.createBlip(player)
    local pos = Shelter.getColonyShelterPosition(apocalypseGetElementData(player,"colony"))
    if pos ~= false then
        local x,y,z = pos[1],pos[2],pos[3]
        triggerClientEvent(player,"ColonyFlag.createBlip",player,x,y,z)
    end
end

function ColonyFlag.dropFlag(player)
    if ColonyFlag.flag[player] == true then
        local x,y,z = getElementPosition(player)

        if isElement(ColonyFlag.object) then
            destroyElement(ColonyFlag.object)
        end

        ColonyFlag.object = createObject(11245,x,y,z,0,290,180)
        setObjectScale(ColonyFlag.object,0.2)

        ColonyFlag.objectMarker = createMarker(x,y,z,"cylinder",2,0,0,0,0)

        local dim = getElementDimension(player)
        local int = getElementInterior(player)

        setElementDimension(ColonyFlag.object, dim)
        setElementInterior(ColonyFlag.object, int)
        setElementDimension(ColonyFlag.objectMarker, dim)
        setElementInterior(ColonyFlag.objectMarker, int)

        local respawnEnd = getRealTime().timestamp + 60
        ColonyFlag.broadcastRenderState(ColonyFlag.object, "dropped", respawnEnd)

        ColonyFlag.pickupBlockedUntil[player] = getTickCount() + 1500

        addEventHandler("onMarkerHit",ColonyFlag.objectMarker,function(hitElement)
            if getElementType(hitElement) ~= "player" then return end
            if not isPedInVehicle(hitElement) then
                if getElementDimension(hitElement) == getElementDimension(source) then
                    if not ColonyFlag.canPickupDroppedFlag(hitElement) then return end

                    ColonyFlag.takeFlag(hitElement)

                    if isTimer(ColonyFlag.respawnTimer) then
                        killTimer(ColonyFlag.respawnTimer)
                    end
                end
            end
        end)

        ColonyFlag.respawnTimer = setTimer(function()
            if isElement(ColonyFlag.object) then destroyElement(ColonyFlag.object) end
            if isElement(ColonyFlag.objectMarker) then destroyElement(ColonyFlag.objectMarker) end
            ColonyFlag.broadcastClearRenderState()
            ColonyFlag.placeFlag(ColonyFlag.ownerShelter)
        end,60000,1)

        triggerClientEvent(player,"ColonyFlag.destroyBlip",player)
        ColonyFlag.flag[player] = false
        unbindKey(player,"e","down",ColonyFlag.dropFlag)
        triggerClientEvent(player,"ColonyFlag.destroyBlip",player)
    end
end

addEvent("ColonyFlag.requestRenderState", true)
addEventHandler("ColonyFlag.requestRenderState", root, function()
    if not isElement(client) then return end

    if isElement(ColonyFlag.shelterFlagPickup) then
        ColonyFlag.sendRenderState(client, ColonyFlag.shelterFlagPickup, "pickup", false)
        return
    end

    if isElement(ColonyFlag.object) and isTimer(ColonyFlag.respawnTimer) then
		local remainingMs = getTimerDetails(ColonyFlag.respawnTimer)
		remainingMs = remainingMs or 0
        local respawnEnd = getRealTime().timestamp + math.ceil(remainingMs / 1000)
        ColonyFlag.sendRenderState(client, ColonyFlag.object, "dropped", respawnEnd)
        return
    end

    ColonyFlag.clearRenderState(client)
end)

addEventHandler("onPlayerWasted",root,function()
    ColonyFlag.dropFlag(source)
end)

addEventHandler("onPlayerQuit",root,function()
    ColonyFlag.dropFlag(source)
    ColonyFlag.pickupBlockedUntil[source] = nil
end)