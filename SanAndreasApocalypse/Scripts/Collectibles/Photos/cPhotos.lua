local imageWidth = 500
local imageHeight = 500
local imageTexture = nil

function Photos.dxDraw()
    local screenWidth, screenHeight = guiGetScreenSize()
    local imageX = (screenWidth - imageWidth) / 2
    local imageY = (screenHeight - imageHeight) / 2

    dxDrawImage(imageX, imageY, imageWidth, imageHeight, imageTexture, 0, 0, 0, tocolor(255, 255, 255, 255))
end

function Photos.showPhoto(ID)
	local ID = tonumber(ID)
	imageTexture = "Files/Images/Photos/Photo_"..ID..".png"
	removeEventHandler("onClientRender",root,Photos.dxDraw)
	addEventHandler("onClientRender",root,Photos.dxDraw)
	playSound("Files/Sounds/Photo.mp3")
	if(isTimer(Photos.Timer))then killTimer(Photos.Timer)end
	
	Photos.Timer = setTimer(function()
		removeEventHandler("onClientRender",root,Photos.dxDraw)
	end,7500,1)
end
addEvent("Photos.showPhoto",true)
addEventHandler("Photos.showPhoto",root,Photos.showPhoto)