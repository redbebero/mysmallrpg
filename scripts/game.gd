extends Node3D

var player: PlayerController
var available_equipment: Array[EquipmentDefinition]
var enemy_definitions: Array[EnemyDefinition]

func _ready() -> void:
	available_equipment = GameDatabase.equipment()
	enemy_definitions = GameDatabase.enemies()
	player = get_node("Player") as PlayerController
	var equipment := player.get_node("EquipmentController") as EquipmentController
	var executor := player.get_node("ActionExecutor") as ActionExecutor
	var progression := player.get_node("Progression") as Progression
	progression.setup(GameDatabase.progressions())
	_configure_loadout(equipment)
	player.setup(equipment, executor)
	equipment.setup(executor, player)
	for enemy_node in get_tree().get_nodes_in_group("enemies"):
		var enemy := enemy_node as Enemy
		var definition := _find_enemy_definition(enemy.definition_id)
		if enemy != null and definition != null:
			enemy.setup(player, definition)
	var hud := GameHud.new()
	add_child(hud)
	hud.setup(player, equipment, available_equipment)

func _configure_loadout(equipment: EquipmentController) -> void:
	for item in available_equipment:
		if equipment.primary == null and item.fits_slot(&"primary") and item.tags.has(&"weapon"):
			equipment.primary = item
		elif equipment.secondary == null and item.fits_slot(&"secondary") and item.tags.has(&"defensive"):
			equipment.secondary = item

func _find_enemy_definition(definition_id: StringName) -> EnemyDefinition:
	for definition in enemy_definitions:
		if definition.id == definition_id:
			return definition
	return null
