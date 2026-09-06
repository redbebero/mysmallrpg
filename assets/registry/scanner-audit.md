# Scanner Audit

- Archives: 7
- Logical assets: 385
- Animation containers: 3
- Animation clips: 91

- characters: 18
- characterParts: 24
- creatures: 2
- environments: 244
- props: 94
- animations: 3
- unknown: 0

## Archive summaries

| archive | files | selected | ignored formats | logical | GLB | GLTF | FBX | OBJ | BLEND | clips |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Bestiary - Dungeon Monsters Kit[Standard].zip | 22 | 2 | 2 | 2 | 2 | 0 | 2 | 0 | 0 | 0 |
| Fantasy Props MegaKit[Standard].zip | 517 | 94 | 188 | 94 | 0 | 94 | 94 | 94 | 0 | 4 |
| Medieval Village MegaKit[Standard].zip | 936 | 176 | 352 | 176 | 0 | 176 | 176 | 176 | 0 | 0 |
| Modular Character Outfits - Fantasy[Standard].zip | 121 | 24 | 24 | 24 | 0 | 24 | 24 | 0 | 0 | 1 |
| Stylized Nature MegaKit[Standard].zip | 454 | 68 | 204 | 68 | 0 | 68 | 136 | 68 | 0 | 0 |
| Universal Animation Library 2[Standard].zip | 13 | 3 | 4 | 3 | 3 | 0 | 3 | 0 | 1 | 86 |
| Universal Base Characters[Standard].zip | 112 | 18 | 26 | 18 | 0 | 18 | 26 | 0 | 0 | 0 |

## Findings

- `animation` counts source containers; clip count comes from actual GLB/GLTF `animations[]` names.
- `creature` counts logical models after exporter-format deduplication; variants remain separate when their source path differs.
- Unknown records are retained rather than discarded.
