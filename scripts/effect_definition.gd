class_name EffectDefinition
extends Resource

@export_enum("damage", "block", "projectile", "status", "mana_change", "stagger") var effect_type: String = "damage"
@export var amount: float = 0.0
@export var duration: float = 0.0
@export var speed: float = 18.0
@export var lifetime: float = 3.0
@export var tags: Array[StringName] = []
