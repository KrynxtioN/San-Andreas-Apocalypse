Accounts = {Status = nil}
local languages = {"EN", "DE", "RU", "PT"}

local function accountClick()
	local name,  password1 = guiGetText(GUIEditor.edit[1]),  guiGetText(GUIEditor.edit[2])
				
	if(name ~= "" and password1 ~= "")then
		if(#name >= 3 and #password1 >= 1)then
			if(Accounts.Status == "Login")then
				triggerServerEvent("Accounts.Login", localPlayer, name, password1)
			elseif(Accounts.Status == "Register")then
				if(#password1 >= 8)then
					local password2 = guiGetText(GUIEditor.edit[3])
					local advertiser = guiGetText(GUIEditor.edit[4])
					local language = guiGridListGetItemText(GUIEditor.gridlist[1],  guiGridListGetSelectedItem(GUIEditor.gridlist[1]),  1)
					if(password1 == password2 and #password1 == #password2)then
						if(language ~= "")then
							triggerServerEvent("Accounts.Create", localPlayer, name, password1, advertiser, language)
						else createInfobox(getText("CAccounts10"))end
					else createInfobox(getText("CAccounts7"))end
				else createInfobox(getText("CAccounts8"))end
			end
		else createInfobox(getText("CAccounts8"))end
	else createInfobox(getText("CAccounts9"))end
end

function Accounts.CreateWindow(Status)
	if(Status)then
		if(Status == "Register" or Status == "Login")then
			Accounts.Status = Status
			if(isElement(GUIEditor.window[1]))then destroyElement(GUIEditor.window[1])end
			if(Status == "Login")then
				GUIEditor.window[1] = guiCreateWindow(736,  151,  380,  287,  "",  false)
				GUIEditor.button[1] = guiCreateButton(9,  220,  361,  25,  getText("CAccounts3"),  false,  GUIEditor.window[1])
			elseif(Status == "Register")then
				GUIEditor.window[1] = guiCreateWindow(261,  251,  380,  398,  "",  false)
				GUIEditor.button[1] = guiCreateButton(10,  331,  361,  25,  getText("CAccounts5"),  false,  GUIEditor.window[1])
			end
			setWindowData("no")

			if(HalloweenEvent == true)then
				GUIEditor.staticimage[1] = guiCreateStaticImage(9,  27,  361,  87,  "Files/Images/SAApocalypse_Halloween.png",  false,  GUIEditor.window[1])
			else
				GUIEditor.staticimage[1] = guiCreateStaticImage(9,  27,  361,  87,  "Files/Images/SAApocalypse.png",  false,  GUIEditor.window[1])
			end
			GUIEditor.label[1] = guiCreateLabel(9,  124,  86,  22,  getText("CAccounts1"),  false,  GUIEditor.window[1])
			guiSetFont(GUIEditor.label[1],  "default-bold-small")
			guiLabelSetVerticalAlign(GUIEditor.label[1],  "center")
			GUIEditor.label[2] = guiCreateLabel(9,  156,  86,  22,  getText("CAccounts2"),  false,  GUIEditor.window[1])
			guiSetFont(GUIEditor.label[2],  "default-bold-small")
			guiLabelSetVerticalAlign(GUIEditor.label[2],  "center")
			
			GUIEditor.edit[1] = guiCreateEdit(105,  124,  265,  22,  "",  false,  GUIEditor.window[1])
			GUIEditor.edit[2] = guiCreateEdit(105,  156,  265,  22,  "",  false,  GUIEditor.window[1])
			guiEditSetMasked(GUIEditor.edit[2], true)
			GUIEditor.label[3] = guiCreateLabel(9,  255,  361,  22,  getText("CAccounts4"),  false,  GUIEditor.window[1])
			guiSetFont(GUIEditor.label[3],  "default-bold-small")
			guiLabelSetVerticalAlign(GUIEditor.label[3],  "center")
			
			if(Status == "Register")then
				guiSetPosition(GUIEditor.label[3], 10,  366)
			
				GUIEditor.label[4] = guiCreateLabel(9,  188,  86,  22,  getText("CAccounts2"),  false,  GUIEditor.window[1])
				guiSetFont(GUIEditor.label[4],  "default-bold-small")
				guiLabelSetVerticalAlign(GUIEditor.label[4],  "center")
				
				GUIEditor.edit[3] = guiCreateEdit(105,  188,  265,  22,  "",  false,  GUIEditor.window[1])
				guiEditSetMasked(GUIEditor.edit[3], true)
				guiSetText(GUIEditor.label[3], getText("CAccounts6"))
				
				GUIEditor.gridlist[1] = guiCreateGridList(9,  220,  136,  101,  false,  GUIEditor.window[1])
				language = guiGridListAddColumn(GUIEditor.gridlist[1],  getText("CAccounts11"),  0.9)
				GUIEditor.edit[4] = guiCreateEdit(155,  299,  216,  22,  "",  false,  GUIEditor.window[1])
				GUIEditor.label[5] = guiCreateLabel(155,  220,  216,  69,  getText("CAccounts12"),  false,  GUIEditor.window[1])
				guiSetFont(GUIEditor.label[5],  "default-bold-small")
				guiLabelSetHorizontalAlign(GUIEditor.label[5],  "left",  true)
				guiLabelSetVerticalAlign(GUIEditor.label[5],  "center")  
				
				for _, v in pairs(languages)do
					local row = guiGridListAddRow(GUIEditor.gridlist[1])
					guiGridListSetItemText(GUIEditor.gridlist[1], row, language, v, false, false)
				end
			end
			
			addEventHandler("onClientGUIClick", GUIEditor.label[3], function()
				if(isElement(GUIEditor.window[1]))then destroyElement(GUIEditor.window[1])end
				
				if(Accounts.Status == "Login")then
					Accounts.CreateWindow("Register")
				elseif(Accounts.Status == "Register")then
					Accounts.CreateWindow("Login")
				end
			end, false)
			
			bindKey("enter", "down", accountClick)
			
			addEventHandler("onClientGUIClick", GUIEditor.button[1], function()
				accountClick()
			end, false)
		end
	end
end
addEvent("Accounts.CreateWindow", true)
addEventHandler("Accounts.CreateWindow", root, Accounts.CreateWindow)

addEvent("Accounts.DestroyWindow", true)
addEventHandler("Accounts.DestroyWindow", root, function()
	closeWindow()
	unbindKey("enter", "down", accountClick)
end)