@abstract class_name CapabilityHandler extends RefCounted

func execute(target: Node, capability_data: ItemCapability):
	push_error("The 'execute' method must be overridden in the concrete handler: %s" % get_script().resource_path)
