@abstract class_name EffectExample extends Resource

func apply(user: Node, target: Node, capability_data: ItemCapability) -> void:
	push_error("Effect 'apply' method must be overridden.")
