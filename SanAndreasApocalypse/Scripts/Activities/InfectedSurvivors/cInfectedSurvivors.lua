local Peds = {}
local renderTick = 0
local FRAME_SKIP = 3
local pedTextCache = {}
local MAX_VISIBLE_PEDS = 30

local function getDistance3D(x1,y1,z1,x2,y2,z2)
    local dx, dy, dz = x2-x1, y2-y1, z2-z1
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

local function isPedInView(px, py, pz, rot, pedX, pedY, pedZ)
    local dx, dy, dz = pedX - px, pedY - py, pedZ - pz
    local distance = math.sqrt(dx*dx + dy*dy + dz*dz)

    if distance > 7.5 then
        return false, distance
    end

    local angleToPed = math.deg(math.atan2(dy, dx))
    local angleDiff = math.abs((angleToPed - rot + 180) % 360 - 180)

    return angleDiff <= 90, distance
end

addEventHandler("onClientRender", root, function()
    if not (isCharacterLoggedIn() and isWindowOpen()) then return end

    local px, py, pz = getElementPosition(localPlayer)
    local rot = getPedRotation(localPlayer)
    local lang = apocalypseGetElementData(localPlayer, "language") or "EN"
    local texts = InfectedSurvivors["Texts"][lang] or InfectedSurvivors["Texts"]["EN"]

    local visiblePeds = {}

    for _, ped in pairs(Peds) do
        if isElement(ped) and apocalypseGetElementData(ped, "InfectedSurvivorID") and not isPedDead(ped) then
            if getElementDimension(localPlayer) == getElementDimension(ped) then
                local pedX, pedY, pedZ = getElementPosition(ped)
                local inView, distance = isPedInView(px, py, pz, rot, pedX, pedY, pedZ)

                if inView then
                    table.insert(visiblePeds, {ped = ped, distance = distance})
                end
            end
        end
    end

    table.sort(visiblePeds, function(a, b)
        return a.distance < b.distance
    end)

    for i = 1, math.min(MAX_VISIBLE_PEDS, #visiblePeds) do
        local ped = visiblePeds[i].ped
        local pedX, pedY, pedZ = getElementPosition(ped)

        if not pedTextCache[ped] then
            pedTextCache[ped] = math.random(1, #texts)
        end

        local screenX, screenY = getScreenFromWorldPosition(pedX, pedY, pedZ + 1.0, 0.07)

        if screenX and screenY then
            local pedText = texts[pedTextCache[ped]]
            dxDrawText(
                pedText,
                screenX, screenY,
                screenX, screenY,
                tocolor(255, 255, 255, 255),
                1,
                "default-bold",
                "center",
                "center"
            )
        end
    end
end)

addEvent("updateInfectedSurvivorsData", true)
addEventHandler("updateInfectedSurvivorsData", root, function(data)
    Peds = data
    pedTextCache = {}
end)

addEventHandler("onClientClick",root,function(button,state,_,_,_,_,_,clickedElement)
	if(isCharacterLoggedIn() and isWindowOpen())then
		if(clickedElement and isElement(clickedElement))then
			if(button == "left" and state == "down" and getElementType(clickedElement) == "ped")then
				local x,y,z = getElementPosition(clickedElement)
				if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(localPlayer)) <= 1.5)then
					if(apocalypseGetElementData(clickedElement,"InfectedSurvivorID"))then
						local ID = apocalypseGetElementData(clickedElement,"InfectedSurvivorID")
						triggerServerEvent("InfectedSurvivors.UseSyringe",localPlayer,ID)
					end
				end
			end
		end
	end
end)