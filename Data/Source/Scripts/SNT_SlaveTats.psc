Scriptname SNT_SlaveTats Hidden

Int Function AvailableSnapshot() Global
    Int cache = JValue.retain(SlaveTatsNG.acquire_cache())
    If !JValue.isMap(cache)
        JValue.release(cache)
        Return 0
    EndIf
    Int domains = JValue.retain(JMap.allKeys(cache))
    Int matches = JValue.retain(JArray.object())
    Int index = 0
    Bool failed = False
    While index < JArray.count(domains) && !failed
        failed = SlaveTatsNG.query_available_tattoos(0, matches, 0, JArray.getStr(domains, index))
        index += 1
    EndWhile
    JValue.release(domains)
    JValue.release(cache)
    If failed
        Debug.Trace("[SNT] Available tattoo query failed", 2)
        Return JValue.release(matches)
    EndIf
    Return matches
EndFunction

; Returns a retained array, including for an empty result; zero means failure.
Int Function AppliedSnapshot(Actor akWearer) Global
    If !akWearer
        Return 0
    EndIf
    Int matches = JValue.retain(JArray.object())
    If SlaveTatsNG.query_applied_tattoos(akWearer, 0, matches)
        Debug.Trace("[SNT] Applied tattoo query failed", 2)
        Return JValue.release(matches)
    EndIf
    Return matches
EndFunction

; Caller retains ownership of aiApplied. Returned entries belong to that array.
Int Function FindApplied(Int aiApplied, String asSection, String asName) Global
    Int index = 0
    While index < JArray.count(aiApplied)
        Int tattoo = JArray.getObj(aiApplied, index)
        If JMap.getStr(tattoo, "section") == asSection && JMap.getStr(tattoo, "name") == asName
            Return tattoo
        EndIf
        index += 1
    EndWhile
    Return 0
EndFunction

String Function Pool(Int aiTattoo) Global
    String area = JMap.getStr(aiTattoo, "area")
    If area == "Body" || area == "Face" || area == "Hands" || area == "Feet"
        Return area
    EndIf
    Return ""
EndFunction

Bool Function HasFreeSlot(Actor akWearer, String asPool) Global
    If !akWearer || asPool == ""
        Return False
    EndIf
    Return SlaveTatsNG._available_slot(akWearer, asPool) >= 0
EndFunction

Bool Function Apply(Actor akWearer, Int aiSource) Global
    String poolName = Pool(aiSource)
    If !HasFreeSlot(akWearer, poolName)
        Return False
    EndIf
    Int tattoo = JValue.retain(JValue.deepCopy(aiSource))
    JMap.removeKey(tattoo, "slot")
    Bool failed = SlaveTatsNG.add_tattoo(akWearer, tattoo, -1, False, True)
    JValue.release(tattoo)
    If failed
        Return False
    EndIf
    Return !SlaveTatsNG.synchronize_tattoos(akWearer, True)
EndFunction

Bool Function CanApply(Actor akWearer, Int aiSource) Global
    If !HasFreeSlot(akWearer, Pool(aiSource))
        Return False
    EndIf
    Int applied = AppliedSnapshot(akWearer)
    If !applied
        Return False
    EndIf
    String section = JMap.getStr(aiSource, "section")
    String tattooName = JMap.getStr(aiSource, "name")
    If FindApplied(applied, section, tattooName)
        JValue.release(applied)
        Return False
    EndIf
    Int template = JValue.retain(JMap.object())
    JMap.setStr(template, "section", section)
    JMap.setStr(template, "name", tattooName)
    Int matches = JValue.retain(JArray.object())
    String domain = JMap.getStr(aiSource, "domain", "default")
    Bool failed = SlaveTatsNG.query_available_tattoos(template, matches, applied, domain)
    Bool eligible = !failed && JArray.count(matches) == 1
    JValue.release(matches)
    JValue.release(template)
    JValue.release(applied)
    Return eligible
EndFunction
