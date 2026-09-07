class_name NPC
extends StaticBody3D

@export var definition_id: StringName
@export var job_id: StringName = &""
@export var price_ids: Array[StringName] = []
var job: JobDefinition
var shop_prices: Array[PriceDefinition] = []
var stock: Inventory
var work_progress := 0.0

func setup(job_definition: JobDefinition, shared_stock: Inventory, prices: Array[PriceDefinition]) -> void:
	job = job_definition
	stock = shared_stock
	for price in prices:
		if price != null and price_ids.has(price.item_id):
			shop_prices.append(price)
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta: float) -> void:
	if job != null and stock != null:
		work_progress = JobSimulator.process(job, stock, delta, work_progress)

func interact(actor: Node) -> void:
	if stock == null:
		return
	var item_id := ShopService.buy(shop_prices, stock, actor)
	if item_id != &"":
		_emit_message(actor, "Bought %s" % item_id)
	elif not shop_prices.is_empty():
		_emit_message(actor, "Nothing affordable in stock")
	else:
		_emit_message(actor, "Working")

func _emit_message(actor: Node, text: String) -> void:
	if actor != null and actor.has_signal("message_changed"):
		actor.emit_signal("message_changed", text)
