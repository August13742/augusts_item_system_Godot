@tool
class_name LootDrop extends Resource

enum Type {Guaranteed, Weighted}
## The item that might drop.
@export var drop_type: Type = Type.Guaranteed:
	set(v):
		if drop_type == v: return
		drop_type = v
		notify_property_list_changed()
		
@export var item_id: StringName = &""

## The quantity range to drop if selected.
@export_range(1, 99, 1) var min_amount: int = 1
@export_range(1, 99, 1) var max_amount: int = 1

## For weighted selection: higher value = more likely.
var _weight: float = 1.0

func get_rolled_amount() -> int: # idiot proof
	var lo: int = min(min_amount, max_amount)
	var hi: int = max(min_amount, max_amount)
	return randi_range(lo, hi)

func _get_property_list() -> Array:
	var p: Array = []

	if drop_type == Type.Weighted:
		p.append({
			"name": "weight",
			"type": TYPE_FLOAT,
			"hint": PROPERTY_HINT_RANGE,
			"hint_string": "0.1,999.0,0.1",
			"usage": PROPERTY_USAGE_DEFAULT
		})

	return p
func _get(p_name):
	match p_name:
		"weight":
			return _weight
		_:
			return null

func _set(p_name, value) -> bool:
	match p_name:
		"weight":
			_weight = clampf(float(value), 0.1, 999.0)
			return true
		_:
			return false
