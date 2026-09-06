class_name GameHud
extends CanvasLayer

var player: PlayerController
var equipment: EquipmentController
var items: Array[EquipmentDefinition]
var status_label: Label
var loadout_label: Label
var inventory_panel: PanelContainer
var stats_label: Label

func setup(player_node: PlayerController, equipment_node: EquipmentController, available: Array[EquipmentDefinition]) -> void:
	player = player_node
	equipment = equipment_node
	items = available
	_build()
	player.message_changed.connect(_show_message)
	equipment.loadout_changed.connect(_refresh)
	player.get_node("Stats").changed.connect(_refresh)
	player.get_node("Progression").changed.connect(_refresh)
	_refresh()

func _build() -> void:
	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	margin.position = Vector2(18, 18)
	add_child(margin)
	stats_label = Label.new()
	stats_label.add_theme_font_size_override("font_size", 18)
	margin.add_child(stats_label)
	var center := Label.new()
	center.text = "+"
	center.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	center.position = Vector2(-5, -14)
	center.add_theme_font_size_override("font_size", 24)
	add_child(center)
	status_label = Label.new()
	status_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM)
	status_label.position = Vector2(-130, -70)
	status_label.size = Vector2(260, 40)
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(status_label)
	loadout_label = Label.new()
	loadout_label.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	loadout_label.position = Vector2(-260, 18)
	loadout_label.size = Vector2(240, 80)
	loadout_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	loadout_label.add_theme_font_size_override("font_size", 16)
	add_child(loadout_label)
	_build_inventory()

func _build_inventory() -> void:
	inventory_panel = PanelContainer.new()
	inventory_panel.position = Vector2(220, 100)
	inventory_panel.size = Vector2(360, 330)
	inventory_panel.visible = false
	add_child(inventory_panel)
	var box := VBoxContainer.new()
	inventory_panel.add_child(box)
	var title := Label.new()
	title.text = "Inventory (E to close)"
	title.add_theme_font_size_override("font_size", 20)
	box.add_child(title)
	for item in items:
		var row := HBoxContainer.new()
		var label := Label.new()
		label.text = item.display_name
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(label)
		var primary_button := Button.new()
		primary_button.text = "Primary"
		primary_button.pressed.connect(_equip_primary.bind(item))
		row.add_child(primary_button)
		var secondary_button := Button.new()
		secondary_button.text = "Secondary"
		secondary_button.pressed.connect(_equip_secondary.bind(item))
		row.add_child(secondary_button)
		box.add_child(row)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		inventory_panel.visible = not inventory_panel.visible
		if inventory_panel.visible:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _equip_primary(item: EquipmentDefinition) -> void:
	equipment.equip(&"primary", item)
	_refresh()

func _equip_secondary(item: EquipmentDefinition) -> void:
	equipment.equip(&"secondary", item)
	_refresh()

func _refresh() -> void:
	if player == null:
		return
	var stats: Stats = player.get_node("Stats")
	var progression: Progression = player.get_node("Progression")
	var inventory: Inventory = player.get_node("Inventory")
	stats_label.text = "HP %.0f/%.0f\nMana %.0f/%.0f\nFight %d  Mining %d\nIron Ore %d" % [stats.health, stats.max_health, stats.mana, stats.max_mana, progression.get_level(&"fight"), progression.get_level(&"mining"), inventory.get_quantity(&"iron_ore")]
	loadout_label.text = "Primary: %s\nSecondary: %s" % [equipment.primary.display_name, equipment.secondary.display_name]

func _show_message(text: String) -> void:
	status_label.text = text
	var timer := get_tree().create_timer(1.2)
	timer.timeout.connect(func():
		if status_label != null:
			status_label.text = "")
