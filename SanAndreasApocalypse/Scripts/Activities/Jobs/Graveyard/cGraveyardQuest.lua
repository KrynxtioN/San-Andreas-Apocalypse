local screenWidth, screenHeight = guiGetScreenSize()
GraveyardQuest = {}
apocalypseSetElementData(localPlayer,"GraveyardBindKey",false)
apocalypseSetElementData(localPlayer,"ClaimFlowerEXPBindkey",false)

addEventHandler("onClientRender",root,function()
	if(isCharacterLoggedIn() and isWindowOpen())then
		local x1,y1,z1 = 823.591796875,-1097.3814697266,25.7890625
		local screenX1,screenY1 = getScreenFromWorldPosition(x1,y1,z1)
		
		if(screenX1 and screenY1)then
			if(getDistanceBetweenPoints3D(x1,y1,z1,getElementPosition(localPlayer)) <= 5)then
				dxDrawText(getText("CGraveyardQuest1"), screenX1 - 100, screenY1 - 20, screenX1 + 100, screenY1 + 20, tocolor(255, 255, 255), 1.2, "default-bold", "center", "center")
			end
		end
	end
end)

addEvent("GraveyardQuest.showDocumentInfo",true)
addEventHandler("GraveyardQuest.showDocumentInfo",root,function()
	addEventHandler("onClientRender",root,GraveyardQuest.render)
	bindKey("space","down",GraveyardQuest.closeDocument)
end)

function GraveyardQuest.closeDocument()
	removeEventHandler("onClientRender",root,GraveyardQuest.render)
	unbindKey("space","down",GraveyardQuest.closeDocument)
end

function GraveyardQuest.render()
	local doc_imageW, doc_imageH = 512, 768
	local doc_x = (screenWidth - doc_imageW) / 2
	local doc_y = (screenHeight - doc_imageH) / 2
	local padding = 40
	local textX = doc_x + padding
	local textY = doc_y + padding
	local textW = doc_imageW - padding * 2
	local textH = doc_imageH - padding * 2

	dxDrawImage(doc_x, doc_y, doc_imageW, doc_imageH, "Files/Images/DocumentPaper.png")

	dxDrawText(getText("CGraveyardDocument1"), textX, textY, textX + textW, textY + textH, tocolor(255, 255, 255, 255), 1.2, "default-bold", "left", "top", true, true, false)
end