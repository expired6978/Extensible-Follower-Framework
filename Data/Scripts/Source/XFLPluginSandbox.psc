Scriptname XFLPluginSandbox extends XFLPlugin Conditional

Keyword Property PlayerFollowerSandboxing Auto

ReferenceAlias[] Property XFL_Sandboxers Auto 
ReferenceAlias[] Property XFL_Markers Auto 

Message Property FollowerSandbox Auto

Float Property XFL_MessageMod_State Auto Conditional

bool isGroup = false

int Function GetIdentifier()
	return 0x1004
EndFunction

string Function GetPluginName()
	return "$Sandbox"
EndFunction

; akCmd 0 - Start Sandbox
; akCmd 1 - Clear Sandbox
; akForm1 - Receiving Actor
Event OnActionEvent(int akCmd, Form akForm1 = None, Form akForm2 = None, int aiValue1 = 0, int aiValue2 = 0)
	If akCmd == 0
		XFL_StartSandboxing(akForm1 as Actor)
	Elseif akCmd == 1
		XFL_ClearAlias(akForm1 as Actor)
	Endif
EndEvent

; Command: Start Sandboxing
; Function XFL_BeginSandbox(Actor follower = None)
; 	If follower != None
; 		XFL_StartSandboxing(follower)
; 	Else
; 		int i = 0
; 		While i <= XFLMain.XFL_GetMaximum()
; 			If XFLMain.XFL_FollowerAliases[i] && XFLMain.XFL_FollowerAliases[i].GetActorRef() != None
; 				XFL_StartSandboxing(XFLMain.XFL_FollowerAliases[i].GetActorRef())
; 			EndIf
; 			i += 1
; 		EndWhile
; 	Endif
; Endfunction

; ; Command: Stop Sandboxing
; Function XFL_EndSandbox(Actor follower = None)
; 	If follower != None
; 		If follower.HasKeyword(PlayerFollowerSandboxing)
; 			XFL_ClearAlias(follower)
; 		Endif
; 	Else
; 		int i = 0
; 		While i <= XFLMain.XFL_GetMaximum()
; 			If XFLMain.XFL_FollowerAliases[i] && XFLMain.XFL_FollowerAliases[i].GetActorRef() != None
; 				XFL_ClearAlias(XFLMain.XFL_FollowerAliases[i].GetActorRef())
; 			EndIf
; 			i += 1
; 		EndWhile
; 	Endif
; Endfunction

; Sets the followers sandbox location, relocates it if they are already sandboxing
Function XFL_StartSandboxing(Actor follower)
	If follower.HasKeyword(PlayerFollowerSandboxing)
		XFL_Markers[XFL_GetIndex(follower)].GetRef().MoveTo(follower)
	Else
		XFL_SetAlias(follower)
	Endif
EndFunction

int Function XFL_GetIndex(Actor follower)
	int i = 0
	While i < XFL_Sandboxers.Length
		If (XFL_Sandboxers[i].GetReference() as Actor) == follower
			return i
		EndIf
		i += 1
	EndWhile
	return -1
EndFunction

; Sets the followers sandbox location
Function XFL_SetAlias(Actor follower)
	int i = 0
	While i < XFL_Sandboxers.Length
		If XFL_Sandboxers[i].ForceRefIfEmpty(follower)
			XFL_Markers[i].GetReference().MoveTo(follower)
			return
		EndIf
		i += 1
	EndWhile
EndFunction

; Clears the alias by actor
Function XFL_ClearAlias(Actor follower)
	int i = 0
	While i < XFL_Sandboxers.Length
		If (XFL_Sandboxers[i].GetReference() as Actor) == follower
			XFL_Sandboxers[i].Clear()
			return
		EndIf
		i += 1
	EndWhile
EndFunction

Function XFL_ForceClearAll()
	int i = 0
	While i < XFL_Sandboxers.Length
		If XFL_Sandboxers[i]
			XFL_Sandboxers[i].TryToClear()
		EndIf
		i += 1
	EndWhile
EndFunction

Event OnDisable()
	XFL_ForceClearAll()
EndEvent

; All of these plugin events will stop the follower from collecting
Event OnPluginEvent(int akType, ObjectReference akRef1 = None, ObjectReference akRef2 = None, int aiValue1 = 0, int aiValue2 = 0)
	If akType == -1 ; Clearall happens before the actual event
		XFL_ForceClearAll()
	Endif
EndEvent

; Menu hierarchy
Function activateMenu(int page, Actor follower) ; Re-implement
	isGroup = false
	XFL_TriggerMenu(follower, "MenuSandbox", "PluginMenu", page)
EndFunction

Function activateGroupMenu(int page, Actor follower) ; Re-implement
	isGroup = true
	XFL_TriggerMenu(follower, "MenuSandbox", "PluginMenu", page)
EndFunction

Bool Function showMenu(Actor follower) ; Re-implement
	return true
EndFunction

Bool Function showGroupMenu() ; Re-implement
	return true
EndFunction

Function activateSubMenu(Actor followerActor, string previousState = "", int page = 0)
	; Do nothing in blank state
EndFunction

Function XFL_TriggerMenu(Actor followerActor, string menuState = "", string previousState = "", int page = 0)
	GoToState(menuState)
	activateSubMenu(followerActor, previousState, page)
EndFunction

State MenuSandbox ; Choose which type of outfit to wear
	Function activateSubMenu(Actor followerActor, string previousState = "", int page = 0)
		Int Sandbox_Set = 0
		Int Sandbox_Clear = 1
		Int Sandbox_Back = 2
		Int Sandbox_Exit = 3
		
		If previousState != ""
			FollowerMenu.XFL_MessageMod_Back = 1
		EndIf
		
		Actor actorRef = None
		If !isGroup
			actorRef = followerActor
		Endif
		
		If actorRef != None
			XFL_MessageMod_State = actorRef.HasKeyword(PlayerFollowerSandboxing) as Int
		Else
			XFL_MessageMod_State = 0
		Endif
		
		int ret = FollowerSandbox.Show()
		;If ret == Sandbox_Set
		;	XFL_BeginSandbox(actorRef)
		;Elseif ret == Sandbox_Clear
		;	XFL_EndSandbox(actorRef)
		If ret < Sandbox_Back
			FollowerMenu.OnFinishMenu()
			XFLMain.XFL_SendActionEvent(GetIdentifier(), ret, followerActor)
		Elseif ret == Sandbox_Back
			FollowerMenu.XFL_TriggerMenu(followerActor, "PluginMenu", FollowerMenu.GetParentState("PluginMenu"), page) ; Force a back all the way to the plugin menu
		Elseif ret == Sandbox_Exit
			FollowerMenu.OnFinishMenu()
		EndIf
		
		GoToState("")
	EndFunction
EndState
