;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname EXP_TIF__000BDFB1 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
HirelingRecognizeStenvar.Value=1
;HasHirelingGV.Value=1
(GetOwningQuest() as EXP_HirelingQuest).PayHireling(akSpeaker)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

globalvariable Property HasHirelingGV  Auto  

GlobalVariable Property HirelingRecognizeStenvar  Auto  
