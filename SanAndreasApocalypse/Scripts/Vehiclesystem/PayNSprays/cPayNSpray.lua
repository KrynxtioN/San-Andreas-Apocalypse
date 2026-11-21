PayNSpray = {}

addEvent("PayNSpray.createWindow",true)
addEventHandler("PayNSpray.createWindow",root,function()
	colorPicker.create(1, _, getText("CPayNSpray1"))
end)

addEvent("PayNSpray.setCameraMatrix",true)
addEventHandler("PayNSpray.setCameraMatrix",root,function(pos1,pos2,pos3,pos4,pos5,pos6)
	setCameraMatrix(pos1,pos2,pos3,pos4,pos5,pos6,0,70)
end)