Scriptname XFLSelectionMenu extends Quest

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

bool Function OpenMenu(Form aForm, Form aReceiver)
	_form = aForm
	_receiver = aReceiver
	_selected = None
	SelectedForms.Revert()
	RegisterForMenu(_rootMenu)
	RegisterForModEvent("SelectionMenu_SelectForm", "OnSelect")
	RegisterForModEvent("SelectionMenu_SelectionReady", "OnSelectForm")
	_receiver.RegisterForModEvent("SelectionMenu_SelectionChanged", "OnSelectForm")
	return FollowerSelection.Show() as bool
EndFunction

Event OnSelect(string eventName, string strArg, float numArg, Form formArg)
	if _mode == 0
		_selected = formArg
	elseif _mode == 1
		SelectedForms.AddForm(formArg)
	endif
EndEvent

Event OnSelectForm(string eventName, string strArg, float numArg, Form formArg)
	SendModEvent("SelectionMenu_SelectionChanged", "", numArg)
EndEvent

Event OnMenuOpen(string menuName)
	If menuName == _rootMenu
		UI.InvokeForm(_rootMenu, _proxyMenu + "SetSelectionMenuFormData", _form)
		UI.InvokeNumber(_rootMenu, _proxyMenu + "SetSelectionMenuMode", _mode as float)

		SoundDescriptor sDescriptor = (Game.GetForm(0x137E7) as Sound).GetDescriptor()
		tempSoundDB = sDescriptor.GetDecibelAttenuation()
		sDescriptor.SetDecibelAttenuation(100.0)
	Endif
EndEvent

Event OnMenuClose(string menuName)
	If menuName == _rootMenu
		UnregisterForMenu(_rootMenu)
		_receiver.UnregisterForModEvent("SelectionMenu_SelectForm")

		SoundDescriptor sDescriptor = (Game.GetForm(0x137E7) as Sound).GetDescriptor()
		sDescriptor.SetDecibelAttenuation(tempSoundDB)
	Endif
EndEvent
