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

All fields are nonempty strings. Position uses the region list in the design plan.
Duplicate source identities and invalid entries reject the replacement catalog and log the file and entry.
The loader currently validates enrichment structure; installed-tattoo resolution and runtime verification remain pending.
