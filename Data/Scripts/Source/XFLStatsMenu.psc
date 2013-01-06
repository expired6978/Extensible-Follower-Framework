Scriptname XFLStatsMenu extends XFLMenuBase

Message Property FollowerStats Auto

string _rootMenu = "MessageBoxMenu"
string _proxyMenu = "_root.MessageMenu.proxyMenu.ActorStatsPanelFader.actorStatsPanel."

Form _form = None

string Function GetMenuName()
	return "StatsMenu"
EndFunction

int Function OpenMenu(Form inForm, Form akReceiver = None)
	_form = inForm
	RegisterForMenu(_rootMenu)
	return FollowerStats.Show()
EndFunction

Event OnMenuOpen(string menuName)
	If menuName == _rootMenu
		UpdateStatsForm()
	Endif
EndEvent

Event OnMenuClose(string menuName)
	If menuName == _rootMenu
		UnregisterForMenu(_rootMenu)
	Endif
EndEvent

Function UpdateStatsForm()
	UI.InvokeForm(_rootMenu, _proxyMenu + "setActorStatsPanelForm", _form)
EndFunction