local levelUpAnimation = {
    show = false,
    y = nil,
    alpha = 255,
    startTime = nil,
    duration = 2000,
    level = 1
}

local rendered = false

local screenX, screenY = guiGetScreenSize()
local boxWidth, boxHeight = 300, 100
local padding = 10

local floatingDisplays = {}
local MAX_FLOATING_DISPLAYS = 5

function showFloatingText(text, r, g, b, zOffset)
    local px, py, pz = getElementPosition(localPlayer)

    if (#floatingDisplays >= MAX_FLOATING_DISPLAYS) then
        table.remove(floatingDisplays, 1)
    end

    table.insert(floatingDisplays, {
        player = localPlayer,
        text = text,
        x = px, y = py, z = pz + (zOffset or 1),
        r = r or 255,
        g = g or 255,
        b = b or 255,
        alpha = 255,
        startTime = getTickCount()
    })
end
addEvent("showFloatingText", true)
addEventHandler("showFloatingText", root, showFloatingText)

addEventHandler("onClientRender", root, function()
    if isCharacterLoggedIn() and isWindowOpen() then
        local yOffset = 0.05 + (#floatingDisplays * 0.005)
        for i = #floatingDisplays, 1, -1 do
            local data = floatingDisplays[i]
            if isElement(data.player) then
                local cx, cy, cz = getElementPosition(data.player)
                local displayZ = data.z + (i - 1) * yOffset
                local sx, sy = getScreenFromWorldPosition(cx, cy, displayZ, 0.06)

                if sx and sy then
                    local timePassed = getTickCount() - data.startTime
                    if timePassed < 2000 then
                        data.alpha = math.max(255 - (timePassed / 2000 * 255), 0)
                        dxDrawText(data.text, sx - 50, sy - 50, sx + 50, sy, tocolor(data.r, data.g, data.b, data.alpha), 1, "default-bold", "center", "center")
                    else
                        table.remove(floatingDisplays, i)
                    end
                end
            else
                table.remove(floatingDisplays, i)
            end
        end
    end
end)

function drawLevelUpNotification()
    if(not(levelUpAnimation.show))then return end

	if(apocalypseGetElementData(localPlayer,"TutorialEndCamera") ~= true)then
		local elapsedTime = getTickCount() - levelUpAnimation.startTime
		local progress = math.min(elapsedTime / levelUpAnimation.duration, 1)

		local animationY = screenY - boxHeight - padding - (boxHeight * progress)

		local alpha = 255 - (255 * progress)

		local backgroundColor = tocolor(220, 25, 25, alpha)
		local textColor = tocolor(255, 255, 255, alpha)

		dxDrawRectangle(screenX / 2 - boxWidth / 2, animationY, boxWidth, boxHeight, backgroundColor)

		dxDrawText(getText("CLevelsystem4"), screenX / 2 - boxWidth / 2 + padding, animationY + padding, screenX / 2 + boxWidth / 2 - padding, animationY + boxHeight / 2, textColor, 2, "default-bold", "center", "center")
		dxDrawText(getText("CLevelsystem3"):format(levelUpAnimation.level), screenX / 2 - boxWidth / 2 + padding, animationY + boxHeight / 2, screenX / 2 + boxWidth / 2 - padding, animationY + boxHeight - padding, textColor, 1.5, "default-bold", "center", "center")

		if(progress == 1)then
			rendered = false
			levelUpAnimation.show = false
			removeEventHandler("onClientRender", root, drawLevelUpNotification)
		end
	end
end

function startLevelUpAnimation(level)
    levelUpAnimation.show = true
    levelUpAnimation.startTime = getTickCount()
    levelUpAnimation.level = level
end

addEvent("onPlayerLevelUp", true)
addEventHandler("onPlayerLevelUp", root, function(level)
	if(rendered == false)then	
		rendered = true
		addEventHandler("onClientRender", root, drawLevelUpNotification)
	end
    startLevelUpAnimation(level)
end)