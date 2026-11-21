AFK = {}

local fadeAlpha = 0
local fadingIn = true
local AFKRendered = false

apocalypseSetElementData(localPlayer,"AFK",false)

function AFK.render()
	if(isWindowOpen())then
		local screenWidth, screenHeight = guiGetScreenSize()
		local AFKCode = apocalypseGetElementData(localPlayer,"AFKCode")

		dxDrawRectangle(0, 0, screenWidth, screenHeight, tocolor(0, 0, 0, 200))
		local text = getText("SAFK2"):format(apocalypseGetElementData(localPlayer,"AFKCode"))
		local font = "default-bold"
		local textWidth = dxGetTextWidth(text, 1, font)
		local textHeight = dxGetFontHeight(1, font)

		dxDrawText(text, (screenWidth - textWidth) / 2, (screenHeight - textHeight) / 2, (screenWidth + textWidth) / 2, (screenHeight + textHeight) / 2, tocolor(255, 255, 255, fadeAlpha), 2, font, "center", "center")
		 
		if(fadingIn)then
			fadeAlpha = fadeAlpha + 5
			if(fadeAlpha >= 255)then
				fadeAlpha = 255
				fadingIn = false
			end
		else
			fadeAlpha = fadeAlpha - 5
			if(fadeAlpha <= 0)then
				fadeAlpha = 0
				fadingIn = true
			end
		end
	end
end

addEvent("AFK.render",true)
addEventHandler("AFK.render",root,function()
	if(AFKRendered == false)then
		AFKRendered = true
		addEventHandler("onClientRender",root,AFK.render)
	else
		AFKRendered = false
		removeEventHandler("onClientRender",root,AFK.render)
	end
end)