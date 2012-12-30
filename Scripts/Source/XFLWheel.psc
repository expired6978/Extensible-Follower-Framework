Scriptname XFLWheel extends Quest

Message Property FollowerWheel Auto

string _rootMenu = "MessageBoxMenu"
string _proxyMenu = "_root.MessageMenu.proxyMenu.WheelPhase.WheelBase."
Actor _actor = None
bool _enabled = true
int _lastIndex = 0

string[] _optionText
string[] _optionLabelText
string[] _optionIcon
float[] _optionIconColor
bool[] _optionEnabled

Function OnInit()
	_optionText = new String[8]
	_optionLabelText = new String[8]
	_optionIcon = new String[8]
	_optionIconColor = new Float[8]
	_optionEnabled = new Bool[8]
	SetupMainMenu()
EndFunction

int Function OpenMenu(Actor follower)
	_actor = follower
	RegisterForMenu(_rootMenu)
	RegisterForModEvent("XFLWheel_SetOption", "OnSelectOption")
	return FollowerWheel.Show()
EndFunction

Event OnMenuOpen(string menuName)
	If menuName == _rootMenu
		UpdateWheelEnabledOptions()
		UpdateWheelActor()
		UpdateWheelOptions()
		UpdateWheelOptionLabels()
		UpdateWheelIcons()
		UpdateWheelIconColors()
		UpdateWheelSelection()
	Endif
EndEvent

Event OnMenuClose(string menuName)
	If menuName == _rootMenu
		UnregisterForMenu(_rootMenu)
	Endif
EndEvent

Event OnSelectOption(string eventName, string strArg, float numArg, Form formArg)
	_lastIndex = numArg as Int
EndEvent

Function ClearMenu()
	_optionText[0] = ""
	_optionText[1] = ""
	_optionText[2] = ""
	_optionText[3] = ""
	_optionText[4] = ""
	_optionText[5] = ""
	_optionText[6] = ""
	_optionText[7] = ""

	_optionLabelText[0] = ""
	_optionLabelText[1] = ""
	_optionLabelText[2] = ""
	_optionLabelText[3] = ""
	_optionLabelText[4] = ""
	_optionLabelText[5] = ""
	_optionLabelText[6] = ""
	_optionLabelText[7] = ""

	_optionIcon[0] = ""
	_optionIcon[1] = ""
	_optionIcon[2] = ""
	_optionIcon[3] = ""
	_optionIcon[4] = ""
	_optionIcon[5] = ""
	_optionIcon[6] = ""
	_optionIcon[7] = ""

	_optionIconColor[0] = 0xFFFFFF
	_optionIconColor[1] = 0xFFFFFF
	_optionIconColor[2] = 0xFFFFFF
	_optionIconColor[3] = 0xFFFFFF
	_optionIconColor[4] = 0xFFFFFF
	_optionIconColor[5] = 0xFFFFFF
	_optionIconColor[6] = 0xFFFFFF
	_optionIconColor[7] = 0xFFFFFF

	_optionEnabled[0] = false
	_optionEnabled[1] = false
	_optionEnabled[2] = false
	_optionEnabled[3] = false
	_optionEnabled[4] = false
	_optionEnabled[5] = false
	_optionEnabled[6] = false
	_optionEnabled[7] = false
EndFunction

Function SetupMainMenu()
	_optionText[0] = "$Wait"
	_optionText[1] = "$Trade"
	_optionText[2] = "$Aggressive"
	_optionText[3] = "$More"
	_optionText[4] = "$Relax"
	_optionText[5] = "$Stats"
	_optionText[6] = "$Talk"
	_optionText[7] = "$Exit"

	_optionLabelText[0] = "$Wait"
	_optionLabelText[1] = "$Trade"
	_optionLabelText[2] = "$Aggressive"
	_optionLabelText[3] = "$More"
	_optionLabelText[4] = "$Relax"
	_optionLabelText[5] = "$Stats"
	_optionLabelText[6] = "$Talk"
	_optionLabelText[7] = "$Exit"

	_optionIcon[0] = "weapon_bow"
	_optionIcon[1] = "inv_all"
	_optionIcon[2] = ""
	_optionIcon[3] = ""
	_optionIcon[4] = "inv_weapons"
	_optionIcon[5] = "potion_health"
	_optionIcon[6] = "default_power"
	_optionIcon[7] = ""

	_optionIconColor[0] = 0xFFFFFF
	_optionIconColor[1] = 0xFFFFFF
	_optionIconColor[2] = 0xFFFFFF
	_optionIconColor[3] = 0xFFFFFF
	_optionIconColor[4] = 0xFFFFFF
	_optionIconColor[5] = 0xFFFFFF
	_optionIconColor[6] = 0xFFFFFF
	_optionIconColor[7] = 0xFFFFFF

	_optionEnabled[0] = true
	_optionEnabled[1] = true
	_optionEnabled[2] = true
	_optionEnabled[3] = true
	_optionEnabled[4] = true
	_optionEnabled[5] = true
	_optionEnabled[6] = true
	_optionEnabled[7] = true
EndFunction

Function SetWheelOptionSelection(int id)
	_lastIndex = id
EndFunction

Function SetWheelOptionText(int id, string str)
	If id >= 0 && id < 8
		_optionText[id] = str
	Endif
EndFunction

Function SetWheelOptionLabelText(int id, string str)
	If id >= 0 && id < 8
		_optionLabelText[id] = str
	Endif
EndFunction

Function SetWheelOptionIcon(int id, string str)
	If id >= 0 && id < 8
		_optionIcon[id] = str
	Endif
EndFunction

Function SetWheelOptionIconColor(int id, int color)
	If id >= 0 && id < 8
		_optionIconColor[id] = color as float
	Endif
EndFunction

Function SetWheelOptionEnabled(int id, bool enabled)
	If id >= 0 && id < 8
		_optionEnabled[id] = enabled
	Endif
EndFunction

; Functions only to be used while the menu is open
Function UpdateWheelSelection()
	float[] params = new float[2]
	params[0] = _lastIndex as float
	params[1] = true as float
	UI.InvokeNumberA(_rootMenu, _proxyMenu + "setWheelSelection", params)
EndFunction

Function UpdateWheelActor()
	UI.InvokeForm(_rootMenu, _proxyMenu + "setWheelActor", _actor)
EndFunction

Function UpdateWheelVisibility()
	UI.SetBool(_rootMenu, _proxyMenu + "enabled", _enabled)
	UI.SetBool(_rootMenu, _proxyMenu + "_visible", _enabled)
EndFunction

Function UpdateWheelEnabledOptions()
	UI.InvokeBoolA(_rootMenu, _proxyMenu + "setWheelOptionsEnabled", _optionEnabled)
EndFunction

Function UpdateWheelOptions()
	UI.InvokeStringA(_rootMenu, _proxyMenu + "setWheelOptions", _optionText)
EndFunction

Function UpdateWheelOptionLabels()
	UI.InvokeStringA(_rootMenu, _proxyMenu + "setWheelOptionLabels", _optionLabelText)
EndFunction

Function UpdateWheelIcons()
	UI.InvokeStringA(_rootMenu, _proxyMenu + "setWheelOptionIcons", _optionIcon)
EndFunction

Function UpdateWheelIconColors()
	UI.InvokeNumberA(_rootMenu, _proxyMenu + "setWheelOptionIconColors", _optionIconColor)
EndFunction