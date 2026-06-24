class_name Equipment extends Node

const COMPONENT_NAME = &"Equipment"


static func is_equipment(node: Node) -> bool:
	return node.has_meta(COMPONENT_NAME)


static func as_equipment(node: Node) -> Equipment:
	return node.get_meta(COMPONENT_NAME) as Equipment


func get_card():
	return StatCard.as_card(get_parent())


func get_gear(path: String) -> void:
	pass


func _ready() -> void:
	assert(is_instance_valid(get_parent()), "Must have parent")
	assert(StatCard.is_card(get_parent()), "Parent must have component 'StatCard'")
	get_parent().set_meta(COMPONENT_NAME, self)


func equip(gear: Gear) -> void:
	pass


func unequip(gear: Gear) -> void:
	pass
