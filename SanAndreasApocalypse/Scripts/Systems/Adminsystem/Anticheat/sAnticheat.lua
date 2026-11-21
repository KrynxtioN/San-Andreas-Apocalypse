ElementData = {}

function apocalypseSetElementData(player,data,value)
	if(player and data)then
		if(not(ElementData[player]))then
			ElementData[player] = {}
		end
		ElementData[player][data] = value
		if(isElement(player))then
			setElementData(player,data,value)
		end
	else
		return nil
	end
end

function apocalypseGetElementData(player, data)
    if(not isElement(player))then
        return nil
    end
    if(player and data)then
        if (not ElementData[player]) then
            ElementData[player] = {}
            return nil
        end
        if(ElementData[player][data])then
            return ElementData[player][data]
        else
            ElementData[player][data] = getElementData(player, data)
            return ElementData[player][data]
        end
    else
        return nil
    end
end