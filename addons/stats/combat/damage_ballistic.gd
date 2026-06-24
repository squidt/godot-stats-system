@tool
class_name DamageBallistic extends Damage

@export_group("Ballistic")
## Level of penetration, compared against [ArmorBallistic.]
@export var ap_level: float = 1.0
## Damage directed toward armor
@export var ap_damage: float = 1.0


static func make_ballistic(_value: float, _ap_level: float, _ap_damage: float) -> DamageBallistic:
	var v := DamageBallistic.new()
	v.value = _value
	v.ap_level = _ap_level
	v.ap_damage = _ap_damage
	return v


func _validate_property(property: Dictionary) -> void:
	if property.name == "type":
		set(property.name, Damage.Type.BALLISTIC)
		property.usage |= PROPERTY_USAGE_READ_ONLY


func _set(property: StringName, value: Variant) -> bool:
	# Prevent setting type
	if property == "type":
		return true
	# Otherwise, set normally
	return false
