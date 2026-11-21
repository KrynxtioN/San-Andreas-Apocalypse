local function loadTexture()
    local Shader = dxCreateShader("Files/Shader/Shader.fx")
    
    local Texture1 = dxCreateTexture("Files/Images/Textures/veding1_64.png")
    local Texture2 = dxCreateTexture("Files/Images/Textures/veding2_64.png")

    dxSetShaderValue(Shader, "Tex0", Texture1)  
    dxSetShaderValue(Shader, "Tex1", Texture2)

    engineApplyShaderToWorldTexture(Shader, "veding1_64")
    engineApplyShaderToWorldTexture(Shader, "veding2_64")
end
loadTexture()

addEventHandler("onClientRender",root,function()
	for _,v in pairs(VendingMachine["Coordinates"])do
		local x, y, z = v[2],v[3],v[4]
		local screenX, screenY = getScreenFromWorldPosition(x, y, z + 1)
			
		if(screenX and screenY)then
			if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(localPlayer)) <= 5)then
				dxDrawText(getText("CVendingMachine1"), screenX - 1, screenY - 1, screenX + 1, screenY + 1, tocolor(0, 0, 0, 255), 1, "default-bold", "center", "center")
				dxDrawText(getText("CVendingMachine1"), screenX, screenY, screenX, screenY, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center")
			end
		end
	end
end)