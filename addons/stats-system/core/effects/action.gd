class_name Action extends Resource

@export var effects: Array[Effect]
var from: Object


func add_effects(first: Effect, ...rest) -> Action:
	var temp: Array[Effect] = [first]
	for r: Effect in rest:
		temp.append(r)
	effects.append_array(temp)
	return self


func apply_to(card: StatCard) -> void:
	for e in effects:
		e.apply_to(card)


func remove_from(card: StatCard) -> void:
	for e in effects:
		e.remove_from(card)
