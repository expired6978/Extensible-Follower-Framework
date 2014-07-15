Scriptname EFF_HirelingQuest extends HirelingQuest  

EFFCore Property XFLMain Auto

function PayHireling (ObjectReference HirelingRef)
	actor HirelingActor = HirelingRef as Actor	
	game.getplayer().RemoveItem(Gold, hirelinggold.value as int)
	;HasHirelingGV.Value=1
	HirelingActor.AddToFaction(CurrentHireling)
	XFLMain.XFL_AddFollower(HirelingActor)
EndFunction

function ReHire (ObjectReference HirelingRef)
	actor HirelingActor = HirelingRef as Actor	
	HirelingActor.AddToFaction(CurrentHireling)
	XFLMain.XFL_AddFollower(HirelingActor)
	CanRehireGV.Value=1
EndFunction
