Warehouse = {}

Warehouse.PlayerMarkerID = nil
Warehouse.Marker = {
    {-154.26930236816,1111.1391601562,18.792200088501},
	{2250.2631835938,-84.774597167969,25.537700653076},
	{-1837.1136474609,-171.93051147461,9.2011976242065},
	{-2167.2492675781,43.072452545166,35.171875},
}

Warehouse.ActiveVehicles = {}
Warehouse.RenderActive = false

local function formatTime(sec)
    if sec < 0 then sec = 0 end
    local m = math.floor(sec / 60)
    local s = sec % 60
    return string.format("%02d:%02d", m, s)
end

addEvent("Warehouse.addVehicle", true)
addEventHandler("Warehouse.addVehicle", root, function(vehicle, expireAt)
    if not isElement(vehicle) then return end

    Warehouse.ActiveVehicles[vehicle] = expireAt

    if not Warehouse.RenderActive then
        addEventHandler("onClientRender", root, function()
            local now = getRealTime().timestamp

            for vehicle, expireAt in pairs(Warehouse.ActiveVehicles) do
                if isElement(vehicle) then
                    local x, y, z = getElementPosition(vehicle)
                    local sx, sy = getScreenFromWorldPosition(x, y, z + 3.75)
					if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(localPlayer)) <= 15)then
						if sx and sy then
							local remaining = expireAt - now
							local text = getText("CMoneyTransporter2"):format(formatTime(remaining))

							dxDrawText(text, sx+1, sy+1, sx, sy, tocolor(0,0,0,200), 1.2, "default-bold", "center", "center")
							dxDrawText(text, sx, sy, sx, sy, tocolor(255, 180, 80,255), 1.2, "default-bold", "center", "center")
						end
					end
                else
                    Warehouse.ActiveVehicles[vehicle] = nil
                end
            end
        end)
        Warehouse.RenderActive = true
    end
end)

addEvent("Warehouse.removeVehicle", true)
addEventHandler("Warehouse.removeVehicle", root, function(vehicle)
    Warehouse.ActiveVehicles[vehicle] = nil
end)

function Warehouse.createWindow()
    if isWindowOpen() then
		if(tonumber(apocalypseGetElementData(localPlayer,"colony")) >= 1)then
			Warehouse.Costs = 150
			Warehouse.SelectedCrates = 1

			GUIEditor.window[1] = guiCreateWindow(727, 449, 359, 185, "", false)
			setWindowData()
			guiCreateCloseButton()

			GUIEditor.label[1] = guiCreateLabel(10, 27, 339, 87, getText("CWarehouse1"), false, GUIEditor.window[1])
			guiSetFont(GUIEditor.label[1], "default-bold-small")
			guiLabelSetHorizontalAlign(GUIEditor.label[1], "left", true)
			guiLabelSetVerticalAlign(GUIEditor.label[1], "center")

			GUIEditor.scrollbar[1] = guiCreateScrollBar(10, 124, 339, 14, true, false, GUIEditor.window[1])
			guiScrollBarSetScrollPosition(GUIEditor.scrollbar[1], 0)

			GUIEditor.button[1] = guiCreateButton(11, 148, 338, 27,
				getText("CWarehouse2"):format(Warehouse.Costs, Warehouse.SelectedCrates), false, GUIEditor.window[1])

			local function updateStepFromScrollbar()
				local pos = guiScrollBarGetScrollPosition(GUIEditor.scrollbar[1])
				local step = math.min(8, math.floor(pos / (100 / 8)) + 1)

				Warehouse.SelectedCrates = step
				Warehouse.Costs = step * 150

				guiSetText(GUIEditor.button[1], getText("CWarehouse2"):format(Warehouse.Costs, step))
			end

			addEventHandler("onClientGUIScroll", GUIEditor.scrollbar[1], updateStepFromScrollbar, false)

			addEventHandler("onClientGUIClick", GUIEditor.button[1], function()
				triggerServerEvent("Warehouse.start", localPlayer, Warehouse.Costs, Warehouse.SelectedCrates)
			end, false)

			NPC.NormalMessage(getText("CWarehouse3"))
		else
			NPC.NormalMessage(getText("CWarehouse4"))
		end
    end
end
addEvent("Warehouse.createWindow", true)
addEventHandler("Warehouse.createWindow", root, Warehouse.createWindow)

function Warehouse.createMarker(deliveryPoint)
    if isElement(Warehouse.DeliveryMarker) then destroyElement(Warehouse.DeliveryMarker) end
    if isElement(Warehouse.blip) then destroyElement(Warehouse.blip) end
    Warehouse.PlayerMarkerID = deliveryPoint
    local tbl = Warehouse.Marker[Warehouse.PlayerMarkerID]
    Warehouse.DeliveryMarker = createMarker(tbl[1],tbl[2],tbl[3],"cylinder",5,200,200,0,175)
    Warehouse.blip = createBlip(tbl[1],tbl[2],tbl[3], 51, 0, 0, 0, 255)

    addEventHandler("onClientMarkerHit", Warehouse.DeliveryMarker, function(hitElement)
        if hitElement == localPlayer then
            triggerServerEvent("Warehouse.delivery", localPlayer)
        end
    end)
end
addEvent("Warehouse.createMarker", true)
addEventHandler("Warehouse.createMarker", root, Warehouse.createMarker)

function Warehouse.destroy()
    if isElement(Warehouse.DeliveryMarker) then destroyElement(Warehouse.DeliveryMarker) end
    if isElement(Warehouse.blip) then destroyElement(Warehouse.blip) end
end
addEvent("Warehouse.destroy", true)
addEventHandler("Warehouse.destroy", root, Warehouse.destroy)

function Warehouse.reset()
    Warehouse.PlayerMarkerID = nil
end
addEvent("Warehouse.reset", true)
addEventHandler("Warehouse.reset", root, Warehouse.reset)