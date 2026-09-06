class_name EnemyDefinition
extends Resource

@export var id: StringName
@export var display_name: String = "Enemy"
@export var tags: Array[StringName] = []
@export var max_health: float = 50.0
@export var move_speed: float = 2.0
@export var spawn_position: Vector3
@export var display_color: Color = Color.WHITE
@export var attacks: Array[EnemyAttackDefinition] = []
