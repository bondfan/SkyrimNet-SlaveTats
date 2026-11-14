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

; Head to toe; All Over last. Prompt templates repeat this list.
String[] Function Positions() Global
    String[] names = new String[18]
    names[0] = "Face"
    names[1] = "Neck"
    names[2] = "Chest"
    names[3] = "Belly"
    names[4] = "Back"
    names[5] = "Ass"
    names[6] = "Pubic Area"
    names[7] = "Left Arm"
    names[8] = "Right Arm"
    names[9] = "Left Hand"
    names[10] = "Right Hand"
    names[11] = "Left Upper Leg"
    names[12] = "Right Upper Leg"
    names[13] = "Left Lower Leg"
    names[14] = "Right Lower Leg"
    names[15] = "Left Foot"
    names[16] = "Right Foot"
    names[17] = "All Over"
    Return names
EndFunction

Bool Function IsPosition(String asPosition) Global
    Return Positions().Find(asPosition) >= 0
EndFunction

; Caller owns the retained result: category name to explanation. Explanations are optional.
Int Function LoadCategories() Global
    String directory = "Data/SKSE/Plugins/SkyrimNet-SlaveTats/Categories"
    String[] filenames = MiscUtil.FilesInFolder(directory, ".json")
    Int categories = JValue.retain(JMap.object())
    Int fileIndex = 0
    While fileIndex < filenames.Length
        AddCategories(categories, directory, filenames[fileIndex])
        fileIndex += 1
    EndWhile
    Return categories
EndFunction

Function AddCategories(Int aiCategories, String asDirectory, String asFilename) Global
    Int entries = JValue.retain(JValue.readFromFile(asDirectory + "/" + asFilename))
    If !JValue.isMap(entries)
        Debug.Trace("[SNT] " + asFilename + ": invalid JSON or root is not an object", 2)
        JValue.release(entries)
        Return
    EndIf
    Int names = JValue.retain(JMap.allKeys(entries))
    Int index = 0
    While index < JArray.count(names)
        String category = JArray.getStr(names, index)
        If JMap.valueType(entries, category) != 6
            Debug.Trace("[SNT] " + asFilename + ": explanation of " + category + " must be a string", 2)
        ElseIf JMap.hasKey(aiCategories, category)
            Debug.Trace("[SNT] " + asFilename + ": duplicate category " + category + " ignored", 2)
        Else
            JMap.setStr(aiCategories, category, JMap.getStr(entries, category))
        EndIf
        index += 1
    EndWhile
    JValue.release(names)
    JValue.release(entries)
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
