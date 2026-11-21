PlayerHeads = {}

addEvent("updateClientHeads",true)
addEventHandler("updateClientHeads", root, function(heads)
	PlayerHeads = heads
	UpdatePlayerHeadsForInventory()
end)