class_name ActionExecutor
extends Node

signal action_used(equipment: EquipmentDefinition)
var cooldowns: Dictionary = {}

func _process(delta: float) -> void:
	for key in cooldowns.keys():
		cooldowns[key] = maxf(0.0, float(cooldowns[key]) - delta)

func execute(equipment: EquipmentDefinition, actor: Node, target: Node = null) -> bool:
	if equipment == null or equipment.action == null:
		return false
	var action := equipment.action
	if float(cooldowns.get(action.id, 0.0)) > 0.0 or not action.can_use(actor):
		return false
	if action.requires_target and target == null and actor.has_method("get_interaction_target"):
		target = actor.get_interaction_target(action.range)
	if action.requires_target and target == null:
		return false
	var stats := actor.get_node_or_null("Stats")
	if stats != null and not stats.spend_mana(action.mana_cost):
		return false
	cooldowns[action.id] = action.cooldown + action.windup + action.recovery_time
	var effect_actor := actor.get_node_or_null("CombatController")
	if effect_actor == null:
		effect_actor = actor
	for effect in action.effects:
		_apply_effect(effect, action, effect_actor, actor, target)
	action_used.emit(equipment)
	return true

func _apply_effect(effect: EffectDefinition, action: ActionDefinition, actor: Node, source: Node, target: Node) -> void:
	match effect.effect_type:
		"damage":
			if actor.has_method("perform_melee_hit"):
				actor.perform_melee_hit(action.range, effect.amount)
		"block":
			if actor.has_method("set_blocking"):
				actor.set_blocking(true, effect.amount, action)
		"projectile":
			if actor.has_method("launch_projectile"):
				actor.launch_projectile(effect.amount, effect.speed, effect.lifetime)
		"gather":
			if target != null and target.has_method("gather"):
				target.gather(source)
		"mana_change":
			if actor.has_method("change_mana"):
				actor.change_mana(effect.amount)
		"stagger":
			if actor.has_method("stagger_target"):
				actor.stagger_target(effect.duration)
		"status":
			# Status payloads are tags for future status definitions.
			pass

func end_held(actor: Node) -> void:
	var effect_actor := actor.get_node_or_null("CombatController")
	if effect_actor == null:
		effect_actor = actor
	if effect_actor.has_method("set_blocking"):
		effect_actor.set_blocking(false, 0.0, null)
