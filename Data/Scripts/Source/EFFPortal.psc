Scriptname EFFPortal extends ActiveMagicEffect  

EFFCore Property XFLMain Auto
Activator Property SummonFX Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	teleportActor(akCaster, akTarget)
EndEvent

Function teleportActor(Actor actorRef, Actor destination)
	actorRef.PlaceAtMe(SummonFX)
	actorRef.DisableNoWait(true)
	actorRef.MoveTo(destination, Utility.RandomFloat(-50.0, 50.0), Utility.RandomFloat(-50.0, 50.0))
	actorRef.PlaceAtMe(SummonFX)
	Utility.Wait(0.5)
	actorRef.EnableNoWait(false)
EndFunction