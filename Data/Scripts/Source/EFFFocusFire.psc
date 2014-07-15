Scriptname EFFFocusFire extends ActiveMagicEffect  

EFFCore Property XFLMain  Auto  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	XFLMain.XFL_FocusTarget(akTarget, None, true)
EndEvent