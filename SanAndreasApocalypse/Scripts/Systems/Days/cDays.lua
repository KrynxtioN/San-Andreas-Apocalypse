ServerTime = {}
ServerTime.Hour = 0
ServerTime.Minute = 0
ServerTime.GameDay = "Monday"

local weekDays = {
	["EN"] = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"},
	["DE"] = {"Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"},
	["RU"] = {"Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"},
	["PT"] = {"Segunda-feira", "Terça-feira", "Quarta-feira", "Quinta-feira", "Sexta-feira", "Sábado", "Domingo"},
}

addEvent("ServerTime.updateData", true)
addEventHandler("ServerTime.updateData", root, function(hour, minute, day)
	ServerTime.Hour = hour
	ServerTime.Minute = minute
	ServerTime.GameDay = weekDays[apocalypseGetElementData(localPlayer, "language") or "EN"][day]
end)

addEvent("clientSetWeather",true)
addEventHandler("clientSetWeather",root,function(weather)
	if(apocalypseGetElementData(localPlayer,"halloween_effects") == "off")then
		local weather = tonumber(weather)
		setWeather(weather)
	end
end)