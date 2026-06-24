@abstract
class_name Alter extends Resource


static func make_array(first: Alter, ...rest) -> AlterArray:
	var v := AlterArray.new()
	v.alters.append(first)
	for r: Alter in rest:
		v.alters.append(r)
	return v


## An alteration that is recorded and continously used in calculations until removed.
@abstract func is_persistent() -> bool
@abstract func apply_to(stat: Stat) -> void
@abstract func remove_from(stat: Stat) -> void
