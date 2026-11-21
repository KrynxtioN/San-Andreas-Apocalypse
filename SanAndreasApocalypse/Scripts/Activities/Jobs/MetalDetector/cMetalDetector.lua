MetalDetector = {questWoodObjects = {}, bind = false,
    ActiveX = nil,
    ActiveY = nil,
    ActiveZ = nil,
}

local QuestWood = {
	{3260,2325.5837402344,-3.7720999717712,27.850299835205,0,0,90},
	{3260,2325.583984375,-3.772500038147,24.850299835205,0,0,90},
}

local searchAllowed = false
local screenWidth, screenHeight = guiGetScreenSize()

function MetalDetector.Start()
    addEventHandler("onClientRender", root, MetalDetector.dxDraw)
    bindKey("e", "down", MetalDetector.Search)
    MetalDetector.Spawn()
end
addEvent("MetalDetector.Start", true)
addEventHandler("MetalDetector.Start", root, MetalDetector.Start)

addEvent("MetalDetector.Stop",true)
addEventHandler("MetalDetector.Stop",root,function()
	removeEventHandler("onClientRender",root,MetalDetector.dxDraw)
	unbindKey("e","down",MetalDetector.Search)
end)

function MetalDetector.Spawn()
    local px, py, pz = getElementPosition(localPlayer)
    local nearbyPositions = {}
    for _, pos in pairs(PossibleMetalDetectorLocations) do
        local x, y = pos[1], pos[2]
        local dist = getDistanceBetweenPoints2D(px, py, x, y)
        if dist <= 500 then
            table.insert(nearbyPositions, pos)
        end
    end

    local finalList = #nearbyPositions > 0 and nearbyPositions or PossibleMetalDetectorLocations
    local chosen = finalList[math.random(#finalList)]

    MetalDetector.ActiveX = chosen[1]
    MetalDetector.ActiveY = chosen[2]
    MetalDetector.ActiveZ = chosen[3]
end
addEvent("MetalDetector.Spawn",true)
addEventHandler("MetalDetector.Spawn",root,MetalDetector.Spawn)

function MetalDetector.dxDraw()
	if(not(isPedDead(localPlayer)))then
		local x, y, z = MetalDetector.ActiveX, MetalDetector.ActiveY, MetalDetector.ActiveZ
		if x and y and z then
			local px, py, pz = getElementPosition(localPlayer)
			local dist = getDistanceBetweenPoints2D(px, py, x, y)

			local headX, headY, headZ = getPedBonePosition(localPlayer, 6)
			local sx, sy = getScreenFromWorldPosition(headX, headY, headZ + 0.3)

			if sx and sy then
				if dist <= 15 and isPedOnGround(localPlayer) then
					searchAllowed = true
					dxDrawText(getText("CMetalDetector1"), sx, sy, sx, sy, tocolor(255, 255, 255), 1, "default-bold", "center", "bottom")
				else
					searchAllowed = false
					dxDrawText(getText("CMetalDetector2"):format(math.floor(dist)), sx, sy, sx, sy, tocolor(255, 100, 100), 1, "default-bold", "center", "bottom")
				end
			end
		end
	end
end

function MetalDetector.Search()
    if searchAllowed then
        triggerServerEvent("MetalDetector.Search", localPlayer)
        searchAllowed = false
    end
end

addEvent("MetalDetector.createPickup",true)
addEventHandler("MetalDetector.createPickup",root,function()
	local Pickup = createPickup(2291.923828125,43.38285446167,8.2038631439209,3,1210,50)
	addEventHandler("onClientPickupHit",Pickup,function(player)
		if(player == localPlayer)then
			destroyElement(source)
			triggerServerEvent("MetalDetector.Collect",localPlayer)
		end
	end)
end)

function MetalDetector.createClientWood()
	for i,v in pairs(QuestWood)do
		MetalDetector.questWoodObjects[i] = createObject(v[1],v[2],v[3],v[4],v[5],v[6],v[7])
		setObjectBreakable(MetalDetector.questWoodObjects[i],false)
	end
	
	MetalDetector.removeWoodPickup = createPickup(2325.9985351562,-2.3682477474213,26.548133850098,3,1239,50)
		
	addEventHandler("onClientPickupHit",MetalDetector.removeWoodPickup,function(player)
		if(player == localPlayer)then
			if(getElementDimension(localPlayer) == getElementDimension(source))then
				createInfobox(getText("CMetalDetector3"))
				if(MetalDetector.bind == false)then
					MetalDetector.bind = true
					bindKey("e","down",MetalDetector.bindKeyWood)
				end
			end
		end
	end)
end
addEvent("MetalDetector.createClientWood",true)
addEventHandler("MetalDetector.createClientWood",root,MetalDetector.createClientWood)

function MetalDetector.bindKeyWood()
	MetalDetector.bind = false
	unbindKey("e","down",MetalDetector.bindKeyWood)
	if(getDistanceBetweenPoints3D(2325.9985351562,-2.3682477474213,26.548133850098,getElementPosition(localPlayer)) <= 5)then
		triggerServerEvent("MetalDetector.destroyWood",localPlayer)
	end
end

function MetalDetector.destroyClientWood()
	destroyElement(MetalDetector.removeWoodPickup)
	for _,v in pairs(MetalDetector.questWoodObjects)do
		if(isElement(v))then
			destroyElement(v)
		end
	end
	MetalDetector.questWoodObjects = {}
end
addEvent("MetalDetector.destroyClientWood",true)
addEventHandler("MetalDetector.destroyClientWood",root,MetalDetector.destroyClientWood)