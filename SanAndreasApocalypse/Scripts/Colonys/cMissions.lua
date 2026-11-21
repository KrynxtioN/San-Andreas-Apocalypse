local colonyMissions = {}
local popup = false
local currentLanguage = "EN"

local sx, sy = guiGetScreenSize()
local serverR, serverG, serverB = 220, 25, 25

local texts = {
    EN = {
        missions = "Colony Missions",
        missionFinished = "Mission completed: "
    },

    DE = {
        missions = "Kolonie Missionen",
        missionFinished = "Mission abgeschlossen: "
    },

    RU = {
        missions = "Миссии колонии",
        missionFinished = "Миссия завершена: "
    },

    PT = {
        missions = "Missões da Colônia",
        missionFinished = "Missão concluída: "
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

    if texts[language] and texts[language][key] then
        return texts[language][key]
    end

    return texts.EN[key] or key
end


addEvent("colonySystemsUnload", true)
addEventHandler("colonySystemsUnload", root, function()
    colonyMissions = {}
    popup = false
    currentLanguage = "EN"
end)


addEvent("colonyMissionsReceive", true)
addEventHandler("colonyMissionsReceive", root, function(missions, language)
    currentLanguage = normalizeLanguage(language)
    colonyMissions = missions or {}
end)


addEvent("colonyMissionsUpdate", true)
addEventHandler("colonyMissionsUpdate", root, function(data, language)
    if not data then
        return
    end

    if language then
        currentLanguage = normalizeLanguage(language)
    end

    local found = false

    for _, mission in ipairs(colonyMissions) do
        if mission.id == data.id then
            mission.title = data.title
            mission.progress = data.progress
            mission.goal = data.goal

            found = true
            break
        end
    end

    if not found then
        table.insert(colonyMissions, data)
    end

    popup = {
        title = data.title,
        progress = data.progress,
        goal = data.goal,
        tick = getTickCount(),
        duration = 2800,
        finished = false
    }
end)


addEvent("colonyMissionFinished", true)
addEventHandler("colonyMissionFinished", root, function(title, language)
    if language then
        currentLanguage = normalizeLanguage(language)
    end

    popup = {
        title = getText("missionFinished") .. tostring(title),
        tick = getTickCount(),
        duration = 3500,
        finished = true
    }
end)


addEventHandler("onClientRender", root, function()
    drawMissionList()
    drawPopup()
end)


function drawMissionList()
    if #colonyMissions <= 0 then
        return
    end

    local x = sx - 320
    local y = 250
    local w = 300
    local h = 40

    dxDrawText(
        getText("missions"),
        x,
        y - 22,
        x + w,
        y + 8,
        tocolor(serverR, serverG, serverB, 255),
        1.2,
        "default-bold",
        "left",
        "center"
    )

    for i, mission in ipairs(colonyMissions) do
        local ry = y + ((i - 1) * 45)

        dxDrawRectangle(
            x,
            ry,
            w,
            h,
            tocolor(0, 0, 0, 150)
        )

        dxDrawText(
            tostring(mission.title or ""),
            x + 10,
            ry + 5,
            x + 290,
            ry + 20,
            tocolor(255, 255, 255, 255),
            1,
            "default-bold"
        )

        dxDrawText(
            tostring(mission.progress or 0) .. "/" .. tostring(mission.goal or 0),
            x + 10,
            ry + 20,
            x + 290,
            ry + 35,
            tocolor(serverR, serverG, serverB, 255),
            1,
            "default",
            "right"
        )
    end
end


function drawPopup()
    if not popup then
        return
    end

    local elapsed = getTickCount() - popup.tick

    if elapsed >= popup.duration then
        popup = false
        return
    end

    local alpha = 255
    local moveY = 0
    local scale = 1.15

    if elapsed < 300 then
        local p = elapsed / 300

        alpha = interpolateBetween(
            0, 0, 0,
            255, 0, 0,
            p,
            "OutQuad"
        )

        moveY = interpolateBetween(
            20, 0, 0,
            0, 0, 0,
            p,
            "OutQuad"
        )

        scale = interpolateBetween(
            0.9, 0, 0,
            1.15, 0, 0,
            p,
            "OutBack"
        )

    elseif elapsed > popup.duration - 600 then
        local p = (
            elapsed - (popup.duration - 600)
        ) / 600

        alpha = interpolateBetween(
            255, 0, 0,
            0, 0, 0,
            p,
            "Linear"
        )

        moveY = interpolateBetween(
            0, 0, 0,
            -25, 0, 0,
            p,
            "OutQuad"
        )
    end

    local text = tostring(popup.title or "")

    if not popup.finished then
        text =
            tostring(popup.title or "")
            .. "  "
            .. tostring(popup.progress or 0)
            .. "/"
            .. tostring(popup.goal or 0)
    end

    local x = 0
    local y = sy * 0.33 + moveY

    dxDrawText(
        text,
        x + 2,
        y + 2,
        sx + 2,
        y + 42,
        tocolor(0, 0, 0, alpha),
        scale,
        "default-bold",
        "center",
        "center"
    )

    dxDrawText(
        text,
        x,
        y,
        sx,
        y + 40,
        tocolor(serverR, serverG, serverB, alpha),
        scale,
        "default-bold",
        "center",
        "center"
    )
end