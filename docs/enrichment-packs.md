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

Positions: Face, Neck, Back, Ass, Pubic Area, All Over, Left Arm, Right Arm, Left Upper Leg, Right Upper Leg, Left Lower Leg, Right Lower Leg, Left Hand, Right Hand, Left Foot, Right Foot.

One invalid entry or duplicate identity rejects every pack; the Papyrus log names the file and entry. Loading retries every 15 seconds.
Entries without an installed tattoo are ignored.