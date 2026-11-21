local chickenModel = 251

local chickenPeds = {}
local chickenBlips = {}

local chickenMissionActive = false
local currentLanguage = "EN"

local chickenPositions = {
    [1] = {
        x = 686.0732421875,
        y = -469.19314575195,
        z = 22.570465087891,
        rot = 0
    },

    [2] = {
        x = 840.45104980469,
        y = -516.00463867188,
        z = 17.448492050171,
        rot = 0
    },

    [3] = {
        x = 619.65179443359,
        y = -584.06665039062,
        z = 17.2265625,
        rot = 0
    },

    [4] = {
        x = 603.78521728516,
        y = -443.2434387207,
        z = 25.590476989746,
        rot = 0
    },

    [5] = {
        x = 664.27581787109,
        y = -563.85217285156,
        z = 20.646862030029,
        rot = 0
    }
}

local texts = {
    EN = {
        chicken = "Escaped Chicken",
        collect = "Click to collect"
    },

    DE = {
        chicken = "Entkommenes Huhn",
        collect = "Mit Klick einsammeln"
    },

    RU = {
        chicken = "Сбежавшая курица",
        collect = "Нажмите, чтобы поймать"
    },

    PT = {
        chicken = "Galinha Fugida",
        collect = "Clique para coletar"
    }
}


local function normalizeLanguage(language)
    language = tostring(language or "EN"):upper()

    if not texts[language] then
        language = "EN"
    end

    return language
end


local function getText(key)
    local language = normalizeLanguage(currentLanguage)

    if texts[language]
    and texts[language][key] then
        return texts[language][key]
    end

    return texts.EN[key] or key
end


addEvent("colonyChickensLoad", true)
addEventHandler("colonyChickensLoad", root, function(collected, language)
    chickenMissionActive = true
    currentLanguage = normalizeLanguage(language)

    clearChickenPeds()

    collected = collected or {}

    for id, pos in pairs(chickenPositions) do
        if not collected[id] then
            local ped = createPed(
                chickenModel,
                pos.x,
                pos.y,
                pos.z,
                pos.rot or 0
            )

            if ped then
                setElementFrozen(
                    ped,
                    true
                )

                setElementData(
                    ped,
                    "colonyChicken",
                    true,
                    false
                )

                setElementData(
                    ped,
                    "colonyChickenId",
                    id,
                    false
                )

                chickenPeds[id] = ped

                local blip = createBlip(
                    pos.x,
                    pos.y,
                    pos.z,
                    0,
                    2,
                    220,
                    25,
                    25,
                    255,
                    0,
                    250
                )

                chickenBlips[id] = blip
            end
        end
    end
end)


addEvent("colonyChickensClear", true)
addEventHandler("colonyChickensClear", root, function()
    chickenMissionActive = false

    clearChickenPeds()
end)


function clearChickenPeds()
    for _, ped in pairs(chickenPeds) do
        if isElement(ped) then
            destroyElement(ped)
        end
    end

    for _, blip in pairs(chickenBlips) do
        if isElement(blip) then
            destroyElement(blip)
        end
    end

    chickenPeds = {}
    chickenBlips = {}
end


addEventHandler("onClientClick", root, function(
    button,
    state,
    absoluteX,
    absoluteY,
    worldX,
    worldY,
    worldZ,
    clickedElement
)
    if button ~= "left" then
        return
    end

    if state ~= "down" then
        return
    end

    if not clickedElement
    or not isElement(clickedElement) then
        return
    end

    if getElementType(clickedElement) ~= "ped" then
        return
    end

    if not getElementData(
        clickedElement,
        "colonyChicken"
    ) then
        return
    end

    local px, py, pz = getElementPosition(localPlayer)
    local cx, cy, cz = getElementPosition(clickedElement)

    if getDistanceBetweenPoints3D(
        px,
        py,
        pz,
        cx,
        cy,
        cz
    ) > 4 then
        return
    end

    local chickenId = getElementData(
        clickedElement,
        "colonyChickenId"
    )

    chickenId = tonumber(chickenId)

    if not chickenId then
        return
    end

    triggerServerEvent(
        "colonyChickenCollect",
        localPlayer,
        chickenId
    )
end)


addEventHandler("onClientRender", root, function()
    drawChickenTexts()
end)


function drawChickenTexts()
    if not chickenMissionActive then
        return
    end

    local px, py, pz = getElementPosition(localPlayer)

    for _, ped in pairs(chickenPeds) do
        if isElement(ped) then
            local x, y, z = getElementPosition(ped)

            local distance = getDistanceBetweenPoints3D(
                px,
                py,
                pz,
                x,
                y,
                z
            )

            if distance <= 18 then
                local screenX, screenY = getScreenFromWorldPosition(
                    x,
                    y,
                    z + 1.15
                )

                if screenX and screenY then
                    local title = getText("chicken")
                    local collectText = getText("collect")

                    dxDrawText(
                        title,
                        screenX + 1,
                        screenY + 1,
                        screenX + 1,
                        screenY + 1,
                        tocolor(0, 0, 0, 220),
                        1,
                        "default-bold",
                        "center",
                        "center"
                    )

                    dxDrawText(
                        title,
                        screenX,
                        screenY,
                        screenX,
                        screenY,
                        tocolor(220, 25, 25, 255),
                        1,
                        "default-bold",
                        "center",
                        "center"
                    )

                    dxDrawText(
                        collectText,
                        screenX + 1,
                        screenY + 19,
                        screenX + 1,
                        screenY + 19,
                        tocolor(0, 0, 0, 220),
                        0.9,
                        "default",
                        "center",
                        "center"
                    )

                    dxDrawText(
                        collectText,
                        screenX,
                        screenY + 18,
                        screenX,
                        screenY + 18,
                        tocolor(255, 255, 255, 230),
                        0.9,
                        "default",
                        "center",
                        "center"
                    )
                end
            end
        end
    end
end