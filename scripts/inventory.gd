class_name Inventory
extends Node

signal changed
var quantities: Dictionary = {}

func add_item(item_id: StringName, amount: int = 1) -> void:
	if item_id == &"" or amount == 0:
		return
	quantities[item_id] = maxi(0, int(quantities.get(item_id, 0)) + amount)
	changed.emit()

func get_quantity(item_id: StringName) -> int:
	return int(quantities.get(item_id, 0))

func has_item(item_id: StringName, amount: int = 1) -> bool:
	return get_quantity(item_id) >= amount

func remove_item(item_id: StringName, amount: int = 1) -> bool:
	if amount < 0 or not has_item(item_id, amount):
		return false
	quantities[item_id] = get_quantity(item_id) - amount
	changed.emit()
	return true
