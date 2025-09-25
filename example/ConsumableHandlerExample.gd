class_name ConsumableHandlerExample extends CapabilityHandler

func execute(user: Node, target: Node, capability_data: ItemCapability) -> void:
	# Type cast to access the specific data.
	var consumable_data: ConsumableCapabilityExample = capability_data as ConsumableCapabilityExample
	if not consumable_data:
		push_error("Invalid capability data passed to ConsumableHandler.")
		return

	# The handler's sole job is to iterate and apply. It is completely
	# decoupled from what the effects actually are.
	for effect in consumable_data.effects:
		if effect:
			effect.apply(user, target, consumable_data)

	# ... logic to decrement item count ...
