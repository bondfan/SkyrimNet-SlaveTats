# Storage and Runtime Evaluation

Status: historical evaluation. The user adopted Papyrus and StorageUtil and accepted dropping any duplicate instance after unequipping. The updated plans supersede the decision gates below. No gameplay or performance tests were run.

## Recommendation

Use Papyrus orchestration with StorageUtil for visibility persistence and prompt publication. Query tattoos through SlaveTatsNG's existing native Papyrus functions. Evaluate unequip-and-drop with representative inventory items before deciding whether a custom DLL is needed.

| Data | Proposed owner | Lifecycle |
| --- | --- | --- |
| Known tattoo identities and saved visibility | One namespaced StorageUtil state value on the player | Save-local; retain hidden/defaulted entries as well as checked entries. |
| Applied-tattoo and capacity snapshots | Runtime cache sourced from SlaveTatsNG | Refresh periodically and rebuild after loading; preserve a successful snapshot on query failure. |
| Enrichment catalog and indexes | Runtime data loaded from pack files | Rebuild after loading; avoid copying complete entries into persistent player state. |
| Published visible-tattoo summary | One namespaced StorageUtil string on the player | Replace when effective output changes; rebuild after loading before treating it as current. |
| Defaults, toggles, hotkey | SkyrimNet plugin settings | Keep the agreed settings backend. |

StorageUtil stores values in memory and serializes them through SKSE save/load/revert callbacks. A stored prompt string can be both a runtime publication cache and serialized data; serialization does not make it authoritative after loading.

## Visibility

- Store every known enriched identity with its saved visibility, not only checked tattoos or deviations from defaults. Membership distinguishes retained tattoos from newly detected tattoos after loading.
- A versioned serialized object is a candidate representation; choose its exact encoding before implementation.
- StorageUtil documents that setting an integer to zero unsets the key. An absent key must not be confused with an explicitly hidden tattoo; an alternative encoding or a serialized object must preserve that distinction.
- Keep the slot 32 override derived. It never rewrites saved choices.
- Remove stored entries only after successful reconciliation confirms removal.
- Prefix storage keys and clear only this mod's own values.

## Detected Tattoos and Prompt Cache

- SlaveTats remains authoritative for applied tattoos. Do not persist a second complete tattoo database.
- Persisted visibility records already retain the identities needed to recognize previously detected enriched tattoos.
- Rebuild active snapshots, pool capacity, catalog indexes, and prompt output after loading. Treat script variables or JContainers handles restored by a save as needing revalidation.
- Render prompts from a prepared StorageUtil summary through SkyrimNet's built-in `papyrus_util` reader. No Papyrus scan or custom Papyrus decorator is needed during prompt rendering for the summary.
- Rebuild the summary after tattoo changes, checkbox changes, effective nudity changes, settings changes, and initialization after loading. Disabling Display must suppress output even if an old summary exists.
- The built-in reader does not eliminate outer prompt-cache behavior; verify the completed prompt after updates.
- A single prepared string avoids exposing a partly updated collection of per-tattoo prompt fields. Write it after preparing a complete replacement; verify runtime behavior rather than assuming a multi-key transaction.

## What a Custom DLL Adds

| Area | Gain | Relevance here |
| --- | --- | --- |
| Tattoo operations | Fewer VM transitions and direct native data structures | SlaveTatsNG already performs its query/application work natively; no measured need for another DLL for one periodically checked player. |
| Scheduling and events | Native queues, event sinks, and direct cache access | Papyrus already exposes updates and player equipment events; delay is acceptable. |
| Inventory instances | Access to worn-item extra data and native instance-aware drop arguments | Concrete potential gain for duplicate base items with different enchantments or tempering. |
| Testing and diagnostics | Conventional C++ core tests, profiling, structured models | Useful, but adds a native build, runtime compatibility, thread/lifetime management, and integration ownership. |
| Save-local storage | Direct SKSE serialization of the plugin's own state | Avoids StorageUtil calls but requires implementing a persistence format and callbacks. |

The installed SlaveTatsNG script declares native enumeration, pool, and application functions. Magelight exposes script-owned views, page callbacks, and hotkeys. SkyrimNet exposes Papyrus actions, events, decorators, and configuration getters. These declarations establish available interfaces, not a tested complete implementation.

If the whole controller stays in C++, direct SKSE serialization and C++ memory caches remain a coherent alternative. The installed PapyrusUtil DLL exports only `SKSEPlugin_Load` and `SKSEPlugin_Version`, and its package ships no C++ SDK. StorageUtil can be invoked through the VM; no supported direct native writer was established. Do not build another private-memory-offset bridge.

## Unequip and Drop

Unequipping a clothing form and dropping one instance is the simple initial approach to evaluate. The script drop API takes a Form and count; it does not take the native per-instance extra-data pointer.

With duplicate base items, unequipping does not by itself identify the removed instance for the later drop. Test worn enchanted/tempered equipment alongside spare copies, including inspection and re-equipping after pickup. Also test multi-slot armor and the agreed exclusions. No failure in those tests has been observed in this task.

Native `Actor::DropObject` accepts an `ExtraDataList*`, making it a candidate if exact-instance selection needs native support. That declaration alone does not prove an implementation preserves the item correctly.

If existing APIs cannot satisfy the agreed item behavior, present the blocker and the choice of a native helper or revised behavior before changing architecture. A performance claim alone does not justify a custom DLL without measurements.

## Evidence

- Installed PapyrusUtil 4.6 script and readme: `G:/Modding/CSVO/mods/PapyrusUtil SE - Modders Scripting Utility Functions/`.
- Static PE inspection of its winning DLL found only the two SKSE exports named above.
- [PapyrusUtil storage containers](https://github.com/eeveelo/PapyrusUtil/blob/master/Data.h) and [save/load callback registration](https://github.com/eeveelo/PapyrusUtil/blob/master/main.cpp).
- [StorageUtil script documentation](https://github.com/eeveelo/PapyrusUtil/blob/master/Scripts/Source/StorageUtil.psc).
- [SkyrimNet's native StorageUtil prompt reader](https://goncalo22.github.io/SkyrimNet-GamePlugin/blog/2025/12/18/beta11-release/).
- Local SkyrimNet prompt example: `../SkyrimNet-GamePlugin/plugins/skyrimnet/base/prompts/submodules/test_decorators/0800_omnisight_state_decorators.prompt`.
- Existing local publication example: `../SLSFR-SkyrimNet/Data/SKSE/Plugins/SkyrimNet/external/housecarl.slsfr/prompts/submodules/user_final_instructions/0850_snrf_reputation.prompt`.
- Winning script declarations: `G:/Modding/CSVO/mods/SlaveTatsNG/Scripts/Source/SlaveTatsNG.psc`, `G:/Modding/CSVO/mods/Magelight UI/Source/Scripts/Magelight.psc`, and `G:/Modding/CSVO/mods/skyrimnet/Source/Scripts/SkyrimNetApi.psc`.
- [Vanilla script drop declaration](https://github.com/ianpatt/skse64/blob/master/scripts/vanilla/ObjectReference.psc), [native actor drop declaration](https://github.com/alandtse/CommonLibVR/blob/ng/include/RE/A/Actor.h), and [VM static-call interface](https://github.com/alandtse/CommonLibVR/blob/ng/include/RE/I/IVirtualMachine.h).
