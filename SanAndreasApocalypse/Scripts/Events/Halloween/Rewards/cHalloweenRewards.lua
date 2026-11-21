HalloweenRewards = {
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
		[1] = {experience = 5000, money = 2500, candy = 5},
		[2] = {experience = 10000, money = 5000, candy = 10},
		[3] = {experience = 20000, money = 10000, candy = 15},
		[4] = {experience = 30000, money = 15000, candy = 20},
		[5] = {experience = 35000, money = 17500, candy = 25},
		[6] = {experience = 50000, money = 25000, candy = 30},
		[7] = {experience = 65000, money = 32500, candy = 35},
		[8] = {experience = 80000, money = 40000, candy = 40},
		[9] = {experience = 90000, money = 45000, candy = 45},
		[10] = {experience = 115000, money = 57500, candy = 50},
	},
	["SpecialRewards"] = {
		["EN"] = {
			[1] = "Double Experience Coupon (1x)",
			[2] = "Double Money Coupon (1x)",
			[3] = "Pumpkinhead",
			[4] = "Immune to Zombies Coupon (1x)",
			[5] = "Vehicle: Romero (+ Vehicle Slot)",
			[6] = "Double Experience Coupon (2x)",
			[7] = "Double Money Coupon (2x)",
			[8] = "Vehicle: Mr. Whoopee (+ Vehicle Slot)",
			[9] = "Immune to Zombies Coupon (2x)",
			[10] = "Vehicle: Monster 1 (+ Vehicle Slot)",
		},
		["DE"] = {
			[1] = "Doppelte Erfahrungspunkte Coupon (1x)",
			[2] = "Doppeltes Geld Coupon (1x)",
			[3] = "Kürbiskopf",
			[4] = "Immun gegen Zombies Coupon (1x)",
			[5] = "Fahrzeug: Romero (+ Fahrzeugslot)",
			[6] = "Doppelte Erfahrungspunkte Coupon (2x)",
			[7] = "Doppeltes Geld Coupon (2x)",
			[8] = "Fahrzeug: Mr. Whoopee (+ Fahrzeugslot)",
			[9] = "Immun gegen Zombies Coupon (2x)",
			[10] = "Fahrzeug: Monster 1 (+ Fahrzeugslot)",
		},
		["RU"] = {
			[1] = "Купон на двойной опыт (1x)",
			[2] = "Купон на двойные деньги (1x)",
			[3] = "Тыквенная голова",
			[4] = "Купон на иммунитет к зомби (1x)",
			[5] = "Транспорт: Romero (+ слот для транспорта)",
			[6] = "Купон на двойной опыт (2x)",
			[7] = "Купон на двойные деньги (2x)",
			[8] = "Транспорт: Mr. Whoopee (+ слот для транспорта)",
			[9] = "Купон на иммунитет к зомби (2x)",
			[10] = "Транспорт: Monster 1 (+ слот для транспорта)",
		},

		["PT"] = {
			[1] = "Cupom de experiência em dobro (1x)",
			[2] = "Cupom de dinheiro em dobro (1x)",
			[3] = "Cabeça de abóbora",
			[4] = "Cupom de imunidade a zumbis (1x)",
			[5] = "Veículo: Romero (+ vaga de veículo)",
			[6] = "Cupom de experiência em dobro (2x)",
			[7] = "Cupom de dinheiro em dobro (2x)",
			[8] = "Veículo: Mr. Whoopee (+ vaga de veículo)",
			[9] = "Cupom de imunidade a zumbis (2x)",
			[10] = "Veículo: Monster 1 (+ vaga de veículo)",
		},
	},
}

function HalloweenRewards.openWindow()
	if(isWindowOpen())then
        GUIEditor.window[1] = guiCreateWindow(637, 281, 468, 174, getText("CHalloween1"), false)
        setWindowData()
		guiCreateCloseButton()
		
        GUIEditor.button[1] = guiCreateButton(163, 139, 296, 24, getText("CHalloween2"), false, GUIEditor.window[1])
        GUIEditor.edit[1] = guiCreateEdit(63, 139, 90, 24, "", false, GUIEditor.window[1])
        GUIEditor.label[1] = guiCreateLabel(10, 139, 45, 24, getText("CHalloween3"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
        GUIEditor.label[2] = guiCreateLabel(10, 27, 448, 70, "", false, GUIEditor.window[1])
        guiLabelSetHorizontalAlign(GUIEditor.label[2], "center", false)
        GUIEditor.progressbar[1] = guiCreateProgressBar(164, 107, 295, 22, false, GUIEditor.window[1])
        guiProgressBarSetProgress(GUIEditor.progressbar[1], 100)
        GUIEditor.label[3] = guiCreateLabel(164, 107, 294, 22, "", false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[3], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[3], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[3], "center")
		guiLabelSetColor(GUIEditor.label[3],255, 115, 0)
        GUIEditor.label[4] = guiCreateLabel(10, 107, 143, 22, "", false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[4], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[4], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[4], "center")

		triggerServerEvent("HalloweenRewards.updateData",localPlayer)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
			local amount = guiGetText(GUIEditor.edit[1])
			if(#amount >= 1 and amount ~= "" and amount ~= " " and isOnlyNumbers(amount))then
				triggerServerEvent("HalloweenRewards.giveReward",localPlayer,amount)
			end
		end,false)
    end
end

addEvent("HalloweenRewards.updateClientData",true)
addEventHandler("HalloweenRewards.updateClientData",root,function(shopLevel, deliveredPumpkins)
	if(shopLevel + 1 > 10)then
		guiSetText(GUIEditor.label[2],getText("CHalloween6"))
	else
		local experience = HalloweenRewards["Rewards"][shopLevel + 1].experience
		local money = HalloweenRewards["Rewards"][shopLevel + 1].money
		local candy = HalloweenRewards["Rewards"][shopLevel + 1].candy
		local special = HalloweenRewards["SpecialRewards"][apocalypseGetElementData(localPlayer,"language") or "EN"][shopLevel + 1]
		local progress = (deliveredPumpkins / HalloweenRewards["Costs"][shopLevel + 1]) * 100
		guiProgressBarSetProgress(GUIEditor.progressbar[1], progress)
		
		guiSetText(GUIEditor.label[2],getText("CHalloween4"):format(experience,money,candy,special))
		guiSetText(GUIEditor.label[3],deliveredPumpkins.."/"..HalloweenRewards["Costs"][shopLevel + 1])
		guiSetText(GUIEditor.label[4],getText("CHalloween5"):format(shopLevel+1))
	end
end)