addEvent("LoginRegistrationArea.Load", true)
addEventHandler("LoginRegistrationArea.Load", root, function()
	local Serial = getPlayerSerial(client)
	local result = dbPoll(dbQuery(handler, "SELECT * FROM accounts WHERE serial = '"..Serial.."'"), -1)
	
	if(#result >= 1)then
		local skipintro = getPlayerData("accounts", "serial", Serial, "skipintro")
		if(skipintro and skipintro == 1)then
			triggerClientEvent(client, "LoginRegistrationArea.LoadIntroSkipped", client)
			MySQL.CheckAutologin(client)
		else triggerClientEvent(client, "LoginRegistrationArea.Load", client)end
	else triggerClientEvent(client, "LoginRegistrationArea.Load", client)end
end)

addEvent("LoginRegistrationArea.setLanguage", true)
addEventHandler("LoginRegistrationArea.setLanguage", root, function()
	local Serial = getPlayerSerial(client)
	local result = dbPoll(dbQuery(handler, "SELECT * FROM accounts WHERE serial = '"..Serial.."'"), -1)
	
	if(#result >= 1)then
		local language = getPlayerData("accounts", "serial", Serial, "language")
		apocalypseSetElementData(client, "language", language)
	else
		apocalypseSetElementData(client, "language", "EN")
	end
end)