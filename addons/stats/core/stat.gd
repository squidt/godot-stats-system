class_name Stat extends StatPath

signal base_changed(delta: float)
signal value_changed(delta: float)

@export var base: float:
	set = _set_base

var _mods: Array[Mod] = []
var _value_cache := 0.0:
	set = _set_value_cache
var _is_value_cache_stale = true


static func make(value: float) -> Stat:
	var v := Stat.new()
	v.base = value
	return v


#region overrides


func _init() -> void:
	pass


func _setup() -> void:
	pass


#endregion

#region container funcs


func get_stat(path: String = "") -> Stat:
	if path.is_empty():
		return self

	var parts := Array(path.split("/", false))
	var current := get(parts.pop_front()) as Stat
	while current != null:
		if parts.is_empty():
			return current
		current = current.get(parts.pop_front())
	return null


## Alias for [method push]
func append(mod: Mod) -> void:
	push(mod)


## Alias for [method push_array]
func append_array(mods: Array[Mod]) -> void:
	push_array(mods)


## Calls Alter.apply_to passing [param self]
func apply(alt: Alter) -> void:
	alt.apply_to(self)


## Calls Alter.apply_to on each of [param alts] passing [param self]
func apply_array(alts: Array[Alter]) -> void:
	for alt in alts:
		alt.apply_to(self)


## Calls Alter.remove_from passing [param self]
func remove(alt: Alter) -> void:
	alt.remove_from(self)


## Cals Alter.remove_from on each of [param alts] passing [param self]
func remove_array(alts: Array[Alter]) -> void:
	for alt in alts:
		alt.remove_from(self)


## Add mod to _mods for get_value() calculations
func push(mod: Mod) -> void:
	_is_value_cache_stale = true
	_mods.append(mod)


## Add array of mods to _mods for get_value() calculations
func push_array(mods: Array[Mod]) -> void:
	for mod in mods:
		push(mod)


func erase(mod: Mod) -> void:
	_is_value_cache_stale = true
	_mods.erase(mod)


func erase_name(name: String) -> void:
	var idx = _mods.find_custom(func(mod): return "name" in mod and mod.name == name)
	if idx != -1:
		_is_value_cache_stale = true
		_mods.remove_at(idx)


## Erase any mod found in [param mods]. Calls Stat::Filter() internally. Does nothing if values
## are not found.
func erase_array(mods: Array[Mod]) -> void:
	filter(func(mod: Mod) -> bool: return !mods.has(mod))


## Erases all mods.
## WARNING: Causes desync with StatCard::_effects
func clear() -> void:
	_mods.clear()


## Calls [code]Array::filter(f)[/code] on the internal modifiers array where [param f]'s signature
## is [code]func(mod: Mod) -> bool[/code] that returns true if the value should be kept or false
## to remove it.
func filter(f: Callable) -> void:
	_is_value_cache_stale = true
	_mods = _mods.filter(f)


#endregion container funcs


func _update_value_cache() -> void:
	if _mods.is_empty():
		_value_cache = base
		return

	_mods.sort_custom(func(a: Mod, b: Mod) -> bool: return a.priority < b.priority)

	var total = base
	for mod: Mod in _mods:
		total = mod.modify(base, total)

	# Value changed
	if total != _value_cache:
		_value_cache = total
		value_changed.emit()


#region Setters


func get_value() -> float:
	if _is_value_cache_stale:
		_update_value_cache()
	return _value_cache


func _set_base(v: float) -> void:
	if is_equal_approx(base, v):
		return

	_is_value_cache_stale = true
	var dv := v - base
	base = v
	base_changed.emit(dv)
	_update_value_cache()


func _set_value_cache(v: float) -> void:
	# Return if no change
	var diff = v - _value_cache
	if is_zero_approx(diff):
		return

	_is_value_cache_stale = false
	_value_cache = v
	value_changed.emit(diff)

#endregion
