Money_Transporter = {
	marker = nil,
	vehicles = {}
}

function Money_Transporter.createMarker(x, y, z)
	Money_Transporter.destroyMarker()
	Money_Transporter.marker = createBlip(x, y, z, 51, 0, 0, 0, 255)
end
addEvent("Money_Transporter.createMarker", true)
addEventHandler("Money_Transporter.createMarker", root, Money_Transporter.createMarker)

function Money_Transporter.destroyMarker()
	if isElement(Money_Transporter.marker) then
		destroyElement(Money_Transporter.marker)
	end
	Money_Transporter.marker = nil
end
addEvent("Money_Transporter.destroyMarker", true)
addEventHandler("Money_Transporter.destroyMarker", root, Money_Transporter.destroyMarker)

addEvent("Money_Transporter.fullSync", true)
addEvent("Money_Transporter.syncAdd", true)
addEvent("Money_Transporter.syncUpdate", true)
addEvent("Money_Transporter.syncRemove", true)

local function formatRemainingTime(seconds)
	if seconds < 0 then seconds = 0 end
	local minutes = math.floor(seconds / 60)
	local secs = seconds % 60
	return string.format("%02d:%02d", minutes, secs)
end

local function applyVehicleData(data)
	if type(data) ~= "table" then return end
	if not isElement(data.vehicle) then return end

	Money_Transporter.vehicles[data.vehicle] = {
		started = data.started or false,
		burnAt = data.burnAt or false,
		moneybags = tonumber(data.moneybags) or 0
	}
end

addEventHandler("Money_Transporter.fullSync", resourceRoot, function(list)
	Money_Transporter.vehicles = {}

	if type(list) ~= "table" then return end

	for _, data in ipairs(list) do
		applyVehicleData(data)
	end
end)

addEventHandler("Money_Transporter.syncAdd", resourceRoot, function(data)
	applyVehicleData(data)
end)

addEventHandler("Money_Transporter.syncUpdate", resourceRoot, function(data)
	applyVehicleData(data)
end)

addEventHandler("Money_Transporter.syncRemove", resourceRoot, function(vehicle)
	Money_Transporter.vehicles[vehicle] = nil
end)

addEventHandler("onClientElementDestroy", root, function()
	if Money_Transporter.vehicles[source] then
		Money_Transporter.vehicles[source] = nil
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
	triggerServerEvent("Money_Transporter.requestSync", resourceRoot)
end)

addEventHandler("onClientRender", root, function()
	local now = getRealTime().timestamp
	local lx, ly, lz = getElementPosition(localPlayer)

	for vehicle, data in pairs(Money_Transporter.vehicles) do
		if isElement(vehicle) then
			local x, y, z = getElementPosition(vehicle)
			local dist = getDistanceBetweenPoints3D(lx, ly, lz, x, y, z)

			if dist <= 15 then
				local sx, sy = getScreenFromWorldPosition(x, y, z + 1.8)

				if sx and sy then
					local text

					if data.started == true and type(data.burnAt) == "number" and data.burnAt > now then
						local remain = data.burnAt - now
						text = getText("CMoneyTransporter2"):format(formatRemainingTime(remain))
							.. "\n" ..
							getText("CMoneyTransporter4"):format(data.moneybags) .. "/5"
					else
						text = getText("CMoneyTransporter4"):format(data.moneybags) .. "/5"
					end

					dxDrawText(
						text,
						sx + 1, sy + 1, sx + 1, sy + 1,
						tocolor(0, 0, 0, 220),
						1.2,
						"default-bold",
						"center",
						"center"
					)

					dxDrawText(
						text,
						sx, sy, sx, sy,
						tocolor(255, 180, 80, 255),
						1.2,
						"default-bold",
						"center",
						"center"
					)
				end
			end
		else
			Money_Transporter.vehicles[vehicle] = nil
		end
	end
end)