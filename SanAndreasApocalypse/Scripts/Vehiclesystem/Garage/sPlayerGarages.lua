PlayerGarages = {Objects = {},
	["Doors"] = {
		{10575,-2045.3955078125,20.169200897217,36.289100646973,0,0,90},
		{10575,-1501.6193847656,905.19372558594,8.163800239563,0,0,0},
		{10575,-1501.6086425781,898.16839599609,8.163800239563,0,0,0},
		{10575,-1501.5979003906,891.11798095703,8.163800239563,0,0,0},
		{10575,-1501.5871582031,884.09320068359,8.163800239563,0,0,0},
		{10575,-1501.5765380859,877.0927734375,8.163800239563,0,0,0},
		{10575,-2069.677734375,1423.5787353516,8.0777997970581,0,0,0},
		{10575,-2069.6328125,1416.453125,8.0777997970581,0,0,0},
		{10575,-2069.6608886719,1409.5030517578,8.0777997970581,0,0,0},
		{10575,-2069.58984375,1402.5017089844,8.0777997970581,0,0,0},
		{10575,-2069.619140625,1395.4517822266,8.0777997970581,0,0,0},
	},
}

for i,v in ipairs(PlayerGarages["Doors"])do
	PlayerGarages.Objects[i] = createObject(v[1],v[2],v[3],v[4],v[5],v[6],v[7])
	apocalypseSetElementData(PlayerGarages.Objects[i],"PlayerGaragesID",i)
	apocalypseSetElementData(PlayerGarages.Objects[i],"GarageStatus","up")
	apocalypseSetElementData(PlayerGarages.Objects[i],"Owner",getPlayerData("garages","ID",i,"owner"))
	apocalypseSetElementData(PlayerGarages.Objects[i],"Moving",false)
end

function PlayerGarages.moveObject(object)
	local id = apocalypseGetElementData(object,"PlayerGaragesID")
	if(isElement(object))then
		local x,y,z = getElementPosition(object)
		local status = apocalypseGetElementData(object,"GarageStatus")
		if(apocalypseGetElementData(object,"Moving") == false)then
			if(status == "down")then
				apocalypseSetElementData(object,"GarageStatus","up")
				moveObject(object,2000,x,y,z+3.5)
				apocalypseSetElementData(object,"Moving",true)
				setTimer(function(object)
					apocalypseSetElementData(object,"Moving",false)
				end,2000,1,object)
			end
			if(status == "up")then
				apocalypseSetElementData(object,"GarageStatus","down")
				moveObject(object,2000,x,y,z-3.5)
				apocalypseSetElementData(object,"Moving",true)
				setTimer(function(object)
					apocalypseSetElementData(object,"Moving",false)
				end,2000,1,object)
			end
		end
	end
end

addCommandHandler("mg",function(player)
	if(isCharacterLoggedIn(player))then
		for _,v in pairs(PlayerGarages.Objects)do
			local x,y,z = getElementPosition(v)
			if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(player)) <= 10)then
				local owner = apocalypseGetElementData(v,"Owner")
				if(owner == getCharacterID(player))then
					PlayerGarages.moveObject(v)
					return
				end
			end
		end
	end
end)

addEvent("PlayerGarages.buy",true)
addEventHandler("PlayerGarages.buy",root,function()
	local GarageID = apocalypseGetElementData(client,"PlayerGaragesID")
	local owner = tonumber(apocalypseGetElementData(PlayerGarages.Objects[GarageID],"Owner"))
	if(owner == 0)then
		if(tonumber(apocalypseGetElementData(client,"money")) >= 10000)then
			createInfobox(client,getText(client,"SPlayerGarages2"))
			apocalypseSetElementData(client,"money",apocalypseGetElementData(client,"money")-10000)
			apocalypseSetElementData(PlayerGarages.Objects[GarageID],"Owner",getCharacterID(client))
			dbExec(handler,"UPDATE garages SET owner = '"..getCharacterID(client).."' WHERE ID = '"..GarageID.."'")
			triggerClientEvent(client,"closeWindow",client)
			setAchievement(client,272)
		else
			createInfobox(client,getText(client,"SPlayerGarages1"))
		end
	end
end)

addEvent("PlayerGarages.sell",true)
addEventHandler("PlayerGarages.sell",root,function()
	local GarageID = apocalypseGetElementData(client,"PlayerGaragesID")
	local owner = tonumber(apocalypseGetElementData(PlayerGarages.Objects[GarageID],"Owner"))
	if(owner == tonumber(getCharacterID(client)))then
		createInfobox(client,getText(client,"SPlayerGarages3"))
		local money = 10000/100*75
		apocalypseSetElementData(client,"money",apocalypseGetElementData(client,"money")+money)
		apocalypseSetElementData(PlayerGarages.Objects[GarageID],"Owner",0)
		dbExec(handler,"UPDATE garages SET owner = '0' WHERE ID = '"..GarageID.."'")
		triggerClientEvent(client,"closeWindow",client)
	end
end)

addEventHandler("onPlayerClick", root, function(button, state, clickedElement)
	if ((button == "left" or button == "right") and state == "down" and clickedElement) then
		local ID = tonumber(apocalypseGetElementData(clickedElement, "PlayerGaragesID"))
		local x,y,z = getElementPosition(source)
		if(ID)then
			if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(clickedElement)) <= 5.0)then
				local owner_name = getPlayerData("characters","ID",tonumber(apocalypseGetElementData(PlayerGarages.Objects[ID],"Owner")),"name") or "/"
				triggerClientEvent(source,"PlayerGarages.createWindow",source,owner_name,10000)
				apocalypseSetElementData(source,"PlayerGaragesID",ID)
			end
		end
	end
end)