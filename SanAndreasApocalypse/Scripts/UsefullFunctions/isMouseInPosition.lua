local screenWidth, screenHeight = guiGetScreenSize()

function isMouseInPosition(x, y, width, height)
	if(x and y and width and height)then
		if(isCursorShowing())then
			local mouseX, mouseY = getCursorPosition()
			mouseX, mouseY = mouseX * screenWidth, mouseY * screenHeight
			return mouseX >= x and mouseX <= x + width and mouseY >= y and mouseY <= y + height
		end
		return false
	end
end