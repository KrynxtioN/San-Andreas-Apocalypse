LaboratoryFights = {}
LaboratoryFights.renderStatus = false

local leftTeamName = "Red"
local rightTeamName = "Blue"
local teamPoints = 0
local maxPoints = 700
local fadeDuration = 1500
local startTick = 0

local phase = "fight"
local phaseEndTick = 0

local leftTeamColor = {255, 120, 120}
local rightTeamColor = {120, 120, 255}

local screenW, screenH = guiGetScreenSize()

function LaboratoryFights.GUI(ID)
	if(isWindowOpen())then
		local Area_ID = ID
		GUIEditor.window[1] = guiCreateWindow(650, 350, 222, 135, getText("CLaboratoryFights1"), false)
		setWindowData()
		guiCreateCloseButton()

		GUIEditor.label[1] = guiCreateLabel(10, 32, 202, 56, getText("CLaboratoryFights2"), false, GUIEditor.window[1])
		guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", true)
		guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
		GUIEditor.button[1] = guiCreateButton(10, 98, 202, 27, getText("CLaboratoryFights3"), false, GUIEditor.window[1])

		addEventHandler("onClientGUIClick", GUIEditor.button[1], function()
			triggerServerEvent("LaboratoryFights.begin", localPlayer, Area_ID)
		end, false)
	end
end
addEvent("LaboratoryFights.GUI", true)
addEventHandler("LaboratoryFights.GUI", root, LaboratoryFights.GUI)

function LaboratoryFights.renderUI()
	if(isWindowOpen() and not(isPedDead(localPlayer)))then
		if(not(isPlayerMapVisible()))then
			local now = getTickCount()
			local elapsed = now - startTick
			local fadeProgress = math.min(elapsed / fadeDuration, 1)
			local globalAlpha = math.floor(255 * fadeProgress)

			local centerX = screenW / 2
			local overlayWidth = 600
			local overlayX = centerX - overlayWidth / 2
			local overlayY = screenH - 220
			local overlayHeight = 200

			dxDrawRectangle(overlayX, overlayY, overlayWidth, overlayHeight, tocolor(0, 0, 0, 80), false)

			local boxWidth = 200
			local boxHeight = 50
			local spacing = 20
			local leftBoxX = centerX - boxWidth - spacing/2
			local rightBoxX = centerX + spacing/2
			local boxY = overlayY + 20

			dxDrawRectangle(leftBoxX, boxY, boxWidth, boxHeight, tocolor(30, 30, 30, globalAlpha), false)
			dxDrawText(
				leftTeamName,
				leftBoxX, boxY, leftBoxX + boxWidth, boxY + boxHeight,
				tocolor(leftTeamColor[1], leftTeamColor[2], leftTeamColor[3], globalAlpha),
				1.5, "default-bold", "center", "center", false, false
			)

			dxDrawRectangle(rightBoxX, boxY, boxWidth, boxHeight, tocolor(30, 30, 30, globalAlpha), false)
			dxDrawText(
				rightTeamName,
				rightBoxX, boxY, rightBoxX + boxWidth, boxY + boxHeight,
				tocolor(rightTeamColor[1], rightTeamColor[2], rightTeamColor[3], globalAlpha),
				1.5, "default-bold", "center", "center", false, false
			)

			local vsY = boxY - 40
			local vsScale = 2.5 + 0.3 * math.sin(now / 200)
			dxDrawText("VS", centerX - 50, vsY, centerX + 50, vsY + 60, tocolor(255, 255, 255, globalAlpha), vsScale, "default-bold", "center", "center", false, false)

			local barWidth = 250
			local barHeight = 30
			local barX = centerX - barWidth / 2
			local barY = overlayY + boxHeight + 40

			dxDrawRectangle(barX, barY, barWidth, barHeight, tocolor(50, 50, 50, globalAlpha), false)

			dxDrawRectangle(barX, barY, barWidth, 3, tocolor(0, 0, 0, globalAlpha), false)
			dxDrawRectangle(barX, barY + barHeight - 3, barWidth, 3, tocolor(0, 0, 0, globalAlpha), false)
			dxDrawRectangle(barX, barY, 3, barHeight, tocolor(0, 0, 0, globalAlpha), false)
			dxDrawRectangle(barX + barWidth - 3, barY, 3, barHeight, tocolor(0, 0, 0, globalAlpha), false)

			local progressFill = math.min(teamPoints / maxPoints, 1)
			local fillWidth = barWidth * progressFill
			dxDrawRectangle(barX, barY, fillWidth, barHeight, tocolor(leftTeamColor[1], leftTeamColor[2], leftTeamColor[3], globalAlpha), false)

			dxDrawText(getText("CLaboratoryFights4")..": " .. teamPoints .. " / " .. maxPoints, barX, barY - 40, barX + barWidth, barY - 10,
				tocolor(255, 255, 255, globalAlpha), 1.3, "default-bold", "center", "center", false, false
			)

			local remaining = math.max(0, phaseEndTick - now)
			local timeText = ""

			if phase == "prep" then
				timeText = getText("CLaboratoryFights5")..": " .. math.ceil(remaining / 1000) .. "s"
			else
				local m = math.floor(remaining / 60000)
				local s = math.floor((remaining % 60000) / 1000)
				timeText = string.format(getText("CLaboratoryFights6")..": %02d:%02d", m, s)
			end

			dxDrawText(timeText, barX, barY + barHeight + 8, barX + barWidth, barY + barHeight + 38,
				tocolor(255, 255, 255, globalAlpha), 1.2, "default-bold", "center", "top", false, false
			)
		end
	end
end

function LaboratoryFights.start(points, attackerName, defenderName, newPhase, remainingMs, ar, ag, ab, dr, dg, db)
	startTick = getTickCount()
	teamPoints = points
	leftTeamName = attackerName
	rightTeamName = defenderName

	leftTeamColor = {ar or 255, ag or 120, ab or 120}
	rightTeamColor = {dr or 120, dg or 120, db or 255}

	phase = newPhase or "fight"
	phaseEndTick = getTickCount() + (remainingMs or 0)

	if not LaboratoryFights.renderStatus then
		addEventHandler("onClientRender", root, LaboratoryFights.renderUI)
	end
	LaboratoryFights.renderStatus = true
end
addEvent("LaboratoryFights.start", true)
addEventHandler("LaboratoryFights.start", root, LaboratoryFights.start)

function LaboratoryFights.stop()
	if LaboratoryFights.renderStatus then
		removeEventHandler("onClientRender", root, LaboratoryFights.renderUI)
	end
	LaboratoryFights.renderStatus = false
end
addEvent("LaboratoryFights.stop", true)
addEventHandler("LaboratoryFights.stop", root, LaboratoryFights.stop)

addEvent("LaboratoryFights.updatePoints", true)
addEventHandler("LaboratoryFights.updatePoints", root, function(points)
	teamPoints = points
end)