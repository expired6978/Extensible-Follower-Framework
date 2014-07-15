Scriptname EFFPlugin extends Quest Conditional

EFFCore Property XFLMain Auto
EFFMenuScript Property FollowerMenu Auto

MiscObject Property MenuOption Auto
ObjectReference Property MenuRef Auto
GlobalVariable Property EnabledVar Auto

int Function GetIdentifier()
	return 0
EndFunction

string Function GetPluginName()
	return ""
EndFunction

string[] Function GetMenuEntries(Form akForm)
	return new string[1]
EndFunction

; Called when the menu system triggers an entry
Event OnMenuEntryTriggered(Form akForm, int itemId, int callback)
	
EndEvent

; Standard initialization for the plugin, DO NOT EDIT UNLESS YOU KNOW WHAT YOU'RE DOING
Event OnInit()
	If XFLMain && FollowerMenu
		XFLMain.XFL_RegisterPlugin(Self) ; Register the plugin
		If MenuOption
			MenuRef = FollowerMenu.XFL_RegisterMenuOption(MenuOption) ; Add the option to the list
		EndIf
	EndIf
EndEvent

Bool Function isEnabled()
	If EnabledVar
		return EnabledVar.GetValue()
	Endif
	return false
EndFunction

; Determines whether to show the plugin in the command menu
Bool Function showMenu(Form akForm) ; Re-implement
	return false
EndFunction

; Determines whether to show the plugin in the group command menu
Bool Function showGroupMenu() ; Re-implement
	return false
EndFunction

; Called when the menu is activated
Function activateMenu(int page, Form akForm) ; Re-implement
	; Do nothing
EndFunction

; Called when the group menu is activated
Function activateGroupMenu(int page, Form akForm) ; Re-implement
	; Do nothing
EndFunction

; Called when the plugin is enabled
Event OnEnabled()
	; Do nothing
EndEvent

; Called when the plugin is disabled
Event OnDisabled()
	; Do nothing
EndEvent

; Called when any follower event occurs
; 0 Add
; 1 Remove
; 2 Remove Dead
; 3 Follow
; 4 Wait
; 5 Relax
; 6 Combat State
; Calling EFFCore:XFL_SendPluginEvent(int akType, ObjectReference akRef1 = None, ObjectReference akRef2 = None, int aiValue1 = 0, int aiValue2 = 0)
; Will propagate the event to all other plugins available
Event OnPluginEvent(int akType, ObjectReference akRef1 = None, ObjectReference akRef2 = None, int aiValue1 = 0, int aiValue2 = 0)
	; Do nothing
EndEvent

; Action event received by the system to determine what to do
Event OnActionEvent(int akCmd, Form akForm1 = None, Form akForm2 = None, int aiValue1 = 0, int aiValue2 = 0)
	; Do nothing
EndEvent
