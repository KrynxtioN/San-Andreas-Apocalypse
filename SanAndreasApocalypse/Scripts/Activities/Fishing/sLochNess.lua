LochNess = {}

LochNess.Pickup = createPickup(2124.9912109375,-80.744827270508,1.7642803192139,3,1239,50)

local DailyFishBundle = {}
local DailyFishBundlePickup = createPickup(2150.3569335938,-98.647499084473,2.6936473846436,3,1239,50)

addEventHandler("onPickupHit",DailyFishBundlePickup,function(player)
	if(getElementType(player) == "player")then
		if(getElementDimension(player) == getElementDimension(source))then
			if(not(DailyFishBundle[player]))then
				giveItem(player,209,1)
				DailyFishBundle[player] = true
				createInfobox(player,getText(player,"SLochNess2"))
			else
				createInfobox(player,getText(player,"SLochNess3"))
			end
		end
	end
end)

addEventHandler("onPickupHit",LochNess.Pickup,function(player)
	if(getElementType(player) == "player")then
		if(getElementDimension(player) == getElementDimension(source))then
			if(isCharacterLoggedIn(player))then
				if(not(isPedInVehicle(player)))then
					NPC.MeMessage(player,getText(player,"SLochNess4"))
				end
			end
		end
	end
end)

function LochNess.Create()
    LochNess.Destroy()

    local x, y, z = 2067.1162109375, -172.23582458496, -0.55000001192093

    LochNess.StartX = x
    LochNess.StartY = y
    LochNess.StartZ = z
    LochNess.SwimTimers = {}

    LochNess.Object = createObject(1337, x, y, z - 40)
    setElementAlpha(LochNess.Object, 0)
    setElementCollisionsEnabled(LochNess.Object, false)

    LochNess.Ped = createPed(1, x, y, z - 40, 0)
    setElementCollisionsEnabled(LochNess.Ped, false)
    attachElements(LochNess.Ped, LochNess.Object, 0, 0, 0)
end

function LochNess.Destroy()
    if LochNess.SwimTimers then
        for _, timer in ipairs(LochNess.SwimTimers) do
            if isTimer(timer) then
                killTimer(timer)
            end
        end
    end

    LochNess.SwimTimers = {}

    if isElement(LochNess.Ped) then
        destroyElement(LochNess.Ped)
    end

    if isElement(LochNess.Object) then
        destroyElement(LochNess.Object)
    end
end

function LochNess.MoveTo(duration, tx, ty, tz)
    if not isElement(LochNess.Object) then
        return
    end

    local x, y = getElementPosition(LochNess.Object)
    local rot = math.deg(math.atan2(tx - x, ty - y))
    setElementRotation(LochNess.Object, 0, 0, rot)
    moveObject(LochNess.Object, duration, tx, ty, tz)
end

function LochNess.AddTimer(delay, func)
    local timer = setTimer(func, delay, 1)
    table.insert(LochNess.SwimTimers, timer)
end

function LochNess.SwimAndDive()
	for _,v in pairs(getElementsByType("player"))do
		if(isCharacterLoggedIn(v))then
			local x,y,z = 2067.1162109375, -172.23582458496, -0.55000001192093
			if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(v)) <= 100)then
				triggerClientEvent(v,"LochNess.playSound",v,1)
			end
		end
	end

    if not isElement(LochNess.Object) or not isElement(LochNess.Ped) then
        return
    end

    local x, y, z = LochNess.StartX, LochNess.StartY, LochNess.StartZ

    if LochNess.SwimTimers then
        for _, timer in ipairs(LochNess.SwimTimers) do
            if isTimer(timer) then
                killTimer(timer)
            end
        end
    end
    LochNess.SwimTimers = {}

    detachElements(LochNess.Ped, LochNess.Object)
    setElementPosition(LochNess.Object, x, y, z - 40)
    setElementPosition(LochNess.Ped, x, y, z - 40)
    attachElements(LochNess.Ped, LochNess.Object, 0, 0, 0)

    setPedAnimation(LochNess.Ped, "SWIM", "Swim_Breast", -1, true, false, false, true)
    LochNess.MoveTo(4000, x + 1, y + 2, z + 1.2)

    local points = {
        { x + 6,  y + 8,  z + 1.3 },
        { x + 2,  y + 16, z + 1.5 },
        { x - 4,  y + 24, z + 1.3 },
        { x + 1,  y + 32, z + 1.4 }
    }

    local delay = 4000
    local duration = 2500

    for _, pos in ipairs(points) do
        LochNess.AddTimer(delay, function()
            if not isElement(LochNess.Object) then
                return
            end

            setPedAnimation(LochNess.Ped, "SWIM", "Swim_Tread", -1, true, false, false, true)
            LochNess.MoveTo(duration, pos[1], pos[2], pos[3])
        end)

        delay = delay + duration
    end

    LochNess.AddTimer(delay, function()
        if not isElement(LochNess.Object) then
            return
        end

        local px, py, pz = getElementPosition(LochNess.Object)
        setPedAnimation(LochNess.Ped, "SWIM", "Swim_Crawl", -1, true, false, false, true)
        LochNess.MoveTo(5000, px + 2, py + 8, pz - 120)
    end)

    LochNess.AddTimer(delay + 5200, function()
        LochNess.Destroy()
    end)
end

LochNess.Create()