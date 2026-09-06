class_name Progression
extends Node

signal changed
@export var definitions: Array[ProgressionDefinition] = []
var levels: Dictionary = {}
var definitions_by_id: Dictionary = {}

func _ready() -> void:
	_register_definitions(definitions)

func setup(values: Array[ProgressionDefinition]) -> void:
	definitions = values
	levels.clear()
	definitions_by_id.clear()
	_register_definitions(definitions)

func _register_definitions(values: Array[ProgressionDefinition]) -> void:
	for definition in values:
		if definition == null:
			continue
		var mastery_id := definition.id if definition.id != &"" else definition.mastery_name
		if mastery_id == &"":
			continue
		definitions_by_id[mastery_id] = definition
		levels[mastery_id] = definition.starting_level

func add_mastery(mastery_id: StringName, amount: int) -> void:
	if not definitions_by_id.has(mastery_id):
		return
	levels[mastery_id] = get_level(mastery_id) + amount
	changed.emit()

func get_level(mastery_id: StringName) -> int:
	return int(levels.get(mastery_id, 0))

func has_unlock(mastery_id: StringName, unlock_id: StringName) -> bool:
	var definition: ProgressionDefinition = definitions_by_id.get(mastery_id)
	if definition == null:
		return false
	for unlock in definition.unlocks:
		if unlock != null and unlock.id == unlock_id:
			return get_level(mastery_id) >= unlock.required_level
	return false
