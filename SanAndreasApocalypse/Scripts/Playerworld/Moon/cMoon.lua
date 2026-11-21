Moon = {}
local triggerType

AstronautTXD = engineLoadTXD("Files/Skins/astronaut.txd")
engineImportTXD(AstronautTXD,10)
AstronautDFF = engineLoadDFF("Files/Skins/astronaut.dff")
engineReplaceModel(AstronautDFF,10)

SpitzhackeTXD = engineLoadTXD("Files/Mods/pickaxe.txd")
engineImportTXD(SpitzhackeTXD,336)
SpitzhackeDFF = engineLoadDFF("Files/Mods/pickaxe.dff")
engineReplaceModel(SpitzhackeDFF,336)

function Moon.loadShader()
	Moon.MyShader = dxCreateShader("Files/Shader/Shader.fx")
	Moon.MyTexture = dxCreateTexture("Files/Images/Moon.png")
	dxSetShaderValue(Moon.MyShader,"Tex0",Moon.MyTexture)
end
Moon.loadShader()

addEvent("Moon.openWindow",true)
addEventHandler("Moon.openWindow",root,function(type)
	if(isWindowOpen())then
        GUIEditor.window[1] = guiCreateWindow(500, 262, 339, 134, getText("CMoon1"), false)
		setWindowData()
		guiCreateCloseButton()

        GUIEditor.label[1] = guiCreateLabel(10, 28, 320, 58, getText("CMoon2"), false, GUIEditor.window[1])
        GUIEditor.button[1] = guiCreateButton(10, 96, 320, 28, getText("CMoon3"), false, GUIEditor.window[1])
		triggerType = "up"
		
		if(type == 2)then
			guiSetText(GUIEditor.label[1],getText("CMoon4"))
			guiSetText(GUIEditor.button[1],getText("CMoon5"))
			triggerType = "down"
		end
		
		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
			triggerServerEvent("Moon.startRocket",localPlayer,triggerType)
		end,false)
	end
end)

function Moon.addTextures(objects)
	if(Moon.MyShader)then
		if(#objects >= 1)then
			for _,v in pairs(objects)do
				if(getElementModel(v[1]) == 16118)then
					engineApplyShaderToWorldTexture(Moon.MyShader,"des_redrock1",v[1])
					engineApplyShaderToWorldTexture(Moon.MyShader,"des_redrock2",v[1])
				elseif(getElementModel(v[1]) == 6959)then
					engineApplyShaderToWorldTexture(Moon.MyShader,"greyground256128",v[1])
				end
			end
		end
	else
		setTimer(function(objects)
			Moon.addTextures(objects)
		end,1000,1,objects)
	end
end
addEvent("Moon.addTextures",true)
addEventHandler("Moon.addTextures",root,Moon.addTextures)

function Moon.raketenStart(type)
	if(isElement(Moon.smokeEffect))then destroyElement(Moon.smokeEffect)end
	if(isTimer(Moon.smokeEffectTimer))then killTimer(Moon.smokeEffectTimer)end
	if(type)then
		local x,y,z = getElementPosition(localPlayer)
		Moon.smokeEffect = createEffect("riot_smoke",x,y,z)
		attachEffect(Moon.smokeEffect,localPlayer,Vector3(0,4,4))
		
		Moon.smokeEffectTimer = setTimer(function()
			Moon.raketenStart("create")
		end,10000,1)
	end
end
addEvent("Moon.raketenStart",true)
addEventHandler("Moon.raketenStart",root,Moon.raketenStart)

addEvent("Moon.activateFeeling",true)
addEventHandler("Moon.activateFeeling",root,function(type)
	if(type == "create")then
		setSkyGradient(0,0,0)
	else
		resetSkyGradient()
	end
end)

addEvent("Moon.sound",true)
addEventHandler("Moon.sound",root,function(type)
	if(isTimer(Moon.soundTimer))then killTimer(Moon.soundTimer)end
	if(type)then
		Moon.soundTimer = setTimer(function()
			playSound("Files/Sounds/Pickaxe.wav")
		end,1000,15)
	end
end)

addEvent("Moon.createBlip",true)
addEventHandler("Moon.createBlip",root,function(type,x,y,z)
	if(isElement(Moon.blip))then destroyElement(Moon.blip)end
	if(type)then
		Moon.blip = createBlip(x,y,z,0,2,255,0,0)
	end
end)