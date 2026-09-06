class_name ActionDefinition
extends Resource

@export var id: StringName
@export var display_name: String = "Action"
@export var effects: Array[EffectDefinition] = []
@export var conditions: Array[ConditionDefinition] = []
@export var perfect_block_conditions: Array[ConditionDefinition] = []
@export var mana_cost: float = 0.0
@export var cooldown: float = 0.0
@export var windup: float = 0.0
@export var active_time: float = 0.1
@export var recovery_time: float = 0.0
@export var range: float = 3.0
@export var requires_target: bool = false
@export var is_held: bool = false
@export var block_angle_degrees: float = 110.0
@export var perfect_block_window: float = 0.18

func can_use(actor: Node) -> bool:
	for condition in conditions:
		if not condition.is_met(actor):
			return false
	var stats := actor.get_node_or_null("Stats")
	return stats == null or stats.mana >= mana_cost

func can_perfect_block(actor: Node) -> bool:
	for condition in perfect_block_conditions:
		if not condition.is_met(actor):
			return false
	return true
