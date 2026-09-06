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

static func progression() -> ProgressionDefinition:
	var definition := ProgressionDefinition.new()
	definition.mastery_name = &"fight"
	definition.starting_level = 0
	definition.unlocks = {&"perfect_block": 1, &"combo_system": 2, &"perfect_dodge": 3}
	return definition
