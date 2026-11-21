local effects = {}

addEvent("ValentinesDayCampfireUpdate", true)
addEventHandler("ValentinesDayCampfireUpdate", root, function()
	for _,v in pairs(effects)do destroyElement(v) end
    effects = {}
    for _, v in pairs(getElementsByType("object")) do
        if getElementModel(v) == 1463 and apocalypseGetElementData(v, "ValentinesDayCampfireID") then
            local x, y, z = getElementPosition(v)
            local ID = apocalypseGetElementData(v, "ValentinesDayCampfireID")
            effects[ID] = createEffect("fire_med", x, y, z, 0, 0, 0)
        end
    end
end)