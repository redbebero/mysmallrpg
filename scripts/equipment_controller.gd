class_name EquipmentController
extends Node

signal loadout_changed
@export var primary: EquipmentDefinition
@export var secondary: EquipmentDefinition
var executor: ActionExecutor
var actor: Node
var held_slot: StringName = &""

func setup(action_executor: ActionExecutor, player: Node) -> void:
	executor = action_executor
	actor = player

func use_primary() -> void:
	_use_slot(&"primary")

func use_secondary() -> void:
	_use_slot(&"secondary")

func release_primary() -> void:
	_release_slot(&"primary")

func release_secondary() -> void:
	_release_slot(&"secondary")

func _use_slot(slot: StringName) -> void:
	var equipment := get_equipment(slot)
	if equipment == null or executor == null:
		return
	if equipment.action.is_held:
		if executor.execute(equipment, actor):
			held_slot = slot
	else:
		executor.execute(equipment, actor)

func _release_slot(slot: StringName) -> void:
	if held_slot == slot and executor != null:
		executor.end_held(actor)
		held_slot = &""

func get_equipment(slot: StringName) -> EquipmentDefinition:
	return primary if slot == &"primary" else secondary

func find_with_tag(tag: StringName) -> EquipmentDefinition:
	for equipment in [primary, secondary]:
		if equipment != null and equipment.tags.has(tag):
			return equipment
	return null

func equip(slot: StringName, equipment: EquipmentDefinition) -> bool:
	if equipment == null or not equipment.fits_slot(slot):
		return false
	if slot == &"primary":
		primary = equipment
	else:
		secondary = equipment
	loadout_changed.emit()
	return true
