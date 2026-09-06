class_name GameDatabase
extends RefCounted

static func _load_resources(path: String) -> Array[Resource]:
	var result: Array[Resource] = []
	var directory := DirAccess.open(path)
	if directory == null:
		return result
	for filename in directory.get_files():
		if filename.ends_with(".tres"):
			var resource := load(path.path_join(filename))
			if resource is Resource:
				result.append(resource)
	return result

static func equipment() -> Array[EquipmentDefinition]:
	var result: Array[EquipmentDefinition] = []
	for resource in _load_resources("res://data/equipment"):
		if resource is EquipmentDefinition:
			result.append(resource)
	return result

static func enemies() -> Array[EnemyDefinition]:
	var result: Array[EnemyDefinition] = []
	for resource in _load_resources("res://data/enemies"):
		if resource is EnemyDefinition:
			result.append(resource)
	return result

static func progressions() -> Array[ProgressionDefinition]:
	var result: Array[ProgressionDefinition] = []
	for resource in _load_resources("res://data/progression"):
		if resource is ProgressionDefinition:
			result.append(resource)
	return result
