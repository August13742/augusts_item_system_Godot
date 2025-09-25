class_name RestoreEffectExample extends EffectExample

enum Status{Health,Mana}
@export var stat_target:Status
@export var amount: int = 10

func apply(user: Node, target: Node, capability_data: ItemCapability) -> void:
	#if target.has_method("restore_stat"):
		#target.restore_stat(stat_target, amount)
		print(self.resource_name, "Triggering on", stat_target)
