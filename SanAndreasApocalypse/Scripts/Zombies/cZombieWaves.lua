local function formatTime(seconds)
	seconds = math.max(0, math.floor(seconds or 0))
	local m = math.floor(seconds / 60)
	local s = seconds % 60
	return string.format("%02d:%02d", m, s)
end

local function drawWaveMarkerInfo()
	local px, py, pz = getElementPosition(localPlayer)

	for _, marker in ipairs(getElementsByType("marker", root, true)) do
		if (isElement(marker) and getElementData(marker, "wave:isWaveMarker") == true) then
			if (getElementInterior(marker) == getElementInterior(localPlayer) and getElementDimension(marker) == getElementDimension(localPlayer)) then
				local mx, my, mz = getElementPosition(marker)
				local dist = getDistanceBetweenPoints3D(px, py, pz, mx, my, mz)

				if (dist <= 25) then
					local sx, sy = getScreenFromWorldPosition(mx, my, mz + 1.5)
					if (sx and sy) then
						local state = getElementData(marker, "wave:state") or "bereit"
						local active = getElementData(marker, "wave:active") == true
						local wave = tonumber(getElementData(marker, "wave:wave")) or 0
						local alive = tonumber(getElementData(marker, "wave:alive")) or 0
						local total = tonumber(getElementData(marker, "wave:total")) or 0
						local timeLeft = tonumber(getElementData(marker, "wave:timeLeft")) or 0
						local cooldownUntil = tonumber(getElementData(marker, "wave:cooldownUntil")) or 0

						local text = getText("CZombieWaves1")
						local r, g, b = 255, 255, 255

						if (active) then
							if (state == "pause") then
								r, g, b = 255, 220, 80
								text = text .. getText("CZombieWaves2")
								text = text .. getText("CZombieWaves3"):format(wave)
								text = text .. getText("CZombieWaves4"):format(formatTime(timeLeft))
							else
								r, g, b = 50, 255, 50
								text = text .. getText("CZombieWaves5")
								text = text .. getText("CZombieWaves6"):format(wave)
								text = text .. getText("CZombieWaves7"):format(alive,total)
								text = text .. getText("CZombieWaves8"):format(formatTime(timeLeft))
							end
						else
							if (state == "cooldown") then
								r, g, b = 255, 120, 120
								local left = math.max(0, cooldownUntil - getRealTime().timestamp)
								text = text .. getText("CZombieWaves9")
								text = text .. getText("CZombieWaves10"):format(formatTime(left))
							else
								r, g, b = 180, 220, 255
								text = text .. getText("CZombieWaves11")
								text = text .. getText("CZombieWaves12")
							end
						end

						dxDrawText(
							text,
							sx + 1, sy + 1, sx + 1, sy + 1,
							tocolor(0, 0, 0, 200),
							1.2, "default-bold", "center", "center", false, false, false, true
						)

						dxDrawText(
							text,
							sx, sy, sx, sy,
							tocolor(r, g, b, 235),
							1.2, "default-bold", "center", "center", false, false, false, true
						)
					end
				end
			end
		end
	end
end
addEventHandler("onClientRender", root, drawWaveMarkerInfo)