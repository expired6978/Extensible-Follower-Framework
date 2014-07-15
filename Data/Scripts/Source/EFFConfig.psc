Scriptname EFFConfig extends SKI_ConfigBase

import Game
import Utility

; Option ID's
int _featUseMenus
int _featIgnoreTimeout
int _featRideHorses
int _featShowStats
int _featInvisibility
int _featAutoIdle
int[] _featPlugins
int _panelX
int _panelY
int _panelScale
int _panelEntryCount
int _panelFadeInDuration
int _panelFadeOutDuration
int _panelMoveDuration
int _panelRemoveDuration
int _panelAlpha
int _inventoryShow
int _inventorySet
int _inventoryReset
int _forceRecruit
int _clearSystem
int _fixActor

EFFMenuScript XFLMenu = None
EFFCore XFLMain = None

int _MaximumFollowers
int _DrawWeapon
int _SandboxRadius
int _FriendHitCombat
int _NumberActorsToFollow
int _NumberActorsInCombat
int _AllyHitNonCombat
int _AllyHitCombat
int _FollowSpace
int _FriendHitNonCombat
int _FollowSpaceAtDoor
int _StartSprintDist

; State Data
float	_fFollowStartSprintDistance			= -1.0
float 	_fAIDistanceTeammateDrawWeapon 		= -1.0
float 	_fSandboxSearchRadius 				= -1.0
int 	_iFriendHitCombatAllowed 			= -1
int 	_iNumberActorsAllowedToFollowPlayer = -1
int 	_iNumberActorsInCombatPlayer 		= -1
int 	_iAllyHitNonCombatAllowed 			= -1
int 	_iAllyHitCombatAllowed 				= -1
float 	_fFollowSpaceBetweenFollowers 		= -1.0
int 	_iFriendHitNonCombatAllowed 		= -1
float 	_fFollowerSpacingAtDoors 			= -1.0

float Property fAIDistanceTeammateDrawWeapon
	float Function Get()
		If _fAIDistanceTeammateDrawWeapon == -1.0
			return GetGameSettingFloat("fAIDistanceTeammateDrawWeapon")
		Endif
		return _fAIDistanceTeammateDrawWeapon
	EndFunction
	Function Set(float value)
		_fAIDistanceTeammateDrawWeapon = value
		SetGameSettingFloat("fAIDistanceTeammateDrawWeapon", value)
	EndFunction
EndProperty

float Property fSandboxSearchRadius
	float Function Get()
		If _fSandboxSearchRadius == -1.0
			return GetGameSettingFloat("fSandboxSearchRadius")
		Endif
		return _fSandboxSearchRadius
	EndFunction
	Function Set(float value)
		_fSandboxSearchRadius = value
		SetGameSettingFloat("fSandboxSearchRadius", value)
	EndFunction
EndProperty

int Property iFriendHitCombatAllowed
	int Function Get()
		If _iFriendHitCombatAllowed == -1
			return GetGameSettingInt("iFriendHitCombatAllowed")
		Endif
		return _iFriendHitCombatAllowed
	EndFunction
	Function Set(int value)
		_iFriendHitCombatAllowed = value
		SetGameSettingInt("iFriendHitCombatAllowed", value)
	EndFunction
EndProperty

int Property iNumberActorsAllowedToFollowPlayer
	int Function Get()
		If _iNumberActorsAllowedToFollowPlayer == -1
			return GetGameSettingInt("iNumberActorsAllowedToFollowPlayer")
		Endif
		return _iNumberActorsAllowedToFollowPlayer
	EndFunction
	Function Set(int value)
		_iNumberActorsAllowedToFollowPlayer = value
		SetGameSettingInt("iNumberActorsAllowedToFollowPlayer", value)
	EndFunction
EndProperty

int Property iNumberActorsInCombatPlayer
	int Function Get()
		If _iNumberActorsInCombatPlayer == -1
			return GetGameSettingInt("iNumberActorsInCombatPlayer")
		Endif
		return _iNumberActorsInCombatPlayer
	EndFunction
	Function Set(int value)
		_iNumberActorsInCombatPlayer = value
		SetGameSettingInt("iNumberActorsInCombatPlayer", value)
	EndFunction
EndProperty

int Property iAllyHitNonCombatAllowed
	int Function Get()
		If _iAllyHitNonCombatAllowed == -1
			return GetGameSettingInt("iAllyHitNonCombatAllowed")
		Endif
		return _iFriendHitCombatAllowed
	EndFunction
	Function Set(int value)
		_iAllyHitNonCombatAllowed = value
		SetGameSettingInt("iAllyHitNonCombatAllowed", value)
	EndFunction
EndProperty

int Property iAllyHitCombatAllowed
	int Function Get()
		If _iAllyHitCombatAllowed == -1
			return GetGameSettingInt("iAllyHitCombatAllowed")
		Endif
		return _iAllyHitCombatAllowed
	EndFunction
	Function Set(int value)
		_iAllyHitCombatAllowed = value
		SetGameSettingInt("iAllyHitCombatAllowed", value)
	EndFunction
EndProperty

int Property iFriendHitNonCombatAllowed
	int Function Get()
		If _iFriendHitNonCombatAllowed == -1
			return GetGameSettingInt("iFriendHitNonCombatAllowed")
		Endif
		return _iFriendHitNonCombatAllowed
	EndFunction
	Function Set(int value)
		_iFriendHitNonCombatAllowed = value
		SetGameSettingInt("iFriendHitNonCombatAllowed", value)
	EndFunction
EndProperty

float Property fFollowSpaceBetweenFollowers
	float Function Get()
		If _fFollowSpaceBetweenFollowers == -1.0
			return GetGameSettingFloat("fFollowSpaceBetweenFollowers")
		Endif
		return _fFollowSpaceBetweenFollowers
	EndFunction
	Function Set(float value)
		_fFollowSpaceBetweenFollowers = value
		SetGameSettingFloat("fFollowSpaceBetweenFollowers", value)
	EndFunction
EndProperty

float Property fFollowerSpacingAtDoors
	float Function Get()
		If _fFollowerSpacingAtDoors == -1.0
			return GetGameSettingFloat("fFollowerSpacingAtDoors")
		Endif
		return _fFollowerSpacingAtDoors
	EndFunction
	Function Set(float value)
		_fFollowerSpacingAtDoors = value
		SetGameSettingFloat("fFollowerSpacingAtDoors", value)
	EndFunction
EndProperty

float Property fFollowStartSprintDistance
	float Function Get()
		If _fFollowStartSprintDistance == -1.0
			return GetGameSettingFloat("fFollowStartSprintDistance")
		Endif
		return _fFollowStartSprintDistance
	EndFunction
	Function Set(float value)
		_fFollowStartSprintDistance = value
		SetGameSettingFloat("fFollowStartSprintDistance", value)
	EndFunction
EndProperty

int function GetVersion()
	return 1 ; Default version
endFunction

event OnConfigInit()
	_featPlugins = new int[128]
	XFLMenu = (Game.GetFormFromFile(0xEFE, "EFFCore.esm") as EFFMenuScript)
	XFLMain = (Game.GetFormFromFile(0xEFF, "EFFCore.esm") as EFFCore)
	Pages = new string[4]
	Pages[0] = "Features"
	Pages[1] = "Plugins"
	Pages[2] = "Settings"
	Pages[3] = "Panel"
endEvent

event OnVersionUpdate(int a_version)
	
endEvent

Event OnGameReload()
	parent.OnGameReload()
	fAIDistanceTeammateDrawWeapon = fAIDistanceTeammateDrawWeapon
	fSandboxSearchRadius = fSandboxSearchRadius
	iFriendHitCombatAllowed = iFriendHitCombatAllowed
	iNumberActorsAllowedToFollowPlayer = iNumberActorsAllowedToFollowPlayer
	iNumberActorsInCombatPlayer = iNumberActorsInCombatPlayer
	iAllyHitNonCombatAllowed = iAllyHitNonCombatAllowed
	iAllyHitCombatAllowed = iAllyHitCombatAllowed
	fFollowSpaceBetweenFollowers = fFollowSpaceBetweenFollowers
	iFriendHitNonCombatAllowed = iFriendHitNonCombatAllowed
	fFollowerSpacingAtDoors = fFollowerSpacingAtDoors
EndEvent

String Function GetFormIDString(Form kForm)
	String sResult
	sResult = kForm as String ; [FormName < (FF000000)>]
	sResult = StringUtil.SubString(sResult,StringUtil.Find(sResult,"(") + 1,8)
	return sResult
EndFunction

event OnPageReset(string a_page)

	if (a_page == "")
		; Image size 512x256
		; X offset = 376 - (height / 2) = 120
		; Y offset = 223 - (width / 2) = 95
		SetTitleText("Extensible Follower Framework")
		LoadCustomContent("res/XFLLogo.dds", 120, 95)
		return
	else
		UnloadCustomContent()
	endIf

	if (a_page == "Features")
		_featUseMenus = AddTextOption("Menu Mode", GetMenuModeString())
		_featIgnoreTimeout = AddToggleOption("Ignore Wait Timeout", XFLMenu.XFL_Config_IgnoreTimeout.GetValue() as bool)
		_featRideHorses = AddToggleOption("Followers Ride Horses", XFLMenu.XFL_Config_RideHorses.GetValue() as bool)
		_featShowStats = AddToggleOption("Show Follower Stats", XFLMenu.XFL_Config_ShowStats.GetValue() as bool)
		_featInvisibility = AddToggleOption("Stealth Invisibility", XFLMain.XFL_Config_AutoInvisiblity.GetValue() as bool)
		_featAutoIdle = AddToggleOption("Auto Idle", XFLMain.XFLIdleMonitor.IsRunning())
	elseif (a_page == "Plugins")
		int totalPlugins = XFLMenu.XFL_FollowerPlugins.GetSize()
		int i = 0
		While i < totalPlugins
			EFFPlugin plugin = (XFLMenu.XFL_FollowerPlugins.GetAt(i) As EFFPlugin)
			If plugin
				_featPlugins[i] = AddToggleOption(plugin.GetPluginName(), plugin.isEnabled())
			Endif
			i += 1
		EndWhile
	elseif (a_page == "Settings")
		SetCursorFillMode(TOP_TO_BOTTOM)

		_MaximumFollowers = AddSliderOption("Maximum Followers", XFLMain.XFL_MaximumFollowers.GetValue())

		AddHeaderOption("Inventory")
		_inventoryShow = AddTextOption("Current Container", GetFormIDString(XFLMain.XFL_UnclaimedItems), OPTION_FLAG_DISABLED)
		_inventorySet = AddTextOption("Set Container", GetFormIDString(Game.GetCurrentCrosshairRef()))
		_inventoryReset = AddTextOption("Reset Container", GetFormIDString(XFLMain.XFL_UnclaimedItemsStatic))

		AddHeaderOption("Spacing")
		_FollowSpace = AddSliderOption("Space between followers", fFollowSpaceBetweenFollowers)
		_FollowSpaceAtDoor = AddSliderOption("Spacing at doors", fFollowerSpacingAtDoors)

		AddHeaderOption("Misc")
		_StartSprintDist = AddSliderOption("Start sprint distance", fFollowStartSprintDistance)
		_SandboxRadius = AddSliderOption("Sandbox radius", fSandboxSearchRadius)
		_NumberActorsToFollow = AddSliderOption("Actors to follow", iNumberActorsAllowedToFollowPlayer)
		
		SetCursorPosition(1)

		AddHeaderOption("Combat")
		_DrawWeapon = AddSliderOption("Draw weapon distance", fAIDistanceTeammateDrawWeapon)
		_AllyHitCombat = AddSliderOption("Ally hits allowed", iAllyHitCombatAllowed)
		_AllyHitNonCombat = AddSliderOption("Ally hits allowed", iAllyHitNonCombatAllowed)
		_FriendHitCombat = AddSliderOption("Friend hits allowed", iFriendHitCombatAllowed)
		_FriendHitNonCombat = AddSliderOption("Friend hits allowed", iFriendHitNonCombatAllowed)
		_NumberActorsInCombat = AddSliderOption("Actors allowed in combat", iNumberActorsInCombatPlayer)

		AddHeaderOption("Maintenance")
		_clearSystem = AddTextOption("Clear System", "")
		Actor crosshairActor = Game.GetCurrentCrosshairRef() as Actor
		If crosshairActor
			_fixActor = AddTextOption("Fix Actor", crosshairActor.GetDisplayName())
		Else
			_fixActor = AddTextOption("Fix Actor", "None", OPTION_FLAG_DISABLED)
		Endif

		AddHeaderOption("Force Recruitment")
		If crosshairActor
			_forceRecruit = AddTextOption("Recruit", crosshairActor.GetDisplayName())
		Else
			_forceRecruit = AddTextOption("Recruit", "None", OPTION_FLAG_DISABLED)
		Endif

	elseif (a_page == "Panel")
		SetCursorFillMode(TOP_TO_BOTTOM)
		If XFLMain.APNLExtended
			AddHeaderOption("Dimensions")
			_panelX = AddSliderOption("X Coordinate", XFLMain.XFL_Panel.X)
			_panelY = AddSliderOption("Y Coordinate", XFLMain.XFL_Panel.Y)
			_panelScale = AddSliderOption("Scale ", XFLMain.XFL_Panel.Scale, "{2}")
			AddHeaderOption("Settings")
			_panelEntryCount = AddSliderOption("Max Entries", XFLMain.XFL_Panel.MaxEntries)
			_panelAlpha = AddSliderOption("Alpha", XFLMain.XFL_Panel.Alpha)
			SetCursorPosition(1)
			AddHeaderOption("Timing")
			_panelFadeInDuration = AddSliderOption("Fade In Duration", XFLMain.XFL_Panel.FadeInDuration, "{0}ms")
			_panelFadeOutDuration = AddSliderOption("Fade Out Duration", XFLMain.XFL_Panel.FadeOutDuration, "{0}ms")
			_panelMoveDuration = AddSliderOption("Move Duration", XFLMain.XFL_Panel.MoveDuration, "{0}ms")
			_panelRemoveDuration = AddSliderOption("Remove Duration", XFLMain.XFL_Panel.RemoveDuration, "{0}ms")
		Endif
	endif
endEvent

string Function GetMenuModeString()
	string menuString = "Dialogue"
	if (XFLMenu.XFL_Config_UseMenus.GetValue() as bool)
		if (XFLMenu.XFL_Config_UseClassicMenus.GetValue() as bool)
			menuString = "Classic"
		else
			menuString = "Standard"
		endIf
	endif
	return menuString
EndFunction

event OnOptionSelect(int a_option)
	GlobalVariable toggleOption = None
	EFFPlugin foundPlugin = None

	bool useMenus = (XFLMenu.XFL_Config_UseMenus.GetValue() as bool)
	bool useClassic = (XFLMenu.XFL_Config_UseClassicMenus.GetValue() as bool)

	if (a_option == _featUseMenus)
		if !useMenus
			XFLMenu.XFL_Config_UseMenus.SetValue(1.0)
			XFLMenu.XFL_Config_UseClassicMenus.SetValue(0.0)
		elseif useMenus && !useClassic
			XFLMenu.XFL_Config_UseClassicMenus.SetValue(1.0)
		elseif useMenus && useClassic
			XFLMenu.XFL_Config_UseMenus.SetValue(0.0)
		endIf
		SetTextOptionValue(_featUseMenus, GetMenuModeString())
	elseIf (a_option == _featIgnoreTimeout)
		toggleOption = XFLMenu.XFL_Config_IgnoreTimeout
	elseIf (a_option == _featRideHorses)
		toggleOption = XFLMenu.XFL_Config_RideHorses
	elseIf (a_option == _featShowStats)
		toggleOption = XFLMenu.XFL_Config_ShowStats
	elseIf (a_option == _featInvisibility)
		toggleOption = XFLMain.XFL_Config_AutoInvisiblity
	elseIf (a_option == _featAutoIdle)
		If XFLMain.XFLIdleMonitor.IsRunning()
			XFLMain.XFLIdleMonitor.StopIdle()
		Else
			XFLMain.XFLIdleMonitor.StartIdle()
		Endif
		SetToggleOptionValue(a_option, XFLMain.XFLIdleMonitor.IsRunning())
	elseif a_option == _inventorySet
		ObjectReference crosshairRef = Game.GetCurrentCrosshairRef()
		if crosshairRef
			Form crosshairBase = crosshairRef.GetBaseObject()
			If crosshairBase as Container
				XFLMain.XFL_UnclaimedItems.RemoveAllItems(crosshairRef, true)
				XFLMain.XFL_UnclaimedItems = crosshairRef
				SetTextOptionValue(_inventoryShow, GetFormIDString(XFLMain.XFL_UnclaimedItems))
			Else
				ShowMessage("Target object must be a container.")
			Endif
		Endif
	elseif a_option == _inventoryReset
		If XFLMain.XFL_UnclaimedItems != XFLMain.XFL_UnclaimedItemsStatic
			XFLMain.XFL_UnclaimedItems.RemoveAllItems(XFLMain.XFL_UnclaimedItemsStatic, true)
			XFLMain.XFL_UnclaimedItems = XFLMain.XFL_UnclaimedItemsStatic
			SetTextOptionValue(_inventoryShow, GetFormIDString(XFLMain.XFL_UnclaimedItems))
		Endif
	elseif a_option == _forceRecruit
		Actor crosshairActor = Game.GetCurrentCrosshairRef() as Actor
		If crosshairActor
			XFLMain.XFL_AddFollower(crosshairActor)
			If XFLMain.XFL_IsFollower(crosshairActor)
				ShowMessage("Recruited " + crosshairActor.GetDisplayName() + ".")
			Else
				ShowMessage("Failed to recruit " + crosshairActor.GetDisplayName() + ".")
			Endif
		Else
			ShowMessage("Forced recruitment can only be used on actors.")
		Endif
	elseif a_option == _clearSystem
		ShowMessage("Forcing system clear, exit the menu and wait for the completion notification.")
		XFLMain.XFL_ForceClearAll()
	elseif a_option == _fixActor
		Actor crosshairActor = Game.GetCurrentCrosshairRef() as Actor
		If crosshairActor
			If !XFLMain.XFL_IsFollower(crosshairActor)
				crosshairActor.RemoveFromFaction(XFLMain.XFL_FollowerFaction)
				crosshairActor.RemoveFromFaction(XFLMain.FollowerScript.pCurrentHireling)
				ShowMessage("Fixed " + crosshairActor.GetDisplayName() + "'s factions.")
			Else
				ShowMessage("Fix Actor can only be used on non-follower actors.")
			Endif
		Endif
	else
		int totalPlugins = XFLMenu.XFL_FollowerPlugins.GetSize()
		int i = 0
		While i < totalPlugins
			if(_featPlugins[i] == a_option)
				EFFPlugin plugin = (XFLMenu.XFL_FollowerPlugins.GetAt(i) As EFFPlugin)
				If plugin
					toggleOption = plugin.EnabledVar
					foundPlugin = plugin
				Endif
				i = totalPlugins
			Endif
			i += 1
		EndWhile
	endif

	if (toggleOption != None)
		bool toggleValue = toggleOption.GetValue() as bool
		toggleValue = !toggleValue
		toggleOption.SetValue(toggleValue as float)
		SetToggleOptionValue(a_option, toggleValue)

		if(foundPlugin)
			if(toggleValue == 1)
				foundPlugin.OnEnabled()
			elseif(toggleValue == 0)
				foundPlugin.OnDisabled()
			Endif
		Endif
	Endif
endEvent

event OnOptionSliderOpen(int a_option)
	{Called when the user selects a slider option}

	if (a_option == _FollowSpace)
		SetSliderDialogStartValue(fFollowSpaceBetweenFollowers)
		SetSliderDialogDefaultValue(100)
		SetSliderDialogRange(0, 8192)
		SetSliderDialogInterval(1)
	Elseif (a_option == _FollowSpaceAtDoor)
		SetSliderDialogStartValue(fFollowerSpacingAtDoors)
		SetSliderDialogDefaultValue(200)
		SetSliderDialogRange(0, 8192)
		SetSliderDialogInterval(1)
	Elseif (a_option == _DrawWeapon)
		SetSliderDialogStartValue(fAIDistanceTeammateDrawWeapon)
		SetSliderDialogDefaultValue(2000)
		SetSliderDialogRange(0, 8192)
		SetSliderDialogInterval(1)
	Elseif (a_option == _AllyHitCombat)
		SetSliderDialogStartValue(iAllyHitCombatAllowed)
		SetSliderDialogDefaultValue(1000)
		SetSliderDialogRange(0, 2048)
		SetSliderDialogInterval(1)
	Elseif (a_option == _AllyHitNonCombat)
		SetSliderDialogStartValue(iAllyHitNonCombatAllowed)
		SetSliderDialogDefaultValue(3)
		SetSliderDialogRange(0, 2048)
		SetSliderDialogInterval(1)
	Elseif (a_option == _FriendHitCombat)
		SetSliderDialogStartValue(iFriendHitCombatAllowed)
		SetSliderDialogDefaultValue(3)
		SetSliderDialogRange(0, 2048)
		SetSliderDialogInterval(1)
	Elseif (a_option == _FriendHitNonCombat)
		SetSliderDialogStartValue(iFriendHitNonCombatAllowed)
		SetSliderDialogDefaultValue(0)
		SetSliderDialogRange(0, 2048)
		SetSliderDialogInterval(1)
	Elseif (a_option == _NumberActorsInCombat)
		SetSliderDialogStartValue(iNumberActorsInCombatPlayer)
		SetSliderDialogDefaultValue(20)
		SetSliderDialogRange(0, 2048)
		SetSliderDialogInterval(1)
	Elseif (a_option == _StartSprintDist)
		SetSliderDialogStartValue(fFollowStartSprintDistance)
		SetSliderDialogDefaultValue(500)
		SetSliderDialogRange(0, 8192)
		SetSliderDialogInterval(1)
	Elseif (a_option == _SandboxRadius)
		SetSliderDialogStartValue(fSandboxSearchRadius)
		SetSliderDialogDefaultValue(6000)
		SetSliderDialogRange(0, 8192)
		SetSliderDialogInterval(1)
	Elseif (a_option == _NumberActorsToFollow)
		SetSliderDialogStartValue(iNumberActorsAllowedToFollowPlayer)
		SetSliderDialogDefaultValue(6)
		SetSliderDialogRange(0, 512)
		SetSliderDialogInterval(1)
	Elseif (a_option == _MaximumFollowers)
		SetSliderDialogStartValue(XFLMain.XFL_MaximumFollowers.GetValue())
		SetSliderDialogDefaultValue(100)
		SetSliderDialogRange(1, 100)
		SetSliderDialogInterval(1)
	Elseif (a_option == _panelX)
		If XFLMain.APNLExtended
			SetSliderDialogStartValue(XFLMain.XFL_Panel.X)
		Endif
		SetSliderDialogDefaultValue(0)
		SetSliderDialogRange(0, 1280)
		SetSliderDialogInterval(1)
	Elseif (a_option == _panelY)
		If XFLMain.APNLExtended
			SetSliderDialogStartValue(XFLMain.XFL_Panel.Y)
		Endif
		SetSliderDialogDefaultValue(0)
		SetSliderDialogRange(0, 720)
		SetSliderDialogInterval(1)
	Elseif (a_option == _panelScale)
		If XFLMain.APNLExtended
			SetSliderDialogStartValue(XFLMain.XFL_Panel.Scale)
		Endif
		SetSliderDialogDefaultValue(0)
		SetSliderDialogRange(0.01, 2.0)
		SetSliderDialogInterval(0.01)
	Elseif (a_option == _panelEntryCount)
		If XFLMain.APNLExtended
			SetSliderDialogStartValue(XFLMain.XFL_Panel.MaxEntries)
		Endif
		SetSliderDialogDefaultValue(5)
		SetSliderDialogRange(1, 100)
		SetSliderDialogInterval(1)
	Elseif (a_option == _panelFadeInDuration)
		If XFLMain.APNLExtended
			SetSliderDialogStartValue(XFLMain.XFL_Panel.FadeInDuration)
		Endif
		SetSliderDialogDefaultValue(250)
		SetSliderDialogRange(0, 5000)
		SetSliderDialogInterval(1)
	Elseif (a_option == _panelFadeOutDuration)
		If XFLMain.APNLExtended
			SetSliderDialogStartValue(XFLMain.XFL_Panel.FadeOutDuration)
		Endif
		SetSliderDialogDefaultValue(250)
		SetSliderDialogRange(0, 5000)
		SetSliderDialogInterval(1)
	Elseif (a_option == _panelMoveDuration)
		If XFLMain.APNLExtended
			SetSliderDialogStartValue(XFLMain.XFL_Panel.MoveDuration)
		Endif
		SetSliderDialogDefaultValue(1000)
		SetSliderDialogRange(0, 5000)
		SetSliderDialogInterval(1)
	Elseif (a_option == _panelRemoveDuration)
		If XFLMain.APNLExtended
			SetSliderDialogStartValue(XFLMain.XFL_Panel.RemoveDuration)
		Endif
		SetSliderDialogDefaultValue(15000)
		SetSliderDialogRange(0, 60000)
		SetSliderDialogInterval(1)
	Elseif (a_option == _panelAlpha)
		If XFLMain.APNLExtended
			SetSliderDialogStartValue(XFLMain.XFL_Panel.Alpha)
		Endif
		SetSliderDialogDefaultValue(100)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	endIf
endEvent

event OnOptionSliderAccept(int a_option, float a_value)
	{Called when the user accepts a new slider value}
		
	if (a_option == _FollowSpace)
		fFollowSpaceBetweenFollowers = a_value
		SetSliderOptionValue(a_option, a_value)
	Elseif (a_option == _FollowSpaceAtDoor)
		fFollowerSpacingAtDoors = a_value
		SetSliderOptionValue(a_option, a_value)
	Elseif (a_option == _DrawWeapon)
		fAIDistanceTeammateDrawWeapon = a_value
		SetSliderOptionValue(a_option, a_value)
	Elseif (a_option == _AllyHitCombat)
		iAllyHitCombatAllowed = a_value as int
		SetSliderOptionValue(a_option, a_value)
	Elseif (a_option == _AllyHitNonCombat)
		iAllyHitNonCombatAllowed = a_value as int
		SetSliderOptionValue(a_option, a_value)
	Elseif (a_option == _FriendHitCombat)
		iFriendHitCombatAllowed = a_value as int
		SetSliderOptionValue(a_option, a_value)
	Elseif (a_option == _FriendHitNonCombat)
		iFriendHitNonCombatAllowed = a_value as int
		SetSliderOptionValue(a_option, a_value)
	Elseif (a_option == _NumberActorsInCombat)
		iNumberActorsInCombatPlayer = a_value as int
		SetSliderOptionValue(a_option, a_value)
	Elseif (a_option == _StartSprintDist)
		fFollowStartSprintDistance = a_value
		SetSliderOptionValue(a_option, a_value)
	Elseif (a_option == _SandboxRadius)
		fSandboxSearchRadius = a_value
		SetSliderOptionValue(a_option, a_value)
	Elseif (a_option == _NumberActorsToFollow)
		iNumberActorsAllowedToFollowPlayer = a_value as int
		SetSliderOptionValue(a_option, a_value)
	Elseif (a_option == _MaximumFollowers)
		XFLMain.XFL_MaximumFollowers.SetValue(a_value)
		SetSliderOptionValue(a_option, a_value)
	Elseif (a_option == _panelX)
		If XFLMain.APNLExtended
			XFLMain.XFL_Panel.X = a_value
		Endif
		SetSliderOptionValue(a_option, a_value)
	Elseif (a_option == _panelY)
		If XFLMain.APNLExtended
			XFLMain.XFL_Panel.Y = a_value
		Endif
		SetSliderOptionValue(a_option, a_value)
	Elseif (a_option == _panelScale)
		If XFLMain.APNLExtended
			XFLMain.XFL_Panel.Scale = a_value
		Endif
		SetSliderOptionValue(a_option, a_value, "{2}")
	Elseif (a_option == _panelEntryCount)
		If XFLMain.APNLExtended
			XFLMain.XFL_Panel.MaxEntries = a_value as int
		Endif
		SetSliderOptionValue(a_option, a_value)
	Elseif (a_option == _panelFadeInDuration)
		If XFLMain.APNLExtended
			XFLMain.XFL_Panel.FadeInDuration = a_value
		Endif
		SetSliderOptionValue(a_option, a_value, "{0}ms")
	Elseif (a_option == _panelFadeOutDuration)
		If XFLMain.APNLExtended
			XFLMain.XFL_Panel.FadeOutDuration = a_value
		Endif
		SetSliderOptionValue(a_option, a_value, "{0}ms")
	Elseif (a_option == _panelMoveDuration)
		If XFLMain.APNLExtended
			XFLMain.XFL_Panel.MoveDuration = a_value
		Endif
		SetSliderOptionValue(a_option, a_value, "{0}ms")
	Elseif (a_option == _panelRemoveDuration)
		If XFLMain.APNLExtended
			XFLMain.XFL_Panel.RemoveDuration = a_value
		Endif
		SetSliderOptionValue(a_option, a_value, "{0}ms")
	Elseif (a_option == _panelAlpha)
		If XFLMain.APNLExtended
			XFLMain.XFL_Panel.Alpha = a_value
		Endif
		SetSliderOptionValue(a_option, a_value, "{0}%")
	endIf
endEvent

event OnOptionHighlight(int a_option)
	{Called when the user highlights an option}
	
	if (a_option == _DrawWeapon)
		SetInfoText("Distance away from the player for the follower to draw their weapon.")
	elseIf (a_option == _SandboxRadius)
		SetInfoText("Radius at which a follower will sandbox.")
	elseIf (a_option == _FriendHitCombat)
		SetInfoText("Number of hits a friend can take during combat before turning hostile.")
	elseIf (a_option == _FriendHitNonCombat)
		SetInfoText("Number of hits a friend can take outside of combat before turning hostile.")
	elseIf (a_option == _NumberActorsToFollow)
		SetInfoText("Number of actors that can follow the player")
	elseIf (a_option == _NumberActorsInCombat)
		SetInfoText("Number of actors that can enter combat with the player.")
	elseIf (a_option == _AllyHitNonCombat)
		SetInfoText("Number of hits an ally can take outside of combat before turning hostile.")
	elseIf (a_option == _AllyHitCombat)
		SetInfoText("Number of hits an ally can take during combat before turning hostile.")
	elseIf (a_option == _FollowSpace)
		SetInfoText("Distance between followers.")
	elseIf (a_option == _FollowSpaceAtDoor)
		SetInfoText("Distance between a follower at a door.")
	elseIf (a_option == _MaximumFollowers)
		SetInfoText("Maximum number of followers who you can recruit.")
	elseIf (a_option == _StartSprintDist)
		SetInfoText("Distance before a follower starts sprinting.")
	elseIf (a_option == _panelEntryCount)
		SetInfoText("Maximum number of actors shown on the panel at one time.")
	elseIf (a_option == _panelFadeInDuration)
		SetInfoText("Amount of time in milliseconds it takes to fade an actor in.")
	elseIf (a_option == _panelFadeOutDuration)
		SetInfoText("Amount of time in milliseconds it takes to fade an actor out.")
	elseIf (a_option == _panelMoveDuration)
		SetInfoText("Amount of time in milliseconds it takes to move an actor up when another is removed.")
	elseIf (a_option == _panelRemoveDuration)
		SetInfoText("Amount of time in milliseconds it takes to remove an actor when no activity has occured.")
	elseIf (a_option == _inventorySet)
		SetInfoText("Assigns the reference under your crosshair to be the container for follower items when dismissed.")
	elseIf (a_option == _fixActor)
		SetInfoText("Fixes the actor's factions under your crosshair to allow them to be re-recruited.")
	elseIf (a_option == _forceRecruit)
		SetInfoText("Forces the actor under your crosshair to become your follower.")
	endIf
endEvent
