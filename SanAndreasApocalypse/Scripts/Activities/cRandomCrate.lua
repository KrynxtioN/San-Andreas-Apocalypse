local function trigger_Airdrop_Event() triggerServerEvent("onCancelLootSearch",localPlayer) end

addEvent("Airdrop.bindKey",true)
addEventHandler("Airdrop.bindKey",root,function()
	bindKey("e","down",trigger_Airdrop_Event)
end)

addEvent("Airdrop.unbindKey",true)
addEventHandler("Airdrop.unbindKey",root,function()
	unbindKey("e","down",trigger_Airdrop_Event)
end)