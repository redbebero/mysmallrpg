class_name ProgressionDefinition
extends Resource

@export var id: StringName
@export var mastery_name: StringName
@export var display_name: String = "Mastery"
@export var starting_level: int = 0
@export var unlocks: Array[UnlockDefinition] = []
