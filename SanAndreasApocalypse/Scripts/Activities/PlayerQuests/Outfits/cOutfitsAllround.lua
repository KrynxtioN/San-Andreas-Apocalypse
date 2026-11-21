PlayerOutfits = {}

addEvent("updateClientOutfits",true)
addEventHandler("updateClientOutfits", root, function(outfits)
	PlayerOutfits = outfits
	UpdatePlayerOutfitsForInventory()
end)

local windowVisible = false
local screenWidth, screenHeight = guiGetScreenSize()
local windowWidth, windowHeight = 320, 220
local windowX, windowY = (screenWidth - windowWidth) / 2, (screenHeight - windowHeight) / 2

local buttonWidth, buttonHeight = 120, 30
local buttonX1 = windowX + (windowWidth / 2) - (buttonWidth + 10)
local buttonX2 = windowX + (windowWidth / 2) + 10
local buttonY = windowY + windowHeight - 50

function Outfits.renderQuestWindow()
	dxDrawRectangle(windowX, windowY, windowWidth, windowHeight, tocolor(0, 0, 0, 180))
	dxDrawRectangle(windowX + 5, windowY + 5, windowWidth - 10, windowHeight - 10, tocolor(40, 40, 40, 200))

	dxDrawText(Outfits.title, windowX, windowY + 10, windowX + windowWidth, windowY + 50, tocolor(255, 255, 255, 255), 1.5, "default-bold", "center", "top")

	dxDrawText(Outfits.text, windowX + 10, windowY + 50, windowX + windowWidth - 10, windowY + 100, tocolor(255, 255, 255, 255), 1, "default", "center", "top", false, true)

	dxDrawRectangle(buttonX1, buttonY, buttonWidth, buttonHeight, tocolor(0, 125, 15, 180))
	dxDrawText(getText("COutfits1"), buttonX1, buttonY, buttonX1 + buttonWidth, buttonY + buttonHeight, tocolor(255, 255, 255, 255), 1.2, "default-bold", "center", "center")

	dxDrawRectangle(buttonX2, buttonY, buttonWidth, buttonHeight, tocolor(255, 0, 0, 180))
	dxDrawText(getText("COutfits2"), buttonX2, buttonY, buttonX2 + buttonWidth, buttonY + buttonHeight, tocolor(255, 255, 255, 255), 1.2, "default-bold", "center", "center")
end

local function onClientClick(button, state)
	if(button == "left" and state == "down")then
		if(isMouseInPosition(buttonX1, buttonY, buttonWidth, buttonHeight))then
			if(Outfits.id == 1)then
				triggerServerEvent("Outfits.policeOutfit",localPlayer)
			elseif(Outfits.id == 2)then
				NPC.NormalMessage(getText("COutfits3"))
			elseif(Outfits.id == 3)then
				triggerServerEvent("Outfits.sexOutfit",localPlayer)
			elseif(Outfits.id == 4)then
				triggerServerEvent("Outfits.liamParker",localPlayer)
			elseif(Outfits.id == 5)then
				triggerServerEvent("Outfits.RogerMoore",localPlayer)
			elseif(Outfits.id == 6)then
				NPC.NormalMessage(getText("COutfits4"))
			elseif(Outfits.id == 7)then
				triggerServerEvent("Outfits.JasonBrooks",localPlayer)
			elseif(Outfits.id == 8)then
				triggerServerEvent("Outfits.FirefighterQuest",localPlayer)
			elseif(Outfits.id == 9)then
				triggerServerEvent("Outfits.MedicQuest",localPlayer)
			elseif(Outfits.id == 10)then
				triggerServerEvent("Outfits.fabricfactory",localPlayer)
			elseif(Outfits.id == 11)then
				triggerServerEvent("Outfits.tattoo",localPlayer)
			elseif(Outfits.id == 12)then
				triggerServerEvent("Outfits.barbershops",localPlayer)
			elseif(Outfits.id == 13)then
				triggerServerEvent("Outfits.zombienestQuest",localPlayer)
			elseif(Outfits.id == 14)then
				triggerServerEvent("Outfits.tuningQuest",localPlayer)
			elseif(Outfits.id == 15)then
				triggerServerEvent("RhinoQuest",localPlayer)
			elseif(Outfits.id == 16)then
				triggerServerEvent("MoonflightQuest",localPlayer)
			elseif(Outfits.id == 17)then
				triggerServerEvent("JunkyardQuest",localPlayer)
			elseif(Outfits.id == 18)then
				triggerServerEvent("TreasureHunterQuest",localPlayer)
			elseif(Outfits.id == 19)then
				triggerServerEvent("BearFurQuest",localPlayer)
			elseif(Outfits.id == 20)then
				triggerServerEvent("BigfootQuest",localPlayer)
			elseif(Outfits.id == 21)then
				triggerServerEvent("sweeperQuest",localPlayer)
			elseif(Outfits.id == 22)then
				triggerServerEvent("chainsawQuest",localPlayer)
			elseif(Outfits.id == 24)then
				triggerServerEvent("metalDetectorWoodQuest",localPlayer)
			elseif(Outfits.id == 25)then
				triggerServerEvent("triadSuppliesQuest",localPlayer)
			elseif(Outfits.id == 26)then
				triggerServerEvent("oilDeliveryQuest",localPlayer)
			elseif(Outfits.id == 27)then
				triggerServerEvent("VehicleDismantlingQuest",localPlayer)
			-- Quest 28 is finished in sAlcoholQuest.lua
			elseif(Outfits.id == 29)then
				triggerServerEvent("RedCountyMonster.finishQuest",localPlayer)
			elseif(Outfits.id == 30)then
				triggerServerEvent("InventoryAmmoExpansion.finishQuest",localPlayer)
			elseif(Outfits.id == 31)then
				triggerServerEvent("PirateIslandPostcard.finishQuest",localPlayer)
			end
		elseif(isMouseInPosition(buttonX2, buttonY, buttonWidth, buttonHeight))then
			closeWindow()
			removeEventHandler("onClientRender",root,Outfits.renderQuestWindow)
			removeEventHandler("onClientClick", root, onClientClick)
		end
	end
end

addEvent("Outfits.createQuestWindow",true)
addEventHandler("Outfits.createQuestWindow",root,function(id)
	if(isWindowOpen())then
		setWindowData()
		showCursor(true)
		Outfits.title = Outfits["QuestInfos"][apocalypseGetElementData(localPlayer,"language") or "EN"][id][1]
		Outfits.text = Outfits["QuestInfos"][apocalypseGetElementData(localPlayer,"language") or "EN"][id][2]
		Outfits.id = id
		addEventHandler("onClientRender",root,Outfits.renderQuestWindow)
		addEventHandler("onClientClick", root, onClientClick)
	end
end)

addEvent("Outfits.closeQuestWindow",true)
addEventHandler("Outfits.closeQuestWindow",root,function()
    closeWindow()
	removeEventHandler("onClientRender",root,Outfits.renderQuestWindow)
	removeEventHandler("onClientClick", root, onClientClick)
end)

addEventHandler("onClientPlayerWasted",root,function()
	if(source == localPlayer)then
		closeWindow()
		removeEventHandler("onClientRender",root,Outfits.renderQuestWindow)
		removeEventHandler("onClientClick", root, onClientClick)
	end
end)