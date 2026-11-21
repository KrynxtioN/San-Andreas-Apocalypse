Accounts = {}

function getAccountID(player)
	return apocalypseGetElementData(player,"AccountID")
end

-- // Recruited Players
local Recruited_Players_Timer = {}
local Recruited_Players = {}

function RecruitedPlayersLoadData(player)
	local recruitedData = getPlayerData("accounts","ID",apocalypseGetElementData(player,"AccountID"),"recruitedplayers")
	Recruited_Players[player] = {}
	
	local values = split(recruitedData,"|")
	for _,v in pairs(values)do
		table.insert(Recruited_Players[player],v)
	end
	
	Recruited_Players_Timer[player] = setTimer(function(player)
		if(isElement(player))then
			if(isCharacterLoggedIn(player))then
				for _,v in pairs(Recruited_Players[player])do
					if(isElement(v))then
						if(isCharacterLoggedIn(v))then
							giveEXP(player,75)
						end
					end
				end
			end
		end
	end,60000,0,player)
end

addEventHandler("onPlayerQuit",root,function()
	if(isTimer(Recruited_Players_Timer[source]))then killTimer(Recruited_Players_Timer[source])end
	Recruited_Players[source] = nil
	Recruited_Players_Timer[source] = nil
end)

addEvent("Accounts.Create", true)
addEventHandler("Accounts.Create", root, function(name, password, advertiser, language)
	local serial = getPlayerSerial(client)
	local result = dbPoll(dbQuery(handler, "SELECT * FROM accounts WHERE serial = '"..serial.."'"), -1)
	
	if(#result == 0)then
		local result = dbPoll(dbQuery(handler, "SELECT * FROM accounts WHERE name = '"..name.."'"), -1)
		if(#result == 0)then
			if(#advertiser >= 1)then
				local resultAdvertiser = dbPoll(dbQuery(handler, "SELECT * FROM accounts WHERE name = '"..advertiser.."'"), -1)
				if(#resultAdvertiser >= 1)then
					local recruitedplayers = getPlayerData("accounts", "name", advertiser, "recruitedplayers")
					dbExec(handler, "UPDATE accounts SET recruitedplayers = '"..recruitedplayers..name.."|' WHERE name = '"..advertiser.."'")
				else
					createInfobox(client, getText(client,"SAccounts5"))
					return
				end
			end
			
			local hashedPassword = passwordHash(password, "bcrypt", {})
			dbExec(handler, "INSERT INTO accounts (name, password, serial, language) VALUES ('"..name.."', '"..hashedPassword.."', '"..serial.."', '"..language.."')")
			
			local AccountID = getPlayerData("accounts", "name", name, "ID")
			apocalypseSetElementData(client, "AccountID", AccountID)
				
			Accounts.SetData(client, name)
			
			Characters.Check(client)
		else createInfobox(client, getText(client, "SAccounts1"))end
	else createInfobox(client, getText(client, "SAccounts2"):format(getPlayerData("accounts", "serial", serial, "name")))end 
end)

addEvent("Accounts.Login", true)
addEventHandler("Accounts.Login", root, function(name, password)
	local result = dbPoll(dbQuery(handler, "SELECT * FROM accounts where name = '"..name.."'"), -1)
	
	if(#result >= 1)then
		local hashedPassword = getPlayerData("accounts", "name", name, "password")
		if(passwordVerify(password, hashedPassword))then
			local AccountID = getPlayerData("accounts", "name", name, "ID")
			apocalypseSetElementData(client, "AccountID", AccountID)
		
			Accounts.SetData(client, name)
			Characters.Check(client)
		else createInfobox(client, getText(client, "SAccounts3"))end
	else createInfobox(client, getText(client, "SAccounts4"))end
end)

function Accounts.SetData(player, Name)
	apocalypseSetElementData(player, "Account:Status", "LoggedIn")
	apocalypseSetElementData(player, "AccountName", Name)
	triggerClientEvent(player, "Accounts.DestroyWindow", player)
	apocalypseSetElementData(player, "language", getPlayerData("accounts", "name", Name, "language"))
end