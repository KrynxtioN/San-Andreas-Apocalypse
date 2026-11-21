WeaponFactory = {
	["Name"] = {
		["EN"] = {
			[1] = "Ammo: Handguns",
			[2] = "Ammo: Submachine Guns",
			[3] = "Ammo: Assault Rifles",
			[4] = "Ammo: Rifles",
		},
		["DE"] = {
			[1] = "Munition: Pistolen",
			[2] = "Munition: Maschinenpistolen",
			[3] = "Munition: Sturmgewehre",
			[4] = "Munition: Gewehre",
		},
		["RU"] = {
			[1] = "Патроны: Пистолеты",
			[2] = "Патроны: ПП",
			[3] = "Патроны: Штурмовые винтовки",
			[4] = "Патроны: Винтовки",
		},
		["PT"] = {
			[1] = "Munição: Pistolas",
			[2] = "Munição: Submetralhadoras",
			[3] = "Munição: Rifles de Assalto",
			[4] = "Munição: Rifles",
		},
	},
	["Costs"] = {
		[1] = 1,
		[2] = 2,
		[3] = 2,
		[4] = 4,
	},
}
WeaponFactory.Pickup = createPickup(1986.6683349609,2630.7651367188,10.942952156067,3,1239,50)
WeaponFactory.currentIndex = 1
WeaponFactory.amount = 1

addEventHandler("onClientPickupHit",WeaponFactory.Pickup,function(player)
	if(player == localPlayer)then
		if(getElementDimension(localPlayer) == getElementDimension(source))then
			WeaponFactory.openWindow()
		end
	end
end)

function WeaponFactory.updateLabel()
    guiSetText(GUIEditor.label[1], WeaponFactory["Name"][apocalypseGetElementData(localPlayer,"language") or "EN"][WeaponFactory.currentIndex])
    guiSetText(GUIEditor.label[2], getText("CWeaponFactory3"):format(WeaponFactory.Costs[WeaponFactory.currentIndex] * WeaponFactory.amount))
    guiSetText(GUIEditor.edit[1], tostring(WeaponFactory.amount))
end

function WeaponFactory.openWindow()
    if(isWindowOpen())then
        GUIEditor.window[1] = guiCreateWindow(706, 370, 312, 209, getText("CWeaponFactory1"), false)
        setWindowData()
        guiCreateCloseButton()

        GUIEditor.button[1] = guiCreateButton(10, 29, 40, 27, "<<", false, GUIEditor.window[1])
        GUIEditor.label[1] = guiCreateLabel(60, 29, 192, 27, "", false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", true)
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
        GUIEditor.button[2] = guiCreateButton(262, 29, 40, 27, ">>", false, GUIEditor.window[1])
        GUIEditor.button[3] = guiCreateButton(10, 171, 292, 28, getText("CWeaponFactory2"), false, GUIEditor.window[1])
        GUIEditor.button[4] = guiCreateButton(10, 66, 79, 25, "-", false, GUIEditor.window[1])
        GUIEditor.button[5] = guiCreateButton(223, 66, 79, 25, "+", false, GUIEditor.window[1])
        GUIEditor.edit[1] = guiCreateEdit(99, 66, 114, 25, "", false, GUIEditor.window[1])
        guiEditSetReadOnly(GUIEditor.edit[1], true)
        GUIEditor.label[2] = guiCreateLabel(10, 101, 292, 27, "", false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[2], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[2], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[2], "center")
		
        WeaponFactory.updateLabel()

        addEventHandler("onClientGUIClick", GUIEditor.button[1], function()
            WeaponFactory.currentIndex = WeaponFactory.currentIndex - 1
            if WeaponFactory.currentIndex < 1 then
                WeaponFactory.currentIndex = #WeaponFactory.Name.EN
            end
            WeaponFactory.updateLabel()
        end, false)

        addEventHandler("onClientGUIClick", GUIEditor.button[2], function()
            WeaponFactory.currentIndex = WeaponFactory.currentIndex + 1
            if WeaponFactory.currentIndex > #WeaponFactory.Name.EN then
                WeaponFactory.currentIndex = 1
            end
            WeaponFactory.updateLabel()
        end, false)

        addEventHandler("onClientGUIClick", GUIEditor.button[4], function()
            WeaponFactory.amount = math.max(1, WeaponFactory.amount - 1)
            WeaponFactory.updateLabel()
        end, false)

        addEventHandler("onClientGUIClick", GUIEditor.button[5], function()
            WeaponFactory.amount = WeaponFactory.amount + 1
            WeaponFactory.updateLabel()
        end, false)

        addEventHandler("onClientGUIClick", GUIEditor.button[3], function()
            triggerServerEvent("WeaponFactory.craft", localPlayer, WeaponFactory.currentIndex, WeaponFactory.amount)
        end, false)
    end
end