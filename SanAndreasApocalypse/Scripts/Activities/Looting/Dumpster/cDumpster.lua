addEvent("Dumpster.createPlayerMarker",true)
addEventHandler("Dumpster.createPlayerMarker",root,function(Coordinates)
	for i,v in ipairs(Coordinates)do
		if(not(isElement(Dumpster.marker[i])))then
			Dumpster.marker[i] = createMarker(v[1],v[2],v[3],"corona",1,255,255,255,100)
		end
	end
end)

addEvent("Dumpster.updateMarkerColor",true)
addEventHandler("Dumpster.updateMarkerColor",root,function(ID,r,g,b)
	local ID = tonumber(ID)
	if(isElement(Dumpster.marker[ID]))then
		setMarkerColor(Dumpster.marker[ID],r,g,b,100)
	end
end)