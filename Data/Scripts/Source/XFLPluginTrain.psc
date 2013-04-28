Scriptname XFLPluginTrain extends XFLPlugin  

Armor Property FollowerTrainPluginArmor Auto
ObjectReference Property FollowerTrainStorageRef Auto

Actor _follower = None

int Function GetIdentifier()
	return 0x1002
EndFunction

string Function GetPluginName()
	return "$Train"
EndFunction

; akCmd 0 - Train
; akForm1 - Receiving Actor
Event OnActionEvent(int akCmd, Form akForm1 = None, Form akForm2 = None, int aiValue1 = 0, int aiValue2 = 0)
	If akCmd == 0
		ToggleActor(akForm1 as Actor)
	Endif
EndEvent

Function activateMenu(int page, Form akForm) ; Re-implement
	;Game.FadeOutGame(true, true, 0, 2.5)
	;Utility.Wait(1)
	FollowerMenu.OnFinishMenu()
	XFLMain.XFL_SendActionEvent(GetIdentifier(), 0, akForm)
	;Debug.MessageBox("$$loadMovie=statssheetmenu$$")
	;XFLMain.XFL_OpenSelectionMenu()
	;int ret = FollowerMenu.XFL_OpenFollowerMenu(follower)
	;FollowerMenu.OnExtendedMenu(ret, follower)
	;Game.ShowLimitedRaceMenu()
	;Book myBook = Game.GetFormFromFile(0x1AD14, "Skyrim.esm") as Book
	;Debug.Trace("Read: " + myBook.IsRead())

	;RegisterForSingleUpdate(1)
	;XFLMain.XFL_OpenMagicMenu(follower)
	;follower.SetEyeTexture(Game.GetFormFromFile(0x81533, "Sierra.esp") as TextureSet)
	;XFLMain.XFL_OpenSelectionMenu()

	;DLC1VampireTurnScript vampireScript = (Game.GetFormFromFile(0x588C, "Dawnguard.esm") as DLC1VampireTurnScript)
	;vampireScript.NPCTransformIntoVampireLord(follower, true, false)
EndFunction

Function ToggleActor(Actor follower)
	If !follower.isDisabled() ; We don't want to accidently enable an actor that is currently disabled
		FollowerTrainStorageRef.RemoveAllItems() ; Clearout container
		follower.RemoveAllItems(FollowerTrainStorageRef, abRemoveQuestItems = true) ; Move follower items to container
		follower.SetPlayerTeammate(false)
		follower.Disable()
		follower.Enable()
		follower.RemoveAllItems() ; Remove all items from follower
		FollowerTrainStorageRef.RemoveAllItems(follower, abRemoveQuestItems = true) ; Move items from container to follower
		follower.SetPlayerTeammate(true)
		follower.AddItem(FollowerTrainPluginArmor, 1, true) ; Toggle an equip-able item to trigger armor update
		follower.RemoveItem(FollowerTrainPluginArmor, 1)
	EndIf
EndFunction

Bool Function showMenu(Form akForm) ; Re-implement
	return true
EndFunction

Bool Function showGroupMenu() ; Re-implement
	return true
EndFunction

Function activateGroupMenu(int page, Form akForm) ; Re-implement
	FollowerMenu.OnFinishMenu()
	XFLMain.XFL_SendActionEvent(GetIdentifier(), 0, None)
EndFunction
