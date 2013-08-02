Scriptname XFLPluginAggression extends XFLPlugin Conditional

Message Property FollowerAggression Auto
Keyword Property PlayerFollowerIsPassive Auto
ReferenceAlias[] Property XFL_Passive Auto

string Property STRING_AGGRESSION_PASSIVE = "$Passive" AutoReadOnly
string Property STRING_AGGRESSION_AGGRESSIVE = "$Aggressive" AutoReadOnly
string Property STRING_AGGRESSION_BACK = "$Back" AutoReadOnly
string Property STRING_AGGRESSION_EXIT = "$Exit" AutoReadOnly

bool isGroup = false

int Function GetIdentifier()
	return 0x1007
EndFunction

string Function GetPluginName()
	return "$Aggression"
EndFunction

; Called when the plugin is disabled
Event onDisabled()
	XFL_ForceClearAll()
EndEvent

; akCmd 0 - Passive
; akCmd 1 - Aggressive
; akForm1 - Receiving Actor
Event OnActionEvent(int akCmd, Form akForm1 = None, Form akForm2 = None, int aiValue1 = 0, int aiValue2 = 0)
	If akCmd == 0
		XFL_SetAggression(akForm1 as Actor, akCmd)
	Elseif akCmd == 1
		XFL_SetAggression(akForm1 as Actor, akCmd)
	Endif
EndEvent

; Follower was dismissed or died, or force clearall fired
Event OnPluginEvent(int akType, ObjectReference akRef1 = None, ObjectReference akRef2 = None, int aiValue1 = 0, int aiValue2 = 0)
	If akType >= 1 && akType <= 2 ; Only dismiss actions
		XFL_ClearAlias(akRef1 as Actor)
	Elseif akType == -1 ; Clearall happens before the actual event
		XFL_ForceClearAll()
	Endif
EndEvent

Function XFL_SetAggression(Actor followerActor, int mode)
	If mode == 0
		XFL_SetAlias(followerActor)
		followerActor.StopCombatAlarm()
	Elseif mode == 1
		XFL_ClearAlias(followerActor)
	Endif
EndFunction

; Sets the collection alias and returns it
Function XFL_SetAlias(Actor follower)
	int i = XFLMain.XFL_GetIndex(follower)
	XFL_Passive[i].ForceRefIfEmpty(follower)
EndFunction

; Clears the alias by actor
Function XFL_ClearAlias(Actor follower)
	int i = XFLMain.XFL_GetIndex(follower)
	If follower.HasKeyword(PlayerFollowerIsPassive)
		XFL_Passive[i].Clear()
	EndIf
EndFunction

Function XFL_ForceClearAll()
	int i = 0
	While i < XFL_Passive.Length
		If XFL_Passive[i]
			XFL_Passive[i].Clear()
		Endif	
		i += 1
	EndWhile
EndFunction

; Menu hierarchy
Function activateMenu(int page, Form akForm) ; Re-implement
	isGroup = false
	XFL_TriggerMenu(akForm, FollowerMenu.GetMenuState("MenuAggression"), FollowerMenu.GetMenuState("PluginMenu"), page)
EndFunction

Function activateGroupMenu(int page, Form akForm) ; Re-implement
	isGroup = true
	XFL_TriggerMenu(akForm, FollowerMenu.GetMenuState("MenuAggression"), FollowerMenu.GetMenuState("PluginMenu"), page)
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

State MenuAggression_Standard
	Function activateSubMenu(Form akForm, string previousState = "", int page = 0)
		int Aggression_Passive = 0
		int Aggression_Aggressive = 4
		Int Aggression_Back = 6
		Int Aggression_Exit = 7
		
		If previousState != "" || page > 0
			FollowerMenu.XFL_MessageMod_Back = 1
		EndIf

		Actor followerActor = akForm as Actor

		UIMenuBase wheelMenu = FollowerMenu.XFL_GetStandardMenu("UIWheelMenu")
		if wheelMenu
			wheelMenu.SetPropertyIndexString("optionText", Aggression_Passive, STRING_AGGRESSION_PASSIVE)
			wheelMenu.SetPropertyIndexString("optionText", Aggression_Aggressive, STRING_AGGRESSION_AGGRESSIVE)
			wheelMenu.SetPropertyIndexString("optionText", Aggression_Back, STRING_AGGRESSION_BACK)
			wheelMenu.SetPropertyIndexString("optionText", Aggression_Exit, STRING_AGGRESSION_EXIT)

			wheelMenu.SetPropertyIndexString("optionLabelText", Aggression_Passive, STRING_AGGRESSION_PASSIVE)
			wheelMenu.SetPropertyIndexString("optionLabelText", Aggression_Aggressive, STRING_AGGRESSION_AGGRESSIVE)
			wheelMenu.SetPropertyIndexString("optionLabelText", Aggression_Back, STRING_AGGRESSION_BACK)
			wheelMenu.SetPropertyIndexString("optionLabelText", Aggression_Exit, STRING_AGGRESSION_EXIT)
			
			wheelMenu.SetPropertyIndexBool("optionEnabled", Aggression_Passive, true)
			wheelMenu.SetPropertyIndexBool("optionEnabled", Aggression_Aggressive, true)
			wheelMenu.SetPropertyIndexBool("optionEnabled", Aggression_Back, true)
			wheelMenu.SetPropertyIndexBool("optionEnabled", Aggression_Exit, true)

			if followerActor
				if followerActor.HasKeyword(PlayerFollowerIsPassive) ; Currently passive, disable option
					wheelMenu.SetPropertyIndexInt("optionTextColor", Aggression_Passive, 0x777777)
					wheelMenu.SetPropertyIndexBool("optionEnabled", Aggression_Passive, false)
				Else
					wheelMenu.SetPropertyIndexInt("optionTextColor", Aggression_Aggressive, 0x777777)
					wheelMenu.SetPropertyIndexBool("optionEnabled", Aggression_Aggressive, false)
				Endif
			Endif

			wheelMenu.SetPropertyIndexInt("optionTextColor", Aggression_Back, 0x777777)
			
			If FollowerMenu.XFL_MessageMod_Back == 1
				wheelMenu.SetPropertyIndexBool("optionEnabled", Aggression_Back, true)
				wheelMenu.SetPropertyIndexInt("optionTextColor", Aggression_Back, 0xFFFFFF)
			EndIf

			int ret = wheelMenu.OpenMenu(akForm)
			If ret == Aggression_Aggressive || ret == Aggression_Passive
				XFLMain.XFL_SendActionEvent(GetIdentifier(), ret, akForm)
				FollowerMenu.OnFinishMenu()
			Elseif ret == Aggression_Back || (ret == -1 && FollowerMenu.XFL_MessageMod_Back == 1)
				FollowerMenu.XFL_TriggerMenu(akForm, FollowerMenu.GetMenuState("PluginMenu"), FollowerMenu.GetParentState("PluginMenu"), page) ; Force a back all the way to the plugin menu
			Elseif ret == Aggression_Exit || (ret == -1 && FollowerMenu.XFL_MessageMod_Back == 0)
				FollowerMenu.OnFinishMenu()
			EndIf
		Endif
		
		GoToState("")
	EndFunction
EndState

State MenuAggression_Classic
	Function activateSubMenu(Form akForm, string previousState = "", int page = 0)
		Int Aggression_Back = 2
		Int Aggression_Exit = 3
		
		If previousState != ""
			FollowerMenu.XFL_MessageMod_Back = 1
		EndIf

		Actor actorRef = None
		If !isGroup
			actorRef = akForm as Actor
		Endif

		int ret = FollowerAggression.Show()
		If ret < Aggression_Back
			XFLMain.XFL_SendActionEvent(GetIdentifier(), ret, actorRef)
			FollowerMenu.OnFinishMenu()
		Elseif ret == Aggression_Back
			FollowerMenu.XFL_TriggerMenu(akForm, FollowerMenu.GetMenuState("PluginMenu"), FollowerMenu.GetParentState("PluginMenu"), page) ; Force a back all the way to the plugin menu
		Elseif ret == Aggression_Exit
			FollowerMenu.OnFinishMenu()
		EndIf
		
		GoToState("")
	EndFunction
EndState

; New menu info
string[] Function GetMenuEntries(Form akForm)
	string[] entries = new string[3]
	int itemOffset = GetIdentifier() * 100
	entries[0] = GetPluginName() + ";;" + -1 + ";;" + GetIdentifier() + ";;" + 0 + ";;1"
	entries[1] = "$Passive" + ";;" + GetIdentifier() + ";;" + (itemOffset + 0) + ";;" + 0 + ";;0"
	entries[2] = "$Aggressive" + ";;" + GetIdentifier() + ";;" + (itemOffset + 1) + ";;" + 1 + ";;0"
	return entries
EndFunction

Event OnMenuEntryTriggered(Form akForm, int itemId, int callback)
	XFLMain.XFL_SendActionEvent(GetIdentifier(), callback, akForm)
EndEvent