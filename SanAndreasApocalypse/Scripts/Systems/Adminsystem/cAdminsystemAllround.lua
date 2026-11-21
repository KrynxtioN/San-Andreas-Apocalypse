Adminsystem = {Open = false,
	["Ranknames"] = {
		["EN"] = {
			[0] = "/",
			[1] = "Team Member on Probation",
			[2] = "Supporter",
			[3] = "Entwickler",
			[4] = "Moderator",
			[5] = "Project Manager / Owner",
		},
		["DE"] = {
			[0] = "/",
			[1] = "Teammitglied in Probezeit",
			[2] = "Supporter",
			[3] = "Developer",
			[4] = "Moderator",
			[5] = "Projektleitung / Inhaber",
		},
		["RU"] = {
			[0] = "/",
			[1] = "Сотрудник команды на испытательном сроке",
			[2] = "Саппорт",
			[3] = "Разработчик",
			[4] = "Модератор",
			[5] = "Руководитель проекта / Владелец",
		},
		["PT"] = {
			[0] = "/",
			[1] = "Membro da Equipe em Período de Experiência",
			[2] = "Apoiador",
			[3] = "Desenvolvedor",
			[4] = "Moderador",
			[5] = "Gerente de Projeto / Proprietário",
		},
	},
}

addEvent("Adminsystem.open",true)
addEventHandler("Adminsystem.open",root,function()
	if(Adminsystem.Open == true)then
		Adminsystem.Open = false
		closeWindow()
	else
		if(isWindowOpen())then
			GUIEditor.window[1] = guiCreateWindow(419, 286, 650, 377, getText("CAdminsystem8"), false)
			setWindowData()
			Adminsystem.Open = true
			
			GUIEditor.tabpanel[1] = guiCreateTabPanel(10, 27, 630, 340, false, GUIEditor.window[1])
			GUIEditor.tab[1] = guiCreateTab(getText("CAdminsystem21"), GUIEditor.tabpanel[1])
			
			--GUIEditor.tab[2] = guiCreateTab(getText("CAdminsystem20"), GUIEditor.tabpanel[1])

			GUIEditor.gridlist[1] = guiCreateGridList(7, 44, 202, 262, false, GUIEditor.tab[1])
			playername = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CAdminsystem9"), 0.5)
			account_id = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CAdminsystem10"), 0.3)
			character_id = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CAdminsystem11"), 0.3)
			GUIEditor.edit[1] = guiCreateEdit(7, 10, 202, 24, getText("CAdminsystem12").."...", false, GUIEditor.tab[1])
			GUIEditor.button[1] = guiCreateButton(219, 44, 122, 25, getText("CAdminsystem13"), false, GUIEditor.tab[1])
			GUIEditor.button[2] = guiCreateButton(219, 79, 122, 25, getText("CAdminsystem14"), false, GUIEditor.tab[1])
			GUIEditor.checkbox[1] = guiCreateCheckBox(483, 79, 137, 25, getText("CAdminsystem15"), true, false, GUIEditor.tab[1])
			GUIEditor.button[3] = guiCreateButton(351, 79, 122, 25, getText("CAdminsystem16"), false, GUIEditor.tab[1])
			GUIEditor.edit[2] = guiCreateEdit(351, 114, 122, 26, "", false, GUIEditor.tab[1])
			GUIEditor.label[1] = guiCreateLabel(219, 114, 122, 26, getText("CAdminsystem17"), false, GUIEditor.tab[1])
			guiSetFont(GUIEditor.label[1], "default-bold-small")
			guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", false)
			guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
			GUIEditor.button[4] = guiCreateButton(351, 44, 122, 25, getText("CAdminsystem18"), false, GUIEditor.tab[1])
			GUIEditor.button[5] = guiCreateButton(483, 44, 122, 25, getText("CAdminsystem19"), false, GUIEditor.tab[1])
			
			GUIEditor.button[6] = guiCreateButton(219, 149, 122, 26, getText("CAdminsystem22"), false, GUIEditor.tab[1])
			
			--GUIEditor.tab[3] = guiCreateTab(getText("CAdminsystem22"), GUIEditor.tabpanel[1])
			
			triggerServerEvent("Adminsystem.getPlayerData",localPlayer)

			addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
				local clicked = guiGridListGetItemText(GUIEditor.gridlist[1],guiGridListGetSelectedItem(GUIEditor.gridlist[1]),1)
				if(clicked ~= "")then
					triggerServerEvent("Adminsystem.kickPlayer",localPlayer,clicked)
				else createInfobox(getText("CAdminsystem1"))end
			end,false)

			addEventHandler("onClientGUIClick",GUIEditor.button[2],function()
				local clicked = guiGridListGetItemText(GUIEditor.gridlist[1],guiGridListGetSelectedItem(GUIEditor.gridlist[1]),1)
				local reason = guiGetText(GUIEditor.edit[1])
				local banTime = guiGetText(GUIEditor.edit[2])
		
				if(clicked ~= "" and #reason >= 1 and #banTime >= 1)then
					if(guiCheckBoxGetSelected(GUIEditor.checkbox[1]) == true)then
						triggerServerEvent("Adminsystem.banPlayer",localPlayer,clicked,reason,banTime)
					end
				else createInfobox(getText("CAdminsystem2"))end
			end,false)

			addEventHandler("onClientGUIClick",GUIEditor.button[3],function()
				local clicked = guiGridListGetItemText(GUIEditor.gridlist[1],guiGridListGetSelectedItem(GUIEditor.gridlist[1]),1)
				local reason = guiGetText(GUIEditor.edit[1])
				
				if(clicked ~= "" and #reason >= 1)then
					if(guiCheckBoxGetSelected(GUIEditor.checkbox[1]) == true)then
						triggerServerEvent("Adminsystem.banPlayerPermanent",localPlayer,clicked,reason)
					end
				else createInfobox(getText("CAdminsystem3"))end
			end,false)
				
			addEventHandler("onClientGUIClick",GUIEditor.button[4],function()
				local clicked = guiGridListGetItemText(GUIEditor.gridlist[1],guiGridListGetSelectedItem(GUIEditor.gridlist[1]),1)
				
				if(clicked ~= "")then
					triggerServerEvent("Adminsystem.spectatePlayer",localPlayer,clicked)
				else createInfobox(getText("CAdminsystem1"))end
			end,false)
				
			addEventHandler("onClientGUIClick",GUIEditor.button[5],function()
				local clicked = guiGridListGetItemText(GUIEditor.gridlist[1],guiGridListGetSelectedItem(GUIEditor.gridlist[1]),1)
					
				if(clicked ~= "")then
					triggerServerEvent("Adminsystem.information",localPlayer,clicked)
				else createInfobox(getText("CAdminsystem1"))end
			end,false)
			
			addEventHandler("onClientGUIClick",GUIEditor.button[6],function()
				openLogUI()
			end,false)
		end
	end
end)

addEvent("Adminsystem.refreshPlayerList",true)
addEventHandler("Adminsystem.refreshPlayerList",root,function(data)
	for _, v in pairs(data)do
		local row = guiGridListAddRow(GUIEditor.gridlist[1])
		guiGridListSetItemText(GUIEditor.gridlist[1],row,playername,v.name,false,false)
		guiGridListSetItemText(GUIEditor.gridlist[1],row,account_id,v.account_id,false,false)
		guiGridListSetItemText(GUIEditor.gridlist[1],row,character_id,v.character_id,false,false)
	end
end)

local banReason = ""
local banRemainingTime = 0
local permanentBan = false

function Adminsystem.playerBannedRender()
	local screenW, screenH = guiGetScreenSize()

    local years = math.floor(banRemainingTime / (3600 * 24 * 365))
    local days = math.floor((banRemainingTime % (3600 * 24 * 365)) / (3600 * 24))
    local hours = math.floor((banRemainingTime % (3600 * 24)) / 3600)
    local minutes = math.floor((banRemainingTime % 3600) / 60)
    local seconds = banRemainingTime % 60

    dxDrawRectangle(screenW * 0.25, screenH * 0.3, screenW * 0.5, screenH * 0.4, tocolor(0, 0, 0, 150))

    dxDrawText(getText("CAdminsystem4"), screenW * 0.25, screenH * 0.32, screenW * 0.75, screenH * 0.36, tocolor(255, 0, 0, 255), 1.5, "default-bold", "center", "top")
    dxDrawText(getText("CAdminsystem5"):format(banReason), screenW * 0.25, screenH * 0.42, screenW * 0.75, screenH * 0.46, tocolor(255, 255, 255, 255), 1.2, "default", "center", "top")

    if(permanentBan == true)then
        dxDrawText(getText("CAdminsystem6"), screenW * 0.25, screenH * 0.48, screenW * 0.75, screenH * 0.52, tocolor(255, 255, 255, 255), 1.2, "default", "center", "top")
    else
        dxDrawText(getText("CAdminsystem7"):format(years, days, hours, minutes, seconds), screenW * 0.25, screenH * 0.48, screenW * 0.75, screenH * 0.52, tocolor(255, 255, 255, 255), 1.2, "default", "center", "top")
    end
end

addEvent("Adminsystem.playerBannedRender", true)
addEventHandler("Adminsystem.playerBannedRender", root, function()
	if(not(isTimer(Adminsystem.banTimer)))then
		Adminsystem.banTimer = setTimer(function()
			if(banRemainingTime > 0)then
				banRemainingTime = banRemainingTime - 1
				if(banRemainingTime == 0 and permanentBan == false)then
					killTimer(Adminsystem.banTimer)
					removeEventHandler("onClientRender",root,Adminsystem.playerBannedRender)
					triggerServerEvent("MySQL.CheckAutologin",localPlayer,localPlayer)
				end
			end
		end, 1000, 0)
	end

    triggerServerEvent("Adminsystem.getBanData", localPlayer)
    addEventHandler("onClientRender", root, Adminsystem.playerBannedRender)
end)

addEvent("Adminsystem.setBanData", true)
addEventHandler("Adminsystem.setBanData", root, function(ban_time, reason)
    banReason = reason
    banRemainingTime = tonumber(ban_time)
	if(banRemainingTime == 0)then permanentBan = true end
end)

addEventHandler("onClientPlayerWasted",root,function()
	if(source == localPlayer)then
		Adminsystem.Open = false
	end
end)