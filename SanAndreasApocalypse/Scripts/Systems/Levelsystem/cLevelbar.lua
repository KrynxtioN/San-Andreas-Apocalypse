local x,y = guiGetScreenSize()
Levelsystem = {Scroll = 0, LevelUpRender = false, Visible = true}

function Levelsystem.Display()
    if(isCharacterLoggedIn() and Infobox.Active == false and not isPedDead(localPlayer) and Levelsystem.Visible == true and not isPlayerMapVisible())then
        local Level = apocalypseGetElementData(localPlayer, "level")
        local ExperiencePoints = apocalypseGetElementData(localPlayer, "experiencepoints")
        local NeededExperiencePoints = 250 * (Level + 1) + ((Level + 1) * 25)
        local Progress = ExperiencePoints / NeededExperiencePoints * 100

        local screenWidth, screenHeight = guiGetScreenSize()
        local scale = math.min(screenWidth / 1920, screenHeight / 1080)

        local barX, barY = math.floor(779 * scale), math.floor(10 * scale)
        local barWidth, barHeight = math.floor(361 * scale), math.floor(27 * scale)
        local progressWidth = math.floor(barWidth / 100 * Progress)

        dxDrawRectangle(barX, barY, barWidth, barHeight, tocolor(0, 0, 0, 200), false)
        dxDrawRectangle(barX, barY, progressWidth, barHeight, tocolor(0, 255, 0, 200), false)

        dxDrawLine(barX, barY, barX + barWidth, barY - 1, tocolor(220, 0, 0, 255), 2, false)
        dxDrawLine(barX, barY + barHeight, barX + barWidth, barY + barHeight - 1, tocolor(220, 0, 0, 255), 2, false)
        dxDrawLine(barX, barY - 1, barX - 1, barY + barHeight, tocolor(220, 0, 0, 255), 2, false)
        dxDrawLine(barX + barWidth, barY - 1, barX + barWidth, barY + barHeight, tocolor(220, 0, 0, 255), 2, false)

        local expText = ExperiencePoints .. "/" .. NeededExperiencePoints .. " EXP (" .. math.floor(Progress) .. "%)"
        dxDrawText(
            expText,
            barX,
            barY,
            barX + barWidth,
            barY + barHeight,
            tocolor(255, 255, 255, 255),
            1.00 * scale,
            "default",
            "center",
            "center",
            false,
            false,
            false
        )

        local levelText = getText("CLevelsystem1") .. ": " .. Level .. " • " .. getText("CLevelsystem2") .. ": " .. apocalypseGetElementData(localPlayer, "rankname")
        dxDrawText(
            levelText,
            barX,
            barY + barHeight,
            barX + barWidth,
            barY + barHeight + math.floor(24 * scale),
            tocolor(255, 255, 255, 255),
            1.20 * scale,
            "default",
            "center",
            "center",
            false,
            false,
            false
        )
    end
end

addEvent("Levelsystem.load",true)
addEventHandler("Levelsystem.load",root,function()
	setTimer(function()
		addEventHandler("onClientRender",root,Levelsystem.Display)
	end,2000,1)
end)