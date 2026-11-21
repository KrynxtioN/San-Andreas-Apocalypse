PoliceDepartmentPrisonersPed = {}
PoliceDepartmentObjects = {}
PoliceDepartmentKeypad = {}
PoliceDepartmentPickup = {}
PoliceDepartmentDocumentClick = {}
PoliceDepartmentDocument = {}

PoliceDepartmentPrisoners = {
	{189.90740966797,163.62838745117,1002.9888305664,180},
	{194.32197570801,163.62866210938,1002.9888305664,180},
	{198.30363464355,163.58737182617,1003.0299682617,180},
	{197.7615814209,172.88914489746,1003.0234375,0},
	{193.26795959473,172.88912963867,1003.0234375,0},
	{189.11737060547,172.89013671875,1002.9888305664,0},
}

PoliceDepartmentObjectList = {
	{192.07749938965,172.62710571289,1001.4334716797,0,0,0,3095},
	{187.21299743652,173.01100158691,1001.7800292969,0,90,0,3095},
	{192.34469604492,162.3157043457,1001.4334716797,0,0,0,3095},
	{187.22540283203,161.09280395508,1001.7800292969,0,90,0,3095},
	{190.37719726562,171.93350219727,1001.7800292969,0,90,90,3095},
	{191.35079956055,172.40400695801,1001.7800292969,0,90,0,3095},
	{198.10510253906,160.31370544434,1004.666809082,0,0,90,2930},
	{196.31269836426,177.11070251465,1004.6602783203,0,0,90,2930},
	{193.88429260254,177.11070251465,1004.6602783203,0,0,90,2930},
	{192.03340148926,177.11070251465,1004.6602783203,0,0,90,2930},
	{189.63310241699,177.11070251465,1004.6602783203,0,0,90,2930},
	{187.80630493164,177.11070251465,1004.6602783203,0,0,90,2930},
	{198.1142578125,177.1103515625,1004.6602783203,0,0,90,2930},
	{196.28309631348,160.31370544434,1004.666809082,0,0,90,2930},
	{193.89329528809,160.31370544434,1004.666809082,0,0,90,2930},
	{192.08299255371,160.31370544434,1004.666809082,0,0,90,2930},
	{189.62690734863,160.31370544434,1004.666809082,0,0,90,2930},
	{187.82420349121,160.31370544434,1004.666809082,0,0,90,2930},
	{190.89390563965,163.97540283203,1001.7800292969,0,90,90,3095},
	{191.34979248047,164.80250549316,1001.7800292969,0,90,0,3095},
	{191.49960327148,164.80610656738,1001.7800292969,0,90,0,3095},
	{195.69909667969,161.96839904785,1004.6256713867,0,0,0,2930},
	{196.27389526367,161.98629760742,1004.6256713867,0,0,0,2930},
	{196.27119445801,163.66799926758,1004.6256713867,0,0,0,2930},
	{196.26370239258,163.97079467773,1004.6256713867,0,0,0,2930},
	{195.69779968262,163.658203125,1004.6256713867,0,0,0,2930},
	{195.70799255371,165.16149902344,1004.6256713867,0,0,0,2930},
}

function createPoliceDepartmentObjects(int,dim)
	PoliceDepartmentObjects[dim] = {}
	for i,v in pairs(PoliceDepartmentObjectList)do
		local object = createObject(v[7],v[1],v[2],v[3],v[4],v[5],v[6])
		apocalypseSetElementData(object,"PoliceDepartmentObjectID",i)
		setElementDimension(object,dim)
		setElementInterior(object,int)
		table.insert(PoliceDepartmentObjects[dim],object)
	end
end

function destroyPoliceDepartmentObjects(dim)
	for _,v in pairs(PoliceDepartmentObjects[dim])do
		destroyElement(v)
	end
	PoliceDepartmentObjects[dim] = {}
end

addEventHandler("onPlayerClick", root, function(button, state, clickedElement)
	if(isCharacterLoggedIn(source))then
		if(button == "left" and state == "down" and clickedElement)then
			if(clickedElement and isElement(clickedElement))then
				if(apocalypseGetElementData(clickedElement,"PoliceDepartmentKeypad"))then
					local x, y, z = getElementPosition(source)
					if(getDistanceBetweenPoints3D(x, y, z, getElementPosition(clickedElement)) <= 5)then
						if(apocalypseGetElementData(source,"PoliceDepartmentKeypadKey"))then
							local ID = tonumber(apocalypseGetElementData(source,"PoliceDepartmentKeypadKey"))
							if(ID == getElementDimension(clickedElement))then
								apocalypseSetElementData(source,"PoliceDepartmentKeypadKey",nil)
								if(not(apocalypseGetElementData(clickedElement,"GatesMoved")))then
									local dim = getElementDimension(clickedElement)
									for i,v in pairs(PoliceDepartmentObjects[dim]) do
										if(i >= 7 and i <= 18)then
											local ox,oy,oz = getElementPosition(v)
											moveObject(v,5000,ox,oy,oz-5)
										end
									end
									NPC.MeMessage(source,getText(source,"MeMessage30"))
									apocalypseSetElementData(clickedElement,"GatesMoved",true)
								end
							end
						else
							NPC.MeMessage(source,getText(source,"MeMessage31"))
						end
					end
				end
			end
		end
	end
end)