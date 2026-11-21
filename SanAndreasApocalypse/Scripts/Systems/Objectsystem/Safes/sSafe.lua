addEvent("PlayerSafe.StorageMoney_TakeOut", true)
addEventHandler("PlayerSafe.StorageMoney_TakeOut", root, function(amount)
	local amount = tonumber(amount)
	local SafeID = apocalypseGetElementData(client,"SafeObject_ActiveID")
	local SafeMoney = tonumber(getPlayerData("objects","ID",SafeID,"money"))
	if(SafeMoney >= amount)then
		dbExec(handler,"UPDATE objects SET money = '"..SafeMoney - amount.."' WHERE ID = '"..SafeID.."'")
		givePlayerServerMoney(client,amount)
		createInfobox(client, getText(client, "SSafe2"):format(amount))
		triggerClientEvent(client, "PlayerSafe.updateLabel", client, SafeMoney - amount)
	else
		createInfobox(client, getText(client, "SSafe1"))
	end
end)

addEvent("PlayerSafe.StorageMoney_PutIn", true)
addEventHandler("PlayerSafe.StorageMoney_PutIn", root, function(amount)
	local amount = tonumber(amount)
	local SafeID = apocalypseGetElementData(client,"SafeObject_ActiveID")
	local SafeMoney = tonumber(getPlayerData("objects","ID",SafeID,"money"))
	if(SafeMoney + amount <= 50000)then
		if(tonumber(apocalypseGetElementData(client, "money")) >= amount)then
			dbExec(handler,"UPDATE objects SET money = '"..SafeMoney + amount.."' WHERE ID = '"..SafeID.."'")
			apocalypseSetElementData(client, "money", apocalypseGetElementData(client, "money")-amount)
			createInfobox(client, getText(client, "SSafe4"):format(amount))
			triggerClientEvent(client, "PlayerSafe.updateLabel", client, SafeMoney + amount)
		else
			createInfobox(client, getText(client, "SSafe3"))
		end
	else
		NPC.MeMessage(client,getText(client,"MeMessage18"))
	end
end)

addEvent("PlayerSafe.getData", true)
addEventHandler("PlayerSafe.getData", root, function()
	local SafeID = apocalypseGetElementData(client,"SafeObject_ActiveID")
	local SafeMoney = getPlayerData("objects","ID",SafeID,"money")
	triggerClientEvent(client, "PlayerSafe.updateLabel", client, SafeMoney)
end)