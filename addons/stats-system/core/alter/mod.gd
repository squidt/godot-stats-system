@abstract
class_name Mod extends Alter

## Lower value is a higher priority
@export var priority: int = 0

@abstract func modify(base: float, total: float) -> float


## An alteration that is recorded and continously used in calculations until removed.
func is_persistent() -> bool:
	return true


static func _sort_priority(a: Mod, b: Mod) -> bool:
	return a.priority < b.priority
