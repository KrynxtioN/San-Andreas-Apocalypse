Coupons = {}
Coupons.Cache = {}

local COUPON_FIELDS = {
    double_experience = true,
    double_money = true,
    zombie_immune = true,
    double_skillpoints = true
}

local function getCharacterKey(player)
    local charID = getCharacterID(player)
    if not charID then return nil end
    return tostring(charID)
end

function Coupons.loadPlayerCache(player)
    local charKey = getCharacterKey(player)
    if not charKey then return nil end

    if Coupons.Cache[charKey] then
        return Coupons.Cache[charKey]
    end

    local cache = {
        double_experience = tonumber(getPlayerData("characters", "ID", getCharacterID(player), "double_experience")) or 0,
        double_money = tonumber(getPlayerData("characters", "ID", getCharacterID(player), "double_money")) or 0,
        zombie_immune = tonumber(getPlayerData("characters", "ID", getCharacterID(player), "zombie_immune")) or 0,
        double_skillpoints = tonumber(getPlayerData("characters", "ID", getCharacterID(player), "double_skillpoints")) or 0,
    }

    Coupons.Cache[charKey] = cache
    return cache
end

function Coupons.clearPlayerCache(player)
    local charKey = getCharacterKey(player)
    if charKey then
        Coupons.Cache[charKey] = nil
    end
end

function Coupons.getValue(player, field)
    if not COUPON_FIELDS[field] then return 0 end

    local cache = Coupons.loadPlayerCache(player)
    if not cache then return 0 end

    return tonumber(cache[field]) or 0
end

function Coupons.setValue(player, field, value)
    if not COUPON_FIELDS[field] then return false end
    if not isElement(player) then return false end

    value = tonumber(value) or 0

    local cache = Coupons.loadPlayerCache(player)
    if not cache then return false end

    cache[field] = value

    dbExec(handler,
        "UPDATE characters SET "..field.." = ? WHERE ID = ?",
        value, getCharacterID(player)
    )

    return true
end

function Coupons.isActive(player, field)
    if not COUPON_FIELDS[field] then return false end
    if not isElement(player) then return false end

    local currentTime = getRealTime().timestamp
    local endTime = Coupons.getValue(player, field)

    if endTime > currentTime then
        return true
    end

    if endTime > 0 then
        Coupons.setValue(player, field, 0)

        if field == "zombie_immune" then
            apocalypseSetElementData(player, "zombieimmunactive", false)
        end
    end

    return false
end

function Coupons.extend(player, field, duration, title)
    if not COUPON_FIELDS[field] then return false end
    if not isElement(player) then return false end

    local currentTime = getRealTime().timestamp
    local oldEndTime = Coupons.getValue(player, field)

    local newEndTime = ((oldEndTime > currentTime) and oldEndTime or currentTime) + duration

    Coupons.setValue(player, field, newEndTime)

    triggerClientEvent(player, "addTimer", player, newEndTime, title, field)
    return true
end

addEvent("Coupons.buy", true)
addEventHandler("Coupons.buy", root, function(couponID)
    couponID = tonumber(couponID)
    if not couponID then return end

    if hasPlayerItem(client, 14) < 5 then
        NPC.NormalMessage(client, getText(client, "CCoupons3"))
        return
    end

    takeItem(client, 14, 5)

    if couponID == 1 then giveItem(client, 15, 1) end
    if couponID == 2 then giveItem(client, 16, 1) end
    if couponID == 3 then giveItem(client, 17, 1) end
    if couponID == 4 then giveItem(client, 187, 1) end

    NPC.NormalMessage(client, getText(client, "CCoupons4"))
    setAchievement(client, 54)
	outputLog(getPlayerName(client).." hat sich einen Coupon (ID: "..couponID..") gekauft","Couponshop",getCharacterID(client))
end)

function isDoubleSkillpointsActive(player)
    return Coupons.isActive(player, "double_skillpoints")
end

function activateDoubleSkillpoints(player)
    Coupons.extend(player, "double_skillpoints", 600, "Doppelte Skillpunkte")
end

function isDoubleExperienceActive(player)
    return Coupons.isActive(player, "double_experience")
end

function activateDoubleExperience(player)
    Coupons.extend(player, "double_experience", 600, "Doppelte Erfahrungspunkte")
end

function isDoubleMoneyActive(player)
    return Coupons.isActive(player, "double_money")
end

function activateDoubleMoney(player)
    Coupons.extend(player, "double_money", 600, "Doppeltes Geld")
end

function isZombieImmuneActive(player)
    return Coupons.isActive(player, "zombie_immune")
end

function activateZombieImmune(player)
    Coupons.extend(player, "zombie_immune", 1800, "Immun gegen Zombies")
end

function activateCouponTimer(player)
    if not isElement(player) then return end

    local currentTime = getRealTime().timestamp
    local cache = Coupons.loadPlayerCache(player)
    if not cache then return end

    local timerData = {
        {field = "double_experience", title = "Doppelte Erfahrungspunkte"},
        {field = "double_money", title = "Doppeltes Geld"},
        {field = "zombie_immune", title = "Immun gegen Zombies"},
        {field = "double_skillpoints", title = "Doppelte Skillpunkte"},
    }

    for _, data in ipairs(timerData) do
        local endTime = tonumber(cache[data.field]) or 0

        if endTime > currentTime then
            triggerClientEvent(player, "addTimer", player, endTime, data.title, data.field)
        elseif endTime > 0 then
            Coupons.setValue(player, data.field, 0)

            if data.field == "zombie_immune" then
                apocalypseSetElementData(player, "zombieimmunactive", false)
            end
        end
    end
end

addEventHandler("onPlayerQuit", root, function()
    Coupons.clearPlayerCache(source)
end)

addEventHandler("onPlayerWasted", root, function()
    if isElement(source) then
        Coupons.clearPlayerCache(source)
    end
end)