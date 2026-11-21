local Model_ID_1 = 1877
local Model_ID_2 = 1878

local TXD = engineLoadTXD("Files/Mods/Objects/mushrooms.txd")
engineImportTXD(TXD,Model_ID_1)
local TXD = engineLoadTXD("Files/Mods/Objects/mushrooms.txd")
engineImportTXD(TXD,Model_ID_2)

local DFF = engineLoadDFF("Files/Mods/Objects/mushroom01.dff")
engineReplaceModel(DFF,Model_ID_1)
local DFF = engineLoadDFF("Files/Mods/Objects/mushroom02.dff")
engineReplaceModel(DFF,Model_ID_2)

local COL = engineLoadCOL("Files/Mods/Objects/mushroom01.col")
engineReplaceCOL(COL,Model_ID_1)
local COL = engineLoadCOL("Files/Mods/Objects/mushroom02.col")
engineReplaceCOL(COL,Model_ID_2)