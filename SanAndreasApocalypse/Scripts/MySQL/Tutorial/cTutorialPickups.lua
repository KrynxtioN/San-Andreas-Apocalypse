TutorialPickups = {Pickups = {}}
local Render = false

function TutorialPickups.render()
    for _, pickup in pairs(TutorialPickups.Pickups) do
        if isElement(pickup) then
            local px, py, pz = getElementPosition(pickup)
            local sx, sy = getScreenFromWorldPosition(px, py, pz + 1)
            if sx and sy then
                if getDistanceBetweenPoints3D(px, py, pz, getElementPosition(localPlayer)) <= 5 then
                    dxDrawText(
                        apocalypseGetElementData(pickup, "informationText"),
                        sx - 100, sy - 25, sx + 100, sy + 25,
                        tocolor(255, 255, 255, 255),
                        1, "default-bold", "center", "center"
                    )
                end
            end
        end
    end
end

addEvent("TutorialPickups.createPickup", true)
addEventHandler("TutorialPickups.createPickup", root, function(Name, x, y, z, text)
    if not isElement(TutorialPickups.Pickups[Name]) then
        if not Render then
            addEventHandler("onClientRender", root, TutorialPickups.render)
            Render = true
        end
        TutorialPickups.Pickups[Name] = createPickup(x, y, z, 3, 1318, 50)
        apocalypseSetElementData(TutorialPickups.Pickups[Name], "informationText", text)
    end
end)

addEvent("TutorialPickups.deletePickup", true)
addEventHandler("TutorialPickups.deletePickup", root, function(Name)
    if isElement(TutorialPickups.Pickups[Name]) then
        destroyElement(TutorialPickups.Pickups[Name])
        TutorialPickups.Pickups[Name] = nil
    end
    if not next(TutorialPickups.Pickups) then
        removeEventHandler("onClientRender", root, TutorialPickups.render)
        Render = false
    end
end)