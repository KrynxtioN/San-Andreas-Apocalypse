local function formatTime(seconds)
	seconds = math.max(0, math.floor(seconds or 0))

	local m = math.floor(seconds / 60)
	local s = seconds % 60

	return string.format("%02d:%02d", m, s)
end

local function drawSpecialAirdropInfo()
	local px, py, pz = getElementPosition(localPlayer)

	for _, col in ipairs(getElementsByType("colshape", root, true)) do
		if isElement(col) and getElementData(col, "specialAirdrop:isSpecialAirdrop") == true then
			if getElementData(col, "specialAirdrop:showInfo") == true then
				if getElementInterior(col) == getElementInterior(localPlayer) and getElementDimension(col) == getElementDimension(localPlayer) then
					local x, y, z = getElementPosition(col)
					local dist = getDistanceBetweenPoints3D(px, py, pz, x, y, z)

					if dist <= 30 then
						local sx, sy = getScreenFromWorldPosition(x, y, z + 2.0)

						if sx and sy then
							local state = getElementData(col, "specialAirdrop:state") or "bereit"
							local active = getElementData(col, "specialAirdrop:active") == true
							local locked = getElementData(col, "specialAirdrop:locked") == true
							local lootReady = getElementData(col, "specialAirdrop:lootReady") == true

							local wave = tonumber(getElementData(col, "specialAirdrop:wave")) or 0
							local alive = tonumber(getElementData(col, "specialAirdrop:alive")) or 0
							local total = tonumber(getElementData(col, "specialAirdrop:total")) or 0
							local timeLeft = tonumber(getElementData(col, "specialAirdrop:timeLeft")) or 0

							local text = "#FF5050" .. getText("CSpecialAirdrop1") .. "\n"
							local r, g, b = 255, 255, 255

							if active then
								if state == "pause" then
									r, g, b = 255, 220, 80

									text = text .. "#FFFFFF" .. getText("CSpecialAirdrop2") .. ": #FFDC50" .. getText("CSpecialAirdrop3") .. "\n"
									text = text .. "#FFFFFF" .. getText("CSpecialAirdrop4") .. ": #FFDC50" .. wave .. "\n"
									text = text .. "#FFFFFF" .. getText("CSpecialAirdrop5") .. ": #FFDC50" .. formatTime(timeLeft)
								else
									r, g, b = 80, 255, 80

									text = text .. "#FFFFFF" .. getText("CSpecialAirdrop2") .. ": #50FF50" .. getText("CSpecialAirdrop6") .. "\n"
									text = text .. "#FFFFFF" .. getText("CSpecialAirdrop7") .. ": #50FF50" .. wave .. "\n"
									text = text .. "#FFFFFF" .. getText("CSpecialAirdrop8"):format(alive, total) .. "\n"
									text = text .. "#FFFFFF" .. getText("CSpecialAirdrop9") .. ": #50FF50" .. formatTime(timeLeft)
								end
							elseif lootReady or state == "lootbar" then
								r, g, b = 80, 255, 80

								text = text .. "#FFFFFF" .. getText("CSpecialAirdrop2") .. ": #50FF50" .. getText("CSpecialAirdrop10") .. "\n"
								text = text .. "#FFFFFF" .. getText("CSpecialAirdrop11") .. "\n"
								text = text .. "#FFFFFF" .. getText("CSpecialAirdrop12") .. ": #50FF50" .. formatTime(timeLeft)
							elseif locked then
								r, g, b = 255, 80, 80
								text = text .. "#FFFFFF" .. getText("CSpecialAirdrop2") .. ": #FF5050" .. getText("CSpecialAirdrop13")
							else
								r, g, b = 180, 220, 255

								text = text .. "#FFFFFF" .. getText("CSpecialAirdrop2") .. ": #B4DCFF" .. getText("CSpecialAirdrop14") .. "\n"
								text = text .. "#FFFFFF" .. getText("CSpecialAirdrop15")
							end

							dxDrawText(
								text,
								sx + 1, sy + 1, sx + 1, sy + 1,
								tocolor(0, 0, 0, 220),
								1.2,
								"default-bold",
								"center",
								"center",
								false,
								false,
								false,
								true
							)

							dxDrawText(
								text,
								sx, sy, sx, sy,
								tocolor(r, g, b, 240),
								1.2,
								"default-bold",
								"center",
								"center",
								false,
								false,
								false,
								true
							)
						end
					end
				end
			end
		end
	end
end
addEventHandler("onClientRender", root, drawSpecialAirdropInfo)

bindKey("space", "down", function()
	if getElementData(localPlayer, "SearchingSpecialAirdrop") == true then
		triggerServerEvent("onCancelSpecialAirdropSearch", localPlayer)
	end
end)