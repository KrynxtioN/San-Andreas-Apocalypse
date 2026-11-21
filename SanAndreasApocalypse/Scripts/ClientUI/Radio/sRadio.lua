Radio = {Blips = {},
	["Data"] = {
		["EN"] = {
			[1] = "Liam Parker's Cameras",
			[2] = "Missing Brother",
			[3] = "Shop for Special Weapons",
			[4] = "Shooting Range",
			[5] = "Bigfoot?",
			[6] = "The Bigfoot Club",
			[7] = "Yacht Harbor Pier",
			[8] = "Dr. Brain's Keycard",
			[9] = "Dinosaur Caves",
			[10] = "Zombie Nests",
			[11] = "Special Engine Shop",
			[12] = "House of Achievements",
			[13] = "Tattoo Studio",
			[14] = "Oil Deliveries",
			[15] = "Vehicle Dismantling",
			[16] = "Cloth Fabric",
			[17] = "Halloween Event: Totems",
			[18] = "Elite Team Base",
			[19] = "Vehicle Missions",
			[20] = "Radio Towers",
			[21] = "Quest NPCs",
			[22] = "Graves",
			[23] = "Spinosaurus Club",
			[24] = "Cash Transporter | Colony Activity",
		},
		["DE"] = {
			[1] = "Liam Parker's Kameras",
			[2] = "Vermisster Bruder",
			[3] = "Shop für Spezialwaffen",
			[4] = "Schießstand",
			[5] = "Bigfoot?",
			[6] = "Der Bigfoot Club",
			[7] = "Yacht Harbor Pier",
			[8] = "Dr. Brains Schlüsselkarte",
			[9] = "Dinosaurier Höhlen",
			[10] = "Zombie Nester",
			[11] = "Spezial Motor Shop",
			[12] = "Haus der Erfolge",
			[13] = "Tattoo Studio",
			[14] = "Öllieferungen",
			[15] = "Fahrzeugzerlegung",
			[16] = "Klamotten Fabrik",
			[17] = "Halloween Event: Totems",
			[18] = "Elite Team Base",
			[19] = "Fahrzeug Missionen",
			[20] = "Funktürme",
			[21] = "Quest NPCs",
			[22] = "Gräber",
			[23] = "Spinosaurus Club",
			[24] = "Geldtransporter | Kolonie Aktivität",
		},
		["RU"] = {
			[1] = "Камеры Лиама Паркера",
			[2] = "Пропавший брат",
			[3] = "Магазин специальных оружий",
			[4] = "Стрелковый тир",
			[5] = "Снежный человек?",
			[6] = "Клуб Снежного человека",
			[7] = "Причал яхтенного порта",
			[8] = "Ключ-карта доктора Брейна",
			[9] = "Пещеры динозавров",
			[10] = "Гнезда зомби",
			[11] = "Специальный магазин моторов",
			[12] = "Дом достижений",
			[13] = "Тату-салон",
			[14] = "Доставка нефти",
			[15] = "Разборка автомобилей",
			[16] = "Фабрика одежды",
			[17] = "Хэллоуин событие: тотемы",
			[18] = "База элитной команды",
			[19] = "Миссии на транспортных средствах",
			[20] = "Радиовышки",
			[21] = "NPC квестов",
			[22] = "Могилы",
			[23] = "Клуб Спинозавра",
			[24] = "Инкассатор | Активность колонии",
		},
		["PT"] = {
			[1] = "Câmeras de Liam Parker",
			[2] = "Irmão desaparecido",
			[3] = "Loja de Armas Especiais",
			[4] = "Campo de Tiro",
			[5] = "Pé Grande?",
			[6] = "Clube do Pé Grande",
			[7] = "Píer do Porto de Iates",
			[8] = "Cartão-chave do Dr. Brain",
			[9] = "Cavernas de Dinossauros",
			[10] = "Ninhos de Zumbis",
			[11] = "Loja especial de motores",
			[12] = "Casa das Conquistas",
			[13] = "Estúdio de Tatuagem",
			[14] = "Entregas de Óleo",
			[15] = "Desmontagem de Veículos",
			[16] = "Fábrica de roupas",
			[17] = "Evento de Halloween: Totens",
			[18] = "Base da Equipe de Elite",
			[19] = "Missões de Veículos",
			[20] = "Torres de Rádio",
			[21] = "NPCs de Missão",
			[22] = "Túmulos",
			[23] = "Clube Spinosaurus",
			[24] = "Carro-forte | Atividade da Colônia",
		},
	},
}

function giveRadioData(player, ID)
	local playerRadioData = getPlayerData("characters","ID",getCharacterID(player),"radiodata")
	
	if(not(playerRadioData) or playerRadioData == 0)then
		dbExec(handler, "UPDATE characters SET radiodata = '' WHERE ID = '"..getCharacterID(player).."'")
		playerRadioData = getPlayerData("characters","ID",getCharacterID(player),"radiodata")
	end
	
	local values = split(playerRadioData, "|")
	local hasRadioData = false
	
	if(playerRadioData and ID)then
		for _, v in pairs(values)do
			if(tonumber(v) == ID)then
				hasRadioData = true
				break
			end
		end
	end
	
	if(hasRadioData == false)then
		giveEXP(player,750)
		dbExec(handler, "UPDATE characters SET radiodata = '"..playerRadioData..ID.."|' WHERE ID = '"..getCharacterID(player).."'")
		outputLog(getPlayerName(player).."  hat Radio-Daten erhalten (ID: "..ID..")", "Radio", getCharacterID(player))
	end
end

function hasRadioLocation(player, ID)
    local playerRadioData = getPlayerData("characters", "ID", getCharacterID(player), "radiodata")

    if (not playerRadioData or playerRadioData == 0) then
        dbExec(handler, "UPDATE characters SET radiodata = '' WHERE ID = '"..getCharacterID(player).."'")
        playerRadioData = ""
    end

    local values = split(playerRadioData, "|")
    for _, v in ipairs(values) do
        if v ~= "" and tonumber(v) == ID then
            return true
        end
    end

    return false
end

function removeRadioData(player, ID)
	local playerRadioData = getPlayerData("characters","ID",getCharacterID(player),"radiodata")
	local values = split(playerRadioData, "|")
	local entries = ""

    for i, v in ipairs(values) do
        if(tonumber(v) ~= tonumber(ID))then
			entries = entries..v.."|"
        end
    end
	dbExec(handler, "UPDATE characters SET radiodata = '"..entries.."' WHERE ID = '"..getCharacterID(player).."'")
	outputLog(getPlayerName(player).." wurden Radio-Daten entfernt (ID: "..ID..")", "Radio", getCharacterID(player))
end

addEvent("Radio.getEntries",true)
addEventHandler("Radio.getEntries",root,function()
	local playerRadioData = getPlayerData("characters","ID",getCharacterID(client),"radiodata")
	local entries = {}
	
	if(not(playerRadioData) or playerRadioData == 0)then
		dbExec(handler, "UPDATE characters SET radiodata = '' WHERE ID = '"..getCharacterID(client).."')")
		playerRadioData = getPlayerData("characters","ID",getCharacterID(client),"radiodata")
	end
	
	local values = split(playerRadioData, "|")
	
	for _, v in pairs(values)do
		table.insert(entries,{v,Radio["Data"][apocalypseGetElementData(client,"language") or "EN"][tonumber(v)]})
	end
	triggerClientEvent(client,"Radio.updateEntries",client,entries)
end)