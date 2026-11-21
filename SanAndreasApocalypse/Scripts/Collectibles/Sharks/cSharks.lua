apocalypseSetElementData(localPlayer,"SharkBind",nil)

Sharks = {RenderStatus = false}

addEvent("Sharks.clientRender",true)
addEventHandler("Sharks.clientRender",root,function(Data)
	Sharks.Data = Data
	if(Sharks.RenderStatus == false)then
		Sharks.RenderStatus = true
		addEventHandler("onClientRender",root,Sharks.render)
	end
end)

function Sharks.render()
	if (Sharks.Data) then
		if (getElementDimension(localPlayer) == 0 and getElementInterior(localPlayer) == 0) then
			for _, v in pairs(Sharks.Data) do
				local posx, posy, posz = v[1], v[2], v[3]
				local sx, sy = getScreenFromWorldPosition(posx, posy, posz + 0.5)

				if (sx and sy) then
					local px, py, pz = getElementPosition(localPlayer)
					local distance = getDistanceBetweenPoints3D(px, py, pz, posx, posy, posz)
					if (distance <= 5) then
						dxDrawText(v[4], sx - 100, sy - 20, sx + 100, sy + 20, tocolor(255, 255, 255), 1.2, "default-bold", "center", "center")
					end
				end
			end
		end
	end
end