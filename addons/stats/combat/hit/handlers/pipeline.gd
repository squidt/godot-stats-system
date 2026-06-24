class_name HitPipeline extends Resource

@export var handlers: Array[HitHandler] = []


## Returns remaining damage
func pipe(card: StatCard, target: String, damage: Damage) -> float:
	var hit_result := HitHandler.Result.make(card, target, damage)
	for h in handlers:
		h.handle(hit_result)

		# Aborted, no damage
		if hit_result.is_aborted:
			return 0.0

	return hit_result.remainder
