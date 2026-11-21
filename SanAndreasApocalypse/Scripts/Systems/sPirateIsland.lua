PirateIsland = {Pickup = {},
	["Reward_Pickups"] = {
		{413.74560546875,2536.7690429688,10,10,3},
		{413.74560546875,2536.7690429688,10,10,4},
		{413.74560546875,2536.7690429688,10,10,5},
	},
	["Player_Bonus"] = {
		[1] = {},
		[2] = {},
		[3] = {},
	},
}

for i,v in ipairs(PirateIsland["Reward_Pickups"])do
	PirateIsland.Pickup[i] = createPickup(v[1],v[2],v[3],3,1239,50)
	setElementInterior(PirateIsland.Pickup[i],v[4])
	setElementDimension(PirateIsland.Pickup[i],v[5])
	apocalypseSetElementData(PirateIsland.Pickup[i],"PirateRewardID",i)
	
	addEventHandler("onPickupHit",PirateIsland.Pickup[i],function(player)
		if(getElementType(player) == "player")then
			if(getElementDimension(player) == getElementDimension(source))then
				local ID = apocalypseGetElementData(source,"PirateRewardID")
				local Character_ID = getCharacterID(player)
				if(not(PirateIsland["Player_Bonus"][ID][Character_ID]))then
					local EXP = 75 * apocalypseGetElementData(player,"level")
					giveEXP(player,EXP)
					PirateIsland["Player_Bonus"][ID][Character_ID] = true
					createInfobox(player,getText(player,"SPirateIsland2"):format(EXP))
				else
					NPC.MeMessage(player,getText(player,"SPirateIsland1"))
				end
			end
		end
	end)
end

addEvent("PirateIsland.claimReward",true)
addEventHandler("PirateIsland.claimReward",root,function()
	if(tonumber(apocalypseGetElementData(client, "money")) >= 1250)then
		apocalypseSetElementData(client,"money",apocalypseGetElementData(client,"money")-1250)
		giveItem(client,208,1)
		createInfobox(client,getText(client,"SPirateIsland4"))
	else
		NPC.MeMessage(client,getText(client,"SPirateIsland3"))
	end
end)