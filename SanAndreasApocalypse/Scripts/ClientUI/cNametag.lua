nameTagRange = 20
nameSphere = createColSphere(0, 0, 0, nameTagRange)

nameTagPlayers = {}
nameTagVisible = {}
nameTagHP = {}
nameTagImages = {}
nameTagAimTarget = localPlayer

local showOwnNameTagTest = false
local badgeTextures = {}

local players = getElementsByType("player")
for key, index in pairs(players) do
	setPlayerNametagShowing(index, false)
end

addEventHandler("onClientPlayerJoin", root, function()
	setPlayerNametagShowing(source, false)
end)

function getBadgeImagePath(id)
	id = tonumber(id)
	if not id then return nil end

	if Badges and Badges["Data"] and Badges["Data"]["EN"] and Badges["Data"]["EN"][id] then
		return Badges["Data"]["EN"][id][3]
	end

	if Badges and Badges["Data"] and Badges["Data"]["DE"] and Badges["Data"]["DE"][id] then
		return Badges["Data"]["DE"][id][3]
	end

	return nil
end

function getBadgeTexture(id)
	id = tonumber(id)
	if not id or id <= 0 then return nil end

	if badgeTextures[id] and isElement(badgeTextures[id]) then
		return badgeTextures[id]
	end

	local path = getBadgeImagePath(id)
	if not path then return nil end

	badgeTextures[id] = dxCreateTexture(path)
	return badgeTextures[id]
end

function getPlayerEquippedBadgeID(player)
	local badgeID = tonumber(getElementData(player, "equippedBadge")) or tonumber(apocalypseGetElementData(player, "equippedBadge")) or 0
	return badgeID
end

function getPlayerEquippedBadgeImage(player)
	local badgeID = getPlayerEquippedBadgeID(player)

	if badgeID <= 0 then
		return nil
	end

	return getBadgeTexture(badgeID)
end

function drawPlayerNameTag(player, sx, sy)
	local r, g, b = calcRGBByHP(player)

	local name = getPlayerName(player)
	local status = apocalypseGetElementData(player, "statusName") or ""
	local level = apocalypseGetElementData(player, "level") or getElementData(player, "level") or 0
	local armor = math.floor(getPedArmor(player))
	local nametag = ""

	if (tonumber(apocalypseGetElementData(player, "adminlevel")) or 0) >= 1 then
		nametag = "[SAA]"

		if apocalypseGetElementData(player, "AFK") == true then
			nametag = "[AFK][SAA]"
		end
	else
		if apocalypseGetElementData(player, "AFK") == true then
			nametag = "[AFK]"
		end
	end

	local badge = getPlayerEquippedBadgeImage(player)
	local text = nametag..name.."#ffffff[#f6ff00"..level.."#ffffff]"

	if badge then
		dxDrawImage(sx - 32, sy - 85, 80, 80, badge, 0, 0, 0, tocolor(255, 255, 255, 255), false)
	end

	dxDrawText(text, sx, sy, sx, sy, tocolor(0, 0, 0, 255), 1, "bankgothic", "center", "center", false, false, false, true)
	dxDrawText(text, sx - 2, sy - 2, sx, sy, tocolor(r, g, b, 255), 1, "bankgothic", "center", "center", false, false, false, true)

	dxDrawText(status, sx, sy + 30, sx, sy, tocolor(190, 190, 190, 255), 0.5, "bankgothic", "center", "center")
	dxDrawText(status, sx - 2, sy - 1 + 30, sx, sy, tocolor(190, 190, 190, 255), 0.5, "bankgothic", "center", "center")

	if HUD["Data"].ExtraArmor >= 1 then
		dxDrawText(HUD["Data"].ExtraArmor.."%", sx - 2, sy + 73, sx, sy, tocolor(255,255,255,255), 0.8, "default-bold", "center", "center", false, false, true, false, false)
		dxDrawRectangle(sx - 70, sy + 28, 137, 16, tocolor(105, 79, 8, 255), false)
		dxDrawRectangle(sx - 70, sy + 28, 1.37 * armor, 16, tocolor(237, 178, 17, 255), false)
	else
		if armor > 0 then
			dxDrawText(armor.."%", sx - 2, sy + 73, sx, sy, tocolor(255,255,255,255), 0.8, "default-bold", "center", "center", false, false, true, false, false)
			dxDrawRectangle(sx - 70, sy + 28, 137, 16, tocolor(0, 8, 13, 255), false)
			dxDrawRectangle(sx - 70, sy + 28, 1.37 * armor, 16, tocolor(0, 41, 67, 255), false)
		end
	end
end

function nameTagSpawn()
	detachElements(nameSphere)

	if isElement(localPlayer) then
		attachElements(nameSphere, localPlayer)
	end
end
setTimer(nameTagSpawn, 500, 0)

function nameTagSphereHit(element, dim)
	if getElementType(element) == "player" and not(element == localPlayer) then
		nameTagPlayers[element] = true
		nameTagImages[element] = {}
		nameTagCheckPlayerSight(element)
	end
end
addEventHandler("onClientColShapeHit", nameSphere, nameTagSphereHit)

function nameTagCheckPlayerSight(player)
	if isElement(player) then
		local x1, y1, z1 = getPedBonePosition(player, 8)
		local x2, y2, z2 = getPedBonePosition(localPlayer, 8)
		local hit = processLineOfSight(x1, y1, z1, x2, y2, z2, true, false, false, true, false)

		nameTagVisible[player] = not hit

		if nameTagVisible[player] then
			nameTagHP[player] = getElementHealth(player)
		end

		if not nameTagImages[player] then
			nameTagImages[player] = {}
		end
	else
		nameTagPlayers[player] = nil
		nameTagVisible[player] = nil
		nameTagHP[player] = nil
	end
end

function nameTagSphereLeave(element)
	nameTagPlayers[element] = nil
	nameTagVisible[element] = nil
	nameTagHP[element] = nil
end
addEventHandler("onClientColShapeLeave", nameSphere, nameTagSphereLeave)

function nameTagRender()
	if isCharacterLoggedIn() then
		for key, index in pairs(nameTagVisible) do
			if isElement(key) then
				if nameTagVisible[key] then
					if getElementDimension(key) == getElementDimension(localPlayer) then
						local x, y, z = getElementPosition(key)

						if x and y and z then
							local screenX, screenY = getScreenFromWorldPosition(x, y, z + 1.1, 1000, true)

							if screenX and screenY then
								if isWindowOpen() then
									drawPlayerNameTag(key, screenX, screenY)
								end
							end
						end
					end
				end
			else
				nameTagCheckPlayerSight(key)
			end
		end

		if showOwnNameTagTest then
			local x, y, z = getElementPosition(localPlayer)
			local screenX, screenY = getScreenFromWorldPosition(x, y, z + 1.1, 1000, true)

			if screenX and screenY then
				drawPlayerNameTag(localPlayer, screenX, screenY)
			end
		end
	end
end
addEventHandler("onClientRender", root, nameTagRender)

function RGBToHex(red, green, blue, alpha)
	if ((red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255) or (alpha and (alpha < 0 or alpha > 255))) then
		return nil
	end

	if alpha then
		return string.format("#%.2X%.2X%.2X%.2X", red, green, blue, alpha)
	else
		return string.format("#%.2X%.2X%.2X", red, green, blue)
	end
end

function calcRGBByHP(player)
	local hp = getElementHealth(player)

	if hp <= 0 then
		return 0, 0, 0
	else
		hp = math.abs(hp - 0.01)
		return (100 - hp) * 2.55 / 2, hp * 2.55, 0
	end
end

function reCheckNameTag()
	if isElement(getCameraTarget()) then
		detachElements(nameSphere)
		attachElements(nameSphere, getCameraTarget())
	end

	setElementInterior(nameSphere, getElementInterior(localPlayer))
	setElementDimension(nameSphere, getElementDimension(localPlayer))

	for key, index in pairs(nameTagPlayers) do
		nameTagCheckPlayerSight(key)
	end
end
setTimer(reCheckNameTag, 500, 0)

addEventHandler("onClientResourceStop", resourceRoot, function()
	for _, texture in pairs(badgeTextures) do
		if isElement(texture) then
			destroyElement(texture)
		end
	end
end)