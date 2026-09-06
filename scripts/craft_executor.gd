class_name CraftExecutor
extends RefCounted

static func craft(recipes: Array[RecipeDefinition], actor: Node) -> RecipeDefinition:
	for recipe in recipes:
		if recipe == null or not recipe.can_craft(actor):
			continue
		if recipe.pay_costs(actor):
			RewardExecutor.execute(recipe.rewards, actor)
			return recipe
	return null
