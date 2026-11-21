addEvent("ColonyTrash.setData",true)
addEventHandler("ColonyTrash.setData",root,function(cTrash,cTrash_kilo,cTrash_started,cTrash_status,level,timeLeft,formatedTime,EXP,Money)
	local max_trash = level * 500
	guiSetText(GUIEditor.label[17],getText("CColonyTrash1"):format(cTrash_started,cTrash_kilo))
	guiSetText(GUIEditor.label[15],getText("CColonyTrash2"):format(cTrash,max_trash))
	local max_trash = level * 500
	if max_trash > 0 then
		guiProgressBarSetProgress(GUIEditor.progressbar[3],cTrash/max_trash*100)
	end
	if(timeLeft < 1)then
		guiSetText(GUIEditor.label[18],getText("CColonyTrash12"):format(tonumber(cTrash_status)))
	else
		guiSetText(GUIEditor.label[18],getText("CColonyTrash14"):format(formatedTime))
	end
	if(tonumber(cTrash_status) < 25)then
		guiSetText(GUIEditor.label[19],getText("CColonyTrash13"))
	else
		guiSetText(GUIEditor.label[19],"")
	end
	guiSetText(GUIEditor.button[18],getText("CColonyTrash9"):format(EXP,Money))
end)