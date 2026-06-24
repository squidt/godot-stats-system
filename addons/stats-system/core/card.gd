class_name StatCard extends Node

signal update(delta: float)

const COMPONENT_NAME = "StatCard"

var _effects: Array[Effect]

#region static functions


## Returns true if [param node] is a [StatCard]
static func is_card(node: Node) -> bool:
	return node.has_meta(COMPONENT_NAME)


## Returns [param node] as a [StatCard] if it is one, or null.
static func as_card(node: Node) -> StatCard:
	return node.get_meta(COMPONENT_NAME) as StatCard


## Call [param if_callable] with [param node] as the only argument and return the result. The
## function is only called if [param node] is a [StatCard].
static func if_is_card(node: Node, if_callable: Callable) -> Variant:
	if is_card(node) and if_callable.is_valid() and if_callable.get_argument_count() == 1:
		return if_callable.call(as_card(node))
	return null


static func if_is_card_apply_effect(node: Node, effect: Effect) -> void:
	if_is_card(node, func(card: StatCard): card.apply(effect))


static func if_is_card_remove_effect(node: Node, effect: Effect) -> void:
	if_is_card(node, func(card: StatCard): card.remove(effect))


static func if_is_card_erase(node: Node, effect: Effect) -> void:
	if_is_card(node, func(c: StatCard): c.remove(effect))


#endregion static functions


func _ready() -> void:
	get_parent().set_meta(COMPONENT_NAME, self)
	_setup_stats()


func _physics_process(delta: float) -> void:
	update.emit(delta)


#region checks


func has_stat(path: String) -> bool:
	return is_instance_valid(get_stat(path))


func has_effect(effect: Effect) -> bool:
	return _effects.has(effect)


func has_effect_name(_name: StringName) -> bool:
	return _effects.find_custom(_find_name.bind(_name))


## Call [param if_callable] with the found [param stat_name] as the only argument and return the
## result. The function is only called if [param node] is a [StatCard] and has [param stat_name]
func if_has_stat(stat_name: StringName, if_callable: Callable) -> Variant:
	var stat := get_stat(stat_name)
	if stat and if_callable.is_valid() and if_callable.get_argument_count() == 1:
		return if_callable.call(stat)
	return null


func if_has_stat_or_default(
	stat_name: StringName, if_callable: Callable, default: Variant = null
) -> Variant:
	var result = if_has_stat(stat_name, if_callable)
	if result:
		return result
	return default


#endregion checks


## Removes all effects
func clear_effects() -> void:
	for e in _effects:
		e.remove_from(self)


func apply(effect: Effect) -> void:
	effect.apply_to(self)


func remove(effect: Effect) -> void:
	effect.remove_from(self)


func remove_effect_name(effect_name: String) -> void:
	var found: Array[Effect] = _effects.reduce(
		func(acc: Array[Effect], e: Effect):
			if e.name == effect_name:
				acc.append(e)
			return acc
	)
	for v in found:
		_effects.erase(v)


func get_stat(path: String) -> Stat:
	if path.is_empty():
		return null

	var parts := Array(path.split("/", false))
	var current := get(parts.pop_front()) as StatRoute
	while current != null:
		# Found leaf, return as Stat
		if parts.is_empty():
			return current as Stat
		current = current.get_stat(parts.pop_front())
	return null


func _find_name(_e: Effect, _name: StringName) -> bool:
	return _e.name == _name


func _filter_name(_e: Effect, _name: StringName) -> bool:
	return _e.name != _name


func _filter_effect(element: Effect, searchee: Effect) -> bool:
	return element != searchee


func _filter_stopped(_e: EffectTimeout) -> bool:
	return _e.timer.is_stopped() if _e.timer else false


func _setup_stats() -> void:
	for property in get_property_list():
		if get(property.name) is Stat:
			get(property.name)._setup()
