Scriptname XFLPanel extends SKI_WidgetBase  

XFLScript XFLMain = None

string function GetWidgetSource()
	return "followerpanel.swf"
endFunction

string function GetWidgetType()
	return "XFLPanel"
endFunction

; @override SKI_WidgetBase
event OnWidgetReset()
	parent.OnWidgetReset()

	XFLMain = (Game.GetFormFromFile(0x48C9, "XFLMain.esm") as XFLScript)
	if XFLMain
		AddActors(XFLMain.XFL_FollowerList)
	endIf
endEvent

Function AddActors(Form aForm)
	UI.InvokeForm(HUD_MENU, WidgetRoot + ".addPanelActors", aForm)
EndFunction

Function RemoveActors(Form aForm)
	UI.InvokeForm(HUD_MENU, WidgetRoot + ".removePanelActors", aForm)
EndFunction