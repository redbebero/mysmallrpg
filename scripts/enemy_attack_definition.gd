class_name EnemyAttackDefinition
extends Resource

@export var id: StringName
@export var display_name: String = "Attack"
@export var damage: float = 5.0
@export var range: float = 1.7
@export var windup: float = 0.8
@export var active_time: float = 0.15
@export var recovery: float = 0.8
@export var tags: Array[StringName] = []
@export var stagger_duration: float = 0.4
