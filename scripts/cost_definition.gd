class_name CostDefinition
extends Resource

@export_enum("item") var cost_type: String = "item"
@export var target_id: StringName
@export var amount: int = 1

func can_pay(actor: Node) -> bool:
	if amount <= 0:
		return true
	if cost_type == "item":
		var inventory := _inventory(actor)
		return inventory != null and inventory.has_item(target_id, amount)
	return false

func pay(actor: Node) -> bool:
	if not can_pay(actor):
		return false
	if cost_type == "item":
		var inventory := _inventory(actor)
		return inventory != null and inventory.remove_item(target_id, amount)
	return false

func _inventory(actor: Node) -> Inventory:
	if actor is Inventory:
		return actor
	return actor.get_node_or_null("Inventory") as Inventory
