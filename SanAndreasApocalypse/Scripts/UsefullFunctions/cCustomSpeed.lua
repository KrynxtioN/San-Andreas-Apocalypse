local PLAYER_SPEED = 0
local SPEED_ACCEL = true 
local IS_AIR_SPEED = false
local DEFAULT_MAX_SPEED = 0.2

local function onClientPreRender(timeSlice)
	local posX,posY,posZ = getElementPosition(localPlayer)
	local velX,velY,velZ = getElementVelocity(localPlayer)
	local velLength = (velX^2 + velY^2 + velZ^2)^0.5
	if velLength > 0 then 
		if isPedOnGround(localPlayer) == false and IS_AIR_SPEED == false then
			return
		end
		
		local dt = timeSlice / 1000
		local speedAccel = SPEED_ACCEL and math.min(velLength / DEFAULT_MAX_SPEED,1) or 1
		
		local normX = velX / velLength
		local normY = velY / velLength
		local normZ = velZ / velLength
		
		local addVelX = normX * PLAYER_SPEED
		local addVelY = normY * PLAYER_SPEED
		local addVelZ = normZ * PLAYER_SPEED
		
		local addPosX = posX + addVelX * speedAccel * dt
		local addPosY = posY + addVelY * speedAccel * dt
		local addPosZ = posZ + addVelZ * speedAccel * dt
		
		setElementPosition(localPlayer,addPosX,addPosY,addPosZ,false)
	end
end

addEvent('onClientSetSpeed',true)
addEventHandler('onClientSetSpeed',localPlayer,
	function(speed)
		if speed > 0 then
			if PLAYER_SPEED == 0 then
				addEventHandler('onClientPreRender',root,onClientPreRender)
			end
		else
			if PLAYER_SPEED > 0 then 
				removeEventHandler('onClientPreRender',root,onClientPreRender)
			end
		end
		PLAYER_SPEED = speed
end)