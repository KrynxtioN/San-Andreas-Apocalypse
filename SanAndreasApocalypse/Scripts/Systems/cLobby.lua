SAALobby = {Apocalypse_Counter = 0, Shooter_Counter = 0, Race_Counter = 0}
local sx, sy = guiGetScreenSize()
local startTick = getTickCount()

addEvent("SAALobby.openDxDraw",true)
addEventHandler("SAALobby.openDxDraw",root,function()
	addEventHandler("onClientRender",root,SAALobby.render)
end)

addEvent("SAALobby.updateLobbyCounter",true)
addEventHandler("SAALobby.updateLobbyCounter",root,function(apocalypse,shooter)
	SAALobby.Apocalypse_Counter = apocalypse
	SAALobby.Shooter_Counter = shooter
end)

function SAALobby.render()
	if(isWindowOpen())then
		if(InformationHelpBarOpen == false)then
			local progress = math.min((getTickCount() - startTick) / 1000, 1)
			local offset = (1 - progress) * 60

			local x = sx - 120
			local y = sy - 28

			local lobbies = {
				{name = "Apocalypse Lobby", players = SAALobby.Apocalypse_Counter},
				{name = "Shooter Lobby", players = SAALobby.Shooter_Counter},
				{name = "Race Lobby", players = SAALobby.Race_Counter},
			}

			for i = #lobbies,1,-1 do
				local v = lobbies[i]

				local text = v.name..": "..v.players
				local w = dxGetTextWidth(text,1,"default-bold") + 20
				local h = 22

				x = x - w

				dxDrawRectangle(x-1, y-1-offset, w+2, h+2, tocolor(0,0,0,120))

				dxDrawRectangle(x, y-offset, w, h, tocolor(20,20,20,220))

				dxDrawRectangle(x, y-offset, w, 2, tocolor(255,40,40,255))

				dxDrawText(
					text,
					x, y-offset,
					x+w, y-offset+h,
					tocolor(255,255,255,255),
					1,
					"default-bold",
					"center",
					"center"
				)

				x = x - 8
			end
		end
	end
end