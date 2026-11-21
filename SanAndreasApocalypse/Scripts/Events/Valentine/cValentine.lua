local baseWidth = 1920
local baseHeight = 1080
local screenWidth, screenHeight = guiGetScreenSize()

local function scaleX(x)
	return x * (screenWidth / baseWidth)
end

local function scaleY(y)
	return y * (screenHeight / baseHeight)
end

local function scaleW(w)
	return w * (screenWidth / baseWidth)
end

local function scaleH(h)
	return h * (screenHeight / baseHeight)
end

local function dxDrawRectangleS(x, y, w, h, color, postGUI)
	dxDrawRectangle(scaleX(x), scaleY(y), scaleW(w), scaleH(h), color, postGUI)
end

local function dxDrawTextS(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPos)
	dxDrawText(text, scaleX(left), scaleY(top), scaleX(right), scaleY(bottom), color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPos)
end

local function dxDrawImageS(x, y, w, h, image, rotation, rotationCenterOffsetX, rotationCenterOffsetY, color, postGUI)
	dxDrawImage(scaleX(x), scaleY(y), scaleW(w), scaleH(h), image, rotation, rotationCenterOffsetX, rotationCenterOffsetY, color, postGUI)
end

ValentinesDay = {
	MenuOpen = false,
	ShopOpen = false,
	["Costs"] = {
		[1] = 500,
		[2] = 1000,
		[3] = 2000,
		[4] = 3000,
		[5] = 3500,
		[6] = 5000,
		[7] = 6500,
		[8] = 8000,
		[9] = 9000,
		[10] = 11500,
	},
	["Rewards"] = {
		["EN"] = {
			[1] = "\n20 Event-Coins\n1250 Experience Points",
			[2] = "\n30 Event-Coins\n2500 Experience Points",
			[3] = "\n50 Event-Coins\n5000 Experience Points",
			[4] = "\n70 Event-Coins\n7500 Experience Points",
			[5] = "\n90 Event-Coins\n8750 Experience Points",
			[6] = "\n110 Event-Coins\n12500 Experience Points",
			[7] = "\n130 Event-Coins\n16250 Experience Points",
			[8] = "\n150 Event-Coins\n20000 Experience Points",
			[9] = "\n170 Event-Coins\n22500 Experience Points",
			[10] = "\n180 Event-Coins\n28750 Experience Points",
		},
		["DE"] = {
			[1] = "\n20 Event-Coins\n1250 Erfahrungspunkte",
			[2] = "\n30 Event-Coins\n2500 Erfahrungspunkte",
			[3] = "\n50 Event-Coins\n5000 Erfahrungspunkte",
			[4] = "\n70 Event-Coins\n7500 Erfahrungspunkte",
			[5] = "\n90 Event-Coins\n8750 Erfahrungspunkte",
			[6] = "\n110 Event-Coins\n12500 Erfahrungspunkte",
			[7] = "\n130 Event-Coins\n16250 Erfahrungspunkte",
			[8] = "\n150 Event-Coins\n20000 Erfahrungspunkte",
			[9] = "\n170 Event-Coins\n22500 Erfahrungspunkte",
			[10] = "\n180 Event-Coins\n28750 Erfahrungspunkte",
		},
	},
	["VehiclePrice"] = {
		[434] = 350,
		[535] = 350,
		[539] = 350,
		[420] = 350,
		[424] = 350,
		[504] = 350,
		[495] = 500,
		[444] = 500,
	},
	["ItemPrice"] = {
		[1] = 25,
		[2] = 25,
		[3] = 50,
		[4] = 50,
		[5] = 100,
		[6] = 100,
		[7] = 5,
		[8] = 100,
		[9] = 0,
		[10] = 0,
		[11] = 0,
		[12] = 0,
	},
}

function ValentinesDay.RenderMenu()
	if(ValentinesDay.questFinished and ValentinesDay.communityProgress and ValentinesDay.task and ValentinesDay.playerEventCoins and ValentinesDay.topPlayer)then
		setPlayerHudComponentVisible("radar",false)
		
		dxDrawRectangleS(0, 0, 1920, 152, tocolor(0, 0, 0, 255), false)
		dxDrawRectangleS(0, 928, 1920, 152, tocolor(0, 0, 0, 255), false)
		dxDrawRectangleS(10, 162, 336, 344, tocolor(0, 0, 0, 175), false)
		dxDrawTextS(getText("CValentineEvent1"), 20, 172, 336, 228, tocolor(255, 255, 255, 255), 2.00, "default-bold", "center", "center", false, false, false, false, false)
		dxDrawTextS(getText("CValentineEvent2"), 20, 238, 336, 303, tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "center", false, true, false, false, false)
		dxDrawTextS(getText("CValentineEvent3"), 20, 313, 336, 351, tocolor(255, 255, 255, 255), 1.20, "default-bold", "center", "center", false, true, false, false, false)
		dxDrawTextS(getText("CValentineEvent4"), 20, 361, 336, 426, tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "center", false, true, false, false, false)

		dxDrawRectangleS(20, 436, 316, 26, tocolor(246, 30, 254, 255), false)
		dxDrawTextS(getText("CValentineEvent5"), 20, 436, 336, 462, tocolor(255, 255, 255, 255), 1.20, "default-bold", "center", "center", false, true, false, false, false)
		dxDrawTextS(getText("CValentineEvent6"):format(ValentinesDay.questFinished), 20, 472, 336, 496, tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "center", false, true, false, false, false)
		
		dxDrawTextS(getText("CValentineEvent7"), 20, 526, 336, 564, tocolor(255, 255, 255, 255), 1.20, "default-bold", "center", "center", false, true, true, false, false)
		dxDrawRectangleS(10, 516, 336, 215, tocolor(0, 0, 0, 175), false)
		dxDrawTextS(ValentinesDay.topPlayer, 20, 574, 336, 721, tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "center", false, true, true, false, false)
		
		dxDrawRectangleS(10, 741, 336, 47, tocolor(0, 0, 0, 175), false)
		dxDrawRectangleS(10, 798, 336, 47, tocolor(0, 0, 0, 175), false)
		dxDrawTextS(getText("CValentineEvent8"), 10, 741, 346, 788, tocolor(255, 255, 255, 255), 1.50, "default-bold", "center", "center", false, true, true, false, false)
		dxDrawTextS(getText("CValentineEvent9"), 10, 798, 346, 845, tocolor(255, 255, 255, 255), 1.50, "default-bold", "center", "center", false, true, true, false, false)

		local MaxProgress = 100000
		local barHeight = math.floor((ValentinesDay.communityProgress/MaxProgress) * 683)
		local barY = 162 + (683 - barHeight)
		
		dxDrawRectangleS(1864, 162, 46, 683, tocolor(0, 0, 0, 255), false)
		dxDrawRectangleS(1864, barY, 46, barHeight, tocolor(45, 45, 238, 255), false)
		dxDrawRectangleS(1569, 162, 285, 113, tocolor(0, 0, 0, 175), false)
		dxDrawTextS(getText("CValentineEvent10"), 1579, 172, 1844, 235, tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "center", false, true, false, false, false)
		dxDrawTextS(getText("CValentineEvent11"):format(ValentinesDay.communityProgress), 1579, 245, 1844, 265, tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "center", false, true, false, false, false)
		
		dxDrawRectangleS(1569, 330, 285, 272, tocolor(0, 0, 0, 175), false)
		dxDrawTextS(getText("CValentineEvent12"):format(ValentinesDay.task + 1, ValentinesDay["Costs"][ValentinesDay.task + 1]), 1579, 340, 1844, 386, tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "center", false, true, false, false, false)
		dxDrawRectangleS(1579, 396, 265, 24, tocolor(45, 45, 238, 255), false)
		dxDrawTextS(getText("CValentineEvent13"):format(ValentinesDay["Rewards"][apocalypseGetElementData(localPlayer,"language") or "EN"][ValentinesDay.task + 1]), 1579, 430, 1844, 592, tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "top", false, true, false, false, false)
		dxDrawTextS(getText("CValentineEvent14"), 1579, 396, 1844, 420, tocolor(255, 255, 255, 255), 1.00, "default-bold", "center", "center", false, true, false, false, false)
		dxDrawTextS(getText("CValentineEvent15"), 1569, 300, 1854, 320, tocolor(255, 255, 255, 255), 1.20, "default-bold", "left", "center", false, true, false, false, false)
	end
end

local buttons = {
    { x = 663,  y = 202, w = 142, h = 91, img = "Files/Images/Vehicles/Vehicle_434.jpg", model = 434 },
    { x = 815,  y = 202, w = 142, h = 91, img = "Files/Images/Vehicles/Vehicle_535.jpg", model = 535 },
    { x = 967,  y = 202, w = 142, h = 91, img = "Files/Images/Vehicles/Vehicle_539.jpg", model = 539 },
    { x = 1119, y = 202, w = 142, h = 91, img = "Files/Images/Vehicles/Vehicle_420.jpg", model = 420 },
    { x = 663,  y = 303, w = 142, h = 91, img = "Files/Images/Vehicles/Vehicle_424.jpg", model = 424 },
    { x = 815,  y = 303, w = 142, h = 91, img = "Files/Images/Vehicles/Vehicle_504.jpg", model = 504 },
    { x = 967,  y = 303, w = 142, h = 91, img = "Files/Images/Vehicles/Vehicle_495.jpg", model = 495 },
    { x = 1119, y = 303, w = 142, h = 91, img = "Files/Images/Vehicles/Vehicle_444.jpg", model = 444 }
}

function ValentinesDay.RenderShop()
	ValentinesDay.selectedPrice = "/"

    dxDrawRectangleS(653, 162, 618, 359, tocolor(0, 0, 1, 175), false)
    dxDrawRectangleS(653, 162, 618, 25, tocolor(226, 2, 2, 175), false)
    dxDrawTextS(getText("CValentineEvent16"), 653, 162, 1271, 187, tocolor(255, 255, 255, 255), 2.00, "default-bold", "center", "center", false, false, false, false, false)
	
    for i, btn in ipairs(buttons) do
        if isMouseInPosition(btn.x, btn.y, btn.w, btn.h) then
            local scale = 1.1
            local newW = btn.w * scale
            local newH = btn.h * scale
            local newX = btn.x - (newW - btn.w) / 2
            local newY = btn.y - (newH - btn.h) / 2
            dxDrawImageS(newX, newY, newW, newH, btn.img, 0, 0, 0, tocolor(255, 255, 255, 255), false)
			ValentinesDay.selectedPrice = ValentinesDay["VehiclePrice"][btn.model]
        else
            dxDrawImageS(btn.x, btn.y, btn.w, btn.h, btn.img, 0, 0, 0, tocolor(255, 255, 255, 255), false)
        end
    end

	local btn1Hovered = isMouseInPosition(scaleX(663), scaleY(404), scaleW(142), scaleH(29))
	local btn1Color = btn1Hovered and tocolor(255, 255, 200, 255) or tocolor(255, 255, 255, 255)
	dxDrawRectangleS(663, 404, 142, 29, btn1Color, false)
	dxDrawTextS(getText("CValentineEvent21"), 663, 404, 663 + 142, 404 + 29, tocolor(0, 0, 0, 255), 1, "default-bold", "center", "center")
	if btn1Hovered then
		ValentinesDay.selectedPrice = ValentinesDay["ItemPrice"][1]
	end

	local btn2Hovered = isMouseInPosition(scaleX(815), scaleY(404), scaleW(142), scaleH(29))
	local btn2Color = btn2Hovered and tocolor(255, 255, 200, 255) or tocolor(255, 255, 255, 255)
	dxDrawRectangleS(815, 404, 142, 29, btn2Color, false)
	dxDrawTextS(getText("CValentineEvent22"), 815, 404, 815 + 142, 404 + 29, tocolor(0, 0, 0, 255), 1, "default-bold", "center", "center")
	if btn2Hovered then
		ValentinesDay.selectedPrice = ValentinesDay["ItemPrice"][2]
	end

	local btn3Hovered = isMouseInPosition(scaleX(967), scaleY(404), scaleW(142), scaleH(29))
	local btn3Color = btn3Hovered and tocolor(255, 255, 200, 255) or tocolor(255, 255, 255, 255)
	dxDrawRectangleS(967, 404, 142, 29, btn3Color, false)
	dxDrawTextS(getText("CValentineEvent23"), 967, 404, 967 + 142, 404 + 29, tocolor(0, 0, 0, 255), 1, "default-bold", "center", "center")
	if btn3Hovered then
		ValentinesDay.selectedPrice = ValentinesDay["ItemPrice"][3]
	end

	local btn4Hovered = isMouseInPosition(scaleX(1119), scaleY(404), scaleW(142), scaleH(29))
	local btn4Color = btn4Hovered and tocolor(255, 255, 200, 255) or tocolor(255, 255, 255, 255)
	dxDrawRectangleS(1119, 404, 142, 29, btn4Color, false)
	dxDrawTextS(getText("CValentineEvent24"), 1119, 404, 1119 + 142, 404 + 29, tocolor(0, 0, 0, 255), 1, "default-bold", "center", "center")
	if btn4Hovered then
		ValentinesDay.selectedPrice = ValentinesDay["ItemPrice"][4]
	end

	local btn5Hovered = isMouseInPosition(scaleX(663), scaleY(443), scaleW(142), scaleH(29))
	local btn5Color = btn5Hovered and tocolor(255, 255, 200, 255) or tocolor(255, 255, 255, 255)
	dxDrawRectangleS(663, 443, 142, 29, btn5Color, false)
	dxDrawTextS(getText("CValentineEvent25"), 663, 443, 663 + 142, 443 + 29, tocolor(0, 0, 0, 255), 1, "default-bold", "center", "center")
	if btn5Hovered then
		ValentinesDay.selectedPrice = ValentinesDay["ItemPrice"][5]
	end

	local btn6Hovered = isMouseInPosition(scaleX(815), scaleY(443), scaleW(142), scaleH(29))
	local btn6Color = btn6Hovered and tocolor(255, 255, 200, 255) or tocolor(255, 255, 255, 255)
	dxDrawRectangleS(815, 443, 142, 29, btn6Color, false)
	dxDrawTextS(getText("CValentineEvent26"), 815, 443, 815 + 142, 443 + 29, tocolor(0, 0, 0, 255), 1, "default-bold", "center", "center")
	if btn6Hovered then
		ValentinesDay.selectedPrice = ValentinesDay["ItemPrice"][6]
	end

	local btn7Hovered = isMouseInPosition(scaleX(967), scaleY(443), scaleW(142), scaleH(29))
	local btn7Color = btn7Hovered and tocolor(255, 255, 200, 255) or tocolor(255, 255, 255, 255)
	dxDrawRectangleS(967, 443, 142, 29, btn7Color, false)
	dxDrawTextS(getText("CValentineEvent27"), 967, 443, 967 + 142, 443 + 29, tocolor(0, 0, 0, 255), 1, "default-bold", "center", "center")
	if btn7Hovered then
		ValentinesDay.selectedPrice = ValentinesDay["ItemPrice"][7]
	end

	local btn8Hovered = isMouseInPosition(scaleX(1119), scaleY(443), scaleW(142), scaleH(29))
	local btn8Color = btn8Hovered and tocolor(255, 255, 200, 255) or tocolor(255, 255, 255, 255)
	dxDrawRectangleS(1119, 443, 142, 29, btn8Color, false)
	dxDrawTextS(getText("CValentineEvent28"), 1119, 443, 1119 + 142, 443 + 29, tocolor(0, 0, 0, 255), 1, "default-bold", "center", "center")
	if btn8Hovered then
		ValentinesDay.selectedPrice = ValentinesDay["ItemPrice"][8]
	end

	local btn9Hovered = isMouseInPosition(scaleX(663), scaleY(482), scaleW(142), scaleH(29))
	local btn9Color = btn9Hovered and tocolor(255, 255, 200, 255) or tocolor(255, 255, 255, 255)
	dxDrawRectangleS(663, 482, 142, 29, btn9Color, false)
	dxDrawTextS(getText("CValentineEvent29"), 663, 482, 663 + 142, 482 + 29, tocolor(0, 0, 0, 255), 1, "default-bold", "center", "center")
	if btn9Hovered then
		ValentinesDay.selectedPrice = ValentinesDay["ItemPrice"][9]
	end

	local btn10Hovered = isMouseInPosition(scaleX(815), scaleY(482), scaleW(142), scaleH(29))
	local btn10Color = btn10Hovered and tocolor(255, 255, 200, 255) or tocolor(255, 255, 255, 255)
	dxDrawRectangleS(815, 482, 142, 29, btn10Color, false)
	dxDrawTextS(getText("CValentineEvent30"), 815, 482, 815 + 142, 482 + 29, tocolor(0, 0, 0, 255), 1, "default-bold", "center", "center")
	if btn10Hovered then
		ValentinesDay.selectedPrice = ValentinesDay["ItemPrice"][10]
	end

	local btn11Hovered = isMouseInPosition(scaleX(967), scaleY(482), scaleW(142), scaleH(29))
	local btn11Color = btn11Hovered and tocolor(255, 255, 200, 255) or tocolor(255, 255, 255, 255)
	dxDrawRectangleS(967, 482, 142, 29, btn11Color, false)
	dxDrawTextS(getText("CValentineEvent31"), 967, 482, 967 + 142, 482 + 29, tocolor(0, 0, 0, 255), 1, "default-bold", "center", "center")
	if btn11Hovered then
		ValentinesDay.selectedPrice = ValentinesDay["ItemPrice"][11]
	end

	local btn12Hovered = isMouseInPosition(scaleX(1119), scaleY(482), scaleW(142), scaleH(29))
	local btn12Color = btn12Hovered and tocolor(255, 255, 200, 255) or tocolor(255, 255, 255, 255)
	dxDrawRectangleS(1119, 482, 142, 29, btn12Color, false)
	dxDrawTextS(getText("CValentineEvent32"), 1119, 482, 1119 + 142, 482 + 29, tocolor(0, 0, 0, 255), 1, "default-bold", "center", "center")
	if btn12Hovered then
		ValentinesDay.selectedPrice = ValentinesDay["ItemPrice"][12]
	end

    dxDrawRectangleS(653, 531, 618, 25, tocolor(0, 0, 0, 175), false)
    dxDrawTextS(getText("CValentineEvent17"):format(ValentinesDay.playerEventCoins), 663, 531, 840, 556, tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "center", false, true, false, false, false)
    dxDrawTextS(getText("CValentineEvent18"):format(ValentinesDay.selectedPrice), 850, 531, 1261, 556, tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "center", false, true, false, false, false)
	
	if(tonumber(ValentinesDay.communityProgress) < 100000) then
		dxDrawRectangleS(967, 303, 142, 91, tocolor(0, 0, 0, 200), false,_,true)
		dxDrawTextS(getText("CValentineEvent19"), 967, 303, 967 + 142, 303 + 91, tocolor(255, 0, 0, 255), 1, "default-bold", "center", "center")
		dxDrawTextS(getText("CValentineEvent20"), 967, 323, 967 + 142, 303 + 91, tocolor(255, 255, 255, 255), 0.8, "default-bold", "center", "center")
		
		dxDrawRectangleS(1119, 303, 142, 91, tocolor(0, 0, 0, 200), false,_,true)
		dxDrawTextS(getText("CValentineEvent19"), 1119, 303, 1119 + 142, 303 + 91, tocolor(255, 0, 0, 255), 1, "default-bold", "center", "center")
		dxDrawTextS(getText("CValentineEvent20"), 1119, 323, 1119 + 142, 303 + 91, tocolor(255, 255, 255, 255), 0.8, "default-bold", "center", "center")
	end
	
	if(tonumber(ValentinesDay.communityProgress) < 25000) then
		dxDrawRectangleS(663, 482, 142, 29, tocolor(0, 0, 0, 200), false,_,true)
		dxDrawTextS(getText("CValentineEvent19"), 663, 482, 663 + 142, 482 + 29, tocolor(255, 0, 0, 255), 1, "default-bold", "center", "center")
	end
	if(tonumber(ValentinesDay.communityProgress) < 50000) then
		dxDrawRectangleS(815, 482, 142, 29, tocolor(0, 0, 0, 200), false,_,true)
		dxDrawTextS(getText("CValentineEvent19"), 815, 482, 815 + 142, 482 + 29, tocolor(255, 0, 0, 255), 1, "default-bold", "center", "center")
	end
	if(tonumber(ValentinesDay.communityProgress) < 75000) then
		dxDrawRectangleS(967, 482, 142, 29, tocolor(0, 0, 0, 200), false,_,true)
		dxDrawTextS(getText("CValentineEvent19"), 967, 482, 967 + 142, 482 + 29, tocolor(255, 0, 0, 255), 1, "default-bold", "center", "center")
	end
	if(tonumber(ValentinesDay.communityProgress) < 100000) then
		dxDrawRectangleS(1119, 482, 142, 29, tocolor(0, 0, 0, 200), false,_,true)
		dxDrawTextS(getText("CValentineEvent19"), 1119, 482, 1119 + 142, 482 + 29, tocolor(255, 0, 0, 255), 1, "default-bold", "center", "center")
	end
end

function ValentinesDay.ShopItemsClick(button, state, absoluteX, absoluteY)
    if(button == "left" and state == "down")then
		if(ValentinesDay.MenuOpen == true)then
			local VehicleModel = nil
			local VehiclePrice = nil
			local ItemPrice = nil
			if(isMouseInPosition(scaleX(663), scaleY(202), scaleW(142), scaleH(91)))then
				VehicleModel = 434
			end
			if(isMouseInPosition(scaleX(815), scaleY(202), scaleW(142), scaleH(91)))then
				VehicleModel = 535
			end
			if(isMouseInPosition(scaleX(967), scaleY(202), scaleW(142), scaleH(91)))then
				VehicleModel = 539
			end
			if(isMouseInPosition(scaleX(1119), scaleY(202), scaleW(142), scaleH(91)))then
				VehicleModel = 420
			end
			if(isMouseInPosition(scaleX(663), scaleY(303), scaleW(142), scaleH(91)))then
				VehicleModel = 424
			end
			if(isMouseInPosition(scaleX(815), scaleY(303), scaleW(142), scaleH(91)))then
				VehicleModel = 504
			end
			if(isMouseInPosition(scaleX(967), scaleY(303), scaleW(142), scaleH(91)))then
				VehicleModel = 495
			end
			if(isMouseInPosition(scaleX(1119), scaleY(303), scaleW(142), scaleH(91)))then
				VehicleModel = 444
			end
			
			if isMouseInPosition(scaleX(663), scaleY(404), scaleW(142), scaleH(29)) then
				ItemPrice = ValentinesDay["ItemPrice"][1]
				ValentinesDay.SelectedItem = 1
			elseif isMouseInPosition(scaleX(815), scaleY(404), scaleW(142), scaleH(29)) then
				ItemPrice = ValentinesDay["ItemPrice"][2]
				ValentinesDay.SelectedItem = 2
			elseif isMouseInPosition(scaleX(967), scaleY(404), scaleW(142), scaleH(29)) then
				ItemPrice = ValentinesDay["ItemPrice"][3]
				ValentinesDay.SelectedItem = 3
			elseif isMouseInPosition(scaleX(1119), scaleY(404), scaleW(142), scaleH(29)) then
				ItemPrice = ValentinesDay["ItemPrice"][4]
				ValentinesDay.SelectedItem = 4
			elseif isMouseInPosition(scaleX(663), scaleY(443), scaleW(142), scaleH(29)) then
				ItemPrice = ValentinesDay["ItemPrice"][5]
				ValentinesDay.SelectedItem = 5
			elseif isMouseInPosition(scaleX(815), scaleY(443), scaleW(142), scaleH(29)) then
				ItemPrice = ValentinesDay["ItemPrice"][6]
				ValentinesDay.SelectedItem = 6
			elseif isMouseInPosition(scaleX(967), scaleY(443), scaleW(142), scaleH(29)) then
				ItemPrice = ValentinesDay["ItemPrice"][7]
				ValentinesDay.SelectedItem = 7
			elseif isMouseInPosition(scaleX(1119), scaleY(443), scaleW(142), scaleH(29)) then
				ItemPrice = ValentinesDay["ItemPrice"][8]
				ValentinesDay.SelectedItem = 8
			elseif isMouseInPosition(scaleX(663), scaleY(482), scaleW(142), scaleH(29)) then
				ItemPrice = ValentinesDay["ItemPrice"][9]
				ValentinesDay.SelectedItem = 9
			elseif isMouseInPosition(scaleX(815), scaleY(482), scaleW(142), scaleH(29)) then
				ItemPrice = ValentinesDay["ItemPrice"][10]
				ValentinesDay.SelectedItem = 10
			elseif isMouseInPosition(scaleX(967), scaleY(482), scaleW(142), scaleH(29)) then
				ItemPrice = ValentinesDay["ItemPrice"][11]
				ValentinesDay.SelectedItem = 11
			elseif isMouseInPosition(scaleX(1119), scaleY(482), scaleW(142), scaleH(29)) then
				ItemPrice = ValentinesDay["ItemPrice"][12]
				ValentinesDay.SelectedItem = 12
			end

			if(ItemPrice)then
				triggerServerEvent("ValentinesDay.buyItem",localPlayer,ItemPrice,ValentinesDay.SelectedItem)
			end
			
			if(VehicleModel)then
				VehiclePrice = ValentinesDay["VehiclePrice"][VehicleModel]
				if(VehicleModel and VehiclePrice)then
					triggerServerEvent("ValentinesDay.buyVehicle",localPlayer,VehicleModel,VehiclePrice)
				end
			end
		end
	end
end

local playerCoordinates = {}
local possibleSkins = {1, 2, 3, 5, 6, 7, 8, 11, 12, 13, 14, 16, 17, 18, 23, 27, 31, 32, 33, 38, 39, 40, 41, 42, 43, 44, 45, 47, 49, 51, 52, 53, 54, 55, 57, 58, 61, 62, 63, 65, 71, 72, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 85, 86, 87, 88, 89, 90, 91, 93, 99, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 153, 154, 156, 157, 158, 159, 160, 161, 164, 165, 166, 167, 168, 169, 172, 173, 174, 175, 177, 178, 180, 182, 183, 184, 186, 187, 190, 191, 193, 194, 195, 196, 197, 198, 199, 200, 202, 203, 204, 205, 207, 208, 210, 211, 212, 213, 214, 215, 216, 218, 219, 220, 221, 222, 224, 225, 226, 227, 228, 230, 231, 232, 233, 234, 235, 236, 239, 240, 249, 250, 251, 252, 253, 255, 256, 257, 260, 261, 263, 264, 265, 266, 267, 268, 269, 270, 272, 274, 275, 277, 278, 281, 282, 283, 284, 285, 286, 288, 289, 290, 292, 293, 294, 295, 297, 298}

function ValentinesDay.OpenMenu()
	if(isWindowOpen())then
		setWindowData("no")
		HUD.Visible = false
		triggerServerEvent("ValentinesDay.getData",localPlayer)
		showCursor(true)
		ValentinesDay.MenuOpen = true
		addEventHandler("onClientRender", root, ValentinesDay.RenderMenu)
		addEventHandler("onClientClick", root, ValentinesDay.Click)
		
		ValentinesDay.Ped1 = createPed(possibleSkins[math.random(1,#possibleSkins)], -2236.84765625, -1747.3359375, 480.87368774414, 346)
		ValentinesDay.Ped2 = createPed(possibleSkins[math.random(1,#possibleSkins)], -2237.9873046875, -1747.1424560547, 480.86779785156, 324)

		setPedAnimation(ValentinesDay.Ped1, "sunbathe", "parksit_m_idlea", -1, true, false, false, true)
		setPedAnimation(ValentinesDay.Ped2, "sunbathe", "parksit_m_idlea", -1, true, false, false, true)

		ValentinesDay.Campfire = createObject(1463, -2236.0637207031, -1745.4130859375, 480.18420410156, 0, 0, 6)
		ValentinesDay.CampfireEffect = createEffect("fire_med", -2236.0637207031, -1745.4130859375, 480.18420410156, 0, 0, 0)
		local x,y,z = getElementPosition(localPlayer)
		playerCoordinates = {x,y,z}
		setCameraMatrix(-2240.8671875, -1754.9223632812, 485.59823608398, -2204.2746582031, -1670.1817626953, 447.12725830078, 0, 70)
		triggerServerEvent("spawnPlayerValentine",localPlayer,x,y,z)
	end
end
addEvent("ValentinesDay.OpenMenu", true)
addEventHandler("ValentinesDay.OpenMenu", root, ValentinesDay.OpenMenu)

function ValentinesDay.Click(button, state, absoluteX, absoluteY)
	if(ValentinesDay.MenuOpen == true)then
		if(button == "left" and state == "down")then
			if(isMouseInPosition(scaleX(10), scaleY(798), scaleW(336), scaleH(47)))then -- // Close
				ValentinesDay.Close()
			end
			if(isMouseInPosition(scaleX(10), scaleY(741), scaleW(336), scaleH(47)))then -- // Shop
				if(ValentinesDay.ShopOpen == false)then
					addEventHandler("onClientRender", root, ValentinesDay.RenderShop)
					ValentinesDay.ShopOpen = true
					addEventHandler("onClientClick", root, ValentinesDay.ShopItemsClick)
				else
					removeEventHandler("onClientRender", root, ValentinesDay.RenderShop)
					ValentinesDay.ShopOpen = false
					removeEventHandler("onClientClick", root, ValentinesDay.ShopItemsClick)
				end
			end
			if(isMouseInPosition(scaleX(20), scaleY(436), scaleW(316), scaleH(26)))then -- // Quest
				triggerServerEvent("ValentineQuest.startQuest", localPlayer)
			end
			if(isMouseInPosition(scaleX(1579), scaleY(396), scaleW(265), scaleH(24)))then -- // Finish Task
				triggerServerEvent("ValentinesDay.nextLevel", localPlayer)
			end
		end
	end
end

function ValentinesDay.UpdateData(communityProgress, playerEventCoins, questFinished, task, topPlayer)
	ValentinesDay.communityProgress = communityProgress
	ValentinesDay.playerEventCoins = playerEventCoins
	ValentinesDay.questFinished = questFinished
	ValentinesDay.task = task
	ValentinesDay.topPlayer = ""
	for i, v in pairs(topPlayer) do
		if(i == 1) then
			ValentinesDay.topPlayer = v[1] .. " (" .. v[2] .. ")"
		else
			ValentinesDay.topPlayer = ValentinesDay.topPlayer .. "\n" .. v[1] .. " (" .. v[2] .. ")"
		end
	end
end
addEvent("ValentinesDay.UpdateData", true)
addEventHandler("ValentinesDay.UpdateData", root, ValentinesDay.UpdateData)

function ValentinesDay.Close()
	if(isElement(ValentinesDay.Ped1))then
		destroyElement(ValentinesDay.Ped1)
		destroyElement(ValentinesDay.Ped2)
		destroyElement(ValentinesDay.Campfire)
		destroyElement(ValentinesDay.CampfireEffect)
	end
	removeEventHandler("onClientRender", root, ValentinesDay.RenderMenu)
	ValentinesDay.MenuOpen = false
	removeEventHandler("onClientRender", root, ValentinesDay.RenderShop)
	ValentinesDay.ShopOpen = false
	setCameraTarget(localPlayer)
	removeEventHandler("onClientClick",root,ValentinesDay.ShopItemsClick)
	removeEventHandler("onClientClick",root,ValentinesDay.Click)
	HUD.Visible = true
	closeWindow()
	if(not(isPedDead(localPlayer)))then
		triggerServerEvent("spawnPlayerValentine",localPlayer,playerCoordinates[1],playerCoordinates[2],playerCoordinates[3])
	end
end

addEventHandler("onClientPlayerWasted", root, function()
	if(source == localPlayer)then
		ValentinesDay.Close()
	end
end)