MySQL = {}

function getPlayerData(from, where, name, data)
	if(from and where and name and data)then
		local sql = dbQuery(handler, "SELECT * FROM "..from.." WHERE "..where.." = '"..name.."'")
		if(sql)then
			local rows = dbPoll(sql, -1)
			for _, v in pairs(rows)do
				return v[data]
			end
		end
	end
end

function MySQL.CheckAccount(player)
	if(isPlayerBanned(player) == false)then
		local result = dbPoll(dbQuery(handler, "SELECT * FROM accounts WHERE serial = '"..getPlayerSerial(player).."'"), -1)
		if(#result >= 1)then Status = "Login" else Status = "Register" end
		triggerClientEvent(player, "Accounts.CreateWindow", player, Status)
	else triggerClientEvent(player,"Adminsystem.playerBannedRender",player)end
end

function MySQL.CheckAutologin(player)
	if(not(player))then player = client end
	local Serial = getPlayerSerial(player)
	local result = dbPoll(dbQuery(handler, "SELECT * FROM accounts WHERE serial = '"..Serial.."'"), -1)
	if(#result >= 1)then
		if(tonumber(getPlayerData("accounts", "serial", Serial, "autologin")) == 1)then
			Accounts.SetData(player, getPlayerData("accounts", "serial", Serial, "name"))
			local FavoriteCharakter = getPlayerData("accounts", "serial", Serial, "favoritecharacter")
			local AccountID = getPlayerData("accounts", "serial", Serial, "ID")
			apocalypseSetElementData(player, "AccountID", AccountID)
			
			if(isPlayerBanned(player) == false)then
				if(tonumber(FavoriteCharakter) > 0)then
					triggerClientEvent(player, "fadeCameraWithInformation", player, getText(player, "SMySQL1"))
					setTimer(function(player, FavChar)
						if(isElement(player))then
							Characters.ServerLogin(player, FavChar)
						end
					end, 4000, 1, player, FavoriteCharakter)
				else
					local result = dbPoll(dbQuery(handler, "SELECT * FROM characters WHERE owner_account_id = '"..apocalypseGetElementData(player, "AccountID").."'"), -1)
					if(#result == 0)then
						triggerClientEvent(player, "fadeCameraWithInformation", player, getText(player, "SMySQL1"))
						setTimer(function(player)
							if(isElement(player))then
								triggerClientEvent(player, "Characters.First", player)
							end
						end, 4000, 1, player)
					else triggerClientEvent(player, "Characters.Load", player)end
				end
			else triggerClientEvent(player,"Adminsystem.playerBannedRender",player)end
		else MySQL.CheckAccount(player)end
	else MySQL.CheckAccount(player)end
end
addEvent("MySQL.CheckAutologin", true)
addEventHandler("MySQL.CheckAutologin", root, MySQL.CheckAutologin)