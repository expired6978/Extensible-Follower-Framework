Scriptname EFFPluginSpells extends EFFPlugin Conditional

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
Bool Function showMenu(Form akForm) ; Re-implement
	return true
EndFunction

; Determines whether to show the plugin in the group command menu
Bool Function showGroupMenu() ; Re-implement
	return true
EndFunction

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

Function activateMenu(int page, Form akForm) ; Re-implement
	isGroup = false
	XFL_TriggerMenu(akForm, FollowerMenu.GetMenuState("MenuSpells"), FollowerMenu.GetMenuState("PluginMenu"), page)
EndFunction

Function activateGroupMenu(int page, Form akForm) ; Re-implement
	; Do nothing
	isGroup = true
	XFL_TriggerMenu(akForm, FollowerMenu.GetMenuState("MenuSpells"), FollowerMenu.GetMenuState("PluginMenu"), page)
EndFunction

Function XFL_TriggerMenu(Form akForm, string menuState = "", string previousState = "", int page = 0)
	GoToState(menuState)
	activateSubMenu(akForm, previousState, page)
EndFunction

Function activateSubMenu(Form akForm, string previousState = "", int page = 0)
	; Do nothing in blank state
EndFunction

State MenuSpells_Classic
	Function activateSubMenu(Form akForm, string previousState = "", int page = 0)
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
			XFL_TriggerMenu(akForm, FollowerMenu.GetMenuState("SubMenuSpellSelect"), GetState(), page)
		Elseif ret == Spells_Forget
			isForget = true
			XFL_TriggerMenu(akForm, FollowerMenu.GetMenuState("SubMenuSpellSelect"), GetState(), page)
		Elseif ret == Spells_Back
			FollowerMenu.XFL_TriggerMenu(akForm, FollowerMenu.GetMenuState("PluginMenu"), FollowerMenu.GetParentState("PluginMenu"), page) ; Force a back all the way to the plugin menu
		Elseif ret == Spells_Exit
			FollowerMenu.OnFinishMenu()
		Endif
		
		GoToState("")
	EndFunction
EndState

State SubMenuSpellSelect_Classic
	Function activateSubMenu(Form akForm, string previousState = "", int page = 0)
		int SpellSelect_Back = 2
		int SpellSelect_Exit = 3

		If previousState != ""
			FollowerMenu.XFL_MessageMod_Back = 1
		EndIf
		
		Actor actorRef = None
		If !isGroup
			actorRef = akForm as Actor
		Endif

		int ret = FollowerSpellSelect.Show()
		If ret < SpellSelect_Back
			FollowerMenu.OnFinishMenu()
			XFLMain.XFL_SendActionEvent(GetIdentifier(), isForget as Int, Game.GetPlayer(), actorRef, ret)
		Elseif ret == SpellSelect_Back
			XFL_TriggerMenu(akForm, FollowerMenu.GetMenuState("SubMenuSpells"), FollowerMenu.GetMenuState("PluginMenu"), page)
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

; New menu system info
string[] Function GetMenuEntries(Form akForm)
	string[] entries = new string[7]
	int itemOffset = GetIdentifier() * 100
	entries[0] = GetPluginName() + ";;" + -1 + ";;" + GetIdentifier() + ";;" + 0 + ";;1"
	entries[1] = "$Teach" + ";;" + GetIdentifier() + ";;" + (itemOffset + 0) + ";;" + 0 + ";;1"
	entries[2] = "$Left Hand" + ";;" + (itemOffset + 0) + ";;" + (itemOffset + 10) + ";;" + 0 + ";;0"
	entries[3] = "$Right Hand" + ";;" + (itemOffset + 0) + ";;" + (itemOffset + 11) + ";;" + 1 + ";;0"

	entries[4] = "$Forget" + ";;" + GetIdentifier() + ";;" + (itemOffset + 1) + ";;" + 0 + ";;1"
	entries[5] = "$Left Hand" + ";;" + (itemOffset + 1) + ";;" + (itemOffset + 20) + ";;" + 0 + ";;0"
	entries[6] = "$Right Hand" + ";;" + (itemOffset + 1) + ";;" + (itemOffset + 21) + ";;" + 1 + ";;0"

	return entries
EndFunction

Event OnMenuEntryTriggered(Form akForm, int itemId, int callback)
	int category = itemId - GetIdentifier() * 100
	int subCategory = category / 10
	if subCategory == 1
		isForget = false
	Elseif subCategory == 2
		isForget = true
	Endif
	XFLMain.XFL_SendActionEvent(GetIdentifier(), isForget as Int, Game.GetPlayer(), akForm, callback)
EndEvent