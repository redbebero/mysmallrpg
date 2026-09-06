class_name CombatController
extends Node

var actor: Node
var camera: Camera3D
var blocking := false
var block_strength := 0.0
var block_action: ActionDefinition
var block_started := -10.0

func setup(actor_node: Node, camera_node: Camera3D) -> void:
	actor = actor_node
	camera = camera_node

func perform_melee_hit(hit_range: float, damage: float) -> void:
	if camera == null:
		return
	var origin := camera.global_position
	var target := origin + -camera.global_transform.basis.z * hit_range
	var query := PhysicsRayQueryParameters3D.create(origin, target)
	query.exclude = [actor]
	var hit: Dictionary = actor.get_world_3d().direct_space_state.intersect_ray(query)
	if not hit.is_empty() and hit.collider.has_method("take_damage"):
		hit.collider.take_damage(damage, actor)

func launch_projectile(damage: float, speed: float, lifetime: float) -> void:
	if camera == null:
		return
	var projectile := Projectile.new()
	actor.get_parent().add_child(projectile)
	projectile.global_position = camera.global_position + -camera.global_transform.basis.z * 0.8
	projectile.setup(-camera.global_transform.basis.z, speed, damage, lifetime, actor)

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
	var incoming: Vector3 = (attacker.global_position - actor.global_position).normalized()
	var facing: Vector3 = -actor.global_transform.basis.z
	var in_front := facing.dot(incoming) >= cos(deg_to_rad(block_action.block_angle_degrees * 0.5)) if block_action != null else false
	var now := Time.get_ticks_msec() / 1000.0
	var perfect := blocking and in_front and block_action != null and block_action.can_perfect_block(actor) and now - block_started <= block_action.perfect_block_window
	if perfect:
		if attacker.has_method("stagger"):
			attacker.stagger(block_action.perfect_block_window + 0.5)
		_emit_message("PERFECT BLOCK!")
		return
	if blocking and in_front:
		damage *= maxf(0.0, 1.0 - block_strength)
		_emit_message("Blocked")
	var stats := actor.get_node_or_null("Stats")
	if stats != null:
		stats.take_damage(damage)

func change_mana(amount: float) -> void:
	var stats := actor.get_node_or_null("Stats")
	if stats != null:
		stats.mana = clampf(stats.mana + amount, 0.0, stats.max_mana)
		stats.changed.emit()

func _emit_message(text: String) -> void:
	if actor != null and actor.has_signal("message_changed"):
		actor.emit_signal("message_changed", text)
