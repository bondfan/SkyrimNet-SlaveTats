# SkyrimNet - SlaveTats

Status: design agreed; implementation and API/performance checks pending.

## Scope

- Prefer the simpler option when uncertain.
- Player is the only tattoo wearer managed by Apply, Display, and the UI.
- NPCs may apply tattoos to the player through SkyrimNet actions.
- No crosshair targeting or NPC tattoo tracking.
- Requirements: SkyrimNet 29, SlaveTats, SlaveTatsNG, Magelight, PapyrusUtil, JContainers, powerofthree's Papyrus Extender, and enrichment content packs.
- Implement the controller in Papyrus using the existing SlaveTatsNG, SkyrimNet, and Magelight script interfaces; no custom SKSE DLL.
- Use SlaveTatsNG's native Papyrus functions; verify availability and result semantics before implementation.
- Only tattoos represented in SlaveTats state are in scope, including those applied or removed by other mods.
- Ignore unenriched tattoos in application choices, the UI, and prompt descriptions. They still consume overlay capacity.

## Content Packs

Use plain JSON arrays under `Data/SKSE/Plugins/SkyrimNet-SlaveTats/Packs/`; see [pack format](../../docs/enrichment-packs.md).

Each enrichment entry has these fields:

| Field | Type | Purpose |
| --- | --- | --- |
| Section | string | Existing SlaveTats section. |
| Name | string | Existing SlaveTats tattoo name within that section. |
| DisplayName | string | UI label. |
| Category | string | One broad category for application selection, e.g. `bondage` or `slave`. |
| Content | string | Short description for display prompts, including literal writing, symbols, or pictures, e.g. `The word “Slave”` or `A padlock surrounded by chains`. |
| Position | enum string | One value from the fixed region list below; describes placement without controlling it. |

- Use the pair `(Section, Name)` as the stable identity; no separate integer Id.
- Keep the SlaveTats area separate from the display region: texture placement cannot be changed by selecting a region.
- Regions: Face, Neck, Chest, Belly, Back, Ass, Pubic Area, All Over; left/right Arm, Lower Leg, Upper Leg, Hand, Foot.
- Use All Over for multi-region tattoos. No partial-visibility model or region arrays.
- The player decides whether the entire tattoo is visible.
- Enrichment describes the existing texture; it does not generate lettering or imagery.
- Resolve duplicate or conflicting pack mappings explicitly during validation.

## Detection and State

- Periodically query the player's applied tattoos and compare with the previous successful snapshot.
- Add newly detected enriched tattoos using the current visibility defaults.
- Preserve visibility choices for tattoos retained between snapshots.
- Remove state when a successful snapshot confirms removal.
- A detected removal followed by reapplication creates a new tattoo using current defaults.
- Removal and reapplication between polls may remain undetected and retain the previous state; this is acceptable.
- Default-setting changes affect new tattoos only.
- Preserve state on query failure; failure is not an empty tattoo list.
- Match tattoos by stable metadata rather than overlay slot alone; slots can be reused.
- Choose the polling interval after measuring native queries. No world-wide actor scans.

## Storage

- Persist one namespaced StorageUtil integer per enriched tattoo identity on the player: missing = newly detected, `1` = hidden, `2` = visible. Store defaulted choices too; unset the key after confirmed removal.
- Loading an older save restores its choices. No JSON visibility-state document or version field is needed.
- Keep detected-tattoo snapshots, pool capacity, and enrichment indexes as runtime caches rebuilt after loading. SlaveTats remains authoritative for applied tattoos.
- Publish complete visible-tattoo summaries and compact application choices as namespaced StorageUtil strings when their contents change.
- Read prepared prompt data through SkyrimNet's built-in `papyrus_util` reader; do not scan tattoos or call a custom Papyrus decorator to fetch the summary during prompt rendering.
- Rebuild published data after loading before treating it as current; feature settings and readiness must suppress stale output.
- Keep defaults, feature toggles, and the hotkey in SkyrimNet plugin settings. Clear only this mod's StorageUtil keys.

## Display and UI

- Display has its own enable setting.
- Checked means the detected tattoo is treated as present and visible in prompts; unchecked hides its description without removing it, except during the slot 32 visibility override.
- When the player's slot 32 is empty, treat every detected enriched tattoo as visible. This is a deliberate nudity approximation regardless of equipment in other slots.
- Apply this as a temporary override; preserve checkbox choices and restore their effect when slot 32 is occupied again.
- Recheck slot 32 on save load and after equipment changes settle; coalesce equipment-event bursts and rebuild prompt output only when effective visibility changes. No per-frame checks.
- No other clothing, opacity, occlusion, or observer-specific visibility detection.
- Face is the only visible region by default. Configure defaults per region in SkyrimNet settings.
- A configurable hotkey opens a Magelight list of the player's enriched applied tattoos with visibility checkboxes.
- Configure the hotkey with the standard SkyrimNet key picker used by SkyrimNet_SexLab: assigned-key display, Set Key, and Unset; no manual scan-code entry.
- Publish current descriptions through a SkyrimNet prompt extension backed by cached state.
- Verify that additions, removals, checkbox changes, save loading, and disabling Display reach subsequent prompts.
- MTF's SkyrimNet display integration is incompatible with this Display feature. Users must disable one of the two display integrations.

## Apply

- Apply has its own enable setting, independent of Display.
- Apply only installed, enriched tattoos to the player through SlaveTatsNG's native Papyrus functions.
- Respect occupied and locked slots. Report failure without narrating successful application.
- Confirm the resulting applied state before emitting the SkyrimNet success event.
- Describe the applied texture using enrichment; do not assume its name is literal writing.
- Investigate cached capacity filtering so unavailable choices can be omitted from the action prompt.
- Capacity belongs to SlaveTats pools (Body, Face, Hands, Feet), not semantic regions. A full Body pool affects every candidate using it, including All Over.
- Include unenriched tattoos and externally occupied overlay slots when determining capacity. This does not extend tattoo-description support beyond SlaveTats.
- Recheck capacity during application because other mods can change it after prompt construction.

### Stripping

- Strip the player before tattoo application by unequipping eligible items and dropping one instance of each item form on the ground.
- Remove worn clothing and armor, including boots, gloves, and helmets; keep jewelry, weapons, and shields equipped.
- Honor `SexLabNoStrip` (`02F16E:SexLab.esm`) when available; do not add SexLab as a required dependency.
- Leave protected or undroppable items untouched; do not bypass removal restrictions.
- Select an eligible tattoo and check capacity before stripping so an empty selection does not cause unnecessary stripping.
- With multiple copies of a base item, dropping any instance after unequipping is acceptable; document in the README that the dropped copy may differ from the worn copy, including its enchantment or tempering.

### Selection

- Pack creators supply categories; no fixed category vocabulary.
- Present available category/position pairs compactly, e.g. `slave: Face, Neck` and `bondage: Back, Left Arm`.
- The LLM selects a category and position; the mod randomly selects one matching installed, enriched tattoo.
- Exclude already-applied `(Section, Name)` pairs, including tattoos hidden in the display UI.
- Apply one tattoo per action. Repeated applications of different tattoos are allowed without a cooldown or additional repetition limit.
- If no eligible candidate remains, fail without substituting another category, position, or tattoo.
- All Over identifies multi-region tattoos; it is not a wildcard for any position.
- Before selection, instruct the NPC to stay vague about the design or writing, e.g. "I’ll mark you as you deserve it." Do not promise specific wording or imagery.
- After confirmed application, narrate the selected tattoo's actual Content and Position.

## Feature Settings

- Apply and Display can each be disabled for partial compatibility with other integrations.
- Disabling Apply removes its available actions; disabling Display removes its prompt contribution.
- When both are disabled, stop periodic tattoo queries.
- Apply may still need capacity queries when Display is disabled.

## Future NPC Extension

- Keep tattoo queries and application operations actor-parameterized; pass the player in this version.
- Keep content-pack metadata independent of the wearer.
- Keep StorageUtil state and query helpers keyed to the wearer; use only the player in this version.
- Do not implement actor registries, NPC polling, crosshair targeting, NPC UI, or NPC state storage now.
- The script APIs already accept an actor; the additional cost would come from tracking actors, handling their lifecycle, persistence, prompt routing, and verification.
- NPC polling cost grows with actors and overlays examined; no runtime measurements exist yet.
- The current prompt route reads prepared player data through `papyrus_util`, avoiding the custom Papyrus decorator speaker/target restriction. Reassess prompt routing before adding NPC wearers.

## Implementation Checks

- Verify script-interface availability, JContainers handle ownership/lifetimes, callback behavior, and boolean result conventions.
- Validate one enrichment pack against installed tattoos before building the full catalog.
- Measure player tattoo enumeration and capacity queries; publish completed prompt data through StorageUtil.
- Verify external application/removal, full pools, failed queries, slot reuse, visibility persistence, and rapid remove/reapply behavior.
- Verify matching category/position choices, random selection, duplicate exclusion, empty-result failure without substitution, and repeated applications without a cooldown.
- Verify both feature toggles independently, including subsequent prompt/action refresh.
- Verify the player's tattoo summary appears when the conversation speaker is an NPC.
- Measure slot 32 checks; verify equipment swaps, save loading, and temporary all-visible behavior preserve manual checkbox choices.
- Verify stripping exclusions and one-instance ground drops, including duplicate base items and pickup of enchanted/tempered copies. Exact worn-copy selection is not required.
- Compile Papyrus scripts and verify behavior in-game; Papyrus development has no unit-test requirement.
- Record MTF code reuse or inspiration and preserve applicable attribution and license notices.

## Sources Inspected

- Original idea: `SkyrimNet - Tats.md`.
- Installed SlaveTatsNG: `G:/Modding/CSVO/mods/SlaveTatsNG/SKSE/Plugins/SlaveTatsNG/SlaveTatsNG_Interface.h`.
- Installed scripts: `G:/Modding/CSVO/mods/SlaveTatsNG/Source/Scripts/SlaveTats.psc` and `G:/Modding/CSVO/mods/SlaveTatsNG/Scripts/Source/SlaveTatsNG.psc`.
- SkyrimNet script API: `G:/Modding/CSVO/mods/skyrimnet/Source/Scripts/SkyrimNetApi.psc`; prompt/content documentation in `../skyrimnet-devkit-beta29.1-rc2/docs/modding/`.
- Magelight: `G:/Modding/CSVO/mods/Magelight UI/Source/Scripts/Magelight.psc`.
- StorageUtil: `G:/Modding/CSVO/mods/PapyrusUtil SE - Modders Scripting Utility Functions/Scripts/Source/StorageUtil.psc`.
- Installed SexLab keyword: `SexLabNoStrip`, `02F16E:SexLab.esm`; stripping documentation in `G:/Modding/CSVO/mods/SexLab Framework PPLUS/Source/Scripts/SexLabFramework.psc`.
- [SKSE worn-slot query declaration](https://github.com/ianpatt/skse64/blob/master/scripts/modified/Actor.psc).
- [MTF source and integration documentation](https://github.com/levchimik/magic-tattoos-framework).

Move this plan to `.agents/plans/completed` after implementation and verification.

- Convert the SkyrimNet picker's Windows VK values to DirectInput scan codes in Papyrus. Support F1–F12, numpad digits/operators, arrows, Home/End, Page Up/Down, Insert/Delete; reject other keys. No SexLab converter dependency.
