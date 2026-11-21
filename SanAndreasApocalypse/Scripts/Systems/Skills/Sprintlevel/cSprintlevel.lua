local sprintLevel = 0
local totalSprintProgress = 0
local sprintThreshold = 10

local isExhausted = false
local exhaustionDuration = 5
local exhaustionEndTime = 0

local lastUpdateTime = getTickCount() / 1000
local sprintTime = 0
local maxSprintTime = 2

local screenW, screenH = guiGetScreenSize()
local blinkState = false

local lastPos = nil
local distanceTraveled = 0
local distanceTrigger = 50

function updateSprintLevel()
    local currentTime = getTickCount() / 1000
    local dt = currentTime - lastUpdateTime
    lastUpdateTime = currentTime
    
    maxSprintTime = 2 + sprintLevel

    if isExhausted then
        toggleControl("sprint", false)
        if currentTime >= exhaustionEndTime then
            isExhausted = false
            sprintTime = 0
            toggleControl("sprint", true)
        else
            sprintTime = maxSprintTime * ((exhaustionEndTime - currentTime) / exhaustionDuration)
        end
        return
    end

    if not isPedInVehicle(localPlayer) then
        local moving = false
        local vx, vy, vz = getElementVelocity(localPlayer)
        local speed = (vx*vx + vy*vy + vz*vz)^(0.5)

        if speed > 0.05 then
            moving = true
        end

        if getPedControlState("sprint") and moving then
            sprintTime = sprintTime + dt
            totalSprintProgress = totalSprintProgress + dt

            if sprintTime >= maxSprintTime then
                isExhausted = true
                exhaustionEndTime = currentTime + exhaustionDuration
                toggleControl("sprint", false)
                NPC.MeMessage(getText("CSprintlevel1"))
                return
            end

            local currentThreshold = (sprintLevel + 1) * sprintThreshold
            if totalSprintProgress >= currentThreshold then
                sprintLevel = sprintLevel + 1
                totalSprintProgress = 0
                triggerServerEvent("Sprintlevel.save", localPlayer, sprintLevel, totalSprintProgress)
            end
        else
            if sprintTime > 0 then
                sprintTime = math.max(0, sprintTime - dt * 1)
            end
        end
    end

    checkPlayerDistance()
end

function drawSprintHUD()
	if isWindowOpen() and SprintLevelVisible == true and not isPedInVehicle(localPlayer) and not(isPlayerMapVisible()) and DialogSystem.active == false then
		if(tonumber(apocalypseGetElementData(localPlayer,"tutorialtask")) >= 8)then
			if(LaboratoryFights.renderStatus == false)then
				if(InformationHelpBarOpen == false)then
					local currentTime = getTickCount() / 1000
					local barWidth, barHeight = 120, 15
					local x = screenW/2 - barWidth/2
					local y = screenH - 110

					dxDrawRectangle(x-2, y-2, barWidth+4, barHeight+4, tocolor(0, 0, 0, 200))

					local staminaPercent = 1 - (sprintTime / maxSprintTime)

					if isExhausted then
						blinkState = (currentTime % 1) < 0.5
					else
						blinkState = false
					end

					local barColor
					if isExhausted then
						barColor = blinkState and tocolor(255, 0, 0, 220) or tocolor(200, 0, 0, 220)
					else
						barColor = tocolor(50, 200, 50, 220)
					end

					dxDrawRectangle(x, y, barWidth * staminaPercent, barHeight, barColor)

					local currentThreshold = (sprintLevel + 1) * sprintThreshold
					local levelPercent = math.min(totalSprintProgress / currentThreshold, 1)
					local y2 = y + barHeight + 8
					dxDrawRectangle(x-2, y2-2, barWidth+4, barHeight+4, tocolor(0,0,0,200))
					dxDrawRectangle(x, y2, barWidth * levelPercent, barHeight, tocolor(255, 215, 0, 220))
					dxDrawText(getText("CSprintlevel2").." ".. sprintLevel, x, y-30, x+barWidth, y-5, tocolor(255,255,255), 1, "default-bold", "center", "bottom")
					dxDrawText(getText("CSprintlevel3"), x, y, x+barWidth, y+barHeight, tocolor(0,0,0,180), 1, "default-bold", "center", "center")
					dxDrawText(getText("CSprintlevel4"), x, y2, x+barWidth, y2+barHeight, tocolor(0,0,0,180), 1, "default-bold", "center", "center")
				end
			end
		end
	end
end

function checkPlayerDistance()
	if isPedInVehicle(localPlayer) then return end

	local x,y,z = getElementPosition(localPlayer)
	if not lastPos then
		lastPos = {x,y,z}
		return
	end

	local dx = x - lastPos[1]
	local dy = y - lastPos[2]
	local dz = z - lastPos[3]
	local dist = math.sqrt(dx*dx + dy*dy + dz*dz)

	distanceTraveled = distanceTraveled + dist
	lastPos = {x,y,z}

	if distanceTraveled >= distanceTrigger then
		distanceTraveled = 0
		onPlayerRun50Meters()
	end
end

function onPlayerRun50Meters()
	triggerServerEvent("sprintLevelServerFat",localPlayer)
	triggerServerEvent("Sprintlevel.save", localPlayer, sprintLevel, totalSprintProgress)
end

addEvent("Sprintlevel.load", true)
addEventHandler("Sprintlevel.load", root, function(level, level_process)
    sprintLevel = level
    totalSprintProgress = level_process
    addEventHandler("onClientRender", root, function()
        updateSprintLevel()
        drawSprintHUD()
    end)
end)

addEvent("Sprintlevel.quit",true)
addEventHandler("Sprintlevel.quit",root,function()
	triggerServerEvent("Sprintlevel.save", localPlayer, sprintLevel, totalSprintProgress)
end)