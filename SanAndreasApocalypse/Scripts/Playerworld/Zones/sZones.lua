Zones = {
	rectangle = {},
	area = {},
	playerKillTimer = {},
	playerSeconds = {},
	playerDamageTimer = {},

	["ZoneLevel"] = {
		[1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0,
		[7] = 0, [8] = 0, [9] = 1, [10] = 0, [11] = 0, [12] = 0,
		[13] = 1, [14] = 0, [15] = 0, [16] = 0, [17] = 0, [18] = 1,
		[19] = 2, [20] = 0, [21] = 0, [22] = 0, [23] = 0, [24] = 0
	},

	BonusZoneIDs = {},
	savedRadarColors = {},
	BonusZoneCount = 2
}

local startX, startY = -3000, -3000
local cols, rows, mapSize = 4, 6, 6000
local zoneWidth, zoneHeight = mapSize / cols, mapSize / rows

local loadedZones = 0
local totalZones = cols * rows

for row = 0, rows - 1 do
	for col = 0, cols - 1 do
		local x = startX + col * zoneWidth
		local y = startY + row * zoneHeight
		loadedZones = loadedZones + 1

		local shade = math.floor(50 + (loadedZones - 5) * (205 / (totalZones - 1)))

		Zones.area[loadedZones] = createRadarArea(x, y, zoneWidth, zoneHeight, shade, shade, shade, 75)
		Zones.rectangle[loadedZones] = createColRectangle(x, y, zoneWidth, zoneHeight)
		apocalypseSetElementData(Zones.rectangle[loadedZones], "ZoneID", loadedZones)

		addEventHandler("onColShapeHit", Zones.rectangle[loadedZones], function(hitElement)
			if getElementType(hitElement) == "player" and isCharacterLoggedIn(hitElement) then
				local ZoneID = apocalypseGetElementData(source, "ZoneID")
				if ZoneID then
					apocalypseSetElementData(hitElement,"InBonusZone",false)
					if Zones.BonusZoneIDs[ZoneID] then
						triggerClientEvent(hitElement, "showBonusZoneLogo", hitElement)
						apocalypseSetElementData(hitElement,"InBonusZone",true)
					end

					Zones.createPlayerWarning(hitElement, source)
					triggerClientEvent(hitElement, "Zones.createZoneName", hitElement, ZoneID)
				end
			end
		end)
	end
end

function Zones.generateBonus()
	for zoneID, _ in pairs(Zones.BonusZoneIDs) do
		local tbl = Zones.savedRadarColors[zoneID]
		if tbl and isElement(Zones.area[zoneID]) then
			setRadarAreaFlashing(Zones.area[zoneID], false)
			setRadarAreaColor(Zones.area[zoneID], tbl[1], tbl[2], tbl[3], tbl[4])
		end
	end

	Zones.BonusZoneIDs = {}
	Zones.savedRadarColors = {}

	local selectedCount = 0
	while selectedCount < Zones.BonusZoneCount do
		local randomZone = math.random(1, totalZones)

		if randomZone ~= 11 and not Zones.BonusZoneIDs[randomZone] then
			Zones.BonusZoneIDs[randomZone] = true

			local r, g, b, a = getRadarAreaColor(Zones.area[randomZone])
			Zones.savedRadarColors[randomZone] = {r, g, b, a}

			setRadarAreaColor(Zones.area[randomZone], 200, 0, 0, 75)
			setRadarAreaFlashing(Zones.area[randomZone], true)

			selectedCount = selectedCount + 1
		end
	end

	setTimer(Zones.generateBonus, 3600000, 1)
end
Zones.generateBonus()

function Zones.isPlayerInBonusZone(player)
	local PlayerZone = tonumber(apocalypseGetElementData(player, "PlayersZone"))
	if PlayerZone and Zones.BonusZoneIDs[PlayerZone] then
		return true
	end
	return false
end

function Zones.createPlayerWarning(player, theZone)
	if getElementDimension(player) == 0 and getElementInterior(player) == 0 then
		if isCharacterLoggedIn(player) then
			if theZone then
				local ZoneID = tonumber(apocalypseGetElementData(theZone, "ZoneID"))
				local SurvivorPassLevel = tonumber(getPlayerData("characters", "ID", getCharacterID(player), "survivorpass_level"))

				if ZoneID and SurvivorPassLevel then
					local ZoneLevel = tonumber(Zones["ZoneLevel"][ZoneID])
					apocalypseSetElementData(player, "PlayersZone", ZoneID)

					if ZoneID == 11 then
						Zones.destroyPlayerEverything(player)
					else
						if tonumber(getPlayerData("character_stats", "character_id", getCharacterID(player), "survivor_pass_abo")) == 1 then
							Zones.destroyPlayerEverything(player)
							return
						end

						if hasPlayerItem(player, 24) == 0 or not (SurvivorPassLevel >= ZoneLevel) then
							if tonumber(getPlayerData("character_stats", "character_id", getCharacterID(player), "survivor_pass_abo")) == 0 then
								if not apocalypseGetElementData(player, "TeleportInInterior") or apocalypseGetElementData(player, "TeleportInInterior") == false then
									if not isTimer(Zones.playerKillTimer[player]) then
										Zones.playerSeconds[player] = 10
										triggerClientEvent(player, "Zones.createWarning", player, Zones.playerSeconds[player])

										Zones.playerKillTimer[player] = setTimer(function(player)
											Zones.playerSeconds[player] = Zones.playerSeconds[player] - 1
											triggerClientEvent(player, "Zones.updateSeconds", player, Zones.playerSeconds[player])

											if Zones.playerSeconds[player] == 0 then
												Zones.playerDamageTimer[player] = setTimer(function(player)
													setElementHealth(player, getElementHealth(player) - 5)
												end, 1000, 0, player)
											end
										end, 1000, 0, player)
									end
								end
							else
								Zones.destroyPlayerEverything(player)
							end
						else
							Zones.destroyPlayerEverything(player)
						end
					end
				end
			end
		end
	end
end

function Zones.destroyPlayerEverything(player)
	if not player then
		player = client
	end

	if isTimer(Zones.playerKillTimer[player]) then
		killTimer(Zones.playerKillTimer[player])
	end
	if isTimer(Zones.playerDamageTimer[player]) then
		killTimer(Zones.playerDamageTimer[player])
	end

	Zones.playerSeconds[player] = 0
	triggerClientEvent(player, "Zones.destroyWarning", player)
end
addEvent("Zones.destroyPlayerEverything", true)
addEventHandler("Zones.destroyPlayerEverything", root, Zones.destroyPlayerEverything)

addEventHandler("onPlayerWasted", root, function()
	Zones.destroyPlayerEverything(source)
end)