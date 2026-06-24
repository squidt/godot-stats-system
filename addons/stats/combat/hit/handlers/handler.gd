@abstract
class_name HitHandler extends Resource

## Return true to continue processing the hit
@abstract func handle(out: Result) -> void


class Result:
	static func make(_card: StatCard, _target: String, _damage: Damage) -> Result:
		var v := Result.new()
		v.card = _card
		v.target = _target
		v.damage = _damage
		v.remainder = _damage.value
		return v

	var card: StatCard
	var target: String
	var damage: Damage
	## Damage remainder. This value will start at delta.value and should be the value changed by
	## resistances.
	var remainder: float = 0.0
	## Is the hit aborted (i.e. dodged or blocked, causing no damage)
	var is_aborted: bool = false
