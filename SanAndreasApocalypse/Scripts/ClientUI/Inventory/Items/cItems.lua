PlayerItems = {}
local x,y = guiGetScreenSize()

addEvent("updatePlayerItems",true)
addEventHandler("updatePlayerItems", root, function(items)
	PlayerItems = items
	UpdatePlayerItemsForInventory()
end)

function hasPlayerItem(itemID)
	if(isCharacterLoggedIn())then
		local amount = 0
		if(PlayerItems)then
			for i, v in ipairs(PlayerItems) do
				if(v.item == itemID)then
					amount = v.amount
					break
				end
			end
		end
		return amount
	end
end

function useDivingSuit()
	if(apocalypseGetElementData(localPlayer,"DivingSuitUse") == true)then
		apocalypseSetElementData(localPlayer,"DivingSuitUse",false)
		removeEventHandler("onClientRender",root,DivingSuitOxygenLevel)
		if(isTimer(DivingSuitTimer))then killTimer(DivingSuitTimer)end
	else
		apocalypseSetElementData(localPlayer,"DivingSuitUse",true)
		addEventHandler("onClientRender",root,DivingSuitOxygenLevel)
		
		DivingSuitTimer = setTimer(function()
			triggerServerEvent("checkDivingOxygen",localPlayer)
		end,3000,0)
	end
end
addEvent("useDivingSuit",true)
addEventHandler("useDivingSuit",root,useDivingSuit)

function DivingSuitOxygenLevel()
    local BottleOxygen = apocalypseGetElementData(localPlayer, "BottleOxygen") or 0
	BottleOxygen = math.max(0, math.min(1000, BottleOxygen))
    local fillHeight = 187 * (BottleOxygen / 1000)
    local fillY = 840 + (187 - fillHeight)
	dxDrawImage(0, 0, x, y, "Files/Images/DivingGoggles.png")
    dxDrawImage(1655, 788, 226, 256, "Files/Images/OxygenBottle.png", 0, 0, 0, tocolor(255,255,255,255))
    dxDrawRectangle(1733, fillY, 57, fillHeight, tocolor(10,244,241,255), false)
    local oxygenPercent = math.floor((BottleOxygen / 1000) * 100)
    dxDrawText(oxygenPercent .. "%", 1733, 840, 1790, 1027, tocolor(255,255,255,255), 1.20, "default-bold", "center", "center", false, false, false, false, false)
end

-- // Treasure Maps
local renderTreasureMapID = 0
local function renderTreasureMapFromInventory()
	if(renderTreasureMapID ~= 0)then
		local screenW, screenH = guiGetScreenSize()

		local size = 500
		local x = (screenW - size) / 2
		local y = (screenH - size) / 2

		dxDrawImage(x, y, size, size, "Files/Images/TreasureMap/TreasureMap"..renderTreasureMapID..".png",_,_,_,_,true)
		dxDrawText(getText("CTreasureMap1"), 0, y + size + 10, screenW, y + size + 40, tocolor(255,255,255,255), 1, "default-bold", "center", "top")
	end
end

local function closeRenderTreasureClose()
	unbindKey("space","down",closeRenderTreasureClose)
	removeEventHandler("onClientRender",root,renderTreasureMapFromInventory)
	renderTreasureMapID = 0
	Inventory.close()
end

addEvent("startRenderTreasureMapFromInventory",true)
addEventHandler("startRenderTreasureMapFromInventory",root,function(ID)
	if(renderTreasureMapID == 0)then
		closeInventory()
		renderTreasureMapID = tonumber(ID)
		addEventHandler("onClientRender",root,renderTreasureMapFromInventory)
		bindKey("space","down",closeRenderTreasureClose)
	end
end)

addEventHandler("onClientPlayerWasted",root,function()
	if(source == localPlayer)then
		if(apocalypseGetElementData(localPlayer,"DivingSuitUse") == true)then
			apocalypseSetElementData(localPlayer,"DivingSuitUse",false)
			removeEventHandler("onClientRender",root,DivingSuitOxygenLevel)
			if(isTimer(DivingSuitTimer))then killTimer(DivingSuitTimer)end
			unbindKey("space","down",closeRenderTreasureClose)
			removeEventHandler("onClientRender",root,renderTreasureMapFromInventory)
			renderTreasureMapID = 0
		end
	end
end)