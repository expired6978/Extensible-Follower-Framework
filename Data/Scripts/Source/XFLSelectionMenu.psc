Scriptname XFLSelectionMenu extends XFLMenuBase

Message Property FollowerSelection Auto
FormList Property SelectedForms  Auto  

string _rootMenu = "MessageBoxMenu"
string _proxyMenu = "_root.MessageMenu.proxyMenu.MenuHolder.Menu_mc."

Form _form = None
Form _receiver = None
Form _selected = None

int _mode = 0

float tempSoundDB = 0.0

Form Function GetSelection()
	if _mode == 0
		return _selected
	elseif _mode == 1
		return SelectedForms
	endif
	return None
EndFunction

Function SetMode(int mode)
	if mode >= 0 && mode <= 1
		_mode = mode
	endif
EndFunction

int Function OpenMenu(Form aForm, Form aReceiver = None)
	_form = aForm
	_receiver = aReceiver
	_selected = None
	SelectedForms.Revert()
	RegisterForMenu(_rootMenu)
	RegisterForModEvent("SelectionMenu_LoadMenu", "OnLoadMenu")
	RegisterForModEvent("SelectionMenu_SelectForm", "OnSelect")
	RegisterForModEvent("SelectionMenu_SelectionReady", "OnSelectForm")
	_receiver.RegisterForModEvent("SelectionMenu_SelectionChanged", "OnSelectForm")
	return FollowerSelection.Show()
EndFunction

string Function GetMenuName()
	return "SelectionMenu"
EndFunction

; Push forms to FormList
Event OnSelect(string eventName, string strArg, float numArg, Form formArg)
	if _mode == 0
		_selected = formArg
	elseif _mode == 1
		SelectedForms.AddForm(formArg)
	endif
EndEvent

; Notify receivers of ReadyState
Event OnSelectForm(string eventName, string strArg, float numArg, Form formArg)
	SendModEvent("SelectionMenu_SelectionChanged", "", numArg)
EndEvent

Event OnLoadMenu(string eventName, string strArg, float numArg, Form formArg)
	UI.InvokeForm(_rootMenu, _proxyMenu + "SetSelectionMenuFormData", _form)
	UI.InvokeFloat(_rootMenu, _proxyMenu + "SetSelectionMenuMode", _mode as float)

	SoundDescriptor sDescriptor = (Game.GetForm(0x137E7) as Sound).GetDescriptor()
	tempSoundDB = sDescriptor.GetDecibelAttenuation()
	sDescriptor.SetDecibelAttenuation(100.0)
EndEvent

Event OnMenuClose(string menuName)
	If menuName == _rootMenu
		UnregisterForMenu(_rootMenu)
		_receiver.UnregisterForModEvent("SelectionMenu_SelectionChanged")
		SoundDescriptor sDescriptor = (Game.GetForm(0x137E7) as Sound).GetDescriptor()
		sDescriptor.SetDecibelAttenuation(tempSoundDB)
	Endif
EndEvent
