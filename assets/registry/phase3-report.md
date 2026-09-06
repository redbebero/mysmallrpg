# Art Pipeline Phase 3 Report

- Blender: 4.3.2 (user-local install at `/home/redbebero/.local/opt/blender`)
- background bpy smoke test: PASS
- selected Blender assets: 13
- Blender failures: 0

## Processed assets

- `stylized_nature_megakit_commontree_1`: PASS, 1 meshes, 6265 triangles, 2 materials, 8888740 bytes
- `stylized_nature_megakit_commontree_2`: PASS, 1 meshes, 5648 triangles, 2 materials, 8830392 bytes
- `stylized_nature_megakit_rock_medium_1`: PASS, 1 meshes, 342 triangles, 1 materials, 2532072 bytes
- `stylized_nature_megakit_rock_medium_2`: PASS, 1 meshes, 244 triangles, 1 materials, 2528216 bytes
- `medieval_village_megakit_wall_plaster_straight`: PASS, 1 meshes, 86 triangles, 2 materials, 17690868 bytes
- `medieval_village_megakit_floor_brick`: PASS, 1 meshes, 4 triangles, 1 materials, 7612576 bytes
- `medieval_village_megakit_door_1_flat`: PASS, 1 meshes, 314 triangles, 2 materials, 7403848 bytes
- `fantasy_props_megakit_chest_wood`: PASS, 3 meshes, 2626 triangles, 2 materials, 14847220 bytes
- `fantasy_props_megakit_barrel`: PASS, 1 meshes, 824 triangles, 2 materials, 14707748 bytes
- `fantasy_props_megakit_lantern_wall`: PASS, 1 meshes, 2822 triangles, 1 materials, 6981016 bytes
- `fantasy_props_megakit_sword_bronze`: PASS, 1 meshes, 1540 triangles, 1 materials, 9799636 bytes
- `fantasy_props_megakit_shield_wooden`: PASS, 1 meshes, 1404 triangles, 3 materials, 24437952 bytes
- `fantasy_props_megakit_scroll_1`: PASS, 1 meshes, 512 triangles, 2 materials, 17233356 bytes

## Equipment

- sword → `mainHand`
- shield → `offHand`
- scroll → `mainHand` (logical slot retained; transform calibration remains visual-only)

## Runtime

- Registry → processed GLB → Godot: PASS
- Phase 3 runtime loaded 13 assets and attached 3 equipment visuals.
- Existing runtime slice loaded 18 assets: PASS

## Warnings

- Godot reports invalid imported texture UID warnings and falls back to text paths; runtime loading still passes.
- Blender shader export emitted sampler warnings for some multi-material assets; outputs validated and load successfully.

## Deferred

- attachment transform visual calibration, full rig retargeting, outfit assembly, LOD, and full inventory processing.
