Scriptname EFFTeleport extends ActiveMagicEffect  

EFFCore Property XFLMain Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	XFLMain.XFL_Teleport(akCaster, None) ; None indicates whole group teleport
EndEvent