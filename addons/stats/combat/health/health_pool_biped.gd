class_name HealthPoolBiped extends HealthPool

@export var head := HealthPart.make_hpart(50.0).add_is_critical(true)
@export var torso := HealthPart.make_hpart(100.0).add_is_critical(true)
@export var arm_left := HealthPart.make_hpart(50.0).add_passthrough(50.0)
@export var arm_right := HealthPart.make_hpart(50.0).add_passthrough(75.0)
@export var leg_left := HealthPart.make_hpart(75.0).add_passthrough(75.0)
@export var leg_right := HealthPart.make_hpart(75.0).add_passthrough(75.0)


func _setup() -> void:
	var parts = get_parts()
	var pool_total: float = 0.0
	for p in parts:
		# Connect signals
		p.emptied.connect(_on_part_emptied, CONNECT_APPEND_SOURCE_OBJECT)
		p.passed.connect(_on_part_passed)

		# Calc Max
		pool_total += p.value_max.get_value()

	# Set pool total
	value_max.base = pool_total
	base = pool_total


func _to_string() -> String:
	var v: String = "HealthPool: (%s / %s)" % [get_value(), value_max.get_value()]
	var lamb := func(_name: String, _hpart: HealthPart) -> String:
		return "\n  %s (%s / %s)" % [_name, _hpart.get_value(), _hpart.value_max.get_value()]
	var names := get_parts_names()
	var parts := get_parts()
	for i in range(names.size()):
		v += lamb.call(names[i], parts[i])
	return v


func get_parts() -> Array[HealthPart]:
	return [head, torso, arm_left, arm_right, leg_left, leg_right]


func get_parts_names() -> Array[String]:
	return ["head", "torso", "arm_left", "arm_right", "leg_left", "leg_right"]


func _on_part_passed(damage: float) -> void:
	base -= damage


func _on_part_emptied(which: HealthPart) -> void:
	# Destroy main pool if critical part
	if which.is_critical:
		base = -1.0
		emptied.emit()
