Gym = {}

function Gym.dxDraw()
    local sx, sy = guiGetScreenSize()
    local w, h = 400, 100
    local x, y = (sx - w) / 2, sy - 180

    dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 180), true)

    dxDrawText(getText("CGym1"),
        x + 10, y + 10, x + w - 10, y + 40, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, true, true)

    local muscles = apocalypseGetElementData(localPlayer,"player_muscles") or 0
    local fat     = apocalypseGetElementData(localPlayer,"player_fat") or 0
    local maxVal  = 1000

    local barY = y + 60
    dxDrawRectangle(x + 20, barY, w - 40, 20, tocolor(50, 50, 50, 200), true)

    if fat > 0 then
        local progress = (fat / maxVal) * (w - 40)
        dxDrawText(getText("CGym2"):format(fat,maxVal), x + 20, barY, x + w - 20, barY + 20,
		tocolor(255,255,255,255), 1, "default-bold", "center", "center",_,_,true)
        dxDrawRectangle(x + 20, barY, progress, 20, tocolor(200, 50, 50, 220), true)
    else
        local progress = (muscles / maxVal) * (w - 40)
        dxDrawText(getText("CGym3"):format(muscles,maxVal), x + 20, barY, x + w - 20, barY + 20,
        tocolor(255,255,255,255), 1, "default-bold", "center", "center",_,_,true)
        dxDrawRectangle(x + 20, barY, progress, 20, tocolor(50, 200, 50, 220), true)
    end
end

addEvent("Gym.dxDraw",true)
addEventHandler("Gym.dxDraw",root,function(type)
	if(type == "create")then
		SprintLevelVisible = false
		addEventHandler("onClientRender",root,Gym.dxDraw)
	else
		SprintLevelVisible = true
		removeEventHandler("onClientRender",root,Gym.dxDraw)
	end
end)

addEventHandler("onClientPlayerWasted",root,function()
	if(source == localPlayer)then
		SprintLevelVisible = true
		removeEventHandler("onClientRender",root,Gym.dxDraw)
	end
end)