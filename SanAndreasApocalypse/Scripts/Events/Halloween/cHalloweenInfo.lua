local isHalloweenWindowOpen = false
local scrollIndex = 1
local lineHeight = 18
local scrollSpeed = 1
local wrappedLines = {}
local visibleLines, maxScroll = 0,0
local contentX, contentY, contentW, contentH
local win = {}
local handlers = {}

local content = "Halloween Event runs from October 1st until November 5th.\nPlayers can collect pumpkins through various activities.\nPumpkins are required for Halloween quests and can also be exchanged in the Halloween Shop for exclusive rewards such as event-only vehicles.\n\nPumpkin Hunt:\n- Every 10 minutes, there is a 50% chance that a pumpkin will appear on your screen.\nIf clicked within 5 seconds, 12 more pumpkins will spawn, which must be clicked within 10 seconds.\n- Decorative pumpkins can be found at major locations. Clicking them grants 1 pumpkin (available every 5 minutes).\n- Additional pumpkins are scattered randomly across San Andreas and can also be collected.\n- On in-game Saturdays and Sundays, every pumpkin you collect will grant one extra bonus pumpkin.\n\nHearse Missions:\nHearses can be found across San Andreas. Players can either transport Mr. Skeleton’s relatives in a taxi-like activity or deliver the hearses directly to his garage.\n\nHalloween Shop:\n- Totems: Can be purchased and placed at 25 different locations. Placement coordinates are available in the shop.\n  Once placed, totems generate pumpkins for you at every payday.\n- Pumpkin Seeds: Can be bought and planted, similar to apple trees and other plants.\n\nQuestlines:\nTwo special Halloween questlines await, offering rewards such as unique vehicles, coupons, experience points, and Halloween keys.\n\nQuest 1:\nComplete 10 stages to earn rewards like coupons, special vehicles, and pumpkinhead items.\n\nQuest 2:\nLevel 1-3: Deliver hearses, kill zombies with pumpkin head, deliver skeletons, collect pumpkins.\nAfter completing each level, you will receive a Halloween Key. Open all chests to unlock the Skeleton Outfit, which grants 15 XP per zombie kill and 1 pumpkin while wearing it."

local function wrapText(text, width, scale, font)
    local wrapped = {}
    for paragraph in text:gmatch("([^\n]*)\n?") do
        if paragraph == "" then
            table.insert(wrapped, " ")
        else
            local currentLine = ""
            for word in paragraph:gmatch("%S+") do
                local testLine = (currentLine ~= "" and currentLine.." "..word or word)
                if dxGetTextWidth(testLine, scale, font) > width then
                    table.insert(wrapped, currentLine)
                    currentLine = word
                else
                    currentLine = testLine
                end
            end
            table.insert(wrapped, currentLine)
        end
    end
    return wrapped
end

function openHalloweenWindow()
    if isHalloweenWindowOpen then return end
    isHalloweenWindowOpen = true
    scrollIndex = 1

    local screenW, screenH = guiGetScreenSize()
    win = {x = screenW/2-600/2, y = screenH/2-400/2, w = 600, h = 400}
    contentX, contentY = win.x+10, win.y+50
    contentW, contentH = win.w-20, win.h-60
	setWindowData()

    wrappedLines = wrapText(content, contentW, 1, "default")
    visibleLines = math.floor(contentH / lineHeight)
    maxScroll = #wrappedLines - visibleLines
    if maxScroll < 0 then maxScroll = 0 end

    showCursor(true)

    handlers.render = function()
        if not isHalloweenWindowOpen then return end
        dxDrawRectangle(win.x, win.y, win.w, win.h, tocolor(30,30,30,220))
        dxDrawRectangle(win.x, win.y, win.w, 40, tocolor(255,165,0,200))
        dxDrawText("HALLOWEEN EVENT", win.x, win.y, win.x+win.w, win.y+40, tocolor(0,0,0,255), 1.5, "default-bold","center","center")

        dxDrawRectangle(win.x+win.w-30, win.y+5, 25, 25, tocolor(200,0,0,200))
        dxDrawText("X", win.x+win.w-30, win.y+5, win.x+win.w-5, win.y+30, tocolor(255,255,255,255), 1, "default-bold","center","center")

        dxDrawText("Use the mouse wheel to scroll", contentX, win.y+win.h-20, contentX+contentW, win.y+win.h-5, tocolor(255,255,0,255), 1, "default","left","top", true, true)

        for i=0, visibleLines-1 do
            local line = wrappedLines[scrollIndex+i]
            if line then
                dxDrawText(line, contentX, contentY+i*lineHeight, contentX+contentW, contentY+(i+1)*lineHeight, tocolor(255,255,255,255), 1, "default","left","top", true, true)
            end
        end
    end
    addEventHandler("onClientRender", root, handlers.render)

    handlers.scrollUp = function()
        scrollIndex = scrollIndex - scrollSpeed
        if scrollIndex < 1 then scrollIndex = 1 end
    end
    handlers.scrollDown = function()
        scrollIndex = scrollIndex + scrollSpeed
        if scrollIndex > maxScroll+1 then scrollIndex = maxScroll+1 end
    end
    bindKey("mouse_wheel_up","down",handlers.scrollUp)
    bindKey("mouse_wheel_down","down",handlers.scrollDown)

    handlers.click = function(button,state)
        if button ~= "left" or state ~= "down" then return end
        local bx, by, bw, bh = win.x+win.w-30, win.y+5, 25, 25
        local mx, my = getCursorPosition()
        if not mx or not my then return end
        mx, my = mx*screenW, my*screenH
        if mx >= bx and mx <= bx+bw and my >= by and my <= by+bh then
            closeHalloweenWindow()
        end
    end
    addEventHandler("onClientClick", root, handlers.click)
end

function closeHalloweenWindow()
    if not isHalloweenWindowOpen then return end
    isHalloweenWindowOpen = false
    showCursor(false)
	closeWindow()

    removeEventHandler("onClientRender", root, handlers.render)
    removeEventHandler("onClientClick", root, handlers.click)
    unbindKey("mouse_wheel_up","down",handlers.scrollUp)
    unbindKey("mouse_wheel_down","down",handlers.scrollDown)
    handlers = {}
end