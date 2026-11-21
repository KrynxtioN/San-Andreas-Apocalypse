local Circles = {}
Teleportmarker = {}
local markerName = {
	["DE"] = {
		[1] = "Zombie Experimente",
		[2] = "Area 51 Labor",
		[3] = "Dillimore's Hope",
		[4] = "Dillimore's Hope",
		[5] = "Dillimore's Hope Hinterräume",
		[6] = "Dillimore's Hope",
		[7] = "Dillimore's Hope Abstellkammer",
		[8] = "Dillimore's Hope",
		[9] = "Dillimore Tankstelle",
		[10] = "Dillimore",
		[11] = "Dillimore Polizeipräsidium",
		[12] = "Dillimore",
		[13] = "Dillimore Tankstelle Hinterräume",
		[14] = "Dillimore",
		[15] = "Versteck des Mechanikers",
		[16] = "Dillimore's Hope Hinterräume",
		[17] = "Survivor Pass",
		[18] = "Dillimore",
		[19] = "Crazy Joe's Haus",
		[20] = "Crazy Joe's Farm",
		[21] = "San Fierro - Reporterbasis",
		[22] = "San Fierro",
		[23] = "Bayside Kirche",
		[24] = "Bayside",
		[25] = "Schießstand",
		[26] = "Dillimore",
		[27] = "Angel Pine - Alte Fabrik",
		[28] = "Angel Pine",
		[29] = "Mine",
		[30] = "Montgomery",
		[31] = "Unbekannter Ort",
		[32] = "San Fierro",
		[33] = "Las Venturas Casino #1",
		[34] = "Las Venturas",
		[35] = "Las Venturas Casino #2",
		[36] = "Las Venturas",
		[37] = "Las Venturas Casino #3",
		[38] = "Las Venturas",
		[39] = "Bigfoot-Gefängnis",
		[40] = "Bigfoot Club",
		[41] = "Bigfoot Clubhaus",
		[42] = "Bigfoot Club",
		[43] = "Haus der Trophäen",
		[44] = "Los Santos",
		[45] = "Palomino Creek",
		[46] = "Keller",
		[47] = "Area 51 Labor",
		[48] = "Area 51",
		[49] = "Fitnessstudio",
		[50] = "Los Santos",
		[51] = "Friseursalon",
		[52] = "Dillimore",
		[53] = "Tattoostudio",
		[54] = "San Fierro",
		[55] = "Textilfabrik",
		[56] = "Las Venturas",
		[57] = "San Fierro Hotel",
		[58] = "San Fierro",
		[59] = "Los Santos Bank",
		[60] = "Bank",
		[61] = "Piraten Insel Versteck #1",
		[62] = "Piraten Insel",
		[63] = "Piraten Insel Versteck #2",
		[64] = "Piraten Insel",
		[65] = "Piraten Insel Versteck #3",
		[66] = "Piraten Insel",
		[67] = "Spinosaurus Club",
		[68] = "San Fierro",
	},
	["EN"] = {
		[1] = "Zombie Experiments",
		[2] = "Area 51 Laboratory",
		[3] = "Dillimore's Hope",
		[4] = "Dillimore's Hope",
		[5] = "Dillimore's Hope Backrooms",
		[6] = "Dillimore's Hope",
		[7] = "Dillimore's Hope Storage Room",
		[8] = "Dillimore's Hope",
		[9] = "Dillimore Gas Station",
		[10] = "Dillimore",
		[11] = "Dillimore Police Department",
		[12] = "Dillimore",
		[13] = "Dillimore Gas Station Backrooms",
		[14] = "Dillimore",
		[15] = "Mechanic's Hideout",
		[16] = "Dillimore's Hope Backrooms",
		[17] = "Survivor Pass",
		[18] = "Dillimore",
		[19] = "Crazy Joe's House",
		[20] = "Crazy Joe's Farm",
		[21] = "San Fierro - Reporter Base",
		[22] = "San Fierro",
		[23] = "Bayside Church",
		[24] = "Bayside",
		[25] = "Shooting Range",
		[26] = "Dillimore",
		[27] = "Angel Pine - Old Factory",
		[28] = "Angel Pine",
		[29] = "Mine",
		[30] = "Montgomery",
		[31] = "Unknown Location",
		[32] = "San Fierro",
		[33] = "Las Venturas Casino #1",
		[34] = "Las Venturas",
		[35] = "Las Venturas Casino #2",
		[36] = "Las Venturas",
		[37] = "Las Venturas Casino #3",
		[38] = "Las Venturas",
		[39] = "Bigfoot Prison",
		[40] = "Bigfoot Club",
		[41] = "Bigfoot Clubhouse",
		[42] = "Bigfoot Club",
		[43] = "House of Trophies",
		[44] = "Los Santos",
		[45] = "Palomino Creek",
		[46] = "Basement",
		[47] = "Area 51 Laboratory",
		[48] = "Area 51",
		[49] = "Gym",
		[50] = "Los Santos",
		[51] = "Barber Shop",
		[52] = "Dillimore",
		[53] = "Tattoo Studio",
		[54] = "San Fierro",
		[55] = "Cloth Factory",
		[56] = "Las Venturas",
		[57] = "San Fierro Hotel",
		[58] = "San Fierro",
		[59] = "Los Santos Bank",
		[60] = "Bank",
		[61] = "Pirate Island Hideout #1",
		[62] = "Pirate Island",
		[63] = "Pirate Island Hideout #2",
		[64] = "Pirate Island",
		[65] = "Pirate Island Hideout #3",
		[66] = "Pirate Island",
		[67] = "Spinosaurus Club",
		[68] = "San Fierro",
	},
	["RU"] = {
		[1] = "Эксперименты с зомби",
		[2] = "Лаборатория Area 51",
		[3] = "Dillimore's Hope",
		[4] = "Dillimore's Hope",
		[5] = "Закулисье Dillimore's Hope",
		[6] = "Dillimore's Hope",
		[7] = "Кладовая Dillimore's Hope",
		[8] = "Dillimore's Hope",
		[9] = "Заправка Dillimore",
		[10] = "Dillimore",
		[11] = "Полицейский участок Dillimore",
		[12] = "Dillimore",
		[13] = "Закулисье заправки Dillimore",
		[14] = "Dillimore",
		[15] = "Укрытие механика",
		[16] = "Закулисье Dillimore's Hope",
		[17] = "Перевал выживших",
		[18] = "Dillimore",
		[19] = "Дом Безумного Джо",
		[20] = "Ферма Безумного Джо",
		[21] = "San Fierro - База репортёров",
		[22] = "San Fierro",
		[23] = "Церковь Bayside",
		[24] = "Bayside",
		[25] = "Тир",
		[26] = "Dillimore",
		[27] = "Angel Pine - Старая фабрика",
		[28] = "Angel Pine",
		[29] = "Шахта",
		[30] = "Montgomery",
		[31] = "Неизвестное место",
		[32] = "San Fierro",
		[33] = "Казино Las Venturas #1",
		[34] = "Las Venturas",
		[35] = "Казино Las Venturas #2",
		[36] = "Las Venturas",
		[37] = "Казино Las Venturas #3",
		[38] = "Las Venturas",
		[39] = "Тюрьма Бигфута",
		[40] = "Клуб Бигфута",
		[41] = "Клубный дом Бигфута",
		[42] = "Клуб Бигфута",
		[43] = "Дом трофеев",
		[44] = "Los Santos",
		[45] = "Palomino Creek",
		[46] = "Подвал",
		[47] = "Лаборатория Area 51",
		[48] = "Area 51",
		[49] = "Спортзал",
		[50] = "Los Santos",
		[51] = "Парикмахерская",
		[52] = "Dillimore",
		[53] = "Тату-студия",
		[54] = "San Fierro",
		[55] = "Текстильная фабрика",
		[56] = "Las Venturas",
		[57] = "Отель San Fierro",
		[58] = "San Fierro",
		[59] = "Банк Los Santos",
		[60] = "Банк",
		[61] = "Укрытие пиратского острова #1",
		[62] = "Пиратский остров",
		[63] = "Укрытие пиратского острова #2",
		[64] = "Пиратский остров",
		[65] = "Укрытие пиратского острова #3",
		[66] = "Пиратский остров",
		[67] = "Клуб Спинозавра",
		[68] = "San Fierro",
	},
	["PT"] = {
		[1] = "Experimentos com Zumbis",
		[2] = "Laboratório Area 51",
		[3] = "Dillimore's Hope",
		[4] = "Dillimore's Hope",
		[5] = "Bastidores de Dillimore's Hope",
		[6] = "Dillimore's Hope",
		[7] = "Depósito de Dillimore's Hope",
		[8] = "Dillimore's Hope",
		[9] = "Posto de Gasolina Dillimore",
		[10] = "Dillimore",
		[11] = "Delegacia de Dillimore",
		[12] = "Dillimore",
		[13] = "Bastidores do posto de Dillimore",
		[14] = "Dillimore",
		[15] = "Esconderijo do Mecânico",
		[16] = "Bastidores de Dillimore's Hope",
		[17] = "Passagem dos Sobreviventes",
		[18] = "Dillimore",
		[19] = "Casa do Crazy Joe",
		[20] = "Fazenda do Crazy Joe",
		[21] = "San Fierro - Base dos Repórteres",
		[22] = "San Fierro",
		[23] = "Igreja de Bayside",
		[24] = "Bayside",
		[25] = "Campo de Tiro",
		[26] = "Dillimore",
		[27] = "Angel Pine - Fábrica Antiga",
		[28] = "Angel Pine",
		[29] = "Mina",
		[30] = "Montgomery",
		[31] = "Local Desconhecido",
		[32] = "San Fierro",
		[33] = "Cassino Las Venturas #1",
		[34] = "Las Venturas",
		[35] = "Cassino Las Venturas #2",
		[36] = "Las Venturas",
		[37] = "Cassino Las Venturas #3",
		[38] = "Las Venturas",
		[39] = "Prisão do Bigfoot",
		[40] = "Clube do Bigfoot",
		[41] = "Sede do Bigfoot",
		[42] = "Clube do Bigfoot",
		[43] = "Casa dos Troféus",
		[44] = "Los Santos",
		[45] = "Palomino Creek",
		[46] = "Porão",
		[47] = "Laboratório Area 51",
		[48] = "Area 51",
		[49] = "Academia",
		[50] = "Los Santos",
		[51] = "Barbearia",
		[52] = "Dillimore",
		[53] = "Estúdio de Tatuagem",
		[54] = "San Fierro",
		[55] = "Fábrica de Tecidos",
		[56] = "Las Venturas",
		[57] = "Hotel de San Fierro",
		[58] = "San Fierro",
		[59] = "Banco de Los Santos",
		[60] = "Banco",
		[61] = "Esconderijo da Ilha Pirata #1",
		[62] = "Ilha Pirata",
		[63] = "Esconderijo da Ilha Pirata #2",
		[64] = "Ilha Pirata",
		[65] = "Esconderijo da Ilha Pirata #3",
		[66] = "Ilha Pirata",
		[67] = "Clube Spinosaurus",
		[68] = "San Fierro",
	},
}

apocalypseSetElementData(localPlayer, "TeleportInInterior", false)

function Teleportmarker.Create(markerID, MarkerSpawn, PlayerSpawn, keyID, size, teleporterName)
	if MarkerSpawn and PlayerSpawn then
		local Marker = createMarker(MarkerSpawn[1], MarkerSpawn[2], MarkerSpawn[3], "corona", 1, 255, 0, 0, 0)
		setElementInterior(Marker, MarkerSpawn[4])
		setElementDimension(Marker, MarkerSpawn[5])

		if not keyID then keyID = 0 end
		if not size then size = 0.8 end

		apocalypseSetElementData(Marker, "MarkerSpawn", MarkerSpawn)
		apocalypseSetElementData(Marker, "PlayerSpawn", PlayerSpawn)
		apocalypseSetElementData(Marker, "keyID", keyID)
		apocalypseSetElementData(Marker, "MarkerID", markerID)
		if teleporterName then
			apocalypseSetElementData(Marker, "markerName", teleporterName)
		end

		table.insert(Circles, {
			Marker = Marker,
			x = MarkerSpawn[1],
			y = MarkerSpawn[2],
			z = MarkerSpawn[3],
			size = size
		})

		addEventHandler("onClientMarkerHit", Marker, function(player)
			if player == localPlayer then
				if not isPedInVehicle(localPlayer) then
					if getElementDimension(localPlayer) == getElementDimension(source) then
						if getElementInterior(localPlayer) == getElementInterior(source) then
							if tonumber(PlayerSpawn[5]) > 0 or tonumber(PlayerSpawn[6]) > 0 then
								apocalypseSetElementData(localPlayer, "TeleportInInterior", true)
							else
								apocalypseSetElementData(localPlayer, "TeleportInInterior", false)
							end
							local PlayerSpawn = apocalypseGetElementData(source, "PlayerSpawn")
							triggerServerEvent("changePlayerSpawn", localPlayer, PlayerSpawn[1], PlayerSpawn[2], PlayerSpawn[3], PlayerSpawn[4], PlayerSpawn[5], PlayerSpawn[6], keyID, apocalypseGetElementData(source,"MarkerID"))
						end
					end
				end
			end
		end)
	end
end
addEvent("Teleportmarker.Create", true)
addEventHandler("Teleportmarker.Create", root, Teleportmarker.Create)

function createTeleporter(id, marker_x, marker_y, marker_z, marker_int, marker_dim, player_x, player_y, player_z, player_rot_z, player_int, player_dim, keyID, size)
	if not size then size = 0.8 end
	local MarkerSpawn = {marker_x, marker_y, marker_z, marker_int, marker_dim}
	local PlayerSpawn = {player_x, player_y, player_z, player_rot_z, player_int, player_dim}
	Teleportmarker.Create(id, MarkerSpawn, PlayerSpawn, keyID, size, markerName[apocalypseGetElementData(localPlayer,"language") or "EN"][tonumber(id)] or "")
end
addEvent("createTeleporter", true)
addEventHandler("createTeleporter", root, createTeleporter)

addEventHandler("onClientRender", root, function()
	if(isCharacterLoggedIn())then
		for _, v in pairs(Circles) do
			if(getElementDimension(localPlayer) == getElementDimension(v.Marker))then
				dxDrawCircle3D(v.x, v.y, v.z - 0.95, v.size)
				
				if(getDistanceBetweenPoints3D(v.x,v.y,v.z,getElementPosition(localPlayer)) <= 5)then
					if(isWindowOpen())then
						local name = apocalypseGetElementData(v.Marker, "markerName")
						if name then
							local sx, sy = getScreenFromWorldPosition(v.x, v.y, v.z + 1)
							if sx and sy then
								dxDrawText(name, sx - 50, sy - 15, sx + 50, sy + 15, tocolor(255, 255, 255, 255), 1.2, "default-bold", "center", "center")
							end
						end
					end
				end
			end
		end
	end
end)