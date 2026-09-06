class_name OreNode
extends StaticBody3D

@export var definition_id: StringName = &"ore"
var rewards: Array[RewardDefinition] = []
var depleted := false

func setup(definition: OreDefinition) -> void:
	if definition == null:
		return
	rewards = definition.rewards

func interact(actor: Node) -> void:
	if depleted:
		return
	var equipment := actor.get_node_or_null("EquipmentController") as EquipmentController
	var executor := actor.get_node_or_null("ActionExecutor") as ActionExecutor
	if equipment == null or executor == null:
		return
	var tool := equipment.find_with_tag(&"gather_tool")
	if tool == null:
		_emit_message(actor, "Requires a gathering tool")
		return
	executor.execute(tool, actor, self)

func gather(actor: Node) -> void:
	if depleted:
		return
	depleted = true
	RewardExecutor.execute(rewards, actor)
	_emit_message(actor, "Ore gathered")
	queue_free()

func _emit_message(actor: Node, text: String) -> void:
	if actor != null and actor.has_signal("message_changed"):
		actor.emit_signal("message_changed", text)
