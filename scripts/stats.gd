class_name Stats
extends Node

signal changed

@export var max_health: float = 100.0
@export var max_mana: float = 100.0
@export var mana_regeneration: float = 8.0
var health: float
var mana: float

func _ready() -> void:
	health = max_health
	mana = max_mana

func _process(delta: float) -> void:
	if mana < max_mana:
		mana = minf(max_mana, mana + mana_regeneration * delta)
		changed.emit()

func spend_mana(amount: float) -> bool:
	if mana < amount:
		return false
	mana -= amount
	changed.emit()
	return true

func take_damage(amount: float) -> void:
	health = maxf(0.0, health - amount)
	changed.emit()
