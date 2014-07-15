Scriptname EFFOutfit extends Quest  

ReferenceAlias[] Property Outfits Auto
Keyword Property PlayerFollowerHasOutfit Auto
Outfit Property Naked Auto

Function XFL_ConvertOutfit(Actor akActor)
	ActorBase akActorBase = akActor.GetActorBase()
	Outfit actorOutfit = akActorBase.GetOutfit()
	If actorOutfit != Naked
		int i = 0
		While i < actorOutfit.GetNumParts()
			akActor.EquipItem(actorOutfit.GetNthPart(i))
			i += 1
		EndWhile
		akActorBase.SetOutfit(Naked)
	Endif
EndFunction

Function XFL_AddPersistentRef(Actor persistent)
	If !persistent.HasKeyword(PlayerFollowerHasOutfit)
		int i = 0
		While i < Outfits.Length
			If Outfits[i].ForceRefIfEmpty(persistent)
				(Outfits[i] as EFFAliasOutfit).SaveEquipment()
				(Outfits[i] as EFFAliasOutfit).LoadEquipment()
				i = Outfits.Length
			Endif
			i += 1
		EndWhile
	Endif
EndFunction

Function XFL_RemovePersistentRef(Actor persistent)
	If persistent.HasKeyword(PlayerFollowerHasOutfit)
		int i = 0
		While i < Outfits.Length
			If Outfits[i].GetReference() == persistent
				(Outfits[i] as EFFAliasOutfit).ClearEquipment()
				Outfits[i].TryToClear()
				i = Outfits.Length
			Endif
			i += 1
		EndWhile
	Endif
EndFunction

Function XFL_ForceClearAll()
	int i = 0
	While i < Outfits.Length
		If Outfits[i].GetReference()
			(Outfits[i] as EFFAliasOutfit).ClearEquipment()
			Outfits[i].TryToClear()
		Endif
		i += 1
	EndWhile
EndFunction