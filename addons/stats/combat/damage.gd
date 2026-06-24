class_name Damage extends Resource

enum Type {
	NONE = 0,
	IMPACT = 1,
	SLASH = 2,
	PIERCE = 3,
	BLEED = 4,
	BALLISTIC = 5,
	EXPLOSIVE = 6,
}

@export var type: Type = Damage.Type.NONE
@export var value: float = 0.0


## Case insensitive
static func string_to_type(string: String) -> Damage.Type:
	var found := Damage.Type.keys().find(string.to_upper())
	if found > -1:
		return found as Damage.Type
	return Damage.Type.NONE


static func type_to_string(_type: Damage.Type) -> String:
	return Damage.Type.keys()[_type].to_lower()


static func make_dmg(ty: Type, val: float) -> Damage:
	var v = Damage.new()
	v.type = ty
	v.value = val
	return v


func _init() -> void:
	resource_local_to_scene = true


func this_type_to_string() -> String:
	return Damage.type_to_string(type)
