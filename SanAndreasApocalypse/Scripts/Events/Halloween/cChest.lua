local screenW, screenH = guiGetScreenSize()

HalloweenChestsUI = {
    chests = {
		["EN"] = {
			{id=1, name="Chest 1", items={"25.000 Experience Points", "1000 Pumpkins", "100 Halloween Candy", "$5000"}},
			{id=2, name="Chest 2", items={"50.000 Experience Points", "2500 Pumpkins", "250 Halloween Candy", "$10000"}},
			{id=3, name="Chest 3", items={"75.000 Experience Points", "5000 Pumpkins", "500 Halloween Candy", "$20000", "Skeleton Outfit"}},
		},
		["DE"] = {
			{id=1, name="Truhe 1", items={"25.000 Erfahrungspunkte", "1000 Kürbisse", "100 Halloween-Süßigkeiten", "$5000"}},
			{id=2, name="Truhe 2", items={"50.000 Erfahrungspunkte", "2500 Kürbisse", "250 Halloween-Süßigkeiten", "$10000"}},
			{id=3, name="Truhe 3", items={"75.000 Erfahrungspunkte", "5000 Kürbisse", "500 Halloween-Süßigkeiten", "$20000", "Skelett-Outfit"}},
		},

		["RU"] = {
			{id=1, name="Сундук 1", items={"25 000 очков опыта", "1000 тыкв", "100 хэллоуинских конфет", "$5000"}},
			{id=2, name="Сундук 2", items={"50 000 очков опыта", "2500 тыкв", "250 хэллоуинских конфет", "$10000"}},
			{id=3, name="Сундук 3", items={"75 000 очков опыта", "5000 тыкв", "500 хэллоуинских конфет", "$20000", "Костюм скелета"}},
		},

		["PT"] = {
			{id=1, name="Baú 1", items={"25.000 pontos de experiência", "1000 abóboras", "100 doces de Halloween", "$5000"}},
			{id=2, name="Baú 2", items={"50.000 pontos de experiência", "2500 abóboras", "250 doces de Halloween", "$10000"}},
			{id=3, name="Baú 3", items={"75.000 pontos de experiência", "5000 abóboras", "500 doces de Halloween", "$20000", "Traje de esqueleto"}},
		},
    },
    currentChest = 1,
    show = false
}

local btnW, btnH = 120, 30
local w, h = 450, 350
local x, y = (screenW - w)/2, (screenH - h)/2

function HalloweenChestsUI.toggleOpen()
	setWindowData()
	showCursor(true)
    addEventHandler("onClientRender", root, renderHalloweenChests)
	addEventHandler("onClientClick", root, HalloweenChestsUI.click)
end

function HalloweenChestsUI.toggleClose()
	closeWindow()
    removeEventHandler("onClientRender", root, renderHalloweenChests)
	removeEventHandler("onClientClick", root, HalloweenChestsUI.click)
end

addEventHandler("onClientPlayerWasted",root,function(player)
	if(player == localPlayer)then
		HalloweenChestsUI.toggleClose()
	end
end)

local function isMouseInPosition(px, py, pw, ph)
    if not isCursorShowing() then return false end
    local cx, cy = getCursorPosition()
    cx, cy = cx*screenW, cy*screenH
    return cx >= px and cx <= px+pw and cy >= py and cy <= py+ph
end

function HalloweenChestsUI.click(button,state)
    if button ~= "left" or state ~= "up" then return end

    local chest = HalloweenChestsUI.chests[apocalypseGetElementData(localPlayer,"language") or "EN"][HalloweenChestsUI.currentChest]

    if isMouseInPosition(x+10, y+h-40, btnW, btnH) then
        HalloweenChestsUI.currentChest = HalloweenChestsUI.currentChest > 1 and HalloweenChestsUI.currentChest-1 or #HalloweenChestsUI.chests[apocalypseGetElementData(localPlayer,"language") or "EN"]
    end

    if isMouseInPosition(x+w-btnW-10, y+h-40, btnW, btnH) then
        HalloweenChestsUI.currentChest = HalloweenChestsUI.currentChest < #HalloweenChestsUI.chests[apocalypseGetElementData(localPlayer,"language") or "EN"] and HalloweenChestsUI.currentChest+1 or 1
    end

    if isMouseInPosition(x+(w-btnW)/2, y+h-40, btnW, btnH) then
        triggerServerEvent("HalloweenChest.Open", localPlayer, chest.id)
    end

    if isMouseInPosition(x+w-35, y+5, 30, 30) then
        HalloweenChestsUI.toggleClose()
    end
end

function renderHalloweenChests()
    local chest = HalloweenChestsUI.chests[apocalypseGetElementData(localPlayer,"language") or "EN"][HalloweenChestsUI.currentChest]

    dxDrawRectangle(x, y, w, h, tocolor(20,20,20,220), false)

    dxDrawRectangle(x+10, y+h-40, btnW, btnH, tocolor(40,40,40,220), false)
    dxDrawRectangle(x+w-btnW-10, y+h-40, btnW, btnH, tocolor(40,40,40,220), false)
    dxDrawRectangle(x+(w-btnW)/2, y+h-40, btnW, btnH, tocolor(80,40,0,220), false)

    dxDrawRectangle(x+w-35, y+5, 30, 30, tocolor(200,50,50,220), false)

    dxDrawText("Halloween Chests ", x, y+10, x+w, y+40, tocolor(255,140,0,255), 1.4, "default-bold", "center", "top", true)
    dxDrawText(chest.name, x, y+50, x+w, y+80, tocolor(255,200,50,255), 1.2, "default-bold", "center", "top", true)

    for i, item in ipairs(chest.items) do
        dxDrawText(item, x+20, y+80 + (i-1)*25, x+w-20, y+105 + (i-1)*25, tocolor(255,255,255,255), 1, "default", "left", "top", true)
    end

    dxDrawText("Previous", x+10, y+h-40, x+10+btnW, y+h-10, tocolor(255,255,255,255), 1, "default-bold", "center", "center", true)
    dxDrawText("Next", x+w-btnW-10, y+h-40, x+w-10, y+h-10, tocolor(255,255,255,255), 1, "default-bold", "center", "center", true)
    dxDrawText("OPEN", x+(w-btnW)/2, y+h-40, x+(w-btnW)/2+btnW, y+h-10, tocolor(255,200,0,255), 1, "default-bold", "center", "center", true)
    dxDrawText("X", x+w-35, y+5, x+w-5, y+35, tocolor(255,255,255,255), 1, "default-bold", "center", "center", true)
end