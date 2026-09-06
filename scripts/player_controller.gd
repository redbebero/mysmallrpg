class_name PlayerController
extends CharacterBody3D

signal message_changed(text: String)
@export var move_speed: float = 6.0
@export var jump_speed: float = 5.5
@export var mouse_sensitivity: float = 0.0025
var camera: Camera3D
var equipment_controller: EquipmentController
var action_executor: ActionExecutor
var pitch := 0.0

func setup(equipment: EquipmentController, executor: ActionExecutor) -> void:
	equipment_controller = equipment
	action_executor = executor
	camera = get_node_or_null("Camera3D")
	var combat := get_node_or_null("CombatController") as CombatController
	if combat != null:
		combat.setup(self, camera)

func _ready() -> void:
	camera = get_node_or_null("Camera3D")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		pitch = clampf(pitch - event.relative.y * mouse_sensitivity, -1.45, 1.45)
		if camera != null:
			camera.rotation.x = pitch
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("primary_use"):
		equipment_controller.use_primary()
	if Input.is_action_just_released("primary_use"):
		equipment_controller.release_primary()
	if Input.is_action_just_pressed("secondary_use"):
		equipment_controller.use_secondary()
	if Input.is_action_just_released("secondary_use"):
		equipment_controller.release_secondary()
	if Input.is_action_just_pressed("interact"):
		_interact()
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed

	var input_vector := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var move_direction := (transform.basis * Vector3(input_vector.x, 0.0, input_vector.y)).normalized()
	velocity.x = move_direction.x * move_speed
	velocity.z = move_direction.z * move_speed
	if not is_on_floor():
		velocity.y -= 14.0 * delta
	else:
		velocity.y = minf(velocity.y, 0.0)
	move_and_slide()

func get_interaction_target(max_range: float = 3.0) -> Node:
	if camera == null:
		return null
	var origin := camera.global_position
	var target := origin + -camera.global_transform.basis.z * max_range
	var query := PhysicsRayQueryParameters3D.create(origin, target)
	query.exclude = [self]
	var hit := get_world_3d().direct_space_state.intersect_ray(query)
	return hit.get("collider") as Node if not hit.is_empty() else null

func _interact() -> void:
	var target := get_interaction_target()
	if target != null and target.has_method("interact"):
		target.interact(self)
	else:
		message_changed.emit("Nothing to interact with")
