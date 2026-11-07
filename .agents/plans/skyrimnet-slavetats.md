# SkyrimNet - SlaveTats

Status: design agreed; implementation and API/performance checks pending.

## Scope

- Prefer the simpler option when uncertain.
- Player is the only tattoo wearer managed by Apply, Display, and the UI.
- NPCs may apply tattoos to the player through SkyrimNet actions.
- No crosshair targeting or NPC tattoo tracking.
- Requirements: SkyrimNet 29, SlaveTats, SlaveTatsNG, Magelight, and enrichment content packs.
- Use SlaveTatsNG's native API; verify supported interface versions and result semantics before implementation.
- Only tattoos represented in SlaveTats state are in scope, including those applied or removed by other mods.
- Ignore unenriched tattoos in application choices, the UI, and prompt descriptions. They still consume overlay capacity.

## Content packs

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
- Regions: Face, Neck, Back, Ass, Pubic Area, All Over; left/right Arm, Lower Leg, Upper Leg, Hand, Foot.
- Use All Over for multi-region tattoos. No partial-visibility model or region arrays.
- The player decides whether the entire tattoo is visible.
- Enrichment describes the existing texture; it does not generate lettering or imagery.
- Resolve duplicate or conflicting pack mappings explicitly during validation.

## Detection and state

- Periodically query the player's applied tattoos and compare with the previous successful snapshot.
- Add newly detected enriched tattoos using the current visibility defaults.
- Preserve visibility choices for tattoos retained between snapshots.
- Remove state when a successful snapshot confirms removal.
- A detected removal followed by reapplication creates a new tattoo using current defaults.
- Removal and reapplication between polls may remain undetected and retain the previous state; this is acceptable.
- Default-setting changes affect new tattoos only.
- Preserve state on query failure; failure is not an empty tattoo list.
- Save visibility choices with the save game; loading an older save must restore its choices and rebuild transient caches.
- Match tattoos by stable metadata rather than overlay slot alone; slots can be reused.
- Cache prompt output and rebuild it when relevant state changes. Do not query SlaveTats while rendering prompts.
- Choose the polling interval after measuring native queries. No world-wide actor scans.

## Display and UI

- Display has its own enable setting.
- Checked means the detected tattoo is treated as present and visible in prompts; unchecked hides its description without removing it, except during the slot 32 visibility override.
- When the player's slot 32 is empty, treat every detected enriched tattoo as visible. This is a deliberate nudity approximation regardless of equipment in other slots.
- Apply this as a temporary override; preserve checkbox choices and restore their effect when slot 32 is occupied again.
- Recheck slot 32 on save load and after equipment changes settle; coalesce equipment-event bursts and rebuild prompt output only when effective visibility changes. No per-frame checks.
- No other clothing, opacity, occlusion, or observer-specific visibility detection.
- Face is the only visible region by default. Configure defaults per region in SkyrimNet settings.
- A configurable hotkey opens a Magelight list of the player's enriched applied tattoos with visibility checkboxes.
- Publish current descriptions through a SkyrimNet prompt extension backed by cached state.
- Verify that additions, removals, checkbox changes, save loading, and disabling Display reach subsequent prompts.
- MTF's SkyrimNet display integration is incompatible with this Display feature. Users must disable one of the two display integrations.

## Apply

- Apply has its own enable setting, independent of Display.
- Apply only installed, enriched tattoos to the player through the native API.
- Respect occupied and locked slots. Report failure without narrating successful application.
- Confirm the resulting applied state before emitting the SkyrimNet success event.
- Describe the applied texture using enrichment; do not assume its name is literal writing.
- Investigate cached capacity filtering so unavailable choices can be omitted from the action prompt.
- Capacity belongs to SlaveTats pools (Body, Face, Hands, Feet), not semantic regions. A full Body pool affects every candidate using it, including All Over.
- Include unenriched tattoos and externally occupied overlay slots when determining capacity. This does not extend tattoo-description support beyond SlaveTats.
- Recheck capacity during application because other mods can change it after prompt construction.

### Stripping

- Strip the player before tattoo application and drop the removed worn items on the ground.
- Remove worn clothing and armor, including boots, gloves, and helmets; keep jewelry and weapons equipped.
- Honor `SexLabNoStrip` (`02F16E:SexLab.esm`) when available; do not add SexLab as a required dependency.
- Leave protected or undroppable items untouched; do not bypass removal restrictions.
- Select an eligible tattoo and check capacity before stripping so an empty selection does not cause unnecessary stripping.
- Verify removal and dropping preserve the worn item instances, including enchantments and tempering, without dropping extra inventory copies.

### Selection

- Pack creators supply categories; no fixed category vocabulary.
- Present available category/position pairs compactly, e.g. `slave: Face, Neck` and `bondage: Back, Left Arm`.
- The LLM selects a category and position; the mod randomly selects one matching installed, enriched tattoo.
- Exclude already-applied `(Section, Name)` pairs, including tattoos hidden in the display UI.
- Apply one tattoo per action. Repeated applications of different tattoos are allowed without a cooldown or additional repetition limit.
- If no eligible candidate remains, fail without substituting another category, position, or tattoo.
- All Over identifies multi-region tattoos; it is not a wildcard for any position.
- Before selection, instruct the NPC to stay vague about the design or writing, e.g. “I’ll mark you as you deserve it.” Do not promise specific wording or imagery.
- After confirmed application, narrate the selected tattoo's actual Content and Position.

## Feature settings

- Apply and Display can each be disabled for partial compatibility with other integrations.
- Disabling Apply removes its available actions; disabling Display removes its prompt contribution.
- When both are disabled, stop periodic tattoo queries.
- Apply may still need capacity queries when Display is disabled.

## Future NPC extension

- Keep tattoo queries and application operations actor-parameterized; pass the player in this version.
- Keep content-pack metadata independent of the wearer.
- Isolate persistence and prompt output so an actor key can be added later.
- Do not implement actor registries, NPC polling, crosshair targeting, NPC UI, or NPC state storage now.
- Native APIs already accept an actor; the additional cost would come from tracking actors, handling their lifecycle, persistence, prompt routing, and testing.
- NPC polling cost grows with actors and overlays examined; no runtime measurements exist yet.
- The devkit's speaker/target restriction documents Papyrus decorators. Its native decorator API accepts an actor and does not document the same restriction; do not treat the Papyrus warning as proof that native NPC support is blocked.

## Implementation checks

- Verify native interface availability, query ownership/lifetimes, thread requirements, and boolean result conventions. The shipped header marks several query helpers as implementation details.
- Validate one enrichment pack against installed tattoos before building the full catalog.
- Measure player tattoo enumeration and capacity queries; serve cached data to SkyrimNet callbacks.
- Verify external application/removal, full pools, failed queries, slot reuse, visibility persistence, and rapid remove/reapply behavior.
- Verify matching category/position choices, random selection, duplicate exclusion, empty-result failure without substitution, and repeated applications without a cooldown.
- Verify both feature toggles independently, including subsequent prompt/action refresh.
- Verify the player's tattoo summary appears when the conversation speaker is an NPC.
- Measure slot 32 checks; verify equipment swaps, save loading, and temporary all-visible behavior preserve manual checkbox choices.
- Verify stripping exclusions, ground drops, and worn-instance preservation, including multiple copies of the same base item.
- Record MTF code reuse or inspiration and preserve applicable attribution and license notices.

## Sources inspected

- Original idea: `SkyrimNet - Tats.md`.
- Installed SlaveTatsNG: `G:/Modding/CSVO/mods/SlaveTatsNG/SKSE/Plugins/SlaveTatsNG/SlaveTatsNG_Interface.h`.
- Installed scripts: `G:/Modding/CSVO/mods/SlaveTatsNG/Source/Scripts/SlaveTats.psc` and `G:/Modding/CSVO/mods/SlaveTatsNG/Scripts/Source/SlaveTatsNG.psc`.
- SkyrimNet 29 devkit: `../skyrimnet-devkit-beta29.1-rc2/CppAPI/PublicAPI.h` and `docs/modding/prompts-and-decorators.md` within that devkit.
- Magelight: `G:/Modding/CSVO/mods/Magelight UI/Source/Scripts/Magelight.psc`.
- Installed SexLab keyword: `SexLabNoStrip`, `02F16E:SexLab.esm`; stripping documentation in `G:/Modding/CSVO/mods/SexLab Framework PPLUS/Source/Scripts/SexLabFramework.psc`.
- [SKSE worn-slot query declaration](https://github.com/ianpatt/skse64/blob/master/scripts/modified/Actor.psc).
- [MTF source and integration documentation](https://github.com/levchimik/magic-tattoos-framework).

Move this plan to `.agents/plans/completed` after implementation and verification.
