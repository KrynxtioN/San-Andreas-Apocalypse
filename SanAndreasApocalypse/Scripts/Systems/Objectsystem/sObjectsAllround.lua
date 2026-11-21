Objectsystem = {Objects = {}, Marker = {},
	["Weaponboxes"] = {
		{-1981.02734375,109.85040283203,27.564599990845,0,0,90},
		{-2238.4099121094,2380.4775390625,4.9042000770569,0,0,80},
		{194.65530395508,-258.27130126953,1.4629000425339,0,0,80},
	},
}

local ModelItems = {[1463] = 35, [944] = 110, [3927] = 116, [2332] = 121, [1808] = 127, [1271] = 131}

for _,v in pairs(Objectsystem["Weaponboxes"])do
	local object = createObject(944,v[1],v[2],v[3],v[4],v[5],v[6])
	apocalypseSetElementData(object,"Weaponbox",true)
end

function Objectsystem.loadObjects()
	local result = dbPoll(dbQuery(handler,"SELECT * FROM objects"),-1)
	if(result and #result >= 1)then
		for _, v in pairs(result)do
			if(not(isElement(Objectsystem.Objects[v["ID"]])))then
				Objectsystem.Objects[v["ID"]] = createObject(
					v["model"],
					v["pos_x"],
					v["pos_y"],
					v["pos_z"],
					v["rot_x"],
					v["rot_y"],
					v["rot_z"]
				)
				local NewObject = Objectsystem.Objects[v["ID"]]
				setElementInterior(NewObject,v["spawn_int"])
				setElementDimension(NewObject,v["spawn_dim"])
				setObjectBreakable(NewObject,false)
				setElementDoubleSided(NewObject, true)
				
				Objectsystem.Marker[v["ID"]] = createMarker(v["pos_x"],v["pos_y"],v["pos_z"],"cylinder",7.5,0,0,0,0)
				local Hit_Marker = Objectsystem.Marker[v["ID"]]
				apocalypseSetElementData(Hit_Marker,"Hit_Marker_Owner",getPlayerData("characters","ID",v["owner"],"name"))
				setElementInterior(Hit_Marker,v["spawn_int"])
				setElementDimension(Hit_Marker,v["spawn_dim"])
				apocalypseSetElementData(Hit_Marker,"Object_ID",v["ID"])

				addEventHandler("onMarkerHit",Hit_Marker,function(player)
					if(getElementType(player) == "player")then
						if(getElementDimension(player) == getElementDimension(source))then
							local Owner_Name = apocalypseGetElementData(source,"Hit_Marker_Owner")
							local x,y,z = getElementPosition(source)
							local Marker_Object_ID = apocalypseGetElementData(source,"Object_ID")
							triggerClientEvent(player,"ObjectLabel.show",player,x,y,z,Owner_Name,Marker_Object_ID)
						end
					end
				end)
				
				addEventHandler("onMarkerLeave",Hit_Marker,function(player)
					if(getElementType(player) == "player")then
						if(getElementDimension(player) == getElementDimension(source))then
							local Marker_Object_ID = apocalypseGetElementData(source,"Object_ID")
							triggerClientEvent(player,"ObjectLabel.hide",player,Marker_Object_ID)
						end
					end
				end)
				
				apocalypseSetElementData(NewObject,"ServerObject",true)
				apocalypseSetElementData(NewObject,"ServerObjectID",v["ID"])
				apocalypseSetElementData(NewObject,"Owner.CharacterID",v["owner"])
				
				if(v["model"] == 1463)then createCampfire(NewObject) end
				if(v["model"] ==  944)then apocalypseSetElementData(NewObject,"Weaponbox",true) end
				if(v["model"] == 3927)then
					apocalypseSetElementData(NewObject,"BlackBoard",true)
					apocalypseSetElementData(NewObject,"BlackBoard_CharacterID_Owner",v["owner"])
				end
				if(v["model"] == 2332)then
					apocalypseSetElementData(NewObject,"SafeObject",true)
					apocalypseSetElementData(NewObject,"SafeObject_CharacterID_Owner",v["owner"])
				end
				if(v["model"] == 1808)then
					apocalypseSetElementData(NewObject,"WaterDispenser",true)
				end
				if(v["model"] == 1271)then
					apocalypseSetElementData(NewObject,"StorageCrate",true)
					apocalypseSetElementData(NewObject,"StorageCrate_CharacterID_Owner",v["owner"])
				end
			end
		end
	end
end
Objectsystem.loadObjects()

addEvent("Objectsystem.place",true)
addEventHandler("Objectsystem.place",root,function(model,x,y,z,rx,ry,rz)
	if(apocalypseGetElementData(client,"furniture_shop") ~= true)then
		if(hasPlayerItem(client,tonumber(ModelItems[model])) >= 1)then
			takeItem(client,ModelItems[model],1)
		else
			return false
		end
	else
		if(hasPlayerFurniture(client,model) >= 1)then
			takeFurniture(client,model,1)
		else
			return false
		end
	end
	
	dbExec(handler,"INSERT INTO objects (owner, pos_x, pos_y, pos_z, rot_x, rot_y, rot_z, spawn_int, spawn_dim, model,text,money,storage) VALUES ('"..getCharacterID(client).."', '"..x.."', '"..y.."', '"..z.."', '"..rx.."', '"..ry.."', '"..rz.."', '"..getElementInterior(client).."', '"..getElementDimension(client).."', '"..model.."','','','')")
	Objectsystem.loadObjects()
end)

addEventHandler("onPlayerClick",root,function(button,state,clickedElement)
	if(isCharacterLoggedIn(source))then
		if(button == "left" and state == "down")then
			if(clickedElement and isElement(clickedElement))then
				if(getElementType(clickedElement) == "object")then
					if(apocalypseGetElementData(clickedElement,"ServerObject") == true)then
						if(apocalypseGetElementData(source,"WindowOpen") == false)then
							local x,y,z = getElementPosition(clickedElement)
							if(getElementDimension(source) == getElementDimension(clickedElement))then
								if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(source)) <= 7.5)then
									local Model = getElementModel(clickedElement)
									local Level = tonumber(apocalypseGetElementData(source,"level")) or 0
									
									-- // Weaponbox
									if(Model == 944 and apocalypseGetElementData(clickedElement,"Weaponbox") == true)then
										if(Level >= 10)then
											triggerClientEvent(source,"Weaponbox.open",source)
										end
									end
									
									-- // Black Board
									if(Model == 3927 and apocalypseGetElementData(clickedElement,"BlackBoard") == true)then
										local BlackBoardID = apocalypseGetElementData(clickedElement,"ServerObjectID")
										local BlackBoardText = getPlayerData("objects","ID",BlackBoardID,"text")
										local CharacterID_Owner = apocalypseGetElementData(clickedElement,"BlackBoard_CharacterID_Owner")
										local OwnerName = getPlayerData("characters","ID",CharacterID_Owner,"name")
										apocalypseSetElementData(source,"BlackBoard_ActiveID",BlackBoardID)
										local isOwner = false
										
										if(CharacterID_Owner == getCharacterID(source))then isOwner = true end
										
										if(BlackBoardText ~= "" and #BlackBoardText >= 1)then
											triggerClientEvent(source,"BlackBoard.createText",source,BlackBoardText,OwnerName,isOwner)
										else
											if(isOwner == false)then
												NPC.MeMessage(source,getText(source,"SBlackBoard1"))
											else
												triggerClientEvent(source,"BlackBoard.createText",source,BlackBoardText,OwnerName,isOwner)
											end
										end
									end
									
									-- // Safe
									if(Model == 2332 and apocalypseGetElementData(clickedElement,"SafeObject") == true and apocalypseGetElementData(clickedElement,"ExplodableSafe") ~= true)then
										local SafeID = apocalypseGetElementData(clickedElement,"ServerObjectID")
										local SafeMoney = getPlayerData("objects","ID",SafeID,"money")
										local CharacterID_Owner = apocalypseGetElementData(clickedElement,"SafeObject_CharacterID_Owner")
										apocalypseSetElementData(source,"SafeObject_ActiveID",SafeID)
										
										if(CharacterID_Owner == getCharacterID(source))then
											triggerClientEvent(source,"PlayerSafe.openWindow",source,SafeMoney)
										else
										
										end
									end
									
									-- // Storage Crate
									if(Model == 1271 and apocalypseGetElementData(clickedElement,"StorageCrate") == true)then
										local ID = apocalypseGetElementData(clickedElement,"ServerObjectID")
										local Items = StorageCrate.getItemsFromChest(ID)
										local CharacterID_Owner = apocalypseGetElementData(clickedElement,"StorageCrate_CharacterID_Owner")
										if(CharacterID_Owner == getCharacterID(source))then
											local playerItems = {}
											for _,v in pairs(TradeableItems)do
												if(hasPlayerItem(source,v) >= 1)then
													table.insert(playerItems,{v,hasPlayerItem(source,v)})
												end
											end
											triggerClientEvent(source,"StorageCrate.createWindow",source,Items,StorageCrate.getTotalItemAmount(ID),playerItems)
											apocalypseSetElementData(source,"StorageCrate_ActiveID",ID)
										else
										
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end)

addEvent("BuyWeaponboxObject",true)
addEventHandler("BuyWeaponboxObject",root,function()
	local Money = tonumber(apocalypseGetElementData(client,"money"))
	local Brainmass = tonumber(apocalypseGetElementData(client,"brainmass"))
	if(Money >= 15000 and hasPlayerItem(client,1) >= 250)then
		apocalypseSetElementData(client,"money",Money - 15000)
		giveItem(client,123,1)
		takeItem(client,1,250)
		createInfobox(client,getText(client,"SBuyObjects1"))
	else
		createInfobox(client,getText(client,"SBuyObjects2"))
	end
end)

addEvent("BuyBlackBoardObject",true)
addEventHandler("BuyBlackBoardObject",root,function()
	local Money = tonumber(apocalypseGetElementData(client,"money"))
	local Brainmass = tonumber(apocalypseGetElementData(client,"brainmass"))
	if(Money >= 5000 and hasPlayerItem(client,1) >= 100)then
		apocalypseSetElementData(client,"money",Money - 5000)
		giveItem(client,116,1)
		takeItem(client,1,100)
		createInfobox(client,getText(client,"SBuyObjects3"))
	else
		createInfobox(client,getText(client,"SBuyObjects4"))
	end
end)

addEvent("BuySafeObject",true)
addEventHandler("BuySafeObject",root,function()
	local Money = tonumber(apocalypseGetElementData(client,"money"))
	local Brainmass = tonumber(apocalypseGetElementData(client,"brainmass"))
	if(Money >= 10000 and hasPlayerItem(client,1) >= 150)then
		apocalypseSetElementData(client,"money",Money - 10000)
		giveItem(client,120,1)
		takeItem(client,1,150)
		createInfobox(client,getText(client,"SBuyObjects5"))
	else
		createInfobox(client,getText(client,"SBuyObjects6"))
	end
end)

addEvent("BuyWaterDispenser",true)
addEventHandler("BuyWaterDispenser",root,function()
	local Money = tonumber(apocalypseGetElementData(client,"money"))
	local Brainmass = tonumber(apocalypseGetElementData(client,"brainmass"))
	if(Money >= 2500 and hasPlayerItem(client,1) >= 50)then
		apocalypseSetElementData(client,"money",Money - 2500)
		giveItem(client,127,1)
		takeItem(client,1,50)
		createInfobox(client,getText(client,"SBuyObjects7"))
	else
		createInfobox(client,getText(client,"SBuyObjects8"))
	end
end)

addEvent("BuyStorageCrate",true)
addEventHandler("BuyStorageCrate",root,function()
	local Money = tonumber(apocalypseGetElementData(client,"money"))
	local Brainmass = tonumber(apocalypseGetElementData(client,"brainmass"))
	if(Money >= 3500 and hasPlayerItem(client,1) >= 75)then
		apocalypseSetElementData(client,"money",Money - 3500)
		giveItem(client,131,1)
		takeItem(client,1,75)
		createInfobox(client,getText(client,"SBuyObjects9"))
	else
		createInfobox(client,getText(client,"SBuyObjects10"))
	end
end)