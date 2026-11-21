Selfmenu = {}

function Selfmenu.getVehicleData(player)
	if(not(player))then player = client end
	local result = dbPoll(dbQuery(handler,"SELECT * FROM chest_vehicles WHERE character_id_owner = '"..getCharacterID(player).."'"),-1)
	local vehicles = {}
	if(#result >= 1)then
		for _,v in pairs(result)do
			table.insert(vehicles,{v["ID"],v["model"]})
		end
	end
	triggerClientEvent(player,"Selfmenu.setVehicleData",player,vehicles)
end
addEvent("Selfmenu.getVehicleData",true)
addEventHandler("Selfmenu.getVehicleData",root,Selfmenu.getVehicleData)

addEvent("Selfmenu.giveVehicle",true)
addEventHandler("Selfmenu.giveVehicle",root,function(databaseID)
	local databaseID = tonumber(databaseID)
	local model = getPlayerData("chest_vehicles","ID",databaseID,"model")
	if(checkPlayerVehicleFreeSlot(client) == true)then
		addPlayerVehicle(client,model)
		dbExec(handler, "DELETE FROM chest_vehicles WHERE ID = '"..databaseID.."'")
		Selfmenu.getVehicleData(client)
		createInfobox(client,getText(client,"SSelfmenu1"))
	else createInfobox(client,getText(client,"SVehicles4"))end
end)