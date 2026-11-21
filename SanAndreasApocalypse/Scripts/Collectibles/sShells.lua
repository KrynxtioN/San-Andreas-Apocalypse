Shells = {Object = {}, Marker = {},
	["Coordinates"] = {
		{2126.7805175781,-90.539596557617,1.2504999637604,0,0,0,953},
		{2126.9147949219,202.27319335938,0.33480000495911,0,0,0,953},
		{-78.260299682617,-561.65832519531,2.6156001091003,0,0,86,953},
		{1378.24609375,-281.7685546875,0.3163999915123,0,0,98,953},
		{-324.9189453125,-389.0986328125,0.58079999685287,0,0,86,953},
		{-116.92430114746,-808.45288085938,0.83429998159409,0,0,86,953},
		{363.51910400391,-281.89819335938,0.53490000963211,0,0,86,953},
		{-262.6474609375,-773.5029296875,1.2107000350952,0,0,86,953},
	}
}

function Shells.create(ID)
	local v = Shells["Coordinates"][ID]
	Shells.Object[ID] = createObject(v[7],v[1],v[2],v[3],v[4],v[5],v[6])
	Shells.Marker[ID] = createMarker(v[1],v[2],v[3],"cylinder",1,0,0,0,0)
	apocalypseSetElementData(Shells.Marker[ID],"ShellID",ID)
	
	addEventHandler("onMarkerHit",Shells.Marker[ID],function(player)
		if(getElementType(player) == "player")then
			if(not(isPedInVehicle(player)))then
				if(getElementDimension(player) == getElementDimension(source))then
					local ShellID = apocalypseGetElementData(source,"ShellID")
					destroyElement(source)
					destroyElement(Shells.Object[ID])
					setTimer(function(ShellID)
						Shells.create(ShellID)
					end,1800000,1,ShellID)
					giveItem(player,67,1)
					outputLog(getPlayerName(player).." hat eine Muschel eingesammelt", "Muscheln", getCharacterID(player))
				end
			end
		end
	end)
end

for i,v in ipairs(Shells["Coordinates"])do
	Shells.create(i)
end