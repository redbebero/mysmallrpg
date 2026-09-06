class_name Enemy
extends CharacterBody3D

@export var definition_id: StringName = &"enemy"
@export var enemy_id: StringName = &"enemy"
@export var display_name: String = "Enemy"
@export var max_health: float = 50.0
@export var move_speed: float = 2.2
@export var detection_range: float = 14.0
var health := 50.0
var target: PlayerController
var attacks: Array[EnemyAttackDefinition] = []
var state := "approach"
var state_time := 0.0
var attack_index := 0
var current_attack: EnemyAttackDefinition
var stagger_time := 0.0
var body_mesh: MeshInstance3D
var normal_color := Color.WHITE

func setup(player: PlayerController, definition: EnemyDefinition) -> void:
	target = player
	if definition == null:
		return
	enemy_id = definition.id
	display_name = definition.display_name
	max_health = definition.max_health
	move_speed = definition.move_speed
	attacks = definition.attacks
	health = max_health
	body_mesh = get_node_or_null("Body")
	if body_mesh != null and body_mesh.material_override is StandardMaterial3D:
		var material := body_mesh.material_override as StandardMaterial3D
		material.albedo_color = definition.display_color
		normal_color = definition.display_color

func _physics_process(delta: float) -> void:
	if target == null or not is_instance_valid(target):
		return
	if stagger_time > 0.0:
		stagger_time -= delta
		velocity = Vector3.ZERO
		move_and_slide()
		return
	state_time += delta
	match state:
		"approach":
			_approach()
		"windup":
			velocity = Vector3.ZERO
			if state_time >= current_attack.windup:
				state = "active"
				state_time = 0.0
				set_warning(false)
				target.receive_attack(current_attack.damage, self)
		"active":
			velocity = Vector3.ZERO
			if state_time >= current_attack.active_time:
				state = "recovery"
				state_time = 0.0
		"recovery":
			velocity = Vector3.ZERO
			if state_time >= current_attack.recovery:
				state = "approach"
				state_time = 0.0
	move_and_slide()

func _approach() -> void:
	var to_player := target.global_position - global_position
	to_player.y = 0.0
	var distance := to_player.length()
	if distance > current_range():
		velocity = to_player.normalized() * move_speed
		look_at(global_position + to_player, Vector3.UP)
	else:
		velocity = Vector3.ZERO
		if not attacks.is_empty():
			current_attack = attacks[attack_index % attacks.size()]
			attack_index += 1
			state = "windup"
			state_time = 0.0
			set_warning(true)

func current_range() -> float:
	if attacks.is_empty():
		return 1.5
	var closest := attacks[0].range
	for attack in attacks:
		closest = minf(closest, attack.range)
	return closest

func set_warning(active: bool) -> void:
	if body_mesh == null or not body_mesh.material_override is StandardMaterial3D:
		return
	var material := body_mesh.material_override as StandardMaterial3D
	material.albedo_color = Color(1.0, 0.18, 0.05) if active else normal_color

func take_damage(amount: float, _attacker: Node = null) -> void:
	health = maxf(0.0, health - amount)
	if health <= 0.0:
		var progression := target.get_node_or_null("Progression") if target != null else null
		if progression != null:
			progression.add_fight_mastery(1)
		queue_free()

func stagger(duration: float) -> void:
	stagger_time = maxf(stagger_time, duration)
	state = "approach"
	state_time = 0.0
	set_warning(false)
