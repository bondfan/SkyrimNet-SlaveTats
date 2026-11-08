Scriptname SNT_Main extends Quest

Int _catalog
Int _applied
Bool _refreshing
Bool _reloadCatalog = True
Int _view
Int _sources
Int _candidates
Bool _applying
Int _generation
Int _hotkey
Int _configuredHotkey = -2

Event OnInit()
    Initialize()
EndEvent

Function Initialize()
    _generation += 1
    _refreshing = False
    _reloadCatalog = True
    RegisterForModEvent("SkyrimNet_OnPluginConfigSaved", "OnSettingsSaved")
    RegisterForModEvent("Magelight_ViewDomReady", "OnViewReady")
    RegisterForModEvent("Magelight_UIModeEntered", "OnViewReady")
    RegisterForModEvent("Magelight_UIModeExited", "OnCloseUI")
    RegisterForModEvent("Magelight_JS_snt_visibility", "OnVisibilityChanged")
    RegisterForModEvent("Magelight_JS_snt_close", "OnCloseUI")
    RegisterForSingleUpdate(1.0)
EndFunction

Event OnSettingsSaved(String eventName, String strArg, Float numArg, Form sender)
    RequestRefresh()
EndEvent

Function RequestRefresh()
    RegisterForSingleUpdate(0.5)
EndFunction

Event OnUpdate()
    Actor wearer = Game.GetPlayer()
    If !wearer
        RegisterForSingleUpdate(1.0)
        Return
    EndIf
    If _refreshing || _applying
        RegisterForSingleUpdate(1.0)
        Return
    EndIf
    _refreshing = True
    SetupUI()
    If _reloadCatalog
        StorageUtil.SetStringValue(wearer, "SNT_VisibleTattoos", "")
        StorageUtil.SetStringValue(wearer, "SNT_AvailableTattoos", "")
        StorageUtil.SetIntValue(wearer, "SNT_Ready", 0)
        _catalog = JValue.release(_catalog)
        _applied = JValue.release(_applied)
        _sources = JValue.release(_sources)
        _candidates = JValue.release(_candidates)
        _applying = False
        StorageUtil.SetIntValue(None, "SNT_ApplyReady", 0)
        _catalog = SNT_Catalog.Load()
        _reloadCatalog = _catalog == 0
        Debug.Trace("[SNT] Controller initialized; SkyrimNet=" + SkyrimNetApi.GetBuildVersion())
        Debug.Trace("[SNT] Enrichment entries=" + JMap.count(_catalog))
    EndIf
    Bool displayEnabled = SkyrimNetApi.GetConfigBool("Plugin_SNT", "features.display", True)
    Bool applyEnabled = SkyrimNetApi.GetConfigBool("Plugin_SNT", "features.apply", True)
    If !displayEnabled
        StorageUtil.SetStringValue(wearer, "SNT_VisibleTattoos", "")
    EndIf
    If _catalog && (displayEnabled || applyEnabled)
        RefreshTattoos(wearer, displayEnabled)
        RefreshCandidates(wearer, applyEnabled)
    EndIf
    _refreshing = False
    If displayEnabled || applyEnabled
        RegisterForSingleUpdate(15.0)
    EndIf
EndEvent

Function RefreshTattoos(Actor akWearer, Bool abDisplay)
    Int snapshot = SNT_SlaveTats.AppliedSnapshot(akWearer)
    If !snapshot
        Return
    EndIf
    Int current = JValue.retain(JMap.object())
    Int index = 0
    String summary = ""
    Bool nude = akWearer.GetWornForm(Armor.GetMaskForSlot(32)) == None
    While index < JArray.count(snapshot)
        Int tattoo = JArray.getObj(snapshot, index)
        String section = JMap.getStr(tattoo, "section")
        String tattooName = JMap.getStr(tattoo, "name")
        String identity = SNT_Storage.VisibilityKey(section, tattooName)
        JMap.setObj(current, identity, tattoo)
        Int enriched = JMap.getObj(_catalog, identity)
        If enriched
            Int visibility = SNT_Storage.GetVisibility(akWearer, section, tattooName)
            String position = JMap.getStr(enriched, "Position")
            If visibility == 0
                Bool defaultVisible = SkyrimNetApi.GetConfigBool("Plugin_SNT", "visibility." + position, position == "Face")
                SNT_Storage.SetVisibility(akWearer, section, tattooName, defaultVisible)
                visibility = SNT_Storage.GetVisibility(akWearer, section, tattooName)
            EndIf
            If abDisplay && (nude || visibility == 2)
                If summary != ""
                    summary += "; "
                EndIf
                summary += position + ": " + JMap.getStr(enriched, "Content")
            EndIf
        EndIf
        index += 1
    EndWhile
    If _applied
        Int previousKeys = JValue.retain(JMap.allKeys(_applied))
        index = 0
        While index < JArray.count(previousKeys)
            String previousIdentity = JArray.getStr(previousKeys, index)
            If !JMap.hasKey(current, previousIdentity)
                StorageUtil.UnsetIntValue(akWearer, previousIdentity)
            EndIf
            index += 1
        EndWhile
        JValue.release(previousKeys)
    Else
        String[] savedKeys = StorageUtil.debug_AllObjIntKeys(akWearer)
        index = 0
        While index < savedKeys.Length
            If StringUtil.Substring(savedKeys[index], 0, 15) == "SNT_Visibility:" && !ContainsIdentity(current, savedKeys[index])
                StorageUtil.UnsetIntValue(akWearer, savedKeys[index])
            EndIf
            index += 1
        EndWhile
    EndIf
    _applied = JValue.release(_applied)
    _applied = current
    JValue.release(snapshot)
    If StorageUtil.GetStringValue(akWearer, "SNT_VisibleTattoos", "") != summary
        StorageUtil.SetStringValue(akWearer, "SNT_VisibleTattoos", summary)
    EndIf
    StorageUtil.SetIntValue(akWearer, "SNT_Ready", 1)
    UpdateUI()
EndFunction

Bool Function ApplyTattoo(Actor akInitiator, String asCategory, String asPosition)
    If !akInitiator || _applying || _refreshing || !_candidates
        Return False
    EndIf
    If !SkyrimNetApi.GetConfigBool("Plugin_SNT", "features.apply", True)
        Return False
    EndIf
    _applying = True
    StorageUtil.SetIntValue(None, "SNT_ApplyReady", 0)
    Int generation = _generation
    Actor wearer = Game.GetPlayer()
    Int matches = JValue.retain(JMap.object())
    Int identities = JValue.retain(JMap.allKeys(_candidates))
    Int index = 0
    While index < JArray.count(identities)
        String identity = JArray.getStr(identities, index)
        Int enriched = JMap.getObj(_candidates, identity)
        If JMap.getStr(enriched, "Category") == asCategory && JMap.getStr(enriched, "Position") == asPosition
            Int sourceTattoo = JMap.getObj(_sources, identity)
            If SNT_SlaveTats.CanApply(wearer, sourceTattoo)
                JMap.setObj(matches, identity, enriched)
            EndIf
        EndIf
        index += 1
    EndWhile
    JValue.release(identities)
    identities = JValue.retain(JMap.allKeys(matches))
    Int count = JArray.count(identities)
    Bool confirmed = False
    If count > 0 && generation == _generation
        String identity = JArray.getStr(identities, Utility.RandomInt(0, count - 1))
        Int enriched = JMap.getObj(matches, identity)
        Int sourceTattoo = JMap.getObj(_sources, identity)
        SNT_Equipment.StripAndDrop(wearer)
        If generation == _generation && SNT_SlaveTats.CanApply(wearer, sourceTattoo)
            Bool applied = SNT_SlaveTats.Apply(wearer, sourceTattoo)
            Int snapshot = SNT_SlaveTats.AppliedSnapshot(wearer)
            confirmed = applied && snapshot && SNT_SlaveTats.FindApplied(snapshot, JMap.getStr(enriched, "Section"), JMap.getStr(enriched, "Name")) != 0
            JValue.release(snapshot)
            If confirmed && generation == _generation
                SkyrimNetApi.DirectNarration("The initiating character has applied a tattoo to the player: " + JMap.getStr(enriched, "Content") + " on " + JMap.getStr(enriched, "Position") + ".", akInitiator, wearer)
            EndIf
        EndIf
    EndIf
    JValue.release(identities)
    JValue.release(matches)
    _applying = False
    RequestRefresh()
    If !confirmed
        Debug.Trace("[SNT] Tattoo application did not complete; no success event emitted", 1)
    EndIf
    Return confirmed
EndFunction

Function RefreshCandidates(Actor akWearer, Bool abEnabled)
    StorageUtil.SetIntValue(None, "SNT_ApplyReady", 0)
    If !abEnabled || !_applied
        StorageUtil.SetStringValue(akWearer, "SNT_AvailableTattoos", "")
        Return
    EndIf
    If !_sources
        Int available = SNT_SlaveTats.AvailableSnapshot()
        If !available
            Return
        EndIf
        _sources = JValue.retain(JMap.object())
        Int sourceIndex = 0
        While sourceIndex < JArray.count(available)
            Int sourceTattoo = JArray.getObj(available, sourceIndex)
            String sourceIdentity = SNT_Storage.VisibilityKey(JMap.getStr(sourceTattoo, "section"), JMap.getStr(sourceTattoo, "name"))
            If JMap.hasKey(_catalog, sourceIdentity) && SNT_SlaveTats.Pool(sourceTattoo) != ""
                JMap.setObj(_sources, sourceIdentity, sourceTattoo)
            EndIf
            sourceIndex += 1
        EndWhile
        JValue.release(available)
        Debug.Trace("[SNT] Installed enriched tattoo sources=" + JMap.count(_sources))
    EndIf
    _candidates = JValue.release(_candidates)
    _candidates = JValue.retain(JMap.object())
    Int pairs = JValue.retain(JMap.object())
    Int pools = JValue.retain(JMap.object())
    Int identities = JValue.retain(JMap.allKeys(_sources))
    Int index = 0
    While index < JArray.count(identities)
        String identity = JArray.getStr(identities, index)
        Int sourceTattoo = JMap.getObj(_sources, identity)
        String poolName = SNT_SlaveTats.Pool(sourceTattoo)
        If !JMap.hasKey(pools, poolName)
            JMap.setInt(pools, poolName, SNT_SlaveTats.HasFreeSlot(akWearer, poolName) as Int)
        EndIf
        If !JMap.hasKey(_applied, identity) && JMap.getInt(pools, poolName) == 1
            Int enriched = JMap.getObj(_catalog, identity)
            JMap.setObj(_candidates, identity, enriched)
            String category = JMap.getStr(enriched, "Category")
            Int positions = JMap.getObj(pairs, category)
            If !positions
                positions = JValue.retain(JMap.object())
                JMap.setObj(pairs, category, positions)
                JValue.release(positions)
            EndIf
            JMap.setInt(positions, JMap.getStr(enriched, "Position"), 1)
        EndIf
        index += 1
    EndWhile
    JValue.release(identities)
    JValue.release(pools)
    Int categories = JValue.retain(JMap.allKeys(pairs))
    String choices = ""
    index = 0
    While index < JArray.count(categories)
        String category = JArray.getStr(categories, index)
        If choices != ""
            choices += "; "
        EndIf
        choices += category + ": "
        Int positions = JValue.retain(JMap.allKeys(JMap.getObj(pairs, category)))
        Int positionIndex = 0
        While positionIndex < JArray.count(positions)
            If positionIndex > 0
                choices += ", "
            EndIf
            choices += JArray.getStr(positions, positionIndex)
            positionIndex += 1
        EndWhile
        JValue.release(positions)
        index += 1
    EndWhile
    JValue.release(categories)
    JValue.release(pairs)
    StorageUtil.SetStringValue(akWearer, "SNT_AvailableTattoos", choices)
    If choices != "" && !_applying
        StorageUtil.SetIntValue(None, "SNT_ApplyReady", 1)
    EndIf
EndFunction

Function SetupUI()
    If !Magelight.IsReady()
        Return
    EndIf
    If !Magelight.RegisterMod("skyrimnet-slavetats", "SkyrimNet - SlaveTats")
        Return
    EndIf
    _view = Magelight.FindView("skyrimnet-slavetats", "visibility")
    If !_view
        _view = Magelight.CreateView("skyrimnet-slavetats", "visibility", "index.html", 80, 60, 900, 650, "popup")
    EndIf
    If !_view
        Return
    EndIf
    Magelight.RegisterListener(_view, "snt_visibility")
    Magelight.RegisterListener(_view, "snt_close")
    Magelight.BindHotkey(_view, 0, 0)
    Int virtualKey = SkyrimNetApi.GetConfigInt("Plugin_SNT", "ui.hotkey", 0)
    Int hotkey = HotkeyScanCode(virtualKey)
    If _configuredHotkey != virtualKey
        _configuredHotkey = virtualKey
        Debug.Trace("[SNT] Visibility key VK=" + virtualKey + "; DX=" + hotkey)
        If virtualKey > 0 && hotkey == 0
            Debug.Notification("Tattoo hotkey unsupported. Choose a function, numpad, or navigation key.")
        EndIf
    EndIf
    If _hotkey != hotkey
        If _hotkey > 0
            UnregisterForKey(_hotkey)
        EndIf
        _hotkey = hotkey
        Debug.Trace("[SNT] Visibility key=" + _hotkey)
    EndIf
    If _hotkey > 0
        RegisterForKey(_hotkey)
    EndIf
EndFunction

; The dashboard stores VK codes; SKSE consumes DirectInput scan codes.
; Restrict conversion to keys independent of letter/punctuation layout.
Int Function HotkeyScanCode(Int virtualKey)
    If virtualKey >= 112 && virtualKey <= 121
        Return virtualKey - 53
    EndIf
    If virtualKey == 122 || virtualKey == 123
        Return virtualKey - 35
    EndIf
    If virtualKey >= 96 && virtualKey <= 105
        Int[] numpad = new Int[10]
        numpad[0] = 82
        numpad[1] = 79
        numpad[2] = 80
        numpad[3] = 81
        numpad[4] = 75
        numpad[5] = 76
        numpad[6] = 77
        numpad[7] = 71
        numpad[8] = 72
        numpad[9] = 73
        Return numpad[virtualKey - 96]
    EndIf
    If virtualKey == 106
        Return 55
    EndIf
    If virtualKey == 107
        Return 78
    EndIf
    If virtualKey == 109
        Return 74
    EndIf
    If virtualKey == 110
        Return 83
    EndIf
    If virtualKey == 111
        Return 181
    EndIf
    If virtualKey >= 33 && virtualKey <= 40
        Int[] navigation = new Int[8]
        navigation[0] = 201
        navigation[1] = 209
        navigation[2] = 207
        navigation[3] = 199
        navigation[4] = 203
        navigation[5] = 200
        navigation[6] = 205
        navigation[7] = 208
        Return navigation[virtualKey - 33]
    EndIf
    If virtualKey == 45
        Return 210
    EndIf
    If virtualKey == 46
        Return 211
    EndIf
    Return 0
EndFunction

Event OnKeyDown(Int keyCode)
    If keyCode != _hotkey || _hotkey <= 0
        Return
    EndIf
    Debug.Trace("[SNT] Visibility key pressed; menu=" + Utility.IsInMenuMode())
    If Magelight.GetUIModeView() == _view && _view
        Magelight.ReleaseUIMode("skyrimnet-slavetats")
        Magelight.ShowView(_view, False)
        Return
    EndIf
    If Utility.IsInMenuMode() || Magelight.IsUIModeActive()
        Return
    EndIf
    OpenUI()
EndEvent

Function OpenUI()
    SetupUI()
    If !_view
        Return
    EndIf
    Magelight.ShowView(_view, True)
    If Magelight.RequestUIMode(_view)
        UpdateUI()
    Else
        Magelight.ShowView(_view, False)
    EndIf
EndFunction

Event OnViewReady(String eventName, String strArg, Float numArg, Form sender)
    If numArg as Int == _view
        If eventName == "Magelight_UIModeEntered"
            Magelight.ShowView(_view, True)
        EndIf
        UpdateUI()
    EndIf
EndEvent

Event OnCloseUI(String eventName, String strArg, Float numArg, Form sender)
    If numArg as Int != _view
        Return
    EndIf
    Magelight.ReleaseUIMode("skyrimnet-slavetats")
    Magelight.ShowView(_view, False)
EndEvent

Event OnVisibilityChanged(String eventName, String strArg, Float numArg, Form sender)
    If numArg as Int != _view || !_applied || _refreshing
        Return
    EndIf
    String identity = SkyrimNetApi.GetJsonString(strArg, "identity", "")
    Int enriched = JMap.getObj(_catalog, identity)
    Int visibility = SkyrimNetApi.GetJsonInt(strArg, "visibility", 0)
    If !enriched || !JMap.hasKey(_applied, identity) || (visibility != 1 && visibility != 2)
        Return
    EndIf
    SNT_Storage.SetVisibility(Game.GetPlayer(), JMap.getStr(enriched, "Section"), JMap.getStr(enriched, "Name"), visibility == 2)
    RequestRefresh()
EndEvent

Function UpdateUI()
    If !_view || !Magelight.IsVisible(_view)
        Return
    EndIf
    Actor wearer = Game.GetPlayer()
    Int uiState = JValue.retain(JMap.object())
    Int rows = JValue.retain(JArray.object())
    JMap.setObj(uiState, "tattoos", rows)
    If wearer.GetWornForm(Armor.GetMaskForSlot(32)) == None
        JMap.setInt(uiState, "nude", 1)
    EndIf
    Int identities = JValue.retain(JMap.allKeys(_applied))
    Int index = 0
    While index < JArray.count(identities)
        String identity = JArray.getStr(identities, index)
        Int enriched = JMap.getObj(_catalog, identity)
        If enriched
            Int row = JValue.retain(JMap.object())
            JMap.setStr(row, "identity", identity)
            JMap.setStr(row, "name", JMap.getStr(enriched, "DisplayName"))
            JMap.setStr(row, "position", JMap.getStr(enriched, "Position"))
            JMap.setInt(row, "visibility", StorageUtil.GetIntValue(wearer, identity, 1))
            JArray.addObj(rows, row)
            JValue.release(row)
        EndIf
        index += 1
    EndWhile
    Magelight.Call(_view, "setState", JValue.toJsonString(uiState))
    JValue.release(identities)
    JValue.release(rows)
    JValue.release(uiState)
EndFunction

Bool Function ContainsIdentity(Int aiMap, String asIdentity)
    Int identities = JValue.retain(JMap.allKeys(aiMap))
    Int index = 0
    Bool found = False
    While index < JArray.count(identities) && !found
        found = JArray.getStr(identities, index) == asIdentity
        index += 1
    EndWhile
    JValue.release(identities)
    Return found
EndFunction
