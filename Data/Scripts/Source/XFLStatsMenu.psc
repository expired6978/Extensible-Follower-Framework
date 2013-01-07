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
	RegisterForModEvent("XFLStatPanel_LoadMenu", "OnLoadSettings")
	return FollowerStats.Show()
EndFunction

Event OnLoadSettings(string eventName, string strArg, float numArg, Form formArg)
	UpdateStatsForm()
EndEvent

Function UpdateStatsForm()
	UI.InvokeForm(_rootMenu, _proxyMenu + "setActorStatsPanelForm", _form)
EndFunction