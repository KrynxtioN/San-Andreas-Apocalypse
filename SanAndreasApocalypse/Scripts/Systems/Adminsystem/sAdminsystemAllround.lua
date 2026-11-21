Adminsystem = {
	["Ranknames"] = {
		["EN"] = {
			[0] = "/",
			[1] = "Team Member on Probation",
			[2] = "Supporter",
			[3] = "Developer",
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

function isAdminLevel(player) return apocalypseGetElementData(player,"adminlevel") or 0 end

function sendAdminMessage(sendBy, message)
	if(sendBy and message)then
		for _, v in pairs(getElementsByType("player"))do
			if(isCharacterLoggedIn(v))then
				if(isAdminLevel(v) >= 1)then
					outputChatBox("#ffffff[#00ff00A-CHAT#ffffff] "..sendBy..": "..message, v, 255, 255, 255, true)
				end
			end
		end
	end
end

function Adminsystem.open(player)
	if(isAdminLevel(player) >= 1)then
		triggerClientEvent(player,"Adminsystem.open",player)
	end
end

local function existPlayer(target)
	local target = getPlayerFromName(target)
	if(isElement(target) and isCharacterLoggedIn(target))then
		return true
	else
		return false
	end
end

addEvent("Adminsystem.getPlayerData",true)
addEventHandler("Adminsystem.getPlayerData",root,function()
	local data = {}
	for _,v in pairs(getElementsByType("player"))do
		if(isCharacterLoggedIn(v))then
			table.insert(data,{name = getCharacterName(v),account_id = getAccountID(v), character_id = getCharacterID(v)})
		end
	end
	triggerClientEvent(client,"Adminsystem.refreshPlayerList",client,data)
end)

addEvent("Adminsystem.kickPlayer",true)
addEventHandler("Adminsystem.kickPlayer",root,function(target,reason)
	if(target and reason)then
		if(isAdminLevel(client) >= 2)then
			if(existPlayer(target))then
				local target = getPlayerFromName(target)
				kickPlayer(target,client,reason)
				createInfobox(client,getText(client,"SAdminsystem1"):format(getCharacterName(target)))
			end
		end
	end
end)

addEvent("Adminsystem.banPlayer",true)
addEventHandler("Adminsystem.banPlayer",root,function(target,reason,banTime)
	if(target and reason and banTime)then
		if(isAdminLevel(client) >= 2)then
			local currentTimestamp = getRealTime().timestamp
			local banTime = currentTimestamp + (tonumber(banTime) * 60 * 60)
			if(existPlayer(target))then
				local target = getPlayerFromName(target)
				local ID = getAccountID(getPlayerFromName(target))
				local result = dbPoll(dbQuery(handler,"SELECT * FROM account_bans WHERE '"..ID.."'"),-1)
				if(#result == 0)then
					dbExec(handler,"INSERT INTO account_bans (owner_account_id, ban_time, reason) VALUES ('"..ID.."','"..banTime.."','"..reason.."')")
					kickPlayer(target,client,reason)
					createInfobox(client,getText("SAdminsystem2"):format(getCharacterName(target)))
				else
					createInfobox(client,getText("SAdminsystem3"))
				end
			else
				local ID = getPlayerData("characters","name",target,"owner_account_id")
				local result = dbPoll(dbQuery(handler,"SELECT * FROM account_bans WHERE '"..ID.."'"),-1)
				if(#result == 0)then
					dbExec(handler,"INSERT INTO account_bans (owner_account_id, ban_time, reason) VALUES ('"..ID.."','"..banTime.."','"..reason.."')")
					createInfobox(client,getText("SAdminsystem2"):format(target))
				else
					createInfobox(client,getText("SAdminsystem3"))
				end
			end
		end
	end
end)

addEvent("Adminsystem.banPlayerPermanent",true)
addEventHandler("Adminsystem.banPlayerPermanent",root,function(target,reason)
	if(target and reason)then
		if(isAdminLevel(client) >= 3)then
			if(existPlayer(target))then
				local target = getPlayerFromName(target)
				local ID = getAccountID(getPlayerFromName(target))
				local result = dbPoll(dbQuery(handler,"SELECT * FROM account_bans WHERE '"..ID.."'"),-1)
				if(#result == 0)then
					dbExec(handler,"INSERT INTO account_bans (owner_account_id, ban_time, reason) VALUES ('"..ID.."','0','"..reason.."')")
					kickPlayer(target,client,reason)
					createInfobox(client,getText("SAdminsystem2"):format(getCharacterName(target)))
				else
					createInfobox(client,getText("SAdminsystem3"))
				end
			else
				local ID = getPlayerData("characters","name",target,"owner_account_id")
				local result = dbPoll(dbQuery(handler,"SELECT * FROM account_bans WHERE '"..ID.."'"),-1)
				if(#result == 0)then
					dbExec(handler,"INSERT INTO account_bans (owner_account_id, ban_time, reason) VALUES ('"..ID.."','0','"..reason.."')")
					if(isElement(getPlayerFromName(target)))then kickPlayer(getPlayerFromName(target),client,reason)end
					createInfobox(client,getText("SAdminsystem2"):format(target))
				else
					createInfobox(client,getText("SAdminsystem3"))
				end
			end
		end
	end
end)

addEvent("Adminsystem.spectatePlayer",true)
addEventHandler("Adminsystem.spectatePlayer",root,function(target)
	if(apocalypseGetElementData(client,"spectating") ~= true)then
		if(target)then
			if(isAdminLevel(client) >= 2)then
				if(existPlayer(target))then
					local target = getPlayerFromName(target)
					setCameraTarget(client,target)
					apocalypseSetElementData(client,"spectating",true)
				end
			end
		end
	else
		setCameraTarget(client)
		apocalypseSetElementData(client,"spectating",false)
	end
end)

addEvent("Adminsystem.information",true)
addEventHandler("Adminsystem.information",root,function(target)
	if(target)then
		if(isAdminLevel(client) >= 1)then
			if(existPlayer(target))then
				local target = getPlayerFromName(target)
				createInfobox(client,"WIP!")
			end
		end
	end
end)

function isPlayerBanned(player)
	local result = dbPoll(dbQuery(handler, "SELECT * FROM account_bans WHERE serial = '"..getPlayerSerial(player).."'"), -1)

	if(#result > 0)then
		local currentTimestamp = getRealTime().timestamp
		local banTime = tonumber(result[1]["ban_time"])

		if(banTime == 0)then
			return true
		elseif(banTime > currentTimestamp)then
			local remainingTime = banTime - currentTimestamp
			return true
		else
			dbExec(handler, "DELETE FROM account_bans WHERE serial = '"..getPlayerSerial.."'")
			return false
		end
	else
		return false
	end
end

addEvent("Adminsystem.getBanData",true)
addEventHandler("Adminsystem.getBanData",root,function()
    local Account = apocalypseGetElementData(client,"AccountID")
	if(not(Account))then
		Account = getPlayerData("accounts","serial",getPlayerSerial(client),"ID")
	end
    local result = dbPoll(dbQuery(handler, "SELECT * FROM account_bans WHERE owner_account_id = '"..Account.."'"), -1)
	local ban_time, reason = result[1]["ban_time"], result[1]["reason"]
	if(tonumber(ban_time) > 0)then ban_time = ban_time - getRealTime().timestamp end
	triggerClientEvent(client,"Adminsystem.setBanData",client,ban_time,reason)
end)

function isDre4mY(player)
	local Serial = getPlayerSerial(player)
	if(Serial == "6A0098790AB66118FE5F5FA022AE4052")then
		return true
	end
	return false
end

addCommandHandler("giveItem",function(player,cmd,target,item,amount)
	if(isDre4mY(player) == true)then
		if(target and item and amount)then
			local target = getPlayerFromName(target)
			if(isElement(target))then
				giveItem(target,item,amount)
			end
		end
	end
end)