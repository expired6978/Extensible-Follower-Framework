Scriptname XFLTelepathy extends activemagiceffect  

XFLScript Property XFLMain  Auto  
XFLMenuScript Property XFLMenu  Auto  

Message Property FollowerCommandTelepathy  Auto  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Actor selected = None
	If XFLMain.XFL_FollowerCountEx.GetValue() == 1 ; We only have one follower, why bother with the main menu
		selected = XFLMain.XFL_GetLastFollower()
	Else ; Follower is ambiguous, Group or Selection
		int Telepathy_Group = 0
		int Telepathy_Select = 1

		XFLMenu.OnStartMenu()
		int ret = FollowerCommandTelepathy.Show()
		If ret == Telepathy_Group
			XFLMenu.XFL_TriggerMenu(None, "GroupMenu") ; Group
		Elseif ret == Telepathy_Select
			selected = XFLMenu.XFL_SelectFollower() ; Selected
		Else
			XFLMenu.OnFinishMenu()
		Endif
	Endif
	If selected ; Single follower selected
		XFLMenu.XFL_TriggerMenu(selected, "CommandMenu")
	Else
		XFLMenu.OnFinishMenu()
	Endif
EndEvent
