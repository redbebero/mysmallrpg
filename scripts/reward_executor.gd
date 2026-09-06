class_name RewardExecutor
extends RefCounted

static func execute(rewards: Array[RewardDefinition], recipient: Node) -> void:
	for reward in rewards:
		if reward == null:
			continue
		match reward.reward_type:
			"mastery":
				var progression := recipient.get_node_or_null("Progression")
				if progression != null and progression.has_method("add_mastery"):
					progression.add_mastery(reward.target_id, reward.amount)
			"item":
				var inventory := recipient.get_node_or_null("Inventory")
				if inventory != null and inventory.has_method("add_item"):
					inventory.add_item(reward.target_id, reward.amount)
