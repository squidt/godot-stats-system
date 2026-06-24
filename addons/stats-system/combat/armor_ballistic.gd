class_name ArmorBallistic extends Stat

## Ballistic Armor only applies to ballistic damage and determines if the damage is fully blocked
## or passes through. Each hit will damage the armor according to the relevant exported variables.

const PEN_NONE = 0.0  ## Pen must be below this value
const PEN_UNDER = -0.5  ## Anything above this value is under penetration
const PEN_FULL = -1.0  ## Anything above this value is full penetration
const PEN_OVER = -2.0  ## Anything below this value is over penetration

## Armor level to prevent penetration
@export var level := Stat.make(0.0)
## Multiplier for [DamageBallistic.ap_damage] absorbed by the armor on penetration
@export var ap_damage_pen_multi := Stat.make(1.0)
## Multiplier for [DamageBallistic.ap_damage] absorbed by the armor on stoppage/ non-penetration
@export var ap_damage_stop_multi := Stat.make(1.0)
## Durability of the armor. Combined with [Degradation] to calculate the remaining effective armor level
@export var durability := StatFill.make_full(100.0)
@export var degradation: Curve


func _to_string() -> String:
	return (
		"lvl(%.2f) | ap_pen_multi(%.2f) | ap_stop_multi(%.2f) | durability(%.2f) | effective(%.2f)"
		% [
			level,
			ap_damage_pen_multi,
			ap_damage_stop_multi,
			durability.get_value(),
			get_effective_level()
		]
	)


## Safety: gurantee [out.damage] is of type DamageBallistic before calling
func resist(out: HitHandler.Result) -> void:
	var damage = out.damage as DamageBallistic
	# Stopped by armor
	var pen_diff = get_penetration(damage)
	if pen_diff < PEN_NONE:
		durability.base -= damage.ap_damage * ap_damage_stop_multi
		out.remainder = 0.0
		out.is_aborted = true
	# Penetration
	else:
		durability.base -= damage.ap_damage * ap_damage_pen_multi
		out.remainder *= get_damage_factor(pen_diff)


func get_penetration(damage: DamageBallistic) -> float:
	return get_effective_level() - damage.ap_level


## Higher [param pen_diff] values equal more penetration
func get_damage_factor(pen_diff: float) -> float:
	if pen_diff <= PEN_NONE:
		return 0.0
	elif pen_diff <= PEN_UNDER:
		return 0.5
	elif pen_diff <= PEN_FULL:
		return 1.0
	elif pen_diff > PEN_OVER:
		return 1.5
	return 1.0


func get_effective_level() -> float:
	if degradation:
		var x: float = maxf(0.0, 1.0 - (durability.get_value() / durability.value_max.get_value()))
		var factor: float = degradation.sample_baked(x)
		return level.get_value() * factor
	return level.get_value()
