local screenW, screenH = guiGetScreenSize()
local level = 1
local unlocks = {}
local startTime = 0
local closeTime = 0
local fadeOutStart = nil
local scrollIndex = 1
local scrollSpeed = 1000
local lastScrollTime = 0

local level_data = {
    ["EN"] = {
		[10] = {"Questline: Brains and Hordes", "Weapon Box Object"},
		[15] = {"Treasure Hunter Activity"},
		[20] = {"Black Board Object"},
		[25] = {"Skills", "Fast Travel", "Lumberjack Activity", "Crafting Panel"},
		[30] = {"Safe Object"},
		[35] = {"Storage Crate Object"},
		[50] = {"Ocean Cleaner Activity"},
		[100] = {"Vehicle Dealer"},
    },
    ["DE"] = {
        [10] = {"Questreihe: Hirn und Horden", "Waffenbox Objekt"},
        [15] = {"Schatzsucher Aktivität"},
		[20] = {"Schwarzes Brett Objekt"},
		[25] = {"Skills", "Schnellreisen", "Holzfäller Aktivität", "Crafting Menü"},
		[30] = {"Tresor Objekt"},
		[35] = {"Lagerkiste Objekt"},
		[50] = {"Meeresreiniger Aktivität"},
		[100] = {"Fahrzeug Dealer"},
    },
	["RU"] = {
		[10] = {"Квестовая линия: Мозги и Орды", "Объект ящика с оружием"},
		[15] = {"Активность охотника за сокровищами"},
		[20] = {"Объект черной доски"},
		[25] = {"Навыки", "Быстрое перемещение", "Активность лесоруба"},
		[30] = {"Объект сейфа"},
		[35] = {"Объект складского ящика"},
		[50] = {"Активность очистки моря"},
	},
	["PT"] = {
		[10] = {"Linha de Missões: Cérebros e Hordas", "Objeto Caixa de Armas"},
		[15] = {"Atividade Caçador de Tesouros"},
		[20] = {"Objeto Quadro Negro"},
		[25] = {"Habilidades", "Viagem Rápida", "Atividade Lenhador"},
		[30] = {"Objeto de cofre"},
		[35] = {"Objeto de caixa de armazenamento"},
		[50] = {"Atividade de limpeza do mar"},
	},
}

function renderLevelUpUI()
    local elapsed = getTickCount() - startTime
    local progress = math.min(elapsed / 500, 1)
    local alpha = progress * 255

    if fadeOutStart then
        local fadeProgress = (getTickCount() - fadeOutStart) / 500
        alpha = alpha * (1 - fadeProgress)
        if fadeProgress >= 1 then
            closeLevelUpUI()
            return
        end
    end

    local remainingTime = math.max(0, math.ceil((closeTime - getTickCount()) / 1000))

    local boxW, boxH = 400, 230
    local boxX, boxY = 50, (screenH - boxH) / 2 + 20

    dxDrawRectangle(boxX, boxY, boxW, boxH, tocolor(20, 20, 20, alpha * 0.9))
    dxDrawRectangle(boxX, boxY, boxW, 40, tocolor(255, 215, 0, alpha))

    dxDrawText(getText("CLevelsystem5"), boxX, boxY, boxX + boxW, boxY + 40, tocolor(0, 0, 0, alpha), 1.5, "default-bold", "center", "center")
    dxDrawText(getText("CLevelsystem6"):format(apocalypseGetElementData(localPlayer, "rankname")), boxX, boxY + 50, boxX + boxW, boxY + 70, tocolor(255, 255, 255, alpha), 1, "default", "center", "top")

    local startY = boxY + 85
    local maxVisible = 3

    for i = scrollIndex, math.min(scrollIndex + maxVisible - 1, #unlocks) do
        dxDrawRectangle(boxX + 15, startY - 5, boxW - 30, 30, tocolor(50, 50, 50, alpha * 0.8))
        dxDrawText(unlocks[i], boxX + 15, startY, boxX + boxW - 15, startY + 30, tocolor(200, 200, 200, alpha), 1, "default", "center", "center")
        startY = startY + 35
    end

    local timeY = startY + 5
    dxDrawText(remainingTime .. "s", boxX, timeY, boxX + boxW, timeY + 20, tocolor(180, 180, 180, alpha), 1, "default", "center", "center")

    if getTickCount() - lastScrollTime >= scrollSpeed then
        scrollIndex = scrollIndex + 1
        if scrollIndex > math.max(1, #unlocks - 2) then
            scrollIndex = 1
        end
        lastScrollTime = getTickCount()
    end

    if getTickCount() >= closeTime and not fadeOutStart then
        fadeOutStart = getTickCount()
    end
end

function closeLevelUpUI()
    removeEventHandler("onClientRender", root, renderLevelUpUI)
end

function showLevelUpStuff(newLevel, newUnlocks)
    level = newLevel
    unlocks = newUnlocks
    startTime = getTickCount()
    closeTime = startTime + (#unlocks * 2000)
    fadeOutStart = nil
    scrollIndex = 1
    lastScrollTime = getTickCount()
    addEventHandler("onClientRender", root, renderLevelUpUI)
end
addEvent("showLevelUpStuff", true)
addEventHandler("showLevelUpStuff", root, showLevelUpStuff)

function createLevelUpStuff(level)
    if level then
        local level = tonumber(level)
        if level_data[apocalypseGetElementData(localPlayer, "language") or "EN"][level] then
            showLevelUpStuff(level, level_data[apocalypseGetElementData(localPlayer, "language") or "EN"][level])
        end
    end
end
addEvent("createLevelUpStuff", true)
addEventHandler("createLevelUpStuff", root, createLevelUpStuff)