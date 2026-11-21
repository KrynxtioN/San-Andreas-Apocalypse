PirateIsland = {
	["Reward_Pickups"] = {
		{413.74560546875,2536.7690429688,10,10,3},
		{413.74560546875,2536.7690429688,10,10,4},
		{413.74560546875,2536.7690429688,10,10,5},
	},
}

addEventHandler("onClientRender",root,function()
	if(isCharacterLoggedIn() and isWindowOpen())then
		for i,v in pairs(PirateIsland["Reward_Pickups"])do
			if(getElementInterior(localPlayer) == v[4])then
				if(getElementDimension(localPlayer) == v[5])then
					local x1,y1,z1 = v[1],v[2],v[3]
					local screenX1,screenY1 = getScreenFromWorldPosition(x1,y1,z1)
					
					if(screenX1 and screenY1)then
						if(getDistanceBetweenPoints3D(x1,y1,z1,getElementPosition(localPlayer)) <= 5)then
							dxDrawText(getText("CPirateIsland1"):format(i), screenX1 - 100, screenY1 - 20, screenX1 + 100, screenY1 + 20, tocolor(255, 255, 255), 1.2, "default-bold", "center", "center")
						end
					end
				end
			end
		end
	end
end)