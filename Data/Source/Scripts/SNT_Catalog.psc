Scriptname SNT_Catalog Hidden

; Caller owns the retained result and must release it when replacing the catalog.
Int Function Load() Global
    String directory = "Data/SKSE/Plugins/SkyrimNet-SlaveTats/Packs"
    String[] filenames = MiscUtil.FilesInFolder(directory, ".json")
    Int catalog = JValue.retain(JMap.object())
    Int fileIndex = 0
    Bool valid = True
    While fileIndex < filenames.Length && valid
        String filename = filenames[fileIndex]
        Int entries = JValue.retain(JValue.readFromFile(directory + "/" + filename))
        If !JValue.isArray(entries)
            Debug.Trace("[SNT] " + filename + ": invalid JSON or root is not an array", 2)
            valid = False
        Else
            Int entryIndex = 0
            While entryIndex < JArray.count(entries) && valid
                Int entry = JArray.getObj(entries, entryIndex)
                String problem = ValidationError(entry)
                If problem != ""
                    Debug.Trace("[SNT] " + filename + " entry " + entryIndex + ": " + problem, 2)
                    valid = False
                Else
                    String identity = SNT_Storage.VisibilityKey(JMap.getStr(entry, "Section"), JMap.getStr(entry, "Name"))
                    If JMap.hasKey(catalog, identity)
                        Debug.Trace("[SNT] " + filename + ": duplicate tattoo " + identity, 2)
                        valid = False
                    Else
                        JMap.setObj(catalog, identity, entry)
                    EndIf
                EndIf
                entryIndex += 1
            EndWhile
        EndIf
        JValue.release(entries)
        fileIndex += 1
    EndWhile
    If !valid
        Return JValue.release(catalog)
    EndIf
    Return catalog
EndFunction

Bool Function HasText(Int aiEntry, String asField) Global
    If JMap.valueType(aiEntry, asField) != 6
        Return False
    EndIf
    Return JMap.getStr(aiEntry, asField) != ""
EndFunction

Bool Function IsPosition(String asPosition) Global
    Return asPosition == "Face" || asPosition == "Neck" || asPosition == "Back" || \
        asPosition == "Chest" || asPosition == "Belly" || \
        asPosition == "Ass" || asPosition == "Pubic Area" || asPosition == "All Over" || \
        asPosition == "Left Arm" || asPosition == "Right Arm" || \
        asPosition == "Left Lower Leg" || asPosition == "Right Lower Leg" || \
        asPosition == "Left Upper Leg" || asPosition == "Right Upper Leg" || \
        asPosition == "Left Hand" || asPosition == "Right Hand" || \
        asPosition == "Left Foot" || asPosition == "Right Foot"
EndFunction

String Function ValidationError(Int aiEntry) Global
    If !JValue.isMap(aiEntry)
        Return "Entry must be an object"
    EndIf
    If !HasText(aiEntry, "Section")
        Return "Section must be a nonempty string"
    EndIf
    If !HasText(aiEntry, "Name")
        Return "Name must be a nonempty string"
    EndIf
    If !HasText(aiEntry, "DisplayName")
        Return "DisplayName must be a nonempty string"
    EndIf
    If !HasText(aiEntry, "Category")
        Return "Category must be a nonempty string"
    EndIf
    If !HasText(aiEntry, "Content")
        Return "Content must be a nonempty string"
    EndIf
    If !HasText(aiEntry, "Position") || !IsPosition(JMap.getStr(aiEntry, "Position"))
        Return "Position must be a supported region"
    EndIf
    Return ""
EndFunction
