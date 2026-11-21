local pos = {
	{669.35748291016,-473.47674560547,16.3359375},
}

addEventHandler("onClientRender",root,function()
	if(isCharacterLoggedIn() and isWindowOpen())then
		for _,v in pairs(pos)do
			local x1,y1,z1 = v[1],v[2],v[3]
			local screenX1,screenY1 = getScreenFromWorldPosition(x1,y1,z1)
			
			if(screenX1 and screenY1)then
				if(getDistanceBetweenPoints3D(x1,y1,z1,getElementPosition(localPlayer)) <= 5)then
					dxDrawText(getText("CNewbieBMX1"), screenX1 - 100, screenY1 - 20, screenX1 + 100, screenY1 + 20, tocolor(255, 255, 255), 1.2, "default-bold", "center", "center")
				end
			end
		end
	end
end)