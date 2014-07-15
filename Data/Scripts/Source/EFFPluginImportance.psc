Scriptname EFFPluginImportance extends EFFPlugin  Conditional

Message Property FollowerImportance Auto

Keyword Property PlayerFollowerIsEssential Auto
Keyword Property PlayerFollowerIsProtected Auto

ReferenceAlias[] Property XFL_Protected Auto
ReferenceAlias[] Property XFL_Essential Auto


bool isGroup = false

int Function GetIdentifier()
	return 0x1005
EndFunction

string Function GetPluginName()
	return "$Importance"
EndFunction

; akCmd 0 - Default
; akCmd 1 - Protected
; akCmd 2 - Essential
; akForm1 - Receiving Actor
Event OnActionEvent(int akCmd, Form akForm1 = None, Form akForm2 = None, int aiValue1 = 0, int aiValue2 = 0)
	If akCmd >= 0 && akCmd <= 2
		XFL_SetImportance(akForm1 as Actor, akCmd)
	Endif
EndEvent

; Set importance state
Function XFL_SetImportance(Actor follower, Int type = 0)
	If type < 0 || type > 2 ; Invalid importance type
		return
	EndIf
	
	XFL_ClearAlias(follower)
	XFL_SetAlias(follower, type)
EndFunction

; Sets the collection alias and returns it
Function XFL_SetAlias(Actor follower, int type)
	int i = XFLMain.XFL_GetIndex(follower)
	If i != -1
		If type == 1
			XFL_Protected[i].ForceRefIfEmpty(follower)
		Elseif type == 2
			XFL_Essential[i].ForceRefIfEmpty(follower)
		Endif
	EndIf
EndFunction

; Clears the alias by actor
Function XFL_ClearAlias(Actor follower)
	int i = XFLMain.XFL_GetIndex(follower)
	If follower.HasKeyword(PlayerFollowerIsProtected)
		XFL_Protected[i].Clear()
	Elseif follower.HasKeyword(PlayerFollowerIsEssential)
		XFL_Essential[i].Clear() ; Clear the ReferenceAlias that corresponds to this actor
	EndIf
EndFunction

Function XFL_ForceClearAll()
	int i = 0
	While i < XFL_Essential.Length
		If XFL_Protected[i]
			XFL_Protected[i].Clear()
		Endif
		If XFL_Essential[i]
			XFL_Essential[i].Clear()
		EndIf		
		i += 1
	EndWhile
EndFunction

; Called when the plugin is disabled
Event OnDisabled()
	XFL_ForceClearAll()
EndEvent

; All of these plugin events will remove importance
Event OnPluginEvent(int akType, ObjectReference akRef1 = None, ObjectReference akRef2 = None, int aiValue1 = 0, int aiValue2 = 0)
	If akType == -1 ; Clearall happens before the actual event
		XFL_ForceClearAll()
	Endif
EndEvent

; Menu hierarchy
Function activateMenu(int page, Form akForm) ; Re-implement
	isGroup = false
	XFL_TriggerMenu(akForm, FollowerMenu.GetMenuState("MenuImportance"), FollowerMenu.GetMenuState("PluginMenu"), page)
EndFunction

Function activateGroupMenu(int page, Form akForm) ; Re-implement
	isGroup = true
	XFL_TriggerMenu(akForm, FollowerMenu.GetMenuState("MenuImportance"), FollowerMenu.GetMenuState("PluginMenu"), page)
EndFunction

Bool Function showMenu(Form akForm) ; Re-implement
	return true
EndFunction

Bool Function showGroupMenu() ; Re-implement
	return true
EndFunction

Function activateSubMenu(Form akForm, string previousState = "", int page = 0)
	; Do nothing in blank state
EndFunction

Function XFL_TriggerMenu(Form akForm, string menuState = "", string previousState = "", int page = 0)
	GoToState(menuState)
	activateSubMenu(akForm, previousState, page)
EndFunction

State MenuImportance_Classic
	Function activateSubMenu(Form akForm, string previousState = "", int page = 0)
		Int Importance_Back = 3
		Int Importance_Exit = 4
		
		If previousState != ""
			FollowerMenu.XFL_MessageMod_Back = 1
		EndIf

		Actor actorRef = None
		If !isGroup
			actorRef = akForm as Actor
		Endif
				
		int ret = FollowerImportance.Show()
		If ret < Importance_Back
			FollowerMenu.OnFinishMenu()
			XFLMain.XFL_SendActionEvent(GetIdentifier(), ret, actorRef)
		Elseif ret == Importance_Back
			FollowerMenu.XFL_TriggerMenu(akForm, FollowerMenu.GetMenuState("PluginMenu"), FollowerMenu.GetParentState("PluginMenu"), page) ; Force a back all the way to the plugin menu
		Elseif ret == Importance_Exit
			FollowerMenu.OnFinishMenu()
		EndIf
		
		GoToState("")
	EndFunction
EndState


; New menu system info
string[] Function GetMenuEntries(Form akForm)
	string[] entries = new string[4]
	int itemOffset = GetIdentifier() * 100
	entries[0] = GetPluginName() + ";;" + -1 + ";;" + GetIdentifier() + ";;" + 0 + ";;1"
	entries[1] = "$Default" + ";;" + GetIdentifier() + ";;" + (itemOffset + 0) + ";;" + 0 + ";;0"
	entries[2] = "$Protected" + ";;" + GetIdentifier() + ";;" + (itemOffset + 1) + ";;" + 1 + ";;0"
	entries[3] = "$Essential" + ";;" + GetIdentifier() + ";;" + (itemOffset + 2) + ";;" + 2 + ";;0"
	return entries
EndFunction

Event OnMenuEntryTriggered(Form akForm, int itemId, int callback)
	XFLMain.XFL_SendActionEvent(GetIdentifier(), callback, akForm)
EndEvent