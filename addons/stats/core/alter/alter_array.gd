class_name AlterArray extends Alter

@export var alters: Array[Alter]


func is_persistent() -> bool:
	return alters.any(func(alt: Alter) -> bool: return alt.is_persistent())


func apply_to(stat: Stat) -> void:
	for alt in alters:
		alt.apply_to(stat)


func remove_from(stat: Stat) -> void:
	for alt in alters:
		alt.remove_from(stat)
