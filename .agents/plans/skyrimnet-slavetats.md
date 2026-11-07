# SkyrimNet - SlaveTats

Status: design agreed where specified; implementation pending.

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

- Map an installed SlaveTats tattoo to a stable identity, readable name, description, and one display region.
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
- Checked means the detected tattoo is treated as present and visible in prompts; unchecked hides its description without removing it.
- No clothing, opacity, occlusion, or observer-specific visibility detection.
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
- Exact candidate selection, categories, empty-result behavior, and repetition limits remain open.

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
- Verify both feature toggles independently, including subsequent prompt/action refresh.
- Verify the player's tattoo summary appears when the conversation speaker is an NPC.
- Record MTF code reuse or inspiration and preserve applicable attribution and license notices.

## Sources inspected

- Original idea: `SkyrimNet - Tats.md`.
- Installed SlaveTatsNG: `G:/Modding/CSVO/mods/SlaveTatsNG/SKSE/Plugins/SlaveTatsNG/SlaveTatsNG_Interface.h`.
- Installed scripts: `G:/Modding/CSVO/mods/SlaveTatsNG/Source/Scripts/SlaveTats.psc` and `G:/Modding/CSVO/mods/SlaveTatsNG/Scripts/Source/SlaveTatsNG.psc`.
- SkyrimNet 29 devkit: `../skyrimnet-devkit-beta29.1-rc2/CppAPI/PublicAPI.h` and `docs/modding/prompts-and-decorators.md` within that devkit.
- Magelight: `G:/Modding/CSVO/mods/Magelight UI/Source/Scripts/Magelight.psc`.
- [MTF source and integration documentation](https://github.com/levchimik/magic-tattoos-framework).

Move this plan to `.agents/plans/completed` after implementation and verification.
