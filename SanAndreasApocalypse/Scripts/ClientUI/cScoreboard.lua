Scoreboard = {Open = false,
	["Categories"] = {
		["EN"] = {"Name", "Zombie Kills", "Playtime", "Level", "Rank", "Ping"},
		["DE"] = {"Name", "Zombie Kills", "Spielzeit", "Level", "Rang", "Ping"},
		["RU"] = {"Имя", "Убийства зомби", "Время в игре", "Уровень", "Ранг", "Пинг"},
		["PT"] = {"Nome", "Zumbis mortos", "Tempo de jogo", "Nível", "Patente", "Ping"},
	},
}

local scoreboardWidth, scoreboardHeight = 600, 360
local headerHeight, itemHeight = 60, 30
local maxVisibleItems = 9
local scrollOffset = 0

local scoreboardData = {}
local headerImage = "Files/Images/Header.png"

local screenWidth, screenHeight = guiGetScreenSize()

function formatMinutes(minutes)
	local hours = math.floor(minutes / 60)
	local remainingMinutes = minutes % 60
	
	return string.format("%d:%02d", hours, remainingMinutes)
end

function Scoreboard.updateData()
	scoreboardData = {}
	local language = apocalypseGetElementData(localPlayer,"language")
	
	for _, v in pairs(getElementsByType("player"))do
		if(isCharacterLoggedIn(v))then
			table.insert(scoreboardData, {
				name = apocalypseGetElementData(v,"CharacterName") or getPlayerName(v),
				zombiekills = apocalypseGetElementData(v,"zombiekills") or 0,
				playtime = formatMinutes(apocalypseGetElementData(v, "playtime") or 0),
				level = apocalypseGetElementData(v, "level") or 0,
				rank = apocalypseGetElementData(v, "rankname") or "/",
				ping = getPlayerPing(v),
				status = tostring(apocalypseGetElementData(v,"statusName")) or "/",
				crew = apocalypseGetElementData(v,"ColonyName") or "/",
				adminlevel = apocalypseGetElementData(v,"adminlevel") or 0,
				teamrank = Adminsystem["Ranknames"][apocalypseGetElementData(v,"language") or "EN"][apocalypseGetElementData(v,"adminlevel")] or "/"
			})
		end
	end
end

function Scoreboard.draw()
	local scoreboardX = (screenWidth - scoreboardWidth) / 2
    local scoreboardY = (screenHeight - scoreboardHeight) / 2
    dxDrawRectangle(scoreboardX, scoreboardY, scoreboardWidth, scoreboardHeight, tocolor(0, 0, 0, 180))
	
	dxDrawImage(scoreboardX, scoreboardY, scoreboardWidth, headerHeight, headerImage)
	
    local startX = scoreboardX
    local columnWidth = scoreboardWidth / 6
    local columnNames = Scoreboard["Categories"][apocalypseGetElementData(localPlayer,"language") or "EN"]
	
	for i, v in ipairs(columnNames)do
		dxDrawText(v, startX + (i-1) * columnWidth, scoreboardY + headerHeight, startX + i * columnWidth, scoreboardY + headerHeight + itemHeight, tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "center")
	end
	
	for i = 1, math.min(maxVisibleItems, #scoreboardData) do
        local itemY = scoreboardY + headerHeight + itemHeight + (i - 1) * itemHeight
        
        if(i + scrollOffset <= #scoreboardData)then
            local playerData = scoreboardData[i + scrollOffset]
			
            dxDrawRectangle(startX, itemY, scoreboardWidth, itemHeight, tocolor(50, 50, 50, 180))
			
			local r,g,b = 255, 255, 255
			if(playerData.adminlevel >= 1)then
				r,g,b = 200, 10, 0
			end
			
            dxDrawText(playerData.name, startX, itemY, startX + columnWidth, itemY + itemHeight, tocolor(r,g,b, 255), 1.0, "default", "center", "center", _, _, true)
            dxDrawText(tostring(playerData.zombiekills), startX + columnWidth, itemY, startX + 2 * columnWidth, itemY + itemHeight, tocolor(255, 255, 255, 255), 1.0, "default", "center", "center", _, _, true)
            dxDrawText(tostring(playerData.playtime), startX + 2 * columnWidth, itemY, startX + 3 * columnWidth, itemY + itemHeight, tocolor(255, 255, 255, 255), 1.0, "default", "center", "center", _, _, true)
            dxDrawText(tostring(playerData.level), startX + 3 * columnWidth, itemY, startX + 4 * columnWidth, itemY + itemHeight, tocolor(255, 255, 255, 255), 1.0, "default", "center", "center", _, _, true)
            dxDrawText(playerData.rank, startX + 4 * columnWidth, itemY, startX + 5 * columnWidth, itemY + itemHeight, tocolor(255, 255, 255, 255), 1.0, "default", "center", "center", _, _, true)
            dxDrawText(tostring(playerData.ping), startX + 5 * columnWidth, itemY, startX + 6 * columnWidth, itemY + itemHeight, tocolor(255, 255, 255, 255), 1.0, "default", "center", "center", _, _, true)
			
			if(isMouseInPosition(startX, itemY, scoreboardWidth, itemHeight))then
				local boxWidth, boxHeight = 200, 100
				local boxX, boxY = startX - boxWidth - 10, itemY
				
				local backgroundColor = isHovered and tocolor(100, 100, 100, 180) or tocolor(0, 0, 0, 175)
				dxDrawRectangle(startX, itemY, scoreboardWidth, itemHeight, backgroundColor)
				
				dxDrawRectangle(boxX, boxY, boxWidth, boxHeight, tocolor(30, 30, 30, 200))

				dxDrawRectangle(boxX, boxY, boxWidth, 30, tocolor(50, 50, 50, 255))
				dxDrawText(playerData.name, boxX + 10, boxY, boxX + boxWidth - 10, boxY + 30, tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "center")

				dxDrawText(getText("CScoreboard1").." "..playerData.status, boxX + 10, boxY + 40, boxX + boxWidth - 10, boxY + 60, tocolor(255, 255, 255, 255), 1.0, "default", "left", "top")
                dxDrawText(getText("CScoreboard2").." " .. playerData.crew, boxX + 10, boxY + 60, boxX + boxWidth - 10, boxY + 80, tocolor(255, 255, 255, 255), 1.0, "default", "left", "top")
                dxDrawText(getText("CScoreboard3").." " .. playerData.teamrank, boxX + 10, boxY + 80, boxX + boxWidth - 10, boxY + 100, tocolor(255, 255, 255, 255), 1.0, "default", "left", "top")
			end
        end
    end
end

function Scoreboard.scroll(direction)
	if(#scoreboardData > maxVisibleItems)then
		scrollOffset = scrollOffset + direction
		if(scrollOffset < 0)then scrollOffset = 0 end
		if(scrollOffset > #scoreboardData - maxVisibleItems)then
			scrollOffset = #scoreboardData - maxVisibleItems
		end
	end
end

function Scoreboard.scrollKey(button, press)
	if(press)then
		if(button == "mouse_wheel_up")then
			Scoreboard.scroll(-1)
		elseif(button == "mouse_wheel_down")then
			Scoreboard.scroll(1)
		end
	end
end

bindKey("tab", "up", function()
	if(Scoreboard.Open == true)then
		Scoreboard.Open = false
		removeEventHandler("onClientRender", root, Scoreboard.draw)
		removeEventHandler("onClientKey", root, Scoreboard.scroll)
		closeWindow("no")
	end
end)

bindKey("tab", "down", function()
	if(isCharacterLoggedIn() and isWindowOpen() and not(isPlayerMapVisible()))then
		Scoreboard.Open = true
		setWindowData("no")
		showCursor(true, false)
		Scoreboard.updateData()
		addEventHandler("onClientRender", root, Scoreboard.draw)
		addEventHandler("onClientKey", root, Scoreboard.scroll)
		triggerServerEvent("setAchievement", localPlayer, localPlayer, 37)
	end
end)

addEventHandler("onClientPlayerWasted", root, function(player)
	if(player == localPlayer)then
		removeEventHandler("onClientRender", root, Scoreboard.draw)
		removeEventHandler("onClientKey", root, Scoreboard.scroll)
		closeWindow()
	end
end)