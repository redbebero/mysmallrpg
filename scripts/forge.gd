class_name Forge
extends StaticBody3D

var recipes: Array[RecipeDefinition] = []

func setup(values: Array[RecipeDefinition]) -> void:
	recipes = values

func interact(actor: Node) -> void:
	var recipe := CraftExecutor.craft(recipes, actor)
	if recipe != null:
		_emit_message(actor, "Crafted %s" % recipe.display_name)
	else:
		_emit_message(actor, "No craftable recipe")

func _emit_message(actor: Node, text: String) -> void:
	if actor != null and actor.has_signal("message_changed"):
		actor.emit_signal("message_changed", text)
