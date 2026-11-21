SprintLevelVisible = true
SanAndreasApocalypseVersion = "v.1.1.0"

function getFreeDimension()
	local freeDim = nil
	for dim = 1, 60000 do
		if isDimFree("player", dim) == true then
			freeDim = dim
			break
		end
	end
	return freeDim
end

function isDimFree(Type,dim)
	local state = true
	for key, value in ipairs(getElementsByType(Type)) do
		if getElementDimension(value) == dim then
			state = false
			break
		end
	end
	return state
end