ItemForItem = {}

local screenWidth, screenHeight = guiGetScreenSize()
local windowWidth, windowHeight = 250, 150

local windowX, windowY = (screenWidth - windowWidth) / 2, (screenHeight - windowHeight) / 2

local buttonWidth, buttonHeight = 90, 30
local buttonY = windowY + windowHeight - 45
local buttonX1 = windowX + 15
local buttonX2 = windowX + windowWidth - buttonWidth - 15

function ItemForItem.dxDraw()
    dxDrawRectangle(windowX, windowY, windowWidth, windowHeight, tocolor(0, 0, 0, 180))
    dxDrawRectangle(windowX + 5, windowY + 5, windowWidth - 10, windowHeight - 10, tocolor(40, 40, 40, 200))
    
    dxDrawText(getText("CTrading1"):format(ItemInfos["items"][apocalypseGetElementData(localPlayer,"language") or "EN"][ItemForItem.costItem],ItemForItem.costItem_amount,ItemInfos["items"][apocalypseGetElementData(localPlayer,"language") or "EN"][ItemForItem.rewardItem],ItemForItem.rewardItem_amount), windowX + 10, windowY + 45, windowX + windowWidth - 10, windowY + windowHeight - 60, tocolor(255, 255, 255, 255), 1, "default", "center", "top", false, true)

    dxDrawRectangle(buttonX1, buttonY, buttonWidth, buttonHeight, tocolor(0, 125, 15, 180))
    dxDrawText(getText("CTrading2"), buttonX1, buttonY, buttonX1 + buttonWidth, buttonY + buttonHeight, tocolor(255, 255, 255, 255), 1.1, "default-bold", "center", "center")
  
    dxDrawRectangle(buttonX2, buttonY, buttonWidth, buttonHeight, tocolor(255, 0, 0, 180))
    dxDrawText(getText("CTrading3"), buttonX2, buttonY, buttonX2 + buttonWidth, buttonY + buttonHeight, tocolor(255, 255, 255, 255), 1.1, "default-bold", "center", "center")
end

function ItemForItem.handleButtonClick(button, state, x, y)
    if(button == "left" and state == "up")then
        if(x >= buttonX1 and x <= buttonX1 + buttonWidth and y >= buttonY and y <= buttonY + buttonHeight)then
            triggerServerEvent("ItemForItem.tradeServer",localPlayer,ItemForItem.costItem,ItemForItem.costItem_amount,ItemForItem.rewardItem,ItemForItem.rewardItem_amount)
        end
        if(x >= buttonX2 and x <= buttonX2 + buttonWidth and y >= buttonY and y <= buttonY + buttonHeight)then
            ItemForItem.closeWindow()
        end
    end
end

function ItemForItem.createWindow(costItem,costItem_amount,rewardItem,rewardItem_amount)
	if(isWindowOpen())then
		if(rewardItem and costItem)then
			showCursor(true)
			ItemForItem.rewardItem = rewardItem
			ItemForItem.rewardItem_amount = rewardItem_amount
			ItemForItem.costItem = costItem
			ItemForItem.costItem_amount = costItem_amount
			addEventHandler("onClientClick",root,ItemForItem.handleButtonClick)
			addEventHandler("onClientRender",root,ItemForItem.dxDraw)
			setWindowData()
		end
	end
end
addEvent("ItemForItem.createWindow",true)
addEventHandler("ItemForItem.createWindow",root,ItemForItem.createWindow)

function ItemForItem.closeWindow()
	removeEventHandler("onClientClick",root,ItemForItem.handleButtonClick)
	removeEventHandler("onClientRender",root,ItemForItem.dxDraw)
	closeWindow()
end
addEvent("ItemForItem.closeWindow",true)
addEventHandler("ItemForItem.closeWindow",root,ItemForItem.closeWindow)