local screenW, screenH = guiGetScreenSize()
local isQuestAcceptedVisible = false
local animationDuration = 1000
local displayTime = 2000
local startTime = 0
local QuestWindowOpen = false

local function drawQuestAccepted()
    if(not isQuestAcceptedVisible) then return end

    local currentTime = getTickCount()
    local elapsedTime = currentTime - startTime
    local progress = math.min(elapsedTime / animationDuration, 1)
    local alpha = math.floor(progress * 255)

    if(elapsedTime > (animationDuration + displayTime)) then
        progress = (elapsedTime - animationDuration - displayTime) / animationDuration
        alpha = math.floor(255 * (1 - progress))
        if(progress >= 1) then
            isQuestAcceptedVisible = false
            removeEventHandler("onClientRender", root, drawQuestAccepted)
            return
        end
    end

    local textScale = 2 + (0.5 * math.sin(elapsedTime / 100))
    dxDrawText(Quests.dxDrawText, 0, screenH / 2 - 50, screenW, screenH / 2 + 50, tocolor(0,175,0,alpha), textScale, "pricedown", "center", "center", false, false, true)
    local questNameScale = 1.5
    dxDrawText(Quests.dxDrawTextQuestName, 0, screenH / 2 + 20, screenW, screenH / 2 + 70, tocolor(255,255,255,alpha), questNameScale, "default-bold", "center", "center")
end

function showQuestAccepted(text, id)
    Quests.dxDrawText = text
    Quests.dxDrawTextQuestName = Quests["QuestData"][apocalypseGetElementData(localPlayer, "language") or "EN"][tonumber(id)].questName or "unknown"
    isQuestAcceptedVisible = true
    startTime = getTickCount()
    addEventHandler("onClientRender", root, drawQuestAccepted)
end
addEvent("showQuestAccepted", true)
addEventHandler("showQuestAccepted", root, showQuestAccepted)

bindKey("f4","down",function()
    if(Quests.WindowOpen == true) then
        Quests.WindowOpen = false
        closeWindow()
    else
        if(isCharacterLoggedIn())then
            if(isWindowOpen())then
                GUIEditor.window[1] = guiCreateWindow(636, 313, 625, 392, getText("CQuests2"), false)
                setWindowData()
                Quests.WindowOpen = true

                GUIEditor.tabpanel[1] = guiCreateTabPanel(10, 27, 605, 355, false, GUIEditor.window[1])

                GUIEditor.tab[1] = guiCreateTab(getText("CQuests3"), GUIEditor.tabpanel[1])
                
                GUIEditor.gridlist[1] = guiCreateGridList(10, 10, 278, 311, false, GUIEditor.tab[1])
                playerQuestGridlist = guiGridListAddColumn(GUIEditor.gridlist[1], "Quest", 0.9)
                
                GUIEditor.label[1] = guiCreateLabel(298, 10, 297, 20, "", false, GUIEditor.tab[1])
                guiSetFont(GUIEditor.label[1], "default-bold-small")
                guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", false)
                guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
                
                GUIEditor.label[2] = guiCreateLabel(298, 40, 297, 249, getText("CQuestSeries7"), false, GUIEditor.tab[1])
                guiSetFont(GUIEditor.label[2], "default-bold-small")
                guiLabelSetHorizontalAlign(GUIEditor.label[2], "center", true)
                
                GUIEditor.button[1] = guiCreateButton(298, 299, 297, 20, getText("CQuests5"), false, GUIEditor.tab[1])
                
                addEventHandler("onClientGUIClick", GUIEditor.button[1], function()
                    local selectedRow = guiGridListGetSelectedItem(GUIEditor.gridlist[1])
                    if(selectedRow ~= -1) then
                        local questID = guiGridListGetItemData(GUIEditor.gridlist[1], selectedRow, playerQuestGridlist)
                        if(questID) then
                            triggerServerEvent("Quests.checkRequirements", localPlayer, questID)
                        end
                    end
                end, false)
                
                addEventHandler("onClientGUIClick", GUIEditor.gridlist[1], function()
                    local selectedRow = guiGridListGetSelectedItem(GUIEditor.gridlist[1])
                    if(selectedRow ~= -1) then
                        local questID = guiGridListGetItemData(GUIEditor.gridlist[1], selectedRow, playerQuestGridlist)
                        if(questID) then
                            guiSetText(GUIEditor.label[1], Quests["QuestData"][apocalypseGetElementData(localPlayer, "language") or "EN"][questID].questName)
                            guiSetText(GUIEditor.label[2], getText("CQuests1"):format(Quests["QuestData"][apocalypseGetElementData(localPlayer, "language") or "EN"][questID].questDescription, Quests["QuestData"][apocalypseGetElementData(localPlayer, "language") or "EN"][questID].questRewards))
                        end
                    end
                end, false)

                GUIEditor.tab[2] = guiCreateTab(getText("CQuests4"), GUIEditor.tabpanel[1])
                
                GUIEditor.label[3] = guiCreateLabel(298, 10, 297, 20, "", false, GUIEditor.tab[2])
                guiSetFont(GUIEditor.label[3], "default-bold-small")
                guiLabelSetHorizontalAlign(GUIEditor.label[3], "center", false)
                guiLabelSetVerticalAlign(GUIEditor.label[3], "center")
                
                GUIEditor.label[4] = guiCreateLabel(298, 40, 297, 249, getText("CQuestSeries7"), false, GUIEditor.tab[2])
                guiSetFont(GUIEditor.label[4], "default-bold-small")
                guiLabelSetHorizontalAlign(GUIEditor.label[4], "center", true)
                
                GUIEditor.gridlist[2] = guiCreateGridList(10, 10, 278, 311, false, GUIEditor.tab[2])
                playerQuestGridlistFinished = guiGridListAddColumn(GUIEditor.gridlist[2], "Quest", 0.9)
                
                addEventHandler("onClientGUIClick", GUIEditor.gridlist[2], function()
                    local selectedRow = guiGridListGetSelectedItem(GUIEditor.gridlist[2])
                    if(selectedRow ~= -1) then
                        local questID = guiGridListGetItemData(GUIEditor.gridlist[2], selectedRow, playerQuestGridlist)
                        if(questID) then
                            guiSetText(GUIEditor.label[3], Quests["QuestData"][apocalypseGetElementData(localPlayer, "language") or "EN"][questID].questName)
                            guiSetText(GUIEditor.label[4], getText("CQuests1"):format(Quests["QuestData"][apocalypseGetElementData(localPlayer, "language") or "EN"][questID].questDescription, Quests["QuestData"][apocalypseGetElementData(localPlayer, "language") or "EN"][questID].questRewards))
                        end
                    end
                end, false)
                
				GUIEditor.tab[3] = guiCreateTab(getText("CQuestSeriesTab") or "Quest Series", GUIEditor.tabpanel[1])
				
				if(tonumber(apocalypseGetElementData(localPlayer,"level")) < 10)then
					guiSetEnabled(GUIEditor.tab[3],false)
				end

				GUIEditor.gridlistQS = guiCreateGridList(10, 10, 278, 311, false, GUIEditor.tab[3])
				GUIEditor.qsColumn = guiGridListAddColumn(GUIEditor.gridlistQS, getText("CQuestSeries6"), 0.9)

				GUIEditor.labelQSDesc = guiCreateLabel(298, 10, 297, 160, getText("CQuestSeries7"), false, GUIEditor.tab[3])
				guiSetFont(GUIEditor.labelQSDesc, "default-bold-small")
				guiLabelSetHorizontalAlign(GUIEditor.labelQSDesc, "center", true)
				guiLabelSetVerticalAlign(GUIEditor.labelQSDesc, "center")

				GUIEditor.staticimageQS1 = guiCreateStaticImage(298, 175, 42, 41, "Files/Images/Activities/QuestStage1.png", false, GUIEditor.tab[3])
				GUIEditor.staticimageQS2 = guiCreateStaticImage(349, 175, 42, 41, "Files/Images/Activities/QuestStage2.png", false, GUIEditor.tab[3])
				GUIEditor.staticimageQS3 = guiCreateStaticImage(400, 175, 42, 41, "Files/Images/Activities/QuestStage3.png", false, GUIEditor.tab[3])

				GUIEditor.progressbarQS = guiCreateProgressBar(298, 226, 297, 19, false, GUIEditor.tab[3])
				GUIEditor.labelQSProgress = guiCreateLabel(298, 226, 297, 19, "", false, GUIEditor.tab[3])
				guiLabelSetHorizontalAlign(GUIEditor.labelQSProgress, "center", true)
				guiLabelSetVerticalAlign(GUIEditor.labelQSProgress, "center")
				guiLabelSetColor(GUIEditor.labelQSProgress,0,0,0)
				guiSetFont(GUIEditor.labelQSProgress, "default-bold-small")

				GUIEditor.labelQSEdit = guiCreateLabel(298, 275, 80, 21, getText("CQuestSeries4"), false, GUIEditor.tab[3])
				guiLabelSetHorizontalAlign(GUIEditor.labelQSEdit, "center", false)
				guiLabelSetVerticalAlign(GUIEditor.labelQSEdit, "center")
				guiSetFont(GUIEditor.labelQSEdit, "default-bold-small")
				GUIEditor.editQS = guiCreateEdit(298 + 80 + 5, 275, 212, 21, "", false, GUIEditor.tab[3])

				GUIEditor.buttonQSUpdate = guiCreateButton(298, 299, 146, 20, getText("CQuestSeries2"), false, GUIEditor.tab[3])
				GUIEditor.buttonQSReset = guiCreateButton(298 + 146 + 5, 299, 146, 20, getText("CQuestSeries3"), false, GUIEditor.tab[3])

                addEventHandler("onClientGUIClick", GUIEditor.gridlistQS, function()
                    local selectedRow = guiGridListGetSelectedItem(GUIEditor.gridlistQS)
                    if(selectedRow ~= -1) then
                        local questID = guiGridListGetItemData(GUIEditor.gridlistQS, selectedRow, GUIEditor.qsColumn)
                        if(questID) then
                            QuestSeries.clickedID = questID
                            QuestSeries.clickedStage = QuestSeries.clickedStage or 1
                            local lang = apocalypseGetElementData(localPlayer, "language")
                            local desc = QuestSeries["QuestData"][questID].Description[lang or "EN"]
                            local reward = QuestSeries["QuestData"][questID].Rewards[lang or "EN"][QuestSeries.clickedStage]
                            guiSetText(GUIEditor.labelQSDesc, desc .. "\n\n" .. reward)
                            triggerServerEvent("QuestSeries.getStageProgress", localPlayer, localPlayer, questID, QuestSeries.clickedStage)
                        end
                    end
                end, false)

                addEventHandler("onClientGUIClick", GUIEditor.staticimageQS1, function()
                    local selectedRow = guiGridListGetSelectedItem(GUIEditor.gridlistQS)
                    if(selectedRow ~= -1) then
                        local questID = guiGridListGetItemData(GUIEditor.gridlistQS, selectedRow, GUIEditor.qsColumn)
                        if(questID) then
                            QuestSeries.clickedStage = 1
                            local lang = apocalypseGetElementData(localPlayer, "language")
                            local desc = QuestSeries["QuestData"][QuestSeries.clickedID].Description[lang or "EN"]
                            local reward = QuestSeries["QuestData"][QuestSeries.clickedID].Rewards[lang or "EN"][QuestSeries.clickedStage]
                            guiSetText(GUIEditor.labelQSDesc, desc .. "\n\n" .. reward)
                            triggerServerEvent("QuestSeries.getStageProgress", localPlayer, localPlayer, questID, 1)
                        end
                    end
                end, false)
                
                addEventHandler("onClientGUIClick", GUIEditor.staticimageQS2, function()
                    local selectedRow = guiGridListGetSelectedItem(GUIEditor.gridlistQS)
                    if(selectedRow ~= -1) then
                        local questID = guiGridListGetItemData(GUIEditor.gridlistQS, selectedRow, GUIEditor.qsColumn)
                        if(questID) then
                            QuestSeries.clickedStage = 2
                            local lang = apocalypseGetElementData(localPlayer, "language")
                            local desc = QuestSeries["QuestData"][QuestSeries.clickedID].Description[lang or "EN"]
                            local reward = QuestSeries["QuestData"][QuestSeries.clickedID].Rewards[lang or "EN"][QuestSeries.clickedStage]
                            guiSetText(GUIEditor.labelQSDesc, desc .. "\n\n" .. reward)
                            triggerServerEvent("QuestSeries.getStageProgress", localPlayer, localPlayer, questID, 2)
                        end
                    end
                end, false)
                
                addEventHandler("onClientGUIClick", GUIEditor.staticimageQS3, function()
                    local selectedRow = guiGridListGetSelectedItem(GUIEditor.gridlistQS)
                    if(selectedRow ~= -1) then
                        local questID = guiGridListGetItemData(GUIEditor.gridlistQS, selectedRow, GUIEditor.qsColumn)
                        if(questID) then
                            QuestSeries.clickedStage = 3
                            local lang = apocalypseGetElementData(localPlayer, "language")
                            local desc = QuestSeries["QuestData"][QuestSeries.clickedID].Description[lang or "EN"]
                            local reward = QuestSeries["QuestData"][QuestSeries.clickedID].Rewards[lang or "EN"][QuestSeries.clickedStage]
                            guiSetText(GUIEditor.labelQSDesc, desc .. "\n\n" .. reward)
                            triggerServerEvent("QuestSeries.getStageProgress", localPlayer, localPlayer, questID, 3)
                        end
                    end
                end, false)

                addEventHandler("onClientGUIClick", GUIEditor.buttonQSUpdate, function()
                    local selectedRow = guiGridListGetSelectedItem(GUIEditor.gridlistQS)
                    if(selectedRow ~= -1) then
                        local questID = guiGridListGetItemData(GUIEditor.gridlistQS, selectedRow, GUIEditor.qsColumn)
                        if(questID) then
                            local amount = guiGetText(GUIEditor.editQS)
                            if(#amount >= 1 and isOnlyNumbers(amount)) then
                                triggerServerEvent("QuestSeries.updateStageProgress", localPlayer, questID, QuestSeries.clickedStage, amount)
                            end
                        end
                    end
                end, false)

                addEventHandler("onClientGUIClick", GUIEditor.buttonQSReset, function()
                    local selectedRow = guiGridListGetSelectedItem(GUIEditor.gridlistQS)
                    if(selectedRow ~= -1) then
                        local questID = guiGridListGetItemData(GUIEditor.gridlistQS, selectedRow, GUIEditor.qsColumn)
                        if(questID) then
                            triggerServerEvent("QuestSeries.updateStageProgress", localPlayer, questID, QuestSeries.clickedStage)
                        end
                    end
                end, false)
           
                triggerServerEvent("QuestSeries.getData", localPlayer)
                triggerServerEvent("Quests.getPlayerQuests", localPlayer)
            end
        end
    end
end)

addEvent("Quests.updateClientData", true)
addEventHandler("Quests.updateClientData", root, function(playerquests)
	if(Quests.WindowOpen == true)then
		guiGridListClear(GUIEditor.gridlist[1])
		guiGridListClear(GUIEditor.gridlist[2])
		if(playerquests) then
			for _, v in pairs(playerquests) do
				if(v.level > v.maxLevel) then
					local row = guiGridListAddRow(GUIEditor.gridlist[2])
					guiGridListSetItemText(GUIEditor.gridlist[2], row, playerQuestGridlistFinished, Quests["QuestData"][apocalypseGetElementData(localPlayer, "language") or "EN"][v.id].questName, false, false)
					guiGridListSetItemData(GUIEditor.gridlist[2], row, playerQuestGridlistFinished, v.id)
				else
					local row = guiGridListAddRow(GUIEditor.gridlist[1])
					guiGridListSetItemText(GUIEditor.gridlist[1], row, playerQuestGridlist, Quests["QuestData"][apocalypseGetElementData(localPlayer, "language") or "EN"][v.id].questName, false, false)
					guiGridListSetItemData(GUIEditor.gridlist[1], row, playerQuestGridlist, v.id)
				end
			end
		end
	end
end)

addEvent("QuestSeries.updateData", true)
addEventHandler("QuestSeries.updateData", root, function(questseries)
    if (#questseries >= 1) then
        guiGridListClear(GUIEditor.gridlistQS)
        for _, v in pairs(questseries) do
            local row = guiGridListAddRow(GUIEditor.gridlistQS)
            guiGridListSetItemText(GUIEditor.gridlistQS, row, GUIEditor.qsColumn, v[2], false, false)
            guiGridListSetItemData(GUIEditor.gridlistQS, row, GUIEditor.qsColumn, v[1])
        end
    end
end)

addEvent("QuestSeries.updateQuestProgress", true)
addEventHandler("QuestSeries.updateQuestProgress", root, function(progress, item, itemRequired)
    guiSetText(GUIEditor.labelQSProgress, getText("CQuestSeries1"):format(progress, itemRequired, item))
    guiProgressBarSetProgress(GUIEditor.progressbarQS, (progress / itemRequired) * 100)
end)

addEventHandler("onClientPlayerWasted", root, function()
    if(source == localPlayer) then
        Quests.WindowOpen = false
    end
end)