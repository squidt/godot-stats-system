class_name GearSlot extends Resource

@export var name: String
## StatPath this protects i.e. "health/head"
@export var protects: StringName
@export var require: String
@export var exclude: String
@export var gear: Gear


## Builder helper func: set [member name]
func named(_name: String) -> GearSlot:
	name = _name
	return self


## Builder helper func: set [member protects]
func protected(_stat_path: String) -> GearSlot:
	protects = _stat_path
	return self


## Builder helper func: set [member require]
func required(_require: String) -> GearSlot:
	require = _require
	return self


## Builder helper func: set [member exclude]
func excluded(_exclude: String) -> GearSlot:
	exclude = _exclude
	return self


func is_allowed(tags: String) -> bool:
	var split := tags.split(",", false)
	for tag in split:
		if exclude.contains(tag):
			return false
		if !require.contains(tag):
			return false
	return true
