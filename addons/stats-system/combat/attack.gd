class_name Attack extends Resource

## This [Damage] is directed by [Hittable.hit()] to whichever stat [Hittable.target_path] points
## to. This allows [Hittable] to represent a physical object which [Attack] is targeting.
@export var damages: Array[Damage]
@export var effects: Array[Effect]
var name: String
var source: WeakRef


static func make() -> Attack:
	var v := Attack.new()
	return v


## Builder helper func: set [member name]
func named(_name: String) -> Attack:
	name = _name
	return self


## Builder helper func: set [member source]
func sourced(_source: Variant) -> Attack:
	source = weakref(_source)
	return self


## Builder helper func: set [member damages]
func add_damages(first: Damage, ...rest) -> Attack:
	damages.append(first)
	for r: Damage in rest:
		damages.append(r)
	return self


## Builder helper func: set [member effects]
func add_effects(first: Effect, ...rest) -> Attack:
	effects.append(first)
	for r: Effect in rest:
		effects.append(r)
	return self


func apply_to(card: StatCard) -> void:
	for e in effects:
		e.apply_to(card)


func remove_from(card: StatCard) -> void:
	for e in effects:
		e.remove_from(card)


## Returns the sum of all damage
func sum() -> float:
	return damages.reduce(func(acc: float, dmg: Damage): return acc + dmg.value, 0.0)
