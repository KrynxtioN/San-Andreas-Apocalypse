Tents = {Objects = {}, Col = {}}

addEvent("Tents.Place", true)
addEventHandler("Tents.Place", root, function(vx, vy, vz, vrot)
    local player = client
	if(hasPlayerItem(player,181) >= 1)then
		if(getElementInterior(player) == 0 and getElementDimension(player) == 0)then
			takeItem(player,181)
			setPedAnimation(player,"BOMBER","BOM_Plant",5000,false,false,nil,false)
			dbExec(handler, "INSERT INTO tents (pos_x,pos_y,pos_z,pos_rot_z,character_owner_id) VALUES (?,?,?,?,?)",
				vx, vy, vz, vrot, getCharacterID(player))
			Tents.loadObjects()
			NPC.MeMessage(player, getText(player,"STents1"))
			setAchievement(player,417)
		end
	end
end)

function Tents.loadObjects()
	local result = dbPoll(dbQuery(handler,"SELECT * FROM tents"),-1)
	if(#result >= 1)then
		for _,v in pairs(result)do
			if(not(isElement(Tents.Objects[v["ID"]])))then
				Tents.Objects[v["ID"]] = createObject(3243,v["pos_x"],v["pos_y"],v["pos_z"],0,0,v["pos_rot_z"])
				Tents.Col[v["ID"]] = createColSphere(v["pos_x"],v["pos_y"],v["pos_z"],4)
				attachElements(Tents.Col[v["ID"]],Tents.Objects[v["ID"]])
				apocalypseSetElementData(Tents.Col[v["ID"]],"TentID",v["ID"])
				apocalypseSetElementData(Tents.Col[v["ID"]],"TentOwner",v["character_owner_id"])
				
				addEventHandler("onColShapeHit",Tents.Col[v["ID"]],function(player,matchingDimension)
					if(getElementType(player) == "player")then
						apocalypseSetElementData(player,"Tent_Interact_ID",apocalypseGetElementData(source,"TentID"))
						local owner = apocalypseGetElementData(source,"TentOwner")
						if(owner == getCharacterID(player))then
							triggerClientEvent(player,"Tents.openWindow",player)
						else
							NPC.MeMessage(player,getText(player,"STents2"))
						end
					end
				end)
			end
		end
	end
end
Tents.loadObjects()