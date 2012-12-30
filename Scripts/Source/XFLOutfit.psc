Scriptname XFLOutfit extends Quest  

ReferenceAlias[] Property Outfits Auto
Keyword Property PlayerFollowerHasOutfit Auto

Function XFL_AddPersistentRef(Actor persistent)
	If !persistent.HasKeyword(PlayerFollowerHasOutfit)
		int i = 0
		While i < Outfits.Length
			If Outfits[i].ForceRefIfEmpty(persistent)
				(Outfits[i] as XFLAliasOutfit).SaveEquipment()
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
				(Outfits[i] as XFLAliasOutfit).ClearEquipment()
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
			(Outfits[i] as XFLAliasOutfit).ClearEquipment()
			Outfits[i].TryToClear()
		Endif
		i += 1
	EndWhile
EndFunction