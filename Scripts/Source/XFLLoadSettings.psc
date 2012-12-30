Scriptname XFLLoadSettings extends ReferenceAlias  

XFLScript Property XFLMain Auto

Event OnPlayerLoadGame()
	(GetOwningQuest() as XFLGameSettings).OnLoadGameSettings()

	float skseVersion = SKSE.GetVersion() + (SKSE.GetVersionMinor() / 10.0) + (SKSE.GetVersionBeta() / 100.0)
	If skseVersion >= 1.60
		XFLMain.SKSEExtended = true
	Else
		Debug.Trace("EFF ERROR: SKSE version (" + skseVersion + ") 1.6.0 not met, some features will be unavailable.")
		XFLMain.SKSEExtended = false
	Endif

	bool DLC1Check = (Game.GetFormFromFile(0x588C, "Dawnguard.esm") != None) ; Checks for DLC1VampireTurnScript Quest
	If DLC1Check
		XFLMain.DLC1Extended = true
	Else
		XFLMain.DLC1Extended = false
		Debug.Trace("EFF WARNING: No Dawnguard detected, some features will be unavailable.")
	Endif

	XFLPanel panel = (Game.GetFormFromFile(0x800, "XFLPanel.esp") as XFLPanel)
	if panel
		XFLMain.XFL_Panel = panel
	Else
		XFLMain.XFL_Panel = None
		Debug.Trace("EFF WARNING: No HUD panel script found, this feature will be unavailable.")
	Endif
EndEvent
