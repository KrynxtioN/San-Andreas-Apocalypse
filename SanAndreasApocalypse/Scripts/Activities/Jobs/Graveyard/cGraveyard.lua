Graveyard = {
    flowerObject = {},
    markerByID = {},
    flowerStatus = {}
}

Graveyard.FlowerObjects = {
    {1,871,838.82482910156,-1096.0889892578,23.487099075317,0,0,0,0.3},
    {1,870,839.02429199219,-1096.4432373047,23.446100616455,0,0,334,0.3},
    {1,2895,838.36889648438,-1096.3649902344,23.468599700928,0,0,90},
    {1,2895,837.91442871094,-1096.0727539062,23.468599700928,0,0,90},
    
    {2,870,842.54571533203,-1097.2375488281,23.546100616455,0,0,0,0.3},
    {2,871,843.38360595703,-1096.9731445312,23.587099075317,0,0,0,0.3},
    {2,2895,843.44201660156,-1097.7261962891,23.568599700928,0,0,0},
    {2,2895,844.14202880859,-1097.1430664062,23.568599700928,0,0,258},
	
	{3,871,849.65447998047,-1096.5926513672,23.587099075317,0,0,0,0.30000001192093},
	{3,871,848.90948486328,-1097.0023193359,23.587099075317,0,0,0,0.30000001192093},
	{3,2895,848.28228759766,-1096.3897705078,23.568599700928,0,0,257.99743652344,1},
	{3,2895,847.68511962891,-1096.6223144531,23.568599700928,0,0,257.99743652344,1},
	{3,870,847.99859619141,-1097.4178466797,23.546100616455,0,0,0,0.30000001192093},
	
	{4,877,856.72412109375,-1096.6684570312,23.465400695801,0,0,0,0.10000000149012},
	{4,877,857.61120605469,-1097.3365478516,23.465400695801,0,0,0,0.10000000149012},
	{4,870,858.18212890625,-1096.5120849609,23.538999557495,0,0,308,0.30000001192093},
	{4,871,858.52972412109,-1097.4501953125,23.579900741577,0,0,0,0.30000001192093},
	{4,871,857.41137695312,-1096.5936279297,23.579900741577,0,0,0,0.30000001192093},
	
	{5,877,865.53851318359,-1097.5557861328,23.465400695801,0,0,0,0.10000000149012},
	{5,877,867.28527832031,-1096.6572265625,23.540399551392,0,0,0,0.10000000149012},
	{5,870,866.06872558594,-1096.6232910156,23.538999557495,0,0,308,0.30000001192093},
	{5,871,865.05377197266,-1096.6020507812,23.579900741577,0,0,0,0.30000001192093},
	{5,871,866.52642822266,-1097.4348144531,23.579900741577,0,0,0,0.30000001192093},
	
	{6,877,872.30291748047,-1096.4669189453,23.465400695801,0,0,0,0.10000000149012},
	{6,877,870.60998535156,-1096.6995849609,23.540399551392,0,0,0,0.10000000149012},
	{6,870,871.38562011719,-1097.4368896484,23.538999557495,0,0,308,0.30000001192093},
	{6,871,871.33911132812,-1096.486328125,23.579900741577,0,0,0,0.30000001192093},
	{6,871,869.76489257812,-1096.4010009766,23.579900741577,0,0,0,0.30000001192093},
	
	{7,877,874.38751220703,-1096.2054443359,23.47260093689,0,0,0,0.10000000149012},
	{7,878,875.37469482422,-1096.4222412109,23.49760055542,0,0,338,0.10000000149012},
}

addEventHandler("onClientRender",root,function()
	if(isCharacterLoggedIn() and isWindowOpen())then
		local x1,y1,z1 = 823.64001464844,-1108.4697265625,25.7890625
		local screenX1,screenY1 = getScreenFromWorldPosition(x1,y1,z1)
		
		if(screenX1 and screenY1)then
			if(getDistanceBetweenPoints3D(x1,y1,z1,getElementPosition(localPlayer)) <= 5)then
				dxDrawText(getText("CGraveyard1"), screenX1 - 100, screenY1 - 20, screenX1 + 100, screenY1 + 20, tocolor(255, 255, 255), 1.2, "default-bold", "center", "center")
			end
		end
	end
end)

for i,v in ipairs(Graveyard.FlowerObjects) do
    local obj = createObject(v[2],v[3],v[4],v[5]-1,v[6],v[7],v[8])
    setElementData(obj,"GraveyardFlowerID",v[1])
    if v[9] then setObjectScale(obj,v[9]) end
    Graveyard.flowerObject[i] = obj
end

addEventHandler("onClientElementStreamIn",root,function()
    if getElementType(source) == "marker" then
        local id = getElementData(source,"GraveyardFlowerID")
        if id then Graveyard.markerByID[id] = source end
    end
end)

addEventHandler("onClientElementStreamOut",root,function()
    if getElementType(source) == "marker" then
        local id = getElementData(source,"GraveyardFlowerID")
        if id then Graveyard.markerByID[id] = nil end
    end
end)

addEvent("Graveyard.moveFlower",true)
addEventHandler("Graveyard.moveFlower",root,function(id)
    Graveyard.flowerStatus[id] = 100
    for _,obj in pairs(Graveyard.flowerObject) do
        if getElementData(obj,"GraveyardFlowerID") == id then
            local x,y,z = getElementPosition(obj)
            moveObject(obj,5000,x,y,z+1)
        end
    end
end)

addEvent("Graveyard.moveFlowerDown",true)
addEventHandler("Graveyard.moveFlowerDown",root,function(id)
    Graveyard.flowerStatus[id] = 0
    for _,obj in pairs(Graveyard.flowerObject) do
        if getElementData(obj,"GraveyardFlowerID") == id then
            local x,y,z = getElementPosition(obj)
            moveObject(obj,5000,x,y,z-1)
        end
    end
end)

addEvent("Graveyard.updateFlowerStatus",true)
addEventHandler("Graveyard.updateFlowerStatus",root,function(tbl)
    for k,v in pairs(tbl) do
        Graveyard.flowerStatus[k] = v
    end
end)

addEventHandler("onClientRender",root,function()
    local px,py,pz=getElementPosition(localPlayer)
    for _,obj in pairs(Graveyard.flowerObject) do
        if isElement(obj) then
            local ox,oy,oz = getElementPosition(obj)
            if getDistanceBetweenPoints3D(px,py,pz,ox,oy,oz) <= 5 then
                local sx,sy = getScreenFromWorldPosition(ox,oy,oz+1.2)
                if sx and sy then
                    local id = getElementData(obj,"GraveyardFlowerID")
                    local status = Graveyard.flowerStatus[id] or 0
                    local r,g,b
                    if status >= 70 then r,g,b = 0,200,0
                    elseif status >= 30 then r,g,b = 255,200,0
                    else r,g,b = 200,0,0 end

                    dxDrawText(status.."%",sx,sy,sx,sy,tocolor(r,g,b,220),1,"default-bold","center","center",false,false,false,true)
                end
            end
        end
    end
end)