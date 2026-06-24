class_name StatFill extends Stat

signal filled
signal emptied

@export var value_max := Stat.make(100.0)


## Override to mimic [method make_full]
static func make(value: float) -> Stat:
	var v := StatFill.new()
	v.value_max.base = value
	v.base = value
	return v


static func make_full(_max: float) -> StatFill:
	var v := StatFill.new()
	v.value_max.base = _max
	v.base = _max
	return v


func _to_string() -> String:
	return "StatFill(%.2f / %.2f)" % [get_value(), value_max.get_value()]


func _update_value_cache() -> void:
	if _mods.is_empty():
		_value_cache = base
		return

	_mods.sort_custom(func(a: Mod, b: Mod) -> bool: return a.priority < b.priority)

	var total = base
	for mod: Mod in _mods:
		total = mod.modify(base, total)

	# Value is changed
	_value_cache = total


func is_empty() -> bool:
	return is_equal_approx(get_value(), 0.0)


func is_full() -> bool:
	return is_equal_approx(get_value(), value_max.get_value())


func _set_base(v: float) -> void:
	v = clampf(v, 0.0, value_max.get_value())
	super(v)


## Handles clamping to max. Emits changed if [param v] != [member _value_cache]
func _set_value_cache(v: float) -> void:
	# Clamp to min/ max
	var v_max: float = value_max.get_value()
	v = clampf(v, 0.0, v_max)

	# Return if no change
	var diff = v - _value_cache
	if is_zero_approx(diff):
		return

	# Emit Signals
	_is_value_cache_stale = false
	_value_cache = v
	value_changed.emit(diff)
	if is_equal_approx(_value_cache, v_max):
		filled.emit()
	elif is_zero_approx(_value_cache):
		emptied.emit()
