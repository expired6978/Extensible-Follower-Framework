Scriptname EFFPluginTattoos extends EFFPlugin  

int Function GetIdentifier()
	return 0x1008
EndFunction

string Function GetPluginName()
	return "$Tattoos"
EndFunction

; Called when the menu system triggers an entry
Event OnMenuEntryTriggered(Form akForm, int itemId, int callback)
	Actor akRef = akForm as Actor
	If SKSE.GetPluginVersion("NiOverride") >= 1
		If !NiOverride.HasOverlays(akRef)
			NiOverride.AddOverlays(akRef)
		Endif
	Endif

	UIMenuBase menuBase = UIExtensions.GetMenu("UICosmeticMenu")
	menuBase.SetPropertyInt("categories", 0x7E)
	menuBase.OpenMenu(akForm)

	If SKSE.GetPluginVersion("NiOverride") >= 1
		If GetAllVisibleOverlays(akRef) == 0
			NiOverride.RemoveOverlays(akRef)
		Endif
	Endif
EndEvent

Bool Function showMenu(Form akForm) ; Re-implement
	return (XFLMain.SKSEExtended && XFLMain.MENUExtended) && SKSE.GetPluginVersion("NiOverride") >= 1 ; Requires menu extension, SKSE, and NiOverride
EndFunction

Bool Function showGroupMenu() ; Do not show while in group menu
	return false
EndFunction

; New menu system info
string[] Function GetMenuEntries(Form akForm)
	string[] entries = new string[3]
	int itemOffset = GetIdentifier() * 100
	entries[0] = GetPluginName() + ";;" + -1 + ";;" + (itemOffset + 0) + ";;" + (itemOffset + 0) + ";;0"
	return entries
EndFunction

int Function GetAllVisibleOverlays(Actor target)
	int totalVisible = 0
	If SKSE.GetPluginVersion("NiOverride") >= 1 ; Checks to make sure the NiOverride plugin exists
		totalVisible += GetVisibleOverlays(target, 256, "Body [Ovl", NiOverride.GetNumBodyOverlays())
		totalVisible += GetVisibleOverlays(target, 257, "Hands [Ovl", NiOverride.GetNumHandOverlays())
		totalVisible += GetVisibleOverlays(target, 258, "Feet [Ovl", NiOverride.GetNumFeetOverlays())
		totalVisible += GetVisibleOverlays(target, 259, "Face [Ovl", NiOverride.GetNumFaceOverlays())
	Endif
	return totalVisible
EndFunction

int Function GetVisibleOverlays(Actor target, int tintType, string tintTemplate, int tintCount)
	int i = 0
	int visible = 0
	ActorBase targetBase = target.GetActorBase()
	While i < tintCount
		string nodeName = tintTemplate + i + "]"
		float alpha = 0
		string texture = ""
		If NetImmerse.HasNode(target, nodeName, false) ; Actor has the node, get the immediate property
			alpha = NiOverride.GetNodePropertyFloat(target, false, nodeName, 8, -1)
			texture = NiOverride.GetNodePropertyString(target, false, nodeName, 9, 0)
		Else ; Doesn't have the node, get it from the override
			bool isFemale = targetBase.GetSex() as bool
			alpha = NiOverride.GetNodeOverrideFloat(target, isFemale, nodeName, 8, -1)
			texture = NiOverride.GetNodeOverrideString(target, isFemale, nodeName, 9, 0)
		Endif
		If texture == ""
			texture = "Actors\\Character\\Overlays\\Default.dds"
		Endif
		If texture != "Actors\\Character\\Overlays\\Default.dds" && alpha > 0.0
			visible += 1
		Endif
		i += 1
	EndWhile
	return visible
EndFunction