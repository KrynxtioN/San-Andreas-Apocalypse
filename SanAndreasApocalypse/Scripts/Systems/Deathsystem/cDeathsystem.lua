local AlreadyDead = false
local DeathCounter = nil
PlayerKillstreak = {alreadyRendered = false}
local screenWidth,  screenHeight = guiGetScreenSize()

local rewardCount = 0
local rewardThreshold = 10

local ZombieBossNames = {
	["DE"] = {
		[2] = "Der Zerstörer",
		[13] = "Der Panzer",
		[31] = "Der Parasit",
	},
	["EN"] = {
		[2] = "The Destroyer",
		[13] = "The Tank",
		[31] = "The Parasite",
	},
	["RU"] = {
		[2] = "Разрушитель",
		[13] = "Танк",
		[31] = "Паразит",
	},
	["PT"] = {
		[2] = "O Destruidor",
		[13] = "O Tanque",
		[31] = "O Parasita",
	},
}

local BossZombieRenderDistance = 35
local BossZombieList = {}

local function isValidBossZombie(ped)
	return isElement(ped)
		and getElementType(ped) == "ped"
		and getElementData(ped, "zombie") == true
		and getElementData(ped, "BossZombie") == true
end

local function registerBossZombie(ped)
	if(not isValidBossZombie(ped))then return end
	BossZombieList[ped] = true
end

local function unregisterBossZombie(ped)
	BossZombieList[ped] = nil
end

local function rebuildBossZombieList()
	BossZombieList = {}
	for _, ped in ipairs(getElementsByType("ped", root, true))do
		if(isValidBossZombie(ped))then
			BossZombieList[ped] = true
		end
	end
end

local function isLocalPlayerAttacker(attacker)
	if(not attacker or not isElement(attacker))then
		return false
	end

	if(attacker == localPlayer)then
		return true
	end

	if(getElementType(attacker) == "vehicle")then
		local controller = getVehicleController(attacker)
		if(controller == localPlayer)then
			return true
		end
	end

	return false
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	rebuildBossZombieList()
end)

addEventHandler("onClientElementStreamIn", root, function()
	if(getElementType(source) == "ped" and getElementData(source, "BossZombie") == true)then
		registerBossZombie(source)
	end
end)

addEventHandler("onClientElementStreamOut", root, function()
	if(getElementType(source) == "ped")then
		unregisterBossZombie(source)
	end
end)

addEventHandler("onClientElementDestroy", root, function()
	if(getElementType(source) == "ped")then
		unregisterBossZombie(source)
	end
end)

addEventHandler("onClientElementDataChange", root, function(dataName)
	if(getElementType(source) ~= "ped")then return end

	if(dataName == "BossZombie" or dataName == "zombie")then
		if(isValidBossZombie(source))then
			registerBossZombie(source)
		else
			unregisterBossZombie(source)
		end
	end
end)

addEventHandler("onClientPedDamage", root, function(attacker, weapon, bodypart, loss)
	if(not isValidBossZombie(source))then
		return
	end

	if(not isLocalPlayerAttacker(attacker))then
		return
	end

	cancelEvent()
	triggerServerEvent("BossZombie.SyncDamage", localPlayer, source, tonumber(weapon) or 0, tonumber(bodypart) or 0)
end)

local function dxDrawBorderedRectangle(x, y, w, h, borderColor, fillColor, borderSize)
	borderSize = borderSize or 1
	dxDrawRectangle(x, y, w, h, borderColor, false)
	dxDrawRectangle(x + borderSize, y + borderSize, w - (borderSize * 2), h - (borderSize * 2), fillColor, false)
end

local function drawBossZombieHealthbars()
	local px, py, pz = getElementPosition(localPlayer)

	for ped in pairs(BossZombieList)do
		if(isElement(ped))then
			local currentHealth = tonumber(getElementData(ped, "BossZombieHealth")) or 0
			local maxHealth = tonumber(getElementData(ped, "BossZombieMaxHealth")) or 100

			if(currentHealth > 0)then
				local x, y, z = getElementPosition(ped)
				local distance = getDistanceBetweenPoints3D(px, py, pz, x, y, z)

				if(distance <= BossZombieRenderDistance)then
					local sxp, syp = getScreenFromWorldPosition(x, y, z + 1.25, 0.06)
					if(sxp and syp)then
						local bossName = ZombieBossNames[apocalypseGetElementData(localPlayer,"language") or "EN"][apocalypseGetElementData(ped,"BossZombieModel")]

						if(maxHealth < 1)then
							maxHealth = 100
						end

						local progress = currentHealth / maxHealth
						if(progress < 0)then progress = 0 end
						if(progress > 1)then progress = 1 end

						local scale = 1 - (distance / BossZombieRenderDistance) * 0.25
						local barW = 200 * scale
						local barH = 18 * scale
						local barX = sxp - (barW / 2)
						local barY = syp - (42 * scale)

						dxDrawBorderedRectangle(
							barX,
							barY,
							barW,
							barH,
							tocolor(0, 0, 0, 220),
							tocolor(20, 20, 20, 190),
							2
						)

						dxDrawRectangle(
							barX + 2,
							barY + 2,
							(barW - 4) * progress,
							barH - 4,
							tocolor(170, 25, 25, 240),
							false
						)

						dxDrawText(
							bossName,
							barX,
							barY - (22 * scale),
							barX + barW,
							barY,
							tocolor(255, 255, 255, 245),
							1.0 * scale,
							"default-bold",
							"center",
							"center",
							false,
							false,
							false,
							true,
							false
						)

						dxDrawText(
							math.floor(currentHealth).."/"..math.floor(maxHealth),
							barX,
							barY,
							barX + barW,
							barY + barH,
							tocolor(255, 255, 255, 255),
							0.9 * scale,
							"default-bold",
							"center",
							"center",
							false,
							false,
							false,
							true,
							false
						)
					end
				end
			else
				unregisterBossZombie(ped)
			end
		else
			unregisterBossZombie(ped)
		end
	end
end

function cPlayerWasted(Counter)
	if(not(AlreadyDead) == true)then
		setPlayerHudComponentVisible("radar", false)
		if(not(Counter))then
			DeathCounter = 1
		else
			DeathCounter = Counter
		end
		if(isTimer(CounterTimer))then killTimer(CounterTimer)end
		AlreadyDead = true
		setElementInterior(localPlayer, 0) setElementDimension(localPlayer, 0)
		fadeCamera(false)
		closeWindow()
		removeCamHandler()
		
		setTimer(function()
			addEventHandler("onClientRender", root, cPlayerWastedDraw)
			fadeCamera(true)
			setCameraMatrix(717.97369384766, -424.24041748047, 26.675863265991, 671.921875, -512.03533935547, 13.588591575623, 0, 70)
			smoothMoveCamera(717.97369384766, -424.24041748047, 26.675863265991, 671.921875, -512.03533935547, 13.588591575623, 698.81634521484, -460.76403808594, 21.231561660767, 652.76452636719, -548.55895996094, 8.1442899703979,  Counter * 1000)
		end, 1000, 1)
		
		CounterTimer = setTimer(function()
			DeathCounter = DeathCounter - 1
			if(DeathCounter < 1)then
				AlreadyDead = false
				if(CounterTimer)then killTimer(CounterTimer)end
				removeEventHandler("onClientRender", root, cPlayerWastedDraw)
				triggerServerEvent("sPlayerDeath:Spawn", localPlayer)
				triggerServerEvent("checkCompass",localPlayer)
				HUD.Visible = true
			end
		end, 1000, DeathCounter)
	end
end
addEvent("cPlayerWasted", true)
addEventHandler("cPlayerWasted", root, cPlayerWasted)

function cPlayerWasted_Revival()
	if(not(AlreadyDead) == true)then
		setPlayerHudComponentVisible("radar", false)
		fadeCamera(false)
		closeWindow()
		removeCamHandler()
		
		setTimer(function()
			fadeCamera(true)

			local px, py, pz = getElementPosition(localPlayer)
			local camStartX = px + 6
			local camStartY = py
			local camStartZ = pz + 4
			local camEndX = px
			local camEndY = py + 6
			local camEndZ = pz + 3

			setCameraMatrix(
				camStartX, camStartY, camStartZ,
				px, py, pz
			)

			smoothMoveCamera(
				camStartX, camStartY, camStartZ,
				px, py, pz,
				camEndX, camEndY, camEndZ,
				px, py, pz,
				60000
			)
			
			GUIEditor.window[1] = guiCreateWindow(645, 457, 288, 137, "", false)

			GUIEditor.label[1] = guiCreateLabel(9, 28, 269, 35, getText("CRebirthKit1"), false, GUIEditor.window[1])
			guiSetFont(GUIEditor.label[1], "default-bold-small")
			guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", true)
			guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
			GUIEditor.button[1] = guiCreateButton(10, 101, 268, 26, getText("CRebirthKit2"), false, GUIEditor.window[1])
			GUIEditor.button[2] = guiCreateButton(9, 65, 268, 26, getText("CRebirthKit3"), false, GUIEditor.window[1])    
			setWindowData()
			showCursor(true)
			
			addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
				AlreadyDead = false
				local temp_x = apocalypseGetElementData(localPlayer,"Revival_X")
				local temp_y = apocalypseGetElementData(localPlayer,"Revival_Y")
				local temp_z = apocalypseGetElementData(localPlayer,"Revival_Z")
				local temp_int = apocalypseGetElementData(localPlayer,"Revival_Int")
				local temp_dim = apocalypseGetElementData(localPlayer,"Revival_Dim")
				triggerServerEvent("sPlayerDeath:Spawn", localPlayer,temp_x,temp_y,temp_z,temp_int,temp_dim)
				triggerServerEvent("checkCompass",localPlayer)
				triggerServerEvent("PlayerSpawn.TakeKit",localPlayer)
				HUD.Visible = true
				closeWindow()
			end,false)
			
			addEventHandler("onClientGUIClick",GUIEditor.button[2],function()
				closeWindow()
				cPlayerWasted(60)
			end,false)
		end, 1000, 1)
	end
end
addEvent("cPlayerWasted_Revival", true)
addEventHandler("cPlayerWasted_Revival", root, cPlayerWasted_Revival)

function cPlayerWastedDraw()
	if(AlreadyDead == true)then
		HUD.Visible = false
        dxDrawRectangle(1639,  10,  271,  111,  tocolor(20,  20,  20,  200),  false)
        dxDrawRectangle(1639,  10,  271,  10,  tocolor(175,  45,  45,  230),  false)
        dxDrawRectangle(1639,  111,  271,  10,  tocolor(175,  45,  45,  230),  false)
        dxDrawText(getText("CDeathsystem2"):format(DeathCounter),  1711,  30,  1900,  101,  tocolor(255,  255,  255,  255),  1.00,  "default-bold",  "center",  "center",  false,  false,  false,  false,  false)
        dxDrawImage(1649,  36,  52,  55,  "Files/Images/Hearth.png",  0,  0,  0,  tocolor(255,  255,  255,  255),  false)
	end
end

function PlayerKillstreak.Render()
    local width,  height = 250,  50
    local x = (screenWidth - width) / 2
    local y = screenHeight - height - 20

    local bgColor = tocolor(0,  0,  0,  150)
    local borderColor = tocolor(255,  255,  255,  200)
    local textColor = tocolor(255,  255,  255,  255)
    local progressColor = tocolor(255,  0,  0,  200)

    local streak = PlayerKillstreak.kills
    local maxStreak = rewardThreshold

    dxDrawRectangle(x,  y,  width,  height,  bgColor,  false)

    dxDrawRectangle(x,  y,  width,  2,  borderColor,  false)
    dxDrawRectangle(x,  y + height - 2,  width,  2,  borderColor,  false)
    dxDrawRectangle(x,  y,  2,  height,  borderColor,  false)
    dxDrawRectangle(x + width - 2,  y,  2,  height,  borderColor,  false)

    local progressWidth = (streak / maxStreak) * (width - 4)
    dxDrawRectangle(x + 2,  y + 2,  progressWidth,  height - 4,  progressColor,  false)

    local streakText = getText("CHeadshot1"):format(streak)
    local rewardText = getText("CDeathsystem1")..": $"..PlayerKillstreak.money.." + "..PlayerKillstreak.erfahrung.." EXP"
    dxDrawText(streakText,  x + width / 2,  y + height / 2 - 10,  x + width / 2,  y + height / 2 - 10,  textColor,  1.0,  "default-bold",  "center",  "center",  false,  false,  false,  false,  false)
    dxDrawText(rewardText,  x + width / 2,  y + height / 2 + 10,  x + width / 2,  y + height / 2 + 10,  textColor,  1.0,  "default-bold",  "center",  "center",  false,  false,  false,  false,  false)
end

addEvent("PlayerKillstreak.Render", true)
addEventHandler("PlayerKillstreak.Render", root, function(kills, money, erfahrung)
    if(kills == 3 and PlayerKillstreak.alreadyRendered == false)then
		PlayerKillstreak.alreadyRendered = true
		addEventHandler("onClientRender", root, PlayerKillstreak.Render)
	end
	PlayerKillstreak.kills = kills
	PlayerKillstreak.money = money
	PlayerKillstreak.erfahrung = erfahrung
end)

addEvent("PlayerKillstreak.Unrender", true)
addEventHandler("PlayerKillstreak.Unrender", root, function()
	removeEventHandler("onClientRender", root, PlayerKillstreak.Render)
	PlayerKillstreak.alreadyRendered = false
end)

addEventHandler("onClientPlayerWeaponFire", localPlayer, function(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
	if(source == localPlayer)then
		if(not(hitElement))then
			triggerServerEvent("PlayerKillstreak.Stop", localPlayer, localPlayer)
		end
	end
end)

addEventHandler("onClientPedDamage",root,function(attacker, weapon, bodypart)
	if(attacker)then
		if(getElementData(source,"zombie"))then
			if(bodypart ~= 9)then
				triggerServerEvent("PlayerKillstreak.Stop", localPlayer, localPlayer)
			end
		end
	end
end)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	if(source == localPlayer)then
		removeEventHandler("onClientRender", root, PlayerKillstreak.Render)
		PlayerKillstreak.alreadyRendered = false
		triggerServerEvent("PlayerKillstreak.Stop", localPlayer, localPlayer)
	end
end)

ZombieRampageUI = {
	Active = false,
	Level = 0,
	EndTick = 0,
	Duration = 2000,
	MoneyBonus = 0,
	EXPBonus = 0,
	StartTick = 0,
	FlashTick = 0,
}

ZombieMultiKillUI = {
	Active = false,
	Name = "",
	Kills = 0,
	StartTick = 0,
	EndTick = 0,
	MoneyBonus = 0,
	EXPBonus = 0,
}

local sx, sy = guiGetScreenSize()

local function clamp(v, minV, maxV)
	if(v < minV)then return minV end
	if(v > maxV)then return maxV end
	return v
end

local function lerp(a, b, t)
	return a + (b - a) * t
end

local function getPulse(scaleMin, scaleMax, speed)
	local now = getTickCount()
	local s = (math.sin(now / speed) + 1) / 2
	return lerp(scaleMin, scaleMax, s)
end

local function drawTextShadow(text, x, y, w, h, color, scale, font, alignX, alignY, shadowSize)
	shadowSize = shadowSize or 1

	dxDrawText(text, x-shadowSize, y, w-shadowSize, h, tocolor(0,0,0,180), scale, font, alignX, alignY)
	dxDrawText(text, x+shadowSize, y, w+shadowSize, h, tocolor(0,0,0,180), scale, font, alignX, alignY)
	dxDrawText(text, x, y-shadowSize, w, h-shadowSize, tocolor(0,0,0,180), scale, font, alignX, alignY)
	dxDrawText(text, x, y+shadowSize, w, h+shadowSize, tocolor(0,0,0,180), scale, font, alignX, alignY)

	dxDrawText(text, x, y, w, h, color, scale, font, alignX, alignY)
end

local function drawGlowText(text, x, y, w, h, mainColor, glowColor, scale, font, alignX, alignY)
	dxDrawText(text, x-2, y, w-2, h, tocolor(glowColor[1], glowColor[2], glowColor[3], 55), scale, font, alignX, alignY)
	dxDrawText(text, x+2, y, w+2, h, tocolor(glowColor[1], glowColor[2], glowColor[3], 55), scale, font, alignX, alignY)
	dxDrawText(text, x, y-2, w, h-2, tocolor(glowColor[1], glowColor[2], glowColor[3], 55), scale, font, alignX, alignY)
	dxDrawText(text, x, y+2, w, h+2, tocolor(glowColor[1], glowColor[2], glowColor[3], 55), scale, font, alignX, alignY)

	dxDrawText(text, x-1, y, w-1, h, tocolor(0,0,0,220), scale, font, alignX, alignY)
	dxDrawText(text, x+1, y, w+1, h, tocolor(0,0,0,220), scale, font, alignX, alignY)
	dxDrawText(text, x, y-1, w, h-1, tocolor(0,0,0,220), scale, font, alignX, alignY)
	dxDrawText(text, x, y+1, w, h+1, tocolor(0,0,0,220), scale, font, alignX, alignY)

	dxDrawText(text, x, y, w, h, mainColor, scale, font, alignX, alignY)
end

local function drawZombieRampage()
	if(not ZombieRampageUI.Active)then return end

	local now = getTickCount()
	local remaining = ZombieRampageUI.EndTick - now

	if(remaining <= 0)then
		ZombieRampageUI.Active = false
		return
	end

	local progress = clamp(remaining / ZombieRampageUI.Duration, 0, 1)
	local elapsed = now - ZombieRampageUI.StartTick

	local fadeIn = clamp(elapsed / 180, 0, 1)
	local alpha = 255 * fadeIn

	local pulseScale = getPulse(1.00, 1.05, 170)
	local flash = clamp(1 - ((now - ZombieRampageUI.FlashTick) / 350), 0, 1)

	local boxW, boxH = 330, 82
	local x = sx/2 - boxW/2
	local y = sy * 0.76

	local title = "RAMPAGE x"..tostring(ZombieRampageUI.Level)
	local bonusText = "+"..tostring(ZombieRampageUI.MoneyBonus).." $   +"..tostring(ZombieRampageUI.EXPBonus).." EXP"

	local glowAlpha = 35 + (flash * 45)
	local pulseWidth = boxW + (flash * 8)
	local pulseHeight = boxH + (flash * 5)

	dxDrawRectangle(x - ((pulseWidth-boxW)/2), y - ((pulseHeight-boxH)/2), pulseWidth, pulseHeight, tocolor(255, 40, 40, glowAlpha))
	dxDrawRectangle(x, y, boxW, boxH, tocolor(0, 0, 0, 175 * fadeIn))
	dxDrawRectangle(x + 2, y + 2, boxW - 4, boxH - 4, tocolor(18, 18, 18, 215 * fadeIn))

	drawGlowText(
		title,
		x, y + 2, x + boxW, y + 34,
		tocolor(255, 255, 255, alpha),
		{255, 70, 70},
		1.42 * pulseScale,
		"default-bold",
		"center",
		"center"
	)

	drawTextShadow(
		bonusText,
		x, y + 32, x + boxW, y + 56,
		tocolor(255, 230, 230, 235 * fadeIn),
		1.0,
		"default-bold",
		"center",
		"center",
		1
	)

	local barMargin = 10
	local barH = 12
	local barW = boxW - (barMargin * 2)
	local barX = x + barMargin
	local barY = y + boxH - 18

	dxDrawRectangle(barX, barY, barW, barH, tocolor(40, 40, 40, 220 * fadeIn))
	dxDrawRectangle(barX + 1, barY + 1, (barW - 2) * progress, barH - 2, tocolor(220, 40 + flash * 70, 40 + flash * 70, 245 * fadeIn))
end

local function drawZombieMultiKill()
	if(not ZombieMultiKillUI.Active)then return end

	local now = getTickCount()
	local duration = ZombieMultiKillUI.EndTick - ZombieMultiKillUI.StartTick
	local elapsed = now - ZombieMultiKillUI.StartTick
	local remaining = ZombieMultiKillUI.EndTick - now

	if(remaining <= 0)then
		ZombieMultiKillUI.Active = false
		return
	end

	local progress = clamp(elapsed / duration, 0, 1)
	local fadeIn = clamp(elapsed / 120, 0, 1)
	local fadeOut = clamp(remaining / 450, 0, 1)
	local alpha = 255 * math.min(fadeIn, fadeOut + 0.15)

	local popScale = 1.0
	if(progress < 0.18)then
		popScale = lerp(1.8, 1.0, progress / 0.18)
	else
		popScale = getPulse(0.98, 1.03, 200)
	end

	local titleY = sy * 0.20
	local bonusY = sy * 0.27

	local mainColor = tocolor(255, 230, 80, alpha)
	local glowColor = {255, 120, 20}

	if(ZombieMultiKillUI.Kills >= 10)then
		mainColor = tocolor(255, 140, 80, alpha)
		glowColor = {255, 80, 20}
	end
	if(ZombieMultiKillUI.Kills >= 25)then
		mainColor = tocolor(255, 90, 90, alpha)
		glowColor = {255, 30, 30}
	end
	if(ZombieMultiKillUI.Kills >= 50)then
		mainColor = tocolor(255, 80, 200, alpha)
		glowColor = {200, 40, 255}
	end
	if(ZombieMultiKillUI.Kills >= 100)then
		mainColor = tocolor(255, 255, 255, alpha)
		glowColor = {255, 40, 40}
	end

	drawGlowText(
		ZombieMultiKillUI.Name,
		0, titleY, sx, titleY + 60,
		mainColor,
		glowColor,
		2.3 * popScale,
		"default-bold",
		"center",
		"center"
	)

	local bonusText = "+"..tostring(ZombieMultiKillUI.MoneyBonus).." $   +"..tostring(ZombieMultiKillUI.EXPBonus).." EXP"

	drawTextShadow(
		bonusText,
		0, bonusY, sx, bonusY + 30,
		tocolor(255,255,255,alpha),
		1.3,
		"default-bold",
		"center",
		"center",
		2
	)
end

local function drawZombieKillFX()
	drawZombieRampage()
	drawZombieMultiKill()
	drawBossZombieHealthbars()
end
addEventHandler("onClientRender", root, drawZombieKillFX)

addEvent("ZombieRampage.Render", true)
addEventHandler("ZombieRampage.Render", root, function(level, duration, moneyBonus, expBonus)
	ZombieRampageUI.Active = true
	ZombieRampageUI.Level = tonumber(level) or 1
	ZombieRampageUI.Duration = tonumber(duration) or 2000
	ZombieRampageUI.MoneyBonus = tonumber(moneyBonus) or 0
	ZombieRampageUI.EXPBonus = tonumber(expBonus) or 0
	ZombieRampageUI.StartTick = getTickCount()
	ZombieRampageUI.EndTick = ZombieRampageUI.StartTick + ZombieRampageUI.Duration
	ZombieRampageUI.FlashTick = ZombieRampageUI.StartTick
end)

addEvent("ZombieRampage.Unrender", true)
addEventHandler("ZombieRampage.Unrender", root, function()
	ZombieRampageUI.Active = false
	ZombieRampageUI.Level = 0
	ZombieRampageUI.EndTick = 0
	ZombieRampageUI.Duration = 2000
	ZombieRampageUI.MoneyBonus = 0
	ZombieRampageUI.EXPBonus = 0
	ZombieRampageUI.StartTick = 0
	ZombieRampageUI.FlashTick = 0
end)

addEvent("ZombieMultiKill.Render", true)
addEventHandler("ZombieMultiKill.Render", root, function(name, kills, duration, moneyBonus, expBonus)
	ZombieMultiKillUI.Active = true
	ZombieMultiKillUI.Name = tostring(name or "")
	ZombieMultiKillUI.Kills = tonumber(kills) or 0
	ZombieMultiKillUI.StartTick = getTickCount()
	ZombieMultiKillUI.EndTick = ZombieMultiKillUI.StartTick + (tonumber(duration) or 1500)
	ZombieMultiKillUI.MoneyBonus = tonumber(moneyBonus) or 0
	ZombieMultiKillUI.EXPBonus = tonumber(expBonus) or 0
end)

addEvent("ZombieMultiKill.Unrender", true)
addEventHandler("ZombieMultiKill.Unrender", root, function()
	ZombieMultiKillUI.Active = false
	ZombieMultiKillUI.Name = ""
	ZombieMultiKillUI.Kills = 0
	ZombieMultiKillUI.StartTick = 0
	ZombieMultiKillUI.EndTick = 0
	ZombieMultiKillUI.MoneyBonus = 0
	ZombieMultiKillUI.EXPBonus = 0
end)