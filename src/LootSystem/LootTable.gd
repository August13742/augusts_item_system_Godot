@tool
class_name LootTable extends Resource

## Items that are always awarded, Weight property is ignored
@export var guaranteed_drops: Array[LootDrop]

## A pool of items to be chosen from randomly
@export var weighted_drops: Array[LootDrop]

## How many times to pick from the weighted_drops pool
@export_range(0, 20, 1) var num_weighted_rolls: int = 1

## --- ANALYSIS TOOL ---
@export_tool_button("Analyse Loot Table") var _analyse_button: Callable = _run_analysis
var analysis_results: String = ""

func roll_loot() -> Array[ItemInstance]:
	var final_loots: Array[ItemInstance] = []

	# Guaranteed
	for drop: LootDrop in guaranteed_drops:
		if is_instance_valid(drop) and drop.item_id != &"":
			final_loots.append(_instantiate_item(drop))

	# Weighted
	if not weighted_drops.is_empty() and num_weighted_rolls > 0:
		for _i in range(num_weighted_rolls):
			var chosen_drop: LootDrop = _pick_from_weighted(weighted_drops)
			if is_instance_valid(chosen_drop) and chosen_drop.item_id != &"":
				final_loots.append(_instantiate_item(chosen_drop))

	# Optional: consolidate duplicates
	return _coalesce(final_loots)

#region Utilities
func _pick_from_weighted(drops: Array[LootDrop]) -> LootDrop:
	var total_weight: float = 0.0
	for drop: LootDrop in drops:
		if not is_instance_valid(drop): continue
		var w: float = float(drop.get("weight"))
		if w > 0.0:
			total_weight += w
	if total_weight <= 0.0:
		return null

	var chosen_value: float = randf_range(0.0, total_weight)
	var acc: float = 0.0
	for drop: LootDrop in drops:
		if not is_instance_valid(drop): continue
		var w: float = float(drop.get("weight"))
		if w <= 0.0: continue
		acc += w
		if chosen_value < acc:
			return drop
	return null


func _instantiate_item(drop: LootDrop) -> ItemInstance:
	var inst: ItemInstance = ItemInstance.new()
	inst.id = drop.item_id
	inst.count = drop.get_rolled_amount()
	return inst

## merge same items into one instance
func _coalesce(items: Array[ItemInstance]) -> Array[ItemInstance]:
	var acc: Dictionary[StringName, int] = {}
	for it: ItemInstance in items:
		if it == null: continue
		acc[it.id] = acc.get(it.id, 0) + it.count
	var out: Array[ItemInstance] = []
	for id in acc.keys():
		var inst := ItemInstance.new()
		inst.id = id
		inst.count = acc[id]
		out.append(inst)
	return out
#endregion

#region Tool Script Logic
func _get_property_list() -> Array:
	var p: Array = []
	p.append({
		"name": "analysis_results",
		"type": TYPE_STRING,
		"usage": PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_READ_ONLY,
		"hint": PROPERTY_HINT_MULTILINE_TEXT,
	})
	return p
	
func _run_analysis() -> void:
	if not Engine.is_editor_hint():
		return

	var report: Array[String] = []
	var overall_avg_yield: Dictionary = {}  # StringName -> float

	# 1. Guaranteed contributions
	for drop in guaranteed_drops:
		if not is_instance_valid(drop) or drop.item_id == &"":
			continue
		var avg_amount := (drop.min_amount + drop.max_amount) * 0.5
		overall_avg_yield[drop.item_id] = overall_avg_yield.get(drop.item_id, 0.0) + avg_amount

	# 2. Weighted contributions
	var total_weight := 0.0
	for d in weighted_drops:
		if is_instance_valid(d) and d.item_id != &"":
			total_weight += float(d.get("weight"))

	if total_weight > 0.0 and num_weighted_rolls > 0:
		for drop in weighted_drops:
			if not is_instance_valid(drop) or drop.item_id == &"":
				continue
			var w := float(drop.get("weight"))
			if w <= 0.0: continue
			var prob := w / total_weight
			var expected_picks := prob * num_weighted_rolls
			var avg_amount := (drop.min_amount + drop.max_amount) * 0.5
			var _yield := avg_amount * expected_picks
			overall_avg_yield[drop.item_id] = overall_avg_yield.get(drop.item_id, 0.0) + _yield

	# --- Compact summary at the top ---
	report.append("=== Average Yield Per Event ===")
	if overall_avg_yield.is_empty():
		report.append("(No drops possible)")
	else:
		for item_id in overall_avg_yield.keys():
			report.append("- %s: %.2f" % [str(item_id), overall_avg_yield[item_id]])

	# --- Extended detail (scroll if you want) ---
	report.append("\n=== Details ===")

	# Guaranteed details
	if not guaranteed_drops.is_empty():
		report.append("Guaranteed:")
		for drop in guaranteed_drops:
			if not is_instance_valid(drop) or drop.item_id == &"":
				continue
			var avg_amount := (drop.min_amount + drop.max_amount) * 0.5
			report.append("- %s: avg %.2f" % [str(drop.item_id), avg_amount])

	# Weighted details
	if total_weight > 0.0 and num_weighted_rolls > 0:
		report.append("\nWeighted (%d Rolls, Total W=%.2f):" % [num_weighted_rolls, total_weight])
		for drop in weighted_drops:
			if not is_instance_valid(drop) or drop.item_id == &"":
				continue
			var w := float(drop.get("weight"))
			if w <= 0.0: continue
			var prob := w / total_weight
			var avg_amount := (drop.min_amount + drop.max_amount) * 0.5
			var _yield := avg_amount * prob * num_weighted_rolls
			report.append("- %s (%.1f%%/roll): avg %.2f" %
				[str(drop.item_id), prob * 100.0, _yield])

	analysis_results = "\n".join(report)

	
#endregion
