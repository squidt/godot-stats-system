class_name Effect extends Resource

## Targets one or more [Stat] within a [StatCard]
@export var name: StringName = &"effect"
## [StringName(StatPath), Alter]
@export var targets: Dictionary[StringName, Alter]
# Tracks whether or not this Effect contains any non-permanent changes, requiring it to be added to
# [StatCard._effects]
var _is_temporal := false


static func make(_name: String) -> Effect:
	var v := Effect.new()
	v.name = _name
	return v


func _init() -> void:
	resource_local_to_scene = true


## An alteration that is recorded and continously used in calculations until removed.
func is_persistent() -> bool:
	return targets.values().any(func(alt: Alter) -> bool: return alt.is_persistent())


## Add target to this Effect, [param rest] must be of type [Alter]
func add_target(path: StringName, alt: Alter) -> Effect:
	targets[path] = alt
	return self


func apply_to(card: StatCard) -> void:
	var is_this_persistent := false
	for path in targets.keys():
		var alt: Alter = targets.get(path)
		if alt and card.has_stat(path):
			if alt.is_persistent():
				is_this_persistent = true
			alt.apply_to(card.get_stat(path))

	# Only record this effect if at least one alteration was persistent
	if is_this_persistent:
		card._effects.append(self)


func remove_from(card: StatCard) -> void:
	for path in targets.keys():
		var alt: Alter = targets.get(path)
		if alt:
			card.if_has_stat(path, func(stat: Stat): alt.remove_from(stat))
	card._effects.erase(self)


## Checks if 'card' is valid before removing
func remove_from_checked(card: StatCard) -> void:
	if card:
		remove_from(card)


func erase_from(card: StatCard) -> void:
	card._effects.erase(self)


## Erase every instance of self in [param card]
func _erase_every_self(card: StatCard) -> void:
	for i in range(card._effects.count(self)):
		card._effects.erase(self)
