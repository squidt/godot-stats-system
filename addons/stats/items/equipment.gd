class_name Equipment extends Node

const COMPONENT_NAME = &"Equipment"


static func is_equipment(node: Node) -> bool:
	return node.has_meta(COMPONENT_NAME)


static func as_equipment(node: Node) -> Equipment:
	return node.get_meta(COMPONENT_NAME) as Equipment


func get_card():
	return StatCard.as_card(get_parent())


func get_slot(path: String) -> GearSlot:
	if path.is_empty():
		return null

	var path_seg := Array(path.split("/", false))
	var current := get(path_seg.pop_front()) as GearSlot
	while current != null:
		if path_seg.is_empty():
			return current
		current = current.get(path_seg.pop_front())
	return null


func _ready() -> void:
	assert(is_instance_valid(get_parent()), "Must have parent")
	get_parent().set_meta(COMPONENT_NAME, self)
	await get_parent().ready
	assert(StatCard.is_card(get_parent()), "Parent must have component 'StatCard'")


func equip(slot_path: StringName, gear: Gear) -> void:
	var slot := get_slot(slot_path)
	if slot and slot.is_allowed(gear.tags):
		slot.gear = gear
		gear.action.apply_to(get_card())


func unequip(slot_path: StringName) -> void:
	var slot := get_slot(slot_path)
	if slot and slot.gear:
		slot.gear.action.remove_from(get_card())
		slot.gear = null
