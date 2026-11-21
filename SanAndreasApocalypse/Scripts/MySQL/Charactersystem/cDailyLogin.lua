DailyLogin = {}

local screenW, screenH = guiGetScreenSize()

local isOpen = false
local anim = 0
local animSpeed = 6

local claimed = {}
local canClaimIndex = 1
local weeklyStreak = 0
local canClaimNow = true

local SR, SG, SB = 220, 25, 25

local days = {
	["EN"] = {
		{id=1, name = "Experience Points", desc = "+ 250 EXP * Your Level"},
		{id=2, name = "SAA Coins", desc = "+ 5 SAA Coins"},
		{id=3, name = "Crates", desc = "+ 5 Item Crates\n3 Item Crates XL\n1 Item Crate XXL"},
		{id=4, name = "Experience Points", desc = "+ 500 EXP * Your Level"},
		{id=5, name = "SAA Coins", desc = "+ 10 SAA Coins"},
		{id=6, name = "Brainmass", desc = "+ 1000 Brainmass"},
		{id=7, name = "A large supply package", desc = "750 EXP * Your level\n+ $7500\n+ 1000 brain mass\n+ 5 SAA coins\n+ 2 XXL item crates\n(10000 EXP * weekly streak)"}
	},
	["DE"] = {
		{id=1, name = "Erfahrungspunkte", desc = "+ 250 EXP * Dein Level"},
		{id=2, name = "SAA Münzen", desc = "+ 5 SAA Münzen"},
		{id=3, name = "Kisten", desc = "+ 5 Item-Kisten\n3 Item-Kisten XL\n1 Item-Kiste XXL"},
		{id=4, name = "Erfahrungspunkte", desc = "+ 500 EXP * Dein Level"},
		{id=5, name = "SAA Münzen", desc = "+ 10 SAA Münzen"},
		{id=6, name = "Gehirnmasse", desc = "+ 1000 Gehirnmasse"},
		{id=7, name = "Ein großes Versorgungspaket", desc = "750 EXP * Dein Level\n+ $7500\n+ 1000 Gehirnmasse\n+ 5 SAA Münzen\n+ 2 Item-Kisten XXL\n(10000 EXP * Wochen Streak)"}
	},
	["RU"] = {
		{id=1, name = "Очки опыта", desc = "+ 250 ОП * Ваш уровень"},
		{id=2, name = "Монеты SAA", desc = "+ 5 Монет SAA"},
		{id=3, name = "Ящики", desc = "+ 5 Ящиков с предметами\n3 Ящика XL\n1 Ящик XXL"},
		{id=4, name = "Очки опыта", desc = "+ 500 ОП * Ваш уровень"},
		{id=5, name = "Монеты SAA", desc = "+ 10 Монет SAA"},
		{id=6, name = "Мозговая масса", desc = "+ 1000 Мозговой массы"},
		{id=7, name = "Большой набор припасов", desc = "750 EXP * Твой уровень\n+ $7500\n+ 1000 мозговой массы\n+ 5 монет SAA\n+ 2 XXL ящика с предметами\n(10000 EXP * недельная серия)"}
	},
	["PT"] = {
		{id=1, name = "Pontos de Experiência", desc = "+ 250 EXP * Seu Nível"},
		{id=2, name = "Moedas SAA", desc = "+ 5 Moedas SAA"},
		{id=3, name = "Caixas", desc = "+ 5 Caixas de Itens\n3 Caixas XL\n1 Caixa XXL"},
		{id=4, name = "Pontos de Experiência", desc = "+ 500 EXP * Seu Nível"},
		{id=5, name = "Moedas SAA", desc = "+ 10 Moedas SAA"},
		{id=6, name = "Massa Cerebral", desc = "+ 1000 Massa Cerebral"},
		{id=7, name = "Um grande pacote de suprimentos", desc = "750 EXP * Seu nível\n+ $7500\n+ 1000 massa cerebral\n+ 5 moedas SAA\n+ 2 caixas de itens XXL\n(10000 EXP * sequência semanal)"}
	},
}

local panelW = math.min(1120, screenW * 0.88)
local panelH = 470
local panelX = (screenW - panelW) / 2
local panelY = (screenH - panelH) / 2

local padding = 36
local gap = 12

local headerH = 92
local footerH = 66

local boxW = (panelW - padding * 2 - gap * 6) / 7
local boxH = 265

local fontTitle = "default-bold"
local fontBig = "default-bold"
local fontSmall = "default"

local function lerp(a,b,t)
	return a + (b-a)*t
end

local function easeOutCubic(t)
	return 1 - (1-t)*(1-t)*(1-t)
end

local function getLangDays()
	local lang = apocalypseGetElementData(localPlayer, "language") or "EN"
	return days[lang] or days["EN"]
end

local function cursorIn(x,y,w,h)
	if not isCursorShowing() then return false end
	local cx, cy = getCursorPosition()
	if not cx then return false end

	local mx, my = cx * screenW, cy * screenH
	return mx >= x and mx <= x+w and my >= y and my <= y+h
end

function dxDrawRoundedRectangle(x,y,w,h,r,color)
	dxDrawRectangle(x+r, y, w-r*2, h, color)
	dxDrawRectangle(x, y+r, w, h-r*2, color)

	dxDrawCircle(x+r, y+r, r, 180, 270, color, color, 16)
	dxDrawCircle(x+w-r, y+r, r, 270, 360, color, color, 16)
	dxDrawCircle(x+r, y+h-r, r, 90, 180, color, color, 16)
	dxDrawCircle(x+w-r, y+h-r, r, 0, 90, color, color, 16)
end

function toggleDailyUI()
	isOpen = not isOpen

	if isOpen then
		showCursor(true)
		setWindowData("no")
		triggerServerEvent("DailyLogin.onDailyStateReceiveRequest", localPlayer)
	else
		showCursor(false)
	end
end

addEvent("toggleDailyUI", true)
addEventHandler("toggleDailyUI", root, toggleDailyUI)

addEvent("DailyLogin.onDailyStateReceive", true)
addEventHandler("DailyLogin.onDailyStateReceive", root, function(serverClaimed, serverCanClaim, serverWeeklyStreak, serverCanClaimNow)
	claimed = serverClaimed or claimed
	canClaimIndex = serverCanClaim or canClaimIndex
	weeklyStreak = serverWeeklyStreak or 0
	canClaimNow = serverCanClaimNow == true
end)

addEvent("DailyLogin.onDailyClaimedUpdate", true)
addEventHandler("DailyLogin.onDailyClaimedUpdate", root, function(newClaimed, newCanClaim, newWeeklyStreak, newCanClaimNow)
	claimed = newClaimed or claimed
	canClaimIndex = newCanClaim or canClaimIndex
	weeklyStreak = newWeeklyStreak or weeklyStreak
	canClaimNow = newCanClaimNow == true
end)

addEventHandler("onClientClick", root, function(button, state)
	if not isOpen then return end
	if button ~= "left" or state ~= "up" then return end

	local a = easeOutCubic(anim)
	local py = lerp(screenH, panelY, a)

	local closeSize = 32
	local closeX = panelX + panelW - padding - closeSize
	local closeY = py + 30

	if cursorIn(closeX, closeY, closeSize, closeSize) then
		toggleDailyUI()
		return
	end

	local startY = py + headerH + 18

	for i = 1,7 do
		local x = panelX + padding + (i-1) * (boxW + gap)
		local y = startY

		if cursorIn(x, y, boxW, boxH) then
			if i == canClaimIndex and not claimed[i] and canClaimNow then
				triggerServerEvent("DailyLogin.onPlayerClaimDaily", localPlayer, i)
			end
			return
		end
	end
end)

addEventHandler("onClientRender", root, function()
	if isOpen then
		anim = math.min(1, anim + (1/60) * animSpeed)
	else
		anim = math.max(0, anim - (1/60) * animSpeed)
	end

	if anim <= 0 then return end

	local a = easeOutCubic(anim)
	local py = lerp(screenH, panelY, a)

	dxDrawRectangle(0, 0, screenW, screenH, tocolor(0,0,0,165*a))

	dxDrawRoundedRectangle(panelX + 5, py + 6, panelW, panelH, 18, tocolor(0,0,0,95*a))
	dxDrawRoundedRectangle(panelX, py, panelW, panelH, 18, tocolor(20,21,25,248*a))

	dxDrawRectangle(panelX + padding, py + 78, panelW - padding * 2, 1, tocolor(255,255,255,22*a))
	dxDrawRectangle(panelX + padding, py + 78, panelW - padding * 2, 2, tocolor(SR,SG,SB,185*a))

	dxDrawText(
		getText("CDailyLogin1"),
		panelX + padding,
		py + 26,
		panelX + panelW - 250,
		py + 56,
		tocolor(255,255,255,245*a),
		1.25,
		fontTitle,
		"left",
		"top"
	)

	dxDrawText(
		getText("CDailyLogin2"),
		panelX + padding,
		py + 56,
		panelX + panelW - 250,
		py + 76,
		tocolor(190,190,195,225*a),
		0.95,
		fontSmall,
		"left",
		"top"
	)

	local closeSize = 32
	local closeX = panelX + panelW - padding - closeSize
	local closeY = py + 30

	local streakW = 142
	local streakH = 32
	local streakX = closeX - streakW - 14
	local streakY = py + 30

	dxDrawRoundedRectangle(streakX, streakY, streakW, streakH, 9, tocolor(31,32,38,240*a))
	dxDrawRectangle(streakX, streakY + streakH - 3, streakW, 2, tocolor(SR,SG,SB,160*a))
	dxDrawText(
		tostring(weeklyStreak) .. "x Streak",
		streakX,
		streakY,
		streakX + streakW,
		streakY + streakH,
		tocolor(240,240,240,240*a),
		0.95,
		fontBig,
		"center",
		"center"
	)

	local closeHover = cursorIn(closeX, closeY, closeSize, closeSize)
	dxDrawRoundedRectangle(
		closeX,
		closeY,
		closeSize,
		closeSize,
		9,
		closeHover and tocolor(SR,SG,SB,215*a) or tocolor(32,33,39,240*a)
	)
	dxDrawText(
		"×",
		closeX,
		closeY - 2,
		closeX + closeSize,
		closeY + closeSize,
		tocolor(245,245,245,245*a),
		1.25,
		fontBig,
		"center",
		"center"
	)

	local langDays = getLangDays()
	local startY = py + headerH + 18

	for i = 1,7 do
		local x = panelX + padding + (i-1) * (boxW + gap)
		local y = startY
		local hover = cursorIn(x, y, boxW, boxH)
		local isClaimableReward = i == canClaimIndex and canClaimIndex <= 7

		local bgR, bgG, bgB = 34, 35, 41
		local lineR, lineG, lineB = 70, 72, 82
		local lineA = 145
		local dayBoxR, dayBoxG, dayBoxB = 24, 25, 30
		local statusText = ""
		local statusR, statusG, statusB = 170, 170, 175

		if claimed[i] then
			bgR, bgG, bgB = 32, 44, 36
			lineR, lineG, lineB = 76, 145, 88
			lineA = 175
			statusText = getText("CDailyLogin3")
			statusR, statusG, statusB = 125, 225, 140
		elseif isClaimableReward then
			if canClaimNow then
				bgR, bgG, bgB = 39, 35, 38
				lineR, lineG, lineB = SR, SG, SB
				lineA = 220
				dayBoxR, dayBoxG, dayBoxB = SR, SG, SB
				statusText = getText("CDailyLogin4")
				statusR, statusG, statusB = 255, 255, 255
			else
				bgR, bgG, bgB = 36, 36, 42
				lineR, lineG, lineB = SR, SG, SB
				lineA = 105
				statusText = "..."
				statusR, statusG, statusB = 185, 185, 190
			end
		end

		if isClaimableReward then
			local pulse = 48 + math.sin(getTickCount() / 450) * 16
			dxDrawRoundedRectangle(x - 5, y - 5, boxW + 10, boxH + 10, 16, tocolor(SR,SG,SB,pulse*a))
		end

		if hover then
			dxDrawRoundedRectangle(x - 3, y - 3, boxW + 6, boxH + 6, 14, tocolor(255,255,255,30*a))
		end

		dxDrawRoundedRectangle(x, y, boxW, boxH, 14, tocolor(bgR,bgG,bgB,236*a))

		dxDrawRectangle(x + 14, y + 12, boxW - 28, 2, tocolor(lineR,lineG,lineB,lineA*a))

		local badgeSize = 34
		dxDrawRoundedRectangle(x + 14, y + 24, badgeSize, badgeSize, 9, tocolor(dayBoxR,dayBoxG,dayBoxB,225*a))
		dxDrawText(
			tostring(i),
			x + 14,
			y + 24,
			x + 14 + badgeSize,
			y + 24 + badgeSize,
			tocolor(255,255,255,240*a),
			1,
			fontBig,
			"center",
			"center"
		)

		dxDrawText(
			langDays[i].name,
			x + 8,
			y + 68,
			x + boxW - 8,
			y + 105,
			tocolor(245,245,245,240*a),
			1,
			fontBig,
			"center",
			"top",
			true,
			true
		)

		dxDrawText(
			langDays[i].desc,
			x + 8,
			y + 108,
			x + boxW - 8,
			y + boxH - 50,
			tocolor(188,188,195,222*a),
			1,
			fontSmall,
			"center",
			"top",
			true,
			true
		)

		if statusText ~= "" then
			local buttonW = boxW - 28
			local buttonH = 28
			local buttonX = x + 14
			local buttonY = y + boxH - 38

			local br, bg, bb = 28, 29, 34

			if isClaimableReward and canClaimNow and not claimed[i] then
				br, bg, bb = SR, SG, SB
			elseif claimed[i] then
				br, bg, bb = 42, 78, 48
			end

			dxDrawRoundedRectangle(buttonX, buttonY, buttonW, buttonH, 8, tocolor(br,bg,bb,220*a))
			dxDrawText(
				statusText,
				buttonX,
				buttonY,
				buttonX + buttonW,
				buttonY + buttonH,
				tocolor(statusR,statusG,statusB,240*a),
				0.82,
				fontBig,
				"center",
				"center"
			)
		end
	end

	local claimedCount = 0
	for i = 1,7 do
		if claimed[i] then claimedCount = claimedCount + 1 end
	end

	local footerText = string.format(getText("CDailyLogin2"), claimedCount)

	local progressX = panelX + padding
	local progressY = py + panelH - 58
	local progressW = panelW - padding * 2
	local progressH = 8
	local progress = claimedCount / 7

	dxDrawRectangle(panelX + padding, py + panelH - footerH - 4, panelW - padding * 2, 1, tocolor(255,255,255,18*a))

	dxDrawRoundedRectangle(progressX, progressY, progressW, progressH, 4, tocolor(35,36,42,230*a))
	dxDrawRoundedRectangle(progressX, progressY, progressW * progress, progressH, 4, tocolor(SR,SG,SB,190*a))

	dxDrawText(
		footerText,
		panelX + padding,
		py + panelH - 44,
		panelX + panelW - padding,
		py + panelH - 14,
		tocolor(190,190,195,225*a),
		0.95,
		fontSmall,
		"left",
		"center"
	)

	dxDrawText(
		tostring(claimedCount) .. "/7",
		panelX + padding,
		py + panelH - 44,
		panelX + panelW - padding,
		py + panelH - 14,
		tocolor(220,220,225,225*a),
		0.95,
		fontBig,
		"right",
		"center"
	)
end)