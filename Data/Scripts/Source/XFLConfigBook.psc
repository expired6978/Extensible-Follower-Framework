Scriptname XFLConfigBook extends ObjectReference  

XFLScript Property XFLMain  Auto  
XFLMenuScript Property XFLMenu Auto

Event OnRead()
	Utility.WaitMenuMode(1)
	XFLMenu.SetStage(0)
EndEvent
