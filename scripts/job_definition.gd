class_name JobDefinition
extends Resource

@export var id: StringName
@export var display_name: String = "Job"
@export var inputs: Array[CostDefinition] = []
@export var outputs: Array[RewardDefinition] = []
@export var required_conditions: Array[ConditionDefinition] = []
@export var rewards: Array[RewardDefinition] = []
@export var work_time: float = 20.0

func can_run(worker: Node) -> bool:
	for condition in required_conditions:
		if condition != null and not condition.is_met(worker):
			return false
	for input in inputs:
		if input != null and not input.can_pay(worker):
			return false
	return true

func run(worker: Node) -> bool:
	if not can_run(worker):
		return false
	for input in inputs:
		if input != null and not input.pay(worker):
			return false
	var grants: Array[RewardDefinition] = []
	grants.append_array(outputs)
	grants.append_array(rewards)
	RewardExecutor.execute(grants, worker)
	return true
