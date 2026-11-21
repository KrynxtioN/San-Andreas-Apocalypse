HUD = {
	["Data"] = {
		Health = 0,
		Armor = 0,
		Money = 0,
		Hunger = 0,
		Thirst = 0,
		ExtraArmor = 0
	},
	Visible = true
}

local x, y = guiGetScreenSize()

local HUDComponents = {
	"ammo",
	"armour",
	"breath",
	"clock",
	"health",
	"money",
	"weapon",
	"wanted",
	"area_name"
}

local boxWidth, boxHeight = 200, 25
local padding = 5
local animationSpeed = 0.1

local healthX, healthY = x - boxWidth - padding, padding
local armorX, armorY = x - boxWidth - padding, healthY + boxHeight + padding
local moneyX, moneyY = x - boxWidth - padding, armorY + boxHeight + padding
local safeZoneX, safeZoneY = x - boxWidth - padding, moneyY + boxHeight + padding
local hungerX, hungerY = x - boxWidth - padding, safeZoneY + boxHeight + padding
local thirstX, thirstY = x - boxWidth - padding, hungerY + boxHeight + padding

local weaponBoxWidth, weaponBoxHeight = 50, 50
local weaponX, weaponY = healthX - weaponBoxWidth - padding, padding

local clockBoxWidth, clockBoxHeight = 200, 25
local clockX, clockY = x - boxWidth - padding, safeZoneY + boxHeight + padding

local skillImagePaths = {
	[1] = "Files/Images/Inventory/196.png",
	[2] = "Files/Images/Inventory/195.png",
	[3] = "Files/Images/Inventory/194.png",
	[4] = "Files/Images/Inventory/197.png",
}

local skillItems = {
	[1] = 196,
	[2] = 195,
	[3] = 194,
	[4] = 197,
}

local skillInfo = {
	[1] = {
		["DE"] = {
			name = "Trank: Heilungsboost",
			text = "Heilt sofort 25 HP und anschließend 10x alle 1,5 Sekunden 5 HP."
		},
		["EN"] = {
			name = "Potion: Healing Boost",
			text = "Instantly heals 25 HP and then restores 5 HP every 1.5 seconds 10 times."
		},
		["RU"] = {
			name = "Зелье: Усиление лечения",
			text = "Мгновенно восстанавливает 25 HP, а затем 10 раз по 5 HP каждые 1.5 секунды."
		},
		["PT"] = {
			name = "Poção: Impulso de Cura",
			text = "Recupera instantaneamente 25 HP e depois restaura 5 HP a cada 1,5 segundos, 10 vezes."
		},
	},

	[2] = {
		["DE"] = {
			name = "Trank: Schutz vor Zombies",
			text = "Erstellt eine Schutzzone um dich herum, die 60 Sekunden lang hält und alle Zombies tötet, die sie betreten."
		},
		["EN"] = {
			name = "Potion: Zombie Protection",
			text = "Creates a protection zone around you for 60 seconds that kills all zombies entering it."
		},
		["RU"] = {
			name = "Зелье: Защита от зомби",
			text = "Создает вокруг вас защитную зону на 60 секунд, которая убивает всех зомби, входящих в неё."
		},
		["PT"] = {
			name = "Poção: Proteção contra Zumbis",
			text = "Cria uma zona de proteção ao seu redor por 60 segundos que mata todos os zumbis que entrarem nela."
		},
	},

	[3] = {
		["DE"] = {
			name = "Trank: Geschwindigkeitsboost",
			text = "Erhöht deine Geschwindigkeit für 10 Sekunden erheblich."
		},
		["EN"] = {
			name = "Potion: Speed Boost",
			text = "Greatly increases your movement speed for 10 seconds."
		},
		["RU"] = {
			name = "Зелье: Ускорение",
			text = "Значительно увеличивает вашу скорость передвижения на 10 секунд."
		},
		["PT"] = {
			name = "Poção: Impulso de Velocidade",
			text = "Aumenta significativamente sua velocidade de movimento por 10 segundos."
		},
	},

	[4] = {
		["DE"] = {
			name = "Trank: Zombiebetäubung",
			text = "Betäubt alle Zombies in deiner Nähe für 5 Sekunden."
		},
		["EN"] = {
			name = "Potion: Zombie Stun",
			text = "Stuns all nearby zombies for 5 seconds."
		},
		["RU"] = {
			name = "Зелье: Оглушение зомби",
			text = "Оглушает всех ближайших зомби на 5 секунд."
		},
		["PT"] = {
			name = "Poção: Atordoamento de Zumbis",
			text = "Atordoa todos os zumbis próximos por 5 segundos."
		},
	},
}

local skillCooldown = {}
local skillFlash = {}

local skillBoxSize = 40
local skillBoxGap = 6
local skillRowWidth = (skillBoxSize * 4) + (skillBoxGap * 3)
local skillRowX = (x - padding) - skillRowWidth
local skillRowY = thirstY + boxHeight + padding

local animationProgress = 0
local animationDuration = 2000
local hudStartX = x + boxWidth
local hudEndX = x - boxWidth - padding

local blinkTimer = 500
local lastBlinkTime = getTickCount()
local isBlinking = false
local lastTick = getTickCount()

local iconX = padding + 10
local iconY = y - boxHeight - padding - 35
local iconSize = 32
local iconSpacing = 10

local function hasSkillItem(idx)
	local itemID = skillItems[idx]
	if not itemID then return false end

	if type(hasPlayerItem) == "function" then
		return hasPlayerItem(itemID) >= 1
	end

	return false
end

local function startSkillCooldown(idx, seconds)
	idx = tonumber(idx)
	seconds = tonumber(seconds)

	if not idx or idx < 1 or idx > 4 then return end
	if not seconds or seconds <= 0 then return end

	skillCooldown[idx] = {
		startTick = getTickCount(),
		durationMs = math.floor(seconds * 1000)
	}

	skillFlash[idx] = getTickCount()
end

local function getSkillCooldownData(idx)
	local cd = skillCooldown[idx]
	if not cd then return nil, nil end

	local now = getTickCount()
	local elapsed = now - cd.startTick

	if elapsed >= cd.durationMs then
		skillCooldown[idx] = nil
		return nil, nil
	end

	local progress = elapsed / cd.durationMs
	local secondsLeft = math.ceil((cd.durationMs - elapsed) / 1000)

	return progress, secondsLeft
end

addEvent("HUD.startSkillCooldown", true)
addEventHandler("HUD.startSkillCooldown", root, function(idx, seconds)
	startSkillCooldown(idx, seconds)
end)

local function isMouseInPosition(px, py, w, h)
	if not isCursorShowing() then return false end

	local cx, cy = getCursorPosition()
	if not cx or not cy then return false end

	cx = cx * x
	cy = cy * y

	return cx >= px and cx <= px + w and cy >= py and cy <= py + h
end

local function drawBorder(px, py, w, h, size, color)
	dxDrawRectangle(px, py, w, size, color)
	dxDrawRectangle(px, py + h - size, w, size, color)
	dxDrawRectangle(px, py, size, h, color)
	dxDrawRectangle(px + w - size, py, size, h, color)
end

local function drawTooltip(title, text, status, px, py)
	local width = 280
	local height = 82

	if px + width > x then
		px = x - width - 10
	end

	if py + height > y then
		py = y - height - 10
	end

	dxDrawRectangle(px, py, width, height, tocolor(15, 15, 15, 235))
	dxDrawRectangle(px, py, width, 2, tocolor(220,25,25, 230))

	dxDrawText(title, px + 8, py + 6, px + width - 8, py + 24, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top")
	dxDrawText(text, px + 8, py + 28, px + width - 8, py + 58, tocolor(255, 255, 255, 245), 0.9, "default", "left", "top", true, true)
	dxDrawText(status, px + 8, py + 60, px + width - 8, py + height - 6, tocolor(200, 200, 200, 255), 0.9, "default-bold", "left", "top")
end

local function drawSkillBlock(idx, baseX, baseY)
	local bx = baseX + (idx - 1) * (skillBoxSize + skillBoxGap)
	local by = baseY

	local cdProgress, secondsLeft = getSkillCooldownData(idx)
	local hasItem = hasSkillItem(idx)
	local hovered = isMouseInPosition(bx, by, skillBoxSize, skillBoxSize)

	local flashAlpha = 0

	if skillFlash[idx] then
		local flashElapsed = getTickCount() - skillFlash[idx]

		if flashElapsed <= 350 then
			flashAlpha = 220 - ((flashElapsed / 350) * 220)
		else
			skillFlash[idx] = nil
		end
	end

	dxDrawRectangle(bx - 2, by - 2, skillBoxSize + 4, skillBoxSize + 4, tocolor(20, 20, 20, 220))

	if hovered and hasItem and not cdProgress then
		dxDrawRectangle(bx - 4, by - 4, skillBoxSize + 8, skillBoxSize + 8, tocolor(255, 220, 80, 120))
	end

	if flashAlpha > 0 then
		dxDrawRectangle(bx - 5, by - 5, skillBoxSize + 10, skillBoxSize + 10, tocolor(255, 220, 80, flashAlpha))
	end

	local imgAlpha = 255

	if cdProgress then
		imgAlpha = 120
	end

	if not hasItem then
		imgAlpha = 65
	end

	local imgPath = skillImagePaths[idx]

	if imgPath and fileExists(imgPath) then
		dxDrawImage(bx, by, skillBoxSize, skillBoxSize, imgPath, 0, 0, 0, tocolor(255, 255, 255, imgAlpha))
	else
		dxDrawRectangle(bx, by, skillBoxSize, skillBoxSize, tocolor(50, 50, 50, 220))
	end

	if not hasItem then
		dxDrawRectangle(bx, by, skillBoxSize, skillBoxSize, tocolor(0, 0, 0, 155))
		dxDrawLine(bx + 6, by + 6, bx + skillBoxSize - 6, by + skillBoxSize - 6, tocolor(200, 0, 0, 230), 3)
		dxDrawLine(bx + skillBoxSize - 6, by + 6, bx + 6, by + skillBoxSize - 6, tocolor(200, 0, 0, 230), 3)
	end

	drawBorder(bx, by, skillBoxSize, skillBoxSize, 2, tocolor(255, 255, 255, 170))

	dxDrawText(tostring(idx), bx + 2, by + 2, bx + skillBoxSize, by + skillBoxSize, tocolor(0, 0, 0, 180), 1.2, "default-bold", "left", "top")
	dxDrawText(tostring(idx), bx, by, bx + skillBoxSize - 3, by + skillBoxSize - 3, tocolor(255, 255, 255, 255), 1.2, "default-bold", "left", "top")

	if cdProgress then
		local overlayHeight = skillBoxSize * (1 - cdProgress)

		dxDrawRectangle(bx, by, skillBoxSize, overlayHeight, tocolor(0, 0, 0, 165))
		dxDrawText(tostring(secondsLeft), bx, by, bx + skillBoxSize, by + skillBoxSize, tocolor(255, 255, 255, 255), 1.35, "default-bold", "center", "center")
	else
		dxDrawRectangle(bx, by, skillBoxSize, skillBoxSize, tocolor(255, 255, 255, 25))
	end

	if hovered then
		local info = skillInfo[idx][apocalypseGetElementData(localPlayer,"language") or "EN"]

		if info then
			local status = getText("CPotions1")

			if not hasItem then
				status = getText("CPotions2")
			elseif cdProgress then
				status = getText("CPotions3"):format(tostring(secondsLeft))
			end

			drawTooltip(info.name, info.text, status, bx - 230, by + skillBoxSize + 8)
		end
	end
end

function HUD.updatePosition()
	local progress = math.min(animationProgress / animationDuration, 1)
	local newX = hudStartX + (hudEndX - hudStartX) * progress

	healthX = newX
	armorX = newX
	moneyX = newX
	safeZoneX = newX
	weaponX = newX - weaponBoxWidth - padding
	clockX = newX
	hungerX = newX
	thirstX = newX

	skillRowX = (healthX + boxWidth) - skillRowWidth
	skillRowY = thirstY + boxHeight + padding
end

function HUD.updateAnimation()
	local now = getTickCount()
	animationProgress = animationProgress + now - lastTick
	lastTick = now

	if animationProgress > animationDuration then
		animationProgress = animationDuration
	end
end

function HUD.render()
	if isCharacterLoggedIn() and HUD.Visible == true and apocalypseGetElementData(localPlayer, "TutorialEndCamera") ~= true and not isPlayerMapVisible() then
		HUD.updateAnimation()
		HUD.updatePosition()

		local healthBarWidth = (HUD["Data"].Health / 100) * (boxWidth - 4)
		local HealthColor = tocolor(255, 0, 0, 255)

		if apocalypseGetElementData(localPlayer, "BarHealing") == true and getElementHealth(localPlayer) < 100 then
			local currentTime = getTickCount()

			if currentTime - lastBlinkTime > blinkTimer then
				isBlinking = not isBlinking
				lastBlinkTime = currentTime
			end

			if isBlinking then
				HealthColor = tocolor(255, 0, 0, 255)
			else
				HealthColor = tocolor(255, 255, 255, 0)
			end
		end

		dxDrawRectangle(healthX, healthY, boxWidth, boxHeight, tocolor(50, 50, 50, 200))
		dxDrawRectangle(healthX + 2, healthY + 2, healthBarWidth, boxHeight - 4, HealthColor)
		dxDrawText(getText("CHUD1") .. ": " .. math.floor(HUD["Data"].Health), healthX + 10, healthY, healthX + boxWidth - 10, healthY + boxHeight, tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "center")

		if HUD["Data"].ExtraArmor >= 1 then
			local armorBarWidth = (HUD["Data"].ExtraArmor / 100) * (boxWidth - 4)

			dxDrawRectangle(armorX, armorY, boxWidth, boxHeight, tocolor(50, 50, 50, 200))
			dxDrawRectangle(armorX + 2, armorY + 2, armorBarWidth, boxHeight - 4, tocolor(237, 178, 17, 255))
			dxDrawText(getText("CHUD8") .. ": " .. math.floor(HUD["Data"].ExtraArmor), armorX + 10, armorY, armorX + boxWidth - 10, armorY + boxHeight, tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "center")
		else
			local armorBarWidth = (HUD["Data"].Armor / 100) * (boxWidth - 4)

			dxDrawRectangle(armorX, armorY, boxWidth, boxHeight, tocolor(50, 50, 50, 200))
			dxDrawRectangle(armorX + 2, armorY + 2, armorBarWidth, boxHeight - 4, tocolor(100, 100, 100, 255))
			dxDrawText(getText("CHUD2") .. ": " .. math.floor(HUD["Data"].Armor), armorX + 10, armorY, armorX + boxWidth - 10, armorY + boxHeight, tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "center")
		end

		local moneyBarWidth = (HUD["Data"].Money / 100000) * (boxWidth - 4)

		if moneyBarWidth > boxWidth - 4 then
			moneyBarWidth = boxWidth - 4
		end

		dxDrawRectangle(moneyX, moneyY, boxWidth, boxHeight, tocolor(50, 50, 50, 200))
		dxDrawRectangle(moneyX + 2, moneyY + 2, moneyBarWidth, boxHeight - 4, tocolor(0, 200, 0, 255))
		dxDrawText(getText("CHUD3") .. ": $" .. math.floor(HUD["Data"].Money), moneyX + 10, moneyY, moneyX + boxWidth - 10, moneyY + boxHeight, tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "center")

		if apocalypseGetElementData(localPlayer, "inSafezone") == true then
			if getElementInterior(localPlayer) == 0 then
				dxDrawRectangle(safeZoneX, safeZoneY, boxWidth, boxHeight, tocolor(30, 100, 30, 200))
				dxDrawText(getText("CHUD4"), safeZoneX + 10, safeZoneY, safeZoneX + boxWidth - 10, safeZoneY + boxHeight, tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "center")
			end
		end

		if apocalypseGetElementData(localPlayer, "Dangerzone") == true then
			if getElementInterior(localPlayer) == 0 then
				dxDrawRectangle(safeZoneX, safeZoneY, boxWidth, boxHeight, tocolor(125, 0, 0, 200))
				dxDrawText(getText("CHUD7"), safeZoneX + 10, safeZoneY, safeZoneX + boxWidth - 10, safeZoneY + boxHeight, tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "center")
			end
		end

		if math.abs(HUD["Data"].Health - getElementHealth(localPlayer)) > 0.1 then
			HUD["Data"].Health = HUD["Data"].Health + (getElementHealth(localPlayer) - HUD["Data"].Health) * animationSpeed
		else
			HUD["Data"].Health = getElementHealth(localPlayer)
		end

		if math.abs(HUD["Data"].Armor - getPedArmor(localPlayer)) > 0.1 then
			HUD["Data"].Armor = HUD["Data"].Armor + (getPedArmor(localPlayer) - HUD["Data"].Armor) * animationSpeed
		else
			HUD["Data"].Armor = getPedArmor(localPlayer)
		end

		local extraArmor = apocalypseGetElementData(localPlayer, "extra_armor") or 0

		if math.abs(HUD["Data"].ExtraArmor - extraArmor) > 0.1 then
			HUD["Data"].ExtraArmor = HUD["Data"].ExtraArmor + (extraArmor - HUD["Data"].ExtraArmor) * animationSpeed
		else
			HUD["Data"].ExtraArmor = extraArmor
		end

		local money = apocalypseGetElementData(localPlayer, "money") or 0

		if math.abs(HUD["Data"].Money - money) > 0.1 then
			HUD["Data"].Money = HUD["Data"].Money + (money - HUD["Data"].Money) * animationSpeed
		else
			HUD["Data"].Money = money
		end

		local hunger = apocalypseGetElementData(localPlayer, "hunger") or 0

		if math.abs(HUD["Data"].Hunger - hunger) > 0.1 then
			HUD["Data"].Hunger = HUD["Data"].Hunger + (hunger - HUD["Data"].Hunger) * animationSpeed
		else
			HUD["Data"].Hunger = hunger
		end

		local thirst = apocalypseGetElementData(localPlayer, "thirst") or 0

		if math.abs(HUD["Data"].Thirst - thirst) > 0.1 then
			HUD["Data"].Thirst = HUD["Data"].Thirst + (thirst - HUD["Data"].Thirst) * animationSpeed
		else
			HUD["Data"].Thirst = thirst
		end

		local thirstBarWidth = ((HUD["Data"].Thirst or 0) + (HUD["Data"].Hunger or 0)) / 200 * (boxWidth - 4)

		dxDrawRectangle(thirstX, thirstY, boxWidth, boxHeight, tocolor(50, 50, 50, 200))
		dxDrawRectangle(thirstX + 2, thirstY + 2, thirstBarWidth, boxHeight - 4, tocolor(0, 191, 255, 255))
		dxDrawText(getText("CHUD5") .. ": " .. math.floor(HUD["Data"].Thirst or 0) .. "% — " .. getText("CHUD6") .. ": " .. math.floor(HUD["Data"].Hunger or 0) .. "%", thirstX + 10, thirstY, thirstX + boxWidth - 10, thirstY + boxHeight, tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "center")

		drawSkillBlock(1, skillRowX, skillRowY)
		drawSkillBlock(2, skillRowX, skillRowY)
		drawSkillBlock(3, skillRowX, skillRowY)
		drawSkillBlock(4, skillRowX, skillRowY)

		local weapon = getPedWeapon(localPlayer)
		local totalAmmo = getPedTotalAmmo(localPlayer)
		local ammoInClip = getPedAmmoInClip(localPlayer)
		local weaponImage = "Files/Images/Weapons/" .. weapon .. ".png"
		local remainingAmmo = totalAmmo - ammoInClip

		if fileExists(weaponImage) then
			dxDrawImage(weaponX + 2, weaponY + 2, weaponBoxWidth - 4, weaponBoxHeight - 4, weaponImage)
			dxDrawText(ammoInClip .. " | " .. remainingAmmo, weaponX + 10, weaponY + weaponBoxHeight + padding, weaponX + weaponBoxWidth - 10, weaponY + weaponBoxHeight + boxHeight, tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "top")
		end

		if apocalypseGetElementData(localPlayer, "inSafezone") == true or apocalypseGetElementData(localPlayer, "Dangerzone") == true and getElementInterior(localPlayer) == 0 then
			dxDrawRectangle(clockX, clockY, clockBoxWidth, clockBoxHeight, tocolor(50, 50, 50, 200))
			dxDrawText(string.format("%02d:%02d", ServerTime.Hour, ServerTime.Minute) .. " - " .. ServerTime.GameDay, clockX + 10, clockY, clockX + clockBoxWidth - 10, clockY + boxHeight, tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "center")
		else
			dxDrawRectangle(safeZoneX, safeZoneY, boxWidth, boxHeight, tocolor(50, 50, 50, 200))
			dxDrawText(string.format("%02d:%02d", ServerTime.Hour, ServerTime.Minute) .. " - " .. ServerTime.GameDay, safeZoneX + 10, safeZoneY, safeZoneX + boxWidth - 10, safeZoneY + boxHeight, tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "center")
		end

		if ProgressBar.open == false then
			if InformationHelpBarOpen == false then
				local icon1Path = "Files/Images/Discord.png"
				local icon2Path = "Files/Images/YouTube.png"
				local icon3Path = "Files/Images/Updates.png"

				dxDrawImage(iconX, iconY, iconSize, iconSize, icon1Path)
				dxDrawImage(iconX + iconSize + iconSpacing, iconY, iconSize, iconSize, icon2Path)
				dxDrawImage(iconX + (iconSize + iconSpacing) * 2, iconY, iconSize, iconSize, icon3Path)

				dxDrawText("San Andreas Apocalypse - BETA - " .. SanAndreasApocalypseVersion, padding, y - boxHeight - padding, x, y, tocolor(255, 255, 255, 200), 1.5, "default-bold", "left", "bottom")
			end
		end
	end
end

addEventHandler("onClientClick", root, function(button, state, cx, cy)
	if button == "left" and state == "up" then
		for idx = 1, 4 do
			local bx = skillRowX + (idx - 1) * (skillBoxSize + skillBoxGap)
			local by = skillRowY

			if cx >= bx and cx <= bx + skillBoxSize and cy >= by and cy <= by + skillBoxSize then
				if hasSkillItem(idx) then
					triggerServerEvent("Potions.clientUsePotion", localPlayer, idx)
				end

				return
			end
		end

		if cx >= iconX and cx <= iconX + iconSize and cy >= iconY and cy <= iconY + iconSize then
			setClipboard("discord.gg/c2UhKGrg")
			createInfobox(getText("CDiscord"))
		end

		if cx >= iconX + iconSize + iconSpacing and cx <= iconX + iconSize * 2 + iconSpacing and cy >= iconY and cy <= iconY + iconSize then
			setClipboard("https://www.youtube.com/@BEMYDRE4MDevelopment")
			createInfobox(getText("CYouTube"))
		end

		if cx >= iconX + (iconSize + iconSpacing) * 2 and cx <= iconX + (iconSize + iconSpacing) * 2 + iconSize and cy >= iconY and cy <= iconY + iconSize then
			openChangelog()
		end
	end
end)

addEvent("HUD.load", true)
addEventHandler("HUD.load", root, function()
	setTimer(function()
		removeEventHandler("onClientRender", root, HUD.render)
		addEventHandler("onClientRender", root, HUD.render)
		triggerServerEvent("loadCompass", localPlayer)
	end, 1000, 1)
end)

addEventHandler("onClientRender", root, function()
	for _, v in pairs(HUDComponents) do
		setPlayerHudComponentVisible(v, false)
	end
end)