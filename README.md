# August's Item System (WIP) for Personal Godot Projects

Overview
- Capability-based item composition system for Godot.
- At editor/runtime the plugin scans `ItemResource` files, builds an in-memory `ItemDatabase`, and (editor-only) writes an inspectable snapshot `ItemCatalogue` resource for debugging and designer inspection.
- The plugin also supports "Actionable" capabilities which require a matching runtime CapabilityHandler implementation.

Usage
- Install into `res://addons/` and enable the plugin via Project > Project Settings > Plugins. See [`plugin.gd`](plugin.gd) and [`plugin.cfg`](plugin.cfg).
- Configure project settings (Project > Project Settings):
  - `augusts_item_system/database/source_directory`
  - `augusts_item_system/database/catalogue_save_path`
  - `augusts_item_system/database/handlers_directory`
- Rebuild catalogue:
  - Editor menu: "Item System / Rebuild Catalogue" (added by [`plugin.gd`](plugin.gd))
  - Or use the inspector tool button on the autoloaded database node (see [`item_database.gd`](item_database.gd)).

Defaults
- Catalogue save path default: `res://items/generated/item_catalogue.tres`
- Source directory default: `res://items/resources`
- Handlers directory default: `res://items/handlers`

Key files / symbols
- [`ItemResource`](item_resource.gd) ([item_resource.gd](item_resource.gd))
- [`ItemCatalogue`](item_catalogue.gd) ([item_catalogue.gd](item_catalogue.gd))
- [`ItemCapability`](item_capability.gd) ([item_capability.gd](item_capability.gd))
- [`ActionableCapability`](actionable_capability.gd) ([actionable_capability.gd](actionable_capability.gd))
- [`CapabilityHandler`](capability_handler.gd) ([capability_handler.gd](capability_handler.gd))
- Database/autoload: [item_database.gd](item_database.gd)
- Plugin entry: [plugin.gd](plugin.gd) and [plugin.cfg](plugin.cfg)
- Examples: [example/crafting_capability.gd](example/crafting_capability.gd), [example/consumable_capability.gd](example/consumable_capability.gd), [example/example_resource.tres](example/example_resource.tres)

License
- MIT. See
