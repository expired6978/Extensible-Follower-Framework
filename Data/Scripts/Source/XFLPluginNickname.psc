Scriptname XFLPluginNickname extends XFLPlugin  

int Function GetIdentifier()
	return 0x1009
EndFunction

string Function GetPluginName()
	return "$Nickname"
EndFunction

; Called when the menu system triggers an entry
Event OnMenuEntryTriggered(Form akForm, int itemId, int callback)
	Actor akRef = akForm as Actor
	If akRef
		UIMenuBase menuBase = UIExtensions.GetMenu("UITextEntryMenu")
		menuBase.SetPropertyString("text", akRef.GetDisplayName())
		menuBase.OpenMenu()
		string ret = menuBase.GetResultString()
		If ret != ""
			akRef.SetDisplayName(ret, true)
		Endif
	Endif
EndEvent

Bool Function showMenu(Form akForm) ; Re-implement
	return (XFLMain.SKSEExtended && XFLMain.MENUExtended) ; Requires menu extension and SKSE
EndFunction

Bool Function showGroupMenu() ; Do not show while in group menu
	return false
EndFunction

; New menu system info
string[] Function GetMenuEntries(Form akForm)
	string[] entries = new string[3]
	int itemOffset = GetIdentifier() * 100
	entries[0] = GetPluginName() + ";;" + -1 + ";;" + (itemOffset + 0) + ";;" + (itemOffset + 0) + ";;0"
	return entries
EndFunction
