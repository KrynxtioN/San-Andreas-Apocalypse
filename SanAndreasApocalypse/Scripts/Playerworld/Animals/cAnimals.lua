Animals = {
	["Models"] = {
		{"bear",237},
		{"goat",238},
		{"wolf",243},
		{"cow1",244},
		{"cow2",245},
		{"alligator",246},
		{"chicken",251},
		{"fox",252},
	},
}

function Animals.load()
	for _,v in pairs(Animals["Models"])do
		local txd = engineLoadTXD("Files/Models/Animals/"..v[1]..".txd")
		engineImportTXD(txd,v[2])
		local dff = engineLoadDFF("Files/Models/Animals/"..v[1]..".dff",v[2])
		engineReplaceModel(dff,v[2])
	end
end
Animals.load()