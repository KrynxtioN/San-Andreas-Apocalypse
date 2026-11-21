ColonyFlag = {}
ColonyFlag.renderObject = nil
ColonyFlag.renderState = "pickup"
ColonyFlag.respawnEnd = false

addEvent("ColonyFlag.createBlip",true)
addEventHandler("ColonyFlag.createBlip",root,function(x,y,z)
    if isElement(ColonyFlag.Blip) then
        destroyElement(ColonyFlag.Blip)
    end
    ColonyFlag.Blip = createBlip(x, y, z, 41, 0, 0, 0, 255)
end)

addEvent("ColonyFlag.destroyBlip",true)
addEventHandler("ColonyFlag.destroyBlip",root,function()
    if isElement(ColonyFlag.Blip) then
        destroyElement(ColonyFlag.Blip)
    end
end)

addEvent("ColonyFlag.setRenderObject", true)
addEventHandler("ColonyFlag.setRenderObject", root, function(object, state, respawnEnd)
    ColonyFlag.renderObject = object
    ColonyFlag.renderState = state
    ColonyFlag.respawnEnd = respawnEnd
end)

addEvent("ColonyFlag.clearRenderObject", true)
addEventHandler("ColonyFlag.clearRenderObject", root, function()
    ColonyFlag.renderObject = nil
    ColonyFlag.renderState = nil
    ColonyFlag.respawnEnd = false
end)

local function draw3DText(x, y, z, text, maxDistance)
    local cx, cy, cz = getCameraMatrix()
    local distance = getDistanceBetweenPoints3D(cx, cy, cz, x, y, z)

    if distance > maxDistance then
        return
    end

    local sx, sy = getScreenFromWorldPosition(x, y, z)
    if not sx or not sy then
        return
    end

    local scale = 1.2 - (distance / maxDistance)
    if scale < 0.8 then
        scale = 0.8
    end

    dxDrawText(
        text,
        sx - 180, sy - 40,
        sx + 180, sy + 40,
        tocolor(255,255,255,255),
        scale,
        "default-bold",
        "center",
        "center",
        false,
        false,
        false,
        true
    )
end

addEventHandler("onClientRender", root, function()
    local obj = ColonyFlag.renderObject
    if not isElement(obj) then return end
    if getElementDimension(localPlayer) ~= getElementDimension(obj) then return end
    if getElementInterior(localPlayer) ~= getElementInterior(obj) then return end

    local x, y, z = getElementPosition(obj)
    z = z + 1.1

    if ColonyFlag.renderState == "pickup" then
        draw3DText(x, y, z - 0.2, getText("CFlag1"), 25)

    elseif ColonyFlag.renderState == "dropped" then
        local remaining = tonumber(ColonyFlag.respawnEnd or 0) - getRealTime().timestamp
        if remaining < 0 then remaining = 0 end
        draw3DText(x, y, z - 0.2, getText("CFlag2"):format(remaining), 25)
    end
end)

triggerServerEvent("ColonyFlag.requestRenderState", localPlayer)