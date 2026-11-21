local screenW, screenH = guiGetScreenSize()
local panelX, panelY = -220, screenH/2 - 100
local panelWidth, panelHeight = 250, 270
local expandedX = 0
local scrollOffset = {daily = 0, weekly = 0}
local maxVisibleTasks = 4
local taskHeight = 40
local activeTab = "daily"

DailyTasks = {playerTasks = {daily = {}, weekly = {}}}
DailyTasks.isHovering = false

addEvent("DailyTasks.updateClient",true)
addEventHandler("DailyTasks.updateClient",root,function(playerTasks)
    DailyTasks.playerTasks["daily"] = playerTasks
end)

addEvent("DailyTasks.updateClientWeeklyTasks",true)
addEventHandler("DailyTasks.updateClientWeeklyTasks",root,function(playerTasks)
    DailyTasks.playerTasks["weekly"] = playerTasks
end)

local buttonAreaHeight = 110
local extendedPanelHeight = panelHeight + buttonAreaHeight

local buttons = {
    { id = "dailyLogin", text = "Daily Login",    relX = 10, relY = panelHeight-20, w = 230, h = 25 },
    { id = "buyDaily",   text = "Buy Daily-Task ($500)",  relX = 10, relY = panelHeight+15, w = 230, h = 25 },
    { id = "buyWeekly",  text = "Buy Weekly-Task ($750)", relX = 10, relY = panelHeight+50, w = 230, h = 25 }
}

function DailyTasks.renderPanel()
    if(Payday.open == false)then
        local targetX = DailyTasks.isHovering and expandedX or -panelWidth + 20
        panelX = panelX + (targetX - panelX) * 0.1  

        dxDrawRectangle(panelX, panelY, panelWidth, extendedPanelHeight, tocolor(0,0,0,180))
        dxDrawText(getText("CDailyTasks1"), panelX+10, panelY+10, panelX+panelWidth, panelY+30, tocolor(255,255,255), 1, "default-bold")

        local tabDailyHover  = DailyTasks.isCursorOnElement(panelX+10,  panelY+35, 100,25)
        local tabWeeklyHover = DailyTasks.isCursorOnElement(panelX+120, panelY+35, 100,25)
        dxDrawRectangle(panelX+10,  panelY+35, 100,25, tabDailyHover  and tocolor(80,80,80,200) or (activeTab=="daily"  and tocolor(100,100,100,200) or tocolor(50,50,50,200)))
        dxDrawRectangle(panelX+120, panelY+35, 100,25, tabWeeklyHover and tocolor(80,80,80,200) or (activeTab=="weekly" and tocolor(100,100,100,200) or tocolor(50,50,50,200)))
        dxDrawText(getText("CDailyTasks2"), panelX+10,  panelY+40, panelX+110, panelY+55, tocolor(255,255,255),1,"default-bold","center")
        dxDrawText(getText("CDailyTasks3"), panelX+120, panelY+40, panelX+220, panelY+55, tocolor(255,255,255),1,"default-bold","center")

        local startY     = panelY + 70
        local maxListHeight = extendedPanelHeight - 80 - buttonAreaHeight
        local maxVisible = math.floor(maxListHeight / taskHeight)
        local tasksMap   = DailyTasks.playerTasks[activeTab]
        local ids        = {}
        for id,_ in pairs(tasksMap) do
            table.insert(ids, id)
        end
        table.sort(ids)

        local totalTasks = #ids
        local maxOffset = math.max(0, totalTasks - maxVisible)
        scrollOffset[activeTab] = math.min(math.max(scrollOffset[activeTab], 0), maxOffset)

        for i = 1, maxVisible do
            local idx    = i + scrollOffset[activeTab]
            local taskId = ids[idx]
            if taskId then
                local task    = tasksMap[taskId]
                local taskY   = startY + (i-1)*taskHeight
                local hovered = DailyTasks.isCursorOnElement(panelX, taskY, panelWidth, taskHeight)
                local r,g,b   = 50,50,50
                if(tonumber(task.progress) >= 1)then r,g,b = 250,150,0 end
                if(tonumber(task.progress) >= tonumber(task.needed_progress))then r,g,b = 0,250,0 end
                
                dxDrawRectangle(panelX+5, taskY, panelWidth-10, taskHeight,
                    hovered and tocolor(r,g,b,200) or tocolor(r,g,b,200))
                dxDrawText(task.text, panelX+15, taskY+5, panelX+panelWidth, taskY+20,
                    tocolor(255,255,255),1,"default-bold")
                dxDrawText(getText("CDailyTasks4").." "..task.progress.."/"..task.needed_progress,
                    panelX+15, taskY+20, panelX+panelWidth, taskY+35,
                    tocolor(200,200,200),0.9,"default")
            end
        end

        for _,btn in ipairs(buttons) do
            local bx, by = panelX+btn.relX, panelY+btn.relY
            local hovered = DailyTasks.isCursorOnElement(bx, by, btn.w, btn.h)
            dxDrawRectangle(bx, by, btn.w, btn.h, hovered and tocolor(80,80,80,200) or tocolor(60,60,60,200))
            dxDrawText(btn.text, bx, by, bx+btn.w, by+btn.h, tocolor(255,255,255), 1, "default-bold","center","center")
        end
    end
end

function DailyTasks.updateHoverState()
    local cursorX, cursorY = getCursorPosition()
    if cursorX then
        cursorX, cursorY = cursorX * screenW, cursorY * screenH
        DailyTasks.isHovering = cursorX >= panelX and cursorX <= panelX + panelWidth 
                     and cursorY >= panelY and cursorY <= panelY + extendedPanelHeight
    else
        DailyTasks.isHovering = false
    end
end

function DailyTasks.handleScroll(key)
    if not DailyTasks.isHovering then return end

    local tasksMap = DailyTasks.playerTasks[activeTab]
    local ids = {}
    for id,_ in pairs(tasksMap) do
        table.insert(ids, id)
    end
    table.sort(ids)

    local totalTasks = #ids
    local maxOffset = math.max(0, totalTasks - maxVisibleTasks)

    if key == "mouse_wheel_up" and scrollOffset[activeTab] > 0 then
        scrollOffset[activeTab] = scrollOffset[activeTab] - 1
    elseif key == "mouse_wheel_down" and scrollOffset[activeTab] < maxOffset then
        scrollOffset[activeTab] = scrollOffset[activeTab] + 1
    end
end

function DailyTasks.handleClick(button, state)
    if button == "left" and state == "down" then
        if DailyTasks.isCursorOnElement(panelX + 10, panelY + 35, 100, 25) then
            activeTab = "daily"
            scrollOffset["daily"] = 0
        elseif DailyTasks.isCursorOnElement(panelX + 120, panelY + 35, 100, 25) then
            activeTab = "weekly"
            scrollOffset["weekly"] = 0
        end

        for _,btn in ipairs(buttons) do
            local bx, by = panelX+btn.relX, panelY+btn.relY
            if DailyTasks.isCursorOnElement(bx, by, btn.w, btn.h) then
                if btn.id == "buyDaily" then
					triggerServerEvent("DailyTasks.giveNewTask",localPlayer)
                elseif btn.id == "buyWeekly" then
                    triggerServerEvent("WeeklyTasks.giveNewTask",localPlayer)
                elseif btn.id == "dailyLogin" then
                    toggleDailyUI()
                end
            end
        end
    end
end

function DailyTasks.open()
    if scrollOffset[activeTab] == 0 then
        scrollOffset[activeTab] = 0
    end

    addEventHandler("onClientRender",root,DailyTasks.renderPanel)
    addEventHandler("onClientCursorMove",root,DailyTasks.updateHoverState)
    addEventHandler("onClientClick",root,DailyTasks.handleClick)
    bindKey("mouse_wheel_up","down",DailyTasks.handleScroll)
    bindKey("mouse_wheel_down","down",DailyTasks.handleScroll)
end
addEvent("DailyTasks.open",true)
addEventHandler("DailyTasks.open",root,DailyTasks.open)

function DailyTasks.isCursorOnElement(x, y, width, height)
    if not isCursorShowing() then return false end
    local mx, my = getCursorPosition()
    if mx and my then
        mx, my = mx * screenW, my * screenH
        return mx >= x and mx <= x + width and my >= y and my <= y + height
    end
    return false
end