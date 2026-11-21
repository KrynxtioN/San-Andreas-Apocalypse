availableCases = {
	["SAACoinCrate"] = { -- Name | Image | Chance in percent | win amount / model id
		{"5 SAA Coins", "SAACoin1.png", 100,5},
		{"10 SAA Coins", "SAACoin2.png", 25,10},
		{"25 SAA Coins", "SAACoin3.png", 5,25},
		{"50 SAA Coins", "SAACoin4.png", 1,50},
	},
	["VehicleCrate"] = {
		{"Glendale Damaged", "GlendaleDamage.png", 100, 604},
		{"Tampa", "Tampa.png", 25, 549},
		{"Admiral", "Admiral.png", 10, 445},
		{"Pizzaboy", "Pizzaboy.png", 1, 448},
	},
}

local function swap(array, a, b)
	array[a], array[b] = array[b], array[a]
end

function shuffleTable(array)
	local count = #array

	while count > 1 do
		swap(array, math.random(#array), count)
		count = count - 1
	end
end