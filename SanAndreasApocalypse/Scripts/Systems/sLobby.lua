SAALobby = {Apocalypse_Counter = 0, Shooter_Counter = 0, Race_Counter = 0}

function SAALobby.updateLobbyCounter(player)
	triggerClientEvent(player,"SAALobby.updateLobbyCounter",player,
		SAALobby.Apocalypse_Counter,
		SAALobby.Shooter_Counter,
		SAALobby.Race_Counter
	)
end

function SAALobby.load(player)
	SAALobby.updateLobbyCounter(player)
	triggerClientEvent(player,"SAALobby.openDxDraw",player)
end

function SAALobby.addApocalypsePlayer()
	SAALobby.Apocalypse_Counter = SAALobby.Apocalypse_Counter + 1
	
	for _,v in pairs(getElementsByType("player"))do
		if(isCharacterLoggedIn(v))then
			SAALobby.updateLobbyCounter(v)
		end
	end
end

function SAALobby.addShooterPlayer()
	SAALobby.Shooter_Counter = SAALobby.Shooter_Counter + 1
	
	for _,v in pairs(getElementsByType("player"))do
		if(isCharacterLoggedIn(v))then
			SAALobby.updateLobbyCounter(v)
		end
	end
end

function SAALobby.addRacePlayer()
	SAALobby.Race_Counter = SAALobby.Race_Counter + 1
	
	for _,v in pairs(getElementsByType("player"))do
		if(isCharacterLoggedIn(v))then
			SAALobby.updateLobbyCounter(v)
		end
	end
end

function SAALobby.removeApocalypsePlayer()
	SAALobby.Apocalypse_Counter = SAALobby.Apocalypse_Counter - 1
	
	for _,v in pairs(getElementsByType("player"))do
		if(isCharacterLoggedIn(v))then
			SAALobby.updateLobbyCounter(v)
		end
	end
end

function SAALobby.removeShooterPlayer()
	SAALobby.Shooter_Counter = SAALobby.Shooter_Counter - 1
	
	for _,v in pairs(getElementsByType("player"))do
		if(isCharacterLoggedIn(v))then
			SAALobby.updateLobbyCounter(v)
		end
	end
end

function SAALobby.removeShooterPlayer()
	SAALobby.Race_Counter = SAALobby.Race_Counter - 1
	
	for _,v in pairs(getElementsByType("player"))do
		if(isCharacterLoggedIn(v))then
			SAALobby.updateLobbyCounter(v)
		end
	end
end