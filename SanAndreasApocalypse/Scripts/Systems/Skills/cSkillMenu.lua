local selectedSkillManagerID = 1
local skillManagerData = {}
local playerSkillpoints = 0

local managerButtons = {
    close = {},
    upgrade = {}
}

local managerText = {
    ["DE"] = {
        title = "Skillverwaltung",
        skillpoints = "Skillpunkte: %s",
        level = "Level %s / %s",
        cost = "Kosten: %s Skillpunkte",
        max = "Maximales Level erreicht",
        upgrade = "Skill erhöhen",
        close = "×"
    },
    ["EN"] = {
        title = "Skill Management",
        skillpoints = "Skillpoints: %s",
        level = "Level %s / %s",
        cost = "Cost: %s skillpoints",
        max = "Maximum level reached",
        upgrade = "Upgrade Skill",
        close = "×"
    },
    ["RU"] = {
        title = "Управление навыками",
        skillpoints = "Очки навыков: %s",
        level = "Уровень %s / %s",
        cost = "Стоимость: %s очков",
        max = "Максимальный уровень достигнут",
        upgrade = "Улучшить навык",
        close = "×"
    },
    ["PT"] = {
        title = "Gestão de Habilidades",
        skillpoints = "Pontos de habilidade: %s",
        level = "Nível %s / %s",
        cost = "Custo: %s pontos",
        max = "Nível máximo alcançado",
        upgrade = "Melhorar habilidade",
        close = "×"
    }
}

local function getManagerLang()
    return apocalypseGetElementData(localPlayer, "language") or "EN"
end

local function getManagerText(key)
    local lang = getManagerLang()
    return (managerText[lang] and managerText[lang][key]) or managerText["EN"][key] or key
end

function Skillsystem.openManager()
	selectedSkillManagerID = 1

	showCursor(true)
	setWindowData("no")
	addEventHandler("onClientRender", root, Skillsystem.drawManager)
	addEventHandler("onClientClick", root, Skillsystem.managerClick)

	triggerServerEvent("Skillsystem.requestManagerData", localPlayer)
end
addEvent("Skillsystem.openManager",true)
addEventHandler("Skillsystem.openManager",root,Skillsystem.openManager)

function Skillsystem.closeManager()
    showCursor(false)
	closeWindow()

    removeEventHandler("onClientRender", root, Skillsystem.drawManager)
    removeEventHandler("onClientClick", root, Skillsystem.managerClick)
end

addEvent("Skillsystem.receiveManagerData", true)
addEventHandler("Skillsystem.receiveManagerData", root, function(data, skillpoints)
    skillManagerData = data or {}
    playerSkillpoints = tonumber(skillpoints) or 0
end)

function Skillsystem.drawManager()
    local sx, sy = guiGetScreenSize()
    local w, h = 720, 430
    local x, y = (sx - w) / 2, (sy - h) / 2
    local lang = getManagerLang()

    dxDrawRectangle(x - 4, y - 4, w + 8, h + 8, tocolor(0, 0, 0, 120), true)
    dxDrawRectangle(x, y, w, h, tocolor(18, 18, 18, 245), true)
    dxDrawRectangle(x, y, w, 42, tocolor(220, 25, 25, 255), true)

    dxDrawText(getManagerText("title"), x + 16, y, x + w - 50, y + 42, tocolor(255,255,255), 1.15, "default-bold", "left", "center", true, true, true)
    dxDrawText(getManagerText("skillpoints"):format(playerSkillpoints), x + 16, y + 45, x + w - 16, y + 70, tocolor(210,210,210), 1, "default-bold", "left", "center", true, true, true)

    managerButtons.close = {x = x + w - 36, y = y + 8, w = 26, h = 26}
    local closeHover = isMouseInPosition(managerButtons.close.x, managerButtons.close.y, managerButtons.close.w, managerButtons.close.h)
    dxDrawRectangle(managerButtons.close.x, managerButtons.close.y, managerButtons.close.w, managerButtons.close.h, closeHover and tocolor(120,20,20,240) or tocolor(80,20,20,220), true)
    dxDrawText("×", managerButtons.close.x, managerButtons.close.y, managerButtons.close.x + managerButtons.close.w, managerButtons.close.y + managerButtons.close.h, tocolor(255,255,255), 1.3, "default-bold", "center", "center", true, true, true)

    local listX, listY = x + 16, y + 78
    local listW, rowH = 250, 38

    for id = 1, 8 do
        local data = skillManagerData[id]
        local skillInfo = Skillsystem["Skills"][lang] and Skillsystem["Skills"][lang][id] or Skillsystem["Skills"]["EN"][id]

        if data and skillInfo then
            local rowY = listY + (id - 1) * (rowH + 5)
            local hover = isMouseInPosition(listX, rowY, listW, rowH)
            local bg = selectedSkillManagerID == id and tocolor(220,25,25,160) or hover and tocolor(45,45,45,240) or tocolor(32,32,32,235)

            dxDrawRectangle(listX, rowY, listW, rowH, bg, true)
            dxDrawText(skillInfo[1], listX + 10, rowY, listX + listW - 10, rowY + 20, tocolor(255,255,255), 0.95, "default-bold", "left", "center", true, true, true)
            dxDrawText(getManagerText("level"):format(data.level, data.maxLevel), listX + 10, rowY + 18, listX + listW - 10, rowY + rowH, tocolor(190,190,190), 0.85, "default", "left", "center", true, true, true)
        end
    end

    local detailX, detailY = x + 285, y + 78
    local detailW, detailH = w - 305, h - 95

    dxDrawRectangle(detailX, detailY, detailW, detailH, tocolor(28,28,28,235), true)

    local selectedData = skillManagerData[selectedSkillManagerID]
    local selectedInfo = Skillsystem["Skills"][lang] and Skillsystem["Skills"][lang][selectedSkillManagerID] or Skillsystem["Skills"]["EN"][selectedSkillManagerID]

    if selectedData and selectedInfo then
        dxDrawText(selectedInfo[1], detailX + 16, detailY + 12, detailX + detailW - 16, detailY + 38, tocolor(255,255,255), 1.15, "default-bold", "left", "center", true, true, true)

        local progress = selectedData.maxLevel > 0 and selectedData.level / selectedData.maxLevel or 0
        dxDrawRectangle(detailX + 16, detailY + 52, detailW - 32, 24, tocolor(60,60,60,230), true)
        dxDrawRectangle(detailX + 16, detailY + 52, math.max(4, (detailW - 32) * progress), 24, tocolor(220,25,25,240), true)
        dxDrawText(getManagerText("level"):format(selectedData.level, selectedData.maxLevel), detailX + 16, detailY + 52, detailX + detailW - 16, detailY + 76, tocolor(255,255,255), 0.95, "default-bold", "center", "center", true, true, true)

        local desc = selectedInfo[2] or ""
        if selectedInfo[3] then desc = desc .. "\n" .. selectedInfo[3] end
        if selectedInfo[4] then desc = desc .. "\n" .. selectedInfo[4] end

        dxDrawText(desc, detailX + 16, detailY + 90, detailX + detailW - 16, detailY + detailH - 76, tocolor(220,220,220), 0.9, "default", "left", "top", true, true, true)

        local costText = selectedData.level >= selectedData.maxLevel and getManagerText("max") or getManagerText("cost"):format(selectedData.cost)
        dxDrawText(costText, detailX + 16, detailY + detailH - 66, detailX + detailW - 16, detailY + detailH - 42, tocolor(230,230,230), 1, "default-bold", "left", "center", true, true, true)

        managerButtons.upgrade = {x = detailX + 16, y = detailY + detailH - 36, w = detailW - 32, h = 28}
        local upgradeHover = isMouseInPosition(managerButtons.upgrade.x, managerButtons.upgrade.y, managerButtons.upgrade.w, managerButtons.upgrade.h)

        local canUpgrade = selectedData.level < selectedData.maxLevel
        local btnColor = canUpgrade and (upgradeHover and tocolor(235,35,35,255) or tocolor(220,25,25,255)) or tocolor(70,70,70,220)

        dxDrawRectangle(managerButtons.upgrade.x, managerButtons.upgrade.y, managerButtons.upgrade.w, managerButtons.upgrade.h, btnColor, true)
        dxDrawText(getManagerText("upgrade"), managerButtons.upgrade.x, managerButtons.upgrade.y, managerButtons.upgrade.x + managerButtons.upgrade.w, managerButtons.upgrade.y + managerButtons.upgrade.h, tocolor(255,255,255), 1, "default-bold", "center", "center", true, true, true)
    end
end

function Skillsystem.managerClick(btn, state)
    if isMouseInPosition(managerButtons.close.x, managerButtons.close.y, managerButtons.close.w, managerButtons.close.h) then
        Skillsystem.closeManager()
        return
    end

    local sx, sy = guiGetScreenSize()
    local w, h = 720, 430
    local x, y = (sx - w) / 2, (sy - h) / 2

    local listX, listY = x + 16, y + 78
    local listW, rowH = 250, 38

    for id = 1, 8 do
        local rowY = listY + (id - 1) * (rowH + 5)
        if isMouseInPosition(listX, rowY, listW, rowH) then
            selectedSkillManagerID = id
            return
        end
    end

    if isMouseInPosition(managerButtons.upgrade.x, managerButtons.upgrade.y, managerButtons.upgrade.w, managerButtons.upgrade.h) then
        triggerServerEvent("Skillsystem.managerBuyUpgrade", localPlayer, selectedSkillManagerID)
    end
end

addEventHandler("onClientPlayerWasted", root, function()
    if localPlayer == source then
        Skillsystem.closeManager()
    end
end)