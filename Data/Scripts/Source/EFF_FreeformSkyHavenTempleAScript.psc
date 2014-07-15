ScriptName EFF_FreeformSkyHavenTempleAScript extends FreeformSkyHavenTempleAScript Conditional

EFFCore Property XFLMain Auto

Function RecruitBlade (Actor RecruitREF)

	;Follower becomes a Blade
	;Incremement counter
	If (BladesCount == 0)
		Blade01.ForceRefTo(RecruitREF)
		XFLMain.XFL_RemoveFollower(RecruitREF, 0, 0)
		BladesCount = 1
		SetStage(20)
	ElseIf (BladesCount == 1)
		Blade02.ForceRefTo(RecruitREF)
		XFLMain.XFL_RemoveFollower(RecruitREF, 0, 0)
		BladesCount = 2
		SetStage(30)
	ElseIf (BladesCount == 2)
		Blade03.ForceRefTo(RecruitREF)
		XFLMain.XFL_RemoveFollower(RecruitREF, 0, 0)
		BladesCount = 3
		SetStage(40)
	EndIf

EndFunction
