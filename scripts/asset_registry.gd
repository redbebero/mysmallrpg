class_name AssetRegistry
extends RefCounted

const MANIFEST_PATH := "res://assets/registry/manifest.json"
static var _manifest: Dictionary = {}

static func initialize(path: String = MANIFEST_PATH) -> void:
	_manifest.clear()
	if not FileAccess.file_exists(path):
		push_warning("Asset registry is missing: " + path)
		return
	var parsed = JSON.parse_string(FileAccess.get_file_as_string(path))
	if parsed is Dictionary:
		_manifest = parsed

static func has_asset(asset_id: StringName) -> bool:
	return _manifest.get("assets", {}).has(String(asset_id))

static func get_definition(asset_id: StringName) -> Dictionary:
	return _manifest.get("assets", {}).get(String(asset_id), {})

static func get_model_path(asset_id: StringName) -> String:
	return str(get_definition(asset_id).get("model", ""))

static func require_model(asset_id: StringName) -> Resource:
	var path := get_model_path(asset_id)
	if path.is_empty():
		push_error("Unknown or model-less asset id: " + String(asset_id))
		return null
	return load(path)
