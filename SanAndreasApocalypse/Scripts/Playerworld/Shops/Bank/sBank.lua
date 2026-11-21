Bank = {}

addEvent("Bank.cashOut",true)
addEventHandler("Bank.cashOut",root,function(amount)
	local amount = tonumber(amount)
	local bank_money = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"bank_money"))
	if(bank_money >= amount)then
		dbExec(handler,"UPDATE character_stats set bank_money = '"..bank_money - amount.."' WHERE character_id = '"..getCharacterID(client).."'")
		givePlayerServerMoney(client,amount)
		triggerClientEvent(client,"Bank.updateLabel",client, bank_money - amount)
		createInfobox(client,getText(client,"SBank2"):format(amount))
		outputLog(getPlayerName(client).." hat $"..amount.." ausgezahlt","ATM",getCharacterID(client))
	else
		NPC.MeMessage(client,getText(client,"SBank1"))
	end
end)

addEvent("Bank.cashIn",true)
addEventHandler("Bank.cashIn",root,function(amount)
	local amount = tonumber(amount)
	local bank_money = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"bank_money"))
	if(tonumber(apocalypseGetElementData(client, "money")) >= amount)then
		dbExec(handler,"UPDATE character_stats set bank_money = '"..bank_money + amount.."' WHERE character_id = '"..getCharacterID(client).."'")
		apocalypseSetElementData(client, "money", apocalypseGetElementData(client, "money")-amount)
		triggerClientEvent(client,"Bank.updateLabel",client, bank_money + amount)
		createInfobox(client,getText(client,"SBank4"):format(amount))
		outputLog(getPlayerName(client).." hat $"..amount.." eingezahlt","ATM",getCharacterID(client))
	else
		NPC.MeMessage(client,getText(client,"SBank3"))
	end
end)

addEvent("Bank.getData",true)
addEventHandler("Bank.getData",root,function()
	local bank_money = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"bank_money"))
	triggerClientEvent(client,"Bank.updateLabel",client,bank_money)
end)

function takeMoneyFromPlayerBank(player,amount)
	local amount = tonumber(amount)
	local bank_money = tonumber(getPlayerData("character_stats","character_id",getCharacterID(player),"bank_money"))
	if(bank_money and bank_money >= amount)then
		dbExec(handler,"UPDATE character_stats set bank_money = '"..bank_money - amount.."' WHERE character_id = '"..getCharacterID(player).."'")
	end
end

function getPlayerBankMoney(player)
	local bank_money = tonumber(getPlayerData("character_stats","character_id",getCharacterID(player),"bank_money"))
	return bank_money
end