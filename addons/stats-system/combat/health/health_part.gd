class_name HealthPart extends StatFill

signal passed(damage: float)

@export var is_critical := false
## Percentage of damage that passes through this part when the part's value [method is_empty()]
@export_custom(PROPERTY_HINT_RANGE, "0.0,100.0,1.0,suffix:%") var passthrough: float = 0.0


static func make_hpart(_max: float) -> HealthPart:
	var v := HealthPart.new()
	v.value_max.base = _max
	v.base = _max
	return v


func _init() -> void:
	super()
	value_changed.connect(_thing)

func _thing(delta):
	if is_empty():
		passed.emit(delta * passthrough / 100.0)

## Build pattern: Used for chaining optional functions after making a new HealthPart[br]
## i.e.[br]
## - HealthPart.make().add_is_critical(true)[br]
## - HealthPart.make().add_passthrough(100.0)[br]
func add_is_critical(_is_critical: bool) -> HealthPart:
	is_critical = _is_critical
	return self


## Build pattern: Used for chaining optional functions after making a new HealthPart[br]
## i.e.[br]
## - HealthPart.make().add_is_critical(true)[br]
## - HealthPart.make().add_passthrough(100.0)[br]
func add_passthrough(_passthrough: float) -> HealthPart:
	passthrough = _passthrough
	return self
