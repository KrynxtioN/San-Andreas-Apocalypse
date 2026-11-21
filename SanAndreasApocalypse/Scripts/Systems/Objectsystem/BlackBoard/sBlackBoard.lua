addEvent("BlackBoard.saveText",true)
addEventHandler("BlackBoard.saveText",root,function(text)
	local ID = apocalypseGetElementData(client,"BlackBoard_ActiveID")
	if(ID)then
		dbExec(handler,"UPDATE objects SET text = '"..text.."' WHERE ID = '"..ID.."'")
		createInfobox(client,getText(client,"SBlackBoard2"))
	end
end)