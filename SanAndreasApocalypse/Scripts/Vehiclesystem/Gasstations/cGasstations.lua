local screenW, screenH = guiGetScreenSize()

local sliderValue = 0
local sliderX, sliderY = screenW / 2 - 150, screenH / 2 - 50
local sliderWidth, sliderHeight = 300, 20

local dragging = false
local currentFuel = 0
local stationGasoline = 0
local refuelTimePerLiter = 150
local uiOpen = false

local function getMaxSelectable()
	return math.max(0, math.min(100 - currentFuel, stationGasoline, 100))
end

local function drawUIGasstation()
	local selectedLiter = math.floor(sliderValue)
	local seconds = selectedLiter * refuelTimePerLiter / 1000

	dxDrawRectangle(sliderX - 20, sliderY - 115, 340, 215, tocolor(0, 0, 0, 200))

	dxDrawText(getText("CGasstations4"):format(math.floor(currentFuel)), sliderX, sliderY - 100, sliderX + 300, sliderY - 80, tocolor(255,255,255), 1, "default-bold", "center", "center")
	dxDrawText(getText("CGasstations5"):format(math.floor(stationGasoline)), sliderX, sliderY - 75, sliderX + 300, sliderY - 55, tocolor(255,255,255), 1, "default-bold", "center", "center")
	dxDrawText(getText("CGasstations6"):format(string.format("%.1f", seconds)), sliderX, sliderY - 50, sliderX + 300, sliderY - 30, tocolor(255,255,255), 1, "default-bold", "center", "center")

	dxDrawText(getText("CGasstations1"):format(selectedLiter), sliderX, sliderY - 25, sliderX + 300, sliderY - 5, tocolor(255,255,255), 1, "default-bold", "center", "center")

	dxDrawRectangle(sliderX, sliderY, sliderWidth, sliderHeight, tocolor(50, 50, 50, 200))

	local maxSelectable = getMaxSelectable()
	local percent = 0

	if maxSelectable > 0 then
		percent = sliderValue / maxSelectable
	end

	local sliderPos = sliderX + percent * sliderWidth
	dxDrawRectangle(sliderPos - 5, sliderY - 5, 10, sliderHeight + 10, tocolor(0, 150, 255, 200))

	dxDrawRectangle(sliderX, sliderY + 50, 140, 30, tocolor(50, 200, 50, 200))
	dxDrawText(getText("CGasstations2"), sliderX, sliderY + 50, sliderX + 140, sliderY + 80, tocolor(255,255,255), 1, "default-bold", "center", "center")

	dxDrawRectangle(sliderX + 160, sliderY + 50, 140, 30, tocolor(200, 50, 50, 200))
	dxDrawText(getText("CGasstations3"), sliderX + 160, sliderY + 50, sliderX + 300, sliderY + 80, tocolor(255,255,255), 1, "default-bold", "center", "center")
end

local function closeSliderUI()
	if not uiOpen then return end

	removeEventHandler("onClientRender", root, drawUIGasstation)
	removeEventHandler("onClientClick", root, onClickGasstation)
	removeEventHandler("onClientCursorMove", root, onCursorMoveGasstation)

	uiOpen = false
	dragging = false

	closeWindow()
	showCursor(false)
end

function onClickGasstation(button, state, cx, cy)
	if button == "left" and state == "down" then
		if cx >= sliderX and cx <= sliderX + sliderWidth and cy >= sliderY and cy <= sliderY + sliderHeight then
			dragging = true
			return
		end

		if cx >= sliderX and cx <= sliderX + 140 and cy >= sliderY + 50 and cy <= sliderY + 80 then
			triggerServerEvent("Gasstations.server", localPlayer, math.floor(sliderValue))
			closeSliderUI()
			return
		end

		if cx >= sliderX + 160 and cx <= sliderX + 300 and cy >= sliderY + 50 and cy <= sliderY + 80 then
			closeSliderUI()
			return
		end

	elseif button == "left" and state == "up" then
		dragging = false
	end
end

function onCursorMoveGasstation(_, _, cx, cy)
	if not dragging then return end

	local maxSelectable = getMaxSelectable()
	local relativeX = math.max(sliderX, math.min(cx, sliderX + sliderWidth))

	sliderValue = ((relativeX - sliderX) / sliderWidth) * maxSelectable
end

local function openSliderUI(vehicleFuel, gasLeft)
	currentFuel = tonumber(vehicleFuel) or 0
	stationGasoline = tonumber(gasLeft) or 0

	sliderValue = getMaxSelectable()

	if uiOpen then return end

	uiOpen = true

	addEventHandler("onClientRender", root, drawUIGasstation)
	addEventHandler("onClientClick", root, onClickGasstation)
	addEventHandler("onClientCursorMove", root, onCursorMoveGasstation)

	setWindowData()
	showCursor(true)
end

addEvent("Gasstations.createPanel", true)
addEventHandler("Gasstations.createPanel", root, function(vehicleFuel, gasLeft)
	if isWindowOpen() then
		openSliderUI(vehicleFuel, gasLeft)
	end
end)

addEvent("Gasstations.closePanel", true)
addEventHandler("Gasstations.closePanel", root, closeSliderUI)