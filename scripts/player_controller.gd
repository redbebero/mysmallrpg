class_name PlayerController
extends CharacterBody3D

signal message_changed(text: String)
@export var move_speed: float = 6.0
@export var jump_speed: float = 5.5
@export var mouse_sensitivity: float = 0.0025
var camera: Camera3D
var equipment_controller: EquipmentController
var action_executor: ActionExecutor
var blocking := false
var block_strength := 0.0
var block_action: ActionDefinition
var block_started := -10.0
var dodge_timer := 0.0
var dodge_velocity := Vector3.ZERO
var pitch := 0.0

func setup(equipment: EquipmentController, executor: ActionExecutor) -> void:
	equipment_controller = equipment
	action_executor = executor

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
	if Input.is_action_just_pressed("dodge"):
		_start_dodge()
	if Input.is_action_just_pressed("jump") and is_on_floor() and dodge_timer <= 0.0:
		velocity.y = jump_speed

	var input_vector := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var move_direction := (transform.basis * Vector3(input_vector.x, 0.0, input_vector.y)).normalized()
	if dodge_timer > 0.0:
		dodge_timer -= delta
		velocity.x = dodge_velocity.x
		velocity.z = dodge_velocity.z
	else:
		velocity.x = move_direction.x * move_speed
		velocity.z = move_direction.z * move_speed
	if not is_on_floor():
		velocity.y -= 14.0 * delta
	else:
		velocity.y = minf(velocity.y, 0.0)
	move_and_slide()

func _start_dodge() -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	if input_vector == Vector2.ZERO:
		if is_on_floor():
			velocity.y = jump_speed
		return
	var direction := (transform.basis * Vector3(input_vector.x, 0.0, input_vector.y)).normalized()
	dodge_velocity = direction * 13.0
	dodge_timer = 0.22

func perform_melee_hit(hit_range: float, damage: float) -> void:
	if camera == null:
		return
	var origin := camera.global_position
	var target := origin + -camera.global_transform.basis.z * hit_range
	var query := PhysicsRayQueryParameters3D.create(origin, target)
	query.exclude = [self]
	var hit := get_world_3d().direct_space_state.intersect_ray(query)
	if not hit.is_empty() and hit.collider.has_method("take_damage"):
		hit.collider.take_damage(damage, self)

func launch_projectile(damage: float, speed: float, lifetime: float) -> void:
	if camera == null:
		return
	var projectile := Projectile.new()
	get_parent().add_child(projectile)
	projectile.global_position = camera.global_position + -camera.global_transform.basis.z * 0.8
	projectile.setup(-camera.global_transform.basis.z, speed, damage, lifetime, self)

func set_blocking(value: bool, strength: float, action: ActionDefinition) -> void:
	blocking = value
	if value:
		block_strength = strength
		block_action = action
		block_started = Time.get_ticks_msec() / 1000.0
	else:
		block_strength = 0.0
		block_action = null

func receive_attack(damage: float, attacker: Node) -> void:
	var incoming: Vector3 = (attacker.global_position - global_position).normalized()
	var facing: Vector3 = -global_transform.basis.z
	var in_front := facing.dot(incoming) >= cos(deg_to_rad(block_action.block_angle_degrees * 0.5)) if block_action != null else false
	var now := Time.get_ticks_msec() / 1000.0
	var perfect := blocking and in_front and block_action != null and block_action.can_perfect_block(self) and now - block_started <= block_action.perfect_block_window
	if perfect:
		if attacker.has_method("stagger"):
			attacker.stagger(block_action.perfect_block_window + 0.5)
		message_changed.emit("PERFECT BLOCK!")
		return
	if blocking and in_front:
		damage *= maxf(0.0, 1.0 - block_strength)
		message_changed.emit("Blocked")
	var stats := get_node_or_null("Stats")
	if stats != null:
		stats.take_damage(damage)

func _interact() -> void:
	if camera == null:
		return
	var origin := camera.global_position
	var target := origin + -camera.global_transform.basis.z * 3.0
	var query := PhysicsRayQueryParameters3D.create(origin, target)
	query.exclude = [self]
	var hit := get_world_3d().direct_space_state.intersect_ray(query)
	message_changed.emit("Interacted" if not hit.is_empty() else "Nothing to interact with")

func change_mana(amount: float) -> void:
	var stats := get_node_or_null("Stats")
	if stats != null:
		stats.mana = clampf(stats.mana + amount, 0.0, stats.max_mana)
		stats.changed.emit()
