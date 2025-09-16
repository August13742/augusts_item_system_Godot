# August's Item System (Requires Godot 4.5+ due to use of Absract Class)

A capability-based item composition system for Godot with editor tooling. You can delete the @abstract from `item_capability.gd` to use this in 4.5-

## Overview
- Composition over inheritance
- Runtime database scans [`ItemResource`](src/item_resource.gd) files
- Editor snapshot via [`ItemCatalogue`](src/item_catalogue.gd)
- Action execution via [`CapabilityHandler`](src/capability_handler.gd) + [`ActionableCapability`](src/actionable_capability.gd)
- Automatic handler discovery (naming convention)
- Integrity validation (ensures actionable capabilities have handlers)
- Loot system with guaranteed + weighted drops + analysis tool
- Lightweight mutable [`ItemInstance`](src/item_instance.gd)

## Installation
1. Copy to `res://addons/augusts_item_system/`, exact naming or change the paths in `plugin.gd` script yourself
2. Enable in Project > Project Settings > Plugins
3. Configure (or let defaults stand):
   - `augusts_item_system/database/source_directory` (default: `res://items/resources`)
   - `augusts_item_system/database/catalogue_save_path` (default: `res://items/generated/item_catalogue.tres`)
   - `augusts_item_system/database/handlers_directory` (optional; default: `res://items/handlers` if missing)

## Rebuilding
- Editor menu: Item System / Rebuild Catalogue
- Or inspector button on autoloaded [`ItemDatabase`](src/item_database.gd)

## Core Classes
| Class | Purpose |
|-------|---------|
| [`ItemResource`](src/item_resource.gd) | Static item definition |
| [`ItemCapability`](src/item_capability.gd) | Passive capability |
| [`ActionableCapability`](src/actionable_capability.gd) | Needs a handler |
| [`CapabilityHandler`](src/capability_handler.gd) | Executes actionable logic |
| [`ItemDatabase`](src/item_database.gd) | Runtime lookup + validation |
| [`ItemCatalogue`](src/item_catalogue.gd) | Editor snapshot (debug) |
| [`ItemInstance`](src/item_instance.gd) | Mutable inventory state |
| [`LootDrop`](src/LootSystem/LootDrop.gd) | Guaranteed or weighted drop entry |
| [`LootTable`](src/LootSystem/LootTable.gd) | Rolls + yield analysis tool |

## Automatic Handler Registration
At runtime the database scans the handlers directory. Convention:
- Capability script: `SomeFeatureCapability` (file: `some_feature_capability.gd`)
- Handler script: `SomeFeatureHandler.gd`
- Capability scripts are expected (by default) under: `res://addons/augusts_item_system/capabilities/`
Mismatch or missing handler → validation error (runtime only).

## Integrity Validation
After building, every discovered actionable capability must have a registered handler. Errors are printed if missing.

## Loot System With Editor Analysis Tool
- `LootDrop` supports Guaranteed or Weighted (with per-entry weight)
- `LootTable`:
  - Rolls guaranteed first
  - Then performs N weighted rolls
  - Coalesces identical item IDs
  - Editor button: Analyse (shows average yield + detail)

## Extending
1. Create a capability (inherit `ItemCapability` or `ActionableCapability`)
2. (If actionable) create matching `...Handler.gd`
3. Add capability resource to an item
4. Use database API at runtime to query items / capabilities

## Notes
- You can safely inspect the generated catalogue; do not edit it.
- Duplicate IDs and null capabilities are reported during build.

## License
MIT - See [LICENSE](LICENSE)