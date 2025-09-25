class_name StatusCureEffectExample extends EffectExample

enum CureType { POISON, ALL_NEGATIVE, SPECIFIC_STATUS }
@export var cure_type: CureType = CureType.POISON
# @export var specific_status: StatusResource # If you have a resource for statuses

func apply(user: Node, target: Node, capability_data: ItemCapability) -> void:
	#if target.has_method("remove_status"):
		## ... logic to remove status effects ...
		#pass
	print(self.resource_name, "triggering status cure")
