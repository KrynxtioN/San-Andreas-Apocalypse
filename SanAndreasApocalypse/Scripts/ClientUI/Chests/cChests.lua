local sx, sy = guiGetScreenSize()
local panel = { w = 500, h = 220 }
panel.x = (sx - panel.w)/2
panel.y = (sy - panel.h)/2 - 100
panel.bg, panel.fg = tocolor(30,34,45,230), tocolor(15,18,25,200)

local area = {
    x = panel.x + 20,
    y = panel.y + 50,
    w = panel.w - 40,
    h = panel.h - 120
}

local size = area.h

local rt, font = false, "default-bold"
local visible = false
local state = "ready"
local selectedCase = nil
local pool = {}
local tickStart, duration = 0, 8000
local offset, totalWidth = 0, 0
local hoverBtn, wonItem = nil, nil
local lastTick = getTickCount()

local keyBindsAdded = false

local function shuffle(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

local function startSpin()
    if not selectedCase then return end
    pool = {}
    math.randomseed(getTickCount())
    for i = 1,120 do
        local list = availableCases[selectedCase]
        local it = list[math.random(#list)]
        if math.random(100) <= it[3] then
            table.insert(pool, it)
        end
        shuffle(list)
    end
    totalWidth = #pool * (size + 20)
    offset = 0
    tickStart = getTickCount()
    state = "spinning"
end

function spinChestEnter()
	if visible and state == "ready" then
		startSpin()
	end
end

addEvent("showTheRaffle", true)
addEventHandler("showTheRaffle", root, function(case)
    Inventory.close()
	pool = {}

    selectedCase = case
    visible = true
    state = "ready"
    wonItem = nil

    if isElement(rt) then
        destroyElement(rt)
    end
    rt = dxCreateRenderTarget(area.w, area.h, true)
    showCursor(true)

    if not keyBindsAdded then
        bindKey("enter", "down", spinChestEnter)
        keyBindsAdded = true
    end

    removeEventHandler("onClientRender", root, ShuffleChestRender)
    addEventHandler("onClientRender", root, ShuffleChestRender)
end)

function ShuffleChestRender()
    local now = getTickCount()
    local dt = (now - lastTick)/1000
    lastTick = now

    dxDrawRectangle(0,0,sx,sy,tocolor(0,0,0,150))

    dxDrawRectangle(panel.x,panel.y,panel.w,panel.h,panel.bg)
    dxDrawRectangle(panel.x+5,panel.y+5,panel.w-10,panel.h-10,panel.fg)

    dxDrawText(
        getText("CChests1"),
        panel.x, panel.y+15,
        panel.x+panel.w, panel.y+45,
        tocolor(240,240,240), 1.3, font, "center","top"
    )

    if state == "spinning" then
        local elapsed = now - tickStart
        local t = math.min(elapsed / duration, 1)
        local target = interpolateBetween(
            0,0,0,
            totalWidth - area.w, 0,0,
            t, "InOutQuad"
        )
        offset = offset + (target - offset) * math.min(dt * 10, 1)
        if t >= 1 then
            state = "ended"
            offset = target
            local center = offset + area.w / 2
            local idx = math.floor(center / (size + 20)) + 1
            wonItem = pool[idx]
        end
    end

    dxSetRenderTarget(rt, true)
    dxDrawRectangle(0,0,area.w,area.h,tocolor(0,0,0,120))
    for i,it in ipairs(pool) do
        local x = (i-1)*(size+20) - offset
        local bob = math.sin(now/200 + i) * 4
        dxDrawImage(
            x, bob,
            size, size,
            "Files/Images/Chests/"..it[2],
            0,0,0,
            tocolor(255,255,255,240)
        )
    end
    dxSetRenderTarget()
    dxDrawImage(area.x, area.y, area.w, area.h, rt)

    local midX = area.x + area.w/2
    dxDrawLine(midX, area.y, midX, area.y + area.h, tocolor(200,150,0,200), 2)

    dxDrawText(
        getText("CChests2"),
        panel.x, panel.y + panel.h - 20,
        panel.x + panel.w, panel.y + panel.h,
        tocolor(200,200,200), 1, font, "center","bottom"
    )

    if state == "ended" and wonItem then
        local pulse = 1 + 0.05 * math.sin(now / 200)
        local w = size * 1.4 * pulse
        local px = panel.x + panel.w/2 - w/2
        local py = panel.y + 60 - w/2

        dxDrawImage(px, py, w, w, "Files/Images/Chests/"..wonItem[2])
        dxDrawText(
            getText("CChests3").." "..wonItem[1],
            panel.x, py + w + 5,
            panel.x + panel.w, py + w + 30,
            tocolor(255,215,0), 1.1, font, "center","center"
        )

        local bw, bh = 100, 35
        local by = panel.y + panel.h - bh - 15
        local bx = panel.x + (panel.w - bw)/2
        local mx,my = getCursorPosition()
        if mx then mx, my = mx * sx, my * sy else mx, my = -1, -1 end

        local col = tocolor(200,200,50,
            (mx >= bx and mx <= bx + bw and my >= by and my <= by + bh) and 255 or 200
        )
        if mx >= bx and mx <= bx + bw and my >= by and my <= by + bh then
            hoverBtn = "ok"
        else
            hoverBtn = nil
        end

        dxDrawRectangle(bx, by, bw, bh, col)
        dxDrawText(getText("CChests4"), bx, by, bx+bw, by+bh, tocolor(30,30,30), 1, font, "center","center")
    end
end

addEventHandler("onClientClick", root, function(button, state, absoluteX, absoluteY)
	if(button == "left" and state == "down")then
		if(visible == true and wonItem ~= nil)then
			local bw, bh = 100, 35
			local by = panel.y + panel.h - bh - 15
			local bx = panel.x + (panel.w - bw)/2
			
			if(isMouseInPosition(bx, by, bw, bh))then
				triggerServerEvent("giveTheRaffleItem", localPlayer, selectedCase, wonItem)
				visible = false
				showCursor(false)
				state = "ready"
				removeEventHandler("onClientRender", root, ShuffleChestRender)
				unbindKey("enter", "down", spinChestEnter)
				keyBindsAdded = false
				
				if isElement(rt) then
					destroyElement(rt)
				end
			end
		end
	end
end)