BonuspointsShop = {
	["Documents"] = {
		["DE"] = {
			{"Dokument: Seismische Anomalien",7500,9,10,"Document","Welche Informationen es wohl beinhaltet?"},
			{"Zelt",5000,nil,15,"Tent","Platziere ein Zelt und wähle es als deinen Spawnpunkt."},
			{"Herstellungsrezept: Lagerfeuer",750,13,5,"CraftingRecipe","Gemütlich."},
			{"Herstellungsrezept: Eisenrüstung",1000,11,7,"CraftingRecipe","Bringt bei Nutzung Rüstung (Extra Leben)"},
			{"Herstellungsrezept: Goldrüstung",1250,12,10,"CraftingRecipe","Bringt bei Nutzung Rüstung (Extra Leben)"},

			{"Funkgerät Daten: Fahrzeug Missionen",1500,19,15,"Coordinates","Alle Standorte direkt auf dein Funkgerät."},
			{"Funkgerät Daten: Geldtransporter | Kolonie Aktivität",7500,24,10,"Coordinates","Alle Standorte direkt auf dein Funkgerät."},

			{"Notizblock",750,nil,5,"Notes","Notiere Dinge, speichere Koordinaten und setze Map-Markierungen."},
			
			{"Funkgerät Daten: Juwelier",3000,25,20,"Coordinates","Der Standort des Juweliers direkt auf dein Funkgerät."},
		},

		["EN"] = {
			{"Document: Seismic Anomalies",7500,9,10,"Document","What information might it contain?"},
			{"Tent",5000,nil,15,"Tent","Place a tent and choose it as your spawn point."},
			{"Crafting Recipe: Campfire",750,13,5,"CraftingRecipe","Cozy."},
			{"Crafting Recipe: Iron Armor",1000,11,7,"CraftingRecipe","Grants armor when used (extra health)."},
			{"Crafting Recipe: Gold Armor",1250,12,10,"CraftingRecipe","Grants armor when used (extra health)."},

			{"Radio Data: Vehicle Missions",1500,19,15,"Coordinates","All locations directly on your radio."},
			{"Radio Data: Cash Transporter | Colony Activity",7500,24,10,"Coordinates","All locations directly on your radio."},

			{"Notepad",750,nil,5,"Notes","Write notes, save coordinates and set map markers."},
			{"Radio Data: Jeweler",3000,25,20,"Coordinates","The jeweler's location directly on your radio."},
		},

		["RU"] = {
			{"Документ: Сейсмические Аномалии",7500,9,10,"Document","Какая информация в нём может содержаться?"},
			{"Палатка",5000,nil,15,"Tent","Установите палатку и выберите её как точку возрождения."},
			{"Рецепт: Костер",750,13,5,"CraftingRecipe","Уютно."},
			{"Рецепт: Железная броня",1000,11,7,"CraftingRecipe","При использовании даёт броню (дополнительное здоровье)."},
			{"Рецепт: Золотая броня",1250,12,10,"CraftingRecipe","При использовании даёт броню (дополнительное здоровье)."},

			{"Данные рации: Миссии с транспортом",1500,19,15,"Coordinates","Все местоположения прямо на вашей рации."},
			{"Данные рации: Инкассатор | Активность колонии",7500,24,10,"Coordinates","Все местоположения прямо на вашей рации."},

			{"Блокнот",750,nil,5,"Notes","Записывайте заметки, сохраняйте координаты и ставьте метки на карте."},
			{"Данные рации: Ювелир",3000,25,20,"Координаты","Местоположение ювелира прямо на вашей рации."},
		},

		["PT"] = {
			{"Documento: Anomalias Sísmicas",7500,9,10,"Document","Que informações será que ele contém?"},
			{"Barraca",5000,nil,15,"Tent","Coloque uma barraca e escolha-a como seu ponto de renascimento."},
			{"Receita de Criação: Fogueira",750,13,5,"CraftingRecipe","Aconchegante."},
			{"Receita de Criação: Armadura de Ferro",1000,11,7,"CraftingRecipe","Concede armadura ao usar (vida extra)."},
			{"Receita de Criação: Armadura de Ouro",1250,12,10,"CraftingRecipe","Concede armadura ao usar (vida extra)."},

			{"Dados do rádio: Missões de veículos",1500,19,15,"Coordinates","Todos os locais diretamente no seu rádio."},
			{"Dados do rádio: Carro-forte | Atividade da Colônia",7500,24,10,"Coordinates","Todos os locais diretamente no seu rádio."},

			{"Bloco de notas",750,nil,5,"Notes","Anote coisas, salve coordenadas e defina marcações no mapa."},
			{"Dados do Rádio: Joalheiro",3000,25,20,"Coordenadas","A localização do joalheiro diretamente no seu rádio."},
		},
	},
}

function BonuspointsShop.createWindow()
	if(isWindowOpen())then
        GUIEditor.window[1] = guiCreateWindow(629, 342, 602, 354, getText("CBonuspointsShop1"), false)
        setWindowData()
		guiCreateCloseButton()

        GUIEditor.tabpanel[1] = guiCreateTabPanel(11, 32, 581, 312, false, GUIEditor.window[1])

        GUIEditor.tab[2] = guiCreateTab(getText("CBonuspointsShop3"), GUIEditor.tabpanel[1])

        GUIEditor.label[1] = guiCreateLabel(10, 10, 561, 26, getText("CBonuspointsShop4"), false, GUIEditor.tab[2])
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", true)
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
        
        GUIEditor.gridlist[1] = guiCreateGridList(10, 46, 561, 197, false, GUIEditor.tab[2])
        guiGridListAddColumn(GUIEditor.gridlist[1], getText("CBonuspointsShop5"), 0.5)
        guiGridListAddColumn(GUIEditor.gridlist[1], getText("CBonuspointsShop6"), 0.2)
        guiGridListAddColumn(GUIEditor.gridlist[1], getText("CBonuspointsShop8"), 0.2)

        local lang = apocalypseGetElementData(localPlayer,"language") or "EN"
        if not BonuspointsShop.Documents[lang] then
            lang = "EN"
        end

        for _, doc in ipairs(BonuspointsShop.Documents[lang]) do
            local row = guiGridListAddRow(GUIEditor.gridlist[1])
            guiGridListSetItemText(GUIEditor.gridlist[1], row, 1, doc[1], false, false)
            guiGridListSetItemText(GUIEditor.gridlist[1], row, 2, tostring(doc[2]), false, false)
            guiGridListSetItemText(GUIEditor.gridlist[1], row, 3, tostring(doc[4]), false, false)

            guiGridListSetItemData(GUIEditor.gridlist[1], row, 1, {
                id = doc[3],
                cost = doc[2],
                bonuspoints = doc[4],
                Type = doc[5],
                description = doc[6] or getText("CBonuspointsShop4")
            })
        end

        addEventHandler("onClientGUIClick", GUIEditor.gridlist[1], function()
            local row = guiGridListGetSelectedItem(GUIEditor.gridlist[1])

            if row and row ~= -1 then
                local data = guiGridListGetItemData(GUIEditor.gridlist[1], row, 1)

                if data then
                    guiSetText(GUIEditor.label[1], data.description or getText("CBonuspointsShop4"))
                end
            else
                guiSetText(GUIEditor.label[1], getText("CBonuspointsShop4"))
            end
        end, false)

        GUIEditor.button[1] = guiCreateButton(10, 253, 561, 25, getText("CBonuspointsShop7"), false, GUIEditor.tab[2])
		
		addEventHandler("onClientGUIClick", GUIEditor.button[1], function()
			local row, col = guiGridListGetSelectedItem(GUIEditor.gridlist[1])
			if row and row ~= -1 then
				local data = guiGridListGetItemData(GUIEditor.gridlist[1], row, 1)
				if data then
					triggerServerEvent("BonuspointsShop.buy", localPlayer, data.cost, data.id, data.bonuspoints, data.Type)
				end
			end
		end, false)
    end
end