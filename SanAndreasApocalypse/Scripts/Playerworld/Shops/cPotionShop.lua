local sx, sy = guiGetScreenSize()

local shopOpen = false
local selected = 1

local Pickup = createPickup(689.40002441406,-458.14544677734,16.536296844482,3,1239,50)

addEventHandler("onClientRender",root,function()
	if(isCharacterLoggedIn() and isWindowOpen())then
		local x1,y1,z1 = getElementPosition(Pickup)
		local screenX1,screenY1 = getScreenFromWorldPosition(x1,y1,z1)
		
		if(screenX1 and screenY1)then
			if(tonumber(apocalypseGetElementData(localPlayer,"level")))then
				if(getDistanceBetweenPoints3D(x1,y1,z1,getElementPosition(localPlayer)) <= 5)then
					dxDrawText(getPotionText("title"), screenX1 - 100, screenY1 - 20, screenX1 + 100, screenY1 + 20, tocolor(255, 255, 255), 1.2, "default-bold", "center", "center")
				end
			end
		end
	end
end)

addEventHandler("onClientPickupHit",Pickup,function(player)
	if(player == localPlayer)then
		if(getElementDimension(localPlayer) == getElementDimension(source))then
			togglePotionShop()
		end
	end
end)

local potions = {
    ["DE"] = {
        {id = "speed", name = "Geschwindigkeitsboost", price = 1250},
        {id = "protection", name = "Schutz vor Zombies", price = 1750},
        {id = "health", name = "Heilungsboost", price = 750},
        {id = "stun", name = "Zombiebetäubung", price = 1500}
    },
	["EN"] = {
		{id = "speed", name = "Speed Boost", price = 1250},
		{id = "protection", name = "Zombie Protection", price = 1750},
		{id = "health", name = "Healing Boost", price = 750},
		{id = "stun", name = "Zombie Stun", price = 1500}
	},
	["RU"] = {
		{id = "speed", name = "Ускорение", price = 1250},
		{id = "protection", name = "Защита от зомби", price = 1750},
		{id = "health", name = "Усиленное лечение", price = 750},
		{id = "stun", name = "Оглушение зомби", price = 1500}
	},
	["PT"] = {
		{id = "speed", name = "Impulso de Velocidade", price = 1250},
		{id = "protection", name = "Proteção contra Zumbis", price = 1750},
		{id = "health", name = "Impulso de Cura", price = 750},
		{id = "stun", name = "Atordoamento de Zumbis", price = 1500}
	},
}

local texts = {
    ["DE"] = {
        title = "Tränke-Shop",
        buy = "Kaufen",
        close = "Schliessen"
    },
	["EN"] = {
		title = "Potion Shop",
		buy = "Buy",
		close = "Close"
	},

	["RU"] = {
		title = "Магазин зелий",
		buy = "Купить",
		close = "Закрыть"
	},

	["PT"] = {
		title = "Loja de Poções",
		buy = "Comprar",
		close = "Fechar"
	},
}

local function getPotionList()
    return potions[apocalypseGetElementData(localPlayer,"language")] or potions["EN"]
end

function getPotionText(key)
    return (texts[apocalypseGetElementData(localPlayer,"language")] and texts[apocalypseGetElementData(localPlayer,"language")][key]) or texts["EN"][key] or key
end

local w, h = 340, 250
local x, y = sx/2 - w/2, sy/2 - h/2

function drawPotionShop()
    local potionList = getPotionList()

    dxDrawRectangle(x-3, y-3, w+6, h+6, tocolor(0,0,0,120))
    dxDrawRectangle(x, y, w, h, tocolor(22,22,22,245))
    dxDrawRectangle(x, y, w, 38, tocolor(220,25,25,255))

    dxDrawText(getPotionText("title"), x+15, y, x+w, y+38, tocolor(255,255,255), 1.15, "default-bold", "left", "center")

    for i, v in ipairs(potionList) do
        local py = y + 55 + (i-1)*38
        local hover = isMouseInPosition(x+15, py, w-30, 32)
        local bg = selected == i and tocolor(220,25,25,120) or hover and tocolor(50,50,50,230) or tocolor(35,35,35,230)

        dxDrawRectangle(x+15, py, w-30, 32, bg)
        dxDrawText(v.name, x+28, py, x+180, py+32, tocolor(255,255,255), 1, "default-bold", "left", "center")
        dxDrawText("$"..v.price, x+180, py, x+w-45, py+32, tocolor(180,180,180), 1, "default", "right", "center")
    end

    local buyHover = isMouseInPosition(x+15, y+h-45, 145, 30)
    dxDrawRectangle(x+15, y+h-45, 145, 30, buyHover and tocolor(235,35,35) or tocolor(220,25,25))
    dxDrawText(getPotionText("buy"), x+15, y+h-45, x+160, y+h-15, tocolor(255,255,255), 1, "default-bold", "center", "center")

    local closeHover = isMouseInPosition(x+180, y+h-45, 145, 30)
    dxDrawRectangle(x+180, y+h-45, 145, 30, closeHover and tocolor(65,65,65) or tocolor(45,45,45))
    dxDrawText(getPotionText("close"), x+180, y+h-45, x+325, y+h-15, tocolor(255,255,255), 1, "default-bold", "center", "center")
end

function togglePotionShop()
	if(isWindowOpen())then
		setWindowData()
		showCursor(true)
		addEventHandler("onClientRender", root, drawPotionShop)
		addEventHandler("onClientClick",root,potionShop_Click)
	end
end

function potionShop_Click(button,state)
    local potionList = getPotionList()

    for i, v in ipairs(potionList) do
        local py = y + 55 + (i-1)*38

        if isMouseInPosition(x+15, py, w-30, 32) then
            selected = i
            return
        end
    end

    if isMouseInPosition(x+15, y+h-45, 145, 30) then
        local potion = potionList[selected]

        if potion then
            triggerServerEvent("buyPotion", localPlayer, potion.id, potion.price)
        end
    end

    if isMouseInPosition(x+180, y+h-45, 145, 30) then
		closeWindow()
		removeEventHandler("onClientRender", root, drawPotionShop)
		removeEventHandler("onClientClick",root,potionShop_Click)
    end
end

addEventHandler("onClientPlayerWasted",root,function(player)
	if(player == localPlayer)then
		removeEventHandler("onClientRender", root, drawPotionShop)
		removeEventHandler("onClientClick",root,potionShop_Click)
	end
end)