# SkyrimNet - SlaveTats: implementation plan

Status: not started. This document schedules implementation; it does not authorize changes to the agreed behavior.

Specification: [skyrimnet-slavetats.md](skyrimnet-slavetats.md). Original idea: [SkyrimNet - Tats.md](../../SkyrimNet%20-%20Tats.md).

## Boundaries

- Player wearers only; NPCs can initiate application. Keep actor parameters at integration boundaries without implementing NPC tracking.
- Build one native SKSE plugin with SlaveTatsNG, SkyrimNet, and Magelight adapters. Keep catalog, reconciliation, visibility, and selection logic independent of game APIs.
- Keep one build and verification setup. Confirm unresolved technical choices before adding dependencies or changing structure.
- Stage added files; do not commit. Use UTF-8 without BOM.
- For later business-logic bug fixes, first reproduce the failure with a test, then fix it and observe the test pass.

## 1. Verify integration contracts and toolchain

- [ ] Confirm the active game runtime, SKSE, SkyrimNet 29 API, SlaveTatsNG interface, Magelight version, and their actual winning files through houseCARL.
- [ ] Check MSVC, CMake/vcpkg, and CommonLibSSE-NG availability. Use the alandtse `ng` lineage; confirm build/dependency choices before scaffolding. Stop if required tooling is missing.
- [ ] Read the current native-plugin lifecycle, threading, and persistence references before writing native code.
- [ ] Verify SlaveTatsNG interface acquisition, initialization order, version checks, and each selected function's result convention. The shipped header's boolean annotations are not sufficient proof of runtime behavior.
- [ ] Establish how native queries allocate, retain, read, and release JContainers results. Identify any additional required interface rather than guessing handle ownership.
- [ ] Verify applied-tattoo enumeration, catalog lookup, pool capacity, external-slot accounting, and application without replacing existing tattoos. The shipped header marks several query methods as implementation details.
- [ ] Locate Magelight's supported integration SDK and verify view creation, page callbacks, hotkeys, readiness, and reload handling. Do not assume the Papyrus interface is also the native interface.
- [ ] Verify SkyrimNet action callback threading and completion semantics, native decorators, settings-change notifications, prompt placement, and cache refresh.
- [ ] Confirm that the player's summary and compact application choices can reach NPC conversations without relying on the Papyrus nearby-actor decorator path.
- [ ] Identify an engine-supported way to drop the exact worn item instance with its enchantment and tempering. Verify removal restrictions and exclusion detection.
- [ ] Record findings and supported versions under `.agents/notes`; record unresolved blockers before proceeding with the affected feature.

Exit: each integration has a documented usable route. Ask before substituting another API, dependency, or verification approach when a required route is blocked.

## 2. Establish the native project

- [ ] Add the confirmed build configuration, dependency references, plugin entry point, logging, and the project's verification setup.
- [ ] Build the minimal DLL before adding feature logic. Package a loadable development artifact and verify its own load message in-game.
- [ ] Add adapter boundaries for SlaveTatsNG, SkyrimNet, Magelight, and equipment operations; keep game objects out of the core data model.
- [ ] Implement readiness checks and save-load/new-game reset handling. Missing or incompatible APIs must not trigger invalid calls.
- [ ] Define a save-session generation so queued work and cached data from a previous save cannot affect the next loaded save.
- [ ] Marshal engine operations to the required thread. Framework callbacks read immutable snapshots; release local locks before calling another plugin.
- [ ] Schedule periodic work with a paced mechanism; never repeatedly enqueue a task into its own draining queue.

Exit: the DLL builds and loads, readiness failures are logged, and save transitions clear transient work.

## 3. Implement enrichment loading

- [ ] Confirm pack serialization and discovery location, then document them with one complete example pack.
- [ ] Implement the six agreed fields: Section, Name, DisplayName, Category, Content, Position. The source identity is `(Section, Name)`; there is no integer Id.
- [ ] Validate field types, required values, and the fixed Position vocabulary. Categories remain supplied by pack creators.
- [ ] Resolve entries against the installed SlaveTats catalog and obtain the underlying Body/Face/Hands/Feet pool from SlaveTats metadata.
- [ ] Detect duplicate identities and conflicting mappings; report the source files without silently choosing a winner.
- [ ] Build indexes by identity and category/position. Unenriched tattoos never become UI, prompt, or application entries.
- [ ] Cover malformed entries, missing source tattoos, duplicate identities, All Over, and Content containing quotes or symbols in core tests.

Exit: a small real pack loads against installed tattoos, and invalid mappings produce actionable diagnostics.

## 4. Implement player reconciliation and persistence

- [ ] Query applied tattoos periodically, distinguish failure from an empty successful result, and copy results into owned snapshots.
- [ ] Reconcile enriched identities: add new entries using current defaults, preserve retained choices, and delete confirmed removals.
- [ ] Preserve the agreed rapid remove/reapply behavior: changes not observed between polls may retain the previous choice.
- [ ] Persist saved checkbox choices in the SKSE co-save using a versioned record and a nonconflicting serialization ID. Rebuild transient caches after loading.
- [ ] Prevent a new default setting from rewriting choices on existing tattoos.
- [ ] Keep complete pool-occupancy information separate from the enriched display list; unenriched tattoos still consume slots.
- [ ] Cover query failure, repeated identical snapshots, removal/reapplication, slot reuse, default changes, and save-state restoration in core tests.

Exit: changes made through SlaveTats or another mod reconcile correctly; loading an older save restores its choices without leaking later state.

## 5. Implement visibility and SkyrimNet Display

- [ ] Compute effective visibility as `slot32Empty || savedVisible` for each detected enriched tattoo, gated by Display being enabled.
- [ ] Check slot 32 on load and after equipment changes settle. Coalesce event bursts; do not poll equipment every frame.
- [ ] Preserve saved choices throughout the temporary all-visible override. Default Face visibility applies only to newly detected tattoos.
- [ ] Publish cached current descriptions through the verified SkyrimNet prompt route. Treat Content as descriptive data and serialize/escape it correctly.
- [ ] Include only the player's summary, and avoid repeating it once per NPC bio in the same prompt.
- [ ] Rebuild output when effective content changes; verify SkyrimNet's own caches do not retain removed or newly hidden tattoos.
- [ ] Add the agreed default-region settings and independent Apply/Display toggles using SkyrimNet's supported plugin-settings schema.
- [ ] Stop recurring tattoo queries when both features are disabled. Apply-only mode may retain the queries it needs for selection and capacity.
- [ ] Cover the visibility formula, dressed/nude transitions, changed defaults, and disabled Display in core tests.

Exit: an NPC conversation sees the player's current visible tattoos; dressing restores manual choices, and disabling Display removes its contribution.

## 6. Implement the Magelight screen

- [ ] Add a player-only list of enriched applied tattoos, showing DisplayName, Position, and the saved visibility checkbox.
- [ ] Show when the slot 32 override makes every tattoo visible, so unchecked saved choices are not presented as currently hidden.
- [ ] Route checkbox changes to saved state and refresh the cached prompt summary.
- [ ] Add the configurable hotkey and handle opening, closing, focus refusal, page reload, save loading, and empty lists.
- [ ] Keep all UI assets local. Use the supported Magelight callbacks; no additional web framework is required by this plan.

Exit: keyboard interaction works in-game, choices survive reopening and save loading, and the UI performs no tattoo scans while rendering.

## 7. Implement candidate selection and the SkyrimNet action

- [ ] Produce compact available pairs, e.g. `slave: Face, Neck`, from installed enriched candidates not already applied.
- [ ] Include cached capacity filtering only after verifying its correctness and cost. Never infer free slots from enriched-tattoo counts alone.
- [ ] Expose pairs through the verified prompt route; do not assume action parameter schemas can be changed dynamically.
- [ ] Register an action taking Category and Position, with the player fixed as the recipient. Eligibility respects Apply and dependency readiness.
- [ ] Instruct NPCs to stay vague before selection, e.g. “I’ll mark you as you deserve it.” All Over remains a concrete Position, not a wildcard.
- [ ] Validate the requested pair, refresh relevant state, exclude duplicates including hidden tattoos, and randomly choose one candidate.
- [ ] Return failure without substitution when no candidate remains. Apply one tattoo per action; add no cooldown or repetition limit.
- [ ] Serialize overlapping application requests so concurrent requests cannot choose the same unapplied tattoo. This is an in-progress guard, not a cooldown.
- [ ] Cover matching, duplicate exclusion, All Over, invalid/empty requests, and random selection using an injectable random source.

Exit: the LLM receives compact choices, selection follows the agreed rules, and requests cannot bypass validation.

## 8. Add stripping, application, and confirmed outcomes

- [ ] Preflight selection, dependency readiness, and capacity before changing equipment.
- [ ] Snapshot eligible worn clothing/armor instances once, including boots, gloves, and helmets. Keep jewelry and weapons; deduplicate items occupying multiple slots.
- [ ] Resolve SexLabNoStrip optionally from `02F16E:SexLab.esm`. Leave marked, protected, or undroppable items untouched without requiring SexLab.
- [ ] Unequip and drop only the selected worn instances through the verified engine route. Do not recreate items from base forms or drop spare inventory copies.
- [ ] Recheck relevant state after stripping, then apply the selected tattoo without overwriting occupied or locked slots.
- [ ] Read back the applied identity before reporting success. Distinguish work being queued from application being completed in the SkyrimNet callback contract.
- [ ] Update cached tattoo/visibility state after completion and emit narration using the actual Content and Position.
- [ ] On failure, report the actual outcome without successful-tattoo narration. Dropped clothing is a separate completed side effect; do not imply it was restored.
- [ ] Cancel stale work across save transitions and release the in-progress guard on every completion/failure path.

Exit: one action strips eligible items, drops their original instances, applies one tattoo, and narrates only a confirmed result.

## 9. Verify performance and package

- [ ] Run the project's build and meaningful core tests. Do not create a parallel runner when the configured setup is blocked.
- [ ] Verify external application/removal, failed queries, full pools, externally occupied slots, locked tattoos, and rapid remove/reapply in-game.
- [ ] Verify stripping with duplicate base items, enchanted/tempered items, multi-slot armor, NoStrip, jewelry, weapons, and protected items.
- [ ] Verify both feature toggles independently, an empty enrichment catalog, UI reopening, equipment swaps, older saves, and new-game reset.
- [ ] Verify late application failure produces no success narration and leaves cached state consistent with actual game state.
- [ ] Measure native enumeration, capacity queries, slot 32 checks, cache rebuilding, and game-thread time with representative tattoo/overlay counts. Select the polling interval from those measurements.
- [ ] Verify prompt rendering reads cached data, equipment-event bursts coalesce, and both features disabled produce no recurring tattoo queries.
- [ ] Package the DLL, required content files, Magelight assets, one verified enrichment pack, and dependency/version instructions as an MO2-ready archive.
- [ ] Document Apply/Display settings, the MTF Display incompatibility, dropped-clothing behavior, and pack authoring. Preserve applicable license notices and record MTF reuse/inspiration.
- [ ] Verify packaged contents and deployed winners through houseCARL after installation; distinguish build, deployment, load, and gameplay results.
- [ ] Move this implementation plan to `.agents/plans/completed` only after its required checks pass. Keep unresolved runtime checks explicit.

## Evidence and stop conditions

Use the specification's source list and the local SkyrimNet 29 devkit. Current static inspection found SlaveTatsNG 0.8.1 and Magelight 1.7.1; these are investigation baselines, not established minimum supported versions.

Stop the affected phase and ask if native query ownership, exact-instance dropping, action completion, or Magelight integration cannot satisfy the specification. Do not silently weaken those requirements, introduce another framework, or claim runtime verification from a successful build.
