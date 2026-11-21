local screenW, screenH = guiGetScreenSize()

HalloweenQuestUI = {
    ["Quests"] = {
        ["DE"] = {
			-- LVL 1
            {
                {key = "hearse_delivered", name = "Bringe Leichenwagen in Mr. Skeletons Garage", goal = 10},
                {key = "killed_pumpkin_zombies", name = "Töte Zombies mit einem Kürbiskopf", goal = 500},
                {key = "skeletons_taxi", name = "Bringe Skelette zu ihrem Zielort", goal = 25},
                {key = "collected_pumpkins", name = "Sammel Kürbisse", goal = 1000},
            },
			-- LVL 2
            {
                {key = "hearse_delivered", name = "Bringe Leichenwagen in Mr. Skeletons Garage", goal = 25},
                {key = "killed_pumpkin_zombies", name = "Töte Zombies mit einem Kürbiskopf", goal = 1250},
                {key = "skeletons_taxi", name = "Bringe Skelette zu ihrem Zielort", goal = 75},
                {key = "collected_pumpkins", name = "Sammel Kürbisse", goal = 2500},
            },
			-- LVL 3
            {
                {key = "hearse_delivered", name = "Bringe Leichenwagen in Mr. Skeletons Garage", goal = 50},
                {key = "killed_pumpkin_zombies", name = "Töte Zombies mit einem Kürbiskopf", goal = 3000},
                {key = "skeletons_taxi", name = "Bringe Skelette zu ihrem Zielort", goal = 150},
                {key = "collected_pumpkins", name = "Sammel Kürbisse", goal = 6000},
            },
        },
		["EN"] = {
			-- LVL 1
			{
				{key = "hearse_delivered", name = "Deliver hearses to Mr. Skeleton's Garage", goal = 10},
				{key = "killed_pumpkin_zombies", name = "Kill zombies with a pumpkin head", goal = 500},
				{key = "skeletons_taxi", name = "Deliver skeletons to their destination", goal = 25},
				{key = "collected_pumpkins", name = "Collect pumpkins", goal = 1000},
			},
			-- LVL 2
			{
				{key = "hearse_delivered", name = "Deliver hearses to Mr. Skeleton's Garage", goal = 25},
				{key = "killed_pumpkin_zombies", name = "Kill zombies with a pumpkin head", goal = 1250},
				{key = "skeletons_taxi", name = "Deliver skeletons to their destination", goal = 75},
				{key = "collected_pumpkins", name = "Collect pumpkins", goal = 2500},
			},
			-- LVL 3
			{
				{key = "hearse_delivered", name = "Deliver hearses to Mr. Skeleton's Garage", goal = 50},
				{key = "killed_pumpkin_zombies", name = "Kill zombies with a pumpkin head", goal = 3000},
				{key = "skeletons_taxi", name = "Deliver skeletons to their destination", goal = 150},
				{key = "collected_pumpkins", name = "Collect pumpkins", goal = 6000},
			},
		},
		["RU"] = {
			-- LVL 1
			{
				{key = "hearse_delivered", name = "Доставьте катафалки в гараж мистера Скелетона", goal = 10},
				{key = "killed_pumpkin_zombies", name = "Убейте зомби с тыквенной головой", goal = 500},
				{key = "skeletons_taxi", name = "Доставьте скелетов к месту назначения", goal = 25},
				{key = "collected_pumpkins", name = "Соберите тыквы", goal = 1000},
			},
			-- LVL 2
			{
				{key = "hearse_delivered", name = "Доставьте катафалки в гараж мистера Скелетона", goal = 25},
				{key = "killed_pumpkin_zombies", name = "Убейте зомби с тыквенной головой", goal = 1250},
				{key = "skeletons_taxi", name = "Доставьте скелетов к месту назначения", goal = 75},
				{key = "collected_pumpkins", name = "Соберите тыквы", goal = 2500},
			},
			-- LVL 3
			{
				{key = "hearse_delivered", name = "Доставьте катафалки в гараж мистера Скелетона", goal = 50},
				{key = "killed_pumpkin_zombies", name = "Убейте зомби с тыквенной головой", goal = 3000},
				{key = "skeletons_taxi", name = "Доставьте скелетов к месту назначения", goal = 150},
				{key = "collected_pumpkins", name = "Соберите тыквы", goal = 6000},
			},
		},
		["PT"] = {
			-- LVL 1
			{
				{key = "hearse_delivered", name = "Leve carros fúnebres para a garagem do Sr. Esqueleto", goal = 10},
				{key = "killed_pumpkin_zombies", name = "Mate zumbis com cabeça de abóbora", goal = 500},
				{key = "skeletons_taxi", name = "Leve esqueletos até o destino", goal = 25},
				{key = "collected_pumpkins", name = "Colete abóboras", goal = 1000},
			},
			-- LVL 2
			{
				{key = "hearse_delivered", name = "Leve carros fúnebres para a garagem do Sr. Esqueleto", goal = 25},
				{key = "killed_pumpkin_zombies", name = "Mate zumbis com cabeça de abóbora", goal = 1250},
				{key = "skeletons_taxi", name = "Leve esqueletos até o destino", goal = 75},
				{key = "collected_pumpkins", name = "Colete abóboras", goal = 2500},
			},
			-- LVL 3
			{
				{key = "hearse_delivered", name = "Leve carros fúnebres para a garagem do Sr. Esqueleto", goal = 50},
				{key = "killed_pumpkin_zombies", name = "Mate zumbis com cabeça de abóbora", goal = 3000},
				{key = "skeletons_taxi", name = "Leve esqueletos até o destino", goal = 150},
				{key = "collected_pumpkins", name = "Colete abóboras", goal = 6000},
			},
		},
    },
    playerData = {}
}

local showHalloween = false
local currentPage = 1

function HalloweenQuestUI.openWindow()
	if(isWindowOpen())then
		showHalloween = true
		setWindowData()
		showCursor(true)
		triggerServerEvent("HalloweenQuestUI.getData",localPlayer)
		addEventHandler("onClientRender",root,HalloweenQuestUI.render)
	end
end

local function isPageComplete(page)
    for _, quest in ipairs(HalloweenQuestUI["Quests"][apocalypseGetElementData(localPlayer,"language") or "EN"][page]) do
        local progress = tonumber(HalloweenQuestUI.playerData[quest.key]) or 0
        if progress < quest.goal then
            return false
        end
    end
    return true
end

local function isMouseInPosition(x, y, w, h)
    if not isCursorShowing() then return false end
    local cx, cy = getCursorPosition()
    cx, cy = cx * screenW, cy * screenH
    return (cx >= x and cx <= x + w and cy >= y and cy <= y + h)
end

addEventHandler("onClientClick", root, function(button, state)
    if not showHalloween then return end
    if button == "left" and state == "up" then
        local w, h = 500, 350
        local x, y = (screenW - w) / 2, (screenH - h) / 2
        local btnW, btnH = 120, 30

        if isMouseInPosition(x+10, y+h-40, btnW, btnH) and currentPage > 1 then
            currentPage = currentPage - 1
        end

        if isMouseInPosition(x+w-btnW-10, y+h-40, btnW, btnH) and currentPage < #HalloweenQuestUI["Quests"][apocalypseGetElementData(localPlayer,"language") or "EN"] then
            currentPage = currentPage + 1
        end

        if isMouseInPosition(x+(w-btnW)/2, y+h-40, btnW, btnH) then
            if isPageComplete(currentPage) then
                triggerServerEvent("HalloweenQuestUI.claimReward", localPlayer, currentPage)
            else
				createInfobox(getText("CHalloweenQuestUI1"))
            end
        end

        if isMouseInPosition(x+w-35, y+5, 30, 30) then
            showHalloween = false
			closeWindow()
            removeEventHandler("onClientRender", root, HalloweenQuestUI.render)
        end
    end
end)

function HalloweenQuestUI.render()
    local w, h = 500, 350
    local x, y = (screenW - w) / 2, (screenH - h) / 2
    dxDrawRectangle(x, y, w, h, tocolor(20, 20, 20, 220), true)
    dxDrawText(getText("CHalloweenQuestUI2"):format(currentPage), x, y, x+w, y+40, tocolor(255,140,0,255), 1.2, "default-bold", "center", "center", true, false, true)

    local startY = y + 50
    local lineHeight = 55

    local quests = HalloweenQuestUI["Quests"][apocalypseGetElementData(localPlayer,"language") or "EN"][currentPage]
    for i, quest in ipairs(quests) do
        local qY = startY + (i-1)*lineHeight
        dxDrawText(quest.name, x+10, qY, x+w-10, qY+20, tocolor(255,255,255,255), 1, "default-bold", "left", "top", true, false, true)

        local barW, barH = w-20, 15
        local barX, barY = x+10, qY+25
        dxDrawRectangle(barX, barY, barW, barH, tocolor(50,50,50,200), true)

        local progress = HalloweenQuestUI.playerData[quest.key] or 0
        local progressW = (progress/quest.goal) * barW
        dxDrawRectangle(barX, barY, progressW, barH, tocolor(255,140,0,220), true)

        dxDrawText(progress.."/"..quest.goal, barX, barY, barX+barW, barY+barH, tocolor(255,255,255,255), 1, "default", "center", "center", true, false, true)
    end

    local totalPages = #HalloweenQuestUI["Quests"][apocalypseGetElementData(localPlayer,"language") or "EN"]
    dxDrawText(getText("CHalloweenQuestUI3"):format(currentPage,totalPages), x, y+h-65, x+w, y+h-40, tocolor(200,200,200,200), 1, "default", "center", "center", true, false, true)

    local btnW, btnH = 120, 30

    dxDrawRectangle(x+10, y+h-40, btnW, btnH, tocolor(40,40,40,220), true)
    dxDrawText(getText("CHalloweenQuestUI4"), x+10, y+h-40, x+10+btnW, y+h-10, tocolor(255,255,255,255), 1, "default-bold", "center", "center", true, false, true)

    dxDrawRectangle(x+w-btnW-10, y+h-40, btnW, btnH, tocolor(40,40,40,220), true)
    dxDrawText(getText("CHalloweenQuestUI5"), x+w-btnW-10, y+h-40, x+w-10, y+h-10, tocolor(255,255,255,255), 1, "default-bold", "center", "center", true, false, true)

    dxDrawRectangle(x+(w-btnW)/2, y+h-40, btnW, btnH, tocolor(80,40,0,220), true)
    dxDrawText(getText("CHalloweenQuestUI6"), x+(w-btnW)/2, y+h-40, x+(w-btnW)/2+btnW, y+h-10, tocolor(255,200,0,255), 1, "default-bold", "center", "center", true, false, true)

    dxDrawRectangle(x+w-35, y+5, 30, 30, tocolor(200,50,50,220), true)
    dxDrawText("X", x+w-35, y+5, x+w-5, y+35, tocolor(255,255,255,255), 1, "default-bold", "center", "center", true, false, true)
end

addEvent("HalloweenQuestUI.setData",true)
addEventHandler("HalloweenQuestUI.setData",root,function(data)
	HalloweenQuestUI.playerData = data or {}
end)