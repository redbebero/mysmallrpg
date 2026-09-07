class_name Wallet
extends Node

signal changed
@export var gold: int = 100

func can_afford(amount: int) -> bool:
	return amount >= 0 and gold >= amount

func spend(amount: int) -> bool:
	if not can_afford(amount):
		return false
	gold -= amount
	changed.emit()
	return true

func add(amount: int) -> void:
	gold = maxi(0, gold + amount)
	changed.emit()
