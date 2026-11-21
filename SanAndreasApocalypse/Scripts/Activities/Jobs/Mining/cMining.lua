local PickaxeTXD = engineLoadTXD("Files/Mods/pickaxe.txd")
engineImportTXD(PickaxeTXD,336)
local PickaxeDFF = engineLoadDFF("Files/Mods/pickaxe.dff")
engineReplaceModel(PickaxeDFF,336)

apocalypseSetElementData(localPlayer,"MiningMarker",nil)

local miningGame = {
	active = false,
	arrows = {},
	points = 0,
	timer = nil,
	nextSpawn = 0,
	progress = 0,
	maxPoints = 10,
	started = 0,
	duration = 12500
}

local screenW, screenH = guiGetScreenSize()
local targetX = screenW * 0.5
local targetY = screenH * 0.75
local targetRadius = 30

local font = "default-bold"

local function dxDrawCircle(x, y, radius, startAngle, stopAngle, color, color2, segments)
	color2 = color2 or color
	segments = segments or 32
	local step = (stopAngle - startAngle) / segments
	for i = 0, segments - 1 do
		local angle1 = math.rad(startAngle + i * step)
		local angle2 = math.rad(startAngle + (i + 1) * step)
		local x1 = x + math.cos(angle1) * radius
		local y1 = y + math.sin(angle1) * radius
		local x2 = x + math.cos(angle2) * radius
		local y2 = y + math.sin(angle2) * radius
		dxDrawLine(x1, y1, x2, y2, i < segments/2 and color or color2, 4)
	end
end

addEvent("startMiningMinigame", true)
addEventHandler("startMiningMinigame", root, function()
	miningGame.active = true
	miningGame.points = 0
	miningGame.arrows = {}
	miningGame.nextSpawn = getTickCount() + 1500
	miningGame.started = getTickCount()

	if isTimer(miningGame.timer) then killTimer(miningGame.timer) end
	miningGame.timer = setTimer(function()
		NPC.MeMessage(getText("CMining1"))
		miningGame.active = false
		setPedAnimation(localPlayer)
	end, miningGame.duration, 1)
end)

addEvent("mining.setStuff",true)
addEventHandler("mining.setStuff",root,function()
	addEventHandler("onClientRender", root, miningGame.render)
	bindKey("arrow_l","down",miningGame.arrow_l)
	bindKey("arrow_r","down",miningGame.arrow_r)
end)

function miningGame.setFeedback(text, r, g, b)
	miningGame.feedbackText = {text = text, r = r, g = g, b = b}
	miningGame.feedbackTime = getTickCount() + 1500
end

function miningGame.render()
	if not miningGame.active then return end

	local now = getTickCount()

	local percent = math.min(miningGame.points / miningGame.maxPoints, 1)
	local barWidth = screenW * 0.4
	local barX = screenW * 0.3
	local barY = screenH * 0.1

	dxDrawRectangle(barX, barY, barWidth, 26, tocolor(0, 0, 0, 180))
	dxDrawRectangle(barX + 3, barY + 3, (barWidth - 6) * percent, 20, tocolor(100, 200, 100, 220))
	dxDrawText(getText("CMining2"):format(miningGame.points, miningGame.maxPoints), barX, barY, barX + barWidth, barY + 26, tocolor(255,255,255,255), 1, font, "center", "center")

	dxDrawCircle(targetX, targetY, targetRadius, 0, 360, tocolor(255, 255, 255, 80), tocolor(255, 255, 255, 80), 50)

	if miningGame.feedbackText and now < miningGame.feedbackTime then
		local fb = miningGame.feedbackText
		dxDrawText(fb.text, targetX - 200, targetY - 100, targetX + 200, targetY - 60, tocolor(fb.r, fb.g, fb.b, 255), 2.4, font, "center", "center")
	end

	if now >= miningGame.nextSpawn then
		local keys = {"arrow_l", "arrow_r"}
		table.insert(miningGame.arrows, {
			key = keys[math.random(#keys)],
			x = screenW,
			created = now
		})
		miningGame.nextSpawn = now + math.random(1000, 1500)
	end

	for i, arrow in ipairs(miningGame.arrows) do
		local elapsed = now - arrow.created
		local duration = 4000
		local progress = elapsed / duration
		arrow.x = screenW - screenW * progress

		local symbol = arrow.key == "arrow_l" and "←" or "→"
		dxDrawText(symbol, arrow.x - 20, targetY - 40, arrow.x + 20, targetY + 40, tocolor(255,255,255,255), 2.6, font, "center", "center")
	end
end

function miningGame.close(binds)
	miningGame.active = false
	removeEventHandler("onClientRender", root, miningGame.render)
	if(binds and binds == true)then
		unbindKey("arrow_l","down",miningGame.arrow_l)
		unbindKey("arrow_r","down",miningGame.arrow_r)
	end
end
addEvent("miningGame.close",true)
addEventHandler("miningGame.close",root,miningGame.close)

local function handleArrowKeyPress(key)
	if not miningGame.active then return end
	for i, arrow in ipairs(miningGame.arrows) do
		if arrow.key == key then
			local dist = math.abs(arrow.x - targetX)

			if dist <= 5 then
				miningGame.points = miningGame.points + 3
				miningGame.setFeedback(getText("CMining3"), 100, 255, 100)
			elseif dist <= 15 then
				miningGame.points = miningGame.points + 2
				miningGame.setFeedback(getText("CMining4"), 200, 200, 50)
			elseif dist <= 30 then
				miningGame.points = miningGame.points + 1
				miningGame.setFeedback(getText("CMining5"), 150, 150, 150)
			else
				miningGame.setFeedback(getText("CMining6"), 255, 80, 80)
			end

			table.remove(miningGame.arrows, i)
			break
		end
	end
	
	if miningGame.points >= miningGame.maxPoints then
		triggerServerEvent("onClientMiningSuccess", localPlayer)
		miningGame.active = false
		if(isTimer(miningGame.timer))then killTimer(miningGame.timer)end
	end
end

function miningGame.arrow_l()
	handleArrowKeyPress("arrow_l")
end

function miningGame.arrow_r()
	handleArrowKeyPress("arrow_r")
end