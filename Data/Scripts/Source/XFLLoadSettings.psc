Scriptname XFLLoadSettings extends ReferenceAlias  

XFLScript Property XFLMain Auto
XFLMenuScript Property XFLMenu Auto

Event OnPlayerLoadGame()
	if !isSKSELoaded()
		Debug.Trace("EFF ERROR: SKSE version 1.6.0 not met, some features will be unavailable.")
	EndIf
	If !isDLC1Loaded()
		Debug.Trace("EFF WARNING: No Dawnguard detected, some features will be unavailable.")
	Endif
EndEvent

bool Function isSKSELoaded()
	float skseVersion = SKSE.GetVersion() + (SKSE.GetVersionMinor() / 10.0) + (SKSE.GetVersionBeta() / 100.0)
	If skseVersion >= 1.60
		XFLMain.SKSEExtended = true
		return true
	Else
		XFLMain.SKSEExtended = false
		XFLMenu.XFL_Config_UseClassicMenus.value = 1
	Endif
	return false
EndFunction

bool Function isDLC1Loaded()
	bool DLC1Check = (Game.GetFormFromFile(0x588C, "Dawnguard.esm") != None) ; Checks for DLC1VampireTurnScript Quest
	If DLC1Check
		XFLMain.DLC1Extended = true
		return true
	Else
		XFLMain.DLC1Extended = false
	Endif
	return false
EndFunction