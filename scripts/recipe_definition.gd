class_name RecipeDefinition
extends Resource

@export var id: StringName
@export var display_name: String = "Recipe"
@export var conditions: Array[ConditionDefinition] = []
@export var costs: Array[CostDefinition] = []
@export var rewards: Array[RewardDefinition] = []

func can_craft(actor: Node) -> bool:
	for condition in conditions:
		if condition != null and not condition.is_met(actor):
			return false
	for cost in costs:
		if cost != null and not cost.can_pay(actor):
			return false
	return true

func pay_costs(actor: Node) -> bool:
	if not can_craft(actor):
		return false
	for cost in costs:
		if cost != null and not cost.pay(actor):
			return false
	return true
