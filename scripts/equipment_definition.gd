class_name EquipmentDefinition
extends Resource

@export var id: StringName
@export var display_name: String = "Equipment"
@export var tags: Array[StringName] = []
@export var compatible_slots: Array[StringName] = [&"primary", &"secondary"]
@export var action: ActionDefinition

func fits_slot(slot: StringName) -> bool:
	return compatible_slots.has(slot)
