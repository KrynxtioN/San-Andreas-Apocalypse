local coupons = {
	["EN"] = {
		{name = "Coupon 1", description = "Double experience points for zombie kills and streaks for 10 minutes.", image = "Files/Images/Coupons/Coupon1.png", id = 1},
		{name = "Coupon 2", description = "Double money for zombie kills and streaks for 10 minutes.", image = "Files/Images/Coupons/Coupon2.png", id = 2},
		{name = "Coupon 3", description = "Be immune to zombies for 30 minutes.", image = "Files/Images/Coupons/Coupon3.png", id = 3},
		{name = "Coupon 4", description = "Double skillpoints for 10 minutes.", image = "Files/Images/Coupons/Coupon4.png", id = 4},
	},
	["DE"] = {
		{name = "Coupon 1", description = "10 Minuten lang doppelte Erfahrungspunkte für Zombiekills und Streaks.", image = "Files/Images/Coupons/Coupon1.png", id = 1},
		{name = "Coupon 2", description = "10 Minuten lang doppeltes Geld für Zombiekills und Streaks.", image = "Files/Images/Coupons/Coupon2.png", id = 2},
		{name = "Coupon 3", description = "Sei für 30 Minuten immun gegen Zombies.", image = "Files/Images/Coupons/Coupon3.png", id = 3},
		{name = "Coupon 4", description = "10 Minuten lang doppelte Skillpunkte.", image = "Files/Images/Coupons/Coupon4.png", id = 4},
	},
	["RU"] = {
		{name = "Купон 1", description = "Двойной опыт за убийства зомби и серии в течение 10 минут.", image = "Files/Images/Coupons/Coupon1.png", id = 1},
		{name = "Купон 2", description = "Двойные деньги за убийства зомби и серии в течение 10 минут.", image = "Files/Images/Coupons/Coupon2.png", id = 2},
		{name = "Купон 3", description = "Будьте невосприимчивы к зомби в течение 30 минут.", image = "Files/Images/Coupons/Coupon3.png", id = 3},
		{name = "Купон 4", description = "Двойные очки навыков в течение 10 минут.", image = "Files/Images/Coupons/Coupon4.png", id = 4},
	},
	["PT"] = {
		{name = "Cupom 1", description = "Dobre pontos de experiência por mortes de zumbis e streaks por 10 minutos.", image = "Files/Images/Coupons/Coupon1.png", id = 1},
		{name = "Cupom 2", description = "Dobre o dinheiro por mortes de zumbis e streaks por 10 minutos.", image = "Files/Images/Coupons/Coupon2.png", id = 2},
		{name = "Cupom 3", description = "Fique imune a zumbis por 30 minutos.", image = "Files/Images/Coupons/Coupon3.png", id = 3},
		{name = "Cupom 4", description = "Dobre os pontos de habilidade por 10 minutos.", image = "Files/Images/Coupons/Coupon4.png", id = 4},
	},
}

local selectedIndex = 1
local couponWidth = 200
local couponHeight = 100
local couponScale = 1.2
local couponNormalScale = 1
local couponSpacing = 50

local function getCouponLanguage()
	local language = apocalypseGetElementData(localPlayer, "language") or "EN"
	if not coupons[language] then
		language = "EN"
	end
	return language
end

function couponShopRender()
    local screenWidth, screenHeight = guiGetScreenSize()
    local startY = (screenHeight - couponHeight) / 2
	local language = getCouponLanguage()
	local currentCoupons = coupons[language]

    local totalWidth = 0
    for i = 1, #currentCoupons do
        local scale = (i == selectedIndex) and couponScale or couponNormalScale
        totalWidth = totalWidth + (couponWidth * scale) + couponSpacing
    end
    totalWidth = totalWidth - couponSpacing

    local startX = (screenWidth - totalWidth) / 2
	local instructionsY = startY + couponHeight * couponNormalScale + 80

	dxDrawText(getText("CCoupons2"), 0, instructionsY, screenWidth, instructionsY + 20, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "top", false, true, true)

    for i = 1, #currentCoupons do
        local scale = (i == selectedIndex) and couponScale or couponNormalScale
        local x = startX
		local coupon = currentCoupons[i]

        dxDrawRectangle(x - 10, startY - 10, (couponWidth * scale) + 20, (couponHeight * scale) + 60, tocolor(0, 0, 0, 150), true)
        dxDrawImage(x, startY, couponWidth * scale, couponHeight * scale, coupon.image, 0, 0, 0, tocolor(255, 255, 255, 255), true)

        dxDrawText(coupon.name, x + 1, startY - 29, x + couponWidth * scale + 1, startY + 1, tocolor(0, 0, 0, 255), scale, "default-bold", "center", "center", false, false, true)
        dxDrawText(coupon.name, x, startY - 30, x + couponWidth * scale, startY, tocolor(255, 255, 255, 255), scale, "default-bold", "center", "center", false, false, true)

        local descriptionY = startY + couponHeight * scale + 5
        dxDrawText(coupon.description, x, descriptionY, x + couponWidth * scale, descriptionY + 50, tocolor(0, 0, 0, 255), 1, "default", "center", "top", false, true, true)
        dxDrawText(coupon.description, x + 1, descriptionY + 1, x + couponWidth * scale + 1, descriptionY + 51, tocolor(255, 255, 255, 255), 1, "default", "center", "top", false, true, true)

        if i == selectedIndex then
            dxDrawRectangle(x - 10, startY - 10, (couponWidth * scale) + 20, (couponHeight * scale) + 60, tocolor(255, 215, 0, 50), true)
        end

        startX = startX + (couponWidth * scale) + couponSpacing
    end
end

local function handleKeyPress(key, state)
    if not state then return end

	local language = getCouponLanguage()
	local currentCoupons = coupons[language]

    if key == "arrow_l" then
        selectedIndex = (selectedIndex - 1) < 1 and #currentCoupons or (selectedIndex - 1)
    elseif key == "arrow_r" then
        selectedIndex = (selectedIndex + 1) > #currentCoupons and 1 or (selectedIndex + 1)
    elseif key == "enter" then
		triggerServerEvent("Coupons.buy", localPlayer, currentCoupons[selectedIndex].id)
    end
end

function openCouponShop()
	if isWindowOpen() then
		local language = getCouponLanguage()
		local currentCoupons = coupons[language]

		if selectedIndex > #currentCoupons then
			selectedIndex = 1
		end

		setWindowData()
		toggleAllControls(false)
		showCursor(true)

		addEventHandler("onClientRender", root, couponShopRender)
		bindKey("arrow_l", "down", handleKeyPress)
		bindKey("arrow_r", "down", handleKeyPress)
		bindKey("enter", "down", handleKeyPress)
		bindKey("backspace", "down", CouponshopClose)

		NPC.NormalMessage(getText("CCoupons1"))
	end
end

function CouponshopClose()
	toggleAllControls(true)
	removeEventHandler("onClientRender", root, couponShopRender)
	unbindKey("arrow_l", "down", handleKeyPress)
	unbindKey("arrow_r", "down", handleKeyPress)
	unbindKey("enter", "down", handleKeyPress)
	unbindKey("backspace", "down", CouponshopClose)
	closeWindow()
	NPC.Close()
end

addEventHandler("onClientPlayerWasted", root, function(player)
	if player == localPlayer then
		CouponshopClose()
	end
end)