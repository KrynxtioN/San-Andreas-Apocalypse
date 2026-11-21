function Documents.createHelpMarker(ID,x,y,z,int,dim)
	local ID = tonumber(ID)
	if(not ID) then return end

	if(not(isElement(Documents.Helpmarker[ID])))then
		Documents.Helpmarker[ID] = createMarker(x,y,z,"corona",1,0,255,0,50)
		setElementInterior(Documents.Helpmarker[ID],int)
		setElementDimension(Documents.Helpmarker[ID],dim)
	end
end
addEvent("Documents.createHelpMarker",true)
addEventHandler("Documents.createHelpMarker",root,Documents.createHelpMarker)

function Documents.destroyHelpMarker(ID)
	local ID = tonumber(ID)
	if(not ID) then return end

	if(isElement(Documents.Helpmarker[ID]))then
		destroyElement(Documents.Helpmarker[ID])
		Documents.Helpmarker[ID] = nil
	end
end
addEvent("Documents.destroyHelpMarker",true)
addEventHandler("Documents.destroyHelpMarker",root,Documents.destroyHelpMarker)