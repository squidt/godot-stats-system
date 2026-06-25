class_name Resists extends Stat

## Resistances cannot reduce damage below 10% of the original
const MAX_REDUCTION = 0.1

## Damage types targetted for resistace and a Mod representing that Resist
## Type = [ID, Target]
@export var types: Dictionary[Damage.Type, Stat]

# single Resist named id, dict [type, mods]


func get_stat(path: String = "") -> Stat:
	if path.is_empty():
		return null

	var parts := Array(path.split("/", false))
	var as_enum := Damage.string_to_type(parts.pop_front())
	var current := types.get_or_add(as_enum, Stat.make(0.0)) as StatPath
	while current != null:
		if parts.is_empty():
			return current
		current = current.get(parts.pop_front())
	return null


## Adds the modifier [param mod] to the damage type [param type]. When damage is applied, every
## mod is called in order of priority as [code]mod.modify(damage_value)[/code]. This means
## [constant ModOp.SUB] will reduce damage, and [constant ModOp.MUL] can be used to increase or
## decrease by a percentage.
func add(type: Damage.Type, mod: Mod) -> Resists:
	var resist: Stat = types.get_or_add(type, Stat.make(0.0))
	resist.append(mod)
	return self


func resisted(damage: Damage) -> float:
	var stat = types.get(damage.type)
	if !stat:
		return damage.value

	stat.base = damage.value
	var minimum = damage.value * MAX_REDUCTION
	return maxf(stat.get_value(), minimum)
