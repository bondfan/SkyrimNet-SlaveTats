# SkyrimNet - SlaveTats

Development build 0.1.0. Feature code compiles; gameplay and performance verification remain pending.

## Requirements

SkyrimNet 29, SlaveTats, SlaveTatsNG, Magelight, PapyrusUtil, JContainers, and powerofthree's Papyrus Extender. Keep their own requirements installed.

## Features

- Player-only tattoo visibility, persisted through StorageUtil.
- Periodic SlaveTats reconciliation and prepared SkyrimNet prompt summaries.
- Empty slot 32 temporarily makes every enriched tattoo visible without changing saved choices.
- Magelight visibility screen and configurable hotkey in SkyrimNet's SNT plugin settings.
- Each refresh publishes the player's applied tattoos as StorageUtil string `SNT_AppliedTattoos`: `|` followed by `|section/name|` per tattoo. Unset while both features are disabled.
- Random tattoo selection from available category/position pairs; existing tattoos are excluded.
- Eligible clothing is unequipped and dropped before application. Jewelry, weapons, shields, quest items, and SexLabNoStrip items are excluded.

With duplicate items, the dropped copy may differ from the worn copy, including enchantment or tempering. Clothing already dropped stays on the ground if tattoo application subsequently fails.

Apply and Display have independent settings. Disable one of the two display integrations when using MTF; their Display features are incompatible.

## Current Checkpoint

The build is deployed to MO2 mod `houseCARL - SkyrimNet-SlaveTats`. Restart Skyrim after updating scripts, then load a save.

Assign the visibility hotkey with Set Key under SkyrimNet Settings > Plugins > SNT; Unset clears it. It starts unbound. Supported keys: F1–F12, numpad digits/operators, arrows, Home/End, Page Up/Down, Insert/Delete. Other selections leave it unbound. Runtime verification remains pending.

The included metadata pack maps seven SlaveTats basic slave marks on the face, hands, and pubic area. Source identities were checked against the installed basic catalog; appearance and application remain unverified in-game. No tattoo textures are redistributed.

The current refresh interval is a provisional 15 seconds; body-armor changes request a deferred refresh. Performance measurements remain pending.

Inspect the Papyrus log for `[SNT] Enrichment entries=7` and `[SNT] Installed enriched tattoo sources=7`. Test checkbox persistence, dressing/undressing, independent feature toggles, and a subsequent dialogue prompt. Application and stripping need separate gameplay checks.

## Potential Issues

- A refresh requested while another runs waits up to 15 seconds.
- Tattoo application gives up if a refresh runs longer than 5 seconds.
- Category/position pairs ignore SlaveTats requirement and exclusion rules; a pair whose tattoos all fail them is still offered, and applying it fails.
- One invalid or duplicate pack entry disables all packs. The packs are then reread every 15 seconds, logging the error each time.
- Saved visibility choices are lost if SlaveTatsNG reports no applied tattoos on the first refresh after loading.
- A pack position in different letter case, such as `face`, reads setting `visibility.face` instead of `visibility.Face`.

## Credits

Magic Tattoos Framework inspired the enrichment and prepared-summary approach. No MTF implementation code was copied.

[Pack format](docs/enrichment-packs.md) · [Design](.agents/plans/skyrimnet-slavetats.md) · [Implementation](.agents/plans/skyrimnet-slavetats-implementation.md)
