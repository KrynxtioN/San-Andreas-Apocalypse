CommunityPumpkin = {}

if(HalloweenEvent == true)then
	CommunityPumpkin.Object = createPickup(685.626953125,-433.62274169922,16.518444061279,3,1935,50)
	
	addEventHandler("onPickupHit",CommunityPumpkin.Object,function(player)
		if(getElementDimension(player) == getElementDimension(source))then
			if(getElementType(player) == "player")then
				local collected = tonumber(getPlayerData("server_event_data","ID",2,"community_progress"))
				createInfobox(player,getText(player,"SCommunityPumpkin1"):format(collected))
			end
		end
	end)
end