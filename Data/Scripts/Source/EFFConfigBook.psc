Scriptname EFFConfigBook extends ObjectReference  

EFFCore Property XFLMain  Auto  
EFFMenuScript Property XFLMenu Auto

Event OnRead()
	Utility.WaitMenuMode(1)
	XFLMenu.SetStage(0)
EndEvent
