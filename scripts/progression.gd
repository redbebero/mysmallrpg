class_name Progression
extends Node

signal changed
@export var definition: ProgressionDefinition
var levels: Dictionary = {}

func _ready() -> void:
	if definition != null:
		levels[definition.mastery_name] = definition.starting_level

func get_level(key: StringName) -> int:
	return int(levels.get(key, 0))

func has_unlock(unlock_id: StringName) -> bool:
	if definition == null:
		return false
	var required := int(definition.unlocks.get(unlock_id, 999999))
	return get_level(definition.mastery_name) >= required

func add_fight_mastery(amount: int = 1) -> void:
	levels[&"fight"] = get_level(&"fight") + amount
	changed.emit()
