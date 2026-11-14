# Enrichment Packs

Install JSON files under `Data/SKSE/Plugins/SkyrimNet-SlaveTats/Packs/`.
Each file contains an array. Replace the example source identity with an installed SlaveTats tattoo.

```json
[
  {
    "Section": "Example",
    "Name": "Mark",
    "DisplayName": "Chain Mark",
    "Category": "bondage",
    "Content": "A chain symbol",
    "Position": "Left Arm"
  }
]
```

All fields are nonempty strings. `Section` and `Name` identify an installed SlaveTats tattoo.

Positions: Face, Neck, Chest, Belly, Back, Ass, Pubic Area, All Over, Left Arm, Right Arm, Left Upper Leg, Right Upper Leg, Left Lower Leg, Right Lower Leg, Left Hand, Right Hand, Left Foot, Right Foot.

One invalid entry or duplicate identity rejects every pack; the Papyrus log names the file and entry. Loading retries every 15 seconds.
Entries without an installed tattoo are ignored.

## Category explanations

Optional. Install JSON files under `Data/SKSE/Plugins/SkyrimNet-SlaveTats/Categories/`.
Each file contains an object mapping a category name to one short sentence shown to the NPC beside the category.

```json
{
  "bondage": "Writing about being bound, gagged, or kept restrained."
}
```

Category names ignore letter case. A category defined in several files keeps one explanation; the Papyrus log names the ignored file.
