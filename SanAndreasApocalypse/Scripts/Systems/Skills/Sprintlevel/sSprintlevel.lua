Sprintlevel = {}

function Sprintlevel.load(player)
	local level = tonumber(getPlayerData("character_stats","character_id",getCharacterID(player),"sprintlevel"))
	local level_process = tonumber(getPlayerData("character_stats","character_id",getCharacterID(player),"sprintlevel_process"))
	triggerClientEvent(player,"Sprintlevel.load",player,level,level_process)
end

addEvent("Sprintlevel.save",true)
addEventHandler("Sprintlevel.save",root,function(level,level_process)
	outputLog(getPlayerName(client).." is now sprint level "..level.." with a progress of "..level_process,"sprintlevel", getCharacterID(client))
	dbExec(handler,"UPDATE character_stats SET sprintlevel = '"..level.."', sprintlevel_process = '"..level_process.."' WHERE character_id = '"..getCharacterID(client).."'")
end)

addEvent("sprintLevelServerFat",true)
addEventHandler("sprintLevelServerFat",root,function()
	if(apocalypseGetElementData(client,"player_fat") > 0)then
		apocalypseSetElementData(client,"player_fat",apocalypseGetElementData(client,"player_fat")-5)
		setPedStat(client,21,apocalypseGetElementData(client,"player_fat"))
	end
	if(apocalypseGetElementData(client,"player_fat") < 0)then apocalypseSetElementData(client,"player_fat",0)end
end)

addEventHandler("onPlayerQuit",root,function() triggerClientEvent(source,"Sprintlevel.quit",source) end)