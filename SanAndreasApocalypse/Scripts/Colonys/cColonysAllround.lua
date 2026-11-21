Colonys = {playerBlips = {}, FunctionsPage = 1, SelectedBonus = nil, SelectedBonusButton = nil,
	["Functions"] = {
		[1] = {
			["EN"] = "Trash Compactor\n\nThe trash compactor becomes available at colony level 5. It allows you to compress items into a trash block. This grants your colony experience points, and the trash block can be sold.",
			["DE"] = "Müllpresse\n\nDie Müllpresse ist ab Koloni-Level 5 verfügbar. Mit ihr lassen sich Items zu einem Müllblock pressen. Dies bringt der Kolonie Erfahrungspunkte und der Müllblock kann verkauft werden.",
			["RU"] = "Мусорный пресс\n\nМусорный пресс доступен с 5 уровня колонии. Он позволяет сжимать предметы в мусорный блок. Это приносит вашей колонии опыт, а блок можно продать.",
			["PT"] = "Compactador de Lixo\n\nO compactador de lixo está disponível no nível 5 da colônia. Ele permite compactar itens em um bloco de lixo. Isso concede pontos de experiência à colônia, e o bloco pode ser vendido.",
		},
		[2] = {
			["EN"] = "Warehouses\n\nWarehouses become available at colony level 10 and allow you to store items up to a certain capacity.",
			["DE"] = "Lagerhallen\n\nLagerhallen sind ab Kolonie-Level 10 verfügbar und ermöglichen das Lagern von Items bis zu einer gewissen Kapazität.",
			["RU"] = "Склады\n\nСклады становятся доступны с 10 уровня колонии и позволяют хранить предметы до определённого объёма.",
			["PT"] = "Armazéns\n\nArmazéns ficam disponíveis no nível 10 da colônia e permitem armazenar itens até certa capacidade.",
		},
		[3] = {
			["EN"] = "Zombie Experiments\n\nFrom colony level 25, you can buy zombies and experiment on them.",
			["DE"] = "Zombie Experimente\n\nAb Kolonie Level 25 können Zombies gekauft werden. Anschließend könnt ihr an ihnen experimentieren.",
			["RU"] = "Эксперименты над зомби\n\nНачиная с 25 уровня колонии можно покупать zомби и проводить над ними эксперименты.",
			["PT"] = "Experimentos com Zumbis\n\nA partir do nível 25 da colônia, você pode comprar zumbis e realizar experimentos com eles.",
		},
	},
}

local function formatTime(seconds)
    seconds = math.max(0, tonumber(seconds) or 0)

    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = seconds % 60

    return string.format("%02d:%02d:%02d", h, m, s)
end

function Colonys.resetBonusSelection()
	Colonys.SelectedBonus = nil
	Colonys.SelectedBonusButton = nil

	if(isElement(GUIEditor.button[9]))then guiSetText(GUIEditor.button[9], getText("CColonys26")) end
	if(isElement(GUIEditor.button[10]))then guiSetText(GUIEditor.button[10], getText("CColonys27")) end
	if(isElement(GUIEditor.button[11]))then guiSetText(GUIEditor.button[11], getText("CColonys28")) end
	if(isElement(GUIEditor.button[12]))then guiSetText(GUIEditor.button[12], getText("CColonys29")) end
	if(isElement(GUIEditor.button[13]))then guiSetText(GUIEditor.button[13], getText("CColonys30")) end
	if(isElement(GUIEditor.button[14]))then guiSetText(GUIEditor.button[14], getText("CColonys31")) end
end

addEvent("Colonys.deactivateTabs",true)
addEventHandler("Colonys.deactivateTabs",root,function(level)
	local level = tonumber(level)
	if(level < 5)then guiSetEnabled(GUIEditor.tab[5],false) else guiSetEnabled(GUIEditor.tab[5],true) end
	if(level < 10)then guiSetEnabled(GUIEditor.tab[6],false) else guiSetEnabled(GUIEditor.tab[6],true) end
	if(level < 25)then guiSetEnabled(GUIEditor.tab[4],false) else guiSetEnabled(GUIEditor.tab[4],true) end
end)

function Colonys.handleBonusButton(button, bonusId, textKey, defaultTextKey)
	if(Colonys.SelectedBonus ~= bonusId)then
		Colonys.resetBonusSelection()
		Colonys.SelectedBonus = bonusId
		Colonys.SelectedBonusButton = button
		guiSetText(GUIEditor.label[5], getText(textKey))
		triggerServerEvent("Colonys.getBonusTimer",localPlayer,bonusId)
		guiSetText(button, "!"..getText(defaultTextKey).."!")
		return
	end

	triggerServerEvent("Colonys.activateBonus", localPlayer, bonusId)
	triggerServerEvent("Colonys.getBonusTimer", localPlayer,bonusId)
	Colonys.resetBonusSelection()
end

addEvent("Colonys.updateBonusTimer",true)
addEventHandler("Colonys.updateBonusTimer",root,function(bonus_time)
	guiSetText(GUIEditor.label[6],getText("CColonys32"):format(formatTime(bonus_time)))
end)

local info_labor = {
    button = {},
    window = {},
    staticimage = {},
    label = {},
    currentPage = 1,
    pages = {
        {
            image = "Files/Images/LaborInfos/1.png",
            textKeys = {"CColonys41", "CColonys42", "CColonys43", "CColonys44", "CColonys45", "CColonys46"},
        },
        {
            image = "Files/Images/LaborInfos/2.png",
            textKeys = {"CColonys47", "CColonys48", "CColonys49", "CColonys50"},
        },
    }
}

function info_labor_buildText(page)
    if(not page or not page.textKeys)then
        return
    end

    local lines = {}

    for _, key in ipairs(page.textKeys) do
        local text = getText(key)

        if(not text or text == "")then
            text = "[FEHLT: "..tostring(key).."]"
        end

        table.insert(lines, text)
    end

    return table.concat(lines, "\n\n")
end

function info_labor_updatePage()
    local page = info_labor.pages[info_labor.currentPage]
    if(not page)then return end

    if(isElement(info_labor.staticimage[1]))then
        guiStaticImageLoadImage(info_labor.staticimage[1], page.image)
    end

    local finalText = info_labor_buildText(page)

    if(isElement(info_labor.label[1]))then
        guiSetText(info_labor.label[1], finalText)
    end

    if(isElement(info_labor.label[2]))then
        guiSetText(info_labor.label[2], info_labor.currentPage.." / "..#info_labor.pages)
    end
end

function info_labor_create_window()
    if(isElement(info_labor.window[1]))then
        destroyElement(info_labor.window[1])
    end

    info_labor.window[1] = guiCreateWindow(500, 180, 720, 650, "", false)
    centerWindow(info_labor.window[1],true)

    info_labor.staticimage[1] = guiCreateStaticImage(20, 35, 680, 285, info_labor.pages[1].image, false, info_labor.window[1])

    info_labor.label[1] = guiCreateLabel(20, 340, 680, 220, "", false, info_labor.window[1])
    guiSetFont(info_labor.label[1], "default-bold-small")
    guiLabelSetHorizontalAlign(info_labor.label[1], "left", true)
    guiLabelSetVerticalAlign(info_labor.label[1], "top")

    info_labor.label[2] = guiCreateLabel(325, 580, 70, 20, "", false, info_labor.window[1])
    guiSetFont(info_labor.label[2], "default-bold-small")
    guiLabelSetHorizontalAlign(info_labor.label[2], "center", true)
    guiLabelSetVerticalAlign(info_labor.label[2], "center")

    info_labor.button[1] = guiCreateButton(600, 575, 100, 32, ">>", false, info_labor.window[1])
    info_labor.button[2] = guiCreateButton(20, 575, 100, 32, "<<", false, info_labor.window[1])
    info_labor.button[3] = guiCreateButton(600, 35, 100, 25, getText("CValentineEvent9"), false, info_labor.window[1])

    info_labor.currentPage = 1
    info_labor_updatePage()

    addEventHandler("onClientGUIClick", info_labor.button[1], function()
        info_labor.currentPage = info_labor.currentPage + 1
        if(info_labor.currentPage > #info_labor.pages)then
            info_labor.currentPage = 1
        end
        info_labor_updatePage()
    end, false)

    addEventHandler("onClientGUIClick", info_labor.button[2], function()
        info_labor.currentPage = info_labor.currentPage - 1
        if(info_labor.currentPage < 1)then
            info_labor.currentPage = #info_labor.pages
        end
        info_labor_updatePage()
    end, false)

    addEventHandler("onClientGUIClick", info_labor.button[3], function()
        if(isElement(info_labor.window[1]))then
            destroyElement(info_labor.window[1])
        end
    end, false)
end

function Colonys.createWindow()
	if(isWindowOpen())then
        GUIEditor.window[1] = guiCreateWindow(1111, 296, 465, 253, getText("CColonys1"), false)
        setWindowData()
		guiCreateCloseButton()

        GUIEditor.label[1] = guiCreateLabel(10, 31, 445, 53, getText("CColonys2"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "left", true)
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
        GUIEditor.label[2] = guiCreateLabel(10, 94, 102, 27, getText("CColonys3"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[2], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[2], "left", true)
        guiLabelSetVerticalAlign(GUIEditor.label[2], "center")
        GUIEditor.edit[1] = guiCreateEdit(122, 94, 333, 27, "", false, GUIEditor.window[1])
        GUIEditor.button[1] = guiCreateButton(10, 131, 445, 26, getText("CColonys4"), false, GUIEditor.window[1])
        GUIEditor.label[3] = guiCreateLabel(10, 167, 445, 76, getText("CColonys5"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[3], "clear-normal")
        guiLabelSetHorizontalAlign(GUIEditor.label[3], "center", true)   
		
		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
			local ColonyName = guiGetText(GUIEditor.edit[1])
			if(#ColonyName >= 1 and #ColonyName <= 24)then
				triggerServerEvent("Colonys.create",localPlayer,ColonyName)
			else
				NPC.NormalMessage(getText("CColonys6"))
			end
		end,false)
	end
end

addEvent("Colonys.createMenu",true)
addEventHandler("Colonys.createMenu",root,function(member)
	if(isWindowOpen())then
        GUIEditor.window[1] = guiCreateWindow(277, 296, 824, 449, apocalypseGetElementData(localPlayer,"ColonyName"), false)
        setWindowData()
		guiCreateCloseButton()

        GUIEditor.tabpanel[1] = guiCreateTabPanel(10, 29, 804, 410, false, GUIEditor.window[1])
		
        GUIEditor.tab[1] = guiCreateTab(getText("CColonys7"), GUIEditor.tabpanel[1])

        GUIEditor.gridlist[1] = guiCreateGridList(10, 10, 654, 365, false, GUIEditor.tab[1])
        Colony_Player = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CColonys8"), 0.2)
        Colony_Rang = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CColonys9"), 0.1)
        Colony_Warns = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CColonys10"), 0.1)
        Colony_Join_Date = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CColonys11"), 0.2)
        Colony_LastLogin = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CColonys12"), 0.2)
        Colony_Status = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CColonys13"), 0.2)
        GUIEditor.button[1] = guiCreateButton(674, 10, 120, 23, getText("CColonys14"), false, GUIEditor.tab[1])
        GUIEditor.button[2] = guiCreateButton(674, 43, 120, 23, getText("CColonys15"), false, GUIEditor.tab[1])
        GUIEditor.button[3] = guiCreateButton(674, 76, 120, 23, getText("CColonys16"), false, GUIEditor.tab[1])
        GUIEditor.button[4] = guiCreateButton(674, 109, 120, 23, getText("CColonys17"), false, GUIEditor.tab[1])
        GUIEditor.button[5] = guiCreateButton(674, 142, 120, 23, getText("CColonys18"), false, GUIEditor.tab[1])
        GUIEditor.label[1] = guiCreateLabel(674, 194, 120, 27, getText("CColonys19"), false, GUIEditor.tab[1])
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
        GUIEditor.edit[1] = guiCreateEdit(674, 231, 120, 24, "", false, GUIEditor.tab[1])
        GUIEditor.button[6] = guiCreateButton(674, 265, 120, 23, getText("CColonys20"), false, GUIEditor.tab[1])
		
		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
			local clicked = guiGridListGetItemText(GUIEditor.gridlist[1],  guiGridListGetSelectedItem(GUIEditor.gridlist[1]), 1)
			if(clicked ~= "")then
				triggerServerEvent("Colonys.giveWarn",localPlayer,clicked)
			end
		end,false)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[2],function()
			local clicked = guiGridListGetItemText(GUIEditor.gridlist[1],  guiGridListGetSelectedItem(GUIEditor.gridlist[1]), 1)
			if(clicked ~= "")then
				triggerServerEvent("Colonys.removeWarn",localPlayer,clicked)
			end
		end,false)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[4],function()
			local clicked = guiGridListGetItemText(GUIEditor.gridlist[1],  guiGridListGetSelectedItem(GUIEditor.gridlist[1]), 1)
			if(clicked ~= "")then
				triggerServerEvent("Colonys.rangUp",localPlayer,clicked)
			end
		end,false)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[5],function()
			local clicked = guiGridListGetItemText(GUIEditor.gridlist[1],  guiGridListGetSelectedItem(GUIEditor.gridlist[1]), 1)
			if(clicked ~= "")then
				triggerServerEvent("Colonys.rangDown",localPlayer,clicked)
			end
		end,false)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[3],function()
			local clicked = guiGridListGetItemText(GUIEditor.gridlist[1],  guiGridListGetSelectedItem(GUIEditor.gridlist[1]), 1)
			if(clicked ~= "")then
				triggerServerEvent("Colonys.uninvite",localPlayer,clicked)
			end
		end,false)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[6],function()
			local PlayerName = guiGetText(GUIEditor.edit[1])
			if(PlayerName ~= "")then
				triggerServerEvent("Colonys.invite",localPlayer,PlayerName)
			end
		end,false)

        GUIEditor.tab[2] = guiCreateTab(getText("CColonys21"), GUIEditor.tabpanel[1])

        GUIEditor.label[2] = guiCreateLabel(10, 10, 241, 14, getText("CColonys21"), false, GUIEditor.tab[2])
        guiSetFont(GUIEditor.label[2], "default-bold-small")
        guiLabelSetVerticalAlign(GUIEditor.label[2], "center")
        GUIEditor.gridlist[2] = guiCreateGridList(10, 34, 241, 342, false, GUIEditor.tab[2])
		Colony_Laboratory = guiGridListAddColumn(GUIEditor.gridlist[2], getText("CColonys33"), 0.9)
        GUIEditor.label[4] = guiCreateLabel(550, 10, 244, 121, getText("CColonys22"), false, GUIEditor.tab[2])
        guiSetFont(GUIEditor.label[4], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[4], "left", true)
        GUIEditor.button[7] = guiCreateButton(550, 141, 244, 22, getText("CColonys23"), false, GUIEditor.tab[2])
        GUIEditor.label[5] = guiCreateLabel(261, 209, 533, 107, "", false, GUIEditor.tab[2])
        guiSetFont(GUIEditor.label[5], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[5], "left", true)
        GUIEditor.button[8] = guiCreateButton(261, 326, 55, 50, getText("CColonys25"), false, GUIEditor.tab[2])
        GUIEditor.button[9] = guiCreateButton(326, 326, 55, 50, getText("CColonys26"), false, GUIEditor.tab[2])
        GUIEditor.button[10] = guiCreateButton(391, 326, 55, 50, getText("CColonys27"), false, GUIEditor.tab[2])
        GUIEditor.button[11] = guiCreateButton(456, 326, 55, 50, getText("CColonys28"), false, GUIEditor.tab[2])
        GUIEditor.button[12] = guiCreateButton(521, 326, 55, 50, getText("CColonys29"), false, GUIEditor.tab[2])
        GUIEditor.button[13] = guiCreateButton(586, 326, 55, 50, getText("CColonys30"), false, GUIEditor.tab[2])
        GUIEditor.button[14] = guiCreateButton(651, 326, 55, 50, getText("CColonys31"), false, GUIEditor.tab[2])
        GUIEditor.label[6] = guiCreateLabel(716, 326, 78, 50, "", false, GUIEditor.tab[2])
        guiSetFont(GUIEditor.label[6], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[6], "left", true)

		Colonys.resetBonusSelection()
		
		addEventHandler("onClientGUIClick",GUIEditor.button[7],function()
			info_labor_create_window()
		end,false)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[8],function()
			guiSetText(GUIEditor.label[5],getText("CColonys40"))
		end,false)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[9],function()
			Colonys.handleBonusButton(GUIEditor.button[9], 1, "CColonys34", "CColonys26")
		end,false)

		addEventHandler("onClientGUIClick",GUIEditor.button[10],function()
			Colonys.handleBonusButton(GUIEditor.button[10], 2, "CColonys35", "CColonys27")
		end,false)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[11],function()
			Colonys.handleBonusButton(GUIEditor.button[11], 3, "CColonys36", "CColonys28")
		end,false)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[12],function()
			Colonys.handleBonusButton(GUIEditor.button[12], 4, "CColonys37", "CColonys29")
		end,false)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[13],function()
			Colonys.handleBonusButton(GUIEditor.button[13], 5, "CColonys38", "CColonys30")
		end,false)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[14],function()
			Colonys.handleBonusButton(GUIEditor.button[14], 6, "CColonys39", "CColonys31")
		end,false)
		
		addEventHandler("onClientGUIClick",GUIEditor.gridlist[2],function()
			local selectedRow = guiGridListGetSelectedItem(GUIEditor.gridlist[2])
			if(selectedRow ~= -1)then
				local areaID = guiGridListGetItemData(GUIEditor.gridlist[2], selectedRow, Colony_Laboratory)
				triggerServerEvent("LaboratoryFights.getAreaRewards",localPlayer,areaID)
				if(isElement(GUIEditor.staticimage[1]))then destroyElement(GUIEditor.staticimage[1])end
				GUIEditor.staticimage[1] = guiCreateStaticImage(261, 10, 279, 189, "Files/Images/Laboratorys/"..areaID..".png", false, GUIEditor.tab[2])
			end
		end,false)

        GUIEditor.tab[3] = guiCreateTab("Statistiken", GUIEditor.tabpanel[1])

        GUIEditor.progressbar[1] = guiCreateProgressBar(10, 348, 784, 28, false, GUIEditor.tab[3])
        guiProgressBarSetProgress(GUIEditor.progressbar[1], 56)
        GUIEditor.label[7] = guiCreateLabel(10, 348, 784, 28, "100 / 500 Erfahrungspunkte bis Level 25.", false, GUIEditor.tab[3])
        guiSetFont(GUIEditor.label[7], "default-bold-small")
        guiLabelSetColor(GUIEditor.label[7], 254, 91, 91)
        guiLabelSetHorizontalAlign(GUIEditor.label[7], "center", true)
        guiLabelSetVerticalAlign(GUIEditor.label[7], "center")
        GUIEditor.label[8] = guiCreateLabel(455, 10, 339, 300, Colonys["Functions"][Colonys.FunctionsPage][apocalypseGetElementData(localPlayer,"language") or "EN"], false, GUIEditor.tab[3])
        guiSetFont(GUIEditor.label[8], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[8], "left", true)
        GUIEditor.button[15] = guiCreateButton(455, 320, 42, 18, "<<", false, GUIEditor.tab[3])
        GUIEditor.button[16] = guiCreateButton(752, 320, 42, 18, ">>", false, GUIEditor.tab[3])
        GUIEditor.label[9] = guiCreateLabel(10, 10, 435, 24, "Gesammelte Erfahrungspunkte:", false, GUIEditor.tab[3])
        guiLabelSetVerticalAlign(GUIEditor.label[9], "center")
        GUIEditor.label[10] = guiCreateLabel(10, 44, 435, 24, "Zombies getötet:", false, GUIEditor.tab[3])
        guiLabelSetVerticalAlign(GUIEditor.label[10], "center")
		
		addEventHandler("onClientGUIClick",GUIEditor.button[15],function()
			local page = Colonys.FunctionsPage
			if(page > 1)then
				Colonys.FunctionsPage = Colonys.FunctionsPage - 1
				guiSetText(GUIEditor.label[8],Colonys["Functions"][Colonys.FunctionsPage][apocalypseGetElementData(localPlayer,"language") or "EN"])
			end
		end,false)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[16],function()
			local page = Colonys.FunctionsPage
			if(page < #Colonys["Functions"])then
				Colonys.FunctionsPage = Colonys.FunctionsPage + 1
				guiSetText(GUIEditor.label[8],Colonys["Functions"][Colonys.FunctionsPage][apocalypseGetElementData(localPlayer,"language") or "EN"])
			end
		end,false)
		
        GUIEditor.tab[5] = guiCreateTab(getText("CColonyTrash15"), GUIEditor.tabpanel[1])
		guiSetEnabled(GUIEditor.tab[5],false)

        GUIEditor.label[12] = guiCreateLabel(10, 10, 241, 14, getText("CColonyTrash3"), false, GUIEditor.tab[5])
        guiSetFont(GUIEditor.label[12], "default-bold-small")
        GUIEditor.gridlist[3] = guiCreateGridList(10, 34, 246, 342, false, GUIEditor.tab[5])
        trashItem = guiGridListAddColumn(GUIEditor.gridlist[3], getText("CColonyTrash4"), 0.6)
        trashAmount = guiGridListAddColumn(GUIEditor.gridlist[3], getText("CColonyTrash5"), 0.4)
        trashValue_EXP = guiGridListAddColumn(GUIEditor.gridlist[3], getText("CColonyTrash16"), 0.2)
        trashValue_Money = guiGridListAddColumn(GUIEditor.gridlist[3], getText("CColonyTrash17"), 0.2)
        GUIEditor.progressbar[3] = guiCreateProgressBar(266, 316, 528, 22, false, GUIEditor.tab[5])
        GUIEditor.label[13] = guiCreateLabel(266, 10, 283, 80, getText("CColonyTrash6"), false, GUIEditor.tab[5])
        guiSetFont(GUIEditor.label[13], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[13], "left", true)
        GUIEditor.label[14] = guiCreateLabel(266, 146, 140, 21, getText("CColonyTrash7"), false, GUIEditor.tab[5])
        guiSetFont(GUIEditor.label[14], "default-bold-small")
        guiLabelSetVerticalAlign(GUIEditor.label[14], "center")
        GUIEditor.edit[2] = guiCreateEdit(266, 177, 140, 28, "", false, GUIEditor.tab[5])
        GUIEditor.button[17] = guiCreateButton(416, 177, 133, 28, getText("CColonyTrash8"), false, GUIEditor.tab[5])
        GUIEditor.button[18] = guiCreateButton(266, 348, 528, 28, getText("CColonyTrash9"), false, GUIEditor.tab[5])
        GUIEditor.label[15] = guiCreateLabel(266, 317, 528, 21, "", false, GUIEditor.tab[5])
        guiSetFont(GUIEditor.label[15], "default-bold-small")
        guiLabelSetColor(GUIEditor.label[15], 1, 0, 0)
        guiLabelSetHorizontalAlign(GUIEditor.label[15], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[15], "center")
        GUIEditor.label[16] = guiCreateLabel(266, 100, 283, 36, getText("CColonyTrash10"), false, GUIEditor.tab[5])
        guiSetFont(GUIEditor.label[16], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[16], "left", true)
        guiLabelSetVerticalAlign(GUIEditor.label[16], "center")
        GUIEditor.label[17] = guiCreateLabel(559, 10, 235, 80, "", false, GUIEditor.tab[5])
        guiSetFont(GUIEditor.label[17], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[17], "left", true)
        GUIEditor.label[18] = guiCreateLabel(559, 100, 235, 36, "", false, GUIEditor.tab[5])
        guiSetFont(GUIEditor.label[18], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[18], "left", true)
        guiLabelSetVerticalAlign(GUIEditor.label[18], "center")
        GUIEditor.label[19] = guiCreateLabel(559, 146, 235, 21, "", false, GUIEditor.tab[5])
        guiSetFont(GUIEditor.label[19], "default-bold-small")
        guiLabelSetVerticalAlign(GUIEditor.label[19], "center")
        GUIEditor.button[19] = guiCreateButton(559, 177, 235, 28, getText("CColonyTrash11"), false, GUIEditor.tab[5])
        GUIEditor.staticimage[2] = guiCreateStaticImage(266, 215, 528, 91, "Files/Images/TrashCompactor.png", false, GUIEditor.tab[5])
		
		addEventHandler("onClientGUIClick",GUIEditor.button[17],function()
			local selectedRow = guiGridListGetSelectedItem(GUIEditor.gridlist[3])
			if(selectedRow ~= -1)then
				local amount = guiGetText(GUIEditor.edit[2])
				local ItemID = guiGridListGetItemData(GUIEditor.gridlist[3], selectedRow, trashItem)

				if(#amount >= 1 and isOnlyNumbers(amount))then
					triggerServerEvent("ColonyTrash.delivery",localPlayer,ItemID,amount)
				end
			end
		end,false)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[18],function()
			triggerServerEvent("ColonyTrash.start",localPlayer)
		end,false)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[19],function()
			triggerServerEvent("ColonyTrash.repair",localPlayer)
		end,false)

        GUIEditor.tab[6] = guiCreateTab(getText("CColonyWarehouse10"), GUIEditor.tabpanel[1])
		guiSetEnabled(GUIEditor.tab[6],false)

        GUIEditor.gridlist[4] = guiCreateGridList(10, 10, 246, 366, false, GUIEditor.tab[6])
        warehouse_items = guiGridListAddColumn(GUIEditor.gridlist[4], getText("CColonyWarehouse15"), 0.5)
        warehouse_amount = guiGridListAddColumn(GUIEditor.gridlist[4], getText("CColonyWarehouse16"), 0.5)
        GUIEditor.label[20] = guiCreateLabel(266, 10, 528, 47, getText("CColonyWarehouse11"), false, GUIEditor.tab[6])
        guiSetFont(GUIEditor.label[20], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[20], "left", true)
        GUIEditor.gridlist[5] = guiCreateGridList(266, 67, 280, 309, false, GUIEditor.tab[6])
		colony_warehouse = guiGridListAddColumn(GUIEditor.gridlist[5], getText("CColonyWarehouse12"), 0.9)
        GUIEditor.button[20] = guiCreateButton(556, 351, 238, 25, getText("CColonyWarehouse13"), false, GUIEditor.tab[6])
        GUIEditor.label[21] = guiCreateLabel(556, 67, 238, 274, "", false, GUIEditor.tab[6])
        guiSetFont(GUIEditor.label[21], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[21], "left", true)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[20],function()
			local selectedRow = guiGridListGetSelectedItem(GUIEditor.gridlist[5])
			if(selectedRow ~= -1)then
				local warehouseID = guiGridListGetItemData(GUIEditor.gridlist[5], selectedRow, colony_warehouse)
				triggerServerEvent("ColonyWarehouse.buy",localPlayer,warehouseID)
			end
		end,false)
		
		addEventHandler("onClientGUIClick",GUIEditor.gridlist[5],function()
			local selectedRow = guiGridListGetSelectedItem(GUIEditor.gridlist[5])
			if(selectedRow ~= -1)then
				local warehouseID = guiGridListGetItemData(GUIEditor.gridlist[5], selectedRow, colony_warehouse)
				triggerServerEvent("ColonyWarehouse.getData",localPlayer,localPlayer,warehouseID,true)
			end
		end,false)
		
		GUIEditor.tab[4] = guiCreateTab(getText("CColonys51"), GUIEditor.tabpanel[1])
		guiSetEnabled(GUIEditor.tab[4],false)

        GUIEditor.label[11] = guiCreateLabel(10, 10, 784, 366, getText("CColonys52"), false, GUIEditor.tab[4])
        guiLabelSetHorizontalAlign(GUIEditor.label[11], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[11], "center")
		
		Colonys.updateClientData(member)
		triggerServerEvent("LaboratoryFights.getAreaData",localPlayer)
		triggerServerEvent("getColonyLevelData",localPlayer)
		triggerServerEvent("Colonys.getTrashItems",localPlayer)
		triggerServerEvent("ColonyTrash.getData",localPlayer)
		triggerServerEvent("Colonys.getWarehouseData",localPlayer,localPlayer)
		triggerServerEvent("Colonys.checkLevel",localPlayer)
	end
end)

addEvent("Colonys.updateTrashItems",true)
addEventHandler("Colonys.updateTrashItems",root,function(items)
	guiGridListClear(GUIEditor.gridlist[3])
    if(items)then
        for _, v in pairs(items) do
			local row = guiGridListAddRow(GUIEditor.gridlist[3])
			guiGridListSetItemText(GUIEditor.gridlist[3], row, trashItem, v[2], false, false)
			guiGridListSetItemText(GUIEditor.gridlist[3], row, trashAmount, v[3], false, false)
			guiGridListSetItemText(GUIEditor.gridlist[3], row, trashValue_EXP, v[4], false, false)
			guiGridListSetItemText(GUIEditor.gridlist[3], row, trashValue_Money, v[5], false, false)
			guiGridListSetItemData(GUIEditor.gridlist[3], row, trashItem, v[1])
        end
    end
end)

function Colonys.updateClientData(member)
	if(member)then
		guiGridListClear(GUIEditor.gridlist[1])
		
		for _,v in pairs(member) do
			local row = guiGridListAddRow(GUIEditor.gridlist[1])
			guiGridListSetItemText(GUIEditor.gridlist[1], row, Colony_Player, v[1], false, false)
			guiGridListSetItemText(GUIEditor.gridlist[1], row, Colony_Warns, v[2], false, false)
			guiGridListSetItemText(GUIEditor.gridlist[1], row, Colony_Rang, v[3], false, false)
			guiGridListSetItemText(GUIEditor.gridlist[1], row, Colony_Join_Date, v[4], false, false)
			guiGridListSetItemText(GUIEditor.gridlist[1], row, Colony_LastLogin, v[5], false, false)
			guiGridListSetItemText(GUIEditor.gridlist[1], row, Colony_Status, v[6], false, false)
		end
	end
end
addEvent("Colonys.updateClientData",true)
addEventHandler("Colonys.updateClientData",root,Colonys.updateClientData)

function Colonys.updateWarehouse(data,items,max_items)
	guiGridListClear(GUIEditor.gridlist[5])
		
	for _,v in pairs(data) do
		local row = guiGridListAddRow(GUIEditor.gridlist[5])
		if(v.owned == false)then r,g,b = 255,0,0 else r,g,b = 0,255,0 end
		guiGridListSetItemText(GUIEditor.gridlist[5], row, colony_warehouse, getText("CColonyWarehouse9"):format(v.id), false, false)
		guiGridListSetItemColor(GUIEditor.gridlist[5], row, colony_warehouse, r, g, b)
		guiGridListSetItemData(GUIEditor.gridlist[5], row, colony_warehouse, v.id)
	end
end
addEvent("Colonys.updateWarehouse",true)
addEventHandler("Colonys.updateWarehouse",root,Colonys.updateWarehouse)

addEvent("Colonys.updateLaboratorys",true)
addEventHandler("Colonys.updateLaboratorys",root,function(areas)
	if(areas)then
		guiGridListClear(GUIEditor.gridlist[2])
			
		for _,v in pairs(areas) do
			local row = guiGridListAddRow(GUIEditor.gridlist[2])
			guiGridListSetItemText(GUIEditor.gridlist[2], row, Colony_Laboratory, v[1], false, false)
			guiGridListSetItemData(GUIEditor.gridlist[2], row, Colony_Laboratory, v[2])
		end
	end
end)

addEvent("Colonys.updateWarehouseItems",true)
addEventHandler("Colonys.updateWarehouseItems",root,function(items,item_amount,item_max_amount)
	if(items)then
		guiGridListClear(GUIEditor.gridlist[4])
			
		for _,v in pairs(items) do
			if(v.id and v.amount)then
				local row = guiGridListAddRow(GUIEditor.gridlist[4])
				guiGridListSetItemText(GUIEditor.gridlist[4], row, warehouse_items, ItemInfos["items"][apocalypseGetElementData(localPlayer,"language") or "EN"][v.id], false, false)
				guiGridListSetItemText(GUIEditor.gridlist[4], row, warehouse_amount, v.amount, false, false)
			end
		end
	end
	guiSetText(GUIEditor.label[21], getText("CColonyWarehouse14"):format(item_amount,item_max_amount))
end)

addEvent("Colonys.updateWarehouseText",true)
addEventHandler("Colonys.updateWarehouseText",root,function(costs,max_amount,needed_level)
	guiSetText(GUIEditor.label[21],getText("CColonyWarehouse17"):format(costs,max_amount,needed_level))
end)

addEvent("Colonys.updateLevelData",true)
addEventHandler("Colonys.updateLevelData",root,function(level,experiencepoints,experiencepointstotal,killed_zombies)
	if(level and experiencepoints and experiencepointstotal and killed_zombies)then
		local needExperience = 2500 * (level + 1) + ((level + 1) * 25)
		guiSetText(GUIEditor.label[7],getText("CColonys55"):format(math.floor(experiencepoints),needExperience,level + 1))
		guiSetText(GUIEditor.label[9],getText("CColonys53"):format(math.floor(experiencepointstotal)))
		guiSetText(GUIEditor.label[10],getText("CColonys54"):format(killed_zombies))
	end
end)

addEvent("Colonys.createPlayerBlips",true)
addEventHandler("Colonys.createPlayerBlips",root,function()
	for i = 1,#Colonys.playerBlips do
		if(isElement(Colonys.playerBlips[i]))then
			destroyElement(Colonys.playerBlips[i])
		end
	end
	
	local counter = 0
	for _,v in pairs(getElementsByType("player"))do
		if(isCharacterLoggedIn(v))then
			if(tonumber(apocalypseGetElementData(v,"colony")) >= 1 and tonumber(apocalypseGetElementData(v,"colony")) == tonumber(apocalypseGetElementData(localPlayer,"colony")))then
				if(v ~= localPlayer)then
					counter = counter + 1
					Colonys.playerBlips[counter] = createBlipAttachedTo(v,0,2,200,200,0)
				end
			end
		end
	end
end)

addEvent("Colonys.updateAreaRewards",true)
addEventHandler("Colonys.updateAreaRewards",root,function(money,experience,brain_mass)
	guiSetText(GUIEditor.label[5],getText("CColonys24"):format(experience,brain_mass,money))
end)

addEventHandler("onClientPlayerWasted",root,function(player)
	if(player == localPlayer)then
		if(isElement(info_labor.window[1]))then
			destroyElement(info_labor.window[1])
		end
	end
end)