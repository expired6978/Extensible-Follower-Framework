Scriptname XFLWheel extends XFLMenuBase

Message Property FollowerWheel Auto

string _rootMenu = "MessageBoxMenu"
string _proxyMenu = "_root.MessageMenu.proxyMenu.WheelPhase.WheelBase."
Form _form = None
bool _enabled = true
int _lastIndex = 0

string[] _optionText
string[] _optionLabelText
string[] _optionIcon
int[] _optionIconColor
bool[] _optionEnabled
int[] _optionTextColor

string Function GetMenuName()
	return "WheelMenu"
EndFunction

Function OnInit()
	_optionText = new String[8]
	_optionLabelText = new String[8]
	_optionIcon = new String[8]
	_optionIconColor = new Int[8]
	_optionEnabled = new Bool[8]
	_optionTextColor = new Int[8]
	ClearMenu()
EndFunction

int Function OpenMenu(Form akForm, Form akReceiver = None)
	_form = akForm
	RegisterForModEvent("XFLWheel_SetOption", "OnSelectOption")
	RegisterForModEvent("XFLWheel_LoadMenu", "OnLoadMenu")
	return FollowerWheel.Show()
EndFunction

Event OnLoadMenu(string eventName, string strArg, float numArg, Form formArg)
	UpdateWheelEnabledOptions()
	UpdateWheelForm()
	UpdateWheelOptions()
	UpdateWheelOptionLabels()
	UpdateWheelIcons()
	UpdateWheelIconColors()
	UpdateWheelSelection()
	UpdateWheelTextColors()
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

	_optionTextColor[0] = 0xFFFFFF
	_optionTextColor[1] = 0xFFFFFF
	_optionTextColor[2] = 0xFFFFFF
	_optionTextColor[3] = 0xFFFFFF
	_optionTextColor[4] = 0xFFFFFF
	_optionTextColor[5] = 0xFFFFFF
	_optionTextColor[6] = 0xFFFFFF
	_optionTextColor[7] = 0xFFFFFF

	_optionEnabled[0] = false
	_optionEnabled[1] = false
	_optionEnabled[2] = false
	_optionEnabled[3] = false
	_optionEnabled[4] = false
	_optionEnabled[5] = false
	_optionEnabled[6] = false
	_optionEnabled[7] = false
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
		_optionIconColor[id] = color
	Endif
EndFunction

Function SetWheelOptionTextColor(int id, int color)
	If id >= 0 && id < 8
		_optionTextColor[id] = color
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
	UI.InvokeFloatA(_rootMenu, _proxyMenu + "setWheelSelection", params)
EndFunction

Function UpdateWheelForm()
	UI.InvokeForm(_rootMenu, _proxyMenu + "setWheelForm", _form)
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
	UI.InvokeIntA(_rootMenu, _proxyMenu + "setWheelOptionIconColors", _optionIconColor)
EndFunction

Function UpdateWheelTextColors()
	UI.InvokeIntA(_rootMenu, _proxyMenu + "setWheelOptionTextColors", _optionTextColor)
EndFunction