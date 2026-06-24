class_name EffectTarget extends Resource

@export var path: StringName = &""
@export var alts: Array[Alter] = []


## [param alterations] can be of either type [] or [Delta] otherwise it is discarded.
static func make(_path: StringName, _alts: Array[Alter]) -> EffectTarget:
	var v := EffectTarget.new()
	v.path = _path
	v.alts = _alts
	return v


## An alteration that is recorded and continously used in calculations until removed.
func is_persistent() -> bool:
	return alts.any(func(alt: Alter) -> bool: return alt.is_persistent())


func apply_to(card: StatCard) -> void:
	card.if_has_stat(
		path,
		func(stat: Stat):
			for v in alts:
				v.apply_to(stat)
	)
