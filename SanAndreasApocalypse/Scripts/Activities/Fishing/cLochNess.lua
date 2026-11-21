LochNess = {}

local TXD = engineLoadTXD("Files/Mods/loch_ness.txd")
local DFF = engineLoadDFF("Files/Mods/loch_ness.dff")
engineImportTXD(TXD,1)
engineReplaceModel(DFF,1)

addEvent("LochNess.playSound",true)
addEventHandler("LochNess.playSound",root,function(ID)
	local ID = tonumber(ID)
	if(ID == 1)then
		LochNess.Sound = playSound3D("loch_ness.mp3",2067.1162109375, -172.23582458496, -0.55000001192093)
		setSoundMaxDistance(LochNess.Sound,100)
	end
end)