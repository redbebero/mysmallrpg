class_name ShopService
extends RefCounted

static func buy(prices: Array[PriceDefinition], stock: Inventory, buyer: Node) -> StringName:
	var wallet := buyer.get_node_or_null("Wallet") as Wallet
	var inventory := buyer.get_node_or_null("Inventory") as Inventory
	if wallet == null or inventory == null:
		return &""
	for offer in prices:
		if offer == null or not stock.has_item(offer.item_id) or not wallet.can_afford(offer.price):
			continue
		if wallet.spend(offer.price) and stock.remove_item(offer.item_id, 1):
			inventory.add_item(offer.item_id, 1)
			return offer.item_id
	return &""
