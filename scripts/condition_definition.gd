class_name ConditionDefinition
extends Resource

@export_enum("none", "mastery") var condition_type: String = "none"
@export var key: StringName = &""
@export var minimum: int = 0

func is_met(actor: Node) -> bool:
	if condition_type == "none":
		return true
	if condition_type == "mastery":
		var progression := actor.get_node_or_null("Progression")
		return progression != null and progression.get_level(key) >= minimum
	return false
