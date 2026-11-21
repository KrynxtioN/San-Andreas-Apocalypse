local BonusCodeText = {
	["EN"] = {
		["ANEWHOPE"] = {
			"+ 2 vehicle slots",
			"+ Status: Survivor",
			"+ 10 Crowbars",
			"+ 250g Brain Mass",
		},
		["izerman"] = {
			"+ 5 Crowbars",
			"+ 2x Dynamit",
			"+ 5 Cigarettes",
			"+ $100",
			"+ 250 Experience Points",
			"+ 1x Double EXP Coupon",
		},
		["AGOODSTART"] = {
			"+ 10 Cigarettes",
			"+ 10 Lighters",
			"+ 5x Gasoline",
			"+ 5x Oil",
			"+ 5 Medikits",
			"+ 5 Crowbars",
			"+ 5 SAA Coins",
			"+ 1x Double EXP Coupon",
			"+ 5x Dynamit",
		},
		["HAPPYHALLOWEEN2026"] = {
			"+ 2x Potion: Speed Boost",
			"+ 2x Potion: Zombie Protection",
			"+ 2x Potion: Healing Boost",
			"+ 2x Potion: Zombie Stun",
			"+ 2 SAA Coins",
			"+ 250 Pumpkins (Event Item)",
			"+ 5 Pumpkin Seeds",
			"+ 1x Double EXP Coupon",
		},
	},
	["DE"] = {
		["ANEWHOPE"] = {
			"+ 2 Fahrzeugslots",
			"+ Status: Überlebender",
			"+ 10 Brechstangen",
			"+ 250g Hirnmasse",
		},
		["izerman"] = {
			"+ 5 Brechstangen",
			"+ 2x Dynamit",
			"+ 5 Zigaretten",
			"+ $100",
			"+ 250 Erfahrungspunkte",
			"+ 1x Doppelte EXP Coupon",
		},
		["AGOODSTART"] = {
			"+ 10 Zigaretten",
			"+ 10 Feuerzeuge",
			"+ 5x Benzin",
			"+ 5x Öl",
			"+ 5 Medikits",
			"+ 5 Brechstangen",
			"+ 5 SAA Münzen",
			"+ 1x Doppelte EXP Coupon",
			"+ 5x Dynamit",
		},
		["HAPPYHALLOWEEN2026"] = {
			"+ 2x Trank: Geschwindigkeitsboost",
			"+ 2x Trank: Schutz vor Zombies",
			"+ 2x Trank: Heilungsboost",
			"+ 2x Trank: Zombiebetäubung",
			"+ 2 SAA Münzen",
			"+ 250 Kürbisse (Event Item)",
			"+ 5 Kürbissamen",
			"+ 1x Doppelte EXP Coupon",
		},
	},
	["RU"] = {
		["ANEWHOPE"] = {
			"+ 2 слота для транспортных средств",
			"+ Статус: Выживший",
			"+ 10 Ломов",
			"+ 250г Мозговой массы",
		},
		["izerman"] = {
			"+ 5 Ломов",
			"+ 2x Динамит",
			"+ 5 Сигарет",
			"+ $100",
			"+ 250 Очков опыта",
			"+ 1x Купон двойного опыта",
		},
		["AGOODSTART"] = {
			"+ 10 Сигарет",
			"+ 10 Зажигалок",
			"+ 5x Бензин",
			"+ 5x Масло",
			"+ 5 Аптечек",
			"+ 5 Ломов",
			"+ 5 Монет SAA",
			"+ 1x Купон двойного опыта",
			"+ 5x Динамит",
		},
		["HAPPYHALLOWEEN2026"] = {
			"+ 2x Зелье: Ускорение",
			"+ 2x Зелье: Защита от зомби",
			"+ 2x Зелье: Усиление лечения",
			"+ 2x Зелье: Оглушение зомби",
			"+ 2 монеты SAA",
			"+ 250 тыкв (предмет события)",
			"+ 5 семян тыквы",
			"+ 1x купон на двойной опыт",
		},
	},
	["PT"] = {
		["ANEWHOPE"] = {
			"+ 2 slots de veículo",
			"+ Status: Sobrevivente",
			"+ 10 Alavancas",
			"+ 250g Massa Cerebral",
		},
		["izerman"] = {
			"+ 5 Alavancas",
			"+ 2x Dinamite",
			"+ 5 Cigarros",
			"+ $100",
			"+ 250 Pontos de Experiência",
			"+ 1x Cupom de EXP Dupla",
		},
		["AGOODSTART"] = {
			"+ 10 Cigarros",
			"+ 10 Isqueiros",
			"+ 5x Gasolina",
			"+ 5x Óleo",
			"+ 5 Kits médicos",
			"+ 5 Pés-de-cabra",
			"+ 5 Moedas SAA",
			"+ 1x Cupom de EXP Dupla",
			"+ 5x Dinamite",
		},
		["HAPPYHALLOWEEN2026"] = {
			"+ 2x Poção: Aumento de Velocidade",
			"+ 2x Poção: Proteção contra Zumbis",
			"+ 2x Poção: Aumento de Cura",
			"+ 2x Poção: Atordoamento de Zumbis",
			"+ 2 Moedas SAA",
			"+ 250 Abóboras (Item do Evento)",
			"+ 5 Sementes de Abóbora",
			"+ 1x Cupom de EXP em Dobro",
		},
	},
}

function getSettingData(player)
	if(not(player))then player = client end
	local autologin = getPlayerData("accounts", "ID", apocalypseGetElementData(client, "AccountID"), "autologin")
	local skipintro = getPlayerData("accounts", "ID", apocalypseGetElementData(client, "AccountID"), "skipintro")
	
	triggerClientEvent(client, "updateSettingData", client, autologin, skipintro)
end
addEvent("getSettingData", true)
addEventHandler("getSettingData", root, getSettingData)

addEvent("getSettingCharacters", true)
addEventHandler("getSettingCharacters", root, function()
	local result = dbPoll(dbQuery(handler, "SELECT * FROM characters WHERE owner_account_id = '"..apocalypseGetElementData(client, "AccountID").."'"), -1)
	if(#result >= 1)then
		local characters = {}
		for _, v in pairs(result)do
			table.insert(characters, {v["ID"], v["name"], v["level"], v["playtime"]})
		end
		triggerClientEvent(client, "updateSettingCharacters", client, characters)
	end
end)

addEvent("changeAutologin", true)
addEventHandler("changeAutologin", root, function()
	local autologin = getPlayerData("accounts", "ID", apocalypseGetElementData(client, "AccountID"), "autologin")
	if(autologin == 1)then
		createInfobox(client, getText(client, "SSettings2"))
		dbExec(handler, "UPDATE accounts SET autologin = '0' WHERE ID = '"..apocalypseGetElementData(client, "AccountID").."'")
	else
		createInfobox(client, getText(client, "SSettings1"))
		dbExec(handler, "UPDATE accounts SET autologin = '1' WHERE ID = '"..apocalypseGetElementData(client, "AccountID").."'")
	end
	getSettingData(client)
end)

addEvent("changeSkipintro", true)
addEventHandler("changeSkipintro", root, function()
	local skipintro = getPlayerData("accounts", "ID", apocalypseGetElementData(client, "AccountID"), "skipintro")
	if(skipintro == 1)then
		createInfobox(client, getText(client, "SSettings4"))
		dbExec(handler, "UPDATE accounts SET skipintro = '0' WHERE ID = '"..apocalypseGetElementData(client, "AccountID").."'")
	else
		createInfobox(client, getText(client, "SSettings3"))
		dbExec(handler, "UPDATE accounts SET skipintro = '1' WHERE ID = '"..apocalypseGetElementData(client, "AccountID").."'")
	end
	getSettingData(client)
end)

addEvent("changePassword", true)
addEventHandler("changePassword", root, function(password, newpassword1, newpassword2)
	if(password and newpassword1 and newpassword2)then
		if(newpassword1 == newpassword2)then
			local hashedPassword = getPlayerData("accounts", "ID", apocalypseGetElementData(client, "AccountID"), "password")
			if(passwordVerify(password, hashedPassword))then
				local newHashedPassword = passwordHash(newpassword1, "bcrypt", {})
				dbExec(handler, "UPDATE accounts SET password = '"..newHashedPassword.."' WHERE ID = '"..apocalypseGetElementData(client, "AccountID").."'")
				createInfobox(client, getText(client, "SSettings7"))
			else
				createInfobox(client, getText(client, "SSettings5"))
			end
		else
			createInfobox(client, getText(client, "SSettings6"))
		end
	end
end)

addEvent("setFavoriteCharacter", true)
addEventHandler("setFavoriteCharacter", root, function(id)
	if(id)then
		local favoritecharacter = getPlayerData("accounts","ID",apocalypseGetElementData(client,"AccountID"),"favoritecharacter")
		if(tonumber(favoritecharacter) == tonumber(id))then
			dbExec(handler, "UPDATE accounts SET favoritecharacter = '0' WHERE ID = '"..apocalypseGetElementData(client, "AccountID").."'")
			createInfobox(client, getText(client, "SSettings11"))
		else
			dbExec(handler, "UPDATE accounts SET favoritecharacter = '"..id.."' WHERE ID = '"..apocalypseGetElementData(client, "AccountID").."'")
			createInfobox(client, getText(client, "SSettings8"):format(id))
		end
	end
end)

addEvent("useBonuscode",true)
addEventHandler("useBonuscode",root,function(code)
    local result = dbPoll(dbQuery(handler,"SELECT * FROM bonuscodes WHERE code = '"..code.."'"),-1)
    
    if(#result >= 1) then
        local playersUsedCode = getPlayerData("bonuscodes","code",code,"player_used_code")
        local values = split(playersUsedCode or "", ",")
        local usedCode = false
        
        if(playersUsedCode) then
            for _,v in pairs(values) do
                if(getCharacterName(client) == v) then
                    usedCode = true
                    break
                end
            end
        end
        
        if(usedCode == false) then
			outputChatBox(getText(client,"SSettings14"),client,0,255,0)
			createInfobox(client,getText(client,"SSettings13"))
            if(code == "ANEWHOPE") then
				local vehicle_slots = getPlayerData("characters","ID",getCharacterID(client),"vehicle_slots")
				dbExec(handler,"UPDATE characters SET vehicle_slots = '"..vehicle_slots + 2 .."' WHERE ID = '"..getCharacterID(client).."'")
				
				setStatus(client,2)
				giveItem(client,1,250)
				giveItem(client,9,10)
				givePlayerServerMoney(client,100)
            end
			if(code == "izerman")then
				giveItem(client,9,5)
				giveItem(client,26,2)
				giveItem(client,2,5)
				giveItem(client,15,1)
				giveEXP(client,250)
				givePlayerServerMoney(client,100)
			end
			if(code == "AGOODSTART")then
				giveItem(client,2,10)
				giveItem(client,3,10)
				giveItem(client,6,5)
				giveItem(client,7,5)
				giveItem(client,8,5)
				giveItem(client,9,5)
				giveItem(client,14,5)
				giveItem(client,15,1)
				giveItem(client,26,5)
				givePlayerServerMoney(client,100)
			end
			if(code == "HAPPYHALLOWEEN2026")then
				giveItem(client,194,2)
				giveItem(client,195,2)
				giveItem(client,196,2)
				giveItem(client,197,2)
				giveItem(client,14,5)
				giveItem(client,12,250)
				giveItem(client,184,5)
				giveItem(client,15,1)
			end
			
			for _,v in pairs(BonusCodeText[apocalypseGetElementData(client,"language") or "EN"][code]) do
				outputChatBox(v, client, 0, 175, 0)
			end
			local newPlayersUsedCode = playersUsedCode..""..getCharacterName(client)..","
			dbExec(handler, "UPDATE bonuscodes SET player_used_code = '"..newPlayersUsedCode.."' WHERE code = '"..code.."'")
			outputLog("[BONUSCODE] "..getPlayerName(client).." ("..getCharacterID(client)..") hat einen Bonuscode eingelöst ("..code..")", "Bonuscodes", getCharacterID(client))
        else
            createInfobox(client,getText(client,"SSettings10"))
        end
    else
        createInfobox(client,getText(client,"SSettings9"))
    end
end)