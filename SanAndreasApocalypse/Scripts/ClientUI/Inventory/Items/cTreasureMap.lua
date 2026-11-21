TreasureMap = {MarkerTbl = {}, PickupTbl = {},
	["Marker"] = {
		[1] = {-1319.5063476562,497.92050170898,18.234375},
		[2] = {1954.8836669922,665.68383789062,10.8203125},
		[3] = {1881.0439453125,-2110.3012695312,15.1640625},
	},
}

function TreasureMap.close()
	removeEventHandler("onClientRender",root,TreasureMap.dxDraw)
	unbindKey("space","down",TreasureMap.close)
end

addEvent("TreasureMap.loadMarker",true)
addEventHandler("TreasureMap.loadMarker",root,function(ID,KeyID)
	if(not(isElement(TreasureMap.MarkerTbl[ID])))then
		local tbl = TreasureMap["Marker"][ID]
		TreasureMap.MarkerTbl[ID] = createMarker(tbl[1],tbl[2],tbl[3]-1.5,"cylinder",2,255,255,0,75)
		TreasureMap.PickupTbl[ID] = createPickup(tbl[1],tbl[2],tbl[3],3,1210,50)
		apocalypseSetElementData(TreasureMap.MarkerTbl[ID],"KeyID",KeyID)
		apocalypseSetElementData(TreasureMap.MarkerTbl[ID],"TreasureMapID",ID)
		
		addEventHandler("onClientMarkerHit",TreasureMap.MarkerTbl[ID],function(player)
			if(player == localPlayer)then
				if(getElementDimension(localPlayer) == getElementDimension(source))then
					local KeyID = apocalypseGetElementData(source,"KeyID")
					local TreasureMapID = apocalypseGetElementData(source,"TreasureMapID")
					destroyElement(TreasureMap.PickupTbl[TreasureMapID])
					destroyElement(source)
					triggerServerEvent("TreasureMap.giveKey",localPlayer,KeyID)
				end
			end
		end)
	end
end)

addEventHandler("onClientPlayerWasted",root,function()
	if(source == localPlayer)then
		TreasureMap.close()
	end
end)