Scriptname XFLPluginSpells extends XFLPlugin Conditional

Message Property FollowerSpells Auto
Message Property FollowerSpellSelect Auto

bool isGroup = false
bool isForget = false

int Function GetIdentifier()
	return 0x1006
EndFunction

string Function GetPluginName()
	return "$Spells"
EndFunction

; akCmd 0 - Teach Spell
; akCmd 1 - Forget Spell
; akForm1 - Sending Actor
; akForm2 - Receiving Actor
; aiValue1 - Hand
Event OnActionEvent(int akCmd, Form akForm1 = None, Form akForm2 = None, int aiValue1 = 0, int aiValue2 = 0)
	If akCmd == 0
		XFL_AddSpell(akForm1 as Actor, akForm2 as Actor, aiValue1)
	Elseif akCmd == 1
		XFL_RemoveSpell(akForm1 as Actor, akForm2 as Actor, aiValue1)
	Endif
EndEvent

; Determines whether to show the plugin in the command menu
Bool Function showMenu(Actor follower) ; Re-implement
	return true
EndFunction

; Determines whether to show the plugin in the group command menu
Bool Function showGroupMenu() ; Re-implement
	return true
EndFunction

; Command: Spells
; Function XFL_TeachSpell(Actor teacher, Actor student, int hand, bool forget = false)
; 	If student != None
; 		If !forget
; 			XFL_AddSpell(teacher, student, hand)
; 		Else
; 			XFL_RemoveSpell(teacher, student, hand)
; 		Endif
; 	Else
; 		int i = 0
; 		While i <= XFLMain.XFL_GetMaximum()
; 			If XFLMain.XFL_FollowerAliases[i] && XFLMain.XFL_FollowerAliases[i].GetActorRef() != None
; 				If !forget
; 					XFL_AddSpell(teacher, XFLMain.XFL_FollowerAliases[i].GetActorRef(), hand)
; 				Else
; 					XFL_RemoveSpell(teacher, XFLMain.XFL_FollowerAliases[i].GetActorRef(), hand)
; 				Endif
; 			EndIf
; 			i += 1
; 		EndWhile
; 	Endif
; EndFunction

Function XFL_AddSpell(Actor teacher, Actor student, int hand)
	Spell handSpell = teacher.GetEquippedSpell(hand)
	If !student.HasSpell(handSpell)
		student.AddSpell(handSpell)
		AbsorbEffect(teacher, student)
	Endif
EndFunction

Function XFL_RemoveSpell(Actor teacher, Actor student, int hand)
	Spell handSpell = teacher.GetEquippedSpell(hand)
	If student.HasSpell(handSpell)
		student.RemoveSpell(handSpell)
		AbsorbEffect(student, teacher)
	Endif
EndFunction

Function activateMenu(int page, Actor follower) ; Re-implement
	isGroup = false
	XFL_TriggerMenu(follower, FollowerMenu.GetMenuState("MenuSpells"), FollowerMenu.GetMenuState("PluginMenu"), page)
EndFunction

Function activateGroupMenu(int page, Actor follower) ; Re-implement
	; Do nothing
	isGroup = true
	XFL_TriggerMenu(follower, FollowerMenu.GetMenuState("MenuSpells"), FollowerMenu.GetMenuState("PluginMenu"), page)
EndFunction

Function XFL_TriggerMenu(Actor followerActor, string menuState = "", string previousState = "", int page = 0)
	GoToState(menuState)
	activateSubMenu(followerActor, previousState, page)
EndFunction

Function activateSubMenu(Actor followerActor, string previousState = "", int page = 0)
	; Do nothing in blank state
EndFunction

State MenuSpells_Classic ; Choose which type of outfit to wear
	Function activateSubMenu(Actor followerActor, string previousState = "", int page = 0)
		int Spells_Teach = 0
		int Spells_Forget = 1
		int Spells_Back = 2
		int Spells_Exit = 3

		If previousState != ""
			FollowerMenu.XFL_MessageMod_Back = 1
		EndIf
		
		int ret = FollowerSpells.Show()
		If ret == Spells_Teach
			isForget = false
			XFL_TriggerMenu(followerActor, FollowerMenu.GetMenuState("SubMenuSpellSelect"), GetState(), page)
		Elseif ret == Spells_Forget
			isForget = true
			XFL_TriggerMenu(followerActor, FollowerMenu.GetMenuState("SubMenuSpellSelect"), GetState(), page)
		Elseif ret == Spells_Back
			FollowerMenu.XFL_TriggerMenu(followerActor, FollowerMenu.GetMenuState("PluginMenu"), FollowerMenu.GetParentState("PluginMenu"), page) ; Force a back all the way to the plugin menu
		Elseif ret == Spells_Exit
			FollowerMenu.OnFinishMenu()
		Endif
		
		GoToState("")
	EndFunction
EndState

State SubMenuSpellSelect_Classic
	Function activateSubMenu(Actor followerActor, string previousState = "", int page = 0)
		int SpellSelect_Back = 2
		int SpellSelect_Exit = 3

		If previousState != ""
			FollowerMenu.XFL_MessageMod_Back = 1
		EndIf
		
		Actor actorRef = None
		If !isGroup
			actorRef = followerActor
		Endif

		int ret = FollowerSpellSelect.Show()
		If ret < SpellSelect_Back
			;XFL_TeachSpell(Game.GetPlayer(), followerActor, ret, isForget)
			FollowerMenu.OnFinishMenu()
			XFLMain.XFL_SendActionEvent(GetIdentifier(), isForget as Int, Game.GetPlayer(), actorRef, ret)
		Elseif ret == SpellSelect_Back
			XFL_TriggerMenu(followerActor, FollowerMenu.GetMenuState("SubMenuSpells"), FollowerMenu.GetMenuState("PluginMenu"), page)
		Elseif ret == SpellSelect_Exit
			FollowerMenu.OnFinishMenu()
		Endif
		
		GoToState("")
	EndFunction
EndState

; for Greybeard effect
VisualEffect Property FXGreybeardAbsorbEffect Auto
EffectShader Property GreybeardPowerAbsorbFXS Auto
EffectShader Property GreybeardPlayerPowerAbsorbFXS Auto
sound property NPCDragonDeathSequenceWind auto
sound property NPCDragonDeathSequenceExplosion auto

; use this for Greybeards
Function AbsorbEffect(Actor teacher, Actor student)
	;Play art and fx shaders on player and targeted grybeard
	FXGreybeardAbsorbEffect.Play(teacher, 7, student)
	GreybeardPowerAbsorbFXS.Play(teacher, 7)
	GreybeardPlayerPowerAbsorbFXS.Play(student, 7)
	; Sounds for when the wispy particles being to fly at the player.
	NPCDragonDeathSequenceWind.play(teacher) 
	NPCDragonDeathSequenceExplosion.play(teacher) 
EndFunction