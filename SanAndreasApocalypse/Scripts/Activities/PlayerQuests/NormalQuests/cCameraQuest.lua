CameraQuest = {CameraObject = {}, CameraObjectClick = {}, CameraMarker = {},
	["CameraObjects"] = {
		[2] = {
			{367,1709.5593261719,-1644.0661621094,19.218799591064,0,0,0,18,0},
			{1549,1709.7176513672,-1643.9858398438,18.568799972534,0,0,0,18,0},
		},
		[3] = {
			{367,1713.3299560547,-1640.1900634766,19.223899841309,0,0,284,18,0},
			{1549,1713.4755859375,-1640.3150634766,18.598899841309,0,0,0,18,0},
		},
		[4] = {
			{367,1711.6225585938,-1672.4993896484,20.236400604248,0,0,156,18,0},
			{1549,1711.4645996094,-1672.5380859375,19.586399078369,0,0,0,18,0},
		},
		[5] = {
			{367,1722.9827880859,-1641.869140625,26.206300735474,0,0,22,18,0},
			{1549,1723.0782470703,-1641.7200927734,25.582399368286,0,0,0,18,0},
		},
		[6] = {
			{367,-2518.4311523438,-669.15087890625,147.12359619141,0,0,154,0,0},
			{1549,-2518.6186523438,-669.18817138672,146.44859313965,0,0,0,0,0},
		},
		[7] = {
			{367,-2494.0905761719,-702.978515625,139.09539794922,0,0,154,0,0},
			{1549,-2494.2788085938,-703.03198242188,138.39540100098,0,0,0,0,0},
		},
	},
}

addEvent("CameraQuest.createCamera",true)
addEventHandler("CameraQuest.createCamera",root,function(ID)
	local ID = tonumber(ID)
	
	if(isElement(CameraQuest.CameraObject[ID]))then
		destroyElement(CameraQuest.CameraObject[ID])
		destroyElement(CameraQuest.CameraObjectClick[ID])
		destroyElement(CameraQuest.CameraMarker[ID])
	end
	
	local tbl = CameraQuest["CameraObjects"][ID]
	CameraQuest.CameraObject[ID] = createObject(tbl[1][1],tbl[1][2],tbl[1][3],tbl[1][4],tbl[1][5],tbl[1][6],tbl[1][7])
	setObjectBreakable(CameraQuest.CameraObject[ID],false)
	CameraQuest.CameraObjectClick[ID] = createObject(tbl[2][1],tbl[2][2],tbl[2][3],tbl[2][4],tbl[2][5],tbl[2][6],tbl[2][7])
	setObjectBreakable(CameraQuest.CameraObjectClick[ID],false)
	setElementInterior(CameraQuest.CameraObject[ID],tbl[1][8])
	setElementDimension(CameraQuest.CameraObject[ID],tbl[1][9])
	setElementInterior(CameraQuest.CameraObjectClick[ID],tbl[1][8])
	setElementDimension(CameraQuest.CameraObjectClick[ID],tbl[1][9])
	setElementAlpha(CameraQuest.CameraObjectClick[ID],0)
	CameraQuest.CameraMarker[ID] = createMarker(tbl[1][2],tbl[1][3],tbl[1][4],"corona",0.5,255,255,255,75)
	setElementInterior(CameraQuest.CameraMarker[ID],tbl[1][8])
	setElementDimension(CameraQuest.CameraMarker[ID],tbl[1][9])
	apocalypseSetElementData(CameraQuest.CameraObjectClick[ID],"CameraID",ID)
end)

addEventHandler("onClientClick", root, function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if(button == "left" and state == "down")then
		if(clickedElement and getElementType(clickedElement) == "object")then
			local CameraID = apocalypseGetElementData(clickedElement,"CameraID")
			if(CameraID)then
				local x,y,z = getElementPosition(clickedElement)
				if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(localPlayer)) <= 5)then
					destroyElement(CameraQuest.CameraMarker[CameraID])
					destroyElement(CameraQuest.CameraObject[CameraID])
					destroyElement(CameraQuest.CameraObjectClick[CameraID])
					triggerServerEvent("givePlayerCamera",localPlayer,localPlayer,CameraID)
				end
			end
		end
	end
end)