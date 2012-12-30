Scriptname XFLPanel extends SKI_WidgetBase  

XFLScript XFLMain = None

string function GetWidgetType()
	return "followerpanel"
endFunction

; @override SKI_WidgetBase
event OnWidgetReset()
	parent.OnWidgetReset()

	XFLMain = (Game.GetFormFromFile(0x48C9, "XFLMain.esm") as XFLScript)
	if XFLMain
		Debug.Trace("Adding: " + XFLMain.XFL_FollowerList)
		AddActors(XFLMain.XFL_FollowerList)
	endIf
endEvent

Function AddActors(Form aForm)
	UI.InvokeForm(HUD_MENU, WidgetRoot + ".addPanelActors", aForm)
EndFunction

Function RemoveActors(Form aForm)
	UI.InvokeForm(HUD_MENU, WidgetRoot + ".removePanelActors", aForm)
EndFunction