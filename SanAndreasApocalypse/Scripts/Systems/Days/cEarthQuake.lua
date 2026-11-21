local x, y = guiGetScreenSize()
local Strength, Phase = 0, 0
local earthQuakeTime = 0

local screenSource = dxCreateScreenSource(x, y)
local earthQuakeShader = dxCreateShader("Files/Shader/EarthQuake.fx")
local earthQuakeRenderTarget = dxCreateRenderTarget(x, y, true)

local function getShakeValue()
	Phase = Phase + 65 * math.pi / 256
	if Phase >= 65 * math.pi then
		Phase = Phase - 65 * math.pi
	end

	return (math.sin(0.5 * Phase) - 0.5) / math.random(40, 70)
end

function renderEarthQuake()
	dxUpdateScreenSource(screenSource)

	local dynamicStrength = Strength * (0.5 + 0.5 * math.sin(getTickCount() / 150))

	dxSetShaderValue(earthQuakeShader, "screenSource", screenSource)
	dxSetShaderValue(earthQuakeShader, "Strength", dynamicStrength)

	dxSetRenderTarget(earthQuakeRenderTarget, true)
	dxDrawImage(0, 0, x, y, earthQuakeShader)
	dxSetRenderTarget()

	dxDrawImage(0, 0, x, y, earthQuakeRenderTarget)

	Strength = getShakeValue()
end

addEvent("earthQuakeStart",true)
addEventHandler("earthQuakeStart",root,function()
	Strength = math.random(10, 20)
	addEventHandler("onClientHUDRender", root, renderEarthQuake)
	NPC.MeMessage(getText("CEarthQuake1"))

	setTimer(function()
		removeEventHandler("onClientHUDRender", root, renderEarthQuake)
		Strength = 0
	end, 15000, 1)
end)