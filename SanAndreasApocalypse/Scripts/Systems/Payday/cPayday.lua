Payday = {open = false}

addEvent("Payday.create",true)
addEventHandler("Payday.create",root,function(experience,money)
	Payday.Data = {experience = experience, money = money}
	if(Payday.open == false)then
		addEventHandler("onClientRender",root,Payday.dxDraw)
		Payday.open = true
		bindKey("space","down",Payday.close)
	end
end)

function Payday.close()
	removeEventHandler("onClientRender",root,Payday.dxDraw)
	Payday.open = false
	unbindKey("space","down",Payday.close)
end

function Payday.dxDraw()
	if(isWindowOpen() and Payday.open == true)then
        local screenW, screenH = guiGetScreenSize()

        local windowWidth, windowHeight = 250, 200
        local windowX = 20
        local windowY = (screenH / 2) - (windowHeight / 2)

        dxDrawRectangle(windowX, windowY, windowWidth, windowHeight, tocolor(0, 0, 0, 200), false)

        dxDrawLine(windowX, windowY + 40, windowX + windowWidth, windowY + 40, tocolor(255, 255, 255, 255), 2)

        dxDrawText(getText("CPayday1"), windowX, windowY, windowX + windowWidth, windowY + 40, tocolor(0, 255, 0, 255), 1.2, "default-bold", "center", "center")

        dxDrawText(getText("CPayday2"), windowX + 10, windowY + 50, windowX + windowWidth, windowY + 70, tocolor(255, 255, 255, 255), 1, "default", "left", "top")
        dxDrawText(Payday.Data.experience, windowX, windowY + 50, windowX + windowWidth - 10, windowY + 70, tocolor(255, 255, 255, 255), 1, "default", "right", "top")

        dxDrawText(getText("CPayday3"), windowX + 10, windowY + 80, windowX + windowWidth, windowY + 100, tocolor(255, 255, 255, 255), 1, "default", "left", "top")
        dxDrawText("$"..Payday.Data.money, windowX, windowY + 80, windowX + windowWidth - 10, windowY + 100, tocolor(255, 255, 255, 255), 1, "default", "right", "top")

        dxDrawLine(windowX, windowY + windowHeight - 30, windowX + windowWidth, windowY + windowHeight - 30, tocolor(255, 255, 255, 255), 2)

        dxDrawText(getText("CPayday4"), windowX + 10, windowY + windowHeight - 25, windowX + windowWidth, windowY + windowHeight - 10, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "center")

        dxDrawText(getText("CPayday5"), windowX, windowY + windowHeight, windowX + windowWidth, windowY + windowHeight + 30, tocolor(255, 255, 255, 150), 1, "default", "center", "top")
	end
end