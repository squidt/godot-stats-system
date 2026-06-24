class_name ArmorBallisticPool extends Stat

# Type: [String(health: Stat to protect), ArmorBallistic(armor to use to prevent hit)]
@export var parts: Dictionary[String, ArmorBallistic]


func _to_string() -> String:
	return parts.values().reduce(func(acc: String, e: ArmorBallistic): return acc + e.to_string(), "pool: ")


func get_stat(path: String = "") -> Stat:
	if path.is_empty():
		return null

	var path_segments := Array(path.split("/", false))
	var current := parts.get(path_segments.pop_front(), null) as StatRoute
	while current != null:
		if path_segments.is_empty():
			return current
		current = current.get(path_segments.pop_front())
	return null


func add(health_path: String, armor: ArmorBallistic) -> ArmorBallisticPool:
	parts[health_path] = armor
	return self


func try_armor(out: HitHandler.Result) -> void:
	var armor = parts.get(out.target)
	if armor:
		armor.resisted(out)
