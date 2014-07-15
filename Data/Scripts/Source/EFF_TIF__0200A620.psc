;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname EFF_TIF__0200A620 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
;PluginSpells.XFL_TeachSpell(Game.GetPlayer(), None, 0, true)
XFLMain.XFL_SendActionEvent(PluginSpells.GetIdentifier(), 1, Game.GetPlayer(), None, 0)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

EFFPluginSpells Property PluginSpells  Auto  

EFFCore Property XFLMain  Auto  
