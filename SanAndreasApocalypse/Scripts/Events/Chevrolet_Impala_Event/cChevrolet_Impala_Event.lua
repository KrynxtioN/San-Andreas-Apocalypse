Chevrolet_Impala_Event = {
	["Shop_Items"] = {
		["DE"] = {
			{"Fahrzeugslot",2500,1},
			{"Fahrzeug: Chevrolet Impala 67",7500,2},
			{"Status: Impala 67",1000,3},
			{"Ein Foto des ersten Chevrolet Impala 67",1000,4},
		},
		["EN"] = {
			{"Vehicle slot",2500,1},
			{"Vehicle: Chevrolet Impala 67",7500,2},
			{"Status: Impala 67",1000,3},
			{"A photo of the first Chevrolet Impala 67",1000,4},
		},
		["PT"] = {
			{"Vaga de veículo",2500,1},
			{"Veículo: Chevrolet Impala 67",7500,2},
			{"Status: Impala 67",1000,3},
			{"Uma foto do primeiro Chevrolet Impala 67",1000,4},
		},
		["RU"] = {
			{"Слот для транспорта",2500,1},
			{"Транспорт: Chevrolet Impala 67",7500,2},
			{"Статус: Impala 67",1000,3},
			{"Фото первого Chevrolet Impala 67",1000,4},
		},
	},
}

local txd = engineLoadTXD("Files/Mods/Vehicles/elegy.txd")
engineImportTXD(txd, 562)
local dff = engineLoadDFF("Files/Mods/Vehicles/elegy.dff", 562)
engineReplaceModel(dff, 562)

Chevrolet_Impala_Event.Vehicle = createVehicle(562,1460.2568359375,-1697.103515625,15.633700370789,0,0,0)
setElementFrozen(Chevrolet_Impala_Event.Vehicle,true)
setVehicleLocked(Chevrolet_Impala_Event.Vehicle,true)
setVehicleDamageProof(Chevrolet_Impala_Event.Vehicle,true)
setVehicleColor(Chevrolet_Impala_Event.Vehicle,0,0,0)

addEventHandler("onClientRender",root,function()
	local rx,ry,rz = getElementRotation(Chevrolet_Impala_Event.Vehicle)
	setElementRotation(Chevrolet_Impala_Event.Vehicle,rx,ry,rz+1)
end)


function Chevrolet_Impala_Event.openWindow_1()
	if(isWindowOpen())then
        GUIEditor.window[1] = guiCreateWindow(661, 480, 300, 159, getText("CImpalaEvent1"), false)
        setWindowData()
		guiCreateCloseButton()

        GUIEditor.label[1] = guiCreateLabel(10, 26, 280, 31, getText("CImpalaEvent2"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", true)
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
        GUIEditor.label[2] = guiCreateLabel(10, 80, 280, 33, getText("CImpalaEvent3"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[2], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[2], "center", true)
        guiLabelSetVerticalAlign(GUIEditor.label[2], "center")
        GUIEditor.label[3] = guiCreateLabel(10, 63, 280, 17, "________________________________________", false, GUIEditor.window[1])
        GUIEditor.button[1] = guiCreateButton(10, 123, 280, 26, getText("CImpalaEvent6"), false, GUIEditor.window[1])    
		
		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
			triggerServerEvent("Chevrolet_Impala_Event.buyVehicle",localPlayer)
		end,false)
    end
end

function Chevrolet_Impala_Event.openWindow_2()
	if(isWindowOpen())then
        GUIEditor.window[1] = guiCreateWindow(661, 480, 300, 159, getText("CImpalaEvent1"), false)
		setWindowData()
        guiCreateCloseButton()

        GUIEditor.label[1] = guiCreateLabel(10, 26, 280, 31, getText("CImpalaEvent2"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", true)
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
        GUIEditor.label[2] = guiCreateLabel(10, 80, 280, 33, getText("CImpalaEvent4"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[2], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[2], "center", true)
        guiLabelSetVerticalAlign(GUIEditor.label[2], "center")
        GUIEditor.label[3] = guiCreateLabel(10, 63, 280, 17, "________________________________________", false, GUIEditor.window[1])
        GUIEditor.button[1] = guiCreateButton(10, 123, 280, 26, getText("CImpalaEvent6"), false, GUIEditor.window[1])    
		
		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
			triggerServerEvent("Chevrolet_Impala_Event.buyVehicleSlot",localPlayer)
		end,false)
    end
end

function Chevrolet_Impala_Event.openWindow_3()
	if(isWindowOpen())then
        GUIEditor.window[1] = guiCreateWindow(661, 480, 300, 159, getText("CImpalaEvent1"), false)
		setWindowData()
        guiCreateCloseButton()

        GUIEditor.label[1] = guiCreateLabel(10, 26, 280, 31, getText("CImpalaEvent2"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", true)
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
        GUIEditor.label[2] = guiCreateLabel(10, 80, 280, 33, getText("CImpalaEvent5"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[2], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[2], "center", true)
        guiLabelSetVerticalAlign(GUIEditor.label[2], "center")
        GUIEditor.label[3] = guiCreateLabel(10, 63, 280, 17, "________________________________________", false, GUIEditor.window[1])
        GUIEditor.button[1] = guiCreateButton(10, 123, 280, 26, getText("CImpalaEvent6"), false, GUIEditor.window[1])    
		
		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
			triggerServerEvent("Chevrolet_Impala_Event.buyStatus",localPlayer)
		end,false)
    end
end