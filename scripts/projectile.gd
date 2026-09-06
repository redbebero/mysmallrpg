class_name Projectile
extends Area3D

var direction := Vector3.FORWARD
var speed := 18.0
var damage := 10.0
var lifetime := 3.0
var shooter: Node

func setup(flight_direction: Vector3, flight_speed: float, hit_damage: float, duration: float, owner_node: Node) -> void:
	direction = flight_direction.normalized()
	speed = flight_speed
	damage = hit_damage
	lifetime = duration
	shooter = owner_node
	var mesh := MeshInstance3D.new()
	var sphere := SphereMesh.new()
	sphere.radius = 0.12
	sphere.height = 0.24
	mesh.mesh = sphere
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(1.0, 0.2, 0.03)
	material.emission_enabled = true
	material.emission = Color(1.0, 0.05, 0.0)
	mesh.material_override = material
	add_child(mesh)
	var shape := CollisionShape3D.new()
	var sphere_shape := SphereShape3D.new()
	sphere_shape.radius = 0.12
	shape.shape = sphere_shape
	add_child(shape)

func _physics_process(delta: float) -> void:
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()
		return
	var next_position := global_position + direction * speed * delta
	var query := PhysicsRayQueryParameters3D.create(global_position, next_position)
	query.exclude = [self, shooter]
	var hit := get_world_3d().direct_space_state.intersect_ray(query)
	if not hit.is_empty():
		if hit.collider.has_method("take_damage"):
			hit.collider.take_damage(damage, shooter)
		queue_free()
		return
	global_position = next_position
