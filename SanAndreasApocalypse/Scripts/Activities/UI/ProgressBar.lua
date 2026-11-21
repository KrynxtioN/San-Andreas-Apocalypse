ProgressBar = {
	startTime = 0,
	duration = 10,
	progress = 0,
	open = false
}

local screenWidth, screenHeight = guiGetScreenSize()

function createProgressBar(time)
	if not time then return end
	if ProgressBar.open then return end

	ProgressBar.open = true
	ProgressBar.startTime = getTickCount()
	ProgressBar.duration = time * 1000
	ProgressBar.progress = 0

	addEventHandler("onClientRender", root, ProgressBar.dxDraw)
end
addEvent("createProgressBar", true)
addEventHandler("createProgressBar", root, createProgressBar)

function ProgressBar.dxDraw()
	if not ProgressBar.open then return end

	if ProgressBar.duration <= 0 then
		ProgressBar.close()
		return
	end

	local elapsedTime = getTickCount() - ProgressBar.startTime
	ProgressBar.progress = elapsedTime / ProgressBar.duration

	if ProgressBar.progress >= 1 then
		ProgressBar.progress = 1
		ProgressBar.close()
	end

	local barWidth = screenWidth * 0.8
	local barHeight = 5
	local x = (screenWidth - barWidth) / 2
	local y = screenHeight - barHeight - 10

	dxDrawRectangle(x, y, barWidth, barHeight, tocolor(50, 50, 50, 255))
	dxDrawRectangle(x, y, barWidth * ProgressBar.progress, barHeight, tocolor(0, 255, 0, 255))
end

function ProgressBar.close()
	if ProgressBar.open then
		removeEventHandler("onClientRender", root, ProgressBar.dxDraw)
		ProgressBar.open = false
	end
end
addEvent("ProgressBar.close", true)
addEventHandler("ProgressBar.close", root, ProgressBar.close)

addEventHandler("onClientPlayerWasted", root, function()
	if source == localPlayer then
		ProgressBar.close()
	end
end)