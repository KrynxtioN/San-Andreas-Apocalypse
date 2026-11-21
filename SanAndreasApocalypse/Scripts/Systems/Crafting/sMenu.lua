local NeededItems = {
	[20] = {
		{19,6},
		{92,3},
	},
	[26] = {
		{57,9},
	},
	[31] = {
		{148,1},
		{149,2},
	},
    [35] = {
        {3, 6},  
        {34, 3},
    },
	[40] = {
		{3, 1},
		{39, 3},
		{32, 3},
	},
	[58] = {
		{159,3},
		{156,2},
		{158,1},
		{157,3},
	},
	[106] = {
		{64,3},
		{65,3},
		{66,3},
	},
	[146] = {
		{129,7},
	},
	[147] = {
		{130,7},
	},
	[186] = {
		{157,3},
		{158,2},
		{159,1},
		{162,3},
	},
	[185] = {
		{28,9},
	},
	[163] = {
		{151,3},
		{153,2},
		{152,1},
		{154,2},
		{155,1},
	},
	[164] = {
		{160,3},
		{155,2},
		{161,1},
		{81,3},
		{159,3},
	},
	[169] = {
		{166,2},
		{167,1},
		{160,4},
		{165,1},
		{168,1},
	},
	[209] = {
		{133,1},
		{134,1},
		{135,1},
		{136,1},
		{137,1},
		{138,1},
		{139,1},
		{140,1},
		{141,1},
	},
}

local function hasPlayerCraftItems(player, ID)
	status = true
	for _,v in pairs(NeededItems[ID])do
		if(hasPlayerItem(player,v[1]) < v[2])then
			status = false
			break
		end
	end
	return status
end

addEvent("Craftmenu.use",true)
addEventHandler("Craftmenu.use",root,function(itemID)
	local itemID = tonumber(itemID)
	local hasNeededItems = false
	if(hasPlayerCraftItems(client,itemID) == true)then
		if(itemID == 40)then
			PlayerWeapons.addNewWeapon(client, 18, 1)
		elseif(item == 169)then
			PlayerWeapons.addNewWeapon(client,42,250)
		elseif(item == 186)then
			PlayerWeapons.addNewWeapon(client,4,1)
		else
			giveItem(client,itemID,1)
		end
		for _,v in pairs(NeededItems[itemID])do
			takeItem(client,v[1],v[2])
		end
		createInfobox(client,getText(client,"SCraftMenu1"))
	else
		createInfobox(client,getText(client,"SCraftMenu2"))
	end
end)