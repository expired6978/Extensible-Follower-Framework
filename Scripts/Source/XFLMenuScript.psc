Scriptname XFLMenuScript extends Quest  Conditional

XFLScript Property XFLMain Auto

FormList Property XFL_FollowerPlugins Auto

GlobalVariable Property XFL_FollowerCountEx Auto

ObjectReference Property FollowerMenuContainer Auto
ObjectReference Property FollowerMenuOption_None Auto
MiscObject Property FollowerMenuObject Auto

ReferenceAlias[] Property XFL_FollowerMenuAliases Auto

Perk Property CommandFollower Auto
Actor Property XFL_Player Auto
Spell Property XFL_SlowTime Auto

ReferenceAlias Property XFL_Placeholder Auto

Message Property XFL_MessageCommands Auto
Message Property XFL_MessageCommand Auto
Message Property XFL_MessageGroupCommands Auto
Message Property XFL_MessageFeatures Auto
Message Property XFL_MessageToggleFeatures Auto
Message Property XFL_MessageTogglePlugins Auto
Message Property XFL_MessagePlugins Auto
Message Property XFL_MessageSelectFollower Auto

Message Property XFL_MessageFeatureUseMenus Auto
Message Property XFL_MessageFeatureIgnoreTimeout Auto
Message Property XFL_MessageFeatureRideHorses Auto
Message Property XFL_MessageFeatureShowStats Auto

Message Property XFL_MessageStats_General Auto
Message Property XFL_MessageStats_Resistances Auto
Message Property XFL_MessageStats_Combat Auto
Message Property XFL_MessageStats_Skill Auto
Message Property XFL_MessageStats_Magic Auto

GlobalVariable Property XFL_Config_UseMenus Auto
GlobalVariable Property XFL_Config_IgnoreTimeout Auto
GlobalVariable Property XFL_Config_RideHorses Auto
GlobalVariable Property XFL_Config_ShowStats Auto

; Toggle Features
Bool Property XFL_MessageMod_Features_Enable Auto Conditional
Bool Property XFL_MessageMod_Features_Disable Auto Conditional
Bool Property XFL_MessageMod_Features_Help Auto Conditional

; Variables to enable/disable certain menu options
Bool Property XFL_MessageMod_Command Auto Conditional
Bool Property XFL_MessageMod_Wait Auto Conditional
Bool Property XFL_MessageMod_Follow Auto Conditional
Bool Property XFL_MessageMod_Dismiss Auto Conditional
Bool Property XFL_MessageMod_Back Auto Conditional
Bool Property XFL_MessageMod_Talk Auto Conditional
Bool Property XFL_MessageMod_Trade Auto Conditional
Bool Property XFL_MessageMod_Stats Auto Conditional
Bool Property XFL_MessageMod_Relax Auto Conditional
Bool Property XFL_MessageMod_More Auto Conditional
; Stats menu
Bool Property XFL_MessageMod_Stats_General Auto Conditional
Bool Property XFL_MessageMod_Stats_Resistances Auto Conditional
Bool Property XFL_MessageMod_Stats_Combat Auto Conditional
Bool Property XFL_MessageMod_Stats_Skill Auto Conditional
Bool Property XFL_MessageMod_Stats_Magic Auto Conditional

Bool Property XFL_MessageMod_Plugin_0 Auto Conditional
Bool Property XFL_MessageMod_Plugin_1 Auto Conditional
Bool Property XFL_MessageMod_Plugin_2 Auto Conditional
Bool Property XFL_MessageMod_Plugin_3 Auto Conditional
Bool Property XFL_MessageMod_Plugin_4 Auto Conditional
Bool Property XFL_MessageMod_Plugin_5 Auto Conditional
Bool Property XFL_MessageMod_Plugin_6 Auto Conditional
Bool Property XFL_MessageMod_Next Auto Conditional

string branchState = ""

Event OnInit()
	Game.GetPlayer().AddPerk(CommandFollower)
	FollowerMenuOption_None = XFL_RegisterMenuOption(FollowerMenuObject) ; Dummy plugin to be used as a reference
EndEvent


ObjectReference Function XFL_RegisterMenuOption(MiscObject miscObj)
	ObjectReference temp = FollowerMenuContainer.PlaceAtMe(miscObj, 1, true)
	FollowerMenuContainer.AddItem(temp)
	return temp
EndFunction

Function XFL_ShowOptionByAlias(ReferenceAlias refAlias, bool enabled)
	If refAlias == XFL_FollowerMenuAliases[0]
		XFL_MessageMod_Plugin_0 = enabled
	Elseif refAlias == XFL_FollowerMenuAliases[1]
		XFL_MessageMod_Plugin_1 = enabled
	Elseif refAlias == XFL_FollowerMenuAliases[2]
		XFL_MessageMod_Plugin_2 = enabled
	Elseif refAlias == XFL_FollowerMenuAliases[3]
		XFL_MessageMod_Plugin_3 = enabled
	Elseif refAlias == XFL_FollowerMenuAliases[4]
		XFL_MessageMod_Plugin_4 = enabled
	Elseif refAlias == XFL_FollowerMenuAliases[5]
		XFL_MessageMod_Plugin_5 = enabled
	Elseif refAlias == XFL_FollowerMenuAliases[6]
		XFL_MessageMod_Plugin_6 = enabled
	EndIf
EndFunction

int Function XFL_Features()
	Int Features_UseMenus = 0
	Int Features_IgnoreTimeout = 1
	Int Features_RideHorses = 2
	Int Features_ShowStats = 3
	Int Features_Plugins = 4
	Int Features_Exit = 5
	
	int ret = XFL_MessageFeatures.Show(XFL_Config_UseMenus.value, XFL_Config_IgnoreTimeout.value, XFL_Config_RideHorses.value, XFL_Config_ShowStats.value)
	If ret == Features_UseMenus
		XFL_ToggleFeature(XFL_Config_UseMenus, XFL_MessageFeatureUseMenus)
	Elseif ret == Features_IgnoreTimeout
		XFL_ToggleFeature(XFL_Config_IgnoreTimeout, XFL_MessageFeatureIgnoreTimeout)
	Elseif ret == Features_RideHorses
		XFL_ToggleFeature(XFL_Config_RideHorses, XFL_MessageFeatureRideHorses)
	Elseif ret == Features_ShowStats
		XFL_ToggleFeature(XFL_Config_ShowStats, XFL_MessageFeatureShowStats)
	Elseif ret == Features_Plugins
		XFL_TogglePlugins()
	Elseif ret == Features_Exit
		; Do nothing
	EndIf
	return ret
EndFunction

int Function XFL_ToggleFeature(GlobalVariable globalVar, Message help = None)
	Int Toggle_Features_Enable = 0
	Int Toggle_Features_Disable = 1
	Int Toggle_Features_Help = 2
	Int Toggle_Features_Back = 3
	
	If globalVar.GetValueInt() == 0
		XFL_MessageMod_Features_Enable = 1
		XFL_MessageMod_Features_Disable = 0
	Elseif globalVar.GetValueInt() == 1
		XFL_MessageMod_Features_Enable = 0
		XFL_MessageMod_Features_Disable = 1
	Else ; Not a boolean value, enable both to set to 1 or 0
		XFL_MessageMod_Features_Enable = 1
		XFL_MessageMod_Features_Disable = 1
	EndIf
	
	If help == None
		XFL_MessageMod_Features_Help = 0
	Else
		XFL_MessageMod_Features_Help = 1
	EndIf

	int ret = XFL_MessageToggleFeatures.Show()
	If ret == Toggle_Features_Enable
		globalVar.SetValue(1)
		XFL_ToggleFeature(globalVar, help)
	Elseif ret == Toggle_Features_Disable
		globalVar.SetValue(0)
		XFL_ToggleFeature(globalVar, help)
	Elseif ret == Toggle_Features_Back
		XFL_Features()
	Elseif ret == Toggle_Features_Help
		help.Show()
		XFL_ToggleFeature(globalVar, help)
	EndIf
	return ret
EndFunction


Function XFL_TogglePlugins(int page = 0)
	Int Command_Plugin_Back = 7
	Int Command_Plugin_Next = 8
	Int Command_Plugin_Exit = 9
	
	XFL_MessageMod_Back = 1
	
	Int[] pluginStatus = new Int[7] ; Store which Plugin Status corresponds to which Menu index
	Int[] pluginIndex = new Int[7] ; Store which Plugin Index corresponds to which Menu index
			
	int ret = 0
	While ret != Command_Plugin_Exit

		int totalPlugins = XFL_FollowerPlugins.GetSize()
		int i = 0
		While i < totalPlugins ; Subtract disabled or hidden plugins
			XFLPlugin plugin = (XFL_FollowerPlugins.GetAt((page * 7) + i) As XFLPlugin)
			If !plugin
				totalPlugins -= 1
			Endif
			i += 1
		EndWhile
	
		; If there are more mods then what are displayed
		If totalPlugins > (page + 1) * 7
			XFL_MessageMod_Next = 1
		Else
			XFL_MessageMod_Next = 0
		EndIf

		; Setup plugin menu options
		i = 0
		int itemIndex = page
		While i < XFL_FollowerMenuAliases.Length
			bool incrementAlias = true
			If XFL_FollowerPlugins.GetSize() > (page * 7) + itemIndex ; Check if there are still more mods to process
				XFLPlugin plugin = (XFL_FollowerPlugins.GetAt((page * 7) + itemIndex) As XFLPlugin)
				If plugin
					XFL_FollowerMenuAliases[i].ForceRefTo(plugin.MenuRef) ; Force the Menu Object into the menu alias for text replacement
					XFL_ShowOptionByAlias(XFL_FollowerMenuAliases[i], true)
					pluginStatus[i] = plugin.isEnabled() as Int
					pluginIndex[i] = (page * 7) + itemIndex
				Else
					incrementAlias = false ; Skip the item and stay on this alias
				EndIf
			Else
				XFL_FollowerMenuAliases[i].ForceRefTo(FollowerMenuOption_None) ; Reaching end of list, rest of the aliases are empty
				XFL_ShowOptionByAlias(XFL_FollowerMenuAliases[i], false)
				pluginStatus[i] = 0
				pluginIndex[i] = -1
			EndIf
			If incrementAlias
				i += 1
			EndIf
			itemIndex += 1
		EndWhile
			
		ret = XFL_MessageTogglePlugins.Show(pluginStatus[0], pluginStatus[1], pluginStatus[2], pluginStatus[3], pluginStatus[4], pluginStatus[5], pluginStatus[6], page + 1)
		
		If ret < Command_Plugin_Back ; Activate the correct menu
			XFLPlugin plugin = (XFL_FollowerPlugins.GetAt(pluginIndex[ret]) as XFLPlugin)
			If plugin
				If plugin.enabledVar.value
					plugin.enabledVar.value = 0
					plugin.onDisabled()
				Else
					plugin.enabledVar.value = 1
					plugin.onEnabled()
				Endif
			EndIf
			;ret = Command_Plugin_Exit ; Discontinue menu loop
		Elseif ret == Command_Plugin_Back
			If page == 0
				XFL_Features()
				ret = Command_Plugin_Exit ; Discontinue menu loop
			Else
				page -= 1
			EndIf
		Elseif ret == Command_Plugin_Next
			XFL_MessageMod_Back = 1 ; We have previous pages
			page += 1
		Elseif ret == Command_Plugin_Exit
			; Do nothing this is shown during a book
		EndIf
	EndWhile
	
	XFL_MessageMod_Plugin_0 = 0
	XFL_MessageMod_Plugin_1 = 0
	XFL_MessageMod_Plugin_2 = 0
	XFL_MessageMod_Plugin_3 = 0
	XFL_MessageMod_Plugin_4 = 0
	XFL_MessageMod_Plugin_5 = 0
	XFL_MessageMod_Plugin_6 = 0
	XFL_MessageMod_Next = 0
	XFL_MessageMod_Back = 0
EndFunction

Actor Function XFL_SelectFollower(int page = 0, bool showPlayer = false)
	Int Command_Plugin_Back = 7
	Int Command_Plugin_Next = 8
	Int Command_Plugin_Exit = 9
	
	If page > 0
		XFL_MessageMod_Back = 1
	Else
		XFL_MessageMod_Back = 0
	EndIf
	
	Actor foundFollower = None
				
	int ret = 0
	While ret != Command_Plugin_Exit
		Int totalFollowers = XFLMain.XFL_GetMaximum() + 1 ; Maximum is an index not a count, adjust
		If showPlayer
			totalFollowers += 1
		Endif
	
		; If there are more followers then what are displayed
		If totalFollowers > (page + 1) * 7
			XFL_MessageMod_Next = 1
		Else
			XFL_MessageMod_Next = 0
		EndIf
		
		; Setup plugin menu options
		int i = 0
		
		; Add the player to the first of the list
		If showPlayer && page == 0
			XFL_FollowerMenuAliases[i].ForceRefTo(Game.GetPlayer()) ; Force the Menu Object into the menu alias for text replacement
			XFL_ShowOptionByAlias(XFL_FollowerMenuAliases[i], true)
			i += 1
		Endif
		
		int itemIndex = 0
		While i < XFL_FollowerMenuAliases.Length
			bool incRow = true
			If totalFollowers >= (page * 7) + itemIndex ; Check if there are still more followers to process
				Actor follower = XFLMain.XFL_FollowerAliases[((page * 7) + itemIndex)].GetReference() as Actor
				If follower
					XFL_FollowerMenuAliases[i].ForceRefTo(follower) ; Force the follower into the menu alias for text replacement
					XFL_ShowOptionByAlias(XFL_FollowerMenuAliases[i], true)
				Else ; Empty alias, next
					incRow = false
				Endif
			Else
				XFL_FollowerMenuAliases[i].ForceRefTo(FollowerMenuOption_None) ; Reaching end of list, rest of the aliases are empty
				XFL_ShowOptionByAlias(XFL_FollowerMenuAliases[i], false)
			EndIf
			If incRow
				i += 1
			EndIf
			itemIndex += 1
		EndWhile
			
		ret = XFL_MessageSelectFollower.Show(page + 1)
		If ret < Command_Plugin_Back ; Activate the correct menu
			Actor follower = XFL_FollowerMenuAliases[ret].GetActorRef()
			If follower
				foundFollower = follower
			EndIf
			ret = Command_Plugin_Exit ; Discontinue menu loop
		Elseif ret == Command_Plugin_Back
			page -= 1
			If page == 0 ; We're returning to the first page of the menu, but we had no previous menu
				XFL_MessageMod_Back = 0
			EndIf
		Elseif ret == Command_Plugin_Next
			XFL_MessageMod_Back = 1 ; We have previous pages
			page += 1
		Elseif ret == Command_Plugin_Exit
			; Do nothing, end after this returns
		EndIf
	EndWhile
	
	XFL_MessageMod_Plugin_0 = 0
	XFL_MessageMod_Plugin_1 = 0
	XFL_MessageMod_Plugin_2 = 0
	XFL_MessageMod_Plugin_3 = 0
	XFL_MessageMod_Plugin_4 = 0
	XFL_MessageMod_Plugin_5 = 0
	XFL_MessageMod_Plugin_6 = 0
	XFL_MessageMod_Next = 0
	XFL_MessageMod_Back = 0
	return foundFollower
EndFunction

; Trigger standalone menus
Function XFL_FollowerMenu(Actor followerActor)
	OnStartMenu()
	XFL_TriggerMenu(followerActor, "FollowerMenu")
EndFunction

Function XFL_CommandFollower(Actor followerActor)
	OnStartMenu()
	XFL_TriggerMenu(followerActor, "CommandMenu")
EndFunction

Function XFL_CommandGroup(Actor followerActor = None)
	OnStartMenu()
	XFL_TriggerMenu(followerActor, "GroupMenu")
EndFunction

Function XFL_Stats(Actor followerActor)
	XFL_TriggerMenu(followerActor, "StatsMenu")
EndFunction

Function XFL_Plugins(Actor followerActor)
	XFL_TriggerMenu(followerActor, "PluginMenu")
EndFunction

Function XFL_TriggerMenu(Actor followerActor, string menuState = "", string previousState = "", int page = 0)
	GoToState(menuState)
	activateMenu(followerActor, previousState, page)
EndFunction

Function activateMenu(Actor followerActor = None, string previousState = "", int page = 0)
	; Do nothing while not in the empty state
EndFunction

Function deactivateMenu()
	; Do nothing
EndFunction

string Function GetParentState(string menuState = "")
	If menuState == "PluginMenu"
		return branchState
	Elseif menuState == "StatsMenu"
		return "CommandMenu"
	Elseif menuState == "FollowerMenu"
		return ""
	Elseif menuState == "GroupMenu"
		return "FollowerMenu"
	Elseif menuState == "CommandMenu"
		return "FollowerMenu"
	Else
		return ""
	Endif
EndFunction

State FollowerMenu
	Function activateMenu(Actor followerActor = None, string previousState = "", int page = 0)
		Int Command_Group = 0
		Int Command_Command = 1
		Int Command_Talk = 2
		Int Command_Exit = 3
					
		XFL_Placeholder.ForceRefTo(followerActor)

		If followerActor
			XFL_MessageMod_Command = 1 ; Show Command
			XFL_MessageMod_Talk = 1 ; Show Talk
		Else ; We have no follower reference for some reason, hide all options except for group
			XFL_MessageMod_Command = 0
			XFL_MessageMod_Talk = 0
		EndIf
		
		int ret = XFL_MessageCommands.Show()
		If ret == Command_Group ; Group Menu
			XFL_TriggerMenu(followerActor, "GroupMenu", GetState())
		Elseif ret == Command_Command ; Command Menu
			XFL_TriggerMenu(followerActor, "CommandMenu", GetState())
		Elseif ret == Command_Talk ; Talk
			followerActor.Activate(Game.GetPlayer(), true)
			OnFinishMenu()
		Elseif ret == Command_Exit ; Exit
			OnFinishMenu()
		EndIf
		
		deactivateMenu()
	EndFunction
	
	Function deactivateMenu()
		XFL_MessageMod_Command = 0
		XFL_MessageMod_Talk = 0
		
		XFL_Placeholder.Clear()
		
		GoToState("")
	EndFunction
EndState

State CommandMenu
	Function activateMenu(Actor followerActor = None, string previousState = "", int page = 0)
		Int Command_Wait = 0
		Int Command_Follow = 1
		Int Command_Dismiss = 2
		Int Command_Relax = 3
		Int Command_Trade = 4
		Int Command_Stats = 5
		Int Command_More = 6
		Int Command_Back = 7
		Int Command_Exit = 8
			
		XFL_Placeholder.ForceRefTo(followerActor)
		
		branchState = GetState()

		If followerActor
			float waiting = followerActor.GetAv("WaitingForPlayer")
			If waiting == 0 ; Not waiting for player
				XFL_MessageMod_Follow = 0 ; Hide Follow
				XFL_MessageMod_Wait = 1 ; Show Wait
				XFL_MessageMod_Relax = 1 ; Show Relax
			Elseif waiting == 1 ; Waiting for player
				XFL_MessageMod_Wait = 0 ; Hide Wait
				XFL_MessageMod_Follow = 1 ; Show Follow
				XFL_MessageMod_Relax = 1 ; Show Relax
			Elseif waiting == 2 ; Relaxing
				XFL_MessageMod_Wait = 1 ; Show Wait
				XFL_MessageMod_Follow = 1 ; Show Follow
				XFL_MessageMod_Relax = 0 ; Hide Relax
			Else ; Waiting state neither of these three, show all
				XFL_MessageMod_Wait = 1 ; Show Wait
				XFL_MessageMod_Follow = 1 ; Show Follow
				XFL_MessageMod_Relax = 1 ; Show Relax
			EndIf
			XFL_MessageMod_Dismiss = 1 ; Show dismiss
			XFL_MessageMod_Trade = 1 ; Show Trade
			XFL_MessageMod_Stats = 1 ; Show Stats
			If XFL_FollowerPlugins.GetSize() > 0
				XFL_MessageMod_More = 1 ; We have loaded plugins show the plugin menu
			Else
				XFL_MessageMod_More = 0
			Endif
		Else ; We have no follower reference for some reason, hide all options except for group
			XFL_MessageMod_Trade = 0
			XFL_MessageMod_Wait = 0
			XFL_MessageMod_Follow = 0
			XFL_MessageMod_Dismiss = 0
			XFL_MessageMod_Stats = 0
			XFL_MessageMod_More = 0
		EndIf
		
		If previousState != ""
			XFL_MessageMod_Back = 1
		EndIf

		int ret = XFL_MessageCommand.Show()
		If ret == Command_Wait ; Wait
			XFLMain.XFL_SetWait(followerActor)
			OnFinishMenu()
		Elseif ret == Command_Follow ; Follow
			XFLMain.XFL_SetFollow(followerActor)
			OnFinishMenu()
		Elseif ret == Command_Dismiss ; Dismiss
			XFLMain.XFL_RemoveFollower(followerActor)
			OnFinishMenu()
		Elseif ret == Command_Relax ; Relax
			XFLMain.XFL_SetSandbox(followerActor)
			OnFinishMenu()
		Elseif ret == Command_Trade ; Trade
			followerActor.OpenInventory()
			OnFinishMenu()
		Elseif ret == Command_Stats ; Stats
			XFL_TriggerMenu(followerActor, "StatsMenu", GetState())
		Elseif ret == Command_More ; More
			XFL_TriggerMenu(followerActor, "PluginMenu", GetState())
		Elseif ret == Command_Back ; Back
			XFL_TriggerMenu(followerActor, previousState)
		Elseif ret == Command_Exit ; Exit
			OnFinishMenu()
		EndIf
		
		deactivateMenu()
	EndFunction
	
	Function deactivateMenu()
		XFL_MessageMod_Trade = 0
		XFL_MessageMod_Wait = 0
		XFL_MessageMod_Follow = 0
		XFL_MessageMod_Dismiss = 0
		XFL_MessageMod_Stats = 0
		XFL_MessageMod_Back = 0
		XFL_MessageMod_More = 0
		XFL_Placeholder.Clear()
		GoToState("")
	EndFunction
EndState

State GroupMenu
	Function activateMenu(Actor followerActor = None, string previousState = "", int page = 0)
		Int Command_Group_Wait = 0
		Int Command_Group_Follow = 1
		Int Command_Group_Dismiss = 2
		Int Command_Group_Relax = 3
		Int Command_Group_More = 4
		Int Command_Group_Back = 5
		Int Command_Group_Exit = 6
		
		XFL_MessageMod_Wait = 1 ; Enable both follow and wait as both may be possible
		XFL_MessageMod_Follow = 1
		XFL_MessageMod_Dismiss = 1
		XFL_MessageMod_Relax = 1
		
		branchState = GetState()
		
		If previousState != "" && followerActor
			XFL_MessageMod_Back = 1
		Else
			XFL_MessageMod_Back = 0
		EndIf
		
		If XFL_FollowerPlugins.GetSize() > 0
			XFL_MessageMod_More = 1 ; We have loaded plugins show the plugin menu
		Else
			XFL_MessageMod_More = 0
		Endif
		
		int ret = XFL_MessageGroupCommands.Show(XFL_FollowerCountEx.GetValue())
		If ret == Command_Group_Wait ; Group Wait
			XFLMain.XFL_WaitAll()
			OnFinishMenu()
		Elseif ret == Command_Group_Follow ; Group Follow
			XFLMain.XFL_FollowAll()
			OnFinishMenu()
		Elseif ret == Command_Group_Dismiss ; Group Dismiss
			XFLMain.XFL_RemoveAll()
			OnFinishMenu()
		Elseif ret == Command_Group_Relax ; Group Relax
			XFLMain.XFL_SandboxAll()
			OnFinishMenu()
		Elseif ret == Command_Group_More ; Group Plugins
			XFL_TriggerMenu(followerActor, "PluginMenu", GetState())
		Elseif ret == Command_Group_Back ; Group Back
			XFL_TriggerMenu(followerActor, previousState, GetParentState(previousState))
		Elseif ret == Command_Group_Exit ; Exit Group Menu
			OnFinishMenu()
		EndIf
		
		deactivateMenu()
	EndFunction
	
	Function deactivateMenu()
		XFL_MessageMod_Wait = 1
		XFL_MessageMod_Follow = 1
		XFL_MessageMod_Dismiss = 1
		XFL_MessageMod_Relax = 1
		XFL_MessageMod_Back = 0
		GoToState("")
	EndFunction
EndState

State StatsMenu
	Function activateMenu(Actor followerActor = None, string previousState = "", int page = 0)
		Int Command_Stats_General = 0
		Int Command_Stats_Resistances = 1
		Int Command_Stats_Combat = 2
		Int Command_Stats_Skill = 3
		Int Command_Stats_Magic = 4
		Int Command_Stats_Back = 5
		Int Command_Stats_Exit = 6
		
		XFL_Placeholder.ForceRefTo(followerActor)
		
		If previousState != ""
			XFL_MessageMod_Back = 1
		EndIf
		
		int ret = 0
		If followerActor
			While ret != Command_Stats_Exit && ret != Command_Stats_Back
				XFL_MessageMod_Stats_General = 1
				XFL_MessageMod_Stats_Resistances = 1
				XFL_MessageMod_Stats_Combat = 1
				XFL_MessageMod_Stats_Skill = 1
				XFL_MessageMod_Stats_Magic = 1
				If ret == Command_Stats_General
					XFL_MessageMod_Stats_General = 0
					ret = XFL_MessageStats_General.Show(followerActor.GetLevel(), \
														followerActor.GetActorValue("Health"), \
														followerActor.GetActorValue("Magicka"), \
														followerActor.GetActorValue("Stamina"), \
														followerActor.GetActorValue("HealRateMult"), \
														followerActor.GetActorValue("MagickaRateMult"), \
														followerActor.GetActorValue("StaminaRateMult"), \
														followerActor.GetActorValue("DamageResist"))
				Elseif ret == Command_Stats_Resistances
					XFL_MessageMod_Stats_Resistances = 0
					ret = XFL_MessageStats_Resistances.Show(followerActor.GetActorValue("DiseaseResist"), \
														followerActor.GetActorValue("ElectricResist"), \
														followerActor.GetActorValue("FireResist"), \
														followerActor.GetActorValue("FrostResist"), \
														followerActor.GetActorValue("PoisonResist"), \
														followerActor.GetActorValue("MagicResist"))
				Elseif ret == Command_Stats_Combat
					XFL_MessageMod_Stats_Combat = 0
					ret = XFL_MessageStats_Combat.Show(followerActor.GetActorValue("OneHanded"), \
														followerActor.GetActorValue("TwoHanded"), \
														followerActor.GetActorValue("Marksman"), \
														followerActor.GetActorValue("Block"), \
														followerActor.GetActorValue("HeavyArmor"), \
														followerActor.GetActorValue("LightArmor"), \
														followerActor.GetActorValue("Sneak"))
				Elseif ret == Command_Stats_Skill
					XFL_MessageMod_Stats_Skill = 0
					ret = XFL_MessageStats_Skill.Show(followerActor.GetActorValue("Alchemy"), \
													followerActor.GetActorValue("Enchanting"), \
													followerActor.GetActorValue("Smithing"), \
													followerActor.GetActorValue("Lockpicking"), \
													followerActor.GetActorValue("Pickpocket"), \
													followerActor.GetActorValue("Speechcraft"))
				Elseif ret == Command_Stats_Magic
					XFL_MessageMod_Stats_Magic = 0
					ret = XFL_MessageStats_Magic.Show(followerActor.GetActorValue("Alteration"), \
													followerActor.GetActorValue("Conjuration"), \
													followerActor.GetActorValue("Destruction"), \
													followerActor.GetActorValue("Illusion"), \
													followerActor.GetActorValue("Restoration"))
				Endif
			EndWhile
		EndIf
		
		If ret == Command_Stats_Back
			XFL_TriggerMenu(followerActor, previousState, GetParentState(previousState)) ; Third level menu, need parent of parent
		Elseif ret == Command_Stats_Exit
			OnFinishMenu()
		Endif
		
		deactivateMenu()
	EndFunction
	
	Function deactivateMenu()
		XFL_MessageMod_Stats_General = 0
		XFL_MessageMod_Stats_Combat = 0
		XFL_MessageMod_Stats_Skill = 0
		XFL_MessageMod_Stats_Magic = 0
		XFL_MessageMod_Back = 0
		XFL_Placeholder.Clear()
		GoToState("")
	EndFunction
EndState

State PluginMenu
	Function activateMenu(Actor followerActor = None, string previousState = "", int page = 0)
		Int Command_Plugin_Back = 7
		Int Command_Plugin_Next = 8
		Int Command_Plugin_Exit = 9
		
		If previousState != "" || page > 0
			XFL_MessageMod_Back = 1
		EndIf
		
		bool isGroup = (previousState == "GroupMenu")
		
		Int[] pluginIndex = new Int[7] ; Store which Plugin Index corresponds to which Menu index
				
		int ret = 0
		While ret != Command_Plugin_Exit
			int totalPlugins = XFL_FollowerPlugins.GetSize()
			int i = 0
			While i < totalPlugins ; Subtract disabled or hidden plugins
				XFLPlugin plugin = (XFL_FollowerPlugins.GetAt((page * 7) + i) As XFLPlugin)
				If plugin && (!plugin.isEnabled() || ((!isGroup && !plugin.showMenu(followerActor)) || (isGroup && !plugin.showGroupMenu())))
					totalPlugins -= 1
				Elseif !plugin
					totalPlugins -= 1
				Endif
				i += 1
			EndWhile

			; If there are more mods then what are displayed
			If totalPlugins > (page + 1) * 7
				XFL_MessageMod_Next = 1
			Else
				XFL_MessageMod_Next = 0
			EndIf
			
			; Setup plugin menu options
			i = 0
			int itemIndex = 0
			While i < XFL_FollowerMenuAliases.Length
				bool incrementAlias = true
				If XFL_FollowerPlugins.GetSize() > (page * 7) + itemIndex ; Check if there are still more mods to process
					XFLPlugin plugin = (XFL_FollowerPlugins.GetAt((page * 7) + itemIndex) As XFLPlugin)
					If plugin && plugin.isEnabled() && ((!isGroup && plugin.showMenu(followerActor)) || (isGroup && plugin.showGroupMenu()))
						XFL_FollowerMenuAliases[i].ForceRefTo(plugin.MenuRef) ; Force the Menu Object into the menu alias for text replacement
						XFL_ShowOptionByAlias(XFL_FollowerMenuAliases[i], true)
						pluginIndex[i] = (page * 7) + itemIndex
					Else
						incrementAlias = false ; Skip the item and stay on this alias
					EndIf
				Else
					XFL_FollowerMenuAliases[i].ForceRefTo(FollowerMenuOption_None) ; Reaching end of list, rest of the aliases are empty
					XFL_ShowOptionByAlias(XFL_FollowerMenuAliases[i], false)
					pluginIndex[i] = -1
				EndIf
				If incrementAlias
					i += 1
				EndIf
				itemIndex += 1
			EndWhile
				
			ret = XFL_MessagePlugins.Show(page + 1)
			
			If ret < Command_Plugin_Back ; Activate the correct menu
				XFLPlugin plugin = (XFL_FollowerPlugins.GetAt(pluginIndex[ret]) as XFLPlugin)
				If plugin
					If isGroup
						plugin.activateGroupMenu(page, followerActor)
					Else
						plugin.activateMenu(page, followerActor)
					Endif
				EndIf
				ret = Command_Plugin_Exit ; Discontinue menu loop
			Elseif ret == Command_Plugin_Back
				If page == 0
					XFL_TriggerMenu(followerActor, previousState, GetParentState(previousState)) ; Third level menu, need parent of parent
					ret = Command_Plugin_Exit ; Discontinue menu loop
				Else
					page -= 1
					
					If page == 0 && previousState == "" ; We're returning to the first page of the menu, but we had no previous menu
						XFL_MessageMod_Back = 0
					EndIf
				EndIf
			Elseif ret == Command_Plugin_Next
				XFL_MessageMod_Back = 1 ; We have previous pages
				page += 1
			Elseif ret == Command_Plugin_Exit
				OnFinishMenu()
			EndIf
		EndWhile
		
		deactivateMenu()
	EndFunction
	
	Function deactivateMenu()
		XFL_MessageMod_Plugin_0 = 0
		XFL_MessageMod_Plugin_1 = 0
		XFL_MessageMod_Plugin_2 = 0
		XFL_MessageMod_Plugin_3 = 0
		XFL_MessageMod_Plugin_4 = 0
		XFL_MessageMod_Plugin_5 = 0
		XFL_MessageMod_Plugin_6 = 0
		XFL_MessageMod_Next = 0
		XFL_MessageMod_Back = 0
		GoToState("")
	EndFunction
EndState

Event OnStartMenu()
	XFL_Player.DoCombatSpellApply(XFL_SlowTime, XFL_Player)
EndEvent

Event OnFinishMenu()
	XFL_Player.DispelSpell(XFL_SlowTime)
EndEvent

; Menu Extensions
Function XFL_OpenSelectionMenu()
	If XFLMain.SKSEExtended == false
		Debug.Trace("EFF WARNING: This feature requires SKSE.")
		return
	Endif
	XFLSelectionMenu selectionMenu = (Game.GetFormFromFile(0xE00, "XFLMenus.esp") as XFLSelectionMenu)
	selectionMenu.SetMode(1) ; Mode is multi-selection
	selectionMenu.OpenMenu(XFLMain.XFL_FollowerList, Self)
EndFunction

int Function XFL_OpenFollowerMenu(Actor follower)
	If XFLMain.SKSEExtended == false
		Debug.Trace("EFF WARNING: This feature requires SKSE.")
		return -1
	Endif
	XFLWheel wheelMenu = (Game.GetFormFromFile(0xE01, "XFLMenus.esp") as XFLWheel)
	wheelMenu.ClearMenu()
	wheelMenu.SetupMainMenu()
	return wheelMenu.OpenMenu(follower)
EndFunction

int Function XFL_OpenMagicMenu(Actor follower)
	If XFLMain.SKSEExtended == false
		Debug.Trace("EFF WARNING: This feature requires SKSE.")
		return -1
	Endif
	XFLMagicMenu magicMenu = (Game.GetFormFromFile(0xE02, "XFLMenus.esp") as XFLMagicMenu)
	return magicMenu.OpenMenu(follower)
EndFunction

int Function XFL_OpenStatsMenu(Form inForm)
	If XFLMain.SKSEExtended == false
		Debug.Trace("EFF WARNING: This feature requires SKSE.")
		return -1
	Endif
	XFLStatsMenu statsMenu = (Game.GetFormFromFile(0xE03, "XFLMenus.esp") as XFLStatsMenu)
	return statsMenu.OpenMenu(inForm)
EndFunction

Event OnSelectForm(string eventName, string strArg, float numArg, Form sender)
	if sender
		Form selection = (sender as XFLSelectionMenu).GetSelection()
		XFL_OpenStatsMenu(selection)
		; if (selection as FormList)
		; 	int size = (selection as FormList).GetSize()
		; 	int i = 0
		; 	Debug.Trace("Length: " + size)
		; 	While i < size
		; 		Debug.Trace("Multi Selected: " + (selection as FormList).GetAt(i))
		; 		i += 1
		; 	EndWhile
		; elseif selection != None
		; 	Debug.Trace("Single Selected: " + selection)
		; endif
	Endif
EndEvent

Event OnExtendedMenu(int result, Form receiver)
	bool isGroup = false
	int size = 0
	If (receiver as Actor)
		isGroup = false
		size = 1
	Elseif (receiver as FormList)
		isGroup = true
		size = (receiver as FormList).GetSize()
	Endif


	If result == 0 ; Wait
		XFLMain.XFL_WaitList(receiver)
	Elseif result == 1 ; Trade - Cannot trade while in group select
		If !isGroup
			(receiver as Actor).OpenInventory()
		Endif
	Elseif result == 2 ; Aggressive

	Elseif result == 3 ; More

	Elseif result == 4 ; Relax
		XFLMain.XFL_SandboxList(receiver)
	Elseif result == 5 ; Stats
		XFL_OpenStatsMenu(receiver)
	Elseif result == 6 ; Talk - Cannot talk while in group select
		If !isGroup
			(receiver as Actor).Activate(Game.GetPlayer(), true)
		Endif
	Elseif result == 7 ; Exit
		; Do nothing
	Endif
EndEvent