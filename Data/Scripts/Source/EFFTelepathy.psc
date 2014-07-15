Scriptname EFFTelepathy extends activemagiceffect  

EFFCore Property XFLMain  Auto  
EFFMenuScript Property XFLMenu  Auto  

Message Property FollowerCommandTelepathy  Auto  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Form selected = None
	If XFLMain.XFL_FollowerCountEx.GetValue() == 1 ; We only have one follower, why bother with the main menu
		selected = XFLMain.XFL_GetLastFollower()
	Else ; Follower is ambiguous, Group or Selection
		int Telepathy_Group = 0
		int Telepathy_Select = 1

		XFLMenu.OnStartMenu()
		If (XFLMenu.XFL_Config_UseClassicMenus.GetValue() as bool)
			int ret = FollowerCommandTelepathy.Show()
			If ret == Telepathy_Group
				XFLMenu.XFL_TriggerMenu(None, XFLMenu.GetMenuState("GroupMenu")) ; Group
			Elseif ret == Telepathy_Select
				selected = XFLMenu.XFL_SelectFollower() ; Selected
			Else
				XFLMenu.OnFinishMenu()
			Endif
		Else
			selected = XFLMenu.XFL_SelectFollowers()
			If (selected as FormList) && (selected as FormList).GetSize() == 0
				selected = None
			Endif
		Endif
	Endif
	If selected 
		if (selected as FormList)
			XFLMenu.XFL_PreviousActor = (selected as FormList).GetAt(0) as Actor
		else
			XFLMenu.XFL_PreviousActor = selected as Actor
		Endif
		XFLMenu.XFL_TriggerMenu(selected, XFLMenu.GetMenuState("CommandMenu"))
	Else
		XFLMenu.OnFinishMenu()
	Endif
EndEvent
