function dxDrawCircle3D(x, y, z, radius, segments, color, width)
	local segments = segments or 16
	local color = color or tocolor(255, 255, 0)
	width = width or 1
	local segAngle = 360/segments
	local fX, fY, tX, tY
	for i = 1, segments do
		fX = x + math.cos(math.rad(segAngle * i)) * radius
		fY = y + math.sin(math.rad(segAngle * i)) * radius
		tX = x + math.cos(math.rad(segAngle * (i + 1))) * radius
		tY = y + math.sin(math.rad(segAngle * (i + 1))) * radius
		dxDrawLine3D(fX, fY, z, tX, tY, z, color, width)
	end
end