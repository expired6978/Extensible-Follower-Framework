Scriptname XFLMagicMenu extends XFLMenuBase  

Message Property FollowerMagicMenuMessage Auto

string _rootMenu = "MessageBoxMenu"
string _proxyMenu = "_root.MessageMenu.proxyMenu."

Actor _actor = None

float tempSoundDB = 0.0

string Function GetMenuName()
	return "MagicMenuExt"
EndFunction

int Function OpenMenu(Form akForm, Form akReceiver = None)
	_actor = akForm as Actor
	RegisterForMenu(_rootMenu)
	return FollowerMagicMenuMessage.Show()
EndFunction

Event OnMenuOpen(string menuName)
	If menuName == _rootMenu
		UI.Invoke(_rootMenu, _proxyMenu + "InitExtensions")
		float[] params = new Float[2]
		params[0] = 0
		params[1] = 0
		UI.InvokeFloatA(_rootMenu, _proxyMenu + "SetPlatform", params)
		UI.InvokeForm(_rootMenu, _proxyMenu + "Menu_mc.SetMagicMenuExtActor", _actor)

		; Kill the MessageBox UI OK Sound
		SoundDescriptor sDescriptor = (Game.GetForm(0x137E7) as Sound).GetDescriptor()
		tempSoundDB = sDescriptor.GetDecibelAttenuation()
		sDescriptor.SetDecibelAttenuation(100.0)
	Endif
EndEvent

Event OnMenuClose(string menuName)
	If menuName == _rootMenu
		UnregisterForMenu(_rootMenu)

		; Restore the MessageBox UI OK Sound
		SoundDescriptor sDescriptor = (Game.GetForm(0x137E7) as Sound).GetDescriptor()
		sDescriptor.SetDecibelAttenuation(tempSoundDB)
	Endif
EndEvent
