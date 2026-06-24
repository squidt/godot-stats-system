@abstract
class_name Delta extends Alter

@abstract func change(stat: Stat) -> void


## An alteration that is recorded and continously used in calculations until removed.
func is_persistent() -> bool:
	return false


func apply_to(stat: Stat) -> void:
	change(stat)


## Has no effect with type [Delta]
func remove_from(stat: Stat) -> void:
	pass
