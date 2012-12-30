Scriptname XFLFocusFire extends ActiveMagicEffect  

XFLScript Property XFLMain  Auto  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	XFLMain.XFL_FocusTarget(akTarget, None, true)
EndEvent