Objectsystem = {}

local function ObjectsystemControls()
    dxDrawText(
        getText("CObjectsystem1"),
        10, 10, 500, 200,
        tocolor(255, 255, 255, 255),
        1.5,
        "default-bold",
        "left", "top",
        false, false, true
    )
end

local activeObjectLabels = {}

addEvent("ObjectLabel.show", true)
addEventHandler("ObjectLabel.show", root, function(x,y,z, ownerName, id)
	activeObjectLabels[id] = {x,y,z,ownerName}
end)

addEvent("ObjectLabel.hide", true)
addEventHandler("ObjectLabel.hide", root, function(id)
	activeObjectLabels[id] = nil
end)

addEventHandler("onClientRender", root, function()
	for _,v in pairs(activeObjectLabels) do
		local x, y, z = v[1],v[2],v[3]
		local sx, sy = getScreenFromWorldPosition(x, y, z + 1.2)

		if sx and sy then
			if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(localPlayer)) <= 10)then
				dxDrawText(
					getText("CObjectsystem2"):format(v[4]),
					sx, sy, sx, sy,
					tocolor(255,255,255,255),
					1.2,
					"default-bold",
					"center",
					"center"
				)
			end
		end
	end
end)

function Objectsystem.createObject(model)
	if(apocalypseGetElementData(localPlayer,"inSafezone") ~= true)then
		Objectsystem.cord = 0.1
		if(isElement(Objectsystem.playerObject))then
			setElementModel(Objectsystem.playerObject,model)
		else
			local x,y,z = getElementPosition(localPlayer)
			Objectsystem.playerObject = createObject(model,x,y,z)
			setElementDoubleSided(Objectsystem.playerObject,true)
			setElementInterior(Objectsystem.playerObject,getElementInterior(localPlayer))
			setElementDimension(Objectsystem.playerObject,getElementDimension(localPlayer))
			setElementCollisionsEnabled(Objectsystem.playerObject,false)
			setElementDoubleSided(Objectsystem.playerObject,true)
			setElementAlpha(Objectsystem.playerObject,175)
			
			bindKey("backspace","down",Objectsystem.close)
			addEventHandler("onClientKey",root,Objectsystem.moveObject)
			bindKey("lshift","down",Objectsystem.shift)
			bindKey("enter","down",Objectsystem.place)
			toggleAllControls(false)
			addEventHandler("onClientRender",root,ObjectsystemControls)
		end
	else
		createInfobox(getText("CObjects1"))
	end
end
addEvent("Objectsystem.createObject",true)
addEventHandler("Objectsystem.createObject",root,Objectsystem.createObject)

function Objectsystem.moveObject(button,press)
	if(press and button)then
		local x,y,z = getElementPosition(Objectsystem.playerObject)
		local rx,ry,rz = getElementRotation(Objectsystem.playerObject)
		if(button == "pgup")then
			setElementPosition(Objectsystem.playerObject,x,y,z+Objectsystem.cord)
		elseif(button == "pgdn")then
			setElementPosition(Objectsystem.playerObject,x,y,z-Objectsystem.cord)
		elseif(button == "mouse_wheel_up")then
			setElementRotation(Objectsystem.playerObject,rx,ry,rz+1)
		elseif(button == "mouse_wheel_down")then
			setElementRotation(Objectsystem.playerObject,rx,ry,rz-1)
		elseif(button == "arrow_u")then
			setElementPosition(Objectsystem.playerObject,x,y+Objectsystem.cord,z)
		elseif(button == "arrow_d")then
			setElementPosition(Objectsystem.playerObject,x,y-Objectsystem.cord,z)
		elseif(button == "arrow_l")then
			setElementPosition(Objectsystem.playerObject,x-Objectsystem.cord,y,z)
		elseif(button == "arrow_r")then
			setElementPosition(Objectsystem.playerObject,x+Objectsystem.cord,y,z)
		end
	end
end

function Objectsystem.shift()
	if(Objectsystem.cord == 0.1)then
		Objectsystem.cord = 0.01
	else 
		Objectsystem.cord = 0.1
	end
end

function Objectsystem.close()
	if(isElement(Objectsystem.playerObject))then destroyElement(Objectsystem.playerObject)end
	toggleAllControls(true)
	unbindKey("backspace","down",Objectsystem.close)
	removeEventHandler("onClientKey",root,Objectsystem.moveObject)
	unbindKey("lshift","down",Objectsystem.shift)
	unbindKey("enter","down",Objectsystem.place)
	closeWindow()
	removeEventHandler("onClientRender",root,ObjectsystemControls)
	apocalypseSetElementData(localPlayer,"furniture_shop",false)
end

function Objectsystem.place()
	local x,y,z = getElementPosition(Objectsystem.playerObject)
	local rx,ry,rz = getElementRotation(Objectsystem.playerObject)
	triggerServerEvent("Objectsystem.place",localPlayer,getElementModel(Objectsystem.playerObject),x,y,z,rx,ry,rz)
	Objectsystem.close()
end

addEventHandler("onClientPlayerWasted",root,function()
	if(source == localPlayer)then
		Objectsystem.close()
	end
end)