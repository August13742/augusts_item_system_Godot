# August's Item System

A capability-based item composition system for Godot with editor tooling.

## Overview

- **Composition over inheritance**: Items are defined by their capabilities rather than class hierarchies
- **Runtime database**: Scans [`ItemResource`](augusts_item_system/item_resource.gd) files to build an in-memory [`ItemDatabase`](augusts_item_system/item_database.gd)
- **Editor snapshot**: Generates an inspectable [`ItemCatalogue`](augusts_item_system/item_catalogue.gd) resource for debugging
- **Handler system**: [`ActionableCapability`](augusts_item_system/actionable_capability.gd) items require matching [`CapabilityHandler`](augusts_item_system/capability_handler.gd) implementations

## Installation

1. Copy to `res://addons/augusts_item_system/`
2. Enable in Project > Project Settings > Plugins
3. Configure paths in Project Settings:
   - `augusts_item_system/database/source_directory` (default: `res://items/resources`)
   - `augusts_item_system/database/catalogue_save_path` (default: `res://items/generated/item_catalogue.tres`)
   - `augusts_item_system/database/handlers_directory` (default: `res://items/handlers`)

## Usage

**Rebuild catalogue:**
- Editor menu: "Item System / Rebuild Catalogue"
- Or use inspector tool button on the [`ItemDatabase`](augusts_item_system/item_database.gd) autoload

**Create items:**
- Create [`ItemResource`](augusts_item_system/item_resource.gd) files in your source directory
- Add [`ItemCapability`](augusts_item_system/item_capability.gd) or [`ActionableCapability`](augusts_item_system/actionable_capability.gd) components

## Core Classes

| Class | Purpose |
|-------|---------|
| [`ItemResource`](augusts_item_system/item_resource.gd) | Base item definition with capabilities |
| [`ItemCapability`](augusts_item_system/item_capability.gd) | Passive item component |
| [`ActionableCapability`](augusts_item_system/actionable_capability.gd) | Component requiring handler logic |
| [`CapabilityHandler`](augusts_item_system/capability_handler.gd) | Executes actionable capability logic |
| [`ItemDatabase`](augusts_item_system/item_database.gd) | Runtime singleton for item queries |
| [`ItemCatalogue`](augusts_item_system/item_catalogue.gd) | Editor-only debug snapshot |
| [`ItemInstance`](augusts_item_system/item_instance.gd) | Mutable inventory item state |

## License

MIT - See [LICENSE](LICENSE)